# TypeScript SDK Validation Prompt

Use this prompt when the TypeScript package scaffold exists and the next task is safe parsing and schema-backed validation.

## Read First

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. `../../../schema/`
5. `../../../spec/`
6. `../../../examples/`
7. `../../../conformance/`
8. `../../../../ASCP_TypeScript_SDK_Implementation_Plan.md`

## Feature Boundary

This feature is only for the TypeScript validation layer.

Included:

- schema loading or embedding strategy
- AJV validator setup
- validation helpers for models, method responses, and event envelopes
- useful validation error formatting
- unit tests for success and failure behavior

Out of scope:

- transport implementations beyond local test stubs
- full client wrappers
- replay helper ergonomics beyond validation needs

## Goal

Make the TypeScript SDK capable of parsing upstream ASCP payloads safely and reporting validation failures clearly.

## Acceptance Focus

- core entities validate against upstream schemas
- event envelopes validate against upstream event schemas
- response validation errors are actionable
- tests prove success and failure behavior

## Documentation Requirements

Before closing the branch, document the validation layer in enough detail that the next contributor understands how to use it, why it is shaped that way, and where its boundaries are.

Make sure the branch documentation covers:

- how to load or invoke the validation surface from the current branch
- how model, response, and event validation are expected to be used by downstream consumers
- the thought process behind the schema-loading strategy, validator structure, and error formatting
- why the chosen validation approach was used instead of plausible alternatives such as looser parsing, ad hoc checks, or a different schema runtime
- which upstream schema, spec, example, and conformance assets drove the implementation decisions
- what commands verify the validation behavior and which success and failure paths they cover
- known limits, strictness choices, extension-handling behavior, and deferred concerns for later branches
- what the next branch can assume about the validation API and package layout
