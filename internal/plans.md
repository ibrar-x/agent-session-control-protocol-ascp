# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Host daemon pairing backend slice
- Branch: `branch-host-daemon`
- Goal: add a loopback-only pairing backend above the completed daemon auth engine so a host-side UI can create short-lived pairing sessions, explicitly approve or reject pending mobile claims, and issue trusted device credentials without changing frozen ASCP semantics
- Source inputs:
  - `AGENTS.md`
  - `internal/plans.md`
  - `internal/status.md`
  - `README.md`
  - `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `protocol/spec/methods.md`
  - `protocol/spec/events.md`
  - `protocol/spec/auth.md`
  - `protocol/spec/compatibility.md`
  - `docs/superpowers/specs/2026-04-27-host-daemon-replay-persistence-design.md`
  - `docs/superpowers/specs/2026-04-28-host-daemon-auth-trust-design.md`
  - `docs/superpowers/plans/2026-04-28-host-daemon-pairing-backend.md`
  - `packages/host-service/src/index.ts`
  - `services/host-daemon/src/main.ts`
  - `services/host-daemon/src/auth/`

## Scope

Included in this branch:

- add SQLite-backed pairing session persistence and expiry handling
- add a daemon-local admin HTTP surface for pairing session create/approve/reject and trusted-device list/revoke
- add a mobile-facing claim/poll backend contract for onboarding completion
- keep the existing ASCP WebSocket auth path unchanged after credential issuance
- update daemon docs and branch tracking for the pairing backend slice

Explicitly out of scope:

- protocol redesign
- QR rendering or host/mobile pairing UI
- TLS network transport
- relay transport auth
- runtime-specific trust policy
- moving pairing logic into adapters

## Planned Files

Files added or modified in this slice:

- `docs/superpowers/plans/2026-04-28-host-daemon-pairing-backend.md`
- `internal/plans.md`
- `internal/status.md`
- `README.md`
- `services/host-daemon/README.md`
- `services/host-daemon/src/config.ts`
- `services/host-daemon/src/index.ts`
- `services/host-daemon/src/main.ts`
- `services/host-daemon/src/sqlite.ts`
- `services/host-daemon/src/pairing/types.ts`
- `services/host-daemon/src/pairing/session-store.ts`
- `services/host-daemon/src/pairing/service.ts`
- `services/host-daemon/src/pairing/admin-server.ts`
- `services/host-daemon/tests/pairing/session-store.test.ts`
- `services/host-daemon/tests/pairing/service.test.ts`
- `services/host-daemon/tests/pairing/admin-server.test.ts`
- `services/host-daemon/tests/config.test.ts`
- `services/host-daemon/tests/main.test.ts`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | add pairing session store | pairing sessions persist with code, expiry, status, claim metadata, and issued-device linkage |
| completed | add pairing state machine | host approval is required before credentials issue, rejected and expired sessions are truthful, and trusted-device admin flows reuse the existing trust store |
| completed | add loopback admin server and daemon wiring | admin endpoints can create, claim, approve, reject, poll, list, and revoke over local HTTP without changing ASCP WebSocket semantics |
| completed | update docs and verify the slice | daemon docs and branch tracker describe the pairing backend contract, and focused verification passes |

## Acceptance Criteria

This slice is done only when all of the following are true:

- host-side code can create a short-lived pairing session and receive a code plus expiry
- a mobile claim cannot receive credentials until explicit host approval happens
- approved pairing returns `device_id + secret` once and persists only verifier data in the trust store
- expired and rejected pairing sessions are surfaced truthfully
- trusted devices can be listed and revoked through the daemon-local admin surface
- no ASCP core method or event names are changed, and the existing WebSocket auth flow remains the reconnect path after pairing

## Next Likely Step

After this slice lands, build host-console and mobile UI flows on top of the completed pairing backend, or extend the daemon toward TLS-backed transport without changing the host-wide trust model.
