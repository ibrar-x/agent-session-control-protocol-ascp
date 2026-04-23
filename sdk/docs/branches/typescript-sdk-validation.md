# TypeScript SDK Validation Branch Reference

This document captures the implementation context for `feature/typescript-sdk-validation`.

Use it when you need to understand how the current validation layer should be used, why it was designed this way, what it intentionally does not do yet, and what the transport branch should build on top of it.

## Branch Identity

- Branch: `feature/typescript-sdk-validation`
- Current repository state: implemented locally on the validation branch

## What This Branch Added

The validation branch added the first runtime behavior to `sdk/typescript/`.

It introduced:

- an exported `ascp-sdk-typescript/validation` entry point
- AJV draft 2020-12 setup with schema registration for the upstream ASCP schema set
- vendored schema snapshots under `typescript/src/validation/schemas/`
- package-relative runtime schema loading plus a build copy step into `dist/validation/schemas/`
- safe-parse, parse, and assert helpers for core entities, method responses, base event envelopes, and core event envelopes
- a structured `AscpValidationError` with issue-level path, keyword, schema-path, and parameter details
- runtime tests anchored to upstream examples and type-level tests for the validation API

## What It Intentionally Did Not Add

This branch did not implement:

- request execution helpers
- stdio or WebSocket transports
- replay helpers
- client wrappers
- integration tests against the upstream mock server
- protocol-core schema changes

Those remain later slices so the validation layer stays a narrow dependency for downstream transport and client work.

## Upstream Inputs That Shaped The Branch

The branch was built directly from these upstream inputs:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../schema/`
- `../../spec/methods.md`
- `../../spec/events.md`
- `../../examples/`
- `../../conformance/`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`

These inputs were used for different purposes:

- the implementation plan fixed AJV as the runtime validator and set validation ahead of transport
- the schemas defined the exact entity, response, and event contracts
- `spec/methods.md` and `spec/events.md` anchored the method and event names to the correct schema defs
- the examples supplied schema-valid success and failure fixtures for tests
- the conformance fixtures kept replay-safe and extension-safe expectations visible while designing the event boundary
- the detailed spec kept the helpers protocol-faithful instead of SDK-opinionated

## How To Use The Current Validation Surface

From `sdk/typescript/`:

```bash
npm install
npm run build
npm test
npm run test:types
```

Or run the full package verification:

```bash
npm run check
```

The runtime validation helpers are exported from:

- `ascp-sdk-typescript/validation`

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

Important behavior boundaries:

- `safeParseCoreEntity` validates a named upstream entity schema such as `Session` or `Artifact`
- `safeParseMethodResponse` validates a method-specific success or error response envelope
- `safeParseEventEnvelope` validates only the shared `EventEnvelope` shape
- `safeParseCoreEventEnvelope` validates a known core event type against its exact payload contract
- parse helpers throw `AscpValidationError`
- assert helpers expose the same checks as TypeScript assertions for downstream code

## Source Layout You Should Assume

The validation branch adds implementation in place under the reserved validation directory:

```text
typescript/
  src/
    validation/
      index.ts
      schema-registry.ts
      types.ts
      schemas/
        ascp-core.schema.json
        ascp-capabilities.schema.json
        ascp-methods.schema.json
        ascp-events.schema.json
        ascp-errors.schema.json
  scripts/
    copy-validation-schemas.mjs
  test/
    validation.test.ts
  test-d/
    validation-api.test-d.ts
```

Later branches should build on this layout rather than relocating schema assets or validation helpers.

## Thought Process Behind The Design

The main design goal was to make validation a reusable substrate for later transport and client code without turning the SDK into a hiding layer over ASCP.

That led to four decisions:

1. vendor exact upstream schemas into the package instead of reading the parent repository at runtime
2. register the full schema set once and compile validators lazily from schema refs
3. separate base event-envelope validation from core event payload validation so extension events stay representable
4. return issue-level validation details instead of a flattened string-only error

The branch stayed intentionally boring. It uses exact schema refs, explicit helper names, and a minimal API surface because later branches need reliable primitives more than convenience abstractions.

## Why This Approach Was Chosen

### Vendored schema snapshots instead of live parent-repo reads

The validation layer needs to ship as part of the installable package. Reading `../../schema/` directly would work only inside this workspace and would break for downstream consumers. Vendored snapshots plus the build copy step preserve the upstream JSON as visible source material while still producing a self-contained package.

### AJV registry plus schema refs instead of ad hoc object checks

The parent repository already defines exact JSON Schemas. Rewriting those contracts in custom validation code would duplicate protocol logic and create drift risk. AJV lets the SDK compile the existing contract surface directly and keeps future method or event additions additive.

### Separate `EventEnvelope` and core-event helpers instead of one catch-all event parser

ASCP permits extensions and unknown fields. A single strict event parser would either reject extension events incorrectly or blur the difference between validating the shared envelope and validating a core payload. The split keeps both use cases explicit:

- base envelope validation for extension-safe transport handling
- core-event validation when downstream code depends on exact ASCP payload semantics

### Structured issue objects instead of message-only failures

Later transport and client layers need actionable diagnostics. The validation error includes target, path, keyword, schema path, and params so downstream consumers can log or format failures without re-parsing AJV internals.

## Alternatives Considered And Rejected

### Load schemas directly from `../schema/` at runtime

Rejected because the published package cannot depend on the parent repository layout.

### Hand-write runtime validators beside the authored types

Rejected because it would duplicate the upstream schema contracts and invite divergence.

### Precompile validators into generated code during the build

Rejected for this slice because it would add more tooling and reduce the visibility of which upstream schema refs power the helpers. The current registry is simpler and sufficient for the package size.

### Validate every event only through a large union schema

Rejected because union-level failures are less actionable for exact core-event payload bugs and make extension handling less clear.

## Verification Evidence

This branch was verified with:

```bash
cd sdk/typescript
npm test -- validation.test.ts
npm run build
npm test
npm run test:types
npm run check
```

And repository-level patch hygiene was checked with:

```bash
cd sdk
git diff --check
```

What these commands prove:

- `npm test -- validation.test.ts` proved the new validation API passed the initial red-green fixtures for success and failure behavior
- `npm run build` proved the package compiles and ships the schema assets into `dist/`
- `npm test` proved the validation tests and the existing metadata tests pass together
- `npm run test:types` proved the validation API types compile cleanly with the existing public model surface
- `npm run check` proved the combined build, runtime tests, and type tests all pass in one command
- `git diff --check` proves the branch diff is free of whitespace and patch-format issues

## Known Limitations And Deferred Work

The validation branch still has deliberate limits:

- request envelopes are not validated yet through a public helper surface
- extension methods and extension events are not given dedicated namespaced validator helpers yet
- the helper API does not normalize transport failures or runtime errors beyond schema validation
- validators are compiled lazily in-process rather than pre-generated ahead of time
- integration against the upstream mock server remains for the transport and client branches

These are expected limits, not regressions. They keep the validation layer narrow and composable.

## What The Next Branch Should Assume

The next branch is:

- `feature/typescript-sdk-transport`

That branch can assume:

- `ascp-sdk-typescript/validation` exists and is the canonical runtime payload-checking surface
- method response validation does not need to be reimplemented inside transport adapters
- base `EventEnvelope` and exact core-event validation are already separated
- the vendored schema snapshot layout is part of the package and should be preserved unless there is a strong packaging reason to change it
- validation failures are represented as `AscpValidationError` with issue-level details

The transport branch should focus on request/subscription primitives and integrate these helpers instead of widening the validation API into transport policy.
