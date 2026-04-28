# Host Pairing UI Design

## Goal

Add a host-side pairing and trusted-device administration workspace inside `apps/host-console` so an operator can create pairing sessions, approve or reject mobile claims, and manage trusted devices using the completed loopback daemon pairing backend.

This is a host-console UI slice only. It must stay downstream of the existing daemon pairing backend, auth/trust model, and frozen ASCP contracts.

## Scope

Included:

- add a distinct pairing/admin workspace to the host console
- add a lifecycle view for pairing sessions with inline create controls
- add a focused approval queue for claimed devices waiting on host action
- add trusted-device listing and revoke controls
- add polling and refresh behavior scoped to non-terminal pairing sessions
- document the pairing workspace behavior and operator expectations

Excluded:

- mobile claim UI
- protocol changes
- new ASCP methods or events
- daemon transport/auth redesign
- TLS/network transport changes
- a separate host admin application

## User Experience Direction

The host console already has a clear session-first workspace. Pairing is daemon-wide administration, not selected-session context, so it should live in a separate workspace inside the same app shell.

The host should be able to:

- switch between `Sessions` and `Pairing`
- create a pairing session without leaving the lifecycle list
- watch a session progress from created to claimed to approved, rejected, expired, or consumed
- approve or reject claimed devices from a focused queue
- inspect and revoke trusted devices from the same workspace

The UI should keep the current dark technical tone, but the pairing workspace should read as operational admin tooling rather than chat context.

## Workspace Structure

Add a top-level workspace switch in `apps/host-console`:

- `Sessions` — existing chat-first operator workspace
- `Pairing` — daemon-admin workspace for device onboarding and trusted-device management

The `Sessions` workspace should keep current behavior and layout intact. The `Pairing` workspace should not depend on a selected ASCP session.

## Pairing Workspace Layout

The pairing workspace should use three panels.

### 1. Pairing Sessions

This is the primary lifecycle panel.

Responsibilities:

- create a new pairing session inline
- list pairing sessions with lifecycle status
- show code, expiry, requested scopes, device label when claimed, and issued-device linkage when present
- show the raw pairing code as copyable text in v1; store `qr_payload` from the backend but do not render a QR image yet
- keep all sessions visible through their lifecycle

Create flow:

- inline form at the top of the panel
- requested scopes selector
- TTL input
- create action

Why inline:

- v1 create state is lightweight
- the result belongs immediately in the lifecycle list
- keeping creation inside the same panel avoids a split mental model

### 2. Claim Approval

This is a focused action queue derived from the pairing-session dataset.

Responsibilities:

- show only sessions in `pending_host_approval`
- surface claimed device label, claim timing, requested scopes, and expiry
- provide approve and reject actions

Important rule:

- sessions in `pending_host_approval` remain visible in the lifecycle list and also appear here
- this panel is an action-focused projection, not a separate source of truth

### 3. Trusted Devices

This is a daemon-admin inventory panel.

Responsibilities:

- list trusted devices
- show device identity, display label, scopes, pair time, and revocation state
- allow revoke action

Revocation should update the device inventory only. It should not rewrite pairing-session history.

## Data Model

The pairing workspace should maintain two datasets:

- `pairingSessions`
- `trustedDevices`

The approval queue is derived from `pairingSessions` by filtering `pending_host_approval`.

This keeps the UI state bounded:

- one session lifecycle store
- one device inventory store
- one derived actionable subset

The existing session chat model should remain separate from pairing state.

## Data Flow

On entering the pairing workspace:

1. fetch pairing sessions
2. fetch trusted devices
3. render the lifecycle list and device inventory
4. derive the approval queue from current sessions

On re-entering the pairing workspace after switching away:

1. re-fetch pairing sessions
2. re-fetch trusted devices
3. replace cached pairing-workspace state with the fresh daemon-admin response

On create:

1. submit create request
2. append or merge the returned session into `pairingSessions`
3. restart active polling if the new session is non-terminal

On approval or rejection:

1. submit action for the selected pairing session
2. merge returned session state into `pairingSessions`
3. refresh derived approval queue automatically
4. if the returned state is `approved`, keep active polling running and re-fetch `trustedDevices` on the next polling tick so issued devices appear without leaving the workspace
5. continue polling only if another active-polled session remains

On device revoke:

1. submit revoke request
2. refresh or merge the trusted-device inventory
3. leave pairing-session lifecycle history unchanged

## Polling Rules

Polling must be scoped to non-terminal session state.

Active polling runs every 3 seconds while at least one visible pairing session is:

- `pending_host_claim`
- `pending_host_approval`
- `approved`

When all visible sessions are terminal:

- `consumed`
- `rejected`
- `expired`

The workspace should stop polling or fall back to a 30-second refresh cadence.

Additional rules:

- creating a new pairing session restarts active polling immediately
- approve or reject actions trigger an immediate refresh
- after that refresh, polling continues only if another non-terminal session remains

This keeps the UI efficient and makes the future transport upgrade path cleaner.

## Error Handling

The pairing workspace should treat daemon-admin failures as panel-scoped operational errors.

Required behavior:

- creation failure should keep the inline form visible and show a local error message
- session-list fetch failure should not blank the entire app shell
- approve or reject failure should keep the affected item visible with retryable error feedback
- trusted-device fetch or revoke failure should stay scoped to the device panel

The UI should prefer truthful stale-state handling over silently assuming success.

## Testing Direction

This slice should add focused frontend tests for:

- workspace switching without regressing session UI state
- pairing-session list state transitions
- approval queue derivation from shared pairing-session data
- polling enable or disable behavior based on non-terminal session presence
- trusted-device revoke state updates

Manual verification should confirm:

- create appears in the lifecycle list immediately
- `pending_host_approval` appears in both the lifecycle panel and approval queue
- approve or reject updates both views consistently
- polling stops when all visible sessions are terminal

## Acceptance Criteria

This design is satisfied when:

- `apps/host-console` exposes a distinct pairing workspace
- pairing creation is inline within the lifecycle panel
- lifecycle history remains visible across all pairing states
- pending approvals are actionable from a dedicated queue without disappearing from the lifecycle view
- trusted devices can be reviewed and revoked from the same workspace
- daemon-admin polling is scoped to non-terminal sessions only
