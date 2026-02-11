"use client";

import Link from "next/link";
import { useParams } from "next/navigation";
import { useCallback, useEffect, useState } from "react";
import { AdminMe, api, can, fetchMe } from "@/lib/api";

type JsonMap = Record<string, unknown>;

type Player = {
  citizenid: string;
  license?: string;
  name?: string;
  static_id?: number;
  discord_id?: number;
  slots_current?: number;
  wl: boolean;
  ban: boolean;
  ban_until?: string | null;
  charinfo: JsonMap;
  job: JsonMap;
  gang: JsonMap;
  money: JsonMap;
  inventory: unknown[];
  vehicles: Array<{
    id: number;
    vehicle: string;
    plate: string;
    fakeplate?: string | null;
    garage_id?: string | null;
    state?: number | null;
    nickname?: string | null;
  }>;
};

type InventoryItem = {
  name?: string;
  item?: string;
  label?: string;
  resolved_label?: string;
  resolved_image?: string;
  resolved_image_url?: string;
  count?: number;
  amount?: number;
};

function stringifyValue(value: unknown): string {
  if (value === null || value === undefined) return "-";
  if (typeof value === "string" || typeof value === "number" || typeof value === "boolean") {
    return String(value);
  }
  if (Array.isArray(value)) return value.map((v) => stringifyValue(v)).join(", ");
  try {
    return JSON.stringify(value);
  } catch {
    return String(value);
  }
}

function labelFromItem(item: InventoryItem): string {
  return item.resolved_label || item.label || item.name || item.item || "неизвестный предмет";
}

function codeFromItem(item: InventoryItem): string {
  return item.name || item.item || "unknown_item";
}

export default function PlayerPage() {
  const params = useParams<{ citizenid: string }>();
  const cid = params.citizenid;
  const [me, setMe] = useState<AdminMe | null>(null);
  const [player, setPlayer] = useState<Player | null>(null);
  const [err, setErr] = useState("");
  const [busy, setBusy] = useState(false);
  const [banDays, setBanDays] = useState(1);
  const [slots, setSlots] = useState(3);
  const [copiedField, setCopiedField] = useState("");
  const [editFirstname, setEditFirstname] = useState("");
  const [editLastname, setEditLastname] = useState("");
  const [editPhone, setEditPhone] = useState("");
  const [editBirthdate, setEditBirthdate] = useState("");
  const [editNationality, setEditNationality] = useState("");

  const load = useCallback(async () => {
    setErr("");
    try {
      const [current, res] = await Promise.all([fetchMe(), api<Player>(`/players/${cid}`)]);
      setMe(current);
      setPlayer(res);
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    }
  }, [cid]);

  useEffect(() => {
    void load();
  }, [load]);

  useEffect(() => {
    if (!player) return;
    const charinfo = player.charinfo || {};
    setEditFirstname(stringifyValue(charinfo.firstname === "-" ? "" : charinfo.firstname));
    setEditLastname(stringifyValue(charinfo.lastname === "-" ? "" : charinfo.lastname));
    setEditPhone(stringifyValue(charinfo.phone === "-" ? "" : charinfo.phone));
    setEditBirthdate(stringifyValue(charinfo.birthdate === "-" ? "" : charinfo.birthdate));
    setEditNationality(stringifyValue(charinfo.nationality === "-" ? "" : charinfo.nationality));
  }, [player]);

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

  async function del() {
    if (!confirm(`Удалить персонажа ${cid}?`)) return;
    setBusy(true);
    setErr("");
    try {
      await api(`/players/${cid}`, { method: "DELETE" });
      window.location.href = "/players";
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    } finally {
      setBusy(false);
    }
  }

  async function saveProfile() {
    setBusy(true);
    setErr("");
    try {
      await api(`/players/${cid}/profile`, {
        method: "PATCH",
        body: JSON.stringify({
          firstname: editFirstname.trim(),
          lastname: editLastname.trim(),
          phone: editPhone.trim(),
          birthdate: editBirthdate.trim(),
          nationality: editNationality.trim(),
        }),
      });
      await load();
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    } finally {
      setBusy(false);
    }
  }

  async function copyToClipboard(value: string, fieldKey: string) {
    if (!value || value === "-") return;
    try {
      // Modern API works only in secure contexts (HTTPS/localhost).
      if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(value);
      } else {
        const ta = document.createElement("textarea");
        ta.value = value;
        ta.setAttribute("readonly", "true");
        ta.style.position = "fixed";
        ta.style.opacity = "0";
        ta.style.pointerEvents = "none";
        document.body.appendChild(ta);
        ta.focus();
        ta.select();
        const ok = document.execCommand("copy");
        document.body.removeChild(ta);
        if (!ok) {
          throw new Error("copy_failed");
        }
      }
      setCopiedField(fieldKey);
      window.setTimeout(() => {
        setCopiedField((current) => (current === fieldKey ? "" : current));
      }, 1300);
    } catch {
      setErr("Не удалось скопировать в буфер обмена.");
    }
  }

  function renderCopyableValue(value: unknown, fieldKey: string) {
    const text = stringifyValue(value);
    return (
      <div className="metaRow">
        <span className="metaValue" title={text}>
          {text}
        </span>
        <button type="button" className="copyBtn" onClick={() => copyToClipboard(text, fieldKey)} disabled={text === "-"}>
          {copiedField === fieldKey ? "Скопировано" : "Копировать"}
        </button>
      </div>
    );
  }

  if (err && !player) {
    return (
      <main className="container">
        <pre className="error">{err}</pre>
      </main>
    );
  }

  if (!player) {
    return <main className="container">Загрузка...</main>;
  }

  const ci = player.charinfo || {};
  const moneyEntries = Object.entries(player.money || {});
  const jobLabel = stringifyValue(player.job.label ?? player.job.name);
  const jobGrade = stringifyValue((player.job.grade as JsonMap | undefined)?.name ?? player.job.grade);
  const gangLabel = stringifyValue(player.gang.label ?? player.gang.name);
  const inventory = (player.inventory || []) as InventoryItem[];

  return (
    <main className="container">
      <Link className="link" href="/players">
        Назад к поиску
      </Link>
      <h1 className="title" style={{ marginTop: 10 }}>
        {String(ci.firstname ?? "-")} {String(ci.lastname ?? "-")} <span className="muted">({player.citizenid})</span>
      </h1>

      <div className="twoCol" style={{ marginTop: 12 }}>
        <section className="card">
          <h3>Идентификаторы</h3>
          <div className="metaGrid" style={{ marginTop: 8 }}>
            <div className="metaLine">
              <span className="metaKey">Citizen ID</span>
              {renderCopyableValue(player.citizenid, "citizenid")}
            </div>
            <div className="metaLine">
              <span className="metaKey">FiveM name</span>
              <span className="metaValue" title={player.name ?? "-"}>
                {player.name ?? "-"}
              </span>
            </div>
            <div className="metaLine">
              <span className="metaKey">Static ID</span>
              {renderCopyableValue(player.static_id, "static_id")}
            </div>
            <div className="metaLine">
              <span className="metaKey">Discord ID</span>
              {renderCopyableValue(player.discord_id, "discord_id")}
            </div>
            <div className="metaLine">
              <span className="metaKey">License</span>
              {renderCopyableValue(player.license, "license")}
            </div>
            <div className="metaLine">
              <span className="metaKey">Слоты персонажей (текущие)</span>
              {stringifyValue(player.slots_current)}
            </div>
            <div className="metaLine">
              <span className="metaKey">Whitelist</span>
              {player.wl ? "Включён" : "Выключен"}
            </div>
            <div className="metaLine">
              <span className="metaKey">Ban</span>
              {player.ban ? `До ${player.ban_until ?? "неизвестно"}` : "Не забанен"}
            </div>
          </div>
        </section>

        <section className="card">
          <h3>Действия</h3>
          <div className="row" style={{ flexWrap: "wrap", marginTop: 8 }}>
            {can(me, "players.manage_wl") && (
              <>
                <button disabled={busy} className="btn" onClick={() => act(`/players/${cid}/actions/addwl`)}>
                  Добавить WL
                </button>
                <button
                  disabled={busy}
                  className="btn secondary"
                  onClick={() => act(`/players/${cid}/actions/removewl`)}
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
                  onClick={() => act(`/players/${cid}/actions/banwl?days=${banDays}`)}
                >
                  Выдать WL-бан
                </button>
                <button disabled={busy} className="btn secondary" onClick={() => act(`/players/${cid}/actions/unbanwl`)}>
                  Снять WL-бан
                </button>
              </>
            )}

            {can(me, "players.manage_slots") && (
              <>
                <input
                  type="number"
                  value={slots}
                  min={1}
                  max={20}
                  onChange={(e) => setSlots(parseInt(e.target.value || "1", 10))}
                  className="input"
                  style={{ width: 100 }}
                />
                <button
                  disabled={busy}
                  className="btn"
                  onClick={() => act(`/players/${cid}/actions/setslots?slots=${slots}`)}
                >
                  Установить слоты
                </button>
              </>
            )}

            {can(me, "players.delete_character") && (
              <button disabled={busy} onClick={del} className="btn danger">
                Удалить персонажа
              </button>
            )}
          </div>
          {err && (
            <pre className="error" style={{ marginTop: 10 }}>
              {err}
            </pre>
          )}
        </section>
      </div>

      <div className="twoCol" style={{ marginTop: 12 }}>
        <section className="card">
          <h3>Информация о персонаже</h3>
          <div className="metaGrid" style={{ marginTop: 8 }}>
            <div className="metaLine">
              <span className="metaKey">Телефон</span>
              {renderCopyableValue(ci.phone, "phone")}
            </div>
            <div className="metaLine">
              <span className="metaKey">Дата рождения</span>
              {stringifyValue(ci.birthdate)}
            </div>
            <div className="metaLine">
              <span className="metaKey">Пол</span>
              {stringifyValue(ci.gender)}
            </div>
            <div className="metaLine">
              <span className="metaKey">Национальность</span>
              {stringifyValue(ci.nationality)}
            </div>
          </div>

          {can(me, "players.edit_profile") && (
            <div style={{ marginTop: 12 }}>
              <h4 style={{ margin: "0 0 8px 0" }}>Редактирование профиля</h4>
              <div className="metaGrid">
                <div>
                  <label className="metaKey">Имя</label>
                  <input className="input" value={editFirstname} onChange={(e) => setEditFirstname(e.target.value)} />
                </div>
                <div>
                  <label className="metaKey">Фамилия</label>
                  <input className="input" value={editLastname} onChange={(e) => setEditLastname(e.target.value)} />
                </div>
                <div>
                  <label className="metaKey">Телефон</label>
                  <input className="input" value={editPhone} onChange={(e) => setEditPhone(e.target.value)} />
                </div>
                <div>
                  <label className="metaKey">Дата рождения (YYYY-MM-DD)</label>
                  <input className="input" value={editBirthdate} onChange={(e) => setEditBirthdate(e.target.value)} />
                </div>
                <div>
                  <label className="metaKey">Национальность</label>
                  <input className="input" value={editNationality} onChange={(e) => setEditNationality(e.target.value)} />
                </div>
              </div>
              <div style={{ marginTop: 10 }}>
                <button className="btn" onClick={saveProfile} disabled={busy}>
                  Сохранить изменения
                </button>
              </div>
            </div>
          )}
        </section>

        <section className="card">
          <h3>Работа и банда</h3>
          <div className="metaGrid" style={{ marginTop: 8 }}>
            <div className="metaLine">
              <span className="metaKey">Работа</span>
              {jobLabel}
            </div>
            <div className="metaLine">
              <span className="metaKey">Ранг работы</span>
              {jobGrade}
            </div>
            <div className="metaLine">
              <span className="metaKey">Банда</span>
              {gangLabel}
            </div>
            <div className="metaLine">
              <span className="metaKey">Ранг банды</span>
              {stringifyValue((player.gang.grade as JsonMap | undefined)?.name ?? player.gang.grade)}
            </div>
          </div>
        </section>
      </div>

      <div className="twoCol" style={{ marginTop: 12 }}>
        <section className="card">
          <h3>Деньги</h3>
          {moneyEntries.length === 0 ? (
            <p className="muted">Нет данных по деньгам</p>
          ) : (
            <div className="metaGrid" style={{ marginTop: 8 }}>
              {moneyEntries.map(([key, value]) => (
                <div className="metaLine" key={key}>
                  <span className="metaKey">{key}</span>
                  {stringifyValue(value)}
                </div>
              ))}
            </div>
          )}
        </section>

        <section className="card">
          <h3>Транспорт</h3>
          {player.vehicles.length === 0 ? (
            <p className="muted">Нет зарегистрированного транспорта</p>
          ) : (
            <div className="grid" style={{ marginTop: 8 }}>
              {player.vehicles.map((v) => (
                <article key={v.id} className="metaLine">
                  <div>
                    <strong>{v.vehicle || "-"}</strong>{" "}
                    <span className="muted">({v.plate || "-"})</span>
                  </div>
                  <div className="small">ID: {v.id}</div>
                  <div className="small">garage_id: {v.garage_id || "-"}</div>
                  <div style={{ marginTop: 6 }}>
                    <Link className="link" href={`/vehicles/${v.id}`}>
                      Открыть карточку машины
                    </Link>
                  </div>
                </article>
              ))}
            </div>
          )}
        </section>
      </div>

      <section className="card" style={{ marginTop: 12 }}>
        <h3>Инвентарь (первые 50)</h3>
        {inventory.length === 0 ? (
          <p className="muted">Инвентарь пуст</p>
        ) : (
          <div className="tableWrap" style={{ marginTop: 8 }}>
            <table className="table">
              <thead>
                <tr>
                  <th>Иконка</th>
                  <th>Предмет</th>
                  <th>Кол-во</th>
                </tr>
              </thead>
              <tbody>
                {inventory.slice(0, 50).map((item, idx) => (
                  <tr key={`${codeFromItem(item)}-${idx}`}>
                    <td>
                      {item.resolved_image_url ? (
                        // eslint-disable-next-line @next/next/no-img-element
                        <img
                          src={item.resolved_image_url}
                          alt={labelFromItem(item)}
                          style={{ width: 28, height: 28, objectFit: "contain", borderRadius: 6 }}
                        />
                      ) : (
                        <span className="muted">-</span>
                      )}
                    </td>
                    <td>
                      {labelFromItem(item)} <span className="muted">({codeFromItem(item)})</span>
                    </td>
                    <td>{item.count ?? item.amount ?? 1}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </main>
  );
}
