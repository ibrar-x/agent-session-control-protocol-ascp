# ASCP Method Contracts

This document freezes the `feature/method-contracts` branch. It defines the exact request, success-response, and allowed error contracts for the ASCP core method surface without widening into full event payloads, replay sequencing, auth middleware implementation, or mock-server behavior.

## Scope And Dependency

These contracts depend on the schema-foundation outputs:

- `schema/ascp-core.schema.json`
- `schema/ascp-capabilities.schema.json`
- `schema/ascp-errors.schema.json`
- canonical examples under `examples/core/`, `examples/capabilities/`, `examples/errors/`, and `examples/events/`
- `docs/schema-foundation.md`

Method contracts must reuse those nouns and shared envelopes. They must not redefine `Host`, `Runtime`, `Session`, `Run`, `ApprovalRequest`, `Artifact`, `DiffSummary`, or the base error object loosely.

## Contract Rules

- All core methods use JSON-RPC 2.0 request and response envelopes.
- Success and error responses MUST echo the request `id`.
- Success and error responses are mutually exclusive.
- Request `params` and success `result` objects are closed and explicit in `schema/ascp-methods.schema.json`.
- Shared core nouns remain additive, but method params and success result wrappers are intentionally bounded.
- Unknown envelope-level fields remain safe to ignore so hosts can evolve additively without redefining core semantics.

## Shared Error Rules

The detailed spec gives per-method operational error guidance and a global error catalog. This branch makes that executable with two layers:

1. every method allows `INVALID_REQUEST` for malformed envelopes or invalid params
2. every method allows `UNAUTHORIZED` and `INTERNAL_ERROR` for host-level auth failure or unexpected host-side failure

Method-specific error lists below add the operational codes that the detailed spec names directly or implies through capability gating and state handling.

## Capability Gating

Methods without a dedicated capability flag are part of the base ASCP core surface and are expected from a core-compatible host.

| Method | Capability Gate |
| --- | --- |
| `capabilities.get` | core discovery surface |
| `hosts.get` | core discovery surface |
| `runtimes.list` | core discovery surface |
| `sessions.list` | `capabilities.session_list=true` |
| `sessions.get` | core session-read surface used by `ASCP Core Compatible` |
| `sessions.start` | `capabilities.session_start=true` |
| `sessions.resume` | `capabilities.session_resume=true` |
| `sessions.stop` | `capabilities.session_stop=true` |
| `sessions.send_input` | `capabilities.message_send=true` |
| `sessions.subscribe` | `capabilities.stream_events=true` |
| `sessions.unsubscribe` | `capabilities.stream_events=true` |
| `approvals.list` | `capabilities.approval_requests=true` |
| `approvals.respond` | `capabilities.approval_respond=true` |
| `artifacts.list` | `capabilities.artifacts=true` |
| `artifacts.get` | `capabilities.artifacts=true` |
| `diffs.get` | `capabilities.diffs=true` |

## Schema And Example Layout

- method schema: `schema/ascp-methods.schema.json`
- request examples: `examples/requests/`
- success response examples: `examples/responses/`
- error response examples: `examples/errors/`
- validation command: `scripts/validate_method_contracts.sh`

## Method Catalog

| Method | Request Schema | Success Schema | Allowed Error Codes | Example Files |
| --- | --- | --- | --- | --- |
| `capabilities.get` | `#/$defs/CapabilitiesGetRequest` | `#/$defs/CapabilitiesGetSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `INTERNAL_ERROR` | `examples/requests/capabilities-get.json`, `examples/responses/capabilities-get.json`, `examples/errors/capabilities-get.json` |
| `hosts.get` | `#/$defs/HostsGetRequest` | `#/$defs/HostsGetSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `INTERNAL_ERROR` | `examples/requests/hosts-get.json`, `examples/responses/hosts-get.json`, `examples/errors/hosts-get.json` |
| `runtimes.list` | `#/$defs/RuntimesListRequest` | `#/$defs/RuntimesListSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `ADAPTER_ERROR`, `INTERNAL_ERROR` | `examples/requests/runtimes-list.json`, `examples/responses/runtimes-list.json`, `examples/errors/runtimes-list.json` |
| `sessions.list` | `#/$defs/SessionsListRequest` | `#/$defs/SessionsListSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `ADAPTER_ERROR`, `INTERNAL_ERROR` | `examples/requests/sessions-list.json`, `examples/responses/sessions-list.json`, `examples/errors/sessions-list.json` |
| `sessions.get` | `#/$defs/SessionsGetRequest` | `#/$defs/SessionsGetSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `ADAPTER_ERROR`, `INTERNAL_ERROR` | `examples/requests/sessions-get.json`, `examples/responses/sessions-get.json`, `examples/errors/sessions-get.json` |
| `sessions.start` | `#/$defs/SessionsStartRequest` | `#/$defs/SessionsStartSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `UNSUPPORTED`, `ADAPTER_ERROR`, `RUNTIME_ERROR`, `INTERNAL_ERROR` | `examples/requests/sessions-start.json`, `examples/responses/sessions-start.json`, `examples/errors/sessions-start.json` |
| `sessions.resume` | `#/$defs/SessionsResumeRequest` | `#/$defs/SessionsResumeSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `UNSUPPORTED`, `ADAPTER_ERROR`, `RUNTIME_ERROR`, `INTERNAL_ERROR` | `examples/requests/sessions-resume.json`, `examples/responses/sessions-resume.json`, `examples/errors/sessions-resume.json` |
| `sessions.stop` | `#/$defs/SessionsStopRequest` | `#/$defs/SessionsStopSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `UNSUPPORTED`, `CONFLICT`, `RUNTIME_ERROR`, `INTERNAL_ERROR` | `examples/requests/sessions-stop.json`, `examples/responses/sessions-stop.json`, `examples/errors/sessions-stop.json` |
| `sessions.send_input` | `#/$defs/SessionsSendInputRequest` | `#/$defs/SessionsSendInputSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `UNSUPPORTED`, `RUNTIME_ERROR`, `INTERNAL_ERROR` | `examples/requests/sessions-send-input.json`, `examples/responses/sessions-send-input.json`, `examples/errors/sessions-send-input.json` |
| `sessions.subscribe` | `#/$defs/SessionsSubscribeRequest` | `#/$defs/SessionsSubscribeSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `UNSUPPORTED`, `TRANSIENT_UNAVAILABLE`, `INTERNAL_ERROR` | `examples/requests/sessions-subscribe.json`, `examples/responses/sessions-subscribe.json`, `examples/errors/sessions-subscribe.json` |
| `sessions.unsubscribe` | `#/$defs/SessionsUnsubscribeRequest` | `#/$defs/SessionsUnsubscribeSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `UNSUPPORTED`, `INTERNAL_ERROR` | `examples/requests/sessions-unsubscribe.json`, `examples/responses/sessions-unsubscribe.json`, `examples/errors/sessions-unsubscribe.json` |
| `approvals.list` | `#/$defs/ApprovalsListRequest` | `#/$defs/ApprovalsListSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `UNSUPPORTED`, `ADAPTER_ERROR`, `INTERNAL_ERROR` | `examples/requests/approvals-list.json`, `examples/responses/approvals-list.json`, `examples/errors/approvals-list.json` |
| `approvals.respond` | `#/$defs/ApprovalsRespondRequest` | `#/$defs/ApprovalsRespondSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `CONFLICT`, `RUNTIME_ERROR`, `INTERNAL_ERROR` | `examples/requests/approvals-respond.json`, `examples/responses/approvals-respond.json`, `examples/errors/approvals-respond.json` |
| `artifacts.list` | `#/$defs/ArtifactsListRequest` | `#/$defs/ArtifactsListSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `UNSUPPORTED`, `ADAPTER_ERROR`, `INTERNAL_ERROR` | `examples/requests/artifacts-list.json`, `examples/responses/artifacts-list.json`, `examples/errors/artifacts-list.json` |
| `artifacts.get` | `#/$defs/ArtifactsGetRequest` | `#/$defs/ArtifactsGetSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `UNSUPPORTED`, `ADAPTER_ERROR`, `INTERNAL_ERROR` | `examples/requests/artifacts-get.json`, `examples/responses/artifacts-get.json`, `examples/errors/artifacts-get.json` |
| `diffs.get` | `#/$defs/DiffsGetRequest` | `#/$defs/DiffsGetSuccessResponse` | `INVALID_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`, `NOT_FOUND`, `UNSUPPORTED`, `ADAPTER_ERROR`, `INTERNAL_ERROR` | `examples/requests/diffs-get.json`, `examples/responses/diffs-get.json`, `examples/errors/diffs-get.json` |

## Method Notes

### Discovery methods

- `capabilities.get` returns the capability document directly as the `result` object rather than nesting it under another field.
- `hosts.get` and `runtimes.list` stay transport-neutral and read-only. They do not imply session attachment.

### Session methods

- `sessions.get` may omit `runs` and `pending_approvals` unless the corresponding include flags are set. When present, both fields are arrays of canonical nouns.
- `sessions.resume` carries the replay-related booleans that a client needs before event-stream work begins, but this branch does not define replay sequencing.
- `sessions.stop` returns a normalized acknowledgement object instead of echoing a full `Session`.
- `sessions.subscribe` is the only method whose contract includes a side effect requirement: after a successful response, `EventEnvelope` objects must begin streaming on the active transport.

### Approval and artifact methods

- `approvals.respond` narrows the success status to `approved` or `rejected`, even though the canonical approval object supports broader lifecycle states.
- `artifacts.list`, `artifacts.get`, and `diffs.get` expose metadata and summaries only. Fetching artifact content or full patch bodies stays outside this branch.

## Follow-Up

The next branch should build `feature/event-contracts` on top of these frozen method triggers and the shared `EventEnvelope`, without redefining the method surface or backfilling new core nouns.
