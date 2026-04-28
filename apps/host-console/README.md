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


## Pairing workspace

The host console now includes a separate `Pairing` workspace for daemon-admin onboarding flows.

It exercises the loopback pairing backend through:

- `GET /admin/pairing/sessions`
- `POST /admin/pairing/sessions`
- `POST /admin/pairing/sessions/:id/approve`
- `POST /admin/pairing/sessions/:id/reject`
- `GET /admin/trusted-devices`
- `POST /admin/trusted-devices/:id/revoke`

Behavior notes:

- pairing creation is inline within the lifecycle panel
- `pending_host_approval` sessions appear both in the lifecycle list and the approval queue
- v1 shows copyable pairing codes only; `qr_payload` is not rendered as an image yet
- polling runs every 3 seconds while pending or approved sessions exist, then slows to 30 seconds when all sessions are terminal

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
