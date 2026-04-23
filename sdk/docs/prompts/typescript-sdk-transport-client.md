# TypeScript SDK Transport And Client Prompt

Use this prompt when the TypeScript foundation and validation layers exist and the next workstream is executable SDK behavior.

## Read First

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. `../../../spec/methods.md`
5. `../../../spec/replay.md`
6. `../../../mock-server/README.md`
7. `../../../reference-client/README.md`
8. `../../../../ASCP_TypeScript_SDK_Implementation_Plan.md`

## Feature Boundary

This feature is only for transport and typed client work.

Included:

- stdio transport for mock-server integration
- WebSocket transport for future host use
- normalized request, response, and subscription interfaces
- typed wrappers for core methods
- error normalization aligned to upstream error semantics

Out of scope:

- Dart work
- host daemon behavior
- adapter logic
- product-specific cache or UI abstractions

## Goal

Make the TypeScript SDK usable against the upstream mock server and suitable for later daemon or adapter consumers without baking in product assumptions.

## Acceptance Focus

- the mock server can be exercised through the SDK
- core methods are exposed through typed wrappers
- transport remains replaceable
- replay and subscription behavior remain protocol-faithful

## Documentation Requirements

Before closing the branch, document the transport and client work in enough detail that future contributors can use the branch output and understand the tradeoffs behind it.

Make sure the branch documentation covers:

- how to instantiate and use the current transport and client surface against the mock server
- how request, response, subscription, and error flows are expected to work in this branch
- the thought process behind the transport abstraction, method wrapper design, and error normalization choices
- why the chosen transport/client shape was used instead of tighter coupling to one runtime, one transport, or one product workflow
- which upstream specs, mock-server behavior, replay rules, and reference-client patterns informed the implementation
- what verification commands or integration checks were run and what they prove
- known limitations, unsupported paths, and what replay or approval work is still deferred
- what the next branch can extend safely without breaking the current public surface
