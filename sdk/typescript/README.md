# ASCP TypeScript SDK

This package is the first downstream reference SDK for ASCP.

The current package state includes the foundation, validation, transport, analytics, typed client, replay, end-to-end examples/tests, and release-readiness slices.

For the full branch-level rationale and handoff context, see:

- `../docs/branches/typescript-sdk-foundation.md`
- `../docs/branches/typescript-sdk-validation.md`
- `../docs/branches/typescript-sdk-transport.md`
- `../docs/branches/typescript-sdk-analytics.md`
- `../docs/branches/typescript-sdk-client.md`
- `../docs/branches/typescript-sdk-replay.md`
- `../docs/branches/typescript-sdk-examples-tests.md`
- `../docs/branches/typescript-sdk-release-readiness.md`

## Install

Requirements:

- Node.js `>=22.0.0`

Install:

```bash
npm install ascp-sdk-typescript
```

Minimal consumer flow:

```ts
import { AscpClient } from "ascp-sdk-typescript";
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";

const client = new AscpClient({
  transport: new AscpStdioTransport({
    command: ["python3", "../mock-server/src/mock_server/cli.py"]
  })
});

await client.connect();
const capabilities = await client.getCapabilities();
console.log(capabilities.protocol_version);
await client.close();
```

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
  examples/
  test/
  test-d/
```

Release package boundaries:

- package root: package metadata, `AscpClient`, replay helpers, and core protocol types for the common consumer happy path
- `./transport`: replaceable request/subscription transports plus normalized transport errors
- `./validation`: runtime-safe parsing and assertion helpers
- `./analytics`: opt-in analytics event types, recorders, and remediation helpers
- `./client`: direct access to the typed ASCP core method layer
- `./replay`: direct access to replay request builders and replay subscriptions
- `./models`
- `./methods`
- `./events`
- `./errors`

The `auth` directory remains reserved for a later slice so auth work can extend the package without moving the root layout.

Boundary rationale:

- the root export stays focused on the downstream flow most consumers start with: create a transport, create a client, call typed methods, and optionally layer replay helpers on top
- `transport`, `validation`, and `analytics` stay on dedicated subpaths because they are lower-level or optional surfaces and should not blur the root happy path
- protocol DTO types remain visible and thin so consumers can still compare their usage directly with upstream ASCP schemas, examples, and conformance fixtures

## Versioning Policy

The first release-ready package remains at `0.1.0`.

That decision is intentional:

- it aligns the first downstream reference package with ASCP protocol `0.1.0`
- it signals that the package is ready for sustained downstream use while the protocol itself is still pre-`1.0`
- it leaves room for minor-version API tightening if the package surface needs correction before both protocol and SDK semantics stabilize at `1.0.0`

Compatibility expectations for this package:

- patch releases should preserve the documented root-versus-subpath package boundary
- additive helpers should prefer new subpaths or additive exports over shape changes
- protocol field names and method names should continue matching upstream ASCP instead of being translated into SDK-specific aliases

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

## Replay Surface

The replay layer is published from `ascp-sdk-typescript/replay` and re-exported from the package root.

Representative usage:

```ts
import {
  replayFromSeq,
  subscribeWithReplay
} from "ascp-sdk-typescript/replay";
import { AscpClient } from "ascp-sdk-typescript/client";
import { AscpStdioTransport } from "ascp-sdk-typescript/transport";

const client = new AscpClient({
  transport: new AscpStdioTransport({
    command: ["python3", "../mock-server/src/mock_server/cli.py"]
  })
});

await client.connect();

const subscription = await subscribeWithReplay(
  client,
  replayFromSeq({
    session_id: "sess_abc123",
    from_seq: 205,
    include_snapshot: true
  })
);

for await (const item of subscription) {
  console.log(item.kind, item.event.type);

  if (item.kind === "cursor_advanced") {
    console.log(item.cursor);
  }

  if (item.kind === "live_event") {
    break;
  }
}

await subscription.close();
await client.close();
```

What the replay helpers do:

- provide explicit request builders for `from_seq` and `from_event_id`
- keep opaque cursor handling additive through `replayWithOpaqueCursor(...)`
- classify the stream into `snapshot`, `replay_event`, `replay_complete`, `live_event`, and `cursor_advanced`
- preserve the original `EventEnvelope` on every stream item
- track host-provided opaque cursor values only when `sync.cursor_advanced` is emitted
- unsubscribe cleanly through `sessions.unsubscribe` when the replay subscription closes

The current replay design intentionally does not:

- add a synthetic "recovery state" object that hides protocol events
- infer opaque cursor values from `seq`
- change transport subscription behavior below the client layer

## End-To-End Examples

The examples under `typescript/examples/` prove the package end to end against the upstream mock server without hand-written response DTOs or event-envelope wrappers in consumer code.

Run them from `sdk/typescript/` after building once:

```bash
npm install
npm run build
npm run example:subscribe-replay
npm run example:approval
npm run example:artifact-diff
```

The scripts are:

- `examples/subscribe-replay.ts`: launches the mock server over stdio, uses `AscpClient` plus `subscribeWithReplay(...)`, captures the snapshot and replay boundary, then sends live input and shows the post-replay event flow
- `examples/approval-flow.ts`: reads pending approvals, resolves the seeded approval through `respondApproval(...)`, and captures the emitted approval lifecycle events from the transport stream
- `examples/artifact-diff.ts`: lists artifacts for the seeded session, fetches the diff artifact metadata, and reads the related diff summary through typed client calls

The examples stay deliberately thin:

- imports use the package entry points (`ascp-sdk-typescript/client`, `ascp-sdk-typescript/replay`, and `ascp-sdk-typescript/transport`)
- request params keep upstream ASCP field names
- result objects and event envelopes are consumed directly instead of being remapped into SDK-specific DTO aliases
- replay boundaries remain explicit through `snapshot`, `replay_event`, `replay_complete`, `live_event`, and `cursor_advanced`

That structure makes it easy to compare runtime behavior with the upstream protocol examples, conformance fixtures, mock server, and reference client.

## Integration Tests

The end-to-end integration suite lives in `test/examples.integration.test.ts`.

It launches the parent mock server over stdio and proves:

- typed client method calls for discovery, sessions, approvals, artifacts, and diffs
- replay subscriptions against the deterministic `sync.snapshot`, `sync.replayed`, and `sync.cursor_advanced` flow
- post-replay live events driven by `sessions.send_input`
- standalone example entrypoints that run as scripts and produce deterministic summaries

Run it directly with:

```bash
npm run test:integration
```

## Commands

- `npm install`
- `npm run build`
- `npm test`
- `npm run test:integration`
- `npm run test:types`
- `npm run test:package-types`
- `npm run example:subscribe-replay`
- `npm run example:approval`
- `npm run example:artifact-diff`
- `npm run check`
- `npm run check:release`

## Release Validation Checklist

Use this checklist before publishing or treating the package as the reference release:

- `npm run build`
- `npm test`
- `npm run test:integration`
- `npm run test:types`
- `npm run test:package-types`
- `npm run check`
- `npm run check:release`

`npm run check:release` adds the release-specific evidence on top of the normal package checks:

- package self-reference type resolution through the published export map
- runtime smoke verification of the root and subpath export boundaries
- `npm pack --dry-run` tarball inspection for packaged docs and distributable assets

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
- replay request builders and cursor-preserving replay subscriptions
- focused runtime and type-level replay tests
- standalone example scripts for subscribe/replay, approvals, and artifact/diff flows
- end-to-end integration tests against the upstream mock server

Deferred to later slices:

- dedicated auth hooks
- publish automation beyond the documented manual release checks
- richer extension-specific event parsing for consumers that want stricter streamed payload classification than the base transport layer provides
