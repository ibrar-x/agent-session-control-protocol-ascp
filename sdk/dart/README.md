# ASCP Dart SDK

This package is the Dart executable SDK for ASCP.

It preserves the foundation branch layout and now adds the runtime surface that downstream Dart or Flutter-adjacent consumers need without turning the package into a UI toolkit, daemon, or protocol-core fork.

For the branch-level rationale and handoff context, see:

- `../docs/branches/dart-sdk-foundation.md`
- `../docs/branches/dart-sdk-client.md`
- `../docs/branches/dart-sdk-release-readiness.md`

## Install

Requirements:

- Dart SDK `>=3.8.0 <4.0.0`

From `sdk/dart/`:

```bash
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart run tool/check_package_boundary.dart
dart analyze
dart test
dart run example/foundation_decode.dart
dart run example/mock_server_client.dart
dart pub publish --dry-run
```

## Current Surface

The current package provides:

- immutable ASCP core DTOs and shared JSON-RPC envelopes
- typed request and result models for the ASCP core method set
- a thin `AscpClient` that wraps every core ASCP method
- replaceable stdio and WebSocket transports
- stream-based event access through `AscpTransport.events` and `AscpClient.events`
- replay helpers for `from_seq`, `from_event_id`, and opaque cursor pass-through
- validation hooks for outgoing params, incoming method results, and streamed events
- transport auth hooks for environment injection on stdio and header injection on WebSocket
- focused tests plus a mock-server example

This package intentionally does not provide:

- Flutter widgets or app-state helpers
- HTTP/SSE/relay transport implementations
- schema-generated validation against the full upstream schema set
- vendor-specific auth protocols or token refresh logic
- caching or local persistence layers

## Public Libraries

- `package:ascp_sdk_dart/ascp_sdk_dart.dart`
- `package:ascp_sdk_dart/client.dart`
- `package:ascp_sdk_dart/transport.dart`
- `package:ascp_sdk_dart/replay.dart`
- `package:ascp_sdk_dart/validation.dart`
- `package:ascp_sdk_dart/models.dart`
- `package:ascp_sdk_dart/methods.dart`
- `package:ascp_sdk_dart/events.dart`
- `package:ascp_sdk_dart/errors.dart`

Use the root library for the common client, replay, transport, validation, and model surface. Use secondary libraries when a downstream consumer wants an explicit seam, such as importing only `transport.dart` for host wiring or only `validation.dart` for callback hooks.

Do not import from `package:ascp_sdk_dart/src/...`. The `src` tree is private implementation detail under Dart package conventions, and the release boundary is verified by `dart run tool/check_package_boundary.dart`.

## Example

```dart
import 'package:ascp_sdk_dart/client.dart';
import 'package:ascp_sdk_dart/replay.dart';
import 'package:ascp_sdk_dart/transport.dart';

Future<void> main() async {
  final transport = AscpStdioTransport(
    command: const <String>[
      'python3',
      '../mock-server/src/mock_server/cli.py',
    ],
    workingDirectory: '/path/to/repo/sdk',
  );
  final client = AscpClient(transport: transport);

  await client.connect();

  try {
    final capabilities = await client.getCapabilities();
    print(capabilities.host.name);

    final replaySubscription = await subscribeWithReplay(
      client: client,
      request: replayFromSeq(
        sessionId: 'sess_abc123',
        fromSeq: 34,
        includeSnapshot: true,
      ),
    );

    try {
      await for (final item in replaySubscription.stream.take(4)) {
        print('${item.kind}: ${item.event.type}');
      }
    } finally {
      await replaySubscription.close();
    }
  } finally {
    await client.close();
  }
}
```

The runnable version of this example lives at `example/mock_server_client.dart`.

## API Shape Notes

The Dart surface keeps a few deliberate boundaries:

- the client stays thin and method-oriented instead of hiding ASCP behind session caches or repositories
- transports own connection concerns and expose one event stream rather than having the client re-implement transport lifecycle
- replay remains an explicit helper layer on top of `sessions.subscribe` so snapshot, replay, and live boundaries stay visible
- validation hooks are opt-in callbacks rather than a hard-coded schema runtime
- auth hooks stay transport-specific because the upstream ASCP auth model explicitly leaves credential exchange outside protocol-core semantics

These choices were preferred over fatter abstractions because they preserve protocol fidelity and keep downstream consumers close to the actual ASCP payloads and recovery rules.

## Release Shape

The first release-ready Dart package remains `0.1.0`.

That version was chosen because the SDK tracks ASCP protocol `0.1.0`, is ready for sustained downstream use, and should remain pre-`1.0` while both the protocol and downstream package boundaries are still intentionally early.

The package is released as one Dart package with explicit root and secondary libraries rather than split packages. That shape was preferred because the current surface is cohesive, consumers still get clear import boundaries, and splitting transport, replay, or validation packages now would create version coordination overhead before there is evidence that those seams need independent lifecycle management.

Patch releases should preserve the documented public library boundary. Additive helpers should prefer existing secondary libraries or a new explicit top-level library. Breaking cleanup before `1.0.0` should still preserve ASCP method names, event names, payload field names, and replay semantics unless upstream ASCP changes first.

## Verification

The current Dart executable surface was verified with:

```bash
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart run tool/check_package_boundary.dart
dart analyze
dart test
dart run example/foundation_decode.dart
dart run example/mock_server_client.dart
dart pub publish --dry-run
```

What these commands prove:

- dependency resolution succeeds against the declared Dart SDK range
- generated DTO and JSON code still match the authored Dart surface
- the public root and secondary library boundary stays explicit and examples avoid private `src` imports
- the analyzer accepts the exported package surface cleanly
- the typed client, replay helpers, validation hooks, and transport layer pass focused tests
- core model decoding and event-envelope examples still match upstream ASCP examples
- the stdio transport, typed client, and replay helpers can reach the upstream mock server end to end
- the package has enough pub-facing metadata and release files for a dry-run publish check

## Current Limits

- WebSocket transport shape exists and auth headers are wired, but end-to-end WebSocket host coverage is still limited to local transport tests
- validation hooks are callback-based; the Dart package does not yet embed the full upstream schema registry
- replay helpers classify stream boundaries explicitly, but they do not add persistence or reconnect state storage
- release checks are local commands rather than CI or registry-publishing automation

## After Dart Parity

The repository should move back to shared SDK maintenance after this branch:

- keep Dart and TypeScript surfaces aligned where upstream ASCP allows it
- add CI or release automation as a dedicated workflow branch instead of mixing it into SDK behavior
- keep package-boundary and mock-server integration checks comparable across TypeScript and Dart
- document any protocol ambiguities discovered here as upstream follow-up instead of redefining them in SDK code
