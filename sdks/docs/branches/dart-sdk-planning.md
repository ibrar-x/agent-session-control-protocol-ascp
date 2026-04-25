# Dart SDK Planning Branch Reference

This document captures the planning outcome for `feature/dart-sdk-planning`.

Use it when you need to understand how the Dart SDK should start after the TypeScript SDK became the first stable downstream reference package, what package and API shape the Dart work should mirror versus translate, why the chosen Dart direction was preferred over the plausible alternatives, and what the first implementation branch should build without reopening scope.

## Branch Identity

- Branch: `feature/dart-sdk-planning`
- Current repository state: planning-only branch with no Dart package implementation yet

## How To Use This Branch

The implementation branch should read these files in this order:

1. `plans.md`
2. `docs/status.md`
3. `docs/branches/dart-sdk-planning.md`
4. `dart/README.md`
5. `docs/branches/typescript-sdk-release-readiness.md`
6. `typescript/README.md`
7. `../ASCP_Protocol_Detailed_Spec_v0_1.md`
8. `../spec/methods.md`
9. `../spec/events.md`
10. `../spec/replay.md`
11. `../spec/auth.md`
12. `../schema/` and `../examples/`

What each file is for:

- `plans.md` gives the active feature boundary and next branch handoff.
- `docs/status.md` confirms the last completed checkpoint.
- this branch document explains the package decisions, tradeoffs, and open assumptions.
- `dart/README.md` is the compact package-facing summary for future implementation work.
- the TypeScript release-readiness docs define the downstream reference package boundaries that Dart should mirror conceptually.
- the upstream spec, schema, and example assets remain the protocol truth for exact contracts and replay behavior.

## Scope Confirmed On This Branch

The Dart SDK remains:

- a pure Dart SDK package
- downstream from the frozen ASCP protocol assets
- intended to be usable from Flutter, desktop Dart, tooling, and tests
- transport-neutral at the package boundary
- replay-safe and event-envelope-first

This branch intentionally does not:

- plan Flutter UI widgets, state management, or caching
- choose product-layer HTTP stacks or app networking opinions
- redefine protocol semantics that already exist upstream
- mix Dart implementation work into the TypeScript branch history

## Inputs Used

The planning decisions here were derived from:

- `../ASCP_Protocol_Detailed_Spec_v0_1.md`
- `../schema/`
- `../spec/methods.md`
- `../spec/events.md`
- `../spec/replay.md`
- `../spec/auth.md`
- `../examples/requests/sessions-subscribe.json`
- `../examples/responses/sessions-subscribe.json`
- `../examples/responses/sessions-resume.json`
- `../examples/events/sync-snapshot.json`
- `../examples/events/sync-replayed.json`
- `../examples/events/sync-cursor-advanced.json`
- `../../ASCP_Dart_SDK_Implementation_Plan.md`
- `../../ASCP_Next_Phase_Master_Roadmap.md`
- `typescript/README.md`
- `typescript/CHANGELOG.md`
- `typescript/package.json`
- `typescript/src/index.ts`
- `docs/branches/typescript-sdk-release-readiness.md`

## Package Scope Decision

The Dart SDK should ship as one package with one primary happy-path library and several explicit secondary libraries.

Planned package identity:

- package name: `ascp_sdk_dart`
- primary import: `package:ascp_sdk_dart/ascp_sdk_dart.dart`

Why one package:

- the TypeScript release-ready package proved that one downstream package with explicit lower-level seams is enough for ASCP without hiding the protocol
- a single package keeps Flutter, CLI, test, and desktop consumers on one protocol-faithful surface
- splitting models, transport, or replay into separate pub packages now would create version-coupling work before the first Dart consumer package exists

## Package Layout Decision

The Dart package should mirror the TypeScript package boundary conceptually, but translate it into Dart library entrypoints instead of npm subpath exports.

Planned layout:

```text
dart/
  README.md
  pubspec.yaml
  analysis_options.yaml
  lib/
    ascp_sdk_dart.dart
    client.dart
    replay.dart
    transport.dart
    validation.dart
    models.dart
    methods.dart
    events.dart
    errors.dart
    src/
      client/
      replay/
      transport/
      validation/
      codecs/
      models/
      methods/
      events/
      errors/
      auth/
  test/
  example/
  tool/
```

Boundary rules for the planned layout:

- `ascp_sdk_dart.dart` is the root happy path for `AscpClient`, replay helpers, and thin protocol model exports.
- `transport.dart` is the explicit lower-level transport seam.
- `validation.dart` is the explicit runtime parsing and guard seam.
- `client.dart` and `replay.dart` stay available as direct seam imports for advanced consumers.
- `models.dart`, `methods.dart`, `events.dart`, and `errors.dart` expose the protocol-facing types without forcing consumers through the full client layer.
- `lib/src/auth/` stays reserved, but auth helpers are not part of the first implementation branch.

What should be mirrored from TypeScript:

- one obvious root happy path
- explicit lower-level seams for transport, validation, client, and replay
- thin protocol-facing types instead of app-specific DTO aliases
- additive package growth instead of a giant convenience namespace

What should be translated for Dart:

- use library entrypoints under `lib/` rather than npm export-map subpaths
- do not mirror TypeScript packaging details such as `prepack`, tarball checks, or Node-only entrypoints
- keep diagnostics and analytics out of the initial Dart branch set unless a later Dart-specific branch explicitly adds them

## Model And Codec Strategy

The Dart SDK should use generated immutable models for stable ASCP DTOs, plus hand-authored dispatch for method and event envelopes.

Chosen direction:

- use `freezed` for immutable value types and sealed unions where they add clarity
- use `json_serializable` for JSON conversion
- keep public barrel files hand-authored so package boundaries remain explicit
- keep ASCP field names unchanged in Dart models
- use hand-authored codec helpers to dispatch method envelopes by `method` and event envelopes by `type`
- preserve unknown extension content by keeping raw JSON available at the envelope boundary and by treating unknown namespaced event types as raw envelopes rather than dropping them

Apply this strategy to these layers:

- core entities such as `Host`, `Runtime`, `Session`, `Run`, `ApprovalRequest`, `Artifact`, and `DiffSummary`
- method params and success envelopes for the ASCP core method set
- exact core event payload models for the event catalog
- shared JSON-RPC and event-envelope wrappers

Why this direction was chosen:

- it stays close to the current Dart implementation plan, which already favored `freezed` plus `json_serializable`
- it mirrors the TypeScript lesson that the public SDK surface should be hand-shaped even when the payload definitions remain schema-led
- it avoids locking the repository into a brittle schema-to-Dart code generator before the first Dart package exists
- it keeps the package friendlier to Flutter and normal Dart tooling than a pure runtime schema-interpreter approach

Alternatives rejected:

### Full schema-to-Dart code generation as the first foundation move

Rejected because the upstream schema set is the protocol truth, but the Dart package still needs hand-authored entrypoints, envelope dispatch, and extension-preserving behavior. A generator-first start would front-load tooling complexity before the first Dart package shape is proven.

### Fully hand-written JSON codecs for every DTO

Rejected because the ASCP surface is large enough that manual codecs would create avoidable boilerplate and make drift against upstream examples harder to spot.

### Translating ASCP field names into Dart-style aliases

Rejected because the SDK must stay protocol-faithful. Consumers should still be able to compare Dart payloads directly against upstream schemas, examples, and conformance fixtures.

## Validation Plan

Validation should remain schema-led in source material, but the runtime Dart SDK should validate primarily through generated codecs plus focused semantic guards rather than through a heavyweight on-device JSON Schema engine.

Planned validation shape:

- foundation branch sets up generated models, JSON codecs, and focused example-backed serialization tests
- executable branch exposes `parse` and `tryParse` helpers for core entities, method results, and core event envelopes
- validation errors normalize into a Dart SDK error type that explains what failed, where it failed, and the likely fix
- upstream schemas, examples, and replay fixtures remain the verification source during tests and package review

What this means in practice:

- decoding a `sessions.get` response or a `sync.snapshot` event should fail loudly and structurally when required fields or enum values are wrong
- unknown extension events should remain available as raw envelopes even when exact core-event decoding is not possible
- validation should be explicit opt-in at the helper boundary, not a hidden mutation of decoded payloads

Why this direction was preferred:

- Dart does not need to ship a generic JSON Schema interpreter to stay faithful to a schema-led protocol
- generated codecs plus focused guards are easier to reason about in Flutter and Dart runtimes
- the TypeScript package already proved that validation should be its own seam, but the tooling can differ by language

## Subscription And Replay Surface Plan

The Dart stream surface should stay envelope-first at the transport boundary and replay-aware at the helper boundary.

Planned layered surface:

- `transport.dart` defines the replaceable request and subscription contracts
- `client.dart` owns typed method wrappers, including `sessions.subscribe` and `sessions.unsubscribe`
- `replay.dart` owns replay request builders, replay classification helpers, and checkpoint tracking on top of the client layer
- `events.dart` owns the typed core-event models and event parsing helpers

Recommended runtime shape:

- the low-level subscription stream carries `AscpEventEnvelope` values so unknown extension events are preserved
- a typed parser helper converts recognized core events into exact typed events when consumers want stricter handling
- `AscpSessionSubscription` should expose:
  - the `subscriptionId`
  - the `sessionId`
  - whether `snapshotEmitted` was reported
  - the raw `Stream<AscpEventEnvelope>`
  - a close or unsubscribe path that maps back to `sessions.unsubscribe`
- replay helpers should expose builders and trackers for:
  - `fromSeq`
  - `fromEventId`
  - `includeSnapshot`
  - replay completion markers from `sync.replayed`
  - opaque cursor advancement from `sync.cursor_advanced`

Replay rules this surface must preserve from upstream:

- `from_seq` is an inclusive lower bound
- `from_event_id` is an exclusive anchor
- `sync.snapshot` is current-state material, not historical replay
- `sync.replayed` marks the boundary between replayed history and resumed live events
- opaque cursor handling is additive and must not redefine the core replay semantics

Alternatives rejected:

### Stream only typed core events

Rejected because it would either drop unknown extension events or force the SDK to invent a parallel fallback channel. The raw envelope must stay available.

### Bake replay logic into transport instead of layering it on top

Rejected because the TypeScript SDK proved that replay helpers belong above the core transport seam. Replay is a protocol-use pattern, not the transport primitive itself.

### Flutter-specific notifier or state container APIs

Rejected because the SDK package must stay usable from Flutter, CLI, tests, and plain Dart without importing UI opinions.

## Open Assumptions And Acceptable Planning-Time Unknowns

These questions remain open, but they do not block the foundation branch:

- whether the first executable Dart transport after the foundation branch should be WebSocket, a test transport, or another host-facing transport that matches the first real ASCP surface available then
- whether auth hooks should first appear as simple request-metadata injection interfaces or as a richer credential-provider seam
- whether exact typed extension-event support is needed early, or whether raw-envelope preservation is enough for the initial Dart release
- whether a later Dart-specific diagnostics surface should exist as its own library, or remain deferred until real downstream operators ask for it

These unknowns are acceptable now because the foundation branch only needs to lock package seams, model strategy, codec workflow, and replay-aware shape. It does not need to finalize app networking choices or production observability policy.

## Validation And Review Used For This Plan

The planning quality for this branch was judged by checking that:

- the package direction stays inside `AGENTS.md` SDK-only scope
- the chosen layout mirrors the TypeScript release-ready package where that adds clarity
- the Dart decisions stay aligned with the detailed ASCP method, event, replay, and auth contracts
- the replay surface preserves the exact upstream snapshot versus replay rules
- the documented handoff is concrete enough that the next branch can start without reopening core scope decisions

This branch is documentation-only, so no runtime package build or test commands were run.

## First Implementation Branch

The first implementation branch should be `feature/dart-sdk-foundation`.

That branch should build:

- `pubspec.yaml`, `analysis_options.yaml`, and the build-runner or codegen baseline
- the root and secondary library entrypoints listed in this plan
- generated core models and JSON codecs for the stable ASCP DTOs
- shared envelope and error types
- placeholder directory structure for `client`, `transport`, `validation`, `replay`, and `auth`
- focused tests that prove the generated codecs round-trip or decode the upstream example payloads correctly
- package README updates that explain the foundation boundary and what remains for the executable branch

That branch should not yet build:

- live transport implementations if they would force app-layer transport choices
- the full typed client method surface
- replay orchestration helpers beyond the type and directory scaffolding they depend on
- Flutter UI integrations

## Next Branch After Foundation

After `feature/dart-sdk-foundation`, the expected executable branch remains `feature/dart-sdk-client`.

That later branch should add:

- typed method wrappers
- subscription lifecycle handling
- replay helpers
- transport abstraction implementations justified by the first real Dart integration target
- validation helpers on top of the generated model baseline

