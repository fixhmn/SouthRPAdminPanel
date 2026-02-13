"use client";

import Link from "next/link";
import { useCallback, useEffect, useMemo, useState } from "react";
import { AdminMe, api, can, clearToken, fetchMe, roleLabel } from "@/lib/api";

type OnlineRes = {
  count: number;
  items: Array<{
    citizenid: string;
    name?: string;
    static_id?: number;
    firstname?: string;
    lastname?: string;
    job?: string | null;
    gang?: string | null;
    source?: number;
  }>;
};

export default function OnlinePlayersPage() {
  const [me, setMe] = useState<AdminMe | null>(null);
  const [data, setData] = useState<OnlineRes | null>(null);
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(false);
  const [limit, setLimit] = useState(100);
  const [query, setQuery] = useState("");

  const load = useCallback(async (currentLimit: number) => {
    setErr("");
    setLoading(true);
    try {
      const res = await api<OnlineRes>(`/players/online?limit=${currentLimit}`);
      setData(res);
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchMe().then(setMe).catch(() => setMe(null));
    void load(100);
  }, [load]);

  function logout() {
    clearToken();
    window.location.href = "/";
  }

  const filteredItems = useMemo(() => {
    const items = data?.items || [];
    const needle = query.trim().toLowerCase();
    if (!needle) return items;

    return items.filter((p) => {
      const haystack = [
        String(p.source ?? ""),
        String(p.static_id ?? ""),
        String(p.citizenid ?? ""),
        String(p.firstname ?? ""),
        String(p.lastname ?? ""),
        String(p.name ?? ""),
        String(p.job ?? ""),
        String(p.gang ?? ""),
      ]
        .join(" ")
        .toLowerCase();
      return haystack.includes(needle);
    });
  }, [data, query]);

  return (
    <main className="container">
      <header className="card" style={{ marginBottom: 14 }}>
        <div className="row" style={{ justifyContent: "space-between" }}>
          <div>
            <h1 className="title" style={{ marginBottom: 6 }}>
              Онлайн персонажи
            </h1>
            <div className="muted">
              {me ? `Вы: ${me.login} (${roleLabel(me.role_name)})` : "Добавьте токен администратора в браузере"}
            </div>
          </div>
          <div className="topMenu">
            <Link className="menuTab" href="/players">
              Поиск игроков
            </Link>
            <Link className="menuTab" href="/">
              Главная
            </Link>
            <button className="menuTab" onClick={logout}>
              Выйти
            </button>
          </div>
        </div>
      </header>

      <section className="card">
        <div className="row">
          <input
            type="number"
            className="input"
            value={limit}
            min={1}
            max={500}
            onChange={(e) => setLimit(parseInt(e.target.value || "100", 10))}
            style={{ maxWidth: 140 }}
          />
          <input
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                e.preventDefault();
                void load(limit);
              }
            }}
            placeholder="Поиск: ServerID / StaticID / CitizenID / имя / job / gang"
            className="input"
            style={{ flex: 1 }}
          />
          <button className="btn" onClick={() => void load(limit)} disabled={!can(me, "players.read") || loading}>
            {loading ? "Загрузка..." : "Обновить"}
          </button>
        </div>
      </section>

      {err && <pre className="error">{err}</pre>}

      {data && (
        <section style={{ marginTop: 14 }}>
          <div className="muted">
            Онлайн: {data.count} | По фильтру: {filteredItems.length}
          </div>
          <div className="grid" style={{ marginTop: 10 }}>
            {filteredItems.map((p) => (
              <article key={p.citizenid} className="card">
                <div className="playerName">
                  {p.firstname} {p.lastname}
                </div>
                <div className="muted" style={{ marginTop: 2 }}>
                  Citizen ID: {p.citizenid}
                </div>

                <div className="searchMetaGrid" style={{ marginTop: 8 }}>
                  <div className="searchMetaLine">
                    <span className="searchMetaKey">Server ID</span>
                    <div className="searchMetaValue" title={String(p.source ?? "-")}>
                      {p.source ?? "-"}
                    </div>
                  </div>
                  <div className="searchMetaLine">
                    <span className="searchMetaKey">Static ID</span>
                    <div className="searchMetaValue" title={String(p.static_id ?? "-")}>
                      {p.static_id ?? "-"}
                    </div>
                  </div>
                  <div className="searchMetaLine">
                    <span className="searchMetaKey">Job</span>
                    <div className="searchMetaValue" title={String(p.job ?? "-")}>
                      {p.job ?? "-"}
                    </div>
                  </div>
                  <div className="searchMetaLine">
                    <span className="searchMetaKey">Gang</span>
                    <div className="searchMetaValue" title={String(p.gang ?? "-")}>
                      {p.gang ?? "-"}
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
