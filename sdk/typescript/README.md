# ASCP TypeScript SDK

This package is the first downstream SDK target for ASCP.

The current package state includes the foundation, validation, transport, analytics, and typed client slices.

For the full branch-level rationale and handoff context, see:

- `../docs/branches/typescript-sdk-foundation.md`
- `../docs/branches/typescript-sdk-validation.md`
- `../docs/branches/typescript-sdk-transport.md`
- `../docs/branches/typescript-sdk-analytics.md`
- `../docs/branches/typescript-sdk-client.md`

## Upstream Inputs

The package is built from the upstream ASCP assets:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../schema/`
- `../../spec/`
- `../../examples/`
- `../../conformance/`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`

## Package Layout

```text
typescript/
  src/
    models/
    methods/
    events/
    errors/
    analytics/
    validation/
    client/
    transport/
    replay/
    auth/
  test/
  test-d/
```

Public exports currently include:

- package root: metadata plus type exports
- `./validation`: runtime-safe parsing and assertion helpers
- `./analytics`: opt-in analytics event types, recorders, and remediation helpers
- `./transport`: replaceable request/subscription transports plus normalized transport errors
- `./client`: typed ASCP core method wrappers plus protocol error normalization
- `./models`
- `./methods`
- `./events`
- `./errors`

The `replay` and `auth` directories remain reserved for later slices so replay and auth work can extend the package without moving the root layout.

## Model Strategy

The foundation uses a schema-indexed authoring strategy instead of a committed code generator in this slice:

1. upstream JSON Schemas under `../schema/` remain the source of truth
2. upstream examples under `../examples/` anchor the authored request, response, and event naming
3. hand-authored barrel files in `src/models`, `src/methods`, `src/events`, and `src/errors` define the stable public surface
4. runtime validation can add schema assets without changing model import paths

This keeps protocol nouns aligned with upstream ASCP contracts while avoiding a fragile generator choice before the validation layer is in place.

## Validation Surface

The validation layer is published from `ascp-sdk-typescript/validation`.

Representative usage:

```ts
import {
  parseCoreEventEnvelope,
  safeParseCoreEntity,
  safeParseMethodResponse
} from "ascp-sdk-typescript/validation";

const sessionResult = safeParseCoreEntity("Session", payload);

if (!sessionResult.success) {
  console.error(sessionResult.error.message);
}

const responseResult = safeParseMethodResponse("sessions.list", responsePayload);

if (responseResult.success && "result" in responseResult.data) {
  console.log(responseResult.data.result.sessions);
}

const event = parseCoreEventEnvelope(eventPayload);
console.log(event.type);
```

What the validation helpers do:

- validate core entities such as `Session`, `Run`, `ApprovalRequest`, `Artifact`, and `DiffSummary`
- validate method response envelopes against the upstream per-method success or error schemas
- validate base `EventEnvelope` objects and exact core-event payloads separately
- return discriminated safe-parse results or throw `AscpValidationError` from the parse helpers

Validation errors are intentionally explicit. Each error includes:

- the target being validated
- the JSON path that failed
- the AJV keyword that failed
- the upstream schema path that triggered the failure

This keeps later transport and client code close to the protocol instead of hiding schema failures behind loose parsing.

## Schema Strategy

The package vendors the upstream ASCP schema files under `src/validation/schemas/`.

At runtime the validation layer loads those packaged schema snapshots relative to the installed module, registers them with AJV draft 2020-12 support, and compiles validators on demand. The build copies the schema JSON into `dist/validation/schemas/` so published package installs do not depend on the parent ASCP repository layout.

This strategy was chosen over reading the parent repository directly because the SDK package needs to remain installable outside this monorepo while still staying visibly schema-led.

## Analytics Surface

The analytics layer is published from `ascp-sdk-typescript/analytics`.

Representative usage:

```ts
import {
  createBufferedAnalyticsRecorder,
  describeTransportError
} from "ascp-sdk-typescript/analytics";
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";

const recorder = createBufferedAnalyticsRecorder();
const transport = new AscpStdioTransport({
  command: ["python3", "../mock-server/src/mock_server/cli.py"],
  analytics: recorder
});

await transport.connect();
await transport.request("capabilities.get");
await transport.close();

console.log(recorder.events.map((event) => event.name));
```

What the analytics helpers do:

- provide explicit recorder contracts instead of silent telemetry
- emit structured transport lifecycle events when a recorder is configured
- avoid capturing raw params, raw results, and arbitrary payload bodies by default
- expose remediation helpers for `AscpTransportError` and `AscpValidationError`

The current analytics design intentionally does not:

- send telemetry anywhere unless the consumer wires a recorder
- bundle a third-party analytics vendor
- replace the existing transport or validation error types
- guess at product-specific dashboards or alerting flows

## Transport Surface

The transport layer is published from `ascp-sdk-typescript/transport`.

Representative usage against the upstream mock server:

```ts
import {
  AscpStdioTransport,
  AscpTransportError
} from "ascp-sdk-typescript/transport";

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

for await (const event of events) {
  console.log(event.type);

  if (event.type === "sync.replayed") {
    break;
  }
}

await events.close();
await transport.close();
```

What the transport helpers do:

- keep connection logic replaceable through a shared `AscpTransport` contract
- validate method responses with `safeParseMethodResponse` before resolving `request`
- validate streamed messages as base `EventEnvelope` objects before broadcasting them to local subscribers
- normalize connection, framing, timeout, abort, and IO failures into `AscpTransportError`
- keep subscription handling transport-level only, so the later typed client branch can decide how to map `sessions.subscribe` and `sessions.unsubscribe`

The current transport design intentionally does not:

- wrap ASCP core methods in convenience client functions
- infer replay cursors beyond the core `from_seq` and `from_event_id` request params
- validate streamed events as exact core-event payloads by default, because extension-safe transport handling needs the shared envelope shape first

## Client Surface

The typed client layer is published from `ascp-sdk-typescript/client` and re-exported from the package root.

Representative usage against the upstream mock server:

```ts
import { AscpClient, AscpProtocolError } from "ascp-sdk-typescript/client";
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";

const transport = new AscpStdioTransport({
  command: ["python3", "../mock-server/src/mock_server/cli.py"]
});
const client = new AscpClient({ transport });

await client.connect();

try {
  const capabilities = await client.getCapabilities();
  const sessions = await client.listSessions({ limit: 25 });
  const subscription = client.events();

  await client.subscribe({
    session_id: sessions.sessions[0]?.id ?? "sess_abc123",
    include_snapshot: true,
    from_seq: 34
  });

  for await (const event of subscription) {
    console.log(event.type);
    break;
  }

  await subscription.close();
  console.log(capabilities.protocol_version);
} catch (error) {
  if (error instanceof AscpProtocolError) {
    console.error(error.code, error.correlationId);
  }
} finally {
  await client.close();
}
```

What the client helpers do:

- expose every ASCP core method as a typed wrapper on top of `AscpTransport.request`
- return the protocol `result` object directly on success
- preserve protocol field names in params and result types instead of introducing SDK-specific DTOs
- map ASCP error response envelopes into `AscpProtocolError`
- preserve transport errors such as `AscpTransportError` without wrapping them as protocol failures
- delegate event streaming to `client.events()` so replay helpers can build on the same transport stream later

The current client design intentionally does not:

- infer replay cursors or implement snapshot-plus-replay orchestration
- validate exact core-event payloads beyond the transport's base event envelope validation
- change ASCP method names, params, or result field names for convenience

## Commands

- `npm install`
- `npm run build`
- `npm test`
- `npm run test:types`
- `npm run check`

## Current Scope

Implemented in the foundation slice:

- package metadata and export map
- TypeScript compiler baseline
- Vitest baseline
- authored model, method, event, and error barrels
- opt-in analytics event types, recorder helpers, and remediation helpers
- AJV-backed validation registry
- packaged schema snapshot loading and build-copy support
- safe parse, parse, and assert helpers for entities, method responses, and events
- focused runtime and type-level validation tests
- a shared transport contract with `connect`, `close`, `request`, and `subscribe`
- a persistent stdio transport for line-delimited JSON-RPC hosts such as the upstream mock server
- a WebSocket transport with the same request/subscription contract for future host use
- normalized `AscpTransportError` handling for transport-level failures
- transport analytics hooks for connect, request, stream, and close lifecycle events
- baseline production package metadata for repository, homepage, bug reporting, and keywords
- focused runtime and type-level transport tests
- typed wrappers for every ASCP core method
- protocol error mapping through `AscpProtocolError`
- focused runtime and type-level client tests

Deferred to later slices:

- replay helpers
- higher-level integration flows that exercise the full typed client surface against the mock server
