# Dart SDK Release Readiness Branch Reference

This document captures the implementation context for `feature/dart-sdk-release-readiness`.

Use it when you need to understand how the Dart SDK package was tightened for sustained downstream use after the client/replay branch, why the final package shape was chosen, what was verified, what remains intentionally limited, and what shared SDK maintenance should follow.

## Branch Identity

- Branch: `feature/dart-sdk-release-readiness`
- Scope: Dart release-facing package polish only

## What This Branch Added

This branch tightened the Dart package for downstream consumption without changing runtime behavior.

It added or refreshed:

- release-accurate `dart/pubspec.yaml` metadata for the executable Dart SDK surface
- `dart/LICENSE` and a release-ready `dart/CHANGELOG.md`
- `dart/tool/check_package_boundary.dart` for public library and example import boundary checks
- README guidance for installation, public imports, release shape, verification, and known limits
- roadmap, active plan, and status checkpoints that move the repository from Dart parity into shared SDK maintenance

## What Stayed Out Of Scope

This branch did not add:

- new ASCP methods, event payloads, or replay semantics
- new transports beyond the existing stdio and WebSocket surfaces
- Flutter widgets, app-state helpers, caching, persistence, or reconnect storage
- provider-specific auth flows or telemetry clients
- schema-registry validation runtime work
- package publishing automation or CI release pipelines

Those remain separate feature decisions so release polish does not become hidden SDK behavior.

## Final Package Boundary

The release-ready Dart package boundary is:

- root library: `package:ascp_sdk_dart/ascp_sdk_dart.dart`
- explicit secondary libraries: `client.dart`, `transport.dart`, `replay.dart`, `validation.dart`, `models.dart`, `methods.dart`, `events.dart`, and `errors.dart`
- private implementation tree: `lib/src/**`

Downstream consumers should import the root library for the common surface and secondary libraries when they want a clear seam. They should not import `package:ascp_sdk_dart/src/...`.

This is verified locally with:

```bash
cd sdk/dart
dart run tool/check_package_boundary.dart
```

## Versioning Decision

The first release-ready Dart package remains at `0.1.0`.

That choice was made for three reasons:

1. the package implements the first Dart downstream SDK for ASCP protocol `0.1.0`
2. the surface is stable enough for sustained downstream use, but ASCP and the SDKs are still intentionally pre-`1.0`
3. pre-`1.0` SemVer leaves room to refine package seams if real consumers expose a better boundary

Patch releases should preserve the documented public library boundary. Additive helpers should stay additive to ASCP semantics and should use an existing explicit library or a new top-level library. Breaking cleanup before `1.0.0` should not rename ASCP methods, events, or payload fields unless the upstream protocol changes first.

## Why This Shape Was Preferred

The branch reused the TypeScript release-readiness lessons conceptually but did not copy npm mechanics.

Chosen:

- one cohesive Dart package with explicit top-level libraries
- local package-boundary tool instead of npm export-map checks
- `dart pub publish --dry-run` as the registry-facing smoke check
- one MIT license and one changelog packaged with the Dart SDK

Rejected:

- splitting transport, replay, validation, or models into separate Dart packages before real lifecycle pressure exists
- adding release automation in this branch, because that is workflow infrastructure rather than package-surface readiness
- broadening validation into an embedded schema registry during release polish
- adding HTTP, SSE, relay, caching, or Flutter UI helpers to make the package look more complete

The selected shape keeps the SDK explicit and boring: it helps consumers use ASCP without hiding ASCP semantics.

## How To Use The Release-Ready Package

From a downstream Dart package:

```dart
import 'package:ascp_sdk_dart/client.dart';
import 'package:ascp_sdk_dart/replay.dart';
import 'package:ascp_sdk_dart/transport.dart';
```

Typical stdio mock-server proof:

```bash
cd sdk/dart
dart pub get
dart run example/mock_server_client.dart
```

Use `validation.dart` for callback validation hooks, `transport.dart` for explicit transport wiring, and `replay.dart` for `sessions.subscribe` replay helpers. Keep ASCP field names intact when serializing payloads or handling extension fields.

## Verification Evidence

The release-readiness branch is intended to be verified with:

```bash
cd sdk/dart
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed lib test example tool
dart run tool/check_package_boundary.dart
dart analyze
dart test
dart run example/foundation_decode.dart
dart run example/mock_server_client.dart
dart pub publish --dry-run
git diff --check
```

What these checks prove:

- generated code remains current
- formatter and analyzer accept the package
- public library boundaries and example imports remain stable
- package tests still cover models, client wrappers, replay helpers, transport behavior, and validation hooks
- examples decode upstream fixtures and exercise the deterministic mock server
- pub-facing metadata and release files are coherent enough for a dry-run publish

## Known Limits

- release validation is local and scriptable, not yet enforced by CI
- WebSocket has local transport coverage but no long-lived upstream WebSocket mock host proof
- validation hooks are callback seams, not a full Dart schema registry
- replay helpers expose boundaries and cursors but do not persist reconnect state for callers
- the package remains SDK-only and does not attempt to satisfy Flutter UI needs directly

## Shared SDK Maintenance Handoff

After this branch, the SDK workspace should shift from feature implementation to shared maintenance.

Recommended follow-up work:

- add CI or release automation as its own branch for both TypeScript and Dart
- keep package metadata, changelogs, README guidance, and package-boundary checks aligned across SDKs
- compare Dart and TypeScript mock-server integration coverage and close evidence gaps without adding new protocol semantics
- document real upstream ASCP ambiguities in the protocol repository instead of papering over them with SDK-specific behavior
