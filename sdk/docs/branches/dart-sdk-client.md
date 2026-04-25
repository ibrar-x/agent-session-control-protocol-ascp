# Dart SDK Transport, Client, And Replay Branch Reference

This document captures the implementation context for `feature/dart-sdk-client`.

Use it when you need to understand what the current Dart SDK surface provides, how to run it locally, why the API and transport choices were made, what was verified, what remains intentionally limited, and what the repository should do after the Dart package reaches parity with the planned executable scope.

## Branch Identity

- Branch: `feature/dart-sdk-client`
- Scope: Dart executable SDK surface only

## What This Branch Added

This branch replaced the foundation markers with the first executable Dart runtime surface.

It added:

- typed param and result models for the ASCP core method set
- a thin `AscpClient` that wraps every core ASCP method
- protocol-error mapping through `AscpProtocolException`
- a replaceable transport contract with stdio and WebSocket implementations
- transport-level auth hooks for stdio environment injection and WebSocket headers
- stream-based event access through `AscpTransport.events` and `AscpClient.events`
- replay request builders and subscription helpers for `from_seq`, `from_event_id`, and opaque cursor pass-through
- validation hooks for outgoing params, incoming method results, and event envelopes
- focused client, replay, transport, and validation tests
- a runnable mock-server example at `dart/example/mock_server_client.dart`

## What Stayed Out Of Scope

This branch did not add:

- Flutter UI concerns
- HTTP, SSE, or relay transport implementations
- bundled caching, persistence, or reconnect-state storage
- provider-specific auth flows
- protocol-core changes or Dart-specific field aliases

## How To Use It

From `sdk/dart/`:

```bash
dart pub get
dart run build_runner build --delete-conflicting-outputs
dart analyze
dart test
dart run example/mock_server_client.dart
```

Typical usage starts with a transport, then a client:

```dart
final transport = AscpStdioTransport(
  command: const <String>[
    'python3',
    '../mock-server/src/mock_server/cli.py',
  ],
  workingDirectory: '/path/to/repo/sdk',
);
final client = AscpClient(transport: transport);

await client.connect();
final capabilities = await client.getCapabilities();
final session = await client.getSession(
  const AscpSessionsGetParams(sessionId: 'sess_abc123'),
);
```

Replay stays explicit on top of `sessions.subscribe`:

```dart
final replaySubscription = await subscribeWithReplay(
  client: client,
  request: replayFromSeq(
    sessionId: 'sess_abc123',
    fromSeq: 34,
    includeSnapshot: true,
  ),
);
```

## Why The API Looks Like This

The branch was shaped by four constraints from the upstream ASCP assets and the Dart implementation plan:

1. the client should stay thin and method-faithful
2. transports should stay replaceable and own their own lifecycle
3. replay must remain explicit about snapshot, replay, and live boundaries
4. auth and validation should be additive hooks, not silent semantic rewrites

That led to a few concrete choices:

- `AscpClient` wraps each method directly instead of inventing a repository or session cache abstraction
- transports expose one shared event stream because the protocol stream exists at the transport boundary, not the session-cache boundary
- replay uses top-level helpers plus a dedicated subscription object so downstream consumers can see `sync.snapshot`, `sync.replayed`, and `sync.cursor_advanced` rather than having them flattened away
- validation is callback-based because the branch needed runtime hooks without prematurely committing the Dart package to a full embedded schema runtime
- auth remains transport-specific because the upstream auth spec defines hooks and scope behavior, not one cross-transport credential envelope

## Why This Was Preferred Over Alternatives

### Thin client over a richer repository-style surface

Rejected richer abstractions because they would have hidden ASCP request and replay semantics behind app-level convenience that this repository is explicitly supposed to avoid.

### Shared transport stream over per-method hidden listeners

Rejected hidden transport listeners because they make it harder to reason about replay ordering and session filtering. A shared stream keeps the package closer to the actual ASCP transport model.

### Explicit replay helper objects over auto-reconnect magic

Rejected auto-reconnect state machines because the upstream replay rules are important protocol behavior, not an implementation detail to bury.

### Hook-based validation over full embedded schema validation in this branch

Rejected a full schema runtime in this slice because the user request centered on the executable surface. Hook seams were enough to make validation pluggable without widening into a second validation branch inside Dart.

## Verification Evidence

This branch was verified with:

```bash
cd sdk/dart
dart run build_runner build --delete-conflicting-outputs
dart analyze
dart test
dart run example/mock_server_client.dart
```

What this proved:

- generated DTOs and JSON code still align with the authored Dart surface
- analyzer-clean exports and internal imports
- typed client wrappers, replay helpers, validation hooks, and auth hooks behave as expected in focused tests
- the stdio transport, typed client, and replay helper layer work end to end against the deterministic upstream mock server

## Known Limitations

- WebSocket support is transport-ready but still verified only through local transport tests rather than a long-lived upstream WebSocket host
- validation hooks are callback seams, not a full Dart schema registry
- replay helpers expose boundaries and cursors but do not persist reconnect state for the caller
- release-readiness automation for Dart is still lighter than the TypeScript package

## What The Repository Should Do Next

After this branch reaches parity, the repository should stop adding broad new Dart SDK behavior casually.

The next useful work should be one of:

- shared SDK maintenance and parity checks across TypeScript and Dart
- targeted Dart release-readiness and package polish where it materially improves downstream adoption
- upstream protocol clarification work when a real ambiguity was discovered here

The important boundary is that follow-up work should remain SDK-only and should not turn this package into a Flutter app layer or a protocol-core invention space.
