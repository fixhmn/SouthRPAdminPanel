"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { AdminMe, api, can, clearToken, fetchMe, roleLabel } from "@/lib/api";

type SearchRes = {
  count: number;
  items: Array<{
    citizenid: string;
    name?: string;
    static_id?: number;
    discord_id?: number;
    firstname?: string;
    lastname?: string;
    phone?: string;
    online?: boolean;
    online_source?: number;
    online_citizenid?: string | null;
  }>;
};

export default function Players() {
  const [field, setField] = useState("static_id");
  const [q, setQ] = useState("");
  const [data, setData] = useState<SearchRes | null>(null);
  const [wlBulkMode, setWlBulkMode] = useState<"add" | "remove">("add");
  const [wlBulkText, setWlBulkText] = useState("");
  const [wlBulkResult, setWlBulkResult] = useState<{ updated: number[]; not_found: number[] } | null>(null);
  const [me, setMe] = useState<AdminMe | null>(null);
  const [err, setErr] = useState("");

  useEffect(() => {
    fetchMe().then(setMe).catch(() => setMe(null));
  }, []);

  async function run() {
    setErr("");
    setData(null);
    try {
      const res = await api<SearchRes>(
        `/players/search?field=${encodeURIComponent(field)}&q=${encodeURIComponent(q)}`
      );
      setData(res);
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    }
  }

  async function runBulkWl() {
    setErr("");
    setWlBulkResult(null);
    try {
      const ids = (wlBulkText.match(/\d+/g) || []).map((x) => Number(x)).filter((x) => Number.isFinite(x) && x > 0);
      if (ids.length === 0) {
        setErr("Укажи хотя бы один static_id.");
        return;
      }
      const endpoint = wlBulkMode === "add" ? "/wl/add-by-static-ids" : "/wl/remove-by-static-ids";
      const res = await api<{ ok: boolean; updated: number[]; not_found: number[] }>(endpoint, {
        method: "POST",
        body: JSON.stringify({ static_ids: ids }),
      });
      setWlBulkResult({ updated: res.updated || [], not_found: res.not_found || [] });
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    }
  }

  function logout() {
    clearToken();
    window.location.href = "/";
  }

  return (
    <main className="container">
      <header className="card" style={{ marginBottom: 14 }}>
        <div className="row" style={{ justifyContent: "space-between" }}>
          <div>
            <h1 className="title" style={{ marginBottom: 6 }}>
              Поиск игроков
            </h1>
            <div className="muted">
              {me ? `Вы: ${me.login} (${roleLabel(me.role_name)})` : "Добавьте токен администратора в браузере"}
            </div>
          </div>
          <div className="row">
            <Link className="btn secondary" href="/">
              Главная
            </Link>
            {can(me, "players.read") && (
              <Link className="btn secondary" href="/players/online">
                Онлайн
              </Link>
            )}
            {can(me, "vehicles.read") && (
              <Link className="btn secondary" href="/vehicles">
                Поиск машин
              </Link>
            )}
            {can(me, "audit.read") && (
              <Link className="btn secondary" href="/audit">
                Журнал аудита
              </Link>
            )}
            {can(me, "actions.manage_templates") && (
              <Link className="btn secondary" href="/game-actions">
                Шаблоны
              </Link>
            )}
            <button className="btn secondary" onClick={logout}>
              Выйти
            </button>
            {can(me, "admins.manage") && (
              <Link className="btn secondary" href="/admins">
                Админы и роли
              </Link>
            )}
          </div>
        </div>
      </header>

      <section className="card">
        <div className="row">
          <select value={field} onChange={(e) => setField(e.target.value)} className="input" style={{ maxWidth: 180 }}>
            <option value="license">license</option>
            <option value="static_id">static_id</option>
            <option value="name">name</option>
            <option value="citizenid">citizenid</option>
            <option value="firstname">firstname</option>
            <option value="lastname">lastname</option>
            <option value="fullname">fullname</option>
            <option value="discord_id">discord_id</option>
            <option value="phone">phone</option>
          </select>

          <input
            value={q}
            onChange={(e) => setQ(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                e.preventDefault();
                void run();
              }
            }}
            placeholder="Запрос"
            className="input"
            style={{ flex: 1 }}
          />
          <button onClick={run} className="btn" disabled={!can(me, "players.read")}>
            Найти
          </button>
        </div>
      </section>

      {can(me, "players.manage_wl") && (
        <section className="card" style={{ marginTop: 14 }}>
          <h3 style={{ marginTop: 0 }}>Массовый WL по static_id</h3>
          <div className="small" style={{ marginBottom: 8 }}>
            Вставь список ID через пробел, запятую или новую строку.
          </div>
          <div className="row" style={{ marginBottom: 8 }}>
            <select
              className="input"
              value={wlBulkMode}
              onChange={(e) => setWlBulkMode(e.target.value as "add" | "remove")}
              style={{ maxWidth: 220 }}
            >
              <option value="add">Добавить в WL</option>
              <option value="remove">Убрать из WL</option>
            </select>
          </div>
          <textarea
            className="input"
            style={{ width: "100%", minHeight: 92, resize: "vertical" }}
            value={wlBulkText}
            onChange={(e) => setWlBulkText(e.target.value)}
            placeholder="1, 2, 3&#10;10&#10;25"
          />
          <div className="row" style={{ marginTop: 8 }}>
            <button className="btn" onClick={runBulkWl}>
              {wlBulkMode === "add" ? "Добавить в WL" : "Убрать из WL"}
            </button>
          </div>
          {wlBulkResult && (
            <div className="small" style={{ marginTop: 8 }}>
              Обновлено: {wlBulkResult.updated.length} ({wlBulkResult.updated.join(", ") || "-"})<br />
              Не найдено: {wlBulkResult.not_found.length} ({wlBulkResult.not_found.join(", ") || "-"})
            </div>
          )}
        </section>
      )}

      {err && <pre className="error">{err}</pre>}

      {data && (
        <section style={{ marginTop: 14 }}>
          <div className="muted">Найдено: {data.count}</div>
          {data.count === 0 && field === "static_id" && /^\d+$/.test(q.trim()) && (
            <div className="card" style={{ marginTop: 10 }}>
              <div className="small" style={{ marginBottom: 8 }}>
                Персонаж с этим static_id не найден. Можно открыть карточку static_id и управлять WL/Ban.
              </div>
              <Link className="btn" href={`/players/static/${encodeURIComponent(q.trim())}`}>
                Открыть карточку static_id {q.trim()}
              </Link>
            </div>
          )}
          <div className="grid" style={{ marginTop: 10 }}>
            {data.items.map((p) => (
              <article key={p.citizenid} className="card">
                <div className="playerName">
                  {p.firstname} {p.lastname}
                </div>
                <div className="muted" style={{ marginTop: 2 }}>
                  Citizen ID: {p.citizenid}
                </div>

                <div className="searchMetaGrid" style={{ marginTop: 8 }}>
                  <div className="searchMetaLine">
                    <span className="searchMetaKey">Онлайн</span>
                    <div className="searchMetaValue">
                      {p.online ? (
                        <>
                          Онлайн ID {String(p.online_source ?? "-")} (
                          <Link className="link" href={`/players/${p.citizenid}`}>
                            {p.citizenid}
                          </Link>
                          )
                        </>
                      ) : p.online_citizenid ? (
                        <>
                          Оффлайн. Онлайн на ID {String(p.online_source ?? "-")} (
                          <Link className="link" href={`/players/${p.online_citizenid}`}>
                            {p.online_citizenid}
                          </Link>
                          )
                        </>
                      ) : (
                        "Оффлайн"
                      )}
                    </div>
                  </div>
                  <div className="searchMetaLine">
                    <span className="searchMetaKey">Static ID</span>
                    <div className="searchMetaValue" title={String(p.static_id ?? "-")}>
                      {p.static_id ?? "-"}
                    </div>
                  </div>
                  <div className="searchMetaLine">
                    <span className="searchMetaKey">Discord ID</span>
                    <div className="searchMetaValue" title={String(p.discord_id ?? "-")}>
                      {p.discord_id ?? "-"}
                    </div>
                  </div>
                  <div className="searchMetaLine">
                    <span className="searchMetaKey">Phone</span>
                    <div className="searchMetaValue" title={String(p.phone ?? "-")}>
                      {p.phone ?? "-"}
                    </div>
                  </div>
                </div>
                <div style={{ marginTop: 10 }}>
                  <Link className="link" href={`/players/${p.citizenid}`}>
                    Открыть профиль
                  </Link>
                </div>
              </article>
            ))}
          </div>
        </section>
      )}
    </main>
  );
}

