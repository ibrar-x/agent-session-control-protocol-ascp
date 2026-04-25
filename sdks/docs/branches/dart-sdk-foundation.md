# Dart SDK Foundation Branch Reference

This document captures the detailed implementation context for `feature/dart-sdk-foundation`.

Use it when you need to understand how the current Dart foundation should be used, why the package surface and codec workflow were designed this way, what this branch intentionally does not implement yet, and what the executable Dart branch should inherit without reopening foundation scope.

## Branch Identity

- Branch: `feature/dart-sdk-foundation`
- Current repository state: foundation branch with package scaffold, generated model baseline, and branch-local verification evidence

## What This Branch Added

The foundation branch established the first real Dart package shape under `sdk/dart/`.

It added:

- installable package metadata in `dart/pubspec.yaml`
- analyzer and repository hygiene baselines in `dart/analysis_options.yaml` and `dart/.gitignore`
- explicit root and secondary libraries under `dart/lib/`
- generated immutable core DTOs for stable ASCP entities
- shared JSON-RPC request and response envelopes plus raw event-envelope support
- a typed `sessions.subscribe` success-result model
- a typed `sync.snapshot` event model
- reserved source directories and marker libraries for later `client`, `transport`, `validation`, `replay`, and `auth` work
- example-backed tests that decode upstream ASCP payloads through the generated codecs

## What It Intentionally Did Not Add

This branch did not implement:

- live transport implementations
- a concrete Dart client
- replay helpers
- runtime validation helpers
- auth-hook behavior
- Flutter UI or app-state concerns

Those belong to `feature/dart-sdk-client` or later Dart-specific refinement branches and were intentionally excluded so the package shape could stabilize first.

## Upstream Inputs That Shaped The Branch

The branch was built directly from these upstream inputs:

- `../../../ASCP_Dart_SDK_Implementation_Plan.md`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`
- `../../schema/`
- `../../spec/`
- `../../examples/`
- `../branches/dart-sdk-planning.md`
- `../branches/typescript-sdk-foundation.md`
- `../branches/typescript-sdk-release-readiness.md`

These inputs were used for different purposes:

- the Dart implementation plan and planning branch fixed the package layout, codec direction, and scope boundary
- the detailed ASCP spec and schema files kept the field names and envelope shapes protocol-faithful
- the example payloads anchored the first executable decode tests
- the TypeScript foundation and release-readiness branches acted as the downstream reference for how much surface should be locked before executable behavior was added

## How To Use The Current Foundation

From `sdk/dart/`:

```bash
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart analyze
dart test
```

The package is foundation-first rather than executable. The root library is the common import point for models, methods, events, and errors, while the client, transport, validation, and replay libraries exist as explicit seams that later branches can fill in without moving the package boundary.

Current import points:

- package root: `ascp_sdk_dart`
- models: `ascp_sdk_dart/models.dart`
- methods: `ascp_sdk_dart/methods.dart`
- events: `ascp_sdk_dart/events.dart`
- errors: `ascp_sdk_dart/errors.dart`
- reserved executable seams: `ascp_sdk_dart/client.dart`, `ascp_sdk_dart/transport.dart`, `ascp_sdk_dart/validation.dart`, `ascp_sdk_dart/replay.dart`

Representative usage from the current branch shape:

```dart
import 'package:ascp_sdk_dart/ascp_sdk_dart.dart';

final session = AscpSession.fromJson(<String, Object?>{
  'id': 'sess_abc123',
  'runtime_id': 'codex_local',
  'status': 'running',
  'created_at': '2026-04-21T10:00:00Z',
  'updated_at': '2026-04-21T10:12:00Z',
});

final event = AscpEventEnvelope.fromJson(<String, Object?>{
  'id': 'evt_9001',
  'type': 'message.assistant.delta',
  'ts': '2026-04-21T10:07:00Z',
  'session_id': session.id,
  'payload': <String, Object?>{
    'message_id': 'msg_12',
    'delta': 'I found the failing assertion...'
  },
});
```

## Source Layout You Should Assume

The branch intentionally locked in this package layout:

```text
dart/
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
      auth/
      client/
      errors/
      events/
      methods/
      models/
      replay/
      transport/
      validation/
  test/
  example/
  tool/
```

The reserved directories are important. Later branches should extend them instead of introducing a new top-level package structure.

## Thought Process Behind The Design

The main design goal was to stabilize the Dart package seams before executable behavior arrived.

That led to five decisions:

1. ship one package instead of multiple pub packages so downstream consumers get one protocol-faithful install surface
2. translate TypeScript subpath concepts into Dart library entrypoints instead of copying npm packaging details
3. use `freezed` plus `json_serializable` for generated immutable DTOs rather than hand-writing every codec
4. keep ASCP field names unchanged so examples, schemas, and Dart payloads line up directly
5. keep raw event envelopes alongside the first typed event model so unknown extension events still have a protocol-preserving home

The branch was deliberately biased toward boring packaging and codec choices over clever abstraction. That matches the ASCP protocol constraints and reduces drift risk for the later client, replay, and validation work.

## Why This Approach Was Chosen

### One package with explicit secondary libraries instead of multiple pub packages

This was chosen because the first Dart SDK should prove the downstream package surface before introducing cross-package version coordination. One installable package is enough to keep the root happy path obvious while still exposing lower-level seams intentionally.

### `freezed` plus `json_serializable` instead of hand-written codecs

This was chosen because the ASCP DTO surface is large enough that manual codec maintenance would create avoidable drift risk. Generated immutable models also fit normal Dart and Flutter-adjacent tooling well.

### Hand-authored barrel files instead of schema-to-Dart generation for every public library

This was chosen because the public library structure is a package-boundary decision, not a schema decision. The branch keeps the model generation automated while preserving explicit control over what each library exports.

### Raw `AscpEventEnvelope` alongside selective typed event models

This was chosen because the planning branch required unknown extension events to remain preservable. The foundation therefore keeps the raw event envelope visible and adds typed event models incrementally where they clarify core ASCP behavior.

## Alternatives Considered And Rejected

### Generate the full package surface directly from upstream schemas

Rejected in this branch because the package still needed hand-authored library boundaries, selective typed envelope dispatch, and recoverable downstream documentation. A generator-only start would have front-loaded tooling complexity without proving the package shape.

### Hand-write JSON codecs for every DTO

Rejected because it would create too much boilerplate for a protocol package whose upstream truth already lives in structured schemas and examples.

### Split models, transport, or replay into separate Dart packages now

Rejected because the first Dart branch should prove one coherent SDK package before introducing version-coupling and package-graph maintenance.

### Build the executable client in the same branch

Rejected because it would have mixed package-shape decisions with transport and replay behavior, making it harder to tell whether later issues came from layout mistakes or executable logic.

## Verification Evidence

The foundation branch was verified with:

```bash
cd sdk/dart
dart run build_runner build --delete-conflicting-outputs
dart analyze
dart test
```

What these commands proved:

- `build_runner` proved the generated model and codec workflow resolves and produces stable outputs inside the package
- `dart analyze` proved the package shape, imports, and library surfaces are clean under the configured analyzer rules
- `dart test` proved the public package surface compiles and the generated codecs successfully decode upstream ASCP example payloads for sessions, event envelopes, subscription success results, and sync snapshots

## Known Limitations And Deferred Work

The current foundation has important limits:

- the reserved executable libraries are markers only
- the method surface is not typed beyond the initial subscription success result
- replay helpers do not exist yet
- runtime validation helpers do not exist yet
- typed event coverage is intentionally selective rather than exhaustive
- unknown extension fields are preserved at the raw event-envelope boundary, not through a full typed extension system yet

These are expected limits, not regressions. They are the reason the next branch should focus on executable client behavior rather than restructuring the package.

## What The Next Branch Should Assume

The next branch is:

- `feature/dart-sdk-client`

That branch should assume:

- the package root and secondary library layout are stable
- the `freezed` plus `json_serializable` workflow is the approved model and codec baseline
- core DTOs and shared envelopes should be extended additively rather than replaced
- raw event envelopes remain the preservation path for unknown extension events
- transport, validation, replay, and typed client code should be added under the already-reserved source directories

The executable branch should not revisit the foundation package shape unless a genuine upstream protocol issue forces it.
