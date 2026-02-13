"use client";

import Link from "next/link";
import { useParams } from "next/navigation";
import { useCallback, useEffect, useState } from "react";
import { AdminMe, api, can, fetchMe } from "@/lib/api";

type StaticCard = {
  static_id: number;
  license?: string | null;
  discord_id?: number | null;
  wl: boolean;
  ban: boolean;
  ban_until?: string | null;
  linked_character?: {
    citizenid?: string | null;
    name?: string | null;
    license?: string | null;
    firstname?: string | null;
    lastname?: string | null;
  } | null;
};

export default function StaticPlayerPage() {
  const params = useParams<{ staticId: string }>();
  const staticId = Number(params.staticId);
  const [me, setMe] = useState<AdminMe | null>(null);
  const [data, setData] = useState<StaticCard | null>(null);
  const [err, setErr] = useState("");
  const [busy, setBusy] = useState(false);
  const [banDays, setBanDays] = useState(1);

  const load = useCallback(async () => {
    setErr("");
    try {
      const [current, card] = await Promise.all([fetchMe(), api<StaticCard>(`/players/static/${staticId}`)]);
      setMe(current);
      setData(card);
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    }
  }, [staticId]);

  useEffect(() => {
    if (!Number.isFinite(staticId) || staticId <= 0) {
      setErr("Некорректный static_id");
      return;
    }
    void load();
  }, [load, staticId]);

  async function act(path: string) {
    setBusy(true);
    setErr("");
    try {
      await api(path, { method: "POST" });
      await load();
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    } finally {
      setBusy(false);
    }
  }

  if (!data && !err) {
    return <main className="container">Загрузка...</main>;
  }

  return (
    <main className="container">
      <Link className="link" href="/players">
        Назад к поиску
      </Link>

      <h1 className="title" style={{ marginTop: 10 }}>
        Карточка static_id: {Number.isFinite(staticId) ? staticId : "-"}
      </h1>

      <section className="card" style={{ marginTop: 12 }}>
        <h3>Информация</h3>
        {!data?.linked_character ? (
          <div className="small" style={{ marginTop: 8 }}>
            У игрока нет персонажа.
          </div>
        ) : (
          <div className="small" style={{ marginTop: 8 }}>
            Найден персонаж:{" "}
            <Link className="link" href={`/players/${data.linked_character.citizenid}`}>
              {String(data.linked_character.firstname ?? "")} {String(data.linked_character.lastname ?? "")}
              {" ("}
              {String(data.linked_character.citizenid ?? "-")}
              {")"}
            </Link>
          </div>
        )}

        <div className="metaGrid" style={{ marginTop: 10 }}>
          <div className="metaLine">
            <span className="metaKey">Static ID</span>
            <span className="metaValue">{data?.static_id ?? "-"}</span>
          </div>
          <div className="metaLine">
            <span className="metaKey">WL</span>
            <span className="metaValue">{data?.wl ? "Внесен" : "Не внесен"}</span>
          </div>
          <div className="metaLine">
            <span className="metaKey">Ban WL</span>
            <span className="metaValue">{data?.ban ? `Бан до ${data.ban_until ?? "-"}` : "Нет бана"}</span>
          </div>
          <div className="metaLine">
            <span className="metaKey">Discord ID</span>
            <span className="metaValue">{data?.discord_id ?? "-"}</span>
          </div>
          <div className="metaLine">
            <span className="metaKey">License</span>
            <span className="metaValue" title={String(data?.license ?? "-")}>
              {data?.license ?? "-"}
            </span>
          </div>
        </div>
      </section>

      <section className="card" style={{ marginTop: 12 }}>
        <h3>Действия</h3>
        <div className="row" style={{ flexWrap: "wrap", marginTop: 8 }}>
          {can(me, "players.manage_wl") && (
            <>
              <button disabled={busy} className="btn" onClick={() => act(`/players/static/${staticId}/actions/addwl`)}>
                Добавить WL
              </button>
              <button
                disabled={busy}
                className="btn secondary"
                onClick={() => act(`/players/static/${staticId}/actions/removewl`)}
              >
                Убрать WL
              </button>
            </>
          )}

          {can(me, "players.manage_ban") && (
            <>
              <input
                type="number"
                value={banDays}
                min={1}
                max={3650}
                onChange={(e) => setBanDays(parseInt(e.target.value || "1", 10))}
                className="input"
                style={{ width: 100 }}
              />
              <button
                disabled={busy}
                className="btn"
                onClick={() => act(`/players/static/${staticId}/actions/banwl?days=${banDays}`)}
              >
                Выдать WL-бан
              </button>
              <button
                disabled={busy}
                className="btn secondary"
                onClick={() => act(`/players/static/${staticId}/actions/unbanwl`)}
              >
                Снять WL-бан
              </button>
            </>
          )}
        </div>
      </section>

      {err && (
        <pre className="error" style={{ marginTop: 10 }}>
          {err}
        </pre>
      )}
    </main>
  );
}

