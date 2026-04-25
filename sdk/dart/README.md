# ASCP Dart SDK

This package is the Dart executable SDK for ASCP.

It preserves the foundation branch layout and now adds the runtime surface that downstream Dart or Flutter-adjacent consumers need without turning the package into a UI toolkit, daemon, or protocol-core fork.

For the branch-level rationale and handoff context, see:

- `../docs/branches/dart-sdk-foundation.md`
- `../docs/branches/dart-sdk-client.md`

## Install

Requirements:

- Dart SDK `>=3.8.0 <4.0.0`

From `sdk/dart/`:

```bash
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart analyze
dart test
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

## Verification

The current Dart executable surface was verified with:

```bash
dart run build_runner build --delete-conflicting-outputs
dart analyze
dart test
dart run example/mock_server_client.dart
```

What these commands prove:

- generated DTO and JSON code still match the authored Dart surface
- the analyzer accepts the exported package surface cleanly
- the typed client, replay helpers, validation hooks, and transport layer pass focused tests
- the stdio transport, typed client, and replay helpers can reach the upstream mock server end to end

## Current Limits

- WebSocket transport shape exists and auth headers are wired, but end-to-end WebSocket host coverage is still limited to local transport tests
- validation hooks are callback-based; the Dart package does not yet embed the full upstream schema registry
- replay helpers classify stream boundaries explicitly, but they do not add persistence or reconnect state storage
- the package remains one SDK package and does not yet have Dart-specific release-readiness automation comparable to the TypeScript package

## After Dart Parity

The repository should move back to shared SDK maintenance after this branch:

- keep Dart and TypeScript surfaces aligned where upstream ASCP allows it
- add Dart release-readiness and packaging polish only where it materially improves downstream adoption
- document any protocol ambiguities discovered here as upstream follow-up instead of redefining them in SDK code
