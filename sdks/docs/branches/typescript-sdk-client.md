# TypeScript SDK Client Branch Reference

This document captures the implementation context for `feature/typescript-sdk-client`.

Use it when you need to understand how the typed client surface should be used, why it stays thin over transport and validation, what it intentionally does not do yet, and what the replay branch should inherit.

## Branch Identity

- Branch: `feature/typescript-sdk-client`
- Current repository state: implemented locally on the client branch

## What This Branch Added

The client branch added a typed ASCP method surface to `sdk/typescript/`.

It introduced:

- an exported `ascp-sdk-typescript/client` entry point
- `AscpClient` and `createAscpClient`
- wrappers for all 16 ASCP core methods from `spec/methods.md`
- `defineAscpParams` for consumers who want a small typed helper while keeping protocol field names
- `AscpProtocolError` for ASCP error response envelopes
- root package exports for the client surface
- focused runtime tests for wrapper dispatch, result unwrapping, option pass-through, error mapping, and event/lifecycle delegation
- type tests for public client imports and method return types

## What It Intentionally Did Not Add

This branch did not implement:

- replay cursor carry-forward helpers
- snapshot-plus-replay orchestration
- new transports or changes to stdio/WebSocket framing
- protocol-core schema or method changes
- runtime adapter, daemon, product UI, or Dart SDK behavior

Those remain out of scope so the client layer is a typed convenience surface, not a higher-level product workflow.

## Upstream Inputs That Shaped The Branch

The branch was built from these inputs:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../spec/methods.md`
- `../../examples/responses/`
- `../../examples/errors/`
- `../branches/typescript-sdk-transport.md`
- `../branches/typescript-sdk-analytics.md`

These inputs fixed the branch boundary:

- `spec/methods.md` supplied the exact core method catalog and error-response behavior
- response and error examples confirmed that wrappers should unwrap `result` and preserve ASCP error objects
- the transport branch established that JSON-RPC framing and schema-backed response validation already belong below the client
- the analytics branch established that observability should remain opt-in and transport-driven for this slice
- the TypeScript implementation plan named typed methods and normalized error mapping as the client phase outputs

## How To Use The Client Surface

From `sdk/typescript/`:

```bash
npm install
npm run build
npm test -- client.test.ts
npm run test:types
```

The public client entry point is:

- `ascp-sdk-typescript/client`

Representative usage:

```ts
import { AscpClient, AscpProtocolError } from "ascp-sdk-typescript/client";
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";

const client = new AscpClient({
  transport: new AscpStdioTransport({
    command: ["python3", "../mock-server/src/mock_server/cli.py"]
  })
});

await client.connect();

try {
  const capabilities = await client.getCapabilities();
  const sessions = await client.listSessions({ limit: 25 });

  await client.subscribe({
    session_id: sessions.sessions[0]?.id ?? "sess_abc123",
    include_snapshot: true
  });

  console.log(capabilities.protocol_version);
} catch (error) {
  if (error instanceof AscpProtocolError) {
    console.error(error.method, error.code, error.correlationId);
  }
} finally {
  await client.close();
}
```

The wrapper methods are:

- `getCapabilities()`
- `getHost()`
- `listRuntimes(params?)`
- `listSessions(params?)`
- `getSession(params)`
- `startSession(params)`
- `resumeSession(params)`
- `stopSession(params)`
- `sendInput(params)`
- `subscribe(params)`
- `unsubscribe(params)`
- `listApprovals(params?)`
- `respondApproval(params)`
- `listArtifacts(params)`
- `getArtifact(params)`
- `getDiff(params)`

## Wrapper And Error Design

The client wraps `AscpTransport.request` and returns the ASCP success `result` object directly. It does not return the JSON-RPC envelope on success because the envelope exists to correlate transport requests; downstream SDK consumers usually need the protocol result.

The client preserves ASCP params and result field names. For example, `sendInput` accepts `session_id`, `input`, `input_kind`, and `metadata`, matching the method contract instead of converting to camelCase DTOs. This keeps generated examples, validation errors, and upstream schema paths easy to compare.

ASCP error responses are mapped to `AscpProtocolError`. The error preserves:

- method name
- original error object
- original error response envelope
- code
- retryability
- correlation id

Transport failures remain `AscpTransportError`. This separation matters because a host returning `UNAUTHORIZED` is a valid ASCP response, while a broken socket or malformed frame is a transport problem.

## Alternatives Rejected

### Return JSON-RPC envelopes from every wrapper

Rejected because it pushes envelope handling into every consumer and makes the typed client little more than a renamed transport. The envelope is still available for protocol errors through `AscpProtocolError.response`.

### Convert params and results to SDK-specific camelCase objects

Rejected because it would hide ASCP semantics, complicate schema validation output, and make examples harder to compare against upstream fixtures.

### Merge replay helpers into `subscribe`

Rejected because replay is its own branch. This branch sends the protocol `sessions.subscribe` request and exposes the raw event stream through `events()`, leaving cursor policy and resubscribe behavior for replay-specific helpers.

### Wrap transport errors as protocol errors

Rejected because protocol errors and transport failures have different causes and remediation paths. Consumers need to know whether a host rejected a valid request or whether the connection failed before a valid response existed.

## Verification Evidence

The branch was verified with:

- `npm test -- client.test.ts`
- `npm run test:types`
- `npm run build`
- `npm test`
- `npm run check`
- `git diff --check`

The focused client test proves:

- every core method has a wrapper
- wrapper methods dispatch the exact method names from `ASCP_CORE_METHOD_NAMES`
- params and request options pass through to transport
- success responses unwrap to result objects
- error responses throw `AscpProtocolError`
- connection lifecycle and event subscriptions remain delegated to transport

## Limits And Handoff

Known limits:

- replay helpers are still deferred
- exact streamed core-event payload validation remains outside the client branch
- integration examples that exercise full user workflows remain deferred to the examples/tests branch

The replay branch should build on:

- `AscpClient.subscribe`
- `AscpClient.unsubscribe`
- `AscpClient.events`
- `AscpProtocolError`
- the existing transport analytics and validation behavior

It should not change existing wrapper result shapes.
