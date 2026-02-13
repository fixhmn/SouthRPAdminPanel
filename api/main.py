import json
import os
import secrets
import time
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timedelta, timezone
from typing import Any

import aiomysql
from fastapi import Body, Depends, FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

from auth import (
    ALLOWED_ROLES,
    AdminContext,
    KNOWN_PERMISSIONS,
    ensure_rbac_schema,
    require_admin,
    require_permission,
)
from db import get_pool
from items_catalog import get_items_catalog, resolve_item_image, resolve_item_label
from jobs_gangs_catalog import get_gangs_catalog, get_jobs_catalog
from utils import license_tail

UTC = timezone.utc

JOIN_ON_LICENSE_TAIL = (
    "SUBSTRING_INDEX(p.license, ':', -1) = SUBSTRING_INDEX(s.license, ':', -1)"
)

app = FastAPI(title="South Admin API")

DISCORD_CLIENT_ID = os.getenv("DISCORD_CLIENT_ID", "").strip()
DISCORD_CLIENT_SECRET = os.getenv("DISCORD_CLIENT_SECRET", "").strip()
DISCORD_REDIRECT_URI = os.getenv("DISCORD_REDIRECT_URI", "").strip()
DISCORD_BOT_TOKEN = os.getenv("DISCORD_BOT_TOKEN", "").strip()
DISCORD_GUILD_ID = int(os.getenv("DISCORD_GUILD_ID", "861905224469708821"))

DISCORD_ROLE_HELPER = int(os.getenv("DISCORD_ROLE_HELPER", "862255288979030016"))
DISCORD_ROLE_MODERATOR = int(os.getenv("DISCORD_ROLE_MODERATOR", "893230820326801490"))
DISCORD_ROLE_ADMINISTRATOR = int(os.getenv("DISCORD_ROLE_ADMINISTRATOR", "861906053519900692"))

WEB_BASE_URL = os.getenv("WEB_BASE_URL", "http://localhost:3000").rstrip("/")
BRIDGE_URL = os.getenv("BRIDGE_URL", "http://127.0.0.1:30120/south_webbridge/execute").strip()
BRIDGE_TOKEN = os.getenv("BRIDGE_TOKEN", "").strip()

_oauth_login_codes: dict[str, tuple[str, float]] = {}

_raw_cors = os.getenv("CORS_ORIGINS", "http://localhost:3000")
_cors_origins = [x.strip() for x in _raw_cors.split(",") if x.strip()]
if not _cors_origins:
    _cors_origins = ["http://localhost:3000"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=_cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

IMAGES_DIR = os.getenv("ITEMS_IMAGES_DIR", "").strip()
IMAGES_ROUTE = os.getenv("ITEMS_IMAGES_ROUTE", "/items-images").strip() or "/items-images"
IMAGES_URL_PREFIX = os.getenv("ITEMS_IMAGES_URL_PREFIX", "http://localhost:8000/items-images").rstrip("/")

if IMAGES_DIR and os.path.isdir(IMAGES_DIR):
    app.mount(IMAGES_ROUTE, StaticFiles(directory=IMAGES_DIR), name="items-images")


class RoleReplaceBody(BaseModel):
    permissions: list[str] = Field(default_factory=list)


class AdminCreateBody(BaseModel):
    login: str = Field(min_length=3, max_length=64)
    token: str = Field(min_length=8, max_length=128)
    role_name: str = Field(min_length=3, max_length=64)
    is_active: bool = True


class AdminPatchBody(BaseModel):
    token: str | None = Field(default=None, min_length=8, max_length=128)
    role_name: str | None = Field(default=None, min_length=3, max_length=64)
    is_active: bool | None = None


class DiscordAssignBody(BaseModel):
    discord_id: str = Field(min_length=5, max_length=24)
    login: str | None = Field(default=None, min_length=3, max_length=64)
    role_name: str = Field(min_length=3, max_length=64)
    is_active: bool = True


class WlBulkBody(BaseModel):
    static_ids: list[int] = Field(default_factory=list)


class PlayerProfilePatchBody(BaseModel):
    firstname: str | None = Field(default=None, min_length=1, max_length=48)
    lastname: str | None = Field(default=None, min_length=1, max_length=48)
    phone: str | None = Field(default=None, min_length=1, max_length=32)
    birthdate: str | None = Field(default=None, min_length=4, max_length=16)
    nationality: str | None = Field(default=None, min_length=1, max_length=48)


class VehiclePatchBody(BaseModel):
    plate: str | None = Field(default=None, min_length=1, max_length=16)
    fakeplate: str | None = Field(default=None, max_length=16)
    garage_id: str | None = Field(default=None, max_length=64)
    garage: str | None = Field(default=None, max_length=64)
    nickname: str | None = Field(default=None, max_length=64)
    state: int | None = None
    parking: int | None = None
    impound: int | None = None
    in_garage: int | None = None
    lock: int | None = None


class GameActionVariableBody(BaseModel):
    key: str = Field(min_length=1, max_length=64)
    label: str | None = Field(default=None, max_length=128)
    value_type: str = Field(default="string", pattern="^(string|number|boolean)$")
    required: bool = True
    default_value: str | None = Field(default=None, max_length=256)


class GameActionTemplateCreateBody(BaseModel):
    name: str = Field(min_length=2, max_length=96)
    description: str | None = Field(default=None, max_length=512)
    action_type: str = Field(pattern="^(export|server_event|qbx_set_job|qbx_set_gang)$")
    resource_name: str | None = Field(default=None, max_length=64)
    action_name: str = Field(min_length=1, max_length=128)
    variables: list[GameActionVariableBody] = Field(default_factory=list)
    allowed_roles: list[str] = Field(default_factory=list)
    is_active: bool = True


class GameActionTemplatePatchBody(BaseModel):
    name: str | None = Field(default=None, min_length=2, max_length=96)
    description: str | None = Field(default=None, max_length=512)
    action_type: str | None = Field(default=None, pattern="^(export|server_event|qbx_set_job|qbx_set_gang)$")
    resource_name: str | None = Field(default=None, max_length=64)
    action_name: str | None = Field(default=None, min_length=1, max_length=128)
    variables: list[GameActionVariableBody] | None = None
    allowed_roles: list[str] | None = None
    is_active: bool | None = None


class GameActionExecuteBody(BaseModel):
    template_id: int = Field(ge=1)
    values: dict[str, Any] = Field(default_factory=dict)


class ItemDebugBody(BaseModel):
    item: str = Field(min_length=1, max_length=128)
    amount: int = Field(default=1, ge=1, le=1000000)


class KickBody(BaseModel):
    reason: str | None = Field(default=None, max_length=256)


def _charinfo_to_dict(charinfo):
    if isinstance(charinfo, str):
        try:
            return json.loads(charinfo)
        except Exception:
            return {}
    return charinfo or {}


def _safe_json(v):
    try:
        return json.loads(v) if isinstance(v, str) else (v or {})
    except Exception:
        return {}


def _build_item_image_url(image_value: str | None) -> str | None:
    if not image_value:
        return None
    image_value = image_value.strip()
    if not image_value:
        return None

    if image_value.startswith(("http://", "https://", "nui://", "data:")):
        return image_value

    filename = image_value.lstrip("/").replace("\\", "/")
    return f"{IMAGES_URL_PREFIX}/{filename}"


def _normalize_inventory_like(raw_value):
    parsed = raw_value
    if isinstance(raw_value, str):
        parsed = _safe_json(raw_value)
    if not isinstance(parsed, list):
        return []

    out = []
    for row in parsed:
        if not isinstance(row, dict):
            continue

        item_name = row.get("name") or row.get("item")
        resolved_label = row.get("label") or resolve_item_label(str(item_name) if item_name else None)
        resolved_image = row.get("image") or resolve_item_image(str(item_name) if item_name else None)

        obj = dict(row)
        if resolved_label:
            obj["resolved_label"] = resolved_label
        obj["resolved_image"] = resolved_image
        obj["resolved_image_url"] = _build_item_image_url(str(resolved_image) if resolved_image else None)
        out.append(obj)

    return out


def _normalize_item_key(v: str | None) -> str:
    return (v or "").strip().lower()


def _normalize_search_text(v: str | None) -> str:
    return (v or "").strip().lower()


def _sorted_grade_items(raw_grades: Any) -> list[dict[str, Any]]:
    out: list[dict[str, Any]] = []
    if not isinstance(raw_grades, list):
        return out
    for row in raw_grades:
        if not isinstance(row, dict):
            continue
        try:
            grade_num = int(row.get("grade"))
        except Exception:
            continue
        grade_name = str(row.get("name") or grade_num)
        out.append({"grade": grade_num, "name": grade_name})
    out.sort(key=lambda x: x["grade"])
    return out


def _clean_template_variables(variables: list[GameActionVariableBody] | None) -> list[dict[str, Any]]:
    out: list[dict[str, Any]] = []
    seen: set[str] = set()
    for var in variables or []:
        key = var.key.strip()
        if not key:
            continue
        if key in seen:
            raise HTTPException(400, f"Duplicate variable key: {key}")
        seen.add(key)
        out.append(
            {
                "key": key,
                "label": (var.label or key).strip()[:128],
                "value_type": var.value_type,
                "required": bool(var.required),
                "default_value": var.default_value,
            }
        )
    return out


def _clean_template_roles(roles: list[str] | None) -> list[str]:
    out: list[str] = []
    seen: set[str] = set()
    for role in roles or []:
        role_name = (role or "").strip().lower()
        if not role_name:
            continue
        if role_name not in ALLOWED_ROLES:
            raise HTTPException(400, f"Unknown role: {role_name}")
        if role_name in seen:
            continue
        seen.add(role_name)
        out.append(role_name)
    return out


def _convert_variable_value(raw_value: Any, value_type: str) -> Any:
    if value_type == "number":
        if raw_value is None or raw_value == "":
            return None
        try:
            if isinstance(raw_value, str) and "." in raw_value:
                return float(raw_value)
            return int(raw_value)
        except Exception:
            raise HTTPException(400, f"Expected number, got: {raw_value}")
    if value_type == "boolean":
        if isinstance(raw_value, bool):
            return raw_value
        sval = str(raw_value).strip().lower()
        if sval in {"1", "true", "yes", "on"}:
            return True
        if sval in {"0", "false", "no", "off"}:
            return False
        raise HTTPException(400, f"Expected boolean, got: {raw_value}")
    if raw_value is None:
        return ""
    if isinstance(raw_value, str):
        return raw_value.strip()
    return str(raw_value)


async def _ensure_game_actions_table(pool):
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                CREATE TABLE IF NOT EXISTS web_game_action_templates (
                    id BIGINT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(96) NOT NULL,
                    description TEXT NULL,
                    action_type VARCHAR(32) NOT NULL,
                    resource_name VARCHAR(64) NULL,
                    action_name VARCHAR(128) NOT NULL,
                    variables_json JSON NOT NULL,
                    allowed_roles_json JSON NULL,
                    is_active TINYINT(1) NOT NULL DEFAULT 1,
                    created_at DATETIME NOT NULL,
                    updated_at DATETIME NOT NULL
                )
                """
            )
            await cur.execute("SHOW COLUMNS FROM web_game_action_templates LIKE 'allowed_roles_json'")
            has_allowed_roles = await cur.fetchone()
            if not has_allowed_roles:
                await cur.execute(
                    "ALTER TABLE web_game_action_templates ADD COLUMN allowed_roles_json JSON NULL AFTER variables_json"
                )


def _post_bridge_execute(payload: dict[str, Any]) -> dict[str, Any]:
    if not BRIDGE_URL:
        raise HTTPException(500, "BRIDGE_URL is not configured")
    if not BRIDGE_TOKEN:
        raise HTTPException(500, "BRIDGE_TOKEN is not configured")

    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(BRIDGE_URL, data=data, method="POST")
    req.add_header("Content-Type", "application/json")
    req.add_header("Accept", "application/json")
    req.add_header("X-Bridge-Token", BRIDGE_TOKEN)
    req.add_header("User-Agent", "SouthRPAdminBridge/1.0")
    try:
        with urllib.request.urlopen(req, timeout=8) as resp:
            raw = resp.read().decode("utf-8")
        return json.loads(raw) if raw else {"ok": True}
    except urllib.error.HTTPError as e:
        try:
            detail = e.read().decode("utf-8", errors="ignore")
        except Exception:
            detail = ""
        raise HTTPException(502, f"Bridge HTTP {e.code}: {detail or 'error'}")
    except Exception as e:
        raise HTTPException(502, f"Bridge unavailable: {e}")


def _bridge_url_with_path(path_suffix: str) -> str:
    base = BRIDGE_URL.rsplit("/", 1)[0]
    return f"{base}/{path_suffix.lstrip('/')}"


def _post_bridge_status(payload: dict[str, Any]) -> dict[str, Any]:
    if not BRIDGE_URL:
        raise HTTPException(500, "BRIDGE_URL is not configured")
    if not BRIDGE_TOKEN:
        raise HTTPException(500, "BRIDGE_TOKEN is not configured")

    status_url = _bridge_url_with_path("status")
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(status_url, data=data, method="POST")
    req.add_header("Content-Type", "application/json")
    req.add_header("Accept", "application/json")
    req.add_header("X-Bridge-Token", BRIDGE_TOKEN)
    req.add_header("User-Agent", "SouthRPAdminBridge/1.0")
    try:
        with urllib.request.urlopen(req, timeout=8) as resp:
            raw = resp.read().decode("utf-8")
        return json.loads(raw) if raw else {"ok": False, "online": False}
    except urllib.error.HTTPError as e:
        try:
            detail = e.read().decode("utf-8", errors="ignore")
        except Exception:
            detail = ""
        raise HTTPException(502, f"Bridge HTTP {e.code}: {detail or 'error'}")
    except Exception as e:
        raise HTTPException(502, f"Bridge unavailable: {e}")


def _post_bridge_online_list(payload: dict[str, Any] | None = None) -> dict[str, Any]:
    if not BRIDGE_URL:
        raise HTTPException(500, "BRIDGE_URL is not configured")
    if not BRIDGE_TOKEN:
        raise HTTPException(500, "BRIDGE_TOKEN is not configured")

    url = _bridge_url_with_path("online-list")
    data = json.dumps(payload or {}).encode("utf-8")
    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Content-Type", "application/json")
    req.add_header("Accept", "application/json")
    req.add_header("X-Bridge-Token", BRIDGE_TOKEN)
    req.add_header("User-Agent", "SouthRPAdminBridge/1.0")
    try:
        with urllib.request.urlopen(req, timeout=8) as resp:
            raw = resp.read().decode("utf-8")
        return json.loads(raw) if raw else {"ok": True, "items": []}
    except urllib.error.HTTPError as e:
        try:
            detail = e.read().decode("utf-8", errors="ignore")
        except Exception:
            detail = ""
        raise HTTPException(502, f"Bridge HTTP {e.code}: {detail or 'error'}")
    except Exception as e:
        raise HTTPException(502, f"Bridge unavailable: {e}")


async def _get_player_bridge_context(pool, citizenid: str) -> dict[str, Any]:
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                f"""
                SELECT p.citizenid, p.license, p.name, s.static_id, s.discord_id
                FROM players p
                LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                WHERE p.citizenid = %s
                LIMIT 1
                """,
                (citizenid,),
            )
            p = await cur.fetchone()
            if not p:
                raise HTTPException(404, "Player not found")

    return {
        "citizenid": p.get("citizenid"),
        "static_id": p.get("static_id"),
        "license": p.get("license"),
        "discord_id": p.get("discord_id"),
        "name": p.get("name"),
    }


def _kick_reason(raw_reason: str | None, fallback: str) -> str:
    reason = (raw_reason or "").strip()
    return reason[:256] if reason else fallback


async def _enrich_rows_with_static_id_by_license_tails(pool, rows: list[dict[str, Any]]) -> None:
    if not rows:
        return

    missing_rows: list[dict[str, Any]] = [r for r in rows if r.get("static_id") is None]
    if not missing_rows:
        return

    def _extract_user_id(row: dict[str, Any]) -> int | None:
        for key in ("userId", "userid", "UserID", "user_id"):
            raw = row.get(key)
            if raw is None or raw == "":
                continue
            try:
                return int(raw)
            except Exception:
                continue
        return None

    def _collect_tails(row: dict[str, Any]) -> list[str]:
        out: list[str] = []
        for raw in (row.get("license"), row.get("license2")):
            tail = license_tail(raw)
            if tail:
                out.append(tail)
        return out

    def _load_tail_to_static_map(tails_to_query: set[str]) -> dict[str, int]:
        if not tails_to_query:
            return {}
        placeholders = ",".join(["%s"] * len(tails_to_query))
        tail_to_static: dict[str, int] = {}
        # small local async helper inside function scope
        async def _query() -> None:
            async with pool.acquire() as conn:
                async with conn.cursor(aiomysql.DictCursor) as cur:
                    await cur.execute(
                        f"""
                        SELECT static_id, SUBSTRING_INDEX(license, ':', -1) AS license_tail
                        FROM static_ids
                        WHERE SUBSTRING_INDEX(license, ':', -1) IN ({placeholders})
                        """,
                        tuple(sorted(tails_to_query)),
                    )
                    static_rows = await cur.fetchall()
            for row in static_rows:
                tail = str(row.get("license_tail") or "").strip()
                static_val = row.get("static_id")
                if not tail or static_val is None or tail in tail_to_static:
                    continue
                try:
                    tail_to_static[tail] = int(static_val)
                except Exception:
                    continue
        # run inner async block
        # ruff: noqa: F821 (runtime-defined in closure)
        return _query, tail_to_static

    tails: set[str] = set()
    for row in missing_rows:
        for tail in _collect_tails(row):
            tails.add(tail)

    tail_to_static: dict[str, int] = {}
    if tails:
        _query, _map = _load_tail_to_static_map(tails)
        await _query()
        tail_to_static.update(_map)

    for row in missing_rows:
        for t in _collect_tails(row):
            if not t:
                continue
            resolved = tail_to_static.get(t)
            if resolved is not None:
                row["static_id"] = resolved
                break

    still_missing: list[dict[str, Any]] = [r for r in missing_rows if r.get("static_id") is None]
    if not still_missing:
        return

    user_ids: set[int] = set()
    for row in still_missing:
        uid = _extract_user_id(row)
        if uid is not None:
            user_ids.add(uid)
    if not user_ids:
        return

    placeholders = ",".join(["%s"] * len(user_ids))
    users_by_id: dict[int, dict[str, Any]] = {}
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                f"""
                SELECT userId, license, license2
                FROM users
                WHERE userId IN ({placeholders})
                """,
                tuple(sorted(user_ids)),
            )
            users_rows = await cur.fetchall()

    for row in users_rows:
        try:
            uid = int(row.get("userId"))
            users_by_id[uid] = row
        except Exception:
            continue

    extra_tails: set[str] = set()
    for row in still_missing:
        uid = _extract_user_id(row)
        u = users_by_id.get(uid) if uid is not None else None
        if not u:
            continue
        for tail in (license_tail(u.get("license")), license_tail(u.get("license2"))):
            if tail and tail not in tail_to_static:
                extra_tails.add(tail)

    if extra_tails:
        _query2, _map2 = _load_tail_to_static_map(extra_tails)
        await _query2()
        tail_to_static.update(_map2)

    for row in still_missing:
        uid = _extract_user_id(row)
        u = users_by_id.get(uid) if uid is not None else None
        if not u:
            continue
        for tail in (license_tail(u.get("license")), license_tail(u.get("license2"))):
            if not tail:
                continue
            resolved = tail_to_static.get(tail)
            if resolved is not None:
                row["static_id"] = resolved
                break


async def _drop_player_if_online(pool, citizenid: str, reason: str, admin: AdminContext) -> dict[str, Any]:
    player_ctx = await _get_player_bridge_context(pool, citizenid)
    try:
        status = _post_bridge_status({"player": player_ctx})
    except HTTPException as e:
        return {
            "attempted": False,
            "dropped": False,
            "online": None,
            "source": None,
            "error": str(e.detail),
        }

    source_id = status.get("source")
    if not bool(status.get("online")) or source_id is None:
        return {"attempted": False, "dropped": False, "online": False, "source": None}

    payload = {
        "template": {
            "id": 0,
            "name": "drop_player",
            "action_type": "drop_player",
            "action_name": "DropPlayer",
        },
        "player": {**player_ctx, "source": source_id, "targetId": source_id, "target_id": source_id},
        "values": {"targetId": source_id, "reason": reason},
        "args": [source_id, reason],
        "requested_by": {"admin_id": admin.admin_id, "login": admin.login},
    }
    try:
        bridge = _post_bridge_execute(payload)
        return {"attempted": True, "dropped": True, "online": True, "source": source_id, "bridge": bridge}
    except HTTPException as e:
        return {
            "attempted": True,
            "dropped": False,
            "online": True,
            "source": source_id,
            "error": str(e.detail),
        }


async def _drop_static_if_online(static_id: int, reason: str, admin: AdminContext) -> dict[str, Any]:
    try:
        status = _post_bridge_status({"player": {"static_id": static_id}})
    except HTTPException as e:
        return {
            "attempted": False,
            "dropped": False,
            "online": None,
            "source": None,
            "error": str(e.detail),
        }

    source_id = status.get("source")
    if not bool(status.get("online")) or source_id is None:
        return {"attempted": False, "dropped": False, "online": False, "source": None}

    payload = {
        "template": {
            "id": 0,
            "name": "drop_player",
            "action_type": "drop_player",
            "action_name": "DropPlayer",
        },
        "player": {"static_id": static_id, "source": source_id, "targetId": source_id, "target_id": source_id},
        "values": {"targetId": source_id, "reason": reason},
        "args": [source_id, reason],
        "requested_by": {"admin_id": admin.admin_id, "login": admin.login},
    }
    try:
        bridge = _post_bridge_execute(payload)
        return {"attempted": True, "dropped": True, "online": True, "source": source_id, "bridge": bridge}
    except HTTPException as e:
        return {
            "attempted": True,
            "dropped": False,
            "online": True,
            "source": source_id,
            "error": str(e.detail),
        }


async def _audit(pool, admin_tag: str, action: str, target: dict, payload: dict | None = None):
    payload = payload or {}
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                CREATE TABLE IF NOT EXISTS audit_logs (
                    id BIGINT AUTO_INCREMENT PRIMARY KEY,
                    ts DATETIME NOT NULL,
                    admin_tag VARCHAR(64) NOT NULL,
                    action VARCHAR(64) NOT NULL,
                    target_json JSON NOT NULL,
                    payload_json JSON NOT NULL
                )
                """
            )
            await cur.execute(
                "INSERT INTO audit_logs (ts, admin_tag, action, target_json, payload_json) VALUES (%s,%s,%s,%s,%s)",
                (
                    datetime.now(UTC).replace(tzinfo=None),
                    admin_tag,
                    action,
                    json.dumps(target),
                    json.dumps(payload),
                ),
            )


async def _ensure_audit_table(pool):
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                CREATE TABLE IF NOT EXISTS audit_logs (
                    id BIGINT AUTO_INCREMENT PRIMARY KEY,
                    ts DATETIME NOT NULL,
                    admin_tag VARCHAR(64) NOT NULL,
                    action VARCHAR(64) NOT NULL,
                    target_json JSON NOT NULL,
                    payload_json JSON NOT NULL
                )
                """
            )


@app.on_event("startup")
async def _startup():
    await ensure_rbac_schema()
    pool = await get_pool()
    await _ensure_game_actions_table(pool)


@app.get("/health")
async def health():
    return {"ok": True}


@app.get("/auth/me")
async def auth_me(admin: AdminContext = Depends(require_admin)):
    return {
        "id": admin.admin_id,
        "login": admin.login,
        "role": admin.role_name,
        "permissions": sorted(admin.permissions),
    }


def _discord_oauth_url(state: str) -> str:
    params = {
        "client_id": DISCORD_CLIENT_ID,
        "redirect_uri": DISCORD_REDIRECT_URI,
        "response_type": "code",
        "scope": "identify",
        "state": state,
    }
    return "https://discord.com/api/oauth2/authorize?" + urllib.parse.urlencode(params)


def _post_form(url: str, data: dict[str, str]) -> dict:
    body = urllib.parse.urlencode(data).encode("utf-8")
    req = urllib.request.Request(url, data=body, method="POST")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")
    req.add_header("Accept", "application/json")
    req.add_header("User-Agent", "SouthRPAdmin/1.0 (+https://southrp.local)")
    with urllib.request.urlopen(req, timeout=20) as resp:
        raw = resp.read().decode("utf-8")
    return json.loads(raw)


def _get_json(url: str, headers: dict[str, str]) -> dict:
    req = urllib.request.Request(url, method="GET")
    req.add_header("Accept", "application/json")
    req.add_header("User-Agent", "SouthRPAdmin/1.0 (+https://southrp.local)")
    for k, v in headers.items():
        req.add_header(k, v)
    with urllib.request.urlopen(req, timeout=20) as resp:
        raw = resp.read().decode("utf-8")
    return json.loads(raw)


async def _generate_unique_token(pool) -> str:
    for _ in range(8):
        token = secrets.token_urlsafe(42)
        async with pool.acquire() as conn:
            async with conn.cursor() as cur:
                await cur.execute("SELECT id FROM web_admins WHERE token=%s LIMIT 1", (token,))
                if not await cur.fetchone():
                    return token
    raise HTTPException(500, "Failed to generate token")


def _role_from_discord_roles(role_ids: list[int]) -> str | None:
    role_set = set(role_ids)
    if DISCORD_ROLE_ADMINISTRATOR in role_set:
        return "administrator"
    if DISCORD_ROLE_MODERATOR in role_set:
        return "moderator"
    if DISCORD_ROLE_HELPER in role_set:
        return "helper"
    return None


@app.get("/auth/discord/url")
async def auth_discord_url():
    if not DISCORD_CLIENT_ID or not DISCORD_REDIRECT_URI:
        raise HTTPException(500, "Discord OAuth is not configured")
    state = secrets.token_urlsafe(20)
    return {"url": _discord_oauth_url(state)}


@app.get("/auth/discord/callback")
async def auth_discord_callback(code: str | None = None, error: str | None = None, state: str | None = None):
    del state
    if error:
        return RedirectResponse(f"{WEB_BASE_URL}/?discord_error={urllib.parse.quote(error)}", status_code=302)
    if not code:
        return RedirectResponse(f"{WEB_BASE_URL}/?discord_error=no_code", status_code=302)
    if not DISCORD_CLIENT_ID or not DISCORD_CLIENT_SECRET or not DISCORD_REDIRECT_URI:
        return RedirectResponse(f"{WEB_BASE_URL}/?discord_error=oauth_not_configured", status_code=302)

    try:
        token_data = _post_form(
            "https://discord.com/api/oauth2/token",
            {
                "client_id": DISCORD_CLIENT_ID,
                "client_secret": DISCORD_CLIENT_SECRET,
                "grant_type": "authorization_code",
                "code": code,
                "redirect_uri": DISCORD_REDIRECT_URI,
            },
        )
        access_token = str(token_data.get("access_token") or "")
        if not access_token:
            raise ValueError("No access_token")

        user = _get_json(
            "https://discord.com/api/users/@me",
            {"Authorization": f"Bearer {access_token}"},
        )
        discord_id = int(user.get("id"))
        pool = await get_pool()
        auth_token = await _generate_unique_token(pool)
        now = datetime.now(UTC).replace(tzinfo=None)

        async with pool.acquire() as conn:
            async with conn.cursor() as cur:
                await cur.execute(
                    "SELECT id, role_name, is_active FROM web_admins WHERE discord_id=%s LIMIT 1",
                    (discord_id,),
                )
                existing = await cur.fetchone()
                if not existing:
                    return RedirectResponse(f"{WEB_BASE_URL}/?discord_error=no_allowed_role", status_code=302)

                role_name = str(existing[1] or "").strip().lower()
                is_active = int(existing[2] or 0)
                if not role_name or not is_active:
                    return RedirectResponse(f"{WEB_BASE_URL}/?discord_error=no_allowed_role", status_code=302)

                login = f"discord_{discord_id}"
                await cur.execute(
                    """
                    UPDATE web_admins
                    SET login=%s, token=%s, updated_at=%s
                    WHERE discord_id=%s
                    """,
                    (login, auth_token, now, discord_id),
                )

        short_code = secrets.token_urlsafe(24)
        _oauth_login_codes[short_code] = (auth_token, time.time() + 120.0)
        return RedirectResponse(f"{WEB_BASE_URL}/?discord_code={urllib.parse.quote(short_code)}", status_code=302)
    except urllib.error.HTTPError as e:
        detail = ""
        try:
            detail = e.read().decode("utf-8", errors="ignore")
        except Exception:
            detail = ""
        print(f"[DISCORD_OAUTH_HTTP_ERROR] status={e.code} detail={detail}")

        err_code = f"oauth_http_{e.code}"
        low = detail.lower()
        if "invalid_client" in low:
            err_code = "invalid_client"
        elif "invalid_grant" in low:
            err_code = "invalid_grant"
        elif "unknown member" in low or "10007" in low:
            err_code = "member_not_found"
        elif "missing access" in low or "50001" in low:
            err_code = "missing_access"
        elif "unauthorized" in low or "401" in low:
            err_code = "unauthorized"
        elif "40333" in low or "internal network error" in low:
            err_code = "cloudflare_blocked"
        return RedirectResponse(f"{WEB_BASE_URL}/?discord_error={urllib.parse.quote(err_code)}", status_code=302)
    except Exception as e:
        print(f"[DISCORD_OAUTH_ERROR] {type(e).__name__}: {e}")
        return RedirectResponse(
            f"{WEB_BASE_URL}/?discord_error={urllib.parse.quote(type(e).__name__)}",
            status_code=302,
        )


@app.get("/auth/discord/exchange")
async def auth_discord_exchange(code: str = Query(..., min_length=10, max_length=128)):
    now_ts = time.time()
    expired = [k for k, (_, exp) in _oauth_login_codes.items() if exp < now_ts]
    for k in expired:
        _oauth_login_codes.pop(k, None)

    val = _oauth_login_codes.pop(code, None)
    if not val:
        raise HTTPException(400, "Invalid or expired login code")
    token, exp = val
    if exp < now_ts:
        raise HTTPException(400, "Expired login code")
    return {"token": token}


@app.get("/players/search")
async def players_search(
    field: str = Query(
        ...,
        pattern="^(license|static_id|name|citizenid|firstname|lastname|fullname|discord_id|phone)$",
    ),
    q: str = Query("", max_length=128),
    limit: int = Query(20, ge=1, le=50),
    admin: AdminContext = Depends(require_permission("players.read")),
):
    pool = await get_pool()
    online_items: list[dict[str, Any]] = []
    try:
        online_payload = _post_bridge_online_list({})
        raw_online = online_payload.get("items")
        if isinstance(raw_online, list):
            online_items = [x for x in raw_online if isinstance(x, dict)]
    except HTTPException:
        online_items = []

    online_by_citizen: dict[str, dict[str, Any]] = {}
    online_by_static: dict[int, dict[str, Any]] = {}
    missing_static_citizens: list[str] = []
    for row in online_items:
        online_citizen = str(row.get("citizenid") or "").strip()
        if online_citizen:
            online_by_citizen[online_citizen] = row
        static_val = row.get("static_id")
        try:
            if static_val is not None:
                online_by_static[int(static_val)] = row
            elif online_citizen:
                missing_static_citizens.append(online_citizen)
        except Exception:
            if online_citizen:
                missing_static_citizens.append(online_citizen)

    # Fallback: enrich bridge online rows with static_id from DB by citizenid.
    if missing_static_citizens:
        uniq_missing = sorted(set(x for x in missing_static_citizens if x))
        if uniq_missing:
            placeholders = ",".join(["%s"] * len(uniq_missing))
            async with pool.acquire() as conn:
                async with conn.cursor(aiomysql.DictCursor) as cur:
                    await cur.execute(
                        f"""
                        SELECT p.citizenid, s.static_id
                        FROM players p
                        LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                        WHERE p.citizenid IN ({placeholders})
                        """,
                        tuple(uniq_missing),
                    )
                    static_rows = await cur.fetchall()
            for row in static_rows:
                citizen_key = str(row.get("citizenid") or "").strip()
                static_val = row.get("static_id")
                if not citizen_key or static_val is None:
                    continue
                online_row = online_by_citizen.get(citizen_key)
                if not online_row:
                    continue
                try:
                    static_num = int(static_val)
                    online_row["static_id"] = static_num
                    online_by_static[static_num] = online_row
                except Exception:
                    continue

    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            players = []

            if field == "discord_id":
                if not q.isdigit():
                    raise HTTPException(400, "q must be discord_id digits")
                await cur.execute(
                    f"""
                    SELECT p.*, s.static_id, s.discord_id
                    FROM players p
                    LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                    WHERE s.discord_id = %s
                    LIMIT %s
                """,
                    (int(q), limit),
                )
                players = await cur.fetchall()

            elif field in ["license", "name", "citizenid"]:
                if field == "license":
                    tail = license_tail(q)
                    if not tail:
                        raise HTTPException(400, "Empty license")
                    await cur.execute(
                        f"""
                        SELECT p.*, s.static_id, s.discord_id
                        FROM players p
                        LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                        WHERE SUBSTRING_INDEX(p.license, ':', -1) LIKE %s
                        LIMIT %s
                    """,
                        (f"%{tail}%", limit),
                    )
                else:
                    await cur.execute(
                        f"""
                        SELECT p.*, s.static_id, s.discord_id
                        FROM players p
                        LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                        WHERE p.{field} LIKE %s
                        LIMIT %s
                    """,
                        (f"%{q}%", limit),
                    )
                players = await cur.fetchall()

            elif field == "static_id":
                await cur.execute(
                    f"""
                    SELECT p.*, s.static_id, s.discord_id
                    FROM players p
                    LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                    WHERE s.static_id = %s
                    LIMIT %s
                """,
                    (q, limit),
                )
                players = await cur.fetchall()

            else:
                await cur.execute(
                    f"""
                    SELECT p.*, s.static_id, s.discord_id
                    FROM players p
                    LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                    LIMIT 2000
                """
                )
                all_players = await cur.fetchall()

                ql = q.lower().strip()
                for row in all_players:
                    ci = _charinfo_to_dict(row.get("charinfo"))
                    if field == "phone":
                        if q and q in str(ci.get("phone", "")):
                            players.append(row)
                    elif field in ["firstname", "lastname"]:
                        if ql and ql in str(ci.get(field, "")).lower():
                            players.append(row)
                    elif field == "fullname":
                        parts = ql.split()
                        if len(parts) >= 2:
                            fn = str(ci.get("firstname", "")).lower()
                            ln = str(ci.get("lastname", "")).lower()
                            if parts[0] in fn and parts[1] in ln:
                                players.append(row)

                    if len(players) >= limit:
                        break

    await _enrich_rows_with_static_id_by_license_tails(pool, players)

    out = []
    for p in players[:limit]:
        ci = _charinfo_to_dict(p.get("charinfo"))
        citizen = str(p.get("citizenid") or "")
        static_id_val = p.get("static_id")
        same_online = online_by_citizen.get(citizen)
        online_current_citizenid = citizen if same_online else None
        online_source = same_online.get("source") if same_online else None
        if not same_online:
            try:
                if static_id_val is not None:
                    by_static = online_by_static.get(int(static_id_val))
                    if by_static:
                        online_current_citizenid = str(by_static.get("citizenid") or "") or None
                        online_source = by_static.get("source")
            except Exception:
                pass

        out.append(
            {
                "citizenid": citizen,
                "name": p.get("name"),
                "static_id": p.get("static_id"),
                "discord_id": p.get("discord_id"),
                "firstname": ci.get("firstname"),
                "lastname": ci.get("lastname"),
                "phone": ci.get("phone"),
                "online": bool(same_online),
                "online_source": online_source,
                "online_citizenid": online_current_citizenid,
            }
        )

    return {
        "count": len(out),
        "items": out,
        "admin": {"login": admin.login, "role": admin.role_name},
    }


@app.get("/players/online")
async def players_online(
    limit: int = Query(100, ge=1, le=500),
    admin: AdminContext = Depends(require_permission("players.read")),
):
    bridge = _post_bridge_online_list({})
    raw_items = bridge.get("items")
    if not isinstance(raw_items, list):
        raw_items = []

    online_items: list[dict[str, Any]] = []
    online_citizenids: list[str] = []
    for row in raw_items:
        if not isinstance(row, dict):
            continue
        citizenid = str(row.get("citizenid") or "").strip()
        if not citizenid:
            continue
        online_citizenids.append(citizenid)
        online_items.append(
            {
                "citizenid": citizenid,
                "name": row.get("name"),
                "static_id": row.get("static_id"),
                "discord_id": row.get("discord_id"),
                "firstname": row.get("firstname"),
                "lastname": row.get("lastname"),
                "phone": row.get("phone"),
                "job": row.get("job"),
                "gang": row.get("gang"),
                "source": row.get("source"),
            }
        )
        if len(online_items) >= limit:
            break

    # Fallback static_id from DB when bridge could not resolve it for a player.
    if online_citizenids:
        placeholders = ",".join(["%s"] * len(online_citizenids))
        pool = await get_pool()
        db_static_by_citizen: dict[str, int] = {}
        player_rows: list[dict[str, Any]] = []
        async with pool.acquire() as conn:
            async with conn.cursor(aiomysql.DictCursor) as cur:
                await cur.execute(
                    f"""
                    SELECT p.*, s.static_id
                    FROM players p
                    LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                    WHERE p.citizenid IN ({placeholders})
                    """,
                    tuple(online_citizenids),
                )
                player_rows = await cur.fetchall()

        await _enrich_rows_with_static_id_by_license_tails(pool, player_rows)
        for row in player_rows:
            try:
                citizen = str(row.get("citizenid") or "").strip()
                static_val = row.get("static_id")
                if citizen and static_val is not None:
                    db_static_by_citizen[citizen] = int(static_val)
            except Exception:
                continue

        for item in online_items:
            if item.get("static_id") is None:
                fallback_static = db_static_by_citizen.get(str(item.get("citizenid") or ""))
                if fallback_static is not None:
                    item["static_id"] = fallback_static

    return {
        "count": len(online_items),
        "items": online_items,
        "admin": {"login": admin.login, "role": admin.role_name},
    }


@app.get("/players/{citizenid}")
async def player_get(
    citizenid: str,
    admin: AdminContext = Depends(require_permission("players.read")),
):
    pool = await get_pool()
    current_slots = 1
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                f"""
                SELECT p.*, s.static_id, s.discord_id, s.whitelisted, s.ban, s.ban_until
                FROM players p
                LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                WHERE p.citizenid = %s
                LIMIT 1
            """,
                (citizenid,),
            )
            p = await cur.fetchone()
            if not p:
                raise HTTPException(404, "Player not found")

            await cur.execute(
                """
                SELECT id, vehicle, plate, fakeplate, garage_id, state, nickname
                FROM player_vehicles
                WHERE citizenid = %s
                ORDER BY id DESC
                """,
                (citizenid,),
            )
            vehicles = await cur.fetchall()

            player_license_tail = license_tail(p.get("license"))
            if player_license_tail:
                await cur.execute(
                    "SELECT max_slots FROM player_slots WHERE SUBSTRING_INDEX(license, ':', -1)=%s LIMIT 1",
                    (player_license_tail,),
                )
                slot_row = await cur.fetchone()
                if slot_row and slot_row.get("max_slots") is not None:
                    try:
                        current_slots = int(slot_row.get("max_slots"))
                    except Exception:
                        current_slots = 1

    ci = _charinfo_to_dict(p.get("charinfo"))
    inv = []
    try:
        inv = json.loads(p.get("inventory") or "[]")
    except Exception:
        inv = []

    normalized_inventory = []
    for row in inv:
        if not isinstance(row, dict):
            normalized_inventory.append(row)
            continue

        item_name = row.get("name") or row.get("item")
        resolved_label = row.get("label") or resolve_item_label(str(item_name) if item_name else None)
        resolved_image = row.get("image") or resolve_item_image(str(item_name) if item_name else None)

        item_obj = dict(row)
        if resolved_label:
            item_obj["resolved_label"] = resolved_label
        item_obj["resolved_image"] = resolved_image
        item_obj["resolved_image_url"] = _build_item_image_url(str(resolved_image) if resolved_image else None)
        normalized_inventory.append(item_obj)

    resolved_static_id = p.get("static_id")
    if resolved_static_id is None:
        await _enrich_rows_with_static_id_by_license_tails(pool, [p])
        resolved_static_id = p.get("static_id")
    if resolved_static_id is None:
        try:
            online_payload = _post_bridge_online_list({})
            raw_online = online_payload.get("items")
            if isinstance(raw_online, list):
                for row in raw_online:
                    if not isinstance(row, dict):
                        continue
                    if str(row.get("citizenid") or "").strip() != citizenid:
                        continue
                    static_val = row.get("static_id")
                    if static_val is not None:
                        try:
                            resolved_static_id = int(static_val)
                        except Exception:
                            resolved_static_id = static_val
                    break
        except HTTPException:
            pass

    return {
        "citizenid": p.get("citizenid"),
        "license": p.get("license"),
        "name": p.get("name"),
        "static_id": resolved_static_id,
        "discord_id": p.get("discord_id"),
        "slots_current": current_slots,
        "wl": bool(p.get("whitelisted") or 0),
        "ban": bool(p.get("ban") or 0),
        "ban_until": str(p.get("ban_until")) if p.get("ban_until") else None,
        "charinfo": ci,
        "job": _safe_json(p.get("job")),
        "gang": _safe_json(p.get("gang")),
        "money": _safe_json(p.get("money")),
        "inventory": normalized_inventory,
        "vehicles": vehicles,
        "permissions": sorted(admin.permissions),
    }


@app.get("/players/static/{static_id}")
async def player_static_get(
    static_id: int,
    admin: AdminContext = Depends(require_permission("players.read")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                """
                SELECT static_id, license, discord_id, whitelisted, ban, ban_until
                FROM static_ids
                WHERE static_id = %s
                LIMIT 1
                """,
                (static_id,),
            )
            s = await cur.fetchone()
            if not s:
                raise HTTPException(404, "static_id not found")

            await cur.execute(
                f"""
                SELECT p.citizenid, p.name, p.license, p.charinfo
                FROM players p
                WHERE SUBSTRING_INDEX(p.license, ':', -1) = SUBSTRING_INDEX(%s, ':', -1)
                ORDER BY p.citizenid DESC
                LIMIT 1
                """,
                (s.get("license"),),
            )
            p = await cur.fetchone()

    linked_character = None
    if p:
        ci = _charinfo_to_dict(p.get("charinfo"))
        linked_character = {
            "citizenid": p.get("citizenid"),
            "name": p.get("name"),
            "license": p.get("license"),
            "firstname": ci.get("firstname"),
            "lastname": ci.get("lastname"),
        }

    return {
        "static_id": int(s.get("static_id")),
        "license": s.get("license"),
        "discord_id": s.get("discord_id"),
        "wl": bool(s.get("whitelisted") or 0),
        "ban": bool(s.get("ban") or 0),
        "ban_until": str(s.get("ban_until")) if s.get("ban_until") else None,
        "linked_character": linked_character,
    }


@app.post("/players/static/{static_id}/actions/addwl")
async def addwl_static(
    static_id: int,
    admin: AdminContext = Depends(require_permission("players.manage_wl")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute("UPDATE static_ids SET whitelisted=1 WHERE static_id=%s", (static_id,))
            if cur.rowcount == 0:
                raise HTTPException(404, "static_id not found")

    await _audit(pool, admin.login, "ADD_WL", {"static_id": static_id})
    return {"ok": True, "static_id": static_id}


@app.post("/players/static/{static_id}/actions/removewl")
async def removewl_static(
    static_id: int,
    admin: AdminContext = Depends(require_permission("players.manage_wl")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute("UPDATE static_ids SET whitelisted=0 WHERE static_id=%s", (static_id,))
            if cur.rowcount == 0:
                raise HTTPException(404, "static_id not found")

    drop_result = await _drop_static_if_online(
        static_id,
        _kick_reason(None, "You have been removed from whitelist."),
        admin,
    )
    await _audit(pool, admin.login, "REMOVE_WL", {"static_id": static_id}, {"drop": drop_result})
    return {"ok": True, "static_id": static_id, "drop": drop_result}


@app.post("/players/static/{static_id}/actions/banwl")
async def banwl_static(
    static_id: int,
    days: int = Query(1, ge=1, le=3650),
    admin: AdminContext = Depends(require_permission("players.manage_ban")),
):
    pool = await get_pool()
    ban_until = (datetime.now(UTC) + timedelta(days=days)).replace(tzinfo=None)

    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                "UPDATE static_ids SET ban=1, ban_until=%s WHERE static_id=%s",
                (ban_until, static_id),
            )
            if cur.rowcount == 0:
                raise HTTPException(404, "static_id not found")

    drop_result = await _drop_static_if_online(
        static_id,
        _kick_reason(None, f"You have been banned from whitelist for {days} day(s)."),
        admin,
    )
    await _audit(pool, admin.login, "BAN_WL", {"static_id": static_id}, {"days": days, "drop": drop_result})
    return {"ok": True, "static_id": static_id, "days": days, "drop": drop_result}


@app.post("/players/static/{static_id}/actions/unbanwl")
async def unbanwl_static(
    static_id: int,
    admin: AdminContext = Depends(require_permission("players.manage_ban")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute("UPDATE static_ids SET ban=0, ban_until=NULL WHERE static_id=%s", (static_id,))
            if cur.rowcount == 0:
                raise HTTPException(404, "static_id not found")

    await _audit(pool, admin.login, "UNBAN_WL", {"static_id": static_id})
    return {"ok": True, "static_id": static_id}


@app.patch("/players/{citizenid}/profile")
async def player_patch_profile(
    citizenid: str,
    body: PlayerProfilePatchBody,
    admin: AdminContext = Depends(require_permission("players.edit_profile")),
):
    updates = body.model_dump(exclude_none=True)
    if not updates:
        raise HTTPException(400, "No fields to update")

    birthdate = updates.get("birthdate")
    if birthdate is not None:
        try:
            datetime.strptime(birthdate, "%Y-%m-%d")
        except ValueError:
            raise HTTPException(400, "birthdate must be YYYY-MM-DD")

    pool = await get_pool()
    changes_for_audit: dict[str, dict[str, object]] = {}
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute("SELECT charinfo FROM players WHERE citizenid=%s LIMIT 1", (citizenid,))
            row = await cur.fetchone()
            if not row:
                raise HTTPException(404, "Player not found")

            charinfo = _charinfo_to_dict(row.get("charinfo"))
            for key, value in updates.items():
                old_value = charinfo.get(key)
                new_value = value.strip() if isinstance(value, str) else value
                charinfo[key] = new_value
                if old_value != new_value:
                    changes_for_audit[key] = {"from": old_value, "to": new_value}

            await cur.execute(
                "UPDATE players SET charinfo=%s WHERE citizenid=%s",
                (json.dumps(charinfo, ensure_ascii=False), citizenid),
            )

    await _audit(
        pool,
        admin.login,
        "EDIT_PROFILE",
        {"citizenid": citizenid},
        {"changes": changes_for_audit},
    )
    return {"ok": True, "updated_fields": sorted(updates.keys())}


async def _resolve_static_id_by_license(pool, license_value: str | None) -> int | None:
    tail = license_tail(license_value)
    if not tail:
        return None

    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                "SELECT static_id FROM static_ids WHERE SUBSTRING_INDEX(license, ':', -1) = %s LIMIT 1",
                (tail,),
            )
            r = await cur.fetchone()
            return int(r[0]) if r else None


@app.post("/players/{citizenid}/actions/addwl")
async def addwl(
    citizenid: str,
    admin: AdminContext = Depends(require_permission("players.manage_wl")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute("SELECT license FROM players WHERE citizenid=%s LIMIT 1", (citizenid,))
            r = await cur.fetchone()
            if not r:
                raise HTTPException(404, "Player not found")
            sid = await _resolve_static_id_by_license(pool, r.get("license"))
            if sid is None:
                raise HTTPException(404, "static_id not found")
            await cur.execute("UPDATE static_ids SET whitelisted=1 WHERE static_id=%s", (sid,))

    await _audit(pool, admin.login, "ADD_WL", {"citizenid": citizenid, "static_id": sid})
    return {"ok": True, "static_id": sid}


@app.post("/wl/add-by-static-ids")
async def addwl_by_static_ids(
    body: WlBulkBody,
    admin: AdminContext = Depends(require_permission("players.manage_wl")),
):
    static_ids = sorted(set(int(x) for x in body.static_ids if int(x) > 0))
    if not static_ids:
        raise HTTPException(400, "static_ids is empty")

    pool = await get_pool()
    updated: list[int] = []
    not_found: list[int] = []

    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            for sid in static_ids:
                await cur.execute("UPDATE static_ids SET whitelisted = 1 WHERE static_id = %s", (sid,))
                if cur.rowcount > 0:
                    updated.append(sid)
                else:
                    not_found.append(sid)

    await _audit(
        pool,
        admin.login,
        "ADD_WL_BULK",
        {"count": len(static_ids)},
        {"updated": updated, "not_found": not_found},
    )
    return {"ok": True, "updated": updated, "not_found": not_found}


@app.post("/wl/remove-by-static-ids")
async def removewl_by_static_ids(
    body: WlBulkBody,
    admin: AdminContext = Depends(require_permission("players.manage_wl")),
):
    static_ids = sorted(set(int(x) for x in body.static_ids if int(x) > 0))
    if not static_ids:
        raise HTTPException(400, "static_ids is empty")

    pool = await get_pool()
    updated: list[int] = []
    not_found: list[int] = []

    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            for sid in static_ids:
                await cur.execute("UPDATE static_ids SET whitelisted = 0 WHERE static_id = %s", (sid,))
                if cur.rowcount > 0:
                    updated.append(sid)
                else:
                    not_found.append(sid)

    await _audit(
        pool,
        admin.login,
        "REMOVE_WL_BULK",
        {"count": len(static_ids)},
        {"updated": updated, "not_found": not_found},
    )
    return {"ok": True, "updated": updated, "not_found": not_found}


@app.post("/players/{citizenid}/actions/removewl")
async def removewl(
    citizenid: str,
    admin: AdminContext = Depends(require_permission("players.manage_wl")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute("SELECT license FROM players WHERE citizenid=%s LIMIT 1", (citizenid,))
            r = await cur.fetchone()
            if not r:
                raise HTTPException(404, "Player not found")
            sid = await _resolve_static_id_by_license(pool, r.get("license"))
            if sid is None:
                raise HTTPException(404, "static_id not found")
            await cur.execute("UPDATE static_ids SET whitelisted=0 WHERE static_id=%s", (sid,))

    drop_result = await _drop_player_if_online(
        pool,
        citizenid,
        _kick_reason(None, "You have been removed from whitelist."),
        admin,
    )
    await _audit(
        pool,
        admin.login,
        "REMOVE_WL",
        {"citizenid": citizenid, "static_id": sid},
        {"drop": drop_result},
    )
    return {"ok": True, "static_id": sid, "drop": drop_result}


@app.post("/players/{citizenid}/actions/banwl")
async def banwl(
    citizenid: str,
    days: int = Query(1, ge=1, le=3650),
    admin: AdminContext = Depends(require_permission("players.manage_ban")),
):
    pool = await get_pool()
    ban_until = (datetime.now(UTC) + timedelta(days=days)).replace(tzinfo=None)

    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute("SELECT license FROM players WHERE citizenid=%s LIMIT 1", (citizenid,))
            r = await cur.fetchone()
            if not r:
                raise HTTPException(404, "Player not found")
            sid = await _resolve_static_id_by_license(pool, r.get("license"))
            if sid is None:
                raise HTTPException(404, "static_id not found")
            await cur.execute(
                "UPDATE static_ids SET ban=1, ban_until=%s WHERE static_id=%s",
                (ban_until, sid),
            )

    drop_result = await _drop_player_if_online(
        pool,
        citizenid,
        _kick_reason(None, f"You have been banned from whitelist for {days} day(s)."),
        admin,
    )
    await _audit(
        pool,
        admin.login,
        "BAN_WL",
        {"citizenid": citizenid, "static_id": sid},
        {"days": days, "drop": drop_result},
    )
    return {"ok": True, "static_id": sid, "days": days, "drop": drop_result}


@app.post("/players/{citizenid}/actions/unbanwl")
async def unbanwl(
    citizenid: str,
    admin: AdminContext = Depends(require_permission("players.manage_ban")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute("SELECT license FROM players WHERE citizenid=%s LIMIT 1", (citizenid,))
            r = await cur.fetchone()
            if not r:
                raise HTTPException(404, "Player not found")
            sid = await _resolve_static_id_by_license(pool, r.get("license"))
            if sid is None:
                raise HTTPException(404, "static_id not found")
            await cur.execute("UPDATE static_ids SET ban=0, ban_until=NULL WHERE static_id=%s", (sid,))

    await _audit(pool, admin.login, "UNBAN_WL", {"citizenid": citizenid, "static_id": sid})
    return {"ok": True, "static_id": sid}


@app.post("/players/{citizenid}/actions/setslots")
async def setslots(
    citizenid: str,
    slots: int = Query(..., ge=1, le=20),
    admin: AdminContext = Depends(require_permission("players.manage_slots")),
):
    pool = await get_pool()

    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute("SELECT license FROM players WHERE citizenid=%s LIMIT 1", (citizenid,))
            r = await cur.fetchone()
            if not r:
                raise HTTPException(404, "Player not found")
            license_val = r.get("license")
            tail = license_tail(license_val)
            if not tail:
                raise HTTPException(400, "Bad license")

            await cur.execute(
                "SELECT max_slots FROM player_slots WHERE SUBSTRING_INDEX(license, ':', -1)=%s",
                (tail,),
            )
            ex = await cur.fetchone()
            if ex:
                await cur.execute(
                    "UPDATE player_slots SET max_slots=%s WHERE SUBSTRING_INDEX(license, ':', -1)=%s",
                    (slots, tail),
                )
                action = "updated"
            else:
                await cur.execute(
                    "INSERT INTO player_slots (license, max_slots) VALUES (%s,%s)",
                    (license_val, slots),
                )
                action = "created"

    await _audit(
        pool,
        admin.login,
        "SET_SLOTS",
        {"citizenid": citizenid},
        {"slots": slots, "action": action},
    )
    return {"ok": True, "action": action, "slots": slots}


@app.post("/players/{citizenid}/actions/kick")
async def kick_player(
    citizenid: str,
    body: KickBody,
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    pool = await get_pool()
    reason = _kick_reason(body.reason, "Kicked by administrator.")
    drop_result = await _drop_player_if_online(pool, citizenid, reason, admin)
    if not drop_result.get("dropped"):
        raise HTTPException(400, "Player is offline. Kick is unavailable.")

    await _audit(
        pool,
        admin.login,
        "KICK_PLAYER",
        {"citizenid": citizenid},
        {"reason": reason, "drop": drop_result},
    )
    return {"ok": True, "reason": reason, "drop": drop_result}


@app.delete("/players/{citizenid}")
async def delete_character(
    citizenid: str,
    admin: AdminContext = Depends(require_permission("players.delete_character")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute("DELETE FROM players WHERE citizenid=%s", (citizenid,))
            if cur.rowcount <= 0:
                raise HTTPException(404, "Not found")

    await _audit(pool, admin.login, "DELETE_CHAR", {"citizenid": citizenid})
    return {"ok": True}


def _format_vehicle_row(row: dict):
    glovebox_items = _normalize_inventory_like(row.get("glovebox"))
    trunk_items = _normalize_inventory_like(row.get("trunk"))
    return {
        "id": row.get("id"),
        "license": row.get("license"),
        "citizenid": row.get("citizenid"),
        "vehicle": row.get("vehicle"),
        "plate": row.get("plate"),
        "fakeplate": row.get("fakeplate"),
        "garage_id": row.get("garage_id"),
        "garage": row.get("garage"),
        "state": row.get("state"),
        "parking": row.get("parking"),
        "nickname": row.get("nickname"),
        "type": row.get("type"),
        "in_garage": row.get("in_garage"),
        "impound": row.get("impound"),
        "lock": row.get("lock"),
        "fuel": row.get("fuel"),
        "engine": row.get("engine"),
        "body": row.get("body"),
        "traveldistance": row.get("traveldistance"),
        "glovebox": glovebox_items,
        "trunk": trunk_items,
    }


@app.get("/vehicles/search")
async def vehicles_search(
    plate: str = Query(..., min_length=1, max_length=32),
    limit: int = Query(30, ge=1, le=100),
    admin: AdminContext = Depends(require_permission("vehicles.read")),
):
    pool = await get_pool()
    like = f"%{plate.strip()}%"
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                """
                SELECT id, citizenid, vehicle, plate, fakeplate, garage_id, garage, state, nickname
                FROM player_vehicles
                WHERE plate LIKE %s OR fakeplate LIKE %s
                ORDER BY id DESC
                LIMIT %s
                """,
                (like, like, limit),
            )
            rows = await cur.fetchall()

    items = []
    for row in rows:
        items.append(
            {
                "id": row.get("id"),
                "citizenid": row.get("citizenid"),
                "vehicle": row.get("vehicle"),
                "plate": row.get("plate"),
                "fakeplate": row.get("fakeplate"),
                "garage_id": row.get("garage_id"),
                "garage": row.get("garage"),
                "state": row.get("state"),
                "nickname": row.get("nickname"),
            }
        )

    return {"count": len(items), "items": items, "admin": admin.login}


@app.get("/vehicles/{vehicle_id}")
async def vehicle_get(
    vehicle_id: int,
    admin: AdminContext = Depends(require_permission("vehicles.read")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                """
                SELECT
                    id, license, citizenid, vehicle, plate, fakeplate, garage, fuel, engine, body, state,
                    `lock`, parking, in_garage, garage_id, impound, nickname, type, traveldistance,
                    glovebox, trunk
                FROM player_vehicles
                WHERE id = %s
                LIMIT 1
                """,
                (vehicle_id,),
            )
            row = await cur.fetchone()
            if not row:
                raise HTTPException(404, "Vehicle not found")

            owner = None
            citizenid = row.get("citizenid")
            if citizenid:
                await cur.execute("SELECT citizenid, charinfo FROM players WHERE citizenid = %s LIMIT 1", (citizenid,))
                prow = await cur.fetchone()
                if prow:
                    ci = _charinfo_to_dict(prow.get("charinfo"))
                    owner = {
                        "citizenid": prow.get("citizenid"),
                        "firstname": ci.get("firstname"),
                        "lastname": ci.get("lastname"),
                    }

    return {"item": _format_vehicle_row(row), "owner": owner}


@app.patch("/vehicles/{vehicle_id}")
async def vehicle_patch(
    vehicle_id: int,
    body: VehiclePatchBody,
    admin: AdminContext = Depends(require_permission("vehicles.edit")),
):
    updates = body.model_dump(exclude_none=True)
    if not updates:
        raise HTTPException(400, "No fields to update")

    if "plate" in updates:
        updates["plate"] = str(updates["plate"]).strip().upper()
    if "fakeplate" in updates and updates["fakeplate"] is not None:
        updates["fakeplate"] = str(updates["fakeplate"]).strip().upper()

    allowed_cols = {
        "plate",
        "fakeplate",
        "garage_id",
        "garage",
        "nickname",
        "state",
        "parking",
        "impound",
        "in_garage",
        "lock",
    }
    bad = [k for k in updates.keys() if k not in allowed_cols]
    if bad:
        raise HTTPException(400, f"Unsupported fields: {', '.join(sorted(bad))}")

    assignments = []
    args: list[object] = []
    for key, value in updates.items():
        assignments.append(f"`{key}` = %s")
        args.append(value)
    args.append(vehicle_id)

    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(f"UPDATE player_vehicles SET {', '.join(assignments)} WHERE id = %s", tuple(args))
            if cur.rowcount <= 0:
                raise HTTPException(404, "Vehicle not found")

            await cur.execute(
                """
                SELECT
                    id, license, citizenid, vehicle, plate, fakeplate, garage, fuel, engine, body, state,
                    `lock`, parking, in_garage, garage_id, impound, nickname, type, traveldistance,
                    glovebox, trunk
                FROM player_vehicles
                WHERE id = %s
                LIMIT 1
                """,
                (vehicle_id,),
            )
            row = await cur.fetchone()

    await _audit(pool, admin.login, "VEHICLE_EDIT", {"vehicle_id": vehicle_id}, updates)
    return {"ok": True, "item": _format_vehicle_row(row), "updated_fields": sorted(updates.keys())}


@app.get("/game-actions/templates")
async def game_actions_templates(
    active_only: bool = Query(False),
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    pool = await get_pool()
    await _ensure_game_actions_table(pool)
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            if active_only:
                await cur.execute(
                    """
                    SELECT id, name, description, action_type, resource_name, action_name, variables_json, allowed_roles_json, is_active, created_at, updated_at
                    FROM web_game_action_templates
                    WHERE is_active = 1
                    ORDER BY id ASC
                    """
                )
            else:
                await cur.execute(
                    """
                    SELECT id, name, description, action_type, resource_name, action_name, variables_json, allowed_roles_json, is_active, created_at, updated_at
                    FROM web_game_action_templates
                    ORDER BY id ASC
                    """
                )
            rows = await cur.fetchall()

    items = []
    for row in rows:
        item = dict(row)
        allowed_roles = _safe_json(row.get("allowed_roles_json")) if row.get("allowed_roles_json") is not None else []
        if not isinstance(allowed_roles, list):
            allowed_roles = []
        allowed_roles = _clean_template_roles([str(x) for x in allowed_roles if isinstance(x, str)])
        can_manage_templates = "*" in admin.permissions or "actions.manage_templates" in admin.permissions
        if allowed_roles and admin.role_name not in allowed_roles and not can_manage_templates:
            continue
        item["variables"] = _safe_json(row.get("variables_json")) if row.get("variables_json") is not None else []
        if isinstance(item["variables"], dict):
            item["variables"] = []
        item["allowed_roles"] = allowed_roles
        item.pop("variables_json", None)
        item.pop("allowed_roles_json", None)
        items.append(item)
    return {"items": items}


@app.get("/game-actions/allowed-roles")
async def game_actions_allowed_roles(
    admin: AdminContext = Depends(require_permission("actions.manage_templates")),
):
    del admin
    return {"items": sorted(ALLOWED_ROLES)}


@app.post("/game-actions/templates")
async def game_actions_template_create(
    body: GameActionTemplateCreateBody,
    admin: AdminContext = Depends(require_permission("actions.manage_templates")),
):
    if body.action_type == "export" and not (body.resource_name or "").strip():
        raise HTTPException(400, "resource_name is required for export action")

    variables = _clean_template_variables(body.variables)
    allowed_roles = _clean_template_roles(body.allowed_roles)
    now = datetime.now(UTC).replace(tzinfo=None)
    pool = await get_pool()
    await _ensure_game_actions_table(pool)
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                """
                INSERT INTO web_game_action_templates
                (name, description, action_type, resource_name, action_name, variables_json, allowed_roles_json, is_active, created_at, updated_at)
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                """,
                (
                    body.name.strip(),
                    (body.description or "").strip() or None,
                    body.action_type,
                    (body.resource_name or "").strip() or None,
                    body.action_name.strip(),
                    json.dumps(variables, ensure_ascii=False),
                    json.dumps(allowed_roles, ensure_ascii=False),
                    1 if body.is_active else 0,
                    now,
                    now,
                ),
            )
            new_id = int(cur.lastrowid)

    await _audit(
        pool,
        admin.login,
        "GAME_ACTION_TEMPLATE_CREATE",
        {"template_id": new_id},
        {
            "name": body.name.strip(),
            "action_type": body.action_type,
            "resource_name": (body.resource_name or "").strip() or None,
            "action_name": body.action_name.strip(),
            "variables_count": len(variables),
            "allowed_roles": allowed_roles,
        },
    )
    return {"ok": True, "id": new_id}


@app.patch("/game-actions/templates/{template_id}")
async def game_actions_template_patch(
    template_id: int,
    body: GameActionTemplatePatchBody,
    admin: AdminContext = Depends(require_permission("actions.manage_templates")),
):
    updates = body.model_dump(exclude_none=True)
    if not updates:
        raise HTTPException(400, "No fields to update")

    if "action_type" in updates and updates["action_type"] == "export":
        incoming_resource_name = (body.resource_name or "").strip()
        if incoming_resource_name == "":
            raise HTTPException(400, "resource_name is required for export action")

    fields: list[str] = []
    args: list[Any] = []
    audit_payload: dict[str, Any] = {}

    if body.name is not None:
        fields.append("name=%s")
        args.append(body.name.strip())
        audit_payload["name"] = body.name.strip()
    if body.description is not None:
        desc = body.description.strip() or None
        fields.append("description=%s")
        args.append(desc)
        audit_payload["description"] = desc
    if body.action_type is not None:
        fields.append("action_type=%s")
        args.append(body.action_type)
        audit_payload["action_type"] = body.action_type
    if body.resource_name is not None:
        resource = body.resource_name.strip() or None
        fields.append("resource_name=%s")
        args.append(resource)
        audit_payload["resource_name"] = resource
    if body.action_name is not None:
        fields.append("action_name=%s")
        args.append(body.action_name.strip())
        audit_payload["action_name"] = body.action_name.strip()
    if body.variables is not None:
        clean_vars = _clean_template_variables(body.variables)
        fields.append("variables_json=%s")
        args.append(json.dumps(clean_vars, ensure_ascii=False))
        audit_payload["variables_count"] = len(clean_vars)
    if body.allowed_roles is not None:
        clean_roles = _clean_template_roles(body.allowed_roles)
        fields.append("allowed_roles_json=%s")
        args.append(json.dumps(clean_roles, ensure_ascii=False))
        audit_payload["allowed_roles"] = clean_roles
    if body.is_active is not None:
        fields.append("is_active=%s")
        args.append(1 if body.is_active else 0)
        audit_payload["is_active"] = body.is_active

    fields.append("updated_at=%s")
    args.append(datetime.now(UTC).replace(tzinfo=None))
    args.append(template_id)

    pool = await get_pool()
    await _ensure_game_actions_table(pool)
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                f"UPDATE web_game_action_templates SET {', '.join(fields)} WHERE id = %s",
                tuple(args),
            )
            if cur.rowcount <= 0:
                raise HTTPException(404, "Template not found")

    await _audit(pool, admin.login, "GAME_ACTION_TEMPLATE_PATCH", {"template_id": template_id}, audit_payload)
    return {"ok": True}


@app.delete("/game-actions/templates/{template_id}")
async def game_actions_template_delete(
    template_id: int,
    admin: AdminContext = Depends(require_permission("actions.manage_templates")),
):
    pool = await get_pool()
    await _ensure_game_actions_table(pool)
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                "DELETE FROM web_game_action_templates WHERE id=%s",
                (template_id,),
            )
            if cur.rowcount <= 0:
                raise HTTPException(404, "Template not found")

    await _audit(pool, admin.login, "GAME_ACTION_TEMPLATE_DELETE", {"template_id": template_id}, {})
    return {"ok": True}


@app.get("/players/{citizenid}/online-status")
async def player_online_status(
    citizenid: str,
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                f"""
                SELECT p.citizenid, p.license, p.name, s.static_id, s.discord_id
                FROM players p
                LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                WHERE p.citizenid = %s
                LIMIT 1
                """,
                (citizenid,),
            )
            p = await cur.fetchone()
            if not p:
                raise HTTPException(404, "Player not found")
    online_payload = _post_bridge_online_list({})
    raw_items = online_payload.get("items")
    items = raw_items if isinstance(raw_items, list) else []

    requested_citizenid = str(p.get("citizenid") or "").strip()
    requested_static = p.get("static_id")
    same_char: dict[str, Any] | None = None
    other_same_static: dict[str, Any] | None = None

    for row in items:
        if not isinstance(row, dict):
            continue
        row_citizenid = str(row.get("citizenid") or "").strip()
        if row_citizenid and row_citizenid == requested_citizenid:
            same_char = row
            break

    if same_char is None and requested_static is not None:
        for row in items:
            if not isinstance(row, dict):
                continue
            row_citizenid = str(row.get("citizenid") or "").strip()
            if row_citizenid == requested_citizenid:
                continue
            try:
                if row.get("static_id") is not None and int(row.get("static_id")) == int(requested_static):
                    other_same_static = row
                    break
            except Exception:
                continue

    status = same_char or {}
    return {
        "ok": True,
        "online": same_char is not None,
        "source": status.get("source"),
        "player_name": status.get("player_name"),
        "online_citizenid": status.get("citizenid"),
        "online_on_other_character": other_same_static is not None,
        "other_source": other_same_static.get("source") if other_same_static else None,
        "other_citizenid": other_same_static.get("citizenid") if other_same_static else None,
    }


@app.get("/items/check")
async def item_check(
    name: str = Query(..., min_length=1, max_length=128),
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    del admin
    key = _normalize_item_key(name)
    label = resolve_item_label(key)
    image = resolve_item_image(key)
    return {
        "ok": True,
        "item": key,
        "exists_in_site_catalog": bool(label),
        "label": label,
        "image": image,
        "image_url": _build_item_image_url(str(image) if image else None),
    }


@app.get("/items/suggest")
async def items_suggest(
    q: str = Query(..., min_length=1, max_length=128),
    limit: int = Query(10, ge=1, le=50),
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    del admin
    needle = _normalize_search_text(q)
    out: list[dict[str, Any]] = []
    catalog = get_items_catalog()
    if not catalog:
        return {"items": out}

    for item_key, meta in catalog.items():
        key = _normalize_item_key(item_key)
        label = str((meta or {}).get("label") or item_key)
        image = (meta or {}).get("image")
        haystack_key = _normalize_search_text(key)
        haystack_label = _normalize_search_text(label)
        if needle not in haystack_key and needle not in haystack_label:
            continue
        out.append(
            {
                "item": key,
                "label": label,
                "image": image,
                "image_url": _build_item_image_url(str(image) if image else None),
            }
        )
        if len(out) >= limit:
            break

    return {"items": out}


@app.get("/jobs/suggest")
async def jobs_suggest(
    q: str = Query(..., min_length=1, max_length=128),
    limit: int = Query(10, ge=1, le=50),
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    del admin
    needle = _normalize_search_text(q)
    out: list[dict[str, Any]] = []
    catalog = get_jobs_catalog()
    if not catalog:
        return {"items": out}

    for job_key, meta in catalog.items():
        key = _normalize_item_key(job_key)
        label = str((meta or {}).get("label") or job_key)
        if needle not in _normalize_search_text(key) and needle not in _normalize_search_text(label):
            continue
        grades = _sorted_grade_items((meta or {}).get("grades"))
        out.append({"job": key, "label": label, "grades_count": len(grades)})
        if len(out) >= limit:
            break
    return {"items": out}


@app.get("/gangs/suggest")
async def gangs_suggest(
    q: str = Query(..., min_length=1, max_length=128),
    limit: int = Query(10, ge=1, le=50),
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    del admin
    needle = _normalize_search_text(q)
    out: list[dict[str, Any]] = []
    catalog = get_gangs_catalog()
    if not catalog:
        return {"items": out}

    for gang_key, meta in catalog.items():
        key = _normalize_item_key(gang_key)
        label = str((meta or {}).get("label") or gang_key)
        if needle not in _normalize_search_text(key) and needle not in _normalize_search_text(label):
            continue
        grades = _sorted_grade_items((meta or {}).get("grades"))
        out.append({"gang": key, "label": label, "grades_count": len(grades)})
        if len(out) >= limit:
            break
    return {"items": out}


@app.get("/jobs/{job_key}/grades")
async def jobs_grades(
    job_key: str,
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    del admin
    key = _normalize_item_key(job_key)
    meta = None
    for raw_key, raw_meta in get_jobs_catalog().items():
        if _normalize_item_key(raw_key) == key:
            meta = raw_meta
            break
    if not meta:
        raise HTTPException(404, "Job not found")
    label = str((meta or {}).get("label") or key)
    grades = _sorted_grade_items((meta or {}).get("grades"))
    return {"job": key, "label": label, "items": grades}


@app.get("/gangs/{gang_key}/grades")
async def gangs_grades(
    gang_key: str,
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    del admin
    key = _normalize_item_key(gang_key)
    meta = None
    for raw_key, raw_meta in get_gangs_catalog().items():
        if _normalize_item_key(raw_key) == key:
            meta = raw_meta
            break
    if not meta:
        raise HTTPException(404, "Gang not found")
    label = str((meta or {}).get("label") or key)
    grades = _sorted_grade_items((meta or {}).get("grades"))
    return {"gang": key, "label": label, "items": grades}


@app.post("/players/{citizenid}/game-actions/debug-additem")
async def player_game_action_debug_additem(
    citizenid: str,
    body: ItemDebugBody,
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                f"""
                SELECT p.citizenid, p.license, p.name, s.static_id, s.discord_id
                FROM players p
                LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                WHERE p.citizenid = %s
                LIMIT 1
                """,
                (citizenid,),
            )
            p = await cur.fetchone()
            if not p:
                raise HTTPException(404, "Player not found")

    player_ctx = {
        "citizenid": p.get("citizenid"),
        "static_id": p.get("static_id"),
        "license": p.get("license"),
        "discord_id": p.get("discord_id"),
        "name": p.get("name"),
    }
    status = _post_bridge_status({"player": player_ctx})
    source_id = status.get("source")
    if not bool(status.get("online")) or source_id is None:
        raise HTTPException(400, "Player is offline. In-game interaction is unavailable.")

    item_key = _normalize_item_key(body.item)
    amount = int(body.amount)

    item_exists_payload = {
        "template": {
            "id": 0,
            "name": "debug_item_exists",
            "action_type": "export",
            "resource_name": "ox_inventory",
            "action_name": "Items",
        },
        "player": {**player_ctx, "source": source_id, "targetId": source_id, "target_id": source_id},
        "values": {"item": item_key},
        "args": [item_key],
        "requested_by": {"admin_id": admin.admin_id, "login": admin.login},
    }
    item_exists_response: dict[str, Any] | None = None
    item_exists_error: str | None = None
    try:
        item_exists_response = _post_bridge_execute(item_exists_payload)
    except HTTPException as e:
        item_exists_error = str(e.detail)

    cancarry_payload = {
        "template": {
            "id": 0,
            "name": "debug_can_carry",
            "action_type": "export",
            "resource_name": "ox_inventory",
            "action_name": "CanCarryItem",
        },
        "player": {**player_ctx, "source": source_id, "targetId": source_id, "target_id": source_id},
        "values": {"targetId": source_id, "item": item_key, "amount": amount},
        "args": [source_id, item_key, amount],
        "requested_by": {"admin_id": admin.admin_id, "login": admin.login},
    }
    cancarry_response: dict[str, Any] | None = None
    cancarry_error: str | None = None
    try:
        cancarry_response = _post_bridge_execute(cancarry_payload)
    except HTTPException as e:
        cancarry_error = str(e.detail)

    add_payload = {
        "template": {
            "id": 0,
            "name": "debug_add_item",
            "action_type": "export",
            "resource_name": "ox_inventory",
            "action_name": "AddItem",
        },
        "player": {**player_ctx, "source": source_id, "targetId": source_id, "target_id": source_id},
        "values": {"targetId": source_id, "item": item_key, "amount": amount},
        "args": [source_id, item_key, amount],
        "requested_by": {"admin_id": admin.admin_id, "login": admin.login},
    }
    add_response: dict[str, Any] | None = None
    add_error: str | None = None
    try:
        add_response = _post_bridge_execute(add_payload)
    except HTTPException as e:
        add_error = str(e.detail)

    await _audit(
        pool,
        admin.login,
        "GAME_ACTION_DEBUG_ADDITEM",
        {"citizenid": citizenid, "item": item_key, "amount": amount},
        {
            "source": source_id,
            "item_exists_response": item_exists_response,
            "item_exists_error": item_exists_error,
            "can_carry_response": cancarry_response,
            "can_carry_error": cancarry_error,
            "add_response": add_response,
            "add_error": add_error,
        },
    )
    return {
        "ok": add_error is None,
        "source": source_id,
        "item": item_key,
        "amount": amount,
        "item_exists_response": item_exists_response,
        "item_exists_error": item_exists_error,
        "can_carry_response": cancarry_response,
        "can_carry_error": cancarry_error,
        "add_response": add_response,
        "add_error": add_error,
    }


@app.post("/players/{citizenid}/game-actions/execute")
async def player_game_action_execute(
    citizenid: str,
    body: GameActionExecuteBody,
    admin: AdminContext = Depends(require_permission("players.game_interact")),
):
    pool = await get_pool()
    await _ensure_game_actions_table(pool)
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                f"""
                SELECT p.citizenid, p.license, p.name, s.static_id, s.discord_id
                FROM players p
                LEFT JOIN static_ids s ON {JOIN_ON_LICENSE_TAIL}
                WHERE p.citizenid = %s
                LIMIT 1
                """,
                (citizenid,),
            )
            p = await cur.fetchone()
            if not p:
                raise HTTPException(404, "Player not found")

            await cur.execute(
                """
                SELECT id, name, action_type, resource_name, action_name, variables_json, allowed_roles_json, is_active
                FROM web_game_action_templates
                WHERE id = %s
                LIMIT 1
                """,
                (body.template_id,),
            )
            tmpl = await cur.fetchone()
            if not tmpl:
                raise HTTPException(404, "Template not found")
            if int(tmpl.get("is_active") or 0) == 0:
                raise HTTPException(400, "Template is inactive")
            allowed_roles = _safe_json(tmpl.get("allowed_roles_json")) if tmpl.get("allowed_roles_json") is not None else []
            if not isinstance(allowed_roles, list):
                allowed_roles = []
            clean_roles = _clean_template_roles([str(x) for x in allowed_roles if isinstance(x, str)])
            if clean_roles and admin.role_name not in clean_roles and "*" not in admin.permissions:
                raise HTTPException(403, "Your role is not allowed to execute this template")

    variables = _safe_json(tmpl.get("variables_json")) if tmpl.get("variables_json") is not None else []
    if not isinstance(variables, list):
        variables = []

    player_ctx = {
        "citizenid": p.get("citizenid"),
        "static_id": p.get("static_id"),
        "license": p.get("license"),
        "discord_id": p.get("discord_id"),
        "name": p.get("name"),
    }

    status = _post_bridge_status({"player": player_ctx})
    source_id = status.get("source")
    if not bool(status.get("online")) or source_id is None:
        raise HTTPException(400, "Player is offline. In-game interaction is unavailable.")
    player_ctx["source"] = source_id
    player_ctx["targetId"] = source_id
    player_ctx["target_id"] = source_id

    values: dict[str, Any] = {}
    args: list[Any] = []
    for var in variables:
        if not isinstance(var, dict):
            continue
        key = str(var.get("key") or "").strip()
        if not key:
            continue

        required = bool(var.get("required", True))
        value_type = str(var.get("value_type") or "string")

        raw = body.values.get(key)
        raw_is_empty = raw is None or raw == "" or (isinstance(raw, str) and raw.strip() == "")
        # If UI sent empty value, allow auto-fill from player context.
        if raw_is_empty and key in player_ctx:
            raw = player_ctx.get(key)
        if raw is None and var.get("default_value") not in (None, ""):
            raw = var.get("default_value")

        if required and (raw is None or raw == ""):
            raise HTTPException(400, f"Missing required variable: {key}")

        converted = _convert_variable_value(raw, value_type)
        if key == "item" and isinstance(converted, str):
            converted = _normalize_item_key(converted)
        values[key] = converted
        args.append(converted)

    bridge_payload = {
        "template": {
            "id": tmpl.get("id"),
            "name": tmpl.get("name"),
            "action_type": tmpl.get("action_type"),
            "resource_name": tmpl.get("resource_name"),
            "action_name": tmpl.get("action_name"),
        },
        "player": player_ctx,
        "values": values,
        "args": args,
        "requested_by": {"admin_id": admin.admin_id, "login": admin.login},
    }

    bridge_response = _post_bridge_execute(bridge_payload)

    await _audit(
        pool,
        admin.login,
        "GAME_ACTION_EXECUTE",
        {"citizenid": citizenid, "template_id": tmpl.get("id"), "template_name": tmpl.get("name")},
        {"source": source_id, "values": values, "bridge_response": bridge_response},
    )
    return {"ok": True, "bridge": bridge_response}


@app.get("/audit")
async def audit(
    limit: int = Query(50, ge=1, le=200),
    admin: AdminContext = Depends(require_permission("audit.read")),
):
    pool = await get_pool()
    await _ensure_audit_table(pool)
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                """
                SELECT id, ts, admin_tag, action, target_json, payload_json
                FROM audit_logs
                ORDER BY id DESC
                LIMIT %s
            """,
                (limit,),
            )
            rows = await cur.fetchall()

    return {"items": rows, "admin": admin.login}


@app.get("/admin/permissions")
async def admin_permissions(
    admin: AdminContext = Depends(require_permission("admins.manage")),
):
    return {"items": sorted(KNOWN_PERMISSIONS), "admin": admin.login}


@app.get("/admin/roles")
async def admin_roles(admin: AdminContext = Depends(require_permission("admins.manage"))):
    pool = await get_pool()
    by_role: dict[str, list[str]] = {}
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                "SELECT role_name, permission FROM web_role_permissions ORDER BY role_name, permission"
            )
            rows = await cur.fetchall()

    for row in rows:
        by_role.setdefault(row["role_name"], []).append(row["permission"])

    items = [{"role_name": role_name, "permissions": permissions} for role_name, permissions in by_role.items()]
    return {"items": items}


@app.put("/admin/roles/{role_name}")
async def admin_role_replace(
    role_name: str,
    body: RoleReplaceBody = Body(...),
    admin: AdminContext = Depends(require_permission("admins.manage")),
):
    role_name = role_name.strip().lower()
    if not role_name:
        raise HTTPException(400, "role_name is required")

    uniq = sorted(set(body.permissions))
    unknown = [p for p in uniq if p != "*" and p not in KNOWN_PERMISSIONS]
    if unknown:
        raise HTTPException(400, f"Unknown permissions: {', '.join(unknown)}")

    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute("DELETE FROM web_role_permissions WHERE role_name=%s", (role_name,))
            for permission in uniq:
                await cur.execute(
                    "INSERT INTO web_role_permissions (role_name, permission) VALUES (%s,%s)",
                    (role_name, permission),
                )

    await _audit(
        pool,
        admin.login,
        "ROLE_REPLACE_PERMISSIONS",
        {"role_name": role_name},
        {"permissions": uniq},
    )
    return {"ok": True, "role_name": role_name, "permissions": uniq}


@app.get("/admin/admins")
async def admin_list(admin: AdminContext = Depends(require_permission("admins.manage"))):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                """
                SELECT id, login, discord_id, role_name, is_active, created_at, updated_at
                FROM web_admins
                ORDER BY id ASC
                """
            )
            rows = await cur.fetchall()

    items = []
    for r in rows:
        row = dict(r)
        if row.get("discord_id") is not None:
            row["discord_id"] = str(row["discord_id"])
        items.append(row)
    return {"items": items}


@app.get("/admin/discord-assignments")
async def admin_discord_assignments(admin: AdminContext = Depends(require_permission("admins.manage"))):
    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                """
                SELECT id, login, discord_id, role_name, is_active, created_at, updated_at
                FROM web_admins
                WHERE discord_id IS NOT NULL
                ORDER BY updated_at DESC, id DESC
                """
            )
            rows = await cur.fetchall()
    items = []
    for r in rows:
        row = dict(r)
        if row.get("discord_id") is not None:
            row["discord_id"] = str(row["discord_id"])
        items.append(row)
    return {"items": items}


@app.post("/admin/discord-assignments")
async def admin_discord_assign(
    body: DiscordAssignBody,
    admin: AdminContext = Depends(require_permission("admins.manage")),
):
    role_name = body.role_name.strip().lower()
    discord_raw = (body.discord_id or "").strip()
    if not discord_raw.isdigit():
        raise HTTPException(400, "discord_id must contain only digits")
    discord_id = int(discord_raw)
    login = (body.login or f"discord_{discord_id}").strip()
    if len(login) < 3:
        raise HTTPException(400, "login is too short")
    now = datetime.now(UTC).replace(tzinfo=None)

    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute("SELECT 1 FROM web_role_permissions WHERE role_name=%s LIMIT 1", (role_name,))
            if not await cur.fetchone():
                raise HTTPException(400, "Role does not exist or has no permissions")

            await cur.execute("SELECT id, login FROM web_admins WHERE discord_id=%s LIMIT 1", (discord_id,))
            by_discord = await cur.fetchone()
            if by_discord:
                admin_id = int(by_discord[0])
                if not body.login:
                    login = str(by_discord[1] or login)
                await cur.execute("SELECT id FROM web_admins WHERE login=%s LIMIT 1", (login,))
                login_row = await cur.fetchone()
                if login_row and int(login_row[0]) != admin_id:
                    raise HTTPException(409, "Login already exists")
                await cur.execute(
                    """
                    UPDATE web_admins
                    SET login=%s, role_name=%s, is_active=%s, updated_at=%s
                    WHERE id=%s
                    """,
                    (login, role_name, 1 if body.is_active else 0, now, admin_id),
                )
            else:
                await cur.execute("SELECT id, discord_id FROM web_admins WHERE login=%s LIMIT 1", (login,))
                by_login = await cur.fetchone()
                if by_login:
                    found_id = int(by_login[0])
                    found_discord = by_login[1]
                    if found_discord is not None and int(found_discord) != discord_id:
                        raise HTTPException(409, "Login is already used by another discord admin")
                    admin_id = found_id
                    await cur.execute(
                        """
                        UPDATE web_admins
                        SET discord_id=%s, role_name=%s, is_active=%s, updated_at=%s
                        WHERE id=%s
                        """,
                        (discord_id, role_name, 1 if body.is_active else 0, now, admin_id),
                    )
                else:
                    new_token = await _generate_unique_token(pool)
                    await cur.execute(
                        """
                        INSERT INTO web_admins (login, discord_id, token, role_name, is_active, created_at, updated_at)
                        VALUES (%s,%s,%s,%s,%s,%s,%s)
                        """,
                        (login, discord_id, new_token, role_name, 1 if body.is_active else 0, now, now),
                    )
                    admin_id = int(cur.lastrowid)

    await _audit(
        pool,
        admin.login,
        "DISCORD_ASSIGN_ROLE",
        {"discord_id": discord_id, "admin_id": admin_id},
        {"role_name": role_name, "is_active": body.is_active},
    )
    return {"ok": True, "admin_id": admin_id, "discord_id": discord_id, "role_name": role_name}


@app.post("/admin/admins")
async def admin_create(
    body: AdminCreateBody,
    admin: AdminContext = Depends(require_permission("admins.manage")),
):
    pool = await get_pool()
    now = datetime.now(UTC).replace(tzinfo=None)
    role_name = body.role_name.strip().lower()

    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute("SELECT 1 FROM web_admins WHERE login=%s", (body.login,))
            if await cur.fetchone():
                raise HTTPException(409, "Login already exists")

            await cur.execute("SELECT 1 FROM web_admins WHERE token=%s", (body.token,))
            if await cur.fetchone():
                raise HTTPException(409, "Token already exists")

            await cur.execute("SELECT 1 FROM web_role_permissions WHERE role_name=%s LIMIT 1", (role_name,))
            if not await cur.fetchone():
                raise HTTPException(400, "Role does not exist or has no permissions")

            await cur.execute(
                """
                INSERT INTO web_admins (login, token, role_name, is_active, created_at, updated_at)
                VALUES (%s, %s, %s, %s, %s, %s)
                """,
                (body.login.strip(), body.token.strip(), role_name, 1 if body.is_active else 0, now, now),
            )
            new_id = cur.lastrowid

    await _audit(
        pool,
        admin.login,
        "ADMIN_CREATE",
        {"admin_id": int(new_id)},
        {"login": body.login.strip(), "role_name": role_name, "is_active": body.is_active},
    )
    return {"ok": True, "id": int(new_id)}


@app.patch("/admin/admins/{admin_id}")
async def admin_patch(
    admin_id: int,
    body: AdminPatchBody,
    admin: AdminContext = Depends(require_permission("admins.manage")),
):
    updates = []
    args: list[object] = []

    if body.token is not None:
        updates.append("token=%s")
        args.append(body.token.strip())

    if body.role_name is not None:
        role_name = body.role_name.strip().lower()
        updates.append("role_name=%s")
        args.append(role_name)

    if body.is_active is not None:
        updates.append("is_active=%s")
        args.append(1 if body.is_active else 0)

    if not updates:
        raise HTTPException(400, "No fields to update")

    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            if body.role_name is not None:
                await cur.execute("SELECT 1 FROM web_role_permissions WHERE role_name=%s LIMIT 1", (role_name,))
                if not await cur.fetchone():
                    raise HTTPException(400, "Role does not exist or has no permissions")

            if body.token is not None:
                await cur.execute("SELECT id FROM web_admins WHERE token=%s LIMIT 1", (body.token.strip(),))
                row = await cur.fetchone()
                if row and int(row[0]) != admin_id:
                    raise HTTPException(409, "Token already in use")

            updates.append("updated_at=%s")
            args.append(datetime.now(UTC).replace(tzinfo=None))
            args.append(admin_id)

            await cur.execute(f"UPDATE web_admins SET {', '.join(updates)} WHERE id=%s", tuple(args))
            if cur.rowcount <= 0:
                raise HTTPException(404, "Admin not found")

    await _audit(
        pool,
        admin.login,
        "ADMIN_PATCH",
        {"admin_id": admin_id},
        body.model_dump(exclude_none=True),
    )
    return {"ok": True}


@app.delete("/admin/admins/{admin_id}")
async def admin_deactivate(
    admin_id: int,
    admin: AdminContext = Depends(require_permission("admins.manage")),
):
    if admin.admin_id == admin_id:
        raise HTTPException(400, "Cannot deactivate yourself")

    pool = await get_pool()
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            await cur.execute(
                "UPDATE web_admins SET is_active=0, updated_at=%s WHERE id=%s",
                (datetime.now(UTC).replace(tzinfo=None), admin_id),
            )
            if cur.rowcount <= 0:
                raise HTTPException(404, "Admin not found")

    await _audit(pool, admin.login, "ADMIN_DEACTIVATE", {"admin_id": admin_id})
    return {"ok": True}
