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

type TemplateRow = {
  id: number;
  name: string;
  description?: string | null;
  action_type: "export" | "server_event" | "qbx_set_job";
  resource_name?: string | null;
  action_name: string;
  variables: VariableDef[];
  is_active: number | boolean;
  created_at: string;
  updated_at: string;
};

type TemplatesRes = {
  items: TemplateRow[];
};

type NewTemplateForm = {
  name: string;
  description: string;
  action_type: "export" | "server_event" | "qbx_set_job";
  resource_name: string;
  action_name: string;
  variables_json: string;
  is_active: boolean;
};

function errorText(e: unknown): string {
  return e instanceof Error ? e.message : String(e);
}

const DEFAULT_TEMPLATE: NewTemplateForm = {
  name: "",
  description: "",
  action_type: "export",
  resource_name: "ox_inventory",
  action_name: "AddItem",
  variables_json: JSON.stringify(
    [
      { key: "static_id", label: "ID игрока", value_type: "number", required: true },
      { key: "item", label: "Item", value_type: "string", required: true },
      { key: "amount", label: "Количество", value_type: "number", required: true, default_value: "1" },
    ],
    null,
    2
  ),
  is_active: true,
};

export default function GameActionsPage() {
  const [me, setMe] = useState<AdminMe | null>(null);
  const [items, setItems] = useState<TemplateRow[]>([]);
  const [err, setErr] = useState("");
  const [busy, setBusy] = useState(false);
  const [form, setForm] = useState<NewTemplateForm>(DEFAULT_TEMPLATE);

  const canManage = can(me, "actions.manage_templates");

  async function load() {
    setErr("");
    try {
      const current = await fetchMe();
      setMe(current);
      if (!can(current, "players.game_interact")) {
        return;
      }
      const res = await api<TemplatesRes>("/game-actions/templates");
      setItems(res.items || []);
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
        if (!Array.isArray(parsed)) throw new Error("variables должен быть массивом");
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
    if (!confirm(`Деактивировать шаблон "${row.name}"?`)) return;
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

  return (
    <main className="container">
      <header className="card" style={{ marginBottom: 14 }}>
        <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap" }}>
          <div>
            <h1 className="title" style={{ marginBottom: 6 }}>
              Внутриигровые шаблоны
            </h1>
            <div className="muted">{me ? `Вы: ${me.login} (${roleLabel(me.role_name)})` : "Проверка авторизации..."}</div>
          </div>
          <div className="row" style={{ flexWrap: "wrap" }}>
            <Link className="btn secondary" href="/">
              Главная
            </Link>
            <Link className="btn secondary" href="/players">
              Поиск игроков
            </Link>
          </div>
        </div>
      </header>

      {err && <pre className="error">{err}</pre>}

      {!can(me, "players.game_interact") ? (
        <section className="card">
          <h3 style={{ marginTop: 0 }}>Нет доступа</h3>
          <p className="muted">Требуется permission `players.game_interact`.</p>
        </section>
      ) : (
        <>
          {canManage && (
            <section className="card">
              <h3 style={{ marginTop: 0 }}>Новый шаблон</h3>
              <div className="metaGrid" style={{ marginTop: 8 }}>
                <div>
                  <label className="metaKey">Название</label>
                  <input
                    className="input"
                    value={form.name}
                    onChange={(e) => setForm((s) => ({ ...s, name: e.target.value }))}
                    placeholder="Выдать item"
                  />
                </div>
                <div>
                  <label className="metaKey">Тип действия</label>
                  <select
                    className="input"
                    value={form.action_type}
                    onChange={(e) =>
                      setForm((s) => ({ ...s, action_type: e.target.value as NewTemplateForm["action_type"] }))
                    }
                  >
                    <option value="export">export</option>
                    <option value="server_event">server_event</option>
                    <option value="qbx_set_job">qbx_set_job</option>
                  </select>
                </div>
                <div>
                  <label className="metaKey">resource_name (для export)</label>
                  <input
                    className="input"
                    value={form.resource_name}
                    onChange={(e) => setForm((s) => ({ ...s, resource_name: e.target.value }))}
                    placeholder="ox_inventory"
                    disabled={form.action_type !== "export"}
                  />
                </div>
                <div>
                  <label className="metaKey">action_name</label>
                  <input
                    className="input"
                    value={form.action_name}
                    onChange={(e) => setForm((s) => ({ ...s, action_name: e.target.value }))}
                    placeholder="AddItem / some:event / SetJob"
                  />
                </div>
              </div>

              <div style={{ marginTop: 10 }}>
                <label className="metaKey">Описание</label>
                <input
                  className="input"
                  value={form.description}
                  onChange={(e) => setForm((s) => ({ ...s, description: e.target.value }))}
                  placeholder="Короткое описание кнопки"
                />
              </div>

              <div style={{ marginTop: 10 }}>
                <label className="metaKey">variables (JSON массив)</label>
                <textarea
                  className="input"
                  style={{ width: "100%", minHeight: 160, resize: "vertical" }}
                  value={form.variables_json}
                  onChange={(e) => setForm((s) => ({ ...s, variables_json: e.target.value }))}
                />
              </div>

              <label className="small" style={{ display: "flex", alignItems: "center", gap: 8, marginTop: 8 }}>
                <input
                  type="checkbox"
                  checked={form.is_active}
                  onChange={(e) => setForm((s) => ({ ...s, is_active: e.target.checked }))}
                />
                Активный шаблон
              </label>

              <div style={{ marginTop: 10 }}>
                <button
                  className="btn"
                  disabled={busy || form.name.trim().length < 2 || form.action_name.trim().length < 1}
                  onClick={createTemplate}
                >
                  Создать шаблон
                </button>
              </div>
            </section>
          )}

          <section className="card" style={{ marginTop: 12 }}>
            <h3 style={{ marginTop: 0 }}>Существующие шаблоны</h3>
            {sorted.length === 0 ? (
              <p className="muted">Шаблонов пока нет.</p>
            ) : (
              <div className="grid" style={{ marginTop: 8 }}>
                {sorted.map((row) => (
                  <article key={row.id} className="card">
                    <div className="row" style={{ justifyContent: "space-between", alignItems: "start" }}>
                      <div>
                        <strong>{row.name}</strong>
                        <div className="small">ID: {row.id}</div>
                      </div>
                      <span className="small">{row.is_active ? "active" : "inactive"}</span>
                    </div>
                    <div className="small" style={{ marginTop: 6 }}>
                      {row.description || "Без описания"}
                    </div>
                    <div className="small" style={{ marginTop: 6 }}>
                      {row.action_type}
                      {row.resource_name ? ` | ${row.resource_name}` : ""} | {row.action_name}
                    </div>
                    <div className="small" style={{ marginTop: 6 }}>
                      Переменных: {Array.isArray(row.variables) ? row.variables.length : 0}
                    </div>
                    {Array.isArray(row.variables) && row.variables.length > 0 && (
                      <details style={{ marginTop: 6 }}>
                        <summary className="small">Показать variables</summary>
                        <pre style={{ marginTop: 6, whiteSpace: "pre-wrap" }}>{JSON.stringify(row.variables, null, 2)}</pre>
                      </details>
                    )}

                    {canManage && (
                      <div className="row" style={{ marginTop: 8, flexWrap: "wrap" }}>
                        <button className="btn secondary" onClick={() => toggleTemplate(row)} disabled={busy}>
                          {row.is_active ? "Деактивировать" : "Активировать"}
                        </button>
                        <button className="btn danger" onClick={() => deleteTemplate(row)} disabled={busy}>
                          Удалить
                        </button>
                      </div>
                    )}
                  </article>
                ))}
              </div>
            )}
          </section>
        </>
      )}
    </main>
  );
}

