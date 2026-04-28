# @ascp/host-daemon

Production-style local daemon package for composing ASCP runtime bindings with the reusable `@ascp/host-service` WebSocket transport.

This package is the next layer above `packages/host-service/`. It owns daemon bootstrap concerns such as config, runtime registration, process lifecycle, replay persistence, and host-wide auth/trust enforcement. It does not redefine ASCP methods, events, replay, approvals, or artifact semantics.

## Current slice

- resolves local daemon config from `ASCP_HOST`, `ASCP_PORT`, `ASCP_RUNTIME`, `ASCP_AUTH_TRANSPORT`, and `ASCP_DATABASE_PATH`
- creates the current Codex-backed runtime through a registry boundary
- seeds truthful current session baselines into SQLite-backed daemon stores
- persists real normalized live events and durable replay cursor state for attached sessions
- serves persistence-backed replay through a daemon replay broker and runtime wrapper
- persists host-wide trusted device records with `scrypt` verifier storage rather than plaintext secrets
- authenticates paired devices once per socket on loopback transport and enforces read/control scopes before runtime calls
- records daemon-generated correlation ids and audit outcomes for every authenticated request path
- exposes a loopback-only pairing backend with short-lived pairing sessions, mobile claim/poll flow, explicit host approval, and trusted-device list/revoke endpoints
- exposes additive `auth.transport` capability metadata without changing frozen ASCP method or event names
- includes additive snapshot metadata for `snapshot_origin`, `completeness`, `missing_fields`, `missing_reasons`, and `attachment_status`
- exposes a CLI entrypoint for local daemon startup

## Run

```bash
npm --workspace @ascp/host-daemon run start
```

## Verify

```bash
npm --workspace @ascp/host-daemon run check
```

## Snapshot semantics

- Seeded baselines are stored as current state, not synthetic historical events.
- `sync.snapshot` metadata marks whether the daemon baseline is `complete` or `partial`.
- Indexed-but-detached sessions are surfaced with `attachment_status: "detached"`.
- Detached-only sessions may still serve the last truthful baseline snapshot, but replay history is only served from real stored events.

## Auth semantics

- Pairing is host-wide, not per runtime or per session.
- v1 reconnect uses `device_id + secret` on loopback-only transport.
- The daemon stores only `scrypt` verifier material plus trust metadata in SQLite.
- `capabilities.get` includes additive `auth.transport` metadata so clients can detect loopback vs future TLS surfaces.

## Pairing backend

- The daemon starts a separate loopback-only admin HTTP surface for onboarding trusted devices.
- The admin surface is intentionally unauthenticated in v1 and relies entirely on `127.0.0.1` binding.
- `POST /admin/pairing/sessions` creates a short-lived pairing code and expiry.
- `POST /pairing/claim` lets an unauthenticated mobile client claim one pairing session.
- `POST /admin/pairing/sessions/:id/approve` or `/reject` resolves the pending claim.
- `GET /pairing/claims/:token` returns `pending_host_approval`, `approved`, `rejected`, `expired`, or `consumed`.
- Approved claims issue `device_id + secret` exactly once; later polls may only surface `issued_device_id`.
