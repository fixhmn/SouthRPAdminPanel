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

type GameActionVariable = {
  key: string;
  label?: string;
  value_type: "string" | "number" | "boolean";
  required?: boolean;
  default_value?: string | null;
};

type GameActionTemplate = {
  id: number;
  name: string;
  description?: string | null;
  action_type: "export" | "server_event" | "qbx_set_job" | "qbx_set_gang";
  resource_name?: string | null;
  action_name: string;
  variables: GameActionVariable[];
  is_active: number | boolean;
};

type ItemSuggestion = {
  item: string;
  label: string;
  image?: string | null;
  image_url?: string | null;
};

type JobSuggestion = {
  job: string;
  label: string;
  grades_count?: number;
};

type GangSuggestion = {
  gang: string;
  label: string;
  grades_count?: number;
};

type GradeSuggestion = {
  grade: number;
  name: string;
};

type OnlineStatus = {
  ok: boolean;
  online: boolean;
  source?: number | null;
  player_name?: string | null;
};

const AUTO_VARIABLE_KEYS = new Set(["targetId", "target_id", "source", "static_id"]);

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
  const [kickReason, setKickReason] = useState("");
  const [copiedField, setCopiedField] = useState("");
  const [editFirstname, setEditFirstname] = useState("");
  const [editLastname, setEditLastname] = useState("");
  const [editPhone, setEditPhone] = useState("");
  const [editBirthdate, setEditBirthdate] = useState("");
  const [editNationality, setEditNationality] = useState("");
  const [gameActions, setGameActions] = useState<GameActionTemplate[]>([]);
  const [gameActionValues, setGameActionValues] = useState<Record<number, Record<string, string>>>({});
  const [gameActionBusy, setGameActionBusy] = useState<number | null>(null);
  const [gameActionStatus, setGameActionStatus] = useState<string>("");
  const [showGamePanel, setShowGamePanel] = useState(false);
  const [onlineStatus, setOnlineStatus] = useState<OnlineStatus | null>(null);
  const [checkingOnline, setCheckingOnline] = useState(false);
  const [itemSuggestions, setItemSuggestions] = useState<Record<string, ItemSuggestion[]>>({});
  const [itemSuggestBusy, setItemSuggestBusy] = useState<Record<string, boolean>>({});
  const [jobSuggestions, setJobSuggestions] = useState<Record<string, JobSuggestion[]>>({});
  const [gangSuggestions, setGangSuggestions] = useState<Record<string, GangSuggestion[]>>({});
  const [groupSuggestBusy, setGroupSuggestBusy] = useState<Record<string, boolean>>({});
  const [gradeOptions, setGradeOptions] = useState<Record<number, GradeSuggestion[]>>({});
  const [gradeBusy, setGradeBusy] = useState<Record<number, boolean>>({});

  const load = useCallback(async () => {
    setErr("");
    try {
      const [current, res] = await Promise.all([fetchMe(), api<Player>(`/players/${cid}`)]);
      setMe(current);
      setPlayer(res);

      if (can(current, "players.game_interact")) {
        const t = await api<{ items: GameActionTemplate[] }>("/game-actions/templates?active_only=true");
        const templates = (t.items || []).filter((x) => Boolean(x.is_active));
        setGameActions(templates);
        setGameActionValues((prev) => {
          const next = { ...prev };
          for (const tmpl of templates) {
            if (!next[tmpl.id]) {
              const one: Record<string, string> = {};
              for (const v of tmpl.variables || []) {
                one[v.key] = v.default_value ? String(v.default_value) : "";
              }
              next[tmpl.id] = one;
            }
          }
          return next;
        });
      } else {
        setGameActions([]);
      }
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

  async function kickPlayerNow() {
    setBusy(true);
    setErr("");
    try {
      await api(`/players/${cid}/actions/kick`, {
        method: "POST",
        body: JSON.stringify({ reason: kickReason.trim() || undefined }),
      });
      setKickReason("");
      await checkOnlineStatus(true);
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

  function setTemplateValue(templateId: number, key: string, value: string) {
    setGameActionValues((prev) => ({
      ...prev,
      [templateId]: {
        ...(prev[templateId] || {}),
        [key]: value,
      },
    }));
  }

  function getItemSuggestKey(templateId: number, variableKey: string): string {
    return `${templateId}:${variableKey}`;
  }

  async function searchItemSuggestions(templateId: number, variableKey: string, q: string) {
    const stateKey = getItemSuggestKey(templateId, variableKey);
    const needle = q.trim();
    if (!needle) {
      setItemSuggestions((prev) => ({ ...prev, [stateKey]: [] }));
      return;
    }

    setItemSuggestBusy((prev) => ({ ...prev, [stateKey]: true }));
    try {
      const res = await api<{ items: ItemSuggestion[] }>(
        `/items/suggest?q=${encodeURIComponent(needle)}&limit=8`,
      );
      setItemSuggestions((prev) => ({ ...prev, [stateKey]: res.items || [] }));
    } catch {
      setItemSuggestions((prev) => ({ ...prev, [stateKey]: [] }));
    } finally {
      setItemSuggestBusy((prev) => ({ ...prev, [stateKey]: false }));
    }
  }

  async function searchJobSuggestions(templateId: number, variableKey: string, q: string) {
    const stateKey = getItemSuggestKey(templateId, variableKey);
    const needle = q.trim();
    if (!needle) {
      setJobSuggestions((prev) => ({ ...prev, [stateKey]: [] }));
      return;
    }
    setGroupSuggestBusy((prev) => ({ ...prev, [stateKey]: true }));
    try {
      const res = await api<{ items: JobSuggestion[] }>(`/jobs/suggest?q=${encodeURIComponent(needle)}&limit=8`);
      setJobSuggestions((prev) => ({ ...prev, [stateKey]: res.items || [] }));
    } catch {
      setJobSuggestions((prev) => ({ ...prev, [stateKey]: [] }));
    } finally {
      setGroupSuggestBusy((prev) => ({ ...prev, [stateKey]: false }));
    }
  }

  async function searchGangSuggestions(templateId: number, variableKey: string, q: string) {
    const stateKey = getItemSuggestKey(templateId, variableKey);
    const needle = q.trim();
    if (!needle) {
      setGangSuggestions((prev) => ({ ...prev, [stateKey]: [] }));
      return;
    }
    setGroupSuggestBusy((prev) => ({ ...prev, [stateKey]: true }));
    try {
      const res = await api<{ items: GangSuggestion[] }>(`/gangs/suggest?q=${encodeURIComponent(needle)}&limit=8`);
      setGangSuggestions((prev) => ({ ...prev, [stateKey]: res.items || [] }));
    } catch {
      setGangSuggestions((prev) => ({ ...prev, [stateKey]: [] }));
    } finally {
      setGroupSuggestBusy((prev) => ({ ...prev, [stateKey]: false }));
    }
  }

  async function loadGradeOptions(template: GameActionTemplate, values: Record<string, string>) {
    const templateId = template.id;
    const hasJob = (template.variables || []).some((x) => x.key === "job");
    const hasGang = (template.variables || []).some((x) => x.key === "gang");
    const selectedJob = (values.job || "").trim();
    const selectedGang = (values.gang || "").trim();

    if (!hasJob && !hasGang) {
      setGradeOptions((prev) => ({ ...prev, [templateId]: [] }));
      return;
    }
    if (hasJob && !selectedJob) {
      setGradeOptions((prev) => ({ ...prev, [templateId]: [] }));
      return;
    }
    if (!hasJob && hasGang && !selectedGang) {
      setGradeOptions((prev) => ({ ...prev, [templateId]: [] }));
      return;
    }

    setGradeBusy((prev) => ({ ...prev, [templateId]: true }));
    try {
      if (hasJob) {
        const res = await api<{ items: GradeSuggestion[] }>(
          `/jobs/${encodeURIComponent(selectedJob)}/grades`,
        );
        setGradeOptions((prev) => ({ ...prev, [templateId]: res.items || [] }));
      } else {
        const res = await api<{ items: GradeSuggestion[] }>(
          `/gangs/${encodeURIComponent(selectedGang)}/grades`,
        );
        setGradeOptions((prev) => ({ ...prev, [templateId]: res.items || [] }));
      }
    } catch {
      setGradeOptions((prev) => ({ ...prev, [templateId]: [] }));
    } finally {
      setGradeBusy((prev) => ({ ...prev, [templateId]: false }));
    }
  }

  async function executeTemplate(template: GameActionTemplate) {
    if (!onlineStatus?.online) {
      setErr("Игрок оффлайн. Внутриигровое взаимодействие недоступно.");
      return;
    }
    setGameActionBusy(template.id);
    setGameActionStatus("");
    setErr("");
    try {
      const rawValues = gameActionValues[template.id] || {};
      const values: Record<string, string> = {};
      for (const [k, v] of Object.entries(rawValues)) {
        if (AUTO_VARIABLE_KEYS.has(k)) continue;
        values[k] = v;
      }
      await api(`/players/${cid}/game-actions/execute`, {
        method: "POST",
        body: JSON.stringify({
          template_id: template.id,
          values,
        }),
      });
      setGameActionStatus(`Шаблон "${template.name}" выполнен.`);
    } catch (e: unknown) {
      setErr(e instanceof Error ? e.message : String(e));
    } finally {
      setGameActionBusy(null);
    }
  }

  const checkOnlineStatus = useCallback(async (silent = false) => {
    setCheckingOnline(true);
    if (!silent) {
      setErr("");
    }
    try {
      const st = await api<OnlineStatus>(`/players/${cid}/online-status`);
      setOnlineStatus(st);
      if (!st.online) {
        setShowGamePanel(false);
      }
    } catch (e: unknown) {
      if (!silent) {
        setErr(e instanceof Error ? e.message : String(e));
      }
    } finally {
      setCheckingOnline(false);
    }
  }, [cid]);

  useEffect(() => {
    if (!can(me, "players.game_interact")) return;
    void checkOnlineStatus(true);

    const timer = window.setInterval(() => {
      void checkOnlineStatus(true);
    }, 15000);
    return () => window.clearInterval(timer);
  }, [cid, me, checkOnlineStatus]);

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
          {can(me, "players.game_interact") && (
            <div className="row" style={{ flexWrap: "wrap", marginTop: 8, marginBottom: 8 }}>
              <button className="btn secondary" disabled={checkingOnline} onClick={() => void checkOnlineStatus(false)}>
                {checkingOnline ? "Проверка..." : "Проверить онлайн"}
              </button>
              <div
                style={{
                  fontWeight: 700,
                  color:
                    onlineStatus === null
                      ? "#c7cfdd"
                      : onlineStatus.online
                        ? "#39d98a"
                        : "#ff5f5f",
                }}
              >
                {onlineStatus === null
                  ? "Проверка статуса..."
                  : onlineStatus.online
                    ? `Онлайн (ID ${String(onlineStatus.source ?? "-")})`
                    : "Оффлайн"}
              </div>
            </div>
          )}
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

            {can(me, "players.game_interact") && (
              <>
                <input
                  className="input"
                  value={kickReason}
                  onChange={(e) => setKickReason(e.target.value)}
                  placeholder="Причина кика (опционально)"
                  style={{ minWidth: 240 }}
                  maxLength={256}
                />
                <button
                  disabled={busy || !onlineStatus?.online}
                  className="btn danger"
                  onClick={kickPlayerNow}
                  title={onlineStatus?.online ? "" : "Игрок оффлайн"}
                >
                  Кикнуть
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

      {can(me, "players.game_interact") && (
        <section className="card" style={{ marginTop: 12 }}>
          <div className="row" style={{ justifyContent: "space-between", alignItems: "center" }}>
            <h3 style={{ margin: 0 }}>Внутриигровое взаимодействие</h3>
            <button
              className="btn secondary"
              onClick={() => setShowGamePanel((s) => !s)}
              disabled={!onlineStatus?.online}
            >
              {showGamePanel ? "Скрыть" : "Открыть"}
            </button>
          </div>
          {!onlineStatus?.online && (
            <div className="small" style={{ marginTop: 8 }}>
              Раздел доступен только когда игрок онлайн. Нажми «Проверить онлайн».
            </div>
          )}

          {showGamePanel && onlineStatus?.online && (
            <div style={{ marginTop: 10 }}>
              {gameActionStatus && <div className="small">{gameActionStatus}</div>}
              {gameActions.length === 0 ? (
                <p className="muted">Активные шаблоны не настроены.</p>
              ) : (
                <div className="grid">
                  {gameActions.map((tmpl) => (
                    <article key={tmpl.id} className="metaLine">
                      <div>
                        <strong>{tmpl.name}</strong>
                        <div className="small">{tmpl.description || "Без описания"}</div>
                        <div className="small">
                          {tmpl.action_type}
                          {tmpl.resource_name ? ` | ${tmpl.resource_name}` : ""} | {tmpl.action_name}
                        </div>
                      </div>

                      {(tmpl.variables || []).length > 0 && (
                        <div className="metaGrid" style={{ marginTop: 8 }}>
                          {tmpl.variables.map((v) => (
                            <div key={`${tmpl.id}-${v.key}`}>
                              <label className="metaKey">
                                {v.label || v.key}
                                {v.required ? " *" : ""}
                              </label>
                              {AUTO_VARIABLE_KEYS.has(v.key) ? (
                                <input className="input" value="Авто" disabled readOnly />
                              ) : v.key === "item" ? (
                                <div>
                                  <input
                                    className="input"
                                    value={gameActionValues[tmpl.id]?.[v.key] ?? ""}
                                    onChange={(e) => {
                                      const next = e.target.value;
                                      setTemplateValue(tmpl.id, v.key, next);
                                      void searchItemSuggestions(tmpl.id, v.key, next);
                                    }}
                                    placeholder="Введите label или key предмета"
                                  />
                                  {(itemSuggestions[getItemSuggestKey(tmpl.id, v.key)] || []).length > 0 && (
                                    <div
                                      style={{
                                        border: "1px solid #2c3850",
                                        borderRadius: 8,
                                        marginTop: 6,
                                        maxHeight: 180,
                                        overflowY: "auto",
                                        background: "#101726",
                                      }}
                                    >
                                      {(itemSuggestions[getItemSuggestKey(tmpl.id, v.key)] || []).map((s) => (
                                        <button
                                          key={`${tmpl.id}-${v.key}-${s.item}`}
                                          type="button"
                                          onClick={() => {
                                            setTemplateValue(tmpl.id, v.key, s.item);
                                            setItemSuggestions((prev) => ({
                                              ...prev,
                                              [getItemSuggestKey(tmpl.id, v.key)]: [],
                                            }));
                                          }}
                                          style={{
                                            display: "block",
                                            width: "100%",
                                            textAlign: "left",
                                            padding: "8px 10px",
                                            border: "none",
                                            borderBottom: "1px solid #1a2438",
                                            background: "transparent",
                                            color: "inherit",
                                            cursor: "pointer",
                                          }}
                                        >
                                          {s.label} <span className="muted">({s.item})</span>
                                        </button>
                                      ))}
                                    </div>
                                  )}
                                  {itemSuggestBusy[getItemSuggestKey(tmpl.id, v.key)] && (
                                    <div className="small" style={{ marginTop: 4 }}>
                                      Поиск...
                                    </div>
                                  )}
                                </div>
                              ) : v.key === "job" ? (
                                <div>
                                  <input
                                    className="input"
                                    value={gameActionValues[tmpl.id]?.[v.key] ?? ""}
                                    onChange={(e) => {
                                      const next = e.target.value;
                                      setTemplateValue(tmpl.id, v.key, next);
                                      void searchJobSuggestions(tmpl.id, v.key, next);
                                    }}
                                    placeholder="Введите job label или key"
                                  />
                                  {(jobSuggestions[getItemSuggestKey(tmpl.id, v.key)] || []).length > 0 && (
                                    <div
                                      style={{
                                        border: "1px solid #2c3850",
                                        borderRadius: 8,
                                        marginTop: 6,
                                        maxHeight: 180,
                                        overflowY: "auto",
                                        background: "#101726",
                                      }}
                                    >
                                      {(jobSuggestions[getItemSuggestKey(tmpl.id, v.key)] || []).map((s) => (
                                        <button
                                          key={`${tmpl.id}-${v.key}-${s.job}`}
                                          type="button"
                                          onClick={() => {
                                            const nextValues = {
                                              ...(gameActionValues[tmpl.id] || {}),
                                              [v.key]: s.job,
                                            };
                                            setGameActionValues((prev) => ({ ...prev, [tmpl.id]: nextValues }));
                                            setJobSuggestions((prev) => ({
                                              ...prev,
                                              [getItemSuggestKey(tmpl.id, v.key)]: [],
                                            }));
                                            void loadGradeOptions(tmpl, nextValues);
                                          }}
                                          style={{
                                            display: "block",
                                            width: "100%",
                                            textAlign: "left",
                                            padding: "8px 10px",
                                            border: "none",
                                            borderBottom: "1px solid #1a2438",
                                            background: "transparent",
                                            color: "inherit",
                                            cursor: "pointer",
                                          }}
                                        >
                                          {s.label} <span className="muted">({s.job})</span>
                                        </button>
                                      ))}
                                    </div>
                                  )}
                                  {groupSuggestBusy[getItemSuggestKey(tmpl.id, v.key)] && (
                                    <div className="small" style={{ marginTop: 4 }}>
                                      Поиск...
                                    </div>
                                  )}
                                </div>
                              ) : v.key === "gang" ? (
                                <div>
                                  <input
                                    className="input"
                                    value={gameActionValues[tmpl.id]?.[v.key] ?? ""}
                                    onChange={(e) => {
                                      const next = e.target.value;
                                      setTemplateValue(tmpl.id, v.key, next);
                                      void searchGangSuggestions(tmpl.id, v.key, next);
                                    }}
                                    placeholder="Введите gang label или key"
                                  />
                                  {(gangSuggestions[getItemSuggestKey(tmpl.id, v.key)] || []).length > 0 && (
                                    <div
                                      style={{
                                        border: "1px solid #2c3850",
                                        borderRadius: 8,
                                        marginTop: 6,
                                        maxHeight: 180,
                                        overflowY: "auto",
                                        background: "#101726",
                                      }}
                                    >
                                      {(gangSuggestions[getItemSuggestKey(tmpl.id, v.key)] || []).map((s) => (
                                        <button
                                          key={`${tmpl.id}-${v.key}-${s.gang}`}
                                          type="button"
                                          onClick={() => {
                                            const nextValues = {
                                              ...(gameActionValues[tmpl.id] || {}),
                                              [v.key]: s.gang,
                                            };
                                            setGameActionValues((prev) => ({ ...prev, [tmpl.id]: nextValues }));
                                            setGangSuggestions((prev) => ({
                                              ...prev,
                                              [getItemSuggestKey(tmpl.id, v.key)]: [],
                                            }));
                                            void loadGradeOptions(tmpl, nextValues);
                                          }}
                                          style={{
                                            display: "block",
                                            width: "100%",
                                            textAlign: "left",
                                            padding: "8px 10px",
                                            border: "none",
                                            borderBottom: "1px solid #1a2438",
                                            background: "transparent",
                                            color: "inherit",
                                            cursor: "pointer",
                                          }}
                                        >
                                          {s.label} <span className="muted">({s.gang})</span>
                                        </button>
                                      ))}
                                    </div>
                                  )}
                                  {groupSuggestBusy[getItemSuggestKey(tmpl.id, v.key)] && (
                                    <div className="small" style={{ marginTop: 4 }}>
                                      Поиск...
                                    </div>
                                  )}
                                </div>
                              ) : v.key === "grade" ? (
                                <div>
                                  {((gradeOptions[tmpl.id] || []).length > 0) ? (
                                    <select
                                      className="input"
                                      value={gameActionValues[tmpl.id]?.[v.key] ?? ""}
                                      onChange={(e) => setTemplateValue(tmpl.id, v.key, e.target.value)}
                                    >
                                      <option value="">Выберите grade</option>
                                      {(gradeOptions[tmpl.id] || []).map((g) => (
                                        <option key={`${tmpl.id}-grade-${g.grade}`} value={String(g.grade)}>
                                          {g.name} ({g.grade})
                                        </option>
                                      ))}
                                    </select>
                                  ) : (
                                    <input
                                      className="input"
                                      value={gameActionValues[tmpl.id]?.[v.key] ?? ""}
                                      onChange={(e) => setTemplateValue(tmpl.id, v.key, e.target.value)}
                                      placeholder="Сначала выберите job/gang"
                                    />
                                  )}
                                  <div style={{ marginTop: 6 }}>
                                    <button
                                      type="button"
                                      className="btn secondary"
                                      onClick={() =>
                                        void loadGradeOptions(tmpl, gameActionValues[tmpl.id] || {})
                                      }
                                      disabled={Boolean(gradeBusy[tmpl.id])}
                                    >
                                      {gradeBusy[tmpl.id] ? "Загрузка grades..." : "Обновить grades"}
                                    </button>
                                  </div>
                                </div>
                              ) : (
                                <input
                                  className="input"
                                  value={gameActionValues[tmpl.id]?.[v.key] ?? ""}
                                  onChange={(e) => setTemplateValue(tmpl.id, v.key, e.target.value)}
                                  placeholder={
                                    v.default_value
                                      ? `default: ${String(v.default_value)}`
                                      : "Пусто = взять из профиля игрока"
                                  }
                                />
                              )}
                            </div>
                          ))}
                        </div>
                      )}

                      <div style={{ marginTop: 8 }}>
                        <button
                          className="btn"
                          disabled={gameActionBusy !== null}
                          onClick={() => executeTemplate(tmpl)}
                        >
                          {gameActionBusy === tmpl.id ? "Выполнение..." : "Выполнить"}
                        </button>
                      </div>
                    </article>
                  ))}
                </div>
              )}
            </div>
          )}
        </section>
      )}

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
