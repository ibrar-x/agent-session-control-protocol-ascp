# ASCP SDK Status Log

Use this file as a session-to-session checkpoint log. Each completed task should add a concise entry.

## Entry Template

### YYYY-MM-DD - Short Task Name

- Branch:
- Commit:
- Summary:
- Documentation updated:
- Next likely step:

## Entries

### 2026-04-25 - Dart SDK planning refresh

- Branch: `feature/dart-sdk-planning`
- Commit: `not committed`
- Summary: refreshed the Dart SDK plan after the TypeScript package reached release-ready stability, locked the Dart package as one pure SDK package with explicit secondary libraries, chose generated immutable models plus hand-authored envelope dispatch, and documented the stream-first replay surface plus the `feature/dart-sdk-foundation` handoff
- Documentation updated: `plans.md`, `README.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/sdk-build-roadmap.md`, `docs/status.md`, `docs/branches/dart-sdk-planning.md`, `dart/README.md`
- Next likely step: create `feature/dart-sdk-foundation` from updated `main` and scaffold the Dart package, library entrypoints, generated model and codec workflow, shared envelope types, and example-backed baseline tests

### 2026-04-25 - TypeScript SDK release readiness

- Branch: `feature/typescript-sdk-release-readiness`
- Commit: `not committed`
- Summary: tightened the TypeScript SDK package for sustained downstream use by documenting the `0.1.0` release policy, clarifying the root-versus-subpath export boundary, adding packaged changelog and license files, and adding release-specific type/export/tarball verification commands
- Documentation updated: `plans.md`, `docs/README.md`, `docs/status.md`, `docs/branches/typescript-sdk-release-readiness.md`, `docs/prompts/dart-sdk-planning.md`, `typescript/README.md`, `typescript/CHANGELOG.md`, `typescript/package.json`
- Next likely step: use the release-readiness branch outputs as the downstream reference set when refreshing or starting the dedicated Dart SDK planning branch

### 2026-04-25 - TypeScript SDK examples and integration tests

- Branch: `feature/typescript-sdk-examples-tests`
- Commit: `not committed`
- Summary: added end-to-end mock-server integration coverage for the published TypeScript SDK surface, introduced standalone subscribe/replay, approval, and artifact/diff example scripts, and documented how downstream consumers can run the examples and tests without hand-written protocol DTOs
- Documentation updated: `plans.md`, `docs/README.md`, `docs/status.md`, `docs/branches/typescript-sdk-examples-tests.md`, `typescript/README.md`, `typescript/package.json`
- Next likely step: create `feature/typescript-sdk-release-readiness` from updated `main` and tighten package polish, release-facing docs, and any remaining production-hardening gaps exposed by the end-to-end proof layer

### 2026-04-24 - TypeScript SDK replay helpers

- Branch: `feature/typescript-sdk-replay`
- Commit: `not committed`
- Summary: added a replay entry point for the TypeScript SDK with `from_seq` and `from_event_id` request builders, additive opaque cursor pass-through, a snapshot-versus-replay subscription helper on top of the typed client, cursor tracking from `sync.cursor_advanced`, and focused runtime plus type-level replay tests driven by the upstream replay fixtures
- Documentation updated: `plans.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/status.md`, `docs/branches/typescript-sdk-replay.md`, `typescript/README.md`, `typescript/package.json`
- Next likely step: create `feature/typescript-sdk-examples-tests` from updated `main` and add end-to-end examples plus mock-server integration coverage that exercises the typed client and replay helpers together

### 2026-04-24 - TypeScript SDK typed client methods

- Branch: `feature/typescript-sdk-client`
- Commit: this commit
- Summary: added the TypeScript SDK client entry point with typed wrappers for every ASCP core method, result unwrapping, request option pass-through, event/lifecycle delegation to transport, and normalized `AscpProtocolError` mapping for ASCP error response envelopes
- Documentation updated: `plans.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/sdk-build-roadmap.md`, `docs/status.md`, `docs/branches/typescript-sdk-client.md`, `typescript/README.md`, `typescript/package.json`
- Next likely step: create `feature/typescript-sdk-replay` from updated `main` and build replay helpers on top of `AscpClient.subscribe`, `AscpClient.unsubscribe`, `AscpClient.events`, the existing transport stream, and the existing analytics/diagnostic conventions without changing typed wrapper result shapes

### 2026-04-24 - TypeScript SDK analytics and production hardening

- Branch: `feature/typescript-sdk-analytics`
- Commit: `not committed`
- Summary: added an analytics entry point for the TypeScript SDK with opt-in recorder contracts, instrumented the existing transport layer with structured lifecycle events, exposed remediation helpers for transport and validation errors, added baseline production package metadata, and updated AGENTS plus the prompt pack so future branches preserve observability automatically
- Documentation updated: `AGENTS.md`, `plans.md`, `README.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/prompts/README.md`, `docs/prompts/typescript-sdk-transport-client.md`, `docs/sdk-build-roadmap.md`, `docs/status.md`, `docs/branches/typescript-sdk-analytics.md`, `typescript/README.md`, `typescript/package.json`
- Next likely step: create `feature/typescript-sdk-client` from updated `main` and build typed ASCP method wrappers on top of `ascp-sdk-typescript/transport`, `ascp-sdk-typescript/validation`, and `ascp-sdk-typescript/analytics` so client methods inherit observability instead of re-implementing it

### 2026-04-24 - TypeScript SDK transport layer

- Branch: `feature/typescript-sdk-transport`
- Commit: `not committed`
- Summary: added a transport entry point for the TypeScript SDK with shared request and subscription contracts, implemented persistent stdio and WebSocket adapters, normalized transport-level failures into `AscpTransportError`, and covered the new surface with focused runtime and type-level tests including stdio mock-server integration
- Documentation updated: `plans.md`, `README.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/sdk-build-roadmap.md`, `docs/status.md`, `docs/branches/typescript-sdk-transport.md`, `typescript/README.md`, `typescript/package.json`
- Next likely step: create `feature/typescript-sdk-client` from updated `main` and build typed ASCP method wrappers on top of `ascp-sdk-typescript/transport` plus `ascp-sdk-typescript/validation` instead of re-implementing request execution or transport error handling

### 2026-04-24 - TypeScript SDK validation layer

- Branch: `feature/typescript-sdk-validation`
- Commit: `not committed`
- Summary: added an AJV-backed validation entry point for the TypeScript SDK, vendored the upstream ASCP schema set into the package, exposed safe parse and assert helpers for core entities, method responses, and event envelopes, and covered the new surface with focused runtime and type-level tests
- Documentation updated: `plans.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/status.md`, `docs/branches/typescript-sdk-validation.md`, `typescript/README.md`
- Next likely step: create `feature/typescript-sdk-transport` from updated `main` and build stdio plus WebSocket transport primitives on top of `ascp-sdk-typescript/validation` instead of re-implementing payload checks

### 2026-04-24 - SDK branch documentation discipline

- Branch: `feature/sdk-branch-documentation`
- Commit: `not committed`
- Summary: added a dedicated branch reference for the completed TypeScript SDK foundation work and updated the prompt pack plus roadmap so every future SDK branch must document usage, rationale, alternatives, verification evidence, limitations, and handoff context before closeout
- Documentation updated: `plans.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/status.md`, `docs/sdk-build-roadmap.md`, `docs/prompts/README.md`, `docs/prompts/typescript-sdk-foundation.md`, `docs/prompts/typescript-sdk-validation.md`, `docs/prompts/typescript-sdk-transport-client.md`, `docs/prompts/dart-sdk-planning.md`, `docs/branches/typescript-sdk-foundation.md`, `typescript/README.md`
- Next likely step: create `feature/typescript-sdk-validation` from updated `main` and use the new foundation branch reference plus validation prompt to implement schema-backed parsing without restructuring the package

### 2026-04-23 - TypeScript SDK foundation

- Branch: `feature/typescript-sdk-foundation`
- Commit: `not committed`
- Summary: scaffolded the TypeScript SDK package with an installable package baseline, explicit root and subpath exports, authored core protocol models and request/event/error surfaces, reserved directories for later validation/transport/replay/auth work, and baseline runtime plus type-level checks
- Documentation updated: `plans.md`, `README.md`, `docs/project-context-reference.md`, `docs/status.md`, `docs/prompts/typescript-sdk-foundation.md`, `docs/prompts/typescript-sdk-validation.md`, `docs/prompts/typescript-sdk-transport-client.md`, `docs/prompts/dart-sdk-planning.md`, `typescript/README.md`
- Next likely step: create `feature/typescript-sdk-validation` from updated `main` and add schema loading, AJV-backed validators, and validation error formatting on top of the existing foundation package shape

### 2026-04-22 - SDK repository bootstrap

- Branch: `feature/sdk-repo-bootstrap`
- Commit: `not committed`
- Summary: bootstrapped the downstream ASCP SDK workspace with SDK-only repository rules, an active plan, a resumable status log, a docs index, an end-to-end SDK delivery roadmap, prompt starters for the first workstreams, a local SDK skill pack, and placeholder roots for the TypeScript-first package layout
- Documentation updated: `AGENTS.md`, `README.md`, `plans.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/repo-operating-system.md`, `docs/sdk-build-roadmap.md`, `docs/status.md`, `docs/prompts/README.md`, `docs/prompts/typescript-sdk-foundation.md`, `docs/prompts/typescript-sdk-validation.md`, `docs/prompts/typescript-sdk-transport-client.md`, `docs/prompts/dart-sdk-planning.md`, `typescript/README.md`, `dart/README.md`
- Next likely step: create `feature/typescript-sdk-foundation` from updated `main` and scaffold the initial TypeScript package structure, model strategy, and public exports without widening into transport or client work
