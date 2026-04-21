# ASCP Workstream Prompt Pack

This directory contains copy-paste starter prompts for the main ASCP protocol workstreams.

## How To Use

1. Start from updated `main`.
2. Create or switch to the feature branch named in the prompt, unless the prompt explicitly says the work may stay on an adjacent contract branch.
3. Paste the prompt into a new conversation.
4. Let the agent bootstrap from repository state before implementation.

## Shared Read-First Files

Every prompt in this directory assumes the agent reads these files first:

- `AGENTS.md`
- `plans.md`
- `docs/status.md`
- `ASCP_Protocol_Detailed_Spec_v0_1.md`
- `ASCP_Protocol_PRD_and_Build_Guide.md`

## Dependency Discipline

- If a prompt depends on outputs from an earlier workstream, the agent should read those outputs before writing code.
- If required upstream outputs are missing, the agent should stop and report that the dependency gate is not met rather than inventing protocol behavior.
- The detailed spec remains the source of truth for exact contracts, payloads, schemas, replay behavior, and compliance rules.

## Files

- `schema-foundation.md`
- `method-contracts.md`
- `event-contracts.md`
- `replay-semantics.md`
- `auth-and-approvals.md`
- `extensions.md`
- `conformance.md`
- `mock-server.md`
