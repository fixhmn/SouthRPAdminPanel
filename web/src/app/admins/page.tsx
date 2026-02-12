"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { AdminMe, api, can, fetchMe, roleLabel } from "@/lib/api";

type RoleRow = { role_name: string; permissions: string[] };
type RolesRes = { items: RoleRow[] };
type AdminRow = {
  id: number;
  login: string;
  discord_id: string | null;
  role_name: string;
  is_active: number;
  created_at: string;
  updated_at: string;
};
type AdminsRes = { items: AdminRow[] };
type PermissionRes = { items: string[] };
type DiscordAssignmentRes = { items: AdminRow[] };

const PERMISSION_DESCRIPTIONS: Record<string, string> = {
  "*": "Полный доступ ко всем действиям.",
  "admins.manage": "Управление администраторами, ролями и permissions.",
  "audit.read": "Просмотр журнала аудита.",
  "players.read": "Просмотр профилей и поиска игроков.",
  "players.edit_profile": "Редактирование полей профиля игрока.",
  "players.manage_wl": "Выдача и снятие WL.",
  "players.manage_ban": "Выдача и снятие WL-бана.",
  "players.manage_slots": "Изменение количества слотов персонажа.",
  "players.delete_character": "Удаление персонажа.",
  "players.game_interact": "Выполнение внутриигровых шаблонов в карточке игрока.",
  "vehicles.read": "Просмотр поиска и карточек машин.",
  "vehicles.edit": "Редактирование карточки машины.",
  "actions.manage_templates": "Создание и редактирование шаблонов внутриигровых действий.",
  "auth.discord_login": "Служебный permission для входа через Discord OAuth.",
};

function errorText(e: unknown): string {
  return e instanceof Error ? e.message : String(e);
}

export default function AdminsPage() {
  const [me, setMe] = useState<AdminMe | null>(null);
  const [permsCatalog, setPermsCatalog] = useState<string[]>([]);
  const [roles, setRoles] = useState<RoleRow[]>([]);
  const [admins, setAdmins] = useState<AdminRow[]>([]);
  const [roleDrafts, setRoleDrafts] = useState<Record<string, string[]>>({});
  const [err, setErr] = useState("");
  const [busy, setBusy] = useState(false);

  const [discordAssignments, setDiscordAssignments] = useState<AdminRow[]>([]);
  const [assignDiscordId, setAssignDiscordId] = useState("");
  const [assignLogin, setAssignLogin] = useState("");
  const [assignRole, setAssignRole] = useState("helper");
  const [assignActive, setAssignActive] = useState(true);

  const roleOptions = useMemo(() => roles.map((r) => r.role_name), [roles]);
  const allPermissions = useMemo(() => {
    const fromRoles = roles.flatMap((x) => x.permissions);
    const uniq = Array.from(new Set(["*", ...permsCatalog, ...fromRoles]));
    return uniq.sort((a, b) => {
      if (a === "*") return -1;
      if (b === "*") return 1;
      return a.localeCompare(b);
    });
  }, [permsCatalog, roles]);

  const permissionGroups = useMemo(() => {
    const grouped: Record<string, string[]> = {};
    for (const p of allPermissions) {
      const group = p === "*" ? "core" : p.split(".")[0];
      if (!grouped[group]) grouped[group] = [];
      grouped[group].push(p);
    }
    return grouped;
  }, [allPermissions]);

  useEffect(() => {
    (async () => {
      setErr("");
      try {
        const current = await fetchMe();
        setMe(current);

        if (!can(current, "admins.manage")) {
          return;
        }

        const [p, r, a, d] = await Promise.all([
          api<PermissionRes>("/admin/permissions"),
          api<RolesRes>("/admin/roles"),
          api<AdminsRes>("/admin/admins"),
          api<DiscordAssignmentRes>("/admin/discord-assignments"),
        ]);

        setPermsCatalog(p.items);
        setRoles(r.items);
        setAdmins(a.items);
        setDiscordAssignments(d.items);
        setRoleDrafts(Object.fromEntries(r.items.map((x) => [x.role_name, x.permissions])));

        if (r.items.length > 0) {
          setAssignRole((prev) => (r.items.some((x) => x.role_name === prev) ? prev : r.items[0].role_name));
        }
      } catch (e: unknown) {
        setErr(errorText(e));
      }
    })();
  }, []);

  async function reloadData() {
    try {
      const [p, r, a, d] = await Promise.all([
        api<PermissionRes>("/admin/permissions"),
        api<RolesRes>("/admin/roles"),
        api<AdminsRes>("/admin/admins"),
        api<DiscordAssignmentRes>("/admin/discord-assignments"),
      ]);
      setPermsCatalog(p.items);
      setRoles(r.items);
      setAdmins(a.items);
      setDiscordAssignments(d.items);
      setRoleDrafts(Object.fromEntries(r.items.map((x) => [x.role_name, x.permissions])));
    } catch (e: unknown) {
      setErr(errorText(e));
    }
  }

  async function saveRole(roleName: string) {
    setBusy(true);
    setErr("");

    try {
      const permissions = roleDrafts[roleName] || [];

      await api(`/admin/roles/${encodeURIComponent(roleName)}`, {
        method: "PUT",
        body: JSON.stringify({ permissions }),
      });
      await reloadData();
    } catch (e: unknown) {
      setErr(errorText(e));
    } finally {
      setBusy(false);
    }
  }

  function toggleRolePermission(roleName: string, permission: string) {
    setRoleDrafts((prev) => {
      const current = new Set(prev[roleName] || []);
      if (current.has(permission)) {
        current.delete(permission);
      } else {
        current.add(permission);
      }

      if (permission === "*" && current.has("*")) {
        return { ...prev, [roleName]: ["*"] };
      }

      if (permission !== "*") {
        current.delete("*");
      }

      return { ...prev, [roleName]: Array.from(current).sort() };
    });
  }

  async function patchAdmin(id: number, patch: { role_name?: string; is_active?: boolean }) {
    setBusy(true);
    setErr("");

    try {
      await api(`/admin/admins/${id}`, {
        method: "PATCH",
        body: JSON.stringify(patch),
      });
      await reloadData();
    } catch (e: unknown) {
      setErr(errorText(e));
    } finally {
      setBusy(false);
    }
  }

  async function saveDiscordAssignment() {
    const idStr = assignDiscordId.trim();
    if (!/^\d+$/.test(idStr)) {
      setErr("Ð£ÐºÐ°Ð¶Ð¸ ÐºÐ¾Ñ€Ñ€ÐµÐºÑ‚Ð½Ñ‹Ð¹ Discord ID");
      return;
    }

    setBusy(true);
    setErr("");
    try {
      await api("/admin/discord-assignments", {
        method: "POST",
        body: JSON.stringify({
          discord_id: idStr,
          login: assignLogin.trim() || undefined,
          role_name: assignRole,
          is_active: assignActive,
        }),
      });
      setAssignDiscordId("");
      setAssignLogin("");
      await reloadData();
    } catch (e: unknown) {
      setErr(errorText(e));
    } finally {
      setBusy(false);
    }
  }

  return (
    <main className="container">
      <div className="row" style={{ justifyContent: "space-between" }}>
        <div>
          <h1 className="title">Ð”Ð¾ÑÑ‚ÑƒÐ¿ Ð°Ð´Ð¼Ð¸Ð½Ð¾Ð²</h1>
          <div className="muted">{me ? `Ð’Ñ‹ Ð²Ð¾ÑˆÐ»Ð¸ ÐºÐ°Ðº: ${me.login} (${roleLabel(me.role_name)})` : "Ð—Ð°Ð³Ñ€ÑƒÐ·ÐºÐ°..."}</div>
        </div>
        <Link className="btn secondary" href="/players">
          Ðš ÑÐ¿Ð¸ÑÐºÑƒ Ð¸Ð³Ñ€Ð¾ÐºÐ¾Ð²
        </Link>
      </div>

      {err && <pre className="error">{err}</pre>}

      {!can(me, "admins.manage") ? (
        <section className="card" style={{ marginTop: 14 }}>
          <h3>ÐÐµÑ‚ Ð´Ð¾ÑÑ‚ÑƒÐ¿Ð°</h3>
          <p>Ð¢Ñ€ÐµÐ±ÑƒÐµÑ‚ÑÑ permission `admins.manage`.</p>
        </section>
      ) : (
        <>
          <section className="card" style={{ marginTop: 14 }}>
            <h3>Ð’Ñ‹Ð´Ð°Ñ‡Ð° Ñ€Ð¾Ð»Ð¸ Ð¿Ð¾ Discord ID</h3>
            <div className="small">Ð”Ð¾Ð±Ð°Ð²ÑŒ Discord ID, ÑƒÐºÐ°Ð¶Ð¸ login (Ð¾Ð¿Ñ†Ð¸Ð¾Ð½Ð°Ð»ÑŒÐ½Ð¾) Ð¸ Ñ€Ð¾Ð»ÑŒ Ð´Ð»Ñ Ð²Ñ…Ð¾Ð´Ð° Ñ‡ÐµÑ€ÐµÐ· Discord OAuth.</div>
            <div className="row" style={{ flexWrap: "wrap", marginTop: 10 }}>
              <input
                className="input"
                placeholder="discord id"
                value={assignDiscordId}
                onChange={(e) => setAssignDiscordId(e.target.value)}
                style={{ minWidth: 220 }}
              />
              <input
                className="input"
                placeholder="login (Ð¾Ð¿Ñ†Ð¸Ð¾Ð½Ð°Ð»ÑŒÐ½Ð¾)"
                value={assignLogin}
                onChange={(e) => setAssignLogin(e.target.value)}
                style={{ minWidth: 220 }}
              />
              <select className="input" value={assignRole} onChange={(e) => setAssignRole(e.target.value)}>
                {roleOptions.map((roleName) => (
                  <option key={`assign-${roleName}`} value={roleName}>
                    {roleLabel(roleName)} ({roleName})
                  </option>
                ))}
              </select>
              <label className="small" style={{ display: "flex", alignItems: "center", gap: 8 }}>
                <input type="checkbox" checked={assignActive} onChange={(e) => setAssignActive(e.target.checked)} />
                active
              </label>
              <button className="btn" disabled={busy || assignDiscordId.trim().length < 5} onClick={saveDiscordAssignment}>
                Ð¡Ð¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚ÑŒ
              </button>
            </div>

            <div className="tableWrap" style={{ marginTop: 10 }}>
              <table className="table">
                <thead>
                  <tr>
                    <th>Discord ID</th>
                    <th>Login</th>
                    <th>Role</th>
                    <th>Active</th>
                    <th>Updated</th>
                  </tr>
                </thead>
                <tbody>
                  {discordAssignments.map((row) => (
                    <tr key={`d-${row.id}`}>
                      <td>{row.discord_id ?? "-"}</td>
                      <td>{row.login}</td>
                      <td>{roleLabel(row.role_name)} ({row.role_name})</td>
                      <td>{row.is_active ? "yes" : "no"}</td>
                      <td>{String(row.updated_at || "")}</td>
                    </tr>
                  ))}
                  {discordAssignments.length === 0 && (
                    <tr>
                      <td colSpan={5}>ÐÐµÑ‚ Ð·Ð°Ð¿Ð¸ÑÐµÐ¹</td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </section>

          <section className="card" style={{ marginTop: 14 }}>
            <h3>Roles</h3>
            <div className="small">Ð’Ñ‹Ð±ÐµÑ€Ð¸Ñ‚Ðµ permissions Ñ‡ÐµÑ€ÐµÐ· Ñ‡ÐµÐºÐ±Ð¾ÐºÑÑ‹ Ð¸ ÑÐ¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚Ðµ role.</div>
            <div className="grid" style={{ marginTop: 10 }}>
              {roles.map((role) => (
                <article key={role.role_name} className="card">
                  <h4 style={{ marginBottom: 8 }}>
                    {roleLabel(role.role_name)} <span className="small">({role.role_name})</span>
                  </h4>
                  <div className="small" style={{ marginBottom: 8 }}>
                    Enabled: {(roleDrafts[role.role_name] || []).join(", ") || "none"}
                  </div>

                  {Object.entries(permissionGroups).map(([groupName, permissions]) => (
                    <div key={`${role.role_name}-${groupName}`} className="permGroup">
                      <div className="permGroupTitle">{groupName.toUpperCase()}</div>
                      <div className="permList">
                        {permissions.map((permission) => {
                          const selected = (roleDrafts[role.role_name] || []).includes(permission);
                          return (
                            <label key={`${role.role_name}-${permission}`} className="permItem">
                              <input
                                type="checkbox"
                                checked={selected}
                                onChange={() => toggleRolePermission(role.role_name, permission)}
                                disabled={busy}
                              />
                              <div>
                                <div className="permCode">{permission}</div>
                                <div className="small">
                                  {PERMISSION_DESCRIPTIONS[permission] || "ÐžÐ¿Ð¸ÑÐ°Ð½Ð¸Ðµ Ð´Ð»Ñ permission Ð½Ðµ Ð·Ð°Ð´Ð°Ð½Ð¾."}
                                </div>
                              </div>
                            </label>
                          );
                        })}
                      </div>
                    </div>
                  ))}

                  <div style={{ marginTop: 10 }}>
                    <button className="btn" disabled={busy} onClick={() => saveRole(role.role_name)}>
                      Ð¡Ð¾Ñ…Ñ€Ð°Ð½Ð¸Ñ‚ÑŒ permissions
                    </button>
                  </div>
                </article>
              ))}
            </div>
          </section>

          <section className="card" style={{ marginTop: 14 }}>
            <h3>ÐÐ´Ð¼Ð¸Ð½Ð¸ÑÑ‚Ñ€Ð°Ñ‚Ð¾Ñ€Ñ‹</h3>
            <div className="tableWrap">
              <table className="table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Login</th>
                    <th>Discord ID</th>
                    <th>Role</th>
                    <th>Active</th>
                    <th>Ð”ÐµÐ¹ÑÑ‚Ð²Ð¸Ñ</th>
                  </tr>
                </thead>
                <tbody>
                  {admins.map((adm) => (
                    <tr key={adm.id}>
                      <td>{adm.id}</td>
                      <td>{adm.login}</td>
                      <td>{adm.discord_id ?? "-"}</td>
                      <td>
                        <select
                          className="input"
                          value={adm.role_name}
                          onChange={(e) => patchAdmin(adm.id, { role_name: e.target.value })}
                          disabled={busy}
                        >
                          {roleOptions.map((roleName) => (
                            <option key={roleName} value={roleName}>
                              {roleLabel(roleName)} ({roleName})
                            </option>
                          ))}
                        </select>
                      </td>
                      <td>{adm.is_active ? "yes" : "no"}</td>
                      <td>
                        <button
                          className="btn secondary"
                          disabled={busy}
                          onClick={() => patchAdmin(adm.id, { is_active: !Boolean(adm.is_active) })}
                        >
                          {adm.is_active ? "Disable" : "Enable"}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </section>
        </>
      )}
    </main>
  );
}

