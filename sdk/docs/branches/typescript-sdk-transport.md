# TypeScript SDK Transport Branch Reference

This document captures the implementation context for `feature/typescript-sdk-transport`.

Use it when you need to understand how the current transport layer should be used, why it was designed this way, what it intentionally does not do yet, and what the typed client branch should build on top of it.

## Branch Identity

- Branch: `feature/typescript-sdk-transport`
- Current repository state: implemented locally on the transport branch

## What This Branch Added

The transport branch added the first replaceable execution surface to `sdk/typescript/`.

It introduced:

- an exported `ascp-sdk-typescript/transport` entry point
- a shared `AscpTransport` contract with `connect`, `close`, `request`, and local `subscribe`
- a persistent stdio transport for line-delimited JSON-RPC hosts such as the upstream mock server
- a WebSocket transport that follows the same request/subscription contract for future host use
- base event-envelope validation for streamed messages and method-response validation for request results
- normalized `AscpTransportError` handling for connection, framing, timeout, abort, configuration, and IO failures
- focused runtime tests for stdio mock-server reachability, streamed event delivery, malformed output handling, WebSocket parity, and connection-failure normalization
- a type-level transport API test that locks the generic request and subscription surface

## What It Intentionally Did Not Add

This branch did not implement:

- typed wrappers for the ASCP method catalog
- replay convenience helpers beyond raw `sessions.subscribe` request support
- auth policy abstractions or credential refresh logic
- exact core-event payload parsing on the transport stream by default
- protocol-core schema or spec changes

Those remain later slices so the transport layer stays transport-first rather than client-opinionated.

## Upstream Inputs That Shaped The Branch

The branch was built directly from these upstream inputs:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../spec/methods.md`
- `../../spec/events.md`
- `../../spec/replay.md`
- `../../mock-server/README.md`
- `../../mock-server/src/mock_server/cli.py`
- `../../reference-client/README.md`
- `../../reference-client/src/reference_client/stdio_transport.py`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`

These inputs were used for different purposes:

- the implementation plan fixed stdio plus WebSocket as the transport targets and kept transport ahead of the typed client surface
- `spec/methods.md` locked the method names, params, and response envelopes that `request` validates
- `spec/events.md` and `spec/replay.md` clarified that transport should treat streamed payloads as `EventEnvelope` objects first and should not invent cursor semantics beyond the frozen core fields
- the mock-server README and CLI defined the line-oriented stdio behavior that the persistent child-process transport had to support
- the reference client demonstrated a thin request-plus-emitted-events split that could be adapted into a reusable TypeScript contract without dragging Python client wrappers into this branch
- the detailed spec kept the branch aligned with JSON-RPC request/response rules and replay-safe streaming behavior

## How To Use The Current Transport Surface

From `sdk/typescript/`:

```bash
npm install
npm run build
npm test -- transport.test.ts
npm run test:types
```

Or run the full package verification:

```bash
npm run check
```

The runtime transport helpers are exported from:

- `ascp-sdk-typescript/transport`

Representative usage against the upstream mock server:

```ts
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";

const transport = new AscpStdioTransport({
  command: ["python3", "../mock-server/src/mock_server/cli.py"]
});

await transport.connect();

const events = transport.subscribe();
const capabilities = await transport.request("capabilities.get");
const subscribeResponse = await transport.request("sessions.subscribe", {
  session_id: "sess_abc123",
  include_snapshot: true,
  from_seq: 34
});

if ("result" in capabilities) {
  console.log(capabilities.result.host.id);
}

for await (const event of events) {
  console.log(event.type);

  if (event.type === "sync.replayed") {
    break;
  }
}

await events.close();
await transport.close();
```

Important behavior boundaries:

- `request` validates the method-specific success or error envelope before it resolves
- `subscribe` attaches a local async-iterable listener to the transport stream; it does not itself call `sessions.subscribe`
- streamed events are validated as base `EventEnvelope` objects so extension-safe transports do not reject unknown core-adjacent event types prematurely
- transport-level failures reject or terminate with `AscpTransportError`
- protocol-level method errors remain ASCP error responses and are returned by `request` instead of being remapped into transport failures

## Source Layout You Should Assume

The transport branch adds implementation in place under the reserved transport directory:

```text
typescript/
  src/
    transport/
      async-queue.ts
      base.ts
      errors.ts
      index.ts
      stdio.ts
      types.ts
      websocket.ts
  test/
    transport.test.ts
  test-d/
    transport-api.test-d.ts
```

Later branches should build on this layout rather than relocating transport primitives or reintroducing transport-specific validation logic elsewhere.

## Thought Process Behind The Design

The main design goal was to make the SDK executable against real ASCP surfaces without accidentally turning the transport branch into the client branch.

That led to four decisions:

1. make the shared surface transport-level rather than method-wrapper-level
2. use method-response validation on `request`, but only base event-envelope validation on the event stream
3. keep subscriptions local to the transport and let the later client branch decide how `sessions.subscribe` and `sessions.unsubscribe` should wrap them
4. normalize transport failures separately from protocol error responses

The branch stayed intentionally boring. It uses explicit JSON-RPC requests, a persistent line-oriented child process for stdio, a separate WebSocket adapter, and a small error vocabulary because later client work needs dependable primitives more than convenience methods.

## Why This Approach Was Chosen

### Shared transport contract instead of typed method wrappers in the same branch

The roadmap and implementation plan split transport from the typed client surface. Folding both layers together here would have hidden whether problems were caused by transport behavior, validation, or wrapper logic. The current `AscpTransport` contract keeps that seam visible.

### Persistent stdio child process instead of spawning per request

The upstream mock server streams events after the subscribe response on the same stdio connection. A per-request subprocess approach would make replay and live event continuation impossible. A long-lived child process matches the protocol shape and the reference-client proof path.

### Base `EventEnvelope` validation instead of exact core-event validation in transport

Transport code needs to remain extension-safe. Exact event-payload parsing belongs in higher-level consumers that know whether they want only core events or namespaced extensions. The transport layer still validates the shared event envelope so malformed stream messages fail fast.

### Normalized transport errors instead of remapping protocol errors into exceptions

ASCP already defines method error responses. The transport layer should not hide those under a generic exception type. `AscpTransportError` is reserved for connection, framing, timeout, abort, configuration, and IO failures, while protocol errors still return through the normal ASCP response envelope.

## Alternatives Considered And Rejected

### Make `subscribe` call `sessions.subscribe` directly

Rejected because it couples the transport branch to ASCP client policy and blurs the distinction between the raw stream surface and the later typed client.

### Validate streamed events with `safeParseCoreEventEnvelope` by default

Rejected because extension-safe transports need to carry unknown event types as long as the shared envelope shape is valid.

### Reuse one transport class with conditional stdio versus WebSocket branches

Rejected because the connection lifecycle, framing, and failure modes are different enough that a shared base plus separate adapters is easier to reason about and extend.

### Treat protocol error responses as thrown transport failures

Rejected because ASCP error responses are first-class protocol material, not a transport malfunction.

## Verification Evidence

This branch was verified with:

```bash
cd sdk/typescript
npm test -- transport.test.ts
npm run build
npm run test:types
npm test
npm run check
```

And repository-level patch hygiene was checked with:

```bash
cd sdk
git diff --check
```

What these commands prove:

- `npm test -- transport.test.ts` proved the new transport surface works against the upstream mock server over stdio, delivers streamed events, normalizes malformed output, and supports the WebSocket adapter contract
- `npm run build` proved the package compiles with the new transport source files
- `npm run test:types` proved the generic request and subscription API types compile cleanly
- `npm test` proved the transport tests pass alongside the existing metadata and validation coverage
- `npm run check` proved the combined build, runtime tests, and type tests all pass in one command
- `git diff --check` proves the branch diff is free of whitespace and patch-format issues

## Known Limitations And Deferred Work

The transport branch still has deliberate limits:

- there is no typed client wrapper surface yet for the core ASCP methods
- subscriptions broadcast all validated event envelopes; they do not yet provide higher-level replay helpers or session filtering conveniences
- there is no HTTP JSON-RPC or SSE transport adapter in this slice
- auth headers are supported only through raw WebSocket options today; richer auth hook ergonomics remain later work
- exact core-event payload parsing is still the responsibility of downstream validation consumers, not the transport itself

These are expected limits, not regressions. They keep the branch transport-focused and suitable for extension by the typed client layer.

## What The Next Branch Should Assume

The next branch is:

- `feature/typescript-sdk-client`

That branch can assume:

- `ascp-sdk-typescript/transport` exists and is the canonical request/subscription transport substrate
- `request` returns validated success or error response envelopes and does not need to be reimplemented inside client wrappers
- transport failures are already normalized as `AscpTransportError`
- stdio integration against the upstream mock server is already proven at the transport level
- exact core-event payload parsing and method-level wrapper ergonomics still remain open for the client and replay branches

The typed client branch should focus on method wrappers, request ergonomics, and protocol-error handling on top of this surface instead of widening transport responsibilities.
