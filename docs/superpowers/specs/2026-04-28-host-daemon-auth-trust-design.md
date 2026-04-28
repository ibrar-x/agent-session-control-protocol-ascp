# Host Daemon Auth Trust Design

**Date:** 2026-04-28
**Branch:** `branch-host-daemon`
**Status:** Draft for review

## Goal

Add real multi-client local auth and trust enforcement at the daemon layer so a paired mobile client can connect once to the host daemon and then access all daemon-managed runtimes and sessions according to daemon-enforced scopes.

## Why This Slice

The replay persistence slice made the daemon the durable system boundary for session state, events, and replay. The next correct layer is auth and trust:

- clients authenticate to the daemon, not to each adapter
- the daemon enforces read vs control scopes before forwarding to runtimes
- adapters remain runtime translation layers, not client auth layers
- audit attribution becomes truthful and consistent across all runtimes behind one host

## Non-Goals

This slice does **not**:

- redesign ASCP core methods, event names, or error codes
- add relay transport
- add network-facing remote auth beyond the v1 local-only constraint
- add runtime-specific pairing flows
- add runtime-specific trust stores
- add artifact write scopes or other non-existent v0.1 mutations

## Chosen Model

### Host-wide pairing

Pair once with the **host daemon**, not per runtime and not per session.

One successful pairing gives the device a daemon-scoped identity. After that, the daemon decides which runtimes, sessions, and methods the device may access.

This means:

- one phone pairing can cover `codex`, `gemini`, `claude`, and later runtimes
- adapters do not reimplement device pairing or scope enforcement
- future runtime/session allowlists can be added as daemon policy fields, not as a new pairing model

### Scope-based authorization

The daemon enforces v1 scopes:

- `read:hosts`
- `read:runtimes`
- `read:sessions`
- `write:sessions`
- `read:approvals`
- `write:approvals`
- `read:artifacts`

There is intentionally no `write:artifacts` in v1 because the frozen ASCP v0.1 surface does not define artifact mutation methods.

## Trust Record Model

Each paired device gets one trust record.

Suggested fields:

- `device_id`
- `display_name`
- `paired_at`
- `last_seen_at`
- granted scopes
- `revoked`
- `revoked_at`
- optional future runtime allowlist
- `secret_salt`
- `secret_verifier`
- `kdf`
- `kdf_params`

## Credential Material

### Device secret

The daemon issues a random device secret at pairing time.

- the phone stores the raw secret in secure device storage
- the daemon does **not** store the raw secret
- the daemon stores a verifier record tied to `device_id`

### Verifier form

The verifier must be explicitly KDF-derived.

Chosen v1 KDF:

- `scrypt`

Stored verifier material:

- `secret_salt`
- `secret_verifier`
- `kdf = "scrypt"`
- `kdf_params`

Rules:

- no plaintext secret at rest on the daemon
- no plain SHA hash
- no recoverable shared secret in the trust table

## Reconnect Authentication Mechanism

### Chosen v1 mechanism

Use **device_id + raw device secret** presented over an approved local-only transport.

The daemon verifies the presented secret against the stored `scrypt` verifier.

This is intentionally simpler than challenge-response because it stays consistent with storing only a one-way verifier.

### Why not challenge-response in v1

Challenge-response HMAC would require the daemon to retain secret-capable material for verification, which conflicts with the chosen one-way-verifier model.

That can be a future upgrade, but it is not the v1 choice.

## Transport Constraint

The v1 auth model depends on the transport boundary.

### Approved v1 transport

The daemon may only accept device-secret authentication on:

- loopback-only binding such as `127.0.0.1`
- or an equivalent local-only bridge/tunnel controlled by the host app layer

### Disallowed v1 transport

If the daemon is reachable over LAN/Wi-Fi or broader network transport:

- non-TLS device-secret auth is not allowed
- the daemon must not accept the v1 local-auth flow on that surface

### TLS upgrade rule

When the daemon later supports a network-reachable surface, TLS becomes mandatory before device-secret presentation is allowed on that surface.

## Capability Surface

The daemon must expose the active auth transport mode in `capabilities.get`.

Recommended additive field:

- `auth.transport = "loopback" | "tls"`

v1 expected values:

- `"loopback"` for the local-only device-secret flow
- `"tls"` reserved for future secure network transport

Why this field exists:

- clients can detect whether they are on a trusted local-only transport
- clients can refuse to present device secrets over an unsafe mode
- misconfigured daemons do not silently downgrade client security expectations
- v2 TLS upgrades become visible automatically through capability discovery

This field is additive daemon metadata, not a core ASCP semantic rewrite.

## Request Context

Every daemon-received method call resolves to one request context.

Fields:

- `actor_id`
- `device_id`
- granted scopes
- daemon-generated `correlation_id`
- auth transport mode

The request context is created before scope enforcement and used throughout audit logging and downstream forwarding.

## Correlation ID Rule

The daemon owns the authoritative `correlation_id`.

Rules:

- client may send an optional trace id as untrusted metadata
- daemon always generates its own opaque `correlation_id`
- daemon uses that `correlation_id` in:
  - audit records
  - daemon logs
  - error details
- if echoed to clients, the daemon-generated value remains the authoritative one

## Pairing Flow

### First-time pairing

1. mobile app requests pairing
2. daemon presents short-lived pairing challenge (QR or code)
3. user approves pairing on the host side
4. daemon creates:
   - `device_id`
   - random device secret
   - trust record with scopes and verifier material
5. phone stores:
   - `device_id`
   - raw device secret in secure device storage
6. daemon stores:
   - trust record
   - `scrypt` verifier
   - audit entry

### Reconnect

1. phone connects to daemon
2. phone sends `device_id` + device secret
3. daemon validates:
   - trust record exists
   - trust record not revoked
   - secret matches `scrypt` verifier
4. daemon builds request context and continues to authorization

## Authorization Rules

Enforce at the daemon boundary before adapter/runtime calls.

### Read-side methods

- `capabilities.get` → `read:hosts` or equivalent discovery scope policy
- `hosts.get` → `read:hosts`
- `runtimes.list` → `read:runtimes`
- `sessions.list` → `read:sessions`
- `sessions.get` → `read:sessions`
- `sessions.subscribe` → `read:sessions`
- `sessions.unsubscribe` → `read:sessions`
- `approvals.list` → `read:approvals`
- `artifacts.list` → `read:artifacts`
- `artifacts.get` → `read:artifacts`
- `diffs.get` → `read:artifacts`

### Control-side methods

- `sessions.start` → `write:sessions`
- `sessions.resume` → `write:sessions`
- `sessions.stop` → `write:sessions`
- `sessions.send_input` → `write:sessions`
- `approvals.respond` → `write:approvals`

### Failure classification

- `UNAUTHORIZED` when identity is missing, invalid, revoked, or secret verification fails
- `FORBIDDEN` when identity is valid but lacks the required scope

The daemon must preserve this distinction exactly as frozen in the auth semantics.

## Audit Logging

Audit logging is part of enforcement, not an optional side effect.

Every daemon-received method call must produce audit records whether it succeeds or fails.

### Enforcement order

1. receive request
2. generate daemon `correlation_id`
3. write audit start record
4. authenticate device
5. authorize scope
6. forward to adapter/runtime or reject
7. write audit completion record

### Minimum audit fields

- `correlation_id`
- method name
- `device_id` when available
- `actor_id` when available
- transport mode
- auth result
- authorization result
- forwarded or rejected
- result status or error code
- timestamp

## Adapter Relationship

Adapters remain responsible for:

- runtime discovery
- truthful session state reads
- truthful event production
- runtime-specific method forwarding

Adapters do **not** become responsible for:

- mobile pairing
- trust record storage
- scope enforcement
- client audit policy

The daemon is the only place where client auth/trust is enforced.

## Architecture

### `pairing_service`

Responsibilities:

- issue pairing challenges
- create trust records
- generate device secrets
- persist verifier material
- revoke devices

### `trust_store`

Responsibilities:

- persist device records
- persist `scrypt` verifier material
- list/revoke devices
- read scopes and trust status

### `authenticator`

Responsibilities:

- verify `device_id + secret`
- reject revoked or unknown devices
- construct authenticated daemon identity

### `authorizer`

Responsibilities:

- map ASCP method name to required scope
- return allow/deny
- classify `FORBIDDEN`

### `audit_logger`

Responsibilities:

- write start and completion records for every request
- capture daemon correlation id and auth outcome

### `request_context_factory`

Responsibilities:

- assign daemon `correlation_id`
- attach transport mode
- attach authenticated device identity

## Data and Storage

Suggested daemon auth tables:

- `daemon_trusted_devices`
- `daemon_pairing_challenges`
- `daemon_audit_log`

Suggested trusted-device columns:

- `device_id`
- `display_name`
- `secret_salt`
- `secret_verifier`
- `kdf`
- `kdf_params_json`
- `scopes_json`
- `revoked`
- `paired_at`
- `last_seen_at`

## Capability Truthfulness

The daemon must not overclaim auth guarantees.

Examples:

- local-only daemon using device secret over loopback → advertise `auth.transport = "loopback"`
- future TLS daemon → advertise `auth.transport = "tls"`
- if a surface cannot safely enforce the chosen auth mode, it must not accept device credentials on that surface

## Definition of Done

This slice is done when:

- mobile/device pairing is daemon-wide, not adapter-specific
- daemon stores `scrypt` verifier records rather than raw secrets
- reconnect authentication validates `device_id + secret` against daemon-owned trust records
- method calls enforce read vs control scopes at the daemon boundary
- `UNAUTHORIZED` vs `FORBIDDEN` behavior is truthful
- every request produces audit records with daemon-generated correlation ids
- `capabilities.get` exposes the active auth transport mode
- no adapter takes on client auth responsibilities
