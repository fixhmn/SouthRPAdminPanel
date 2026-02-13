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
  give_player: "Give to player",
  drop_ground: "Drop to ground",
  pickup_drop: "Pickup from drop",
  put_glovebox: "Put to glovebox",
  take_glovebox: "Take from glovebox",
  put_trunk: "Put to trunk",
  take_trunk: "Take from trunk",
  trunk_to_glovebox: "Trunk -> glovebox",
  glovebox_to_trunk: "Glovebox -> trunk",
  stack: "Stack",
  swap: "Swap",
  other: "Other",
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
  if (row.actor_name) return row.actor_name;
  if (row.actor_source !== null && row.actor_source !== undefined) return `ID ${row.actor_source}`;
  return "System";
}

function targetText(row: InvLogRow): string {
  if (row.target_name) return row.target_name;
  if (row.target_source !== null && row.target_source !== undefined) return `ID ${row.target_source}`;
  return "-";
}

function itemText(row: InvLogRow): string {
  const item = row.item_label || row.item_name || "item";
  return `${item} x${row.item_count || 1}`;
}

function storageText(type: string | null, inv: string | null, plate: string | null): string {
  if (type === "glovebox") return `glovebox ${plate || inv || "-"}`;
  if (type === "trunk") return `trunk ${plate || inv || "-"}`;
  if (type === "drop") return `drop ${inv || "-"}`;
  if (type === "player") return `player ${inv || "-"}`;
  return `${type || "?"} ${inv || "-"}`;
}

function messageText(row: InvLogRow): string {
  const actor = actorText(row);
  const target = targetText(row);
  const item = itemText(row);
  const plateOrDrop = row.plate || row.drop_id || "-";

  switch (row.action_key) {
    case "drop_ground":
      return `${actor} dropped ${item} to ground (${plateOrDrop})`;
    case "pickup_drop":
      return `${actor} picked up ${item} from drop (${plateOrDrop})`;
    case "give_player":
      return `${actor} gave ${item} to ${target}`;
    case "put_glovebox":
      return `${actor} put ${item} to glovebox ${plateOrDrop}`;
    case "take_glovebox":
      return `${actor} took ${item} from glovebox ${plateOrDrop}`;
    case "put_trunk":
      return `${actor} put ${item} to trunk ${plateOrDrop}`;
    case "take_trunk":
      return `${actor} took ${item} from trunk ${plateOrDrop}`;
    case "trunk_to_glovebox":
      return `${actor} moved ${item} trunk -> glovebox ${plateOrDrop}`;
    case "glovebox_to_trunk":
      return `${actor} moved ${item} glovebox -> trunk ${plateOrDrop}`;
    default:
      return `${actor}: ${item} (${storageText(row.from_type, row.from_inventory, row.plate)} -> ${storageText(row.to_type, row.to_inventory, row.plate)})`;
  }
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

  async function load(nextOffset?: number) {
    setBusy(true);
    setErr("");
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
      setErr(e instanceof Error ? e.message : String(e));
    } finally {
      setBusy(false);
    }
  }

  useEffect(() => {
    void load(0);
  }, []);

  const totalPages = useMemo(() => {
    if (!data) return 1;
    return Math.max(1, Math.ceil(data.total / data.limit));
  }, [data]);

  const currentPage = useMemo(() => {
    if (!data) return 1;
    return Math.floor(data.offset / data.limit) + 1;
  }, [data]);

  return (
    <main className="container">
      <header className="card" style={{ marginBottom: 14 }}>
        <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap" }}>
          <div>
            <h1 className="title" style={{ marginBottom: 6 }}>
              Game Logs: Inventory
            </h1>
            <div className="muted">{me ? `You: ${me.login} (${roleLabel(me.role_name)})` : "Checking auth..."}</div>
          </div>
          <div className="row" style={{ flexWrap: "wrap" }}>
            <Link className="btn secondary" href="/">
              Home
            </Link>
            <Link className="btn secondary" href="/game-logs">
              Log Sections
            </Link>
            <Link className="btn secondary" href="/players">
              Players
            </Link>
          </div>
        </div>
      </header>

      {err && <pre className="error">{err}</pre>}

      {!can(me, "game_logs.inventory.read") ? (
        <section className="card">
          <h3 style={{ marginTop: 0 }}>No access</h3>
          <p className="muted">Permission `game_logs.inventory.read` is required.</p>
        </section>
      ) : (
        <>
          <section className="card">
            <div className="row" style={{ flexWrap: "wrap", alignItems: "end" }}>
              <div>
                <label className="small" htmlFor="inv-action">Action</label>
                <select id="inv-action" className="input" value={action} onChange={(e) => setAction(e.target.value)}>
                  <option value="">All</option>
                  {(data?.actions || []).map((a) => (
                    <option key={a.action_key} value={a.action_key}>
                      {ACTION_LABELS[a.action_key] || a.action_key} ({a.count})
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="small" htmlFor="inv-player">Player</label>
                <input
                  id="inv-player"
                  className="input"
                  placeholder="Name / citizenid / static_id"
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
                <label className="small" htmlFor="inv-item">Item</label>
                <input
                  id="inv-item"
                  className="input"
                  placeholder="item name / label"
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
                <label className="small" htmlFor="inv-date-from">Date from (ISO)</label>
                <input id="inv-date-from" className="input" placeholder="2026-02-13T00:00:00" value={dateFrom} onChange={(e) => setDateFrom(e.target.value)} />
              </div>

              <div>
                <label className="small" htmlFor="inv-date-to">Date to (ISO)</label>
                <input id="inv-date-to" className="input" placeholder="2026-02-13T23:59:59" value={dateTo} onChange={(e) => setDateTo(e.target.value)} />
              </div>

              <div>
                <label className="small" htmlFor="inv-sort">Sort</label>
                <select id="inv-sort" className="input" value={sort} onChange={(e) => setSort(e.target.value)}>
                  <option value="date_desc">Date (new first)</option>
                  <option value="date_asc">Date (old first)</option>
                  <option value="item_asc">Item (A-Z)</option>
                  <option value="item_desc">Item (Z-A)</option>
                </select>
              </div>

              <div>
                <label className="small" htmlFor="inv-limit">Limit</label>
                <select id="inv-limit" className="input" value={limit} onChange={(e) => setLimit(parseInt(e.target.value, 10))}>
                  <option value={50}>50</option>
                  <option value={100}>100</option>
                  <option value={200}>200</option>
                  <option value={500}>500</option>
                </select>
              </div>

              <button className="btn" onClick={() => void load(0)} disabled={busy}>
                {busy ? "Loading..." : "Apply"}
              </button>
            </div>
          </section>

          <section className="card" style={{ marginTop: 12 }}>
            <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap", marginBottom: 8 }}>
              <div className="small">
                Total: {data?.total ?? 0} | Page: {currentPage}/{totalPages}
              </div>
              <div className="row">
                <button className="btn secondary" onClick={() => void load(Math.max(0, offset - limit))} disabled={busy || offset <= 0}>
                  Prev
                </button>
                <button
                  className="btn secondary"
                  onClick={() => void load(offset + limit)}
                  disabled={busy || !data || offset + limit >= data.total}
                >
                  Next
                </button>
              </div>
            </div>

            <div className="tableWrap">
              <table className="table auditTable">
                <thead>
                  <tr>
                    <th className="auditNowrap">ID</th>
                    <th className="auditNowrap">Time (MSK)</th>
                    <th className="auditNowrap">Action</th>
                    <th>Event</th>
                    <th>Players</th>
                    <th className="auditNowrap">Item</th>
                    <th className="auditNowrap">From {"->"} To</th>
                  </tr>
                </thead>
                <tbody>
                  {(data?.items || []).map((row) => (
                    <tr key={row.id}>
                      <td className="auditNowrap">{row.id}</td>
                      <td className="auditNowrap">{formatMoscowTime(row.ts)}</td>
                      <td className="auditNowrap">{ACTION_LABELS[row.action_key] || row.action_key}</td>
                      <td className="auditJson">{messageText(row)}</td>
                      <td className="auditJson">
                        <div>
                          Actor: {playerLink(row.actor_citizenid, actorText(row))}
                          {row.actor_static_id ? ` (static ${row.actor_static_id})` : ""}
                        </div>
                        <div>
                          Target: {playerLink(row.target_citizenid, targetText(row))}
                          {row.target_static_id ? ` (static ${row.target_static_id})` : ""}
                        </div>
                      </td>
                      <td className="auditNowrap">{itemText(row)}</td>
                      <td className="auditJson">{storageText(row.from_type, row.from_inventory, row.plate)}{" -> "}{storageText(row.to_type, row.to_inventory, row.plate)}</td>
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
