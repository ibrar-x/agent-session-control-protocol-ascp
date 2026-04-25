# SDK Docs Index

This index keeps the SDK workspace navigable without relying on hidden chat context.

## Upstream ASCP Sources

- [`../../ASCP_Protocol_Detailed_Spec_v0_1.md`](../../ASCP_Protocol_Detailed_Spec_v0_1.md): exact ASCP contracts, payloads, replay rules, compatibility behavior, and error semantics
- [`../../ASCP_Protocol_PRD_and_Build_Guide.md`](../../ASCP_Protocol_PRD_and_Build_Guide.md): protocol scope, sequencing, and repository intent
- [`../../schema/`](../../schema/): canonical JSON Schemas for DTO generation and validation
- [`../../spec/`](../../spec/): normative method, event, replay, auth, extension, and compatibility specs
- [`../../examples/`](../../examples/): schema-valid example requests, responses, errors, and events
- [`../../conformance/`](../../conformance/): fixtures and validators that back compatibility claims
- [`../../mock-server/README.md`](../../mock-server/README.md): deterministic executable surface for SDK integration work
- [`../../reference-client/README.md`](../../reference-client/README.md): downstream proof client and transport reference

## SDK Planning Inputs

- [`../../../ASCP_TypeScript_SDK_Implementation_Plan.md`](../../../ASCP_TypeScript_SDK_Implementation_Plan.md): TypeScript SDK scope, architecture, and phased plan
- [`../../../ASCP_Dart_SDK_Implementation_Plan.md`](../../../ASCP_Dart_SDK_Implementation_Plan.md): Dart SDK scope and later-phase package direction
- [`../../../ASCP_Next_Phase_Master_Roadmap.md`](../../../ASCP_Next_Phase_Master_Roadmap.md): downstream work order and feature sequencing

## Repository Operating Files

- [`../AGENTS.md`](../AGENTS.md): repository rules for intake, branch scoping, checkpointing, and drift control
- [`../plans.md`](../plans.md): active branch plan
- [`status.md`](status.md): checkpoint log across completed tasks
- [`repo-operating-system.md`](repo-operating-system.md): SDK workspace workflow summary
- [`project-context-reference.md`](project-context-reference.md): SDK workspace summary, scope, and continuation guidance
- [`sdk-build-roadmap.md`](sdk-build-roadmap.md): end-to-end build sequence for the TypeScript-first and Dart SDK workstreams, with compact prompts for each phase

## Branch References

- [`branches/typescript-sdk-foundation.md`](branches/typescript-sdk-foundation.md): detailed usage, rationale, alternatives, verification evidence, limitations, and handoff notes for the completed TypeScript foundation branch
- [`branches/typescript-sdk-validation.md`](branches/typescript-sdk-validation.md): detailed usage, schema strategy, validation API rationale, verification evidence, limitations, and handoff notes for the TypeScript validation branch
- [`branches/typescript-sdk-transport.md`](branches/typescript-sdk-transport.md): detailed usage, transport-contract rationale, verification evidence, limitations, and handoff notes for the TypeScript transport branch
- [`branches/typescript-sdk-analytics.md`](branches/typescript-sdk-analytics.md): detailed usage, opt-in analytics rationale, production-hardening notes, verification evidence, limitations, and handoff notes for the TypeScript analytics branch
- [`branches/typescript-sdk-client.md`](branches/typescript-sdk-client.md): detailed usage, wrapper-shape rationale, protocol-error mapping notes, verification evidence, limitations, and handoff notes for the TypeScript client branch
- [`branches/typescript-sdk-replay.md`](branches/typescript-sdk-replay.md): detailed usage, replay-shape rationale, cursor-preservation notes, verification evidence, limitations, and handoff notes for the TypeScript replay branch
- [`branches/typescript-sdk-examples-tests.md`](branches/typescript-sdk-examples-tests.md): detailed usage, end-to-end proof scope, example-structure rationale, verification evidence, limitations, and handoff notes for the TypeScript examples/tests branch

## Prompt Starters

- [`prompts/README.md`](prompts/README.md): prompt pack overview
- [`prompts/typescript-sdk-foundation.md`](prompts/typescript-sdk-foundation.md)
- [`prompts/typescript-sdk-validation.md`](prompts/typescript-sdk-validation.md)
- [`prompts/typescript-sdk-transport-client.md`](prompts/typescript-sdk-transport-client.md)
- [`prompts/dart-sdk-planning.md`](prompts/dart-sdk-planning.md)

## Language Package Roots

- [`../typescript/README.md`](../typescript/README.md): TypeScript package intent and expected scope
- [`../dart/README.md`](../dart/README.md): Dart package placeholder and sequencing note

## Local Skills

- [`../.agents/skills/ascp-sdk-task-operating-system/SKILL.md`](../.agents/skills/ascp-sdk-task-operating-system/SKILL.md)
- [`../.agents/skills/ascp-sdk-documentation-discipline/SKILL.md`](../.agents/skills/ascp-sdk-documentation-discipline/SKILL.md)
- [`../.agents/skills/ascp-typescript-sdk-foundation/SKILL.md`](../.agents/skills/ascp-typescript-sdk-foundation/SKILL.md)
- [`../.agents/skills/ascp-typescript-sdk-transport-client/SKILL.md`](../.agents/skills/ascp-typescript-sdk-transport-client/SKILL.md)
- [`../.agents/skills/ascp-typescript-sdk-validation-replay/SKILL.md`](../.agents/skills/ascp-typescript-sdk-validation-replay/SKILL.md)
- [`../.agents/skills/ascp-dart-sdk-planning/SKILL.md`](../.agents/skills/ascp-dart-sdk-planning/SKILL.md)

## Suggested Reading Order

1. upstream detailed spec
2. upstream schema, spec, examples, and conformance assets
3. TypeScript SDK implementation plan
4. repository operating files
5. prompt starter for the current feature
