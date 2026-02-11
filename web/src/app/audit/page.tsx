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

function pretty(v: unknown): string {
  if (v === null || v === undefined) return "-";
  if (typeof v === "string") return v;
  try {
    return JSON.stringify(v, null, 2);
  } catch {
    return String(v);
  }
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
                  <col style={{ width: "calc((100% - 580px) / 2)" }} />
                  <col style={{ width: "calc((100% - 580px) / 2)" }} />
                </colgroup>
                <thead>
                  <tr>
                    <th className="auditNowrap">ID</th>
                    <th className="auditNowrap">Время</th>
                    <th className="auditNowrap">Админ</th>
                    <th className="auditNowrap">Действие</th>
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
                      <td className="auditNowrap">{row.action}</td>
                      <td className="auditJson">
                        <pre style={{ margin: 0, whiteSpace: "pre-wrap" }}>{pretty(row.target_json)}</pre>
                      </td>
                      <td className="auditJson">
                        <pre style={{ margin: 0, whiteSpace: "pre-wrap" }}>{pretty(row.payload_json)}</pre>
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
