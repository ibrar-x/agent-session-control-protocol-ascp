# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Host pairing UI slice
- Branch: `branch-host-pairing-ui`
- Goal: add a host-side pairing and trusted-device administration workspace inside `apps/host-console` on top of the completed daemon pairing backend, without changing frozen ASCP semantics or mixing daemon-wide onboarding state into the session chat workspace
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
  - `docs/superpowers/specs/2026-04-28-host-daemon-auth-trust-design.md`
  - `docs/superpowers/plans/2026-04-28-host-daemon-pairing-backend.md`
  - `services/host-daemon/README.md`
  - `apps/host-console/README.md`
  - `apps/host-console/src/App.tsx`
  - `apps/host-console/src/components/`

## Scope

Included in this branch:

- add a separate pairing/admin workspace inside `apps/host-console`
- add a host-side pairing session lifecycle view with inline create action
- add a focused pending-approval action queue for claimed devices
- add a trusted-device list plus revoke controls
- add daemon-admin polling and refresh behavior scoped to non-terminal pairing sessions
- update host-console docs and branch tracking for the host pairing UI slice

Explicitly out of scope:

- protocol redesign
- mobile pairing UI implementation
- daemon backend changes beyond small UI-enabling adjustments
- TLS network transport
- relay transport auth
- runtime-specific trust policy
- creating a new standalone host admin app

## Planned Files

Files expected to be added or modified in this slice:

- `docs/superpowers/specs/2026-04-28-host-pairing-ui-design.md`
- `docs/superpowers/plans/2026-04-28-host-pairing-ui.md`
- `internal/plans.md`
- `internal/status.md`
- `README.md`
- `apps/host-console/README.md`
- `apps/host-console/src/App.tsx`
- `apps/host-console/src/model.ts`
- `apps/host-console/src/model.test.ts`
- `apps/host-console/src/styles.css`
- `apps/host-console/src/components/`
- `apps/host-console/src/pairing/`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | add pairing workspace shell | host console exposes a clear workspace switch between session operations and pairing/admin without regressing the existing session workspace |
| completed | add pairing session lifecycle UI | hosts can create pairing sessions inline, see lifecycle state transitions, and view code, expiry, and claim details from one session list |
| completed | add approval queue and device management UI | pending claims are actionable in a focused queue and trusted devices can be reviewed and revoked |
| completed | update docs and verify the slice | host-console docs and branch tracker describe the pairing workspace contract, and focused frontend verification passes |

## Acceptance Criteria

This slice is done only when all of the following are true:

- the host console has a distinct pairing/admin workspace separate from the session chat workspace
- hosts can create a short-lived pairing session inline and immediately see it in the lifecycle list
- `pending_host_approval` sessions remain visible in the lifecycle list and also appear in a focused approval queue
- pairing-session polling only runs while non-terminal sessions exist and slows or stops when all visible sessions are terminal
- trusted devices can be listed and revoked through the host console without leaving the app
- no ASCP core method or event names are changed, and the daemon pairing backend remains the source of truth

## Next Likely Step

After this slice lands, build the mobile claim UI on top of the completed pairing backend and host pairing workspace, or extend the daemon toward TLS-backed transport without changing the host-wide trust model.
