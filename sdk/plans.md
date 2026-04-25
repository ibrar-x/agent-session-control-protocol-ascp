# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Dart SDK transport, client, and replay
- Branch: `feature/dart-sdk-client`
- Goal: implement the Dart executable SDK surface on top of the existing package foundation, including typed method wrappers, replaceable transports, stream-based subscriptions, replay helpers, validation hooks, auth hooks, focused tests, and usage documentation without widening into Flutter UI or protocol-core changes
- Active language target: Dart SDK executable surface
- Source inputs:
  - `AGENTS.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../ASCP_Protocol_PRD_and_Build_Guide.md`
  - `../schema/`
  - `../spec/`
  - `../examples/`
  - `../mock-server/README.md`
  - `../mock-server/sample-event-streams/sess_abc123.json`
  - `../conformance/fixtures/replay/`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/branches/dart-sdk-foundation.md`
  - `docs/branches/dart-sdk-planning.md`
  - `docs/branches/typescript-sdk-client.md`
  - `docs/branches/typescript-sdk-replay.md`
  - `docs/branches/typescript-sdk-transport.md`
  - `typescript/README.md`
  - `typescript/src/client/`
  - `typescript/src/replay/`
  - `typescript/src/transport/`
  - `typescript/test/client.test.ts`
  - `typescript/test/replay.test.ts`
  - `typescript/test/transport.test.ts`
  - `dart/README.md`
  - `../../ASCP_Dart_SDK_Implementation_Plan.md`
  - `../../ASCP_Next_Phase_Master_Roadmap.md`

## Scope

Included in this branch:

- replace the marker-only `client`, `transport`, `validation`, and `replay` libraries with executable Dart surfaces while preserving the package layout established by `feature/dart-sdk-foundation`
- add typed method params and result models for the ASCP core method surface, keeping method names and payload fields aligned with upstream ASCP contracts
- implement replaceable stdio and WebSocket transports for JSON-RPC requests plus stream-based event delivery
- implement a thin typed client that wraps every core ASCP method and maps ASCP error responses into a protocol-specific exception
- add replay helpers for `from_seq`, `from_event_id`, opaque cursor pass-through, and snapshot-versus-live event classification
- add validation hooks and transport-auth hooks without inventing provider-specific auth semantics or silently rewriting method payloads
- add focused unit and integration-style tests plus runnable examples against the deterministic upstream mock server
- document how to use the current Dart SDK surface, why the API shape and transport choices were preferred over alternatives, what was verified, what remains limited, and what the repository should do after Dart reaches parity

Explicitly out of scope:

- protocol-core schema, spec, or compatibility changes
- HTTP, SSE, relay, or daemon-specific transport work beyond the current justified stdio and WebSocket surface
- Flutter UI work, app-level state management, or local caching policy
- vendor-specific auth protocols, token refresh flows, or product telemetry
- changing ASCP field names into Dart-specific aliases
- reopening the Dart foundation package layout except where additive executable behavior requires it
- broadening the TypeScript package surface beyond using it as a downstream reference

## Planned Files

Files to add:

- `dart/lib/src/auth/auth.dart`
- `dart/lib/src/transport/base_transport.dart`
- `dart/lib/src/transport/stdio_transport.dart`
- `dart/lib/src/transport/transport_errors.dart`
- `dart/lib/src/transport/websocket_transport.dart`
- `dart/lib/src/client/protocol_error.dart`
- `dart/lib/src/replay/replay_models.dart`
- `dart/lib/src/replay/replay_subscription.dart`
- `dart/test/client_test.dart`
- `dart/test/replay_test.dart`
- `dart/test/transport_test.dart`
- `dart/test/validation_test.dart`
- `dart/example/mock_server_client.dart`
- `docs/branches/dart-sdk-client.md`

Files expected to change:

- `plans.md`
- `docs/README.md`
- `docs/project-context-reference.md`
- `docs/sdk-build-roadmap.md`
- `docs/status.md`
- `README.md`
- `dart/README.md`
- `dart/pubspec.yaml`
- `dart/lib/ascp_sdk_dart.dart`
- `dart/lib/client.dart`
- `dart/lib/replay.dart`
- `dart/lib/transport.dart`
- `dart/lib/validation.dart`
- `dart/lib/methods.dart`
- `dart/lib/events.dart`
- `dart/lib/errors.dart`
- `dart/lib/src/client/client.dart`
- `dart/lib/src/events/events.dart`
- `dart/lib/src/events/sync_events.dart`
- `dart/lib/src/errors/errors.dart`
- `dart/lib/src/errors/protocol_error.dart`
- `dart/lib/src/methods/methods.dart`
- `dart/lib/src/methods/session_subscription.dart`
- `dart/lib/src/models/envelopes.dart`
- `dart/test/foundation_package_surface_test.dart`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | replace the completed foundation plan with the executable Dart branch plan | `plans.md` scopes the branch to transport, client, replay, validation, and auth-hook work only and cites the exact upstream inputs that drive it |
| done | add failing tests for typed client wrappers, replay helpers, transport behavior, validation hooks, and examples | at least one new test file fails for missing executable Dart behavior before production code is added |
| done | implement the replaceable transport layer and auth hooks | the package exposes transport contracts plus justified stdio and WebSocket implementations, with transport-level auth injection where the transport supports it |
| done | implement typed methods, client wrappers, and validation hooks | every ASCP core method is wrapped through a thin Dart client, method params and results stay protocol-faithful, and callers can plug validation without changing core semantics |
| done | implement replay helpers and stream-based subscription support | replay helpers support `from_seq`, `from_event_id`, opaque cursor pass-through, and snapshot-versus-live classification on top of the transport event stream |
| done | document the branch and refresh shared recovery docs | the branch reference, `dart/README.md`, and shared workspace docs explain usage, rationale, rejected alternatives, verification evidence, remaining limits, and the post-parity next step |

## Acceptance Criteria

The task is done only when all of the following are true:

- the Dart package remains SDK-only and does not pull in Flutter UI or protocol-core drift
- the typed Dart client covers the planned ASCP core method surface without hiding protocol semantics behind app-specific abstractions
- stream-based subscriptions work on top of the transport layer and the replay helpers preserve snapshot, replay, and cursor boundaries explicitly
- validation and auth hooks exist as additive SDK seams rather than provider-specific protocol changes
- focused tests and at least one mock-server example verify the executable surface on top of the existing foundation package
- the branch documentation states the chosen direction, rejected alternatives, verification evidence, deferred work, and what the repository should do after Dart reaches parity

## Next Likely Step

If this branch reaches parity cleanly, shift the repository back to shared SDK maintenance and parity follow-ups: tighten any remaining Dart package polish, add release-readiness checks comparable to the TypeScript package where justified, and document any upstream protocol ambiguities that the Dart executable surface exposed without silently redefining ASCP semantics in code.
