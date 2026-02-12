"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { AdminMe, api, can, fetchMe, roleLabel } from "@/lib/api";

type VariableDef = {
  key: string;
  label?: string;
  value_type: "string" | "number" | "boolean";
  required: boolean;
  default_value?: string | null;
};

type ActionType = "export" | "server_event" | "qbx_set_job" | "qbx_set_gang";

type TemplateRow = {
  id: number;
  name: string;
  description?: string | null;
  action_type: ActionType;
  resource_name?: string | null;
  action_name: string;
  variables: VariableDef[];
  allowed_roles?: string[];
  is_active: number | boolean;
  created_at: string;
  updated_at: string;
};

type TemplatesRes = {
  items: TemplateRow[];
};

type AllowedRolesRes = {
  items: string[];
};

type TemplateForm = {
  name: string;
  description: string;
  action_type: ActionType;
  resource_name: string;
  action_name: string;
  variables_json: string;
  allowed_roles: string[];
  is_active: boolean;
};

function errorText(e: unknown): string {
  return e instanceof Error ? e.message : String(e);
}

const DEFAULT_TEMPLATE: TemplateForm = {
  name: "",
  description: "",
  action_type: "export",
  resource_name: "ox_inventory",
  action_name: "AddItem",
  variables_json: JSON.stringify(
    [
      { key: "static_id", label: "Player ID", value_type: "number", required: true },
      { key: "item", label: "Item", value_type: "string", required: true },
      { key: "amount", label: "Amount", value_type: "number", required: true, default_value: "1" },
    ],
    null,
    2
  ),
  allowed_roles: [],
  is_active: true,
};

function toForm(row: TemplateRow): TemplateForm {
  return {
    name: row.name || "",
    description: row.description || "",
    action_type: row.action_type,
    resource_name: row.resource_name || "",
    action_name: row.action_name || "",
    variables_json: JSON.stringify(Array.isArray(row.variables) ? row.variables : [], null, 2),
    allowed_roles: Array.isArray(row.allowed_roles) ? row.allowed_roles : [],
    is_active: Boolean(row.is_active),
  };
}

function toggleRole(list: string[], role: string): string[] {
  return list.includes(role) ? list.filter((r) => r !== role) : [...list, role];
}

export default function GameActionsPage() {
  const [me, setMe] = useState<AdminMe | null>(null);
  const [items, setItems] = useState<TemplateRow[]>([]);
  const [allowedRoles, setAllowedRoles] = useState<string[]>([]);
  const [err, setErr] = useState("");
  const [busy, setBusy] = useState(false);
  const [form, setForm] = useState<TemplateForm>(DEFAULT_TEMPLATE);
  const [editById, setEditById] = useState<Record<number, TemplateForm>>({});

  const canManage = can(me, "actions.manage_templates");

  async function load() {
    setErr("");
    try {
      const current = await fetchMe();
      setMe(current);
      if (!can(current, "players.game_interact")) {
        return;
      }

      const [res, rolesRes] = await Promise.all([
        api<TemplatesRes>("/game-actions/templates"),
        can(current, "actions.manage_templates")
          ? api<AllowedRolesRes>("/game-actions/allowed-roles")
          : Promise.resolve({ items: [] }),
      ]);
      setItems(res.items || []);
      setAllowedRoles(rolesRes.items || []);
    } catch (e: unknown) {
      setErr(errorText(e));
    }
  }

  useEffect(() => {
    void load();
  }, []);

  const sorted = useMemo(() => {
    return [...items].sort((a, b) => Number(b.id) - Number(a.id));
  }, [items]);

  async function createTemplate() {
    setBusy(true);
    setErr("");
    try {
      let variables: VariableDef[] = [];
      if (form.variables_json.trim()) {
        const parsed = JSON.parse(form.variables_json);
        if (!Array.isArray(parsed)) throw new Error("variables must be an array");
        variables = parsed;
      }

      await api("/game-actions/templates", {
        method: "POST",
        body: JSON.stringify({
          name: form.name.trim(),
          description: form.description.trim() || null,
          action_type: form.action_type,
          resource_name: form.action_type === "export" ? form.resource_name.trim() : null,
          action_name: form.action_name.trim(),
          variables,
          allowed_roles: form.allowed_roles,
          is_active: form.is_active,
        }),
      });

      setForm(DEFAULT_TEMPLATE);
      await load();
    } catch (e: unknown) {
      setErr(errorText(e));
    } finally {
      setBusy(false);
    }
  }

  async function toggleTemplate(row: TemplateRow) {
    setBusy(true);
    setErr("");
    try {
      await api(`/game-actions/templates/${row.id}`, {
        method: "PATCH",
        body: JSON.stringify({ is_active: !Boolean(row.is_active) }),
      });
      await load();
    } catch (e: unknown) {
      setErr(errorText(e));
    } finally {
      setBusy(false);
    }
  }

  async function deleteTemplate(row: TemplateRow) {
    if (!confirm(`Delete template \"${row.name}\"?`)) return;
    setBusy(true);
    setErr("");
    try {
      await api(`/game-actions/templates/${row.id}`, { method: "DELETE" });
      await load();
    } catch (e: unknown) {
      setErr(errorText(e));
    } finally {
      setBusy(false);
    }
  }

  function startEdit(row: TemplateRow) {
    setEditById((prev) => ({ ...prev, [row.id]: toForm(row) }));
  }

  function cancelEdit(id: number) {
    setEditById((prev) => {
      const next = { ...prev };
      delete next[id];
      return next;
    });
  }

  async function saveEdit(id: number) {
    const edit = editById[id];
    if (!edit) return;

    setBusy(true);
    setErr("");
    try {
      let variables: VariableDef[] = [];
      if (edit.variables_json.trim()) {
        const parsed = JSON.parse(edit.variables_json);
        if (!Array.isArray(parsed)) throw new Error("variables must be an array");
        variables = parsed;
      }

      await api(`/game-actions/templates/${id}`, {
        method: "PATCH",
        body: JSON.stringify({
          name: edit.name.trim(),
          description: edit.description.trim() || null,
          action_type: edit.action_type,
          resource_name: edit.action_type === "export" ? edit.resource_name.trim() : null,
          action_name: edit.action_name.trim(),
          variables,
          allowed_roles: edit.allowed_roles,
          is_active: edit.is_active,
        }),
      });

      cancelEdit(id);
      await load();
    } catch (e: unknown) {
      setErr(errorText(e));
    } finally {
      setBusy(false);
    }
  }

  return (
    <main className="container">
      <header className="card" style={{ marginBottom: 14 }}>
        <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap" }}>
          <div>
            <h1 className="title" style={{ marginBottom: 6 }}>
              In-game templates
            </h1>
            <div className="muted">{me ? `You: ${me.login} (${roleLabel(me.role_name)})` : "Checking auth..."}</div>
          </div>
          <div className="row" style={{ flexWrap: "wrap" }}>
            <Link className="btn secondary" href="/">
              Home
            </Link>
            <Link className="btn secondary" href="/players">
              Players
            </Link>
          </div>
        </div>
      </header>

      {err && <pre className="error">{err}</pre>}

      {!can(me, "players.game_interact") ? (
        <section className="card">
          <h3 style={{ marginTop: 0 }}>No access</h3>
          <p className="muted">Permission `players.game_interact` is required.</p>
        </section>
      ) : (
        <>
          {canManage && (
            <section className="card">
              <h3 style={{ marginTop: 0 }}>New template</h3>
              <div className="metaGrid" style={{ marginTop: 8 }}>
                <div>
                  <label className="metaKey">Name</label>
                  <input className="input" value={form.name} onChange={(e) => setForm((s) => ({ ...s, name: e.target.value }))} />
                </div>
                <div>
                  <label className="metaKey">Action type</label>
                  <select
                    className="input"
                    value={form.action_type}
                    onChange={(e) => setForm((s) => ({ ...s, action_type: e.target.value as ActionType }))}
                  >
                    <option value="export">export</option>
                    <option value="server_event">server_event</option>
                    <option value="qbx_set_job">qbx_set_job</option>
                    <option value="qbx_set_gang">qbx_set_gang</option>
                  </select>
                </div>
                <div>
                  <label className="metaKey">resource_name</label>
                  <input
                    className="input"
                    value={form.resource_name}
                    onChange={(e) => setForm((s) => ({ ...s, resource_name: e.target.value }))}
                    disabled={form.action_type !== "export"}
                  />
                </div>
                <div>
                  <label className="metaKey">action_name</label>
                  <input className="input" value={form.action_name} onChange={(e) => setForm((s) => ({ ...s, action_name: e.target.value }))} />
                </div>
              </div>

              <div style={{ marginTop: 10 }}>
                <label className="metaKey">Description</label>
                <input className="input" value={form.description} onChange={(e) => setForm((s) => ({ ...s, description: e.target.value }))} />
              </div>

              <div style={{ marginTop: 10 }}>
                <label className="metaKey">variables (JSON array)</label>
                <textarea
                  className="input"
                  style={{ width: "100%", minHeight: 160, resize: "vertical" }}
                  value={form.variables_json}
                  onChange={(e) => setForm((s) => ({ ...s, variables_json: e.target.value }))}
                />
              </div>

              <div style={{ marginTop: 10 }}>
                <label className="metaKey">Allowed roles</label>
                {allowedRoles.length === 0 ? (
                  <div className="small muted">Empty means all roles with `players.game_interact` can use.</div>
                ) : (
                  <div className="row" style={{ flexWrap: "wrap", marginTop: 6 }}>
                    {allowedRoles.map((role) => (
                      <label key={`new-role-${role}`} className="small" style={{ display: "flex", alignItems: "center", gap: 6 }}>
                        <input
                          type="checkbox"
                          checked={form.allowed_roles.includes(role)}
                          onChange={() => setForm((s) => ({ ...s, allowed_roles: toggleRole(s.allowed_roles, role) }))}
                        />
                        {role}
                      </label>
                    ))}
                  </div>
                )}
              </div>

              <label className="small" style={{ display: "flex", alignItems: "center", gap: 8, marginTop: 8 }}>
                <input type="checkbox" checked={form.is_active} onChange={(e) => setForm((s) => ({ ...s, is_active: e.target.checked }))} />
                Active
              </label>

              <div style={{ marginTop: 10 }}>
                <button className="btn" disabled={busy || form.name.trim().length < 2 || form.action_name.trim().length < 1} onClick={createTemplate}>
                  Create template
                </button>
              </div>
            </section>
          )}

          <section className="card" style={{ marginTop: 12 }}>
            <h3 style={{ marginTop: 0 }}>Existing templates</h3>
            {sorted.length === 0 ? (
              <p className="muted">No templates yet.</p>
            ) : (
              <div className="grid" style={{ marginTop: 8 }}>
                {sorted.map((row) => {
                  const edit = editById[row.id];
                  return (
                    <article key={row.id} className="card">
                      <div className="row" style={{ justifyContent: "space-between", alignItems: "start" }}>
                        <div>
                          <strong>{row.name}</strong>
                          <div className="small">ID: {row.id}</div>
                        </div>
                        <span className="small">{row.is_active ? "active" : "inactive"}</span>
                      </div>
                      <div className="small" style={{ marginTop: 6 }}>{row.description || "No description"}</div>
                      <div className="small" style={{ marginTop: 6 }}>
                        {row.action_type}
                        {row.resource_name ? ` | ${row.resource_name}` : ""} | {row.action_name}
                      </div>
                      <div className="small" style={{ marginTop: 6 }}>Variables: {Array.isArray(row.variables) ? row.variables.length : 0}</div>
                      <div className="small" style={{ marginTop: 6 }}>
                        Roles: {Array.isArray(row.allowed_roles) && row.allowed_roles.length > 0 ? row.allowed_roles.join(", ") : "all"}
                      </div>

                      {Array.isArray(row.variables) && row.variables.length > 0 && (
                        <details style={{ marginTop: 6 }}>
                          <summary className="small">Show variables</summary>
                          <pre style={{ marginTop: 6, whiteSpace: "pre-wrap" }}>{JSON.stringify(row.variables, null, 2)}</pre>
                        </details>
                      )}

                      {canManage && (
                        <div className="row" style={{ marginTop: 8, flexWrap: "wrap" }}>
                          <button className="btn" onClick={() => (edit ? cancelEdit(row.id) : startEdit(row))} disabled={busy}>
                            {edit ? "Close edit" : "Edit"}
                          </button>
                          <button className="btn secondary" onClick={() => toggleTemplate(row)} disabled={busy}>
                            {row.is_active ? "Deactivate" : "Activate"}
                          </button>
                          <button className="btn danger" onClick={() => deleteTemplate(row)} disabled={busy}>
                            Delete
                          </button>
                        </div>
                      )}

                      {canManage && edit && (
                        <div style={{ marginTop: 10, borderTop: "1px solid #2a3346", paddingTop: 10 }}>
                          <div className="metaGrid">
                            <div>
                              <label className="metaKey">Name</label>
                              <input
                                className="input"
                                value={edit.name}
                                onChange={(e) => setEditById((prev) => ({ ...prev, [row.id]: { ...prev[row.id], name: e.target.value } }))}
                              />
                            </div>
                            <div>
                              <label className="metaKey">Action type</label>
                              <select
                                className="input"
                                value={edit.action_type}
                                onChange={(e) =>
                                  setEditById((prev) => ({
                                    ...prev,
                                    [row.id]: { ...prev[row.id], action_type: e.target.value as ActionType },
                                  }))
                                }
                              >
                                <option value="export">export</option>
                                <option value="server_event">server_event</option>
                                <option value="qbx_set_job">qbx_set_job</option>
                                <option value="qbx_set_gang">qbx_set_gang</option>
                              </select>
                            </div>
                            <div>
                              <label className="metaKey">resource_name</label>
                              <input
                                className="input"
                                value={edit.resource_name}
                                disabled={edit.action_type !== "export"}
                                onChange={(e) =>
                                  setEditById((prev) => ({ ...prev, [row.id]: { ...prev[row.id], resource_name: e.target.value } }))
                                }
                              />
                            </div>
                            <div>
                              <label className="metaKey">action_name</label>
                              <input
                                className="input"
                                value={edit.action_name}
                                onChange={(e) =>
                                  setEditById((prev) => ({ ...prev, [row.id]: { ...prev[row.id], action_name: e.target.value } }))
                                }
                              />
                            </div>
                          </div>

                          <div style={{ marginTop: 8 }}>
                            <label className="metaKey">Description</label>
                            <input
                              className="input"
                              value={edit.description}
                              onChange={(e) =>
                                setEditById((prev) => ({ ...prev, [row.id]: { ...prev[row.id], description: e.target.value } }))
                              }
                            />
                          </div>

                          <div style={{ marginTop: 8 }}>
                            <label className="metaKey">variables (JSON array)</label>
                            <textarea
                              className="input"
                              style={{ width: "100%", minHeight: 140, resize: "vertical" }}
                              value={edit.variables_json}
                              onChange={(e) =>
                                setEditById((prev) => ({ ...prev, [row.id]: { ...prev[row.id], variables_json: e.target.value } }))
                              }
                            />
                          </div>

                          <div style={{ marginTop: 8 }}>
                            <label className="metaKey">Allowed roles</label>
                            {allowedRoles.length === 0 ? (
                              <div className="small muted">Empty means all roles with `players.game_interact` can use.</div>
                            ) : (
                              <div className="row" style={{ flexWrap: "wrap", marginTop: 6 }}>
                                {allowedRoles.map((role) => (
                                  <label key={`edit-${row.id}-${role}`} className="small" style={{ display: "flex", alignItems: "center", gap: 6 }}>
                                    <input
                                      type="checkbox"
                                      checked={edit.allowed_roles.includes(role)}
                                      onChange={() =>
                                        setEditById((prev) => ({
                                          ...prev,
                                          [row.id]: { ...prev[row.id], allowed_roles: toggleRole(prev[row.id].allowed_roles, role) },
                                        }))
                                      }
                                    />
                                    {role}
                                  </label>
                                ))}
                              </div>
                            )}
                          </div>

                          <label className="small" style={{ display: "flex", alignItems: "center", gap: 8, marginTop: 8 }}>
                            <input
                              type="checkbox"
                              checked={edit.is_active}
                              onChange={(e) =>
                                setEditById((prev) => ({ ...prev, [row.id]: { ...prev[row.id], is_active: e.target.checked } }))
                              }
                            />
                            Active
                          </label>

                          <div className="row" style={{ marginTop: 8, flexWrap: "wrap" }}>
                            <button className="btn" onClick={() => saveEdit(row.id)} disabled={busy}>
                              Save
                            </button>
                            <button className="btn secondary" onClick={() => cancelEdit(row.id)} disabled={busy}>
                              Cancel
                            </button>
                          </div>
                        </div>
                      )}
                    </article>
                  );
                })}
              </div>
            )}
          </section>
        </>
      )}
    </main>
  );
}
