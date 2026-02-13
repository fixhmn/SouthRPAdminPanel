"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { AdminMe, api, can, fetchMe, roleLabel } from "@/lib/api";

type InvLogRow = {
  id: number;
  ts: string;
  action_key: string;
  item_name: string | null;
  item_label: string | null;
  item_count: number;
  plate: string | null;
  drop_id: string | null;
  actor_source: number | null;
  actor_citizenid: string | null;
  actor_static_id: number | null;
  actor_name: string | null;
  target_source: number | null;
  target_citizenid: string | null;
  target_static_id: number | null;
  target_name: string | null;
  from_type: string | null;
  to_type: string | null;
  from_inventory: string | null;
  to_inventory: string | null;
};

type InvActionsRow = {
  action_key: string;
  count: number;
};

type InvLogsRes = {
  total: number;
  count: number;
  limit: number;
  offset: number;
  items: InvLogRow[];
  actions: InvActionsRow[];
  admin: string;
};

const ACTION_LABELS: Record<string, string> = {
  give_player: "Передача игроку",
  drop_ground: "Выброс на землю",
  pickup_drop: "Поднятие из дропа",
  put_glovebox: "Положил в бардачок",
  take_glovebox: "Взял из бардачка",
  put_trunk: "Положил в багажник",
  take_trunk: "Взял из багажника",
  trunk_to_glovebox: "Багажник -> бардачок",
  glovebox_to_trunk: "Бардачок -> багажник",
  stack: "Объединение (stack)",
  swap: "Swap",
};

function formatMoscowTime(raw: string): string {
  const normalized = raw.includes("T") ? raw : raw.replace(" ", "T");
  const hasZone = /[zZ]|[+\-]\d{2}:?\d{2}$/.test(normalized);
  const asUtc = hasZone ? normalized : `${normalized}Z`;
  const dt = new Date(asUtc);
  if (Number.isNaN(dt.getTime())) return raw;
  return new Intl.DateTimeFormat("ru-RU", {
    timeZone: "Europe/Moscow",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
  }).format(dt);
}

function actorText(row: InvLogRow): string {
  if (row.actor_name && row.actor_name.trim()) return row.actor_name;
  if (row.actor_source !== null && row.actor_source !== undefined) return `ID ${row.actor_source}`;
  return "Система";
}

function targetText(row: InvLogRow): string {
  if (row.target_name && row.target_name.trim()) return row.target_name;
  if (row.target_source !== null && row.target_source !== undefined) return `ID ${row.target_source}`;
  return "-";
}

function itemText(row: InvLogRow): string {
  const item = row.item_label || row.item_name || "item";
  return `${item} x${row.item_count || 1}`;
}

function storageText(type: string | null, inv: string | null, plate: string | null): string {
  if (type === "glovebox") return `бардачок ${plate || inv || "-"}`;
  if (type === "trunk") return `багажник ${plate || inv || "-"}`;
  if (type === "drop") return `дроп ${inv || "-"}`;
  if (type === "player") return `инвентарь игрока ${inv || "-"}`;
  return `${type || "?"} ${inv || "-"}`;
}

function normalizePlate(raw: string | null | undefined): string {
  return (raw || "").trim().toUpperCase();
}

function VehiclePlateLink({ plate }: { plate: string | null | undefined }) {
  const normalized = normalizePlate(plate);
  if (!normalized) return null;
  return (
    <Link className="link" href={`/vehicles?plate=${encodeURIComponent(normalized)}`}>
      {normalized}
    </Link>
  );
}

function actionLabel(row: InvLogRow): string {
  return ACTION_LABELS[row.action_key] || `Перемещение ${row.from_type || "?"} -> ${row.to_type || "?"}`;
}

function messageText(row: InvLogRow): string {
  const actor = actorText(row);
  const target = targetText(row);
  const item = itemText(row);
  const plateOrDrop = row.plate || row.drop_id || "-";

  switch (row.action_key) {
    case "drop_ground":
      return `${actor} выбросил ${item} на землю (${plateOrDrop})`;
    case "pickup_drop":
      return `${actor} поднял ${item} из дропа (${plateOrDrop})`;
    case "give_player":
      return `${actor} передал ${item} игроку ${target}`;
    case "put_glovebox":
      return `${actor} положил ${item} в бардачок ${plateOrDrop}`;
    case "take_glovebox":
      return `${actor} достал ${item} из бардачка ${plateOrDrop}`;
    case "put_trunk":
      return `${actor} положил ${item} в багажник ${plateOrDrop}`;
    case "take_trunk":
      return `${actor} достал ${item} из багажника ${plateOrDrop}`;
    case "trunk_to_glovebox":
      return `${actor} переместил ${item} из багажника в бардачок ${plateOrDrop}`;
    case "glovebox_to_trunk":
      return `${actor} переместил ${item} из бардачка в багажник ${plateOrDrop}`;
    case "stack":
      return `${actor} объединил стаки: ${item}`;
    case "swap":
      return `${actor} поменял слоты/предметы: ${item}`;
    default:
      return `${actor}: ${item} (${storageText(row.from_type, row.from_inventory, row.plate)} -> ${storageText(row.to_type, row.to_inventory, row.plate)})`;
  }
}

function storageNode(type: string | null, inv: string | null, plate: string | null) {
  if ((type === "glovebox" || type === "trunk") && normalizePlate(plate)) {
    const label = type === "glovebox" ? "бардачок" : "багажник";
    return (
      <>
        {label} <VehiclePlateLink plate={plate} />
      </>
    );
  }
  return <>{storageText(type, inv, plate)}</>;
}

function playerLink(citizenid: string | null, fallback: string) {
  if (!citizenid) return <span>{fallback}</span>;
  return (
    <Link className="link" href={`/players/${encodeURIComponent(citizenid)}`}>
      {fallback}
    </Link>
  );
}

export default function InventoryGameLogsPage() {
  const [me, setMe] = useState<AdminMe | null>(null);
  const [err, setErr] = useState("");
  const [busy, setBusy] = useState(false);
  const [data, setData] = useState<InvLogsRes | null>(null);

  const [limit, setLimit] = useState(100);
  const [offset, setOffset] = useState(0);
  const [action, setAction] = useState("");
  const [player, setPlayer] = useState("");
  const [item, setItem] = useState("");
  const [dateFrom, setDateFrom] = useState("");
  const [dateTo, setDateTo] = useState("");
  const [sort, setSort] = useState("date_desc");
  const [autoRefresh, setAutoRefresh] = useState(true);

  async function load(nextOffset?: number, silent = false) {
    if (!silent) setBusy(true);
    if (!silent) setErr("");
    try {
      const admin = await fetchMe();
      setMe(admin);
      if (!can(admin, "game_logs.inventory.read")) {
        setData(null);
        return;
      }

      const off = nextOffset ?? offset;
      const qs = new URLSearchParams();
      qs.set("limit", String(limit));
      qs.set("offset", String(off));
      if (action.trim()) qs.set("action", action.trim());
      if (player.trim()) qs.set("player", player.trim());
      if (item.trim()) qs.set("item", item.trim());
      if (dateFrom.trim()) qs.set("date_from", dateFrom.trim());
      if (dateTo.trim()) qs.set("date_to", dateTo.trim());
      qs.set("sort", sort);

      const res = await api<InvLogsRes>(`/game-logs/inventory?${qs.toString()}`);
      setData(res);
      setOffset(off);
    } catch (e: unknown) {
      if (!silent) {
        setErr(e instanceof Error ? e.message : String(e));
      }
    } finally {
      if (!silent) setBusy(false);
    }
  }

  useEffect(() => {
    void load(0);
  }, []);

  useEffect(() => {
    if (!autoRefresh) return;
    const timer = setInterval(() => {
      void load(offset, true);
    }, 5000);
    return () => clearInterval(timer);
  }, [autoRefresh, offset, limit, action, player, item, dateFrom, dateTo, sort]);

  const totalPages = useMemo(() => {
    if (!data) return 1;
    return Math.max(1, Math.ceil(data.total / data.limit));
  }, [data]);

  const currentPage = useMemo(() => {
    if (!data) return 1;
    return Math.floor(data.offset / data.limit) + 1;
  }, [data]);

  const actionsForFilter = useMemo(
    () => (data?.actions || []).filter((a) => a.action_key && a.action_key !== "other"),
    [data]
  );

  return (
    <main className="container">
      <header className="card" style={{ marginBottom: 14 }}>
        <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap" }}>
          <div>
            <h1 className="title" style={{ marginBottom: 6 }}>
              Игровые логи: Инвентарь
            </h1>
            <div className="muted">{me ? `Вы: ${me.login} (${roleLabel(me.role_name)})` : "Проверка авторизации..."}</div>
          </div>
          <div className="row" style={{ flexWrap: "wrap" }}>
            <Link className="btn secondary" href="/">
              Главная
            </Link>
            <Link className="btn secondary" href="/game-logs">
              Разделы логов
            </Link>
            <Link className="btn secondary" href="/players">
              Игроки
            </Link>
          </div>
        </div>
      </header>

      {err && <pre className="error">{err}</pre>}

      {!can(me, "game_logs.inventory.read") ? (
        <section className="card">
          <h3 style={{ marginTop: 0 }}>Нет доступа</h3>
          <p className="muted">Требуется permission `game_logs.inventory.read`.</p>
        </section>
      ) : (
        <>
          <section className="card">
            <div className="row" style={{ flexWrap: "wrap", alignItems: "end" }}>
              <div>
                <label className="small" htmlFor="inv-action">Действие</label>
                <select id="inv-action" className="input" value={action} onChange={(e) => setAction(e.target.value)}>
                  <option value="">Все</option>
                  {actionsForFilter.map((a) => (
                    <option key={a.action_key} value={a.action_key}>
                      {ACTION_LABELS[a.action_key] || a.action_key} ({a.count})
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="small" htmlFor="inv-player">Игрок</label>
                <input
                  id="inv-player"
                  className="input"
                  placeholder="Имя / citizenid / static_id"
                  value={player}
                  onChange={(e) => setPlayer(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === "Enter") {
                      e.preventDefault();
                      void load(0);
                    }
                  }}
                />
              </div>

              <div>
                <label className="small" htmlFor="inv-item">Предмет</label>
                <input
                  id="inv-item"
                  className="input"
                  placeholder="item / label"
                  value={item}
                  onChange={(e) => setItem(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === "Enter") {
                      e.preventDefault();
                      void load(0);
                    }
                  }}
                />
              </div>

              <div>
                <label className="small" htmlFor="inv-date-from">Дата от (ISO)</label>
                <input id="inv-date-from" className="input" placeholder="2026-02-13T00:00:00" value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} />
              </div>

              <div>
                <label className="small" htmlFor="inv-date-to">Дата до (ISO)</label>
                <input id="inv-date-to" className="input" placeholder="2026-02-13T23:59:59" value={dateTo} onChange={(e) => setDateTo(e.target.value)} />
              </div>

              <div>
                <label className="small" htmlFor="inv-sort">Сортировка</label>
                <select id="inv-sort" className="input" value={sort} onChange={(e) => setSort(e.target.value)}>
                  <option value="date_desc">Дата (сначала новые)</option>
                  <option value="date_asc">Дата (сначала старые)</option>
                  <option value="item_asc">Предмет (A-Z)</option>
                  <option value="item_desc">Предмет (Z-A)</option>
                </select>
              </div>

              <div>
                <label className="small" htmlFor="inv-limit">Лимит</label>
                <select id="inv-limit" className="input" value={limit} onChange={(e) => setLimit(parseInt(e.target.value, 10))}>
                  <option value={50}>50</option>
                  <option value={100}>100</option>
                  <option value={200}>200</option>
                  <option value={500}>500</option>
                </select>
              </div>

              <button className="btn" onClick={() => void load(0)} disabled={busy}>
                {busy ? "Загрузка..." : "Применить"}
              </button>
            </div>

            <div className="row" style={{ marginTop: 10, justifyContent: "space-between", flexWrap: "wrap" }}>
              <label className="small" style={{ display: "flex", alignItems: "center", gap: 8 }}>
                <input type="checkbox" checked={autoRefresh} onChange={(e) => setAutoRefresh(e.target.checked)} />
                Автообновление (каждые 5с)
              </label>
              <div className="small">{autoRefresh ? "Лента обновляется" : "Лента на паузе (скролл не дергается)"}</div>
            </div>
          </section>

          <section className="card" style={{ marginTop: 12 }}>
            <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap", marginBottom: 8 }}>
              <div className="small">
                Всего: {data?.total ?? 0} | Страница: {currentPage}/{totalPages}
              </div>
              <div className="row">
                <button className="btn secondary" onClick={() => void load(Math.max(0, offset - limit))} disabled={busy || offset <= 0}>
                  Назад
                </button>
                <button
                  className="btn secondary"
                  onClick={() => void load(offset + limit)}
                  disabled={busy || !data || offset + limit >= data.total}
                >
                  Вперед
                </button>
              </div>
            </div>

            <div className="tableWrap">
              <table className="table auditTable">
                <thead>
                  <tr>
                    <th className="auditNowrap">ID</th>
                    <th className="auditNowrap">Время (МСК)</th>
                    <th className="auditNowrap">Действие</th>
                    <th>Событие</th>
                    <th>Игроки</th>
                    <th className="auditNowrap">Предмет</th>
                    <th className="auditNowrap">Источник {"->"} Цель</th>
                  </tr>
                </thead>
                <tbody>
                  {(data?.items || []).map((row) => (
                    <tr key={row.id}>
                      <td className="auditNowrap">{row.id}</td>
                      <td className="auditNowrap">{formatMoscowTime(row.ts)}</td>
                      <td className="auditNowrap">{actionLabel(row)}</td>
                      <td className="auditJson">{messageText(row)}</td>
                      <td className="auditJson">
                        <div>
                          Отправитель: {playerLink(row.actor_citizenid, actorText(row))}
                          {row.actor_static_id ? ` (static ${row.actor_static_id})` : ""}
                        </div>
                        <div>
                          Получатель: {playerLink(row.target_citizenid, targetText(row))}
                          {row.target_static_id ? ` (static ${row.target_static_id})` : ""}
                        </div>
                      </td>
                      <td className="auditNowrap">{itemText(row)}</td>
                      <td className="auditJson">
                        {storageNode(row.from_type, row.from_inventory, row.plate)}
                        {" -> "}
                        {storageNode(row.to_type, row.to_inventory, row.plate)}
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
