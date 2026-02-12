# south_webbridge

HTTP bridge resource for South RP Admin Panel.

## Install

1. Copy folder `south_webbridge` into your FiveM resources.
2. In `server.cfg` add:

```cfg
setr south_webbridge_token "CHANGE_ME_STRONG_TOKEN"
ensure south_webbridge
```

3. In admin panel API `.env` set:

```env
BRIDGE_URL=http://127.0.0.1:30120/south_webbridge/execute
BRIDGE_TOKEN=CHANGE_ME_STRONG_TOKEN
```

Token values in `server.cfg` and `.env` must be identical.

## Supported action types

- `export`
  - Executes: `exports[resource_name][action_name](table.unpack(args))`
- `server_event`
  - Executes: `TriggerEvent(action_name, table.unpack(args))`
- `qbx_set_job`
  - Uses qbx player object and runs: `player.Functions.SetJob(job, grade)`
  - Reads vars from payload: `job`/`Job`, `grade`/`Grade`
  - Resolves target player by `targetId`/`target_id`/`source` or by `citizenid` (online only)

## Online check

Bridge also exposes:

- `POST /south_webbridge/status`

Payload:
```json
{
  "player": {
    "static_id": 123,
    "citizenid": "ABCD1234"
  }
}
```

Response:
```json
{
  "ok": true,
  "online": true,
  "source": 57,
  "player_name": "SomePlayer"
}
```

`status` uses `exports["south_staticid"]:getPlayerIdFromStatic(static_id)` first, then fallback by `citizenid`.
