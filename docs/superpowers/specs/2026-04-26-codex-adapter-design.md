# Codex Adapter Design

## Summary

This spec defines the downstream ASCP `Codex adapter` feature for the ASCP monorepo. The adapter consumes the frozen ASCP v0.1 contracts and maps the official Codex app-server runtime surface into truthful ASCP discovery, session, streaming, approval, and diff behavior without inventing new protocol semantics.

This is runtime-integration work only. The adapter must stay downstream of:

- `protocol/schema/`
- `protocol/spec/`
- `protocol/examples/`
- `protocol/conformance/`

If Codex behavior cannot satisfy an ASCP capability honestly, the adapter must advertise that capability as `false` rather than synthesizing support.

## Goal

Build a usable TypeScript adapter under `adapters/codex/` that proves ASCP can sit on top of a real rich runtime and that the existing TypeScript SDK can support a real downstream integration rather than only the mock server.

## Scope

In scope:

- a TypeScript adapter package under `adapters/codex/`
- official Codex app-server stdio JSON-RPC transport integration
- truthful runtime discovery and capability advertisement
- ASCP-shaped `sessions.list`, `sessions.get`, `sessions.resume`, and `sessions.send_input`
- ASCP event normalization over Codex thread, turn, message, diff, and approval notifications
- approval mapping where the app-server exposes approval requests and responses
- best-effort diff support when Codex emits official turn diff updates
- small generic TypeScript SDK extractions only when they are clearly reusable across adapters
- adapter-specific tests, docs, and validation entrypoints

Out of scope:

- protocol redesign
- new ASCP methods, events, schemas, or compatibility levels
- speculative artifact support without an official Codex surface
- replay claims without an official Codex replay surface
- product UX, daemon work, or app surfaces
- broad SDK refactors driven only by this adapter

## Source Inputs

Primary repository inputs:

- `AGENTS.md`
- `plans.md`
- `docs/status.md`
- `README.md`
- `docs/README.md`
- `docs/project-context-reference.md`
- `docs/prompts/codex-adapter.md`
- `docs/superpowers/plans/2026-04-26-codex-adapter.md`
- `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
- `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
- `protocol/schema/`
- `protocol/spec/`
- `protocol/examples/`
- `protocol/conformance/`
- `apps/reference-client/README.md`
- `services/mock-server/README.md`

Observed runtime inputs:

- `codex --version`
- `codex app-server --help`
- app-server generated JSON schemas via `codex app-server generate-json-schema`
- live app-server `initialize`, `thread/list`, `thread/read`, and `thread/resume` probes

Known repository discrepancy:

- the starter prompt references `ASCP_Codex_Adapter_Implementation_Plan.md` at repository root
- that file is not present
- the active replacement is `docs/superpowers/plans/2026-04-26-codex-adapter.md`

## Recommended Architecture

Use option 1: thin SDK extension, thick adapter.

### Adapter boundary

`adapters/codex/` owns:

- app-server stdio process lifecycle
- JSON-RPC request and notification handling against Codex
- runtime discovery from observed Codex surfaces
- capability resolution from observed Codex features
- Codex thread and turn ID normalization into ASCP runtime, session, run, and approval IDs
- mapping Codex thread and turn state into ASCP `Session` and `Run`
- mapping Codex notifications into ASCP `EventEnvelope`
- mapping Codex approval requests into ASCP `ApprovalRequest`
- diff mapping from official turn diff notifications when present

### SDK boundary

`sdks/typescript/` may receive small generic additions only if they are clearly reusable and Codex-agnostic, such as:

- helper types for ASCP success and error envelopes
- generic validation helpers for ASCP-shaped entities or envelopes
- reusable entity or event construction helpers that do not encode Codex runtime assumptions

The SDK must not absorb:

- Codex app-server method names
- Codex thread, turn, or approval semantics
- Codex-specific transport behavior
- Codex-specific capability inference rules

## Runtime Target

The adapter should target the official Codex app-server stdio JSON-RPC surface rather than private sqlite, JSONL, or filesystem internals.

Observed official surface includes:

- requests: `initialize`, `thread/list`, `thread/read`, `thread/start`, `thread/resume`, `turn/start`, `turn/steer`
- notifications: `thread/started`, `thread/status/changed`, `turn/started`, `turn/completed`, `turn/diff/updated`
- delta notifications: `agent message delta` and plan-like incremental notifications
- server approval requests: command execution approval, file change approval, and permission approval requests

Private local state may be used only as discovery fallback when it does not become the truth source for ASCP behavior.

## Capability Truthfulness

The adapter must advertise capabilities from observed Codex app-server behavior, not from repository examples or optimistic assumptions.

Initial truth model:

- `session_list=true` if `thread/list` works
- `session_resume=true` if `thread/resume` works
- `session_start=true` if `thread/start` is available and stable enough to use
- `message_send=true` if `turn/start` or `turn/steer` can inject user input into a thread
- `stream_events=true` if notifications can be subscribed to and normalized into ASCP stream events
- `approval_requests=true` if Codex emits official approval requests
- `approval_respond=true` only if the app-server exposes a supported way to resolve those approval requests through the same official surface
- `diffs=true` only if turn-level diff data can be mapped honestly into ASCP `DiffSummary`
- `artifacts=false` unless an official Codex surface exposes artifact metadata cleanly enough for ASCP mapping
- `replay=false` unless an official Codex surface exposes safe historical replay semantics that match the ASCP replay contract

Ambiguous or unofficial surfaces must resolve to `false`.

## ID Strategy

Use stable adapter-owned ASCP IDs derived from Codex identifiers:

- `runtime_id = codex_local`
- `session_id = codex:<thread_id>`
- `run_id = codex:<thread_id>:<turn_id>`
- `approval_id = codex:<approval_id>` when Codex supplies one
- if an approval callback has no explicit approval ID, derive a deterministic adapter-owned ID from thread, turn, item, and approval kind

These IDs must stay deterministic and transport-neutral from the ASCP consumer perspective.

## Mapping Strategy

### Runtime mapping

Map the local Codex runtime into ASCP `Runtime` with:

- exact ASCP field names
- version from `codex --version` or app-server user agent when safely available
- `kind = codex`
- capabilities derived from the truth model above

### Session mapping

Map a Codex thread into ASCP `Session`:

- `id` from thread ID strategy
- `runtime_id = codex_local`
- `title` from thread name when present
- `workspace` from thread cwd
- `created_at` and `updated_at` from thread timestamps
- `summary` from preview when helpful and honest
- `status` from normalized thread status
- `metadata.source = codex`

Thread status normalization should be conservative:

- idle -> `idle`
- active -> `running` unless Codex is explicitly blocked on approval
- explicit approval wait -> `waiting_approval`
- unrecoverable system error -> `failed`
- archived or closed states should only map to terminal ASCP states when the runtime meaning is clear

### Run mapping

Map a Codex turn into ASCP `Run`:

- turn start and completion timestamps map into `started_at` and `ended_at`
- turn status maps into ASCP run status conservatively
- turn error data maps into ASCP failure detail where available

### Event mapping

Codex notifications and deltas should normalize into exact ASCP event types wherever the semantics align:

- thread creation or activation -> session lifecycle events
- thread status transitions -> `session.status_changed`
- turn start -> `run.started`
- turn completion -> `run.completed` or `run.failed`
- assistant text deltas -> `message.assistant.delta`
- finalized assistant output -> `message.assistant.completed`
- approval requests -> `approval.requested`
- diff notifications -> `diff.updated` or `diff.ready` only if the semantics actually match

If a Codex notification carries useful detail that ASCP does not model directly, preserve it inside namespaced extension-safe metadata rather than changing core ASCP meanings.

### Approval mapping

Codex approval request payloads should map into ASCP `ApprovalRequest` with:

- kind derived from official approval request type
- status initially `pending`
- title and description from the official approval request data
- payload preserved in a stable explicit object
- audit-related detail carried where available

The adapter must not claim `approvals.respond` until the official response path is identified and exercised. If resolution cannot be performed safely from the app-server surface, `approval_respond=false`.

### Diff and artifact mapping

Turn diff notifications appear to justify best-effort `DiffSummary` support.

Artifact support is not yet justified. The adapter should:

- support `diffs.get` only if it can store or reconstruct current official diff data honestly
- leave `artifacts.list` and `artifacts.get` unsupported unless official Codex artifact metadata is observed

## Error Handling

The adapter must map runtime failures back into the frozen ASCP error catalog rather than leaking Codex-specific error shapes as core ASCP behavior.

Guidance:

- malformed adapter input -> `INVALID_REQUEST`
- missing session or turn -> `NOT_FOUND`
- capability not supported by observed Codex surface -> `UNSUPPORTED`
- runtime call fails due to Codex-side problem -> `RUNTIME_ERROR` or `ADAPTER_ERROR` depending on fault boundary
- temporary transport or app-server startup issues -> `TRANSIENT_UNAVAILABLE`

Codex-specific error detail may be carried in namespaced extension-safe metadata or error details when additive.

## Testing Strategy

The first implementation should prove both mapping correctness and truthful degradation.

Required test layers:

- unit tests for runtime discovery and capability resolution
- unit tests for ID generation
- unit tests for session and run normalization
- unit tests for event normalization from representative Codex notifications
- unit tests for approval request mapping and honest fallback
- unit tests for diff fallback and unsupported artifact behavior
- integration smoke tests against a live local `codex app-server` process for `initialize`, `thread/list`, `thread/read`, and `thread/resume`

Validation goals:

- adapter outputs use exact ASCP field names
- unsupported capability flags stay `false`
- mapped events and method results remain downstream of the frozen ASCP contracts
- the adapter uses the official Codex surface instead of private persistence formats as the primary runtime interface

## File Structure

Expected primary adapter files:

- `adapters/codex/package.json`
- `adapters/codex/tsconfig.json`
- `adapters/codex/README.md`
- `adapters/codex/src/index.ts`
- `adapters/codex/src/app-server-client.ts`
- `adapters/codex/src/discovery.ts`
- `adapters/codex/src/capabilities.ts`
- `adapters/codex/src/ids.ts`
- `adapters/codex/src/session-mapper.ts`
- `adapters/codex/src/events.ts`
- `adapters/codex/src/approvals.ts`
- `adapters/codex/src/service.ts`
- `adapters/codex/tests/*.test.ts`
- `tooling/scripts/validate_codex_adapter.sh`

Possible TypeScript SDK touch points:

- generic ASCP helper modules under `sdks/typescript/src/`
- tests proving generic helper behavior remains Codex-agnostic

## Acceptance Criteria

The adapter slice is ready for implementation when the plan targets all of the following:

- truthful runtime discovery and capability advertisement
- ASCP-shaped session list, get, and resume behavior over official Codex thread APIs
- ASCP-shaped input sending over official Codex turn APIs
- normalized ASCP event streaming over official Codex notifications
- approval mapping where the official surface supports it
- honest fallback for replay, artifacts, and any unresolved approval response path
- TypeScript SDK reuse limited to small generic additions
- adapter docs and validator commands written in-repo

## Risks And Constraints

- Codex app-server schemas include unstable and experimental areas; those should not automatically become ASCP compatibility claims
- `thread/resume` may emit notifications before or around the main response, so the adapter must handle interleaved RPC traffic safely
- approval request input is visible, but approval response wiring still needs confirmation before `approval_respond=true`
- replay semantics are not yet evidenced by the observed official surface and should remain unsupported

## Next Step

Write the implementation plan and execute only the adapter slice on `feature/codex-adapter`.
