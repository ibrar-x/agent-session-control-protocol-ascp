# Auth And Approvals Design

## Summary

This design defines the `feature/auth-approvals` branch for ASCP. The branch adds a normative auth and approvals document, approval-lifecycle examples, auth-failure examples, and a minimal conformance slice that makes scope expectations, approval attribution, and `UNAUTHORIZED` versus `FORBIDDEN` behavior explicit and testable without widening into vendor auth systems or transport handshakes.

## Motivation

The schema-foundation, method-contract, event-contract, and replay branches froze the nouns, method surface, event payloads, and reconnect behavior. The next protocol slice is to define how implementations authenticate callers, authorize read versus control actions, and record auditable approval outcomes without forcing later implementers to invent security semantics.

## Scope

Included in this branch:

- normative auth and approvals semantics in `spec/auth.md`
- a method-by-method scope matrix for read and control operations
- explicit `UNAUTHORIZED` versus `FORBIDDEN` rules
- actor, device, and correlation attribution guidance
- approval lifecycle examples covering approve, reject, expire, and conflict outcomes
- minimal auth-focused conformance validation

Explicitly out of scope:

- vendor auth providers, tokens, refresh flows, or revocation protocols
- transport-specific authentication exchanges
- product approval UI flows
- runtime implementation internals beyond documented fixture behavior
- reopening the frozen request, response, or event schemas

## Protocol Impact

The branch must preserve these rules from the source specs:

- ASCP is vendor-neutral and defines hooks rather than one auth provider
- `sessions.start`, `sessions.resume`, `sessions.stop`, `sessions.send_input`, and `approvals.respond` are sensitive control methods
- `UNAUTHORIZED` means auth is missing, expired, or invalid
- `FORBIDDEN` means auth is valid but insufficient for the requested action
- approval outcomes must be attributable to `actor_id`
- `device_id` and `correlation_id` are first-class audit hooks even where they are not frozen core event payload fields
- artifact and diff access may require explicit read scope when session output can expose code or sensitive data

## Architecture

The normative protocol write-up will live in `spec/auth.md` to match the detailed spec's suggested repository shape. That document will separate normative rules from implementation guidance, define scope expectations for the full method surface, explain approval lifecycle transitions, and describe how attribution hooks bind to methods, errors, and events.

Illustrative approval lifecycle material will live under `examples/approvals/` as small fixture documents that combine canonical approval objects, method requests and responses, related events, and audit expectations. This keeps approval behavior readable without overloading `examples/events/`, which already serves as the single-event catalog.

Repeatable validation will use a small shell entrypoint backed by `python3` and `jsonschema`, reusing the frozen schema files. The auth validator will check that approval lifecycle fixtures remain schema-valid where they embed protocol messages, that approval resolution events carry `actor_id`, and that auth-failure examples classify `UNAUTHORIZED` and `FORBIDDEN` consistently with the method surface and scope matrix.

## File Layout

Files to create:

- `spec/auth.md`
- `examples/approvals/approval-request-command.json`
- `examples/approvals/approval-flow-approved.json`
- `examples/approvals/approval-flow-rejected.json`
- `examples/approvals/approval-flow-expired.json`
- `examples/errors/sessions-start-unauthorized.json`
- `examples/errors/sessions-start-forbidden.json`
- `examples/errors/sessions-list-unauthorized.json`
- `examples/errors/approvals-respond-unauthorized.json`
- `examples/errors/approvals-respond-forbidden.json`
- `examples/errors/artifacts-get-unauthorized.json`
- `conformance/fixtures/auth/auth-scope-matrix.json`
- `conformance/fixtures/auth/approval-lifecycle.json`
- `conformance/tests/validate_auth_semantics.py`
- `scripts/validate_auth_semantics.sh`
- `docs/superpowers/specs/2026-04-22-auth-approvals-design.md`
- `docs/superpowers/plans/2026-04-22-auth-approvals.md`

Files to modify:

- `plans.md`
- `docs/status.md`

## Design Decisions

### Scope matrix as protocol documentation

The branch will document recommended scopes in `spec/auth.md` and mirror them in a fixture file for validation. That keeps scope behavior explicit without introducing a new core schema that would freeze one authorization model too early.

### Actor versus device attribution

The frozen event contracts already require `actor_id` on `approval.approved` and `approval.rejected`. This branch will treat `device_id` and `correlation_id` as required audit hooks carried by auth context, error objects, or audit sinks rather than forcing them into frozen event payloads.

### Approval lifecycle as fixture bundles

Approval behavior is inherently cross-object: a pending `ApprovalRequest`, a response method call, a success or conflict response, and one or more approval events. Bundle fixtures will make those relationships explicit and easier to validate than isolated JSON fragments.

### Artifact and diff access guidance

Artifacts and diffs may expose code or other sensitive output. The branch will document them as read-scope operations and include failure examples to show how insufficient access differs from missing auth.

## Validation Strategy

Validation should prove the auth semantics rather than just file presence:

- `spec/auth.md` must contain the expected auth, scope, lifecycle, and error-classification sections
- approval request examples must validate against the frozen `ApprovalRequest` schema
- approval lifecycle fixtures must validate embedded method envelopes, responses, and events against the frozen method and event contracts
- auth failure examples must validate against method-specific error response schemas
- auth fixtures must reject `FORBIDDEN` where the example claims auth is missing and reject `UNAUTHORIZED` where the example claims auth is valid but insufficient

## Risks And Controls

Risk: auth docs drift into provider-specific implementation guidance.
Control: keep the document focused on protocol hooks, recommended scopes, and auditable outcomes.

Risk: device identity gets forced into frozen core payloads.
Control: keep `device_id` in fixture metadata and audit guidance rather than reopening `schema/ascp-events.schema.json`.

Risk: approval lifecycle examples contradict the frozen event catalog.
Control: validate every embedded request, response, and event against the existing method and event schemas.

## Follow-Up

After this branch lands, the next protocol slice should be extensions or the broader conformance branch. Both will be able to build on the auth and approval rules from this branch without reopening the security surface.

