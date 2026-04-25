# Codex Adapter Starter Prompt

Use this prompt to start the optional downstream `Codex adapter` feature for ASCP.

```md
You are starting the ASCP `Codex adapter` feature in `/Users/ibrar/Desktop/infinora.noworkspace/Continuum App/agent-session-control-protocol-ascp`.

This is downstream runtime-integration work, not protocol-core design work. The ASCP v0.1 protocol workspace is already complete on `main`. The adapter must consume the frozen contracts honestly and must not invent new ASCP semantics to fit Codex.

## Branch

- Use feature branch: `feature/codex-adapter`
- Start from the latest `main`

## Bootstrap From Repository State First

Read these files before planning or implementation:

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. `README.md`
5. `docs/README.md`
6. `docs/project-context-reference.md`
7. `docs/prompts/codex-adapter.md`
8. `docs/superpowers/plans/2026-04-26-codex-adapter.md`
9. `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
10. `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
11. `ASCP_Codex_Adapter_Implementation_Plan.md`
12. `apps/reference-client/README.md`
13. `services/mock-server/README.md`

Then read the frozen upstream implementation inputs the adapter must consume:

- canonical schemas under `protocol/schema/`
- method, event, replay, auth, extension, and compatibility specs under `protocol/spec/`
- protocol examples under `protocol/examples/`
- conformance fixtures and validators under `protocol/conformance/`
- the downstream proof client under `apps/reference-client/`

When reading the specs, focus first on:

- detailed spec sections 7, 8, 9, 10, 13, 14, 15, 16, and 17
- PRD sections 7, 8, 9, 10, 16, 17, 18, and 19
- the Codex adapter brief sections `Adapter Goal`, `Mapping Strategy`, `Scope of v1 Adapter`, `Event Mapping Rules`, `Capability Truthfulness`, and `Testing Strategy`

## Dependency Gate

This branch depends on the completed upstream ASCP protocol workspace:

- canonical schemas
- method contracts
- event contracts
- replay semantics
- auth and approvals
- extensions
- conformance evidence
- mock server
- reference client patterns

If any of those outputs are missing or unstable, stop and report the dependency gap. Do not redesign ASCP from the adapter branch.

If Codex runtime access, approval surfaces, or event streaming behavior cannot be observed safely enough to advertise a capability truthfully, degrade the reported capability to `false` instead of guessing.

## Feature Boundary

Stay inside:

- a runtime adapter under `adapters/codex/`
- truthful runtime discovery and capability advertisement for Codex
- list/get/resume/send-input/subscribe/approval support where Codex supports them reliably
- exact ASCP event and method normalization on top of Codex runtime behavior
- best-effort artifact and diff mapping only when the adapter can do so honestly
- branch-specific docs, tests, and compatibility notes

Do not move ahead into:

- protocol redesign
- new ASCP methods, events, schemas, or compatibility levels
- SDK packaging under `sdks/`
- speculative product UX, daemon work, or app surfaces
- fake replay, fake artifacts, fake diffs, or fake approvals

## Required Deliverables

Create or update the assets needed for a usable downstream runtime adapter:

- `adapters/codex/`
- adapter runtime-discovery and capability-resolution code
- adapter mapping code for IDs, sessions, runs, events, approvals, and optional artifacts/diffs
- adapter tests for mapping, contract behavior, and integration smoke cases
- adapter docs explaining scope, limitations, truthful capability behavior, and validation commands

The adapter should be useful for:

- proving that ASCP can sit on top of a real rich runtime
- demonstrating one honest mapping from Codex runtime behavior into the frozen ASCP surface
- giving future SDK or host work a concrete runtime-integration example that is not just PTY passthrough

## Acceptance Criteria

The feature is done only when:

- runtime discovery and capability advertisement are truthful
- sessions can be listed, read, and resumed through ASCP-shaped outputs
- input can be sent and streamed events normalize cleanly into ASCP event envelopes
- approval support works where Codex exposes it, with honest capability fallback where it does not
- unsupported artifact, diff, or replay behavior is reported honestly rather than guessed
- tests prove the adapter stays downstream of the frozen ASCP v0.1 contracts

## Working Rules

- Treat the protocol, schemas, examples, conformance assets, and the external Codex adapter brief as fixed inputs
- If Codex exposes a protocol ambiguity, stop and point at the exact upstream contract instead of silently choosing a new ASCP rule
- Preserve exact ASCP method names, event names, and field names
- Update `plans.md` before implementation
- Add a checkpoint entry to `docs/status.md` when complete

## What To Report Before Coding

After bootstrap, report:

1. whether the frozen upstream protocol assets are stable enough for adapter implementation
2. whether the observable Codex runtime surfaces appear sufficient for truthful v1 capability claims
3. the exact `adapters/codex/` files you will add or modify
4. the scoped branch task list you will execute first

Then implement only the Codex adapter slice.
```
