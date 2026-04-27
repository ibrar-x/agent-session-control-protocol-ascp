# ASCP Prompt Pack

This directory contains copy-paste starter prompts for the ASCP protocol build workstreams plus a small set of optional downstream follow-on branches.

## How To Use

1. Start from updated `main`.
2. Create or switch to the feature branch named in the prompt, unless the prompt explicitly says the work may stay on an adjacent contract branch.
3. Paste the prompt into a new conversation.
4. Let the agent bootstrap from repository state before implementation.

## Shared Read-First Files

Every prompt in this directory assumes the agent reads these files first:

- `AGENTS.md`
- `internal/plans.md`
- `internal/status.md`
- `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
- `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`

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
- `reference-client.md`
- `codex-adapter.md`

## Status

The protocol-first ASCP v0.1 workspace is complete on `main`.

Use the first eight prompts to reproduce or extend the protocol build sequence only if the repository is being reopened intentionally.

Use `reference-client.md` only for optional downstream consumer work that builds on the finished protocol workspace without reopening the ASCP contracts.

Use `codex-adapter.md` only for optional downstream runtime-integration work that maps the frozen ASCP v0.1 surface onto a real Codex runtime without reopening protocol-core behavior.
