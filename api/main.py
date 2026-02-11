import json
import os
import secrets
import time
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime, timedelta, timezone

import aiomysql
from fastapi import Body, Depends, FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, Field

from auth import (
    AdminContext,
    KNOWN_PERMISSIONS,
    ensure_rbac_schema,
    require_admin,
    require_permission,
)
from db import get_pool
from items_catalog import resolve_item_image, resolve_item_label
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

    out = []
    for p in players[:limit]:
        ci = _charinfo_to_dict(p.get("charinfo"))
        out.append(
            {
                "citizenid": p.get("citizenid"),
                "name": p.get("name"),
                "static_id": p.get("static_id"),
                "discord_id": p.get("discord_id"),
                "firstname": ci.get("firstname"),
                "lastname": ci.get("lastname"),
                "phone": ci.get("phone"),
            }
        )

    return {
        "count": len(out),
        "items": out,
        "admin": {"login": admin.login, "role": admin.role_name},
    }


@app.get("/players/{citizenid}")
async def player_get(
    citizenid: str,
    admin: AdminContext = Depends(require_permission("players.read")),
):
    pool = await get_pool()
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

    return {
        "citizenid": p.get("citizenid"),
        "license": p.get("license"),
        "name": p.get("name"),
        "static_id": p.get("static_id"),
        "discord_id": p.get("discord_id"),
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
    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute("SELECT charinfo FROM players WHERE citizenid=%s LIMIT 1", (citizenid,))
            row = await cur.fetchone()
            if not row:
                raise HTTPException(404, "Player not found")

            charinfo = _charinfo_to_dict(row.get("charinfo"))
            for key, value in updates.items():
                charinfo[key] = value.strip() if isinstance(value, str) else value

            await cur.execute(
                "UPDATE players SET charinfo=%s WHERE citizenid=%s",
                (json.dumps(charinfo, ensure_ascii=False), citizenid),
            )

    await _audit(pool, admin.login, "EDIT_PROFILE", {"citizenid": citizenid}, updates)
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

    await _audit(pool, admin.login, "REMOVE_WL", {"citizenid": citizenid, "static_id": sid})
    return {"ok": True, "static_id": sid}


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

    await _audit(
        pool,
        admin.login,
        "BAN_WL",
        {"citizenid": citizenid, "static_id": sid},
        {"days": days},
    )
    return {"ok": True, "static_id": sid, "days": days}


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





