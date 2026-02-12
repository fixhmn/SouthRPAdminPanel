"use client";

import Link from "next/link";
import { Suspense, useEffect, useState } from "react";
import { useSearchParams } from "next/navigation";
import { API_BASE, AdminMe, can, clearToken, fetchMe, getToken, roleLabel, setToken } from "@/lib/api";

function errorText(e: unknown): string {
  return e instanceof Error ? e.message : String(e);
}

function HomeContent() {
  const search = useSearchParams();
  const [token, setTokenInput] = useState("");
  const [me, setMe] = useState<AdminMe | null>(null);
  const [err, setErr] = useState("");
  const [busy, setBusy] = useState(false);
  const [checking, setChecking] = useState(true);

  useEffect(() => {
    const saved = getToken();
    if (!saved) {
      setChecking(false);
      return;
    }

    fetchMe()
      .then((admin) => {
        setMe(admin);
        setTokenInput(saved);
      })
      .catch(() => {
        clearToken();
      })
      .finally(() => setChecking(false));
  }, []);

  useEffect(() => {
    const code = search.get("discord_code");
    const oauthErr = search.get("discord_error");
    if (oauthErr) {
      if (!getToken()) {
        setErr(`Discord OAuth error: ${oauthErr}`);
      }
      const clean = window.location.origin + window.location.pathname;
      window.history.replaceState({}, "", clean);
      return;
    }
    if (!code) return;

    (async () => {
      try {
        const res = await fetch(`${API_BASE}/auth/discord/exchange?code=${encodeURIComponent(code)}`, { cache: "no-store" });
        if (!res.ok) {
          throw new Error(await res.text());
        }
        const data = (await res.json()) as { token: string };
        setToken(data.token);
        const admin = await fetchMe();
        setMe(admin);
      } catch (e: unknown) {
        setErr(errorText(e));
      } finally {
        const clean = window.location.origin + window.location.pathname;
        window.history.replaceState({}, "", clean);
      }
    })();
  }, [search]);

  async function login() {
    setBusy(true);
    setErr("");
    try {
      setToken(token.trim());
      const admin = await fetchMe();
      setMe(admin);
    } catch (e: unknown) {
      setErr(errorText(e));
      clearToken();
    } finally {
      setBusy(false);
    }
  }

  async function loginWithDiscord() {
    setErr("");
    try {
      const res = await fetch(`${API_BASE}/auth/discord/url`, { cache: "no-store" });
      if (!res.ok) throw new Error(await res.text());
      const data = (await res.json()) as { url: string };
      window.location.href = data.url;
    } catch (e: unknown) {
      setErr(errorText(e));
    }
  }

  function logout() {
    clearToken();
    setMe(null);
    setTokenInput("");
    setErr("");
  }

  if (checking) {
    return <main className="container narrow">Проверка авторизации...</main>;
  }

  if (me) {
    return (
      <main className="container">
        <header className="card">
          <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap" }}>
            <div>
              <h1 className="title" style={{ marginBottom: 6 }}>
                South RP Admin
              </h1>
              <div className="muted">
                Вы вошли как: {me.login} ({roleLabel(me.role_name)})
              </div>
            </div>
            <button className="btn secondary" onClick={logout}>
              Выйти
            </button>
          </div>
        </header>

        <section style={{ marginTop: 14 }}>
          <h2 className="title" style={{ fontSize: "1.25rem", marginBottom: 10 }}>
            Разделы
          </h2>
          <div className="grid">
            {can(me, "players.read") && (
              <article className="card">
                <h3 style={{ marginTop: 0 }}>Поиск игроков</h3>
                <p className="small">Поиск, просмотр профиля, действия с персонажем.</p>
                <div style={{ marginTop: 10 }}>
                  <Link className="btn" href="/players">
                    Открыть
                  </Link>
                </div>
              </article>
            )}

            {can(me, "vehicles.read") && (
              <article className="card">
                <h3 style={{ marginTop: 0 }}>Поиск машин</h3>
                <p className="small">Поиск по номеру, карточка авто, багажник и бардачок.</p>
                <div style={{ marginTop: 10 }}>
                  <Link className="btn" href="/vehicles">
                    Открыть
                  </Link>
                </div>
              </article>
            )}

            {can(me, "audit.read") && (
              <article className="card">
                <h3 style={{ marginTop: 0 }}>Журнал аудита</h3>
                <p className="small">Таблица действий администраторов и изменений.</p>
                <div style={{ marginTop: 10 }}>
                  <Link className="btn" href="/audit">
                    Открыть
                  </Link>
                </div>
              </article>
            )}

            {can(me, "admins.manage") && (
              <article className="card">
                <h3 style={{ marginTop: 0 }}>Админы и роли</h3>
                <p className="small">Управление администраторами и permissions ролей.</p>
                <div style={{ marginTop: 10 }}>
                  <Link className="btn" href="/admins">
                    Открыть
                  </Link>
                </div>
              </article>
            )}

            {can(me, "actions.manage_templates") && (
              <article className="card">
                <h3 style={{ marginTop: 0 }}>Внутриигровые шаблоны</h3>
                <p className="small">Настройка кнопок действий для взаимодействия с сервером из карточки игрока.</p>
                <div style={{ marginTop: 10 }}>
                  <Link className="btn" href="/game-actions">
                    Открыть
                  </Link>
                </div>
              </article>
            )}
          </div>
        </section>
      </main>
    );
  }

  return (
    <main className="container narrow">
      <h1 className="title">South RP Admin</h1>
      <p className="muted">Введите токен администратора для входа в панель.</p>

      <section className="card" style={{ marginTop: 18 }}>
        <label className="label" htmlFor="token-input">
          Токен администратора
        </label>
        <input
          id="token-input"
          value={token}
          onChange={(e) => setTokenInput(e.target.value)}
          placeholder="admin-token"
          className="input"
        />
        <div className="row" style={{ marginTop: 12 }}>
          <button className="btn" onClick={login} disabled={busy || token.trim().length < 8}>
            {busy ? "Проверка..." : "Войти"}
          </button>
          <button className="btn secondary" onClick={loginWithDiscord} disabled={busy}>
            Войти через Discord
          </button>
        </div>
        {err && <pre className="error">{err}</pre>}
      </section>
    </main>
  );
}

export default function Home() {
  return (
    <Suspense fallback={<main className="container narrow">Загрузка...</main>}>
      <HomeContent />
    </Suspense>
  );
}
