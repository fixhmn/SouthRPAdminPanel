"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { AdminMe, can, fetchMe, roleLabel } from "@/lib/api";

export default function GameLogsPage() {
  const [me, setMe] = useState<AdminMe | null>(null);

  useEffect(() => {
    fetchMe().then(setMe).catch(() => setMe(null));
  }, []);

  return (
    <main className="container">
      <header className="card" style={{ marginBottom: 14 }}>
        <div className="row" style={{ justifyContent: "space-between", flexWrap: "wrap" }}>
          <div>
            <h1 className="title" style={{ marginBottom: 6 }}>
              Game Logs
            </h1>
            <div className="muted">{me ? `You: ${me.login} (${roleLabel(me.role_name)})` : "Checking auth..."}</div>
          </div>
          <div className="row" style={{ flexWrap: "wrap" }}>
            <Link className="btn secondary" href="/">
              Home
            </Link>
            <Link className="btn secondary" href="/players">
              Players
            </Link>
            {can(me, "audit.read") && (
              <Link className="btn secondary" href="/audit">
                Audit
              </Link>
            )}
          </div>
        </div>
      </header>

      <section className="grid">
        <article className="card">
          <h3 style={{ marginTop: 0 }}>Inventory Logs</h3>
          <p className="small">Transfers, drops, pickups, glovebox/trunk movements, and other inventory actions.</p>
          <div style={{ marginTop: 10 }}>
            <Link className="btn" href="/game-logs/inventory">
              Open
            </Link>
          </div>
        </article>
      </section>
    </main>
  );
}
