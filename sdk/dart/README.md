# ASCP Dart SDK

This package is the Dart foundation for ASCP.

The current package state is intentionally limited to foundation work: installable package metadata, explicit library seams, generated immutable models, shared JSON envelopes, selected typed method and event payloads, and example-backed codec tests.

For the branch-level rationale and handoff context, see:

- `../docs/branches/dart-sdk-planning.md`
- `../docs/branches/dart-sdk-foundation.md`

## Install

Requirements:

- Dart SDK `>=3.8.0 <4.0.0`

Install dependencies locally:

```bash
dart pub get
```

Generate model and codec code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Verify the foundation branch:

```bash
dart analyze
dart test
```

## Current Scope

This foundation package currently provides:

- generated immutable core DTOs for ASCP entities such as `Host`, `Runtime`, `Session`, `Run`, `ApprovalRequest`, `Artifact`, and `DiffSummary`
- shared JSON-RPC and event-envelope models
- a typed `sessions.subscribe` success result model
- a typed `sync.snapshot` event model
- one root library plus explicit secondary libraries for later client, transport, validation, replay, model, method, event, and error work

This branch intentionally does not provide:

- live transport implementations
- typed method wrappers for the full ASCP method set
- replay helpers
- runtime validation helpers
- Flutter UI concerns or app-level networking policy

## Package Layout

```text
dart/
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

Current public libraries:

- `package:ascp_sdk_dart/ascp_sdk_dart.dart`: root foundation exports for models, methods, events, and errors
- `package:ascp_sdk_dart/models.dart`
- `package:ascp_sdk_dart/methods.dart`
- `package:ascp_sdk_dart/events.dart`
- `package:ascp_sdk_dart/errors.dart`
- `package:ascp_sdk_dart/client.dart`
- `package:ascp_sdk_dart/transport.dart`
- `package:ascp_sdk_dart/validation.dart`
- `package:ascp_sdk_dart/replay.dart`

The `client`, `transport`, `validation`, and `replay` libraries are foundation-only markers in this branch so later implementation can extend the already-published seams without moving package boundaries.

## Model And Codec Strategy

The foundation follows the direction locked in `feature/dart-sdk-planning`:

- use `freezed` for immutable value types
- use `json_serializable` for JSON conversion
- keep public barrel files hand-authored
- keep ASCP field names unchanged instead of introducing Dart aliases
- keep the raw event-envelope shape available at the root surface
- add typed method and event dispatch incrementally instead of generating every protocol layer at once

This means the package stays close to the upstream ASCP schema and example assets while still fitting normal Dart and Flutter-adjacent tooling.

## Example

```dart
import 'package:ascp_sdk_dart/ascp_sdk_dart.dart';

void main() {
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

  print(session.toJson());
  print(event.toJson());
}
```

## Upstream Inputs

This package depends on the upstream ASCP assets:

- `../../../ASCP_Dart_SDK_Implementation_Plan.md`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`
- `../../schema/`
- `../../spec/`
- `../../examples/`

The schema, spec, and example assets remain the protocol truth. The Dart package is a downstream translation layer, not a place to redefine ASCP semantics.

## Next Branch

The expected next branch is `feature/dart-sdk-client`.

That branch should preserve the current package layout and code-generation strategy, then add:

- typed method wrappers
- subscription lifecycle handling
- replay helpers
- validation helpers
- the first justified transport implementations
