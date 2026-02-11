"use client";

import Link from "next/link";
import { useParams } from "next/navigation";
import { useCallback, useEffect, useState } from "react";
import { AdminMe, api, can, fetchMe } from "@/lib/api";

type VehicleItem = {
  id: number;
  license?: string;
  citizenid?: string;
  vehicle?: string;
  plate?: string;
  fakeplate?: string;
  garage_id?: string;
  garage?: string;
  state?: number;
  parking?: number;
  nickname?: string;
  type?: string;
  in_garage?: number;
  impound?: number;
  lock?: number;
  fuel?: number;
  engine?: number;
  body?: number;
  traveldistance?: number;
  glovebox?: InventoryItem[];
  trunk?: InventoryItem[];
};

type InventoryItem = {
  name?: string;
  item?: string;
  label?: string;
  resolved_label?: string;
  resolved_image_url?: string;
  count?: number;
  amount?: number;
  slot?: number;
};

type VehicleRes = {
  item: VehicleItem;
  owner?: {
    citizenid?: string;
    firstname?: string;
    lastname?: string;
  } | null;
};

function val(v: unknown): string {
  if (v === null || v === undefined || v === "") return "-";
  return String(v);
}

function itemLabel(item: InventoryItem): string {
  return item.resolved_label || item.label || item.name || item.item || "неизвестный предмет";
}

function itemCode(item: InventoryItem): string {
  return item.name || item.item || "unknown_item";
}

export default function VehicleCardPage() {
  const params = useParams<{ id: string }>();
  const vehicleId = Number(params.id);

  const [me, setMe] = useState<AdminMe | null>(null);
  const [owner, setOwner] = useState<VehicleRes["owner"]>(null);
  const [item, setItem] = useState<VehicleItem | null>(null);
  const [err, setErr] = useState("");
  const [busy, setBusy] = useState(false);

  const [editPlate, setEditPlate] = useState("");
  const [editFakePlate, setEditFakePlate] = useState("");
  const [editGarageId, setEditGarageId] = useState("");
  const [editGarage, setEditGarage] = useState("");
  const [editNickname, setEditNickname] = useState("");

  const load = useCallback(async () => {
    setErr("");
    try {
      const [current, data] = await Promise.all([fetchMe(), api<VehicleRes>(`/vehicles/${vehicleId}`)]);
      setMe(current);
      setOwner(data.owner || null);
      setItem(data.item);

      setEditPlate(data.item.plate || "");
      setEditFakePlate(data.item.fakeplate || "");
      setEditGarageId(data.item.garage_id || "");
      setEditGarage(data.item.garage || "");
      setEditNickname(data.item.nickname || "");
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    }
  }, [vehicleId]);

  useEffect(() => {
    if (!Number.isFinite(vehicleId)) {
      setErr("Некорректный ID машины");
      return;
    }
    void load();
  }, [vehicleId, load]);

  async function saveVehicle() {
    setBusy(true);
    setErr("");
    try {
      await api(`/vehicles/${vehicleId}`, {
        method: "PATCH",
        body: JSON.stringify({
          plate: editPlate.trim(),
          fakeplate: editFakePlate.trim(),
          garage_id: editGarageId.trim(),
          garage: editGarage.trim(),
          nickname: editNickname.trim(),
        }),
      });
      await load();
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    } finally {
      setBusy(false);
    }
  }

  return (
    <main className="container">
      <div className="row" style={{ marginBottom: 10, flexWrap: "wrap" }}>
        <Link className="link" href="/vehicles">
          Назад к поиску машин
        </Link>
        <span className="muted">|</span>
        <Link className="link" href="/players">
          Поиск игроков
        </Link>
      </div>

      {err && !item && <pre className="error">{err}</pre>}
      {!item ? (
        !err && <main className="container">Загрузка...</main>
      ) : (
        <>
          <h1 className="title">
            {item.vehicle || "Машина"} <span className="muted">(ID {item.id})</span>
          </h1>

          <div className="twoCol" style={{ marginTop: 12 }}>
            <section className="card">
              <h3>Основная информация</h3>
              <div className="metaGrid" style={{ marginTop: 8 }}>
                <div className="metaLine">
                  <span className="metaKey">Plate</span>
                  {val(item.plate)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">Fake Plate</span>
                  {val(item.fakeplate)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">Citizen ID</span>
                  {item.citizenid ? <Link className="link" href={`/players/${item.citizenid}`}>{item.citizenid}</Link> : "-"}
                </div>
                <div className="metaLine">
                  <span className="metaKey">Владелец</span>
                  {owner ? `${owner.firstname || ""} ${owner.lastname || ""}`.trim() || owner.citizenid : "-"}
                </div>
                <div className="metaLine">
                  <span className="metaKey">garage_id</span>
                  {val(item.garage_id)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">garage</span>
                  {val(item.garage)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">nickname</span>
                  {val(item.nickname)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">type</span>
                  {val(item.type)}
                </div>
              </div>
            </section>

            <section className="card">
              <h3>Состояние</h3>
              <div className="metaGrid" style={{ marginTop: 8 }}>
                <div className="metaLine">
                  <span className="metaKey">state</span>
                  {val(item.state)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">parking</span>
                  {val(item.parking)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">in_garage</span>
                  {val(item.in_garage)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">impound</span>
                  {val(item.impound)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">fuel</span>
                  {val(item.fuel)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">engine</span>
                  {val(item.engine)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">body</span>
                  {val(item.body)}
                </div>
                <div className="metaLine">
                  <span className="metaKey">traveldistance</span>
                  {val(item.traveldistance)}
                </div>
              </div>
            </section>
          </div>

          {can(me, "vehicles.edit") && (
            <section className="card" style={{ marginTop: 12 }}>
              <h3>Редактирование машины</h3>
              <div className="metaGrid" style={{ marginTop: 8 }}>
                <div>
                  <label className="metaKey">Plate</label>
                  <input className="input" value={editPlate} onChange={(e) => setEditPlate(e.target.value)} />
                </div>
                <div>
                  <label className="metaKey">Fake Plate</label>
                  <input className="input" value={editFakePlate} onChange={(e) => setEditFakePlate(e.target.value)} />
                </div>
                <div>
                  <label className="metaKey">garage_id</label>
                  <input className="input" value={editGarageId} onChange={(e) => setEditGarageId(e.target.value)} />
                </div>
                <div>
                  <label className="metaKey">garage</label>
                  <input className="input" value={editGarage} onChange={(e) => setEditGarage(e.target.value)} />
                </div>
                <div>
                  <label className="metaKey">nickname</label>
                  <input className="input" value={editNickname} onChange={(e) => setEditNickname(e.target.value)} />
                </div>
              </div>
              <div style={{ marginTop: 10 }}>
                <button className="btn" onClick={saveVehicle} disabled={busy}>
                  {busy ? "Сохранение..." : "Сохранить изменения"}
                </button>
              </div>
              {err && (
                <pre className="error" style={{ marginTop: 10 }}>
                  {err}
                </pre>
              )}
            </section>
          )}

          <div className="twoCol" style={{ marginTop: 12 }}>
            <section className="card">
              <h3>Содержимое glovebox</h3>
              {!(item.glovebox || []).length ? (
                <p className="muted">Пусто</p>
              ) : (
                <div className="tableWrap" style={{ marginTop: 8 }}>
                  <table className="table">
                    <thead>
                      <tr>
                        <th>Иконка</th>
                        <th>Предмет</th>
                        <th>Кол-во</th>
                        <th>Slot</th>
                      </tr>
                    </thead>
                    <tbody>
                      {(item.glovebox || []).map((x, idx) => (
                        <tr key={`${itemCode(x)}-${idx}`}>
                          <td>
                            {x.resolved_image_url ? (
                              // eslint-disable-next-line @next/next/no-img-element
                              <img src={x.resolved_image_url} alt={itemLabel(x)} style={{ width: 28, height: 28, objectFit: "contain" }} />
                            ) : (
                              <span className="muted">-</span>
                            )}
                          </td>
                          <td>
                            {itemLabel(x)} <span className="muted">({itemCode(x)})</span>
                          </td>
                          <td>{x.count ?? x.amount ?? 1}</td>
                          <td>{x.slot ?? "-"}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </section>

            <section className="card">
              <h3>Содержимое trunk</h3>
              {!(item.trunk || []).length ? (
                <p className="muted">Пусто</p>
              ) : (
                <div className="tableWrap" style={{ marginTop: 8 }}>
                  <table className="table">
                    <thead>
                      <tr>
                        <th>Иконка</th>
                        <th>Предмет</th>
                        <th>Кол-во</th>
                        <th>Slot</th>
                      </tr>
                    </thead>
                    <tbody>
                      {(item.trunk || []).map((x, idx) => (
                        <tr key={`${itemCode(x)}-${idx}`}>
                          <td>
                            {x.resolved_image_url ? (
                              // eslint-disable-next-line @next/next/no-img-element
                              <img src={x.resolved_image_url} alt={itemLabel(x)} style={{ width: 28, height: 28, objectFit: "contain" }} />
                            ) : (
                              <span className="muted">-</span>
                            )}
                          </td>
                          <td>
                            {itemLabel(x)} <span className="muted">({itemCode(x)})</span>
                          </td>
                          <td>{x.count ?? x.amount ?? 1}</td>
                          <td>{x.slot ?? "-"}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </section>
          </div>
        </>
      )}
    </main>
  );
}
