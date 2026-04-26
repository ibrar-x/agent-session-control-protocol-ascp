# @ascp/app-host-console

Codex-first browser console for testing the local ASCP WebSocket host in real time.

## What It Exercises

- WebSocket host connection
- `capabilities.get`
- `sessions.list`
- `sessions.get`
- `sessions.subscribe`
- `sessions.send_input`
- `approvals.list` and `approvals.respond`
- `artifacts.list` and `artifacts.get`
- `diffs.get`

## Run

Start the Codex-backed host:

```bash
npm --workspace @ascp/adapter-codex run host
```

Then start the browser console:

```bash
npm --workspace @ascp/app-host-console run dev
```

The default host URL is `ws://127.0.0.1:8765`.
