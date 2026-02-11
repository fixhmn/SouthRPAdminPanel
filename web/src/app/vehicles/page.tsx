"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { AdminMe, api, can, fetchMe, roleLabel } from "@/lib/api";

type VehicleSearchItem = {
  id: number;
  citizenid?: string;
  vehicle?: string;
  plate?: string;
  fakeplate?: string;
  garage_id?: string;
  garage?: string;
  state?: number;
  nickname?: string;
};

type VehicleSearchRes = {
  count: number;
  items: VehicleSearchItem[];
};

export default function VehiclesPage() {
  const [me, setMe] = useState<AdminMe | null>(null);
  const [plate, setPlate] = useState("");
  const [data, setData] = useState<VehicleSearchRes | null>(null);
  const [err, setErr] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchMe().then(setMe).catch(() => setMe(null));
  }, []);

  async function runSearch() {
    setLoading(true);
    setErr("");
    setData(null);
    try {
      const q = plate.trim();
      if (!q) {
        setErr("Введите номер для поиска.");
        return;
      }
      const res = await api<VehicleSearchRes>(`/vehicles/search?plate=${encodeURIComponent(q)}`);
      setData(res);
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    } finally {
      setLoading(false);
    }
  }

  return (
    <main className="container">
      <header className="card" style={{ marginBottom: 14 }}>
        <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap" }}>
          <div>
            <h1 className="title" style={{ marginBottom: 6 }}>
              Поиск машин
            </h1>
            <div className="muted">{me ? `Вы: ${me.login} (${roleLabel(me.role_name)})` : "Проверка доступа..."}</div>
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

      {!can(me, "vehicles.read") ? (
        <section className="card">
          <h3 style={{ marginTop: 0 }}>Нет доступа</h3>
          <p className="muted">Требуется permission `vehicles.read`.</p>
        </section>
      ) : (
        <>
          <section className="card">
            <div className="row">
              <input
                className="input"
                value={plate}
                onChange={(e) => setPlate(e.target.value)}
                placeholder="Номер или часть номера"
                style={{ flex: 1 }}
              />
              <button className="btn" onClick={runSearch} disabled={loading || !plate.trim()}>
                {loading ? "Поиск..." : "Найти"}
              </button>
            </div>
          </section>

          {err && <pre className="error">{err}</pre>}

          {data && (
            <section style={{ marginTop: 14 }}>
              <div className="muted">Найдено: {data.count}</div>
              <div className="grid" style={{ marginTop: 10 }}>
                {data.items.map((v) => (
                  <article key={v.id} className="card">
                    <div className="playerName">{v.vehicle || "-"}</div>
                    <div className="muted" style={{ marginTop: 2 }}>
                      Plate: {v.plate || "-"} {v.fakeplate ? `(fake: ${v.fakeplate})` : ""}
                    </div>
                    <div className="small" style={{ marginTop: 6 }}>
                      ID: {v.id}
                    </div>
                    <div className="small">CitizenID: {v.citizenid || "-"}</div>
                    <div className="small">garage_id: {v.garage_id || "-"}</div>
                    <div style={{ marginTop: 10 }}>
                      <Link className="link" href={`/vehicles/${v.id}`}>
                        Открыть карточку машины
                      </Link>
                    </div>
                  </article>
                ))}
              </div>
            </section>
          )}
        </>
      )}
    </main>
  );
}
