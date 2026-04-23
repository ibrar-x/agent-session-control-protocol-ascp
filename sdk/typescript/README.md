# ASCP TypeScript SDK

This package is the first downstream SDK target for ASCP.

The current package state includes the foundation slice plus the validation layer.

For the full branch-level rationale and handoff context, see:

- `../docs/branches/typescript-sdk-foundation.md`
- `../docs/branches/typescript-sdk-validation.md`

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
- `./models`
- `./methods`
- `./events`
- `./errors`

The `client`, `transport`, `replay`, and `auth` directories remain reserved for later slices so transport and client work can extend the package without moving the root layout.

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
- AJV-backed validation registry
- packaged schema snapshot loading and build-copy support
- safe parse, parse, and assert helpers for entities, method responses, and events
- focused runtime and type-level validation tests

Deferred to later slices:

- stdio and WebSocket transports
- typed client wrappers
- replay helpers
- integration tests against the mock server
