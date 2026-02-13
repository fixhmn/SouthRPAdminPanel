import os
import asyncio
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Callable

import aiomysql
from fastapi import Header, HTTPException

from db import get_pool

UTC = timezone.utc

KNOWN_PERMISSIONS = {
    "players.read",
    "players.edit_profile",
    "players.manage_wl",
    "players.manage_ban",
    "players.manage_slots",
    "players.delete_character",
    "players.game_interact",
    "players.inventory_delete",
    "vehicles.read",
    "vehicles.edit",
    "actions.manage_templates",
    "audit.read",
    "admins.manage",
    "auth.discord_login",
}

DEFAULT_ROLE_PERMISSIONS = {
    "megamozg": ["*"],
    "administrator": [
        "admins.manage",
        "audit.read",
        "players.read",
        "players.edit_profile",
        "players.manage_wl",
        "players.manage_ban",
        "players.manage_slots",
        "players.delete_character",
        "players.game_interact",
        "players.inventory_delete",
        "vehicles.read",
        "vehicles.edit",
        "actions.manage_templates",
    ],
    "moderator": [
        "players.read",
        "players.edit_profile",
        "players.manage_wl",
        "players.manage_ban",
        "players.manage_slots",
        "players.delete_character",
        "players.game_interact",
        "players.inventory_delete",
        "vehicles.read",
        "vehicles.edit",
        "actions.manage_templates",
        "audit.read",
    ],
    "helper": ["players.read", "vehicles.read", "audit.read"],
}

ROLE_RENAME_MAP = {
    "owner": "megamozg",
    "superadmin": "administrator",
    "admin": "moderator",
    "viewer": "helper",
}

ALLOWED_ROLES = {"megamozg", "administrator", "moderator", "helper"}


@dataclass
class AdminContext:
    admin_id: int
    login: str
    role_name: str
    permissions: set[str]


_rbac_ready = False
_rbac_lock = asyncio.Lock()


def has_permission(admin: AdminContext, permission: str) -> bool:
    if "*" in admin.permissions:
        return True
    return permission in admin.permissions


async def ensure_rbac_schema() -> None:
    global _rbac_ready
    if _rbac_ready:
        return

    async with _rbac_lock:
        if _rbac_ready:
            return

        pool = await get_pool()
        now = datetime.now(UTC).replace(tzinfo=None)

        async with pool.acquire() as conn:
            async with conn.cursor() as cur:
                await cur.execute(
                    """
                    CREATE TABLE IF NOT EXISTS web_admins (
                        id BIGINT AUTO_INCREMENT PRIMARY KEY,
                        login VARCHAR(64) NOT NULL UNIQUE,
                        discord_id BIGINT NULL UNIQUE,
                        token VARCHAR(128) NOT NULL UNIQUE,
                        role_name VARCHAR(64) NOT NULL,
                        is_active TINYINT(1) NOT NULL DEFAULT 1,
                        created_at DATETIME NOT NULL,
                        updated_at DATETIME NOT NULL
                    )
                    """
                )
                await cur.execute(
                    """
                    CREATE TABLE IF NOT EXISTS web_role_permissions (
                        role_name VARCHAR(64) NOT NULL,
                        permission VARCHAR(64) NOT NULL,
                        PRIMARY KEY (role_name, permission)
                    )
                    """
                )

                await cur.execute("SHOW COLUMNS FROM web_admins LIKE 'discord_id'")
                has_discord_id = await cur.fetchone()
                if not has_discord_id:
                    await cur.execute(
                        "ALTER TABLE web_admins ADD COLUMN discord_id BIGINT NULL UNIQUE AFTER login"
                    )

                # Normalize legacy role names to current role model.
                for old_role, new_role in ROLE_RENAME_MAP.items():
                    await cur.execute(
                        """
                        INSERT IGNORE INTO web_role_permissions (role_name, permission)
                        SELECT %s, permission FROM web_role_permissions WHERE role_name = %s
                        """,
                        (new_role, old_role),
                    )
                    await cur.execute("DELETE FROM web_role_permissions WHERE role_name = %s", (old_role,))
                    await cur.execute("UPDATE web_admins SET role_name = %s WHERE role_name = %s", (new_role, old_role))

                await cur.execute("SELECT COUNT(*) FROM web_role_permissions")
                role_perm_count = int((await cur.fetchone())[0])
                if role_perm_count == 0:
                    for role_name, permissions in DEFAULT_ROLE_PERMISSIONS.items():
                        for permission in permissions:
                            await cur.execute(
                                "INSERT INTO web_role_permissions (role_name, permission) VALUES (%s, %s)",
                                (role_name, permission),
                            )
                else:
                    # Keep only the supported roles and ensure defaults exist.
                    for role_name, permissions in DEFAULT_ROLE_PERMISSIONS.items():
                        for permission in permissions:
                            await cur.execute(
                                "INSERT IGNORE INTO web_role_permissions (role_name, permission) VALUES (%s, %s)",
                                (role_name, permission),
                            )
                    await cur.execute(
                        "DELETE FROM web_role_permissions WHERE role_name NOT IN ('megamozg', 'administrator', 'moderator', 'helper')"
                    )
                    await cur.execute(
                        "UPDATE web_admins SET role_name = 'helper' WHERE role_name NOT IN ('megamozg', 'administrator', 'moderator', 'helper')"
                    )

                await cur.execute("SELECT COUNT(*) FROM web_admins")
                admin_count = int((await cur.fetchone())[0])
                if admin_count == 0:
                    bootstrap_token = (
                        os.getenv("ADMIN_BOOTSTRAP_TOKEN")
                        or os.getenv("ADMIN_TOKEN")
                        or "change-me-admin-token"
                    )
                    bootstrap_login = os.getenv("ADMIN_BOOTSTRAP_LOGIN", "root")
                    await cur.execute(
                        """
                        INSERT INTO web_admins (login, token, role_name, is_active, created_at, updated_at)
                        VALUES (%s, %s, 'administrator', 1, %s, %s)
                        """,
                        (bootstrap_login, bootstrap_token, now, now),
                    )

        _rbac_ready = True


async def _load_admin_from_token(token: str) -> AdminContext:
    await ensure_rbac_schema()
    pool = await get_pool()

    async with pool.acquire() as conn:
        async with conn.cursor(aiomysql.DictCursor) as cur:
            await cur.execute(
                """
                SELECT id, login, role_name, is_active
                FROM web_admins
                WHERE token = %s
                LIMIT 1
                """,
                (token,),
            )
            admin_row = await cur.fetchone()
            if not admin_row or not int(admin_row.get("is_active") or 0):
                raise HTTPException(status_code=401, detail="Unauthorized")

            await cur.execute(
                "SELECT permission FROM web_role_permissions WHERE role_name = %s",
                (admin_row["role_name"],),
            )
            perm_rows = await cur.fetchall()

    permissions = {row["permission"] for row in perm_rows}
    return AdminContext(
        admin_id=int(admin_row["id"]),
        login=str(admin_row["login"]),
        role_name=str(admin_row["role_name"]),
        permissions=permissions,
    )


async def require_admin(x_admin_token: str | None = Header(default=None)) -> AdminContext:
    if not x_admin_token:
        raise HTTPException(status_code=401, detail="Unauthorized")
    return await _load_admin_from_token(x_admin_token)


def require_permission(permission: str) -> Callable:
    async def _dep(x_admin_token: str | None = Header(default=None)) -> AdminContext:
        admin = await require_admin(x_admin_token)
        if not has_permission(admin, permission):
            raise HTTPException(status_code=403, detail=f"Missing permission: {permission}")
        return admin

    return _dep



