# Docs Index

This index keeps the protocol workspace navigable without relying on prior chat context.

## Core Protocol Sources

- [`../ASCP_Protocol_Detailed_Spec_v0_1.md`](../ASCP_Protocol_Detailed_Spec_v0_1.md): exact ASCP v0.1 contracts, payloads, schemas, compatibility levels, and conformance requirements
- [`../ASCP_Protocol_PRD_and_Build_Guide.md`](../ASCP_Protocol_PRD_and_Build_Guide.md): scope, sequencing, repository shape, and design intent

## Repository Operating Files

- [`../AGENTS.md`](../AGENTS.md): repository rules for intake, branch scoping, checkpointing, and drift control
- [`../plans.md`](../plans.md): active branch plan
- [`status.md`](status.md): checkpoint log across completed tasks
- [`repo-operating-system.md`](repo-operating-system.md): repository workflow summary

## Protocol Specs

- [`../spec/methods.md`](../spec/methods.md): frozen method surface and request/response notes
- [`../spec/events.md`](../spec/events.md): frozen event support and event fixture coverage
- [`../spec/replay.md`](../spec/replay.md): replay semantics and cursor behavior
- [`../spec/auth.md`](../spec/auth.md): auth hooks, scopes, and approval semantics
- [`../spec/extensions.md`](../spec/extensions.md): extension namespacing and ignore behavior
- [`../spec/compatibility.md`](../spec/compatibility.md): compatibility ladder and evidence model

## Guides

- [`protocol-usage-and-dto-generation.md`](protocol-usage-and-dto-generation.md): how ASCP can be consumed and how to generate DTOs from the schema files
- [`schema-foundation.md`](schema-foundation.md): notes from the schema-foundation workstream
- [`../reference-client/README.md`](../reference-client/README.md): downstream proof-client scope, layout, and validation entrypoints

## Prompt Starters

- [`prompts/README.md`](prompts/README.md): workstream prompt pack overview
- [`prompts/schema-foundation.md`](prompts/schema-foundation.md)
- [`prompts/method-contracts.md`](prompts/method-contracts.md)
- [`prompts/event-contracts.md`](prompts/event-contracts.md)
- [`prompts/replay-semantics.md`](prompts/replay-semantics.md)
- [`prompts/auth-and-approvals.md`](prompts/auth-and-approvals.md)
- [`prompts/extensions.md`](prompts/extensions.md)
- [`prompts/conformance.md`](prompts/conformance.md)
- [`prompts/mock-server.md`](prompts/mock-server.md)
- [`prompts/reference-client.md`](prompts/reference-client.md)

## Validation And Fixtures

- [`../schema/`](../schema/): canonical JSON Schema files
- [`../examples/`](../examples/): schema-valid protocol examples
- [`../conformance/`](../conformance/): fixtures, validators, and tests for compatibility evidence
- [`../mock-server/README.md`](../mock-server/README.md): Mock Server usage and scope
- [`../scripts/validate_reference_client.sh`](../scripts/validate_reference_client.sh): repeatable validator for the downstream reference client

## Suggested Reading Order

1. detailed spec
2. PRD and build guide
3. repository operating files
4. protocol specs
5. conformance and Mock Server assets
