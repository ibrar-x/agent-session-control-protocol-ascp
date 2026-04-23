# TypeScript SDK Foundation Prompt

Use this prompt when starting the first implementation slice for the TypeScript SDK.

## Read First

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. `../../../ASCP_Protocol_Detailed_Spec_v0_1.md`
5. `../../../schema/`
6. `../../../examples/`
7. `../../../../ASCP_TypeScript_SDK_Implementation_Plan.md`
8. `../project-context-reference.md`

## Feature Boundary

This feature is only for the TypeScript SDK foundation layer.

Included:

- package scaffold under `typescript/`
- package metadata and scripts
- initial source layout
- public export strategy
- typed model strategy based on upstream schema files
- minimal type tests or generation checks if needed
- README updates for the package

Out of scope:

- transport implementations
- full typed client methods
- replay helpers
- integration tests beyond what is needed to prove the scaffold

## Goal

Produce a clean TypeScript package foundation that makes the model and export strategy explicit and keeps future validation and transport work easy to add.

## Acceptance Focus

- the package structure matches the implementation plan
- the model strategy is documented
- the public export surface is clear
- future validation and transport work does not need to restructure the package immediately
