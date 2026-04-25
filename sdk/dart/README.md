# ASCP Dart SDK

This directory is the planned home for the ASCP Dart SDK package.

The TypeScript SDK is now the first stable downstream reference package. Dart should follow it intentionally, not as a Flutter-only side branch and not by copying Node-specific packaging choices.

Use these files before starting implementation:

1. `../plans.md`
2. `../docs/status.md`
3. `../docs/branches/dart-sdk-planning.md`
4. `../docs/branches/typescript-sdk-release-readiness.md`
5. `../../ASCP_Dart_SDK_Implementation_Plan.md`
6. `../../schema/`
7. `../../spec/`
8. `../../examples/`

## Confirmed Package Scope

The Dart SDK should provide:

- typed ASCP models
- method wrappers
- event subscription support
- replay helpers
- transport abstraction
- validation hooks
- auth-hook seams later
- Flutter-friendly async ergonomics without Flutter UI code

The Dart SDK should not become:

- a Flutter UI package
- app-level networking policy
- local cache or state-management glue
- a protocol-redefinition layer

## Planned Package Direction

The chosen direction from `feature/dart-sdk-planning` is:

- one pure Dart package named `ascp_sdk_dart`
- one root happy-path library at `package:ascp_sdk_dart/ascp_sdk_dart.dart`
- explicit secondary libraries for `client`, `replay`, `transport`, `validation`, `models`, `methods`, `events`, and `errors`
- generated immutable DTOs plus hand-authored envelope dispatch and public barrel files
- replay helpers layered above the client seam, not baked into transport
- raw event-envelope preservation for unknown extension events

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

## First Implementation Branch

The first implementation branch should be `feature/dart-sdk-foundation`.

That branch should scaffold the package, the library entrypoints, the generated model and codec workflow, shared envelope and error types, and example-backed baseline tests.

For the full rationale, tradeoffs, alternatives, replay plan, and open assumptions, read `../docs/branches/dart-sdk-planning.md`.
