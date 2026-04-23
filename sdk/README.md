# ASCP SDK Workspace

This repository is the downstream SDK workspace for ASCP.

Its job is to turn the finished ASCP protocol assets from the parent repository into reusable language SDKs without reopening protocol-core scope by default.

## Current Priority

The current implementation order comes from the downstream roadmap:

1. TypeScript SDK
2. Dart SDK

The TypeScript SDK is the first active target because it unlocks local tooling, mock-server consumers, contract tests, and future daemon or adapter work without hand-written DTO duplication.

## Upstream Sources

This workspace depends on the finished protocol assets in the parent ASCP repository:

- [`../ASCP_Protocol_Detailed_Spec_v0_1.md`](../ASCP_Protocol_Detailed_Spec_v0_1.md)
- [`../ASCP_Protocol_PRD_and_Build_Guide.md`](../ASCP_Protocol_PRD_and_Build_Guide.md)
- [`../schema/`](../schema/)
- [`../spec/`](../spec/)
- [`../examples/`](../examples/)
- [`../conformance/`](../conformance/)
- [`../mock-server/README.md`](../mock-server/README.md)
- [`../reference-client/README.md`](../reference-client/README.md)

The SDK planning inputs live one level above the parent repository:

- [`../../ASCP_TypeScript_SDK_Implementation_Plan.md`](../../ASCP_TypeScript_SDK_Implementation_Plan.md)
- [`../../ASCP_Dart_SDK_Implementation_Plan.md`](../../ASCP_Dart_SDK_Implementation_Plan.md)
- [`../../ASCP_Next_Phase_Master_Roadmap.md`](../../ASCP_Next_Phase_Master_Roadmap.md)

## Workspace Rules

- keep this repository SDK-only
- keep TypeScript-first unless priorities are explicitly changed
- do not silently redefine ASCP behavior in SDK code
- prefer schema-led typing and validation
- keep transport replaceable
- preserve unknown extension fields unless strict behavior is explicitly requested

## Repository Files

- [`AGENTS.md`](./AGENTS.md): repository-specific workflow and scope rules
- [`plans.md`](./plans.md): active scoped task plan
- [`docs/status.md`](./docs/status.md): session-to-session checkpoint log
- [`docs/README.md`](./docs/README.md): documentation index
- [`docs/project-context-reference.md`](./docs/project-context-reference.md): high-level repository context for future sessions
- [`.agents/skills/`](./.agents/skills/): local SDK workflow and implementation skills

## Current State

This workspace now contains the TypeScript SDK foundation, validation, transport, and analytics slices under [`typescript/`](./typescript/).

The next logical step is to build the TypeScript typed client slice on its own branch, using the existing validation, transport, and analytics entry points instead of re-implementing request execution, diagnostics, or response parsing.
