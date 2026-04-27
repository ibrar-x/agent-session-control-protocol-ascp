# @ascp/app-host-console

Codex-first browser workspace for testing the local ASCP WebSocket host with a chat-first UI and a layered operator rail.

## What It Exercises

- WebSocket host connection and reconnect
- `capabilities.get`
- `sessions.list`
- `sessions.start`
- `sessions.get`
- `sessions.subscribe`
- `sessions.send_input`
- `approvals.list` and `approvals.respond`
- `artifacts.list` and `artifacts.get`
- `diffs.get`

## Layout

- Left rail: multi-session switcher plus a lightweight new-session launcher
- Center pane: conversation timeline with inline approval and blocked-input cards
- Right rail: live state, session summary, current run, pending interactions, artifacts/diffs, recent events, and expandable raw JSON

## Behavior Notes

- Session switching blanks the detail pane immediately and reloads the next session as one coherent state bundle.
- If the snapshot loads but live subscribe fails, the UI falls back to `snapshot-only` and shows a visible `Live updates paused` banner.
- Artifact lists and diff detail load lazily only when the operator expands those sections.
- A brand-new Codex session can exist before turn materialization. The adapter and UI now degrade gracefully until the first user message lands.
- Reopened sessions replay historical transcript when the adapter can recover stored ASCP-safe events from Codex turn history.
- Reconnect preserves the selected session, restores the session list, and reattaches live subscription state after the transport comes back.

## Run

Start the Codex-backed host:

```bash
npm --workspace @ascp/adapter-codex run host
```

Then start the browser console:

```bash
npm --workspace @ascp/app-host-console run dev -- --host 127.0.0.1 --port 4173
```

The default host URL is `ws://127.0.0.1:8765`.

## Verification

```bash
npm --workspace @ascp/app-host-console test
npm --workspace @ascp/app-host-console run build
npm --workspace @ascp/adapter-codex exec vitest run tests/service.test.ts
```
