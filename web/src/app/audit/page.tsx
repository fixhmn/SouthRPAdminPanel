"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { AdminMe, api, can, fetchMe, roleLabel } from "@/lib/api";

type AuditRow = {
  id: number;
  ts: string;
  admin_tag: string;
  action: string;
  target_json: unknown;
  payload_json: unknown;
};

type AuditRes = {
  items: AuditRow[];
  admin: string;
};

function parseMaybeJsonObject(v: unknown): Record<string, unknown> {
  if (!v) return {};
  if (typeof v === "object" && !Array.isArray(v)) return v as Record<string, unknown>;
  if (typeof v !== "string") return {};
  try {
    const parsed = JSON.parse(v);
    return parsed && typeof parsed === "object" && !Array.isArray(parsed)
      ? (parsed as Record<string, unknown>)
      : {};
  } catch {
    return {};
  }
}

function pretty(v: unknown): string {
  if (v === null || v === undefined) return "-";
  if (typeof v === "string") return v;
  try {
    return JSON.stringify(v, null, 2);
  } catch {
    return String(v);
  }
}

function actionLabel(action: string): string {
  const map: Record<string, string> = {
    ADD_WL: "Добавил WL",
    REMOVE_WL: "Убрал WL",
    BULK_ADD_WL: "Массово добавил WL",
    BAN_WL: "Выдал WL-бан",
    UNBAN_WL: "Снял WL-бан",
    SET_SLOTS: "Изменил слоты",
    EDIT_PROFILE: "Изменил профиль",
    DELETE_CHAR: "Удалил персонажа",
    VEHICLE_EDIT: "Изменил машину",
    ADMIN_CREATE: "Создал админа",
    ADMIN_PATCH: "Изменил админа",
    ADMIN_DEACTIVATE: "Деактивировал админа",
    ROLE_REPLACE_PERMISSIONS: "Изменил permissions роли",
    DISCORD_ASSIGN_ROLE: "Назначил роль Discord ID",
  };
  return map[action] || action;
}

function summarizeChange(row: AuditRow): string {
  const target = parseMaybeJsonObject(row.target_json);
  const payload = parseMaybeJsonObject(row.payload_json);
  const action = row.action;

  if (action === "BULK_ADD_WL") {
    const updated = Array.isArray(payload.updated) ? payload.updated.join(", ") : "-";
    const notFound = Array.isArray(payload.not_found) ? payload.not_found.join(", ") : "-";
    return `WL добавлен static_id: [${updated}] | не найдены: [${notFound}]`;
  }

  if (action === "ADD_WL" || action === "REMOVE_WL" || action === "BAN_WL" || action === "UNBAN_WL") {
    const citizenid = String(target.citizenid ?? "-");
    const staticId = String(target.static_id ?? payload.static_id ?? "-");
    const days = payload.days ?? payload.duration_days;
    if (action === "BAN_WL") {
      return `CitizenID: ${citizenid}, static_id: ${staticId}, дней: ${String(days ?? "-")}`;
    }
    return `CitizenID: ${citizenid}, static_id: ${staticId}`;
  }

  if (action === "SET_SLOTS") {
    return `CitizenID: ${String(target.citizenid ?? "-")}, слоты: ${String(payload.slots ?? "-")} (${String(payload.action ?? "updated")})`;
  }

  if (action === "EDIT_PROFILE") {
    const changed = Object.keys(payload);
    return `CitizenID: ${String(target.citizenid ?? "-")}, поля: ${changed.join(", ") || "-"}`;
  }

  if (action === "DELETE_CHAR") {
    return `Удален персонаж CitizenID: ${String(target.citizenid ?? "-")}`;
  }

  if (action === "VEHICLE_EDIT") {
    const changed = Object.keys(payload);
    return `Vehicle ID: ${String(target.vehicle_id ?? "-")}, поля: ${changed.join(", ") || "-"}`;
  }

  if (action === "ADMIN_CREATE") {
    return `Admin ID: ${String(target.admin_id ?? "-")}, login: ${String(payload.login ?? "-")}, role: ${String(payload.role_name ?? "-")}`;
  }

  if (action === "ADMIN_PATCH") {
    const changed = Object.keys(payload);
    return `Admin ID: ${String(target.admin_id ?? "-")}, поля: ${changed.join(", ") || "-"}`;
  }

  if (action === "ADMIN_DEACTIVATE") {
    return `Admin ID: ${String(target.admin_id ?? "-")} деактивирован`;
  }

  if (action === "ROLE_REPLACE_PERMISSIONS") {
    const perms = Array.isArray(payload.permissions) ? payload.permissions.length : 0;
    return `Role: ${String(target.role_name ?? "-")}, permissions: ${String(perms)}`;
  }

  if (action === "DISCORD_ASSIGN_ROLE") {
    return `Discord ID: ${String(target.discord_id ?? "-")}, role: ${String(payload.role_name ?? "-")}, active: ${String(payload.is_active ?? "-")}`;
  }

  return "Детали в Target/Payload";
}

export default function AuditPage() {
  const [me, setMe] = useState<AdminMe | null>(null);
  const [rows, setRows] = useState<AuditRow[]>([]);
  const [limit, setLimit] = useState(50);
  const [filter, setFilter] = useState("");
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(false);

  async function load(selectedLimit: number) {
    setLoading(true);
    setErr("");
    try {
      const current = await fetchMe();
      setMe(current);
      if (!can(current, "audit.read")) return;

      const data = await api<AuditRes>(`/audit?limit=${selectedLimit}`);
      setRows(data.items || []);
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    void load(limit);
  }, [limit]);

  const filtered = useMemo(() => {
    const q = filter.trim().toLowerCase();
    if (!q) return rows;

    return rows.filter((row) => {
      const blob = [
        String(row.id),
        String(row.ts),
        String(row.admin_tag),
        String(row.action),
        pretty(row.target_json),
        pretty(row.payload_json),
      ]
        .join(" ")
        .toLowerCase();
      return blob.includes(q);
    });
  }, [rows, filter]);

  return (
    <main className="container">
      <header className="card" style={{ marginBottom: 14 }}>
        <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap" }}>
          <div>
            <h1 className="title" style={{ marginBottom: 6 }}>
              Журнал аудита
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
            {can(me, "vehicles.read") && (
              <Link className="btn secondary" href="/vehicles">
                Поиск машин
              </Link>
            )}
          </div>
        </div>
      </header>

      {err && <pre className="error">{err}</pre>}

      {!can(me, "audit.read") ? (
        <section className="card">
          <h3 style={{ marginTop: 0 }}>Нет доступа</h3>
          <p className="muted">Требуется permission `audit.read`.</p>
        </section>
      ) : (
        <>
          <section className="card">
            <div className="row" style={{ flexWrap: "wrap" }}>
              <label className="small" htmlFor="audit-limit">
                Кол-во записей
              </label>
              <select
                id="audit-limit"
                className="input"
                value={limit}
                onChange={(e) => setLimit(parseInt(e.target.value, 10))}
              >
                <option value={25}>25</option>
                <option value={50}>50</option>
                <option value={100}>100</option>
                <option value={200}>200</option>
              </select>

              <input
                className="input"
                placeholder="Фильтр: action/admin/citizenid..."
                value={filter}
                onChange={(e) => setFilter(e.target.value)}
                style={{ flex: 1, minWidth: 220 }}
              />

              <button className="btn" onClick={() => load(limit)} disabled={loading}>
                {loading ? "Загрузка..." : "Обновить"}
              </button>
            </div>
          </section>

          <section className="card" style={{ marginTop: 12 }}>
            <div className="small" style={{ marginBottom: 8 }}>
              Показано записей: {filtered.length}
            </div>
            <div className="tableWrap">
              <table className="table auditTable">
                <colgroup>
                  <col style={{ width: 70 }} />
                  <col style={{ width: 190 }} />
                  <col style={{ width: 140 }} />
                  <col style={{ width: 180 }} />
                  <col style={{ width: "calc((100% - 580px) / 3)" }} />
                  <col style={{ width: "calc((100% - 580px) / 3)" }} />
                  <col style={{ width: "calc((100% - 580px) / 3)" }} />
                </colgroup>
                <thead>
                  <tr>
                    <th className="auditNowrap">ID</th>
                    <th className="auditNowrap">Время</th>
                    <th className="auditNowrap">Админ</th>
                    <th className="auditNowrap">Действие</th>
                    <th>Что изменено</th>
                    <th>Target</th>
                    <th>Payload</th>
                  </tr>
                </thead>
                <tbody>
                  {filtered.map((row) => (
                    <tr key={row.id}>
                      <td className="auditNowrap">{row.id}</td>
                      <td className="auditNowrap">{row.ts}</td>
                      <td className="auditNowrap">{row.admin_tag}</td>
                      <td className="auditNowrap">{actionLabel(row.action)}</td>
                      <td className="auditJson">{summarizeChange(row)}</td>
                      <td className="auditJson">
                        <details>
                          <summary className="small">Показать Target</summary>
                          <pre style={{ margin: 0, whiteSpace: "pre-wrap" }}>{pretty(row.target_json)}</pre>
                        </details>
                      </td>
                      <td className="auditJson">
                        <details>
                          <summary className="small">Показать Payload</summary>
                          <pre style={{ margin: 0, whiteSpace: "pre-wrap" }}>{pretty(row.payload_json)}</pre>
                        </details>
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
