# ASCP TypeScript SDK

This package is the first downstream SDK target for ASCP.

The foundation slice establishes the package shape, export surface, and schema-led model strategy without widening into transport, replay, validation, or typed client implementation yet.

## Upstream Inputs

The package is built from the upstream ASCP assets:

- `../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
- `../../schema/`
- `../../examples/`
- `../../ASCP_Protocol_Detailed_Spec_v0_1.md`

## Package Layout

```text
typescript/
  src/
    models/
    methods/
    events/
    errors/
    client/
    transport/
    validation/
    replay/
    auth/
  test/
  test-d/
```

Only the model-facing barrels are exported publicly in this slice:

- package root: metadata plus type exports
- `./models`
- `./methods`
- `./events`
- `./errors`

The reserved `client`, `transport`, `validation`, `replay`, and `auth` directories exist now so later work can extend the package without moving the root layout.

## Model Strategy

The foundation uses a schema-indexed authoring strategy instead of a committed code generator in this slice:

1. upstream JSON Schemas under `../schema/` remain the source of truth
2. upstream examples under `../examples/` anchor the authored request, response, and event naming
3. hand-authored barrel files in `src/models`, `src/methods`, `src/events`, and `src/errors` define the stable public surface
4. later validation work can add runtime schema assets without changing model import paths

This keeps protocol nouns aligned with upstream ASCP contracts while avoiding a fragile generator choice before the validation layer is in place.

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
- reserved source directories for later validation, transport, replay, and auth work

Deferred to later slices:

- AJV-backed validation
- stdio and WebSocket transports
- typed client wrappers
- replay helpers
- integration tests against the mock server
