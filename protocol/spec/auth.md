# ASCP Auth And Approval Semantics

This document freezes the `feature/auth-approvals` branch. It defines the auth hooks, recommended scope expectations, approval lifecycle behavior, and audit-attribution rules that sit on top of the frozen method, event, and replay contracts without reopening provider-specific auth models, transport handshakes, or mock-server behavior.

## Scope And Dependency

Auth and approval semantics depend on the frozen schema, method, event, and replay outputs:

- `schema/ascp-core.schema.json`
- `schema/ascp-methods.schema.json`
- `schema/ascp-events.schema.json`
- `spec/methods.md`
- `spec/events.md`
- `spec/replay.md`
- approval-, artifact-, and error-related examples under `examples/`

This branch does not redefine the method envelopes or event payloads. Instead it makes the auth surface and approval behavior explicit and testable on top of the already-frozen contracts.

## Auth Model Boundary

- ASCP remains vendor-neutral. It defines auth hooks, not one token format, provider, or refresh workflow.
- Auth decisions SHOULD be made from caller identity, device context, and granted scopes or permissions.
- Transport-specific credential exchange is outside this branch.
- Implementations MAY expose richer provider-specific detail through extensions, but they MUST NOT redefine the core meaning of `UNAUTHORIZED`, `FORBIDDEN`, approval statuses, or approval events.

## Recommended Scopes

The detailed spec defines these recommended scope names:

- `read:capabilities`
- `read:hosts`
- `read:runtimes`
- `read:sessions`
- `write:sessions`
- `read:approvals`
- `write:approvals`
- `read:artifacts`
- `admin:host`

`admin:host` is reserved for privileged host-wide operations or extensions. No core v0.1 method in this repository requires it directly.

## Method Scope Matrix

| Method | Access Type | Recommended Scope | Notes |
| --- | --- | --- | --- |
| `capabilities.get` | read | `read:capabilities` | capability discovery should be separately gateable from session access |
| `hosts.get` | read | `read:hosts` | host metadata is read-only but still part of the auth surface |
| `runtimes.list` | read | `read:runtimes` | runtime discovery remains distinct from session control |
| `sessions.list` | read | `read:sessions` | listing reveals active work and metadata |
| `sessions.get` | read | `read:sessions` | includes summary state and optional pending approvals or pending inputs |
| `sessions.subscribe` | read | `read:sessions` | live subscription exposes transcript and approval activity |
| `sessions.unsubscribe` | read | `read:sessions` | closes an existing read-side subscription |
| `sessions.start` | control | `write:sessions` | starts a new controllable session |
| `sessions.resume` | control | `write:sessions` | reattaches control to an existing interactive session |
| `sessions.stop` | control | `write:sessions` | changes session execution state |
| `sessions.send_input` | control | `write:sessions` | steers or injects new user input into a running session and answers pending input requests |
| `approvals.list` | read | `read:approvals` | exposes pending or historical approval requests |
| `approvals.respond` | control | `write:approvals` | resolves a pending approval and changes execution flow |
| `artifacts.list` | read | `read:artifacts` | artifact metadata may reveal generated outputs or code-adjacent material |
| `artifacts.get` | read | `read:artifacts` | access information may reveal sensitive output locations |
| `diffs.get` | read | `read:artifacts` | diff summaries may reveal code or patch intent |

## Sensitive Control Methods

The following methods SHOULD require explicit control scope:

- `sessions.start`
- `sessions.resume`
- `sessions.stop`
- `sessions.send_input`
- `approvals.respond`

These methods change runtime behavior or session state. They are not mere reads and should be auditable as control operations.

## Auth Failure Classification

### `UNAUTHORIZED`

Return `UNAUTHORIZED` when authentication is missing, expired, malformed, or otherwise invalid for the method call.

Rules:

- use it when the caller has not established a valid auth context
- do not use it for callers that are authenticated but under-scoped
- include `correlation_id` in the error object
- include `details.method` and any relevant object identifier when available

### `FORBIDDEN`

Return `FORBIDDEN` when authentication is valid but insufficient for the requested action.

Rules:

- use it when the caller is known but lacks the required scope or permission
- do not use it as a substitute for missing auth
- include `correlation_id` in the error object
- include `details.method`
- when scope-based authorization is used, include `details.required_scope`

The distinction is normative:

- `UNAUTHORIZED` answers "who are you?"
- `FORBIDDEN` answers "you are known, but you cannot do this"

## Audit Attribution

Implementations SHOULD associate sensitive control actions and approval outcomes with:

- `actor_id`
- `device_id`
- `correlation_id`

Rules:

- `actor_id` is part of the frozen core approval resolution event payloads and SHOULD identify the human or service principal that approved or rejected the request
- `device_id` SHOULD be captured from auth context or the audit sink even though it is not part of the frozen core approval event payloads in this branch
- `correlation_id` SHOULD be propagated into method errors and linked audit records so clients and operators can trace a control action across transports and logs
- if an implementation needs `device_id` or additional auth metadata in stream payloads, it SHOULD use an additive extension rather than changing the frozen core payloads

## Approval Lifecycle

### Request creation

- when execution requires human approval, the host emits `approval.requested` with the canonical `ApprovalRequest`
- the related session may enter `waiting_approval`
- pending approvals SHOULD remain visible through `approvals.list` and optional `sessions.get.include_pending_approvals`
- approval provenance is normative:
  - `metadata.source="runtime-native"` means the runtime exposed the request directly
  - `metadata.source="host-derived"` means the adapter derived the request from truthful runtime state
  - both provenance classes are actionable only when the adapter can route a response back into the runtime
  - if a host-derived approval is visible but not actionable, the host MUST advertise `approval_respond=false` and `approvals.respond` MUST return `UNSUPPORTED`

### Resolution via `approvals.respond`

`approvals.respond` is the control method for resolving a pending approval.

Rules:

- only pending approvals are eligible for successful resolution
- success is limited to `approved` or `rejected`
- the response result uses the terminal status only; it does not echo a full approval object
- hosts SHOULD emit `approval.updated` when the status changes and SHOULD then emit the terminal event that matches the result

### Terminal outcomes

Terminal approval outcomes are:

- `approved`
- `rejected`
- `expired`
- `cancelled`

Rules:

- `approval.approved` MUST carry `approval_id`, `resolved_at`, and `actor_id`
- `approval.rejected` MUST carry `approval_id`, `resolved_at`, `actor_id`, and the rejection `note`
- `approval.expired` records host- or policy-driven timeout without inventing an approval responder
- once an approval is terminal, later `approvals.respond` attempts SHOULD return `CONFLICT`

## Input Request Lifecycle

### Request creation

- when execution blocks on user input, the host emits `input.requested` with the canonical `InputRequest`
- the related session may enter `waiting_input`
- pending input requests SHOULD remain visible through optional `sessions.get.include_pending_inputs`
- `run_id` on `InputRequest` is populated only when the runtime exposes a stable run or turn identifier that the adapter can map honestly
- clients MUST treat absent `run_id` as a normal opaque omission and MUST NOT require it for rendering, routing, or response handling

### Resolution via `sessions.send_input`

- `sessions.send_input` is the control method for answering a pending `InputRequest`
- when a request identifier is supplied, hosts SHOULD validate that the request is still pending before attempting delivery
- if the target input request is no longer pending, the host SHOULD return `CONFLICT`
- successful delivery SHOULD lead to `input.completed` when the request is satisfied

### Terminal outcomes

- terminal input outcomes are `answered`, `expired`, and `cancelled`
- `input.expired` records a blocked question that can no longer be answered successfully
- if a pending input request becomes terminal before the answer arrives, later `sessions.send_input` attempts SHOULD return `CONFLICT`

### Approval history and auditability

- approval history SHOULD preserve the original request metadata, terminal outcome, and timestamps
- approval history SHOULD preserve actor attribution for approved and rejected outcomes
- audit records SHOULD preserve `device_id` and `correlation_id` even where the frozen core event payload does not carry them directly

## Artifact And Diff Access

Artifacts and diffs are read operations in the method surface, but they can expose code, patches, or other sensitive output.

Rules:

- `artifacts.list`, `artifacts.get`, and `diffs.get` SHOULD require `read:artifacts` or a stronger equivalent
- missing or invalid auth returns `UNAUTHORIZED`
- authenticated callers without sufficient access return `FORBIDDEN`
- hosts MAY choose stronger internal policy for particularly sensitive artifacts, but they SHOULD map the error back to the core `UNAUTHORIZED` or `FORBIDDEN` distinction

## Compatibility Notes

`ASCP Approval-Aware` depends on:

- approval events
- `approvals.list`
- `approvals.respond`
- auditable approval outcomes with actor attribution

This branch does not define a new compatibility level. It makes the approval-aware and artifact-aware auth behavior explicit enough for later conformance work.

## Conformance Material In This Branch

This branch adds:

- `examples/approvals/` approval lifecycle fixtures
- representative auth failure examples under `examples/errors/`
- auth scope and approval lifecycle fixtures under `conformance/fixtures/auth/`
- auth-specific validation in `conformance/tests/validate_auth_semantics.py`
- a shell entrypoint at `scripts/validate_auth_semantics.sh`

Those assets make the auth and approvals rules executable without broadening into provider-specific auth mechanics.
