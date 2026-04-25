# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Codex adapter planning pack
- Branch: `feature/codex-adapter-planning`
- Goal: translate the external Codex adapter implementation brief into repository-native planning assets so a future implementation branch can start from explicit prompts, a detailed task plan, and updated repo bootstrap docs without reopening protocol-core scope
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `README.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/prompts/README.md`
  - `docs/prompts/reference-client.md`
  - `reference-client/README.md`
  - `mock-server/README.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `ASCP_Codex_Adapter_Implementation_Plan.md`
  - `schema/`
  - `spec/`
  - `examples/`
  - `conformance/`
  - recent git history

## Scope

Included in this branch:

- rewrite repository state around a new optional downstream Codex adapter planning feature
- add a reusable starter prompt for the future `feature/codex-adapter` implementation branch
- add a detailed superpowers implementation plan that breaks the adapter work into concrete downstream tasks
- update the docs index and checkpoint log so future sessions can discover the Codex adapter planning assets from repository state

Explicitly out of scope:

- implementing the Codex adapter itself
- changing frozen ASCP protocol contracts, schemas, examples, or conformance rules
- SDK package work under `sdk/`
- speculative product UI or vendor-specific runtime behavior beyond the existing adapter brief

## Planned Files

Files to add:

- `docs/prompts/codex-adapter.md`
- `docs/superpowers/plans/2026-04-26-codex-adapter.md`

Files to update:

- `plans.md`
- `docs/status.md`
- `docs/README.md`
- `docs/prompts/README.md`
- `docs/project-context-reference.md`
- `README.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | rewrite the active plan for the Codex adapter planning branch | `plans.md` scopes the branch to planning assets only and names the external Codex adapter brief as a source input |
| done | add the Codex adapter starter prompt | `docs/prompts/codex-adapter.md` gives a future implementation branch explicit bootstrap reads, dependency gates, feature boundaries, deliverables, and pre-coding reporting requirements |
| done | add the detailed Codex adapter implementation plan | `docs/superpowers/plans/2026-04-26-codex-adapter.md` breaks the adapter work into concrete tasks, files, and validation expectations for a future implementation agent |
| done | wire the new planning assets into repository docs | `docs/README.md`, `docs/prompts/README.md`, `docs/project-context-reference.md`, and `README.md` point future contributors to the Codex adapter planning assets without implying the adapter is already implemented |
| done | checkpoint the planning branch | `docs/status.md` records the planning outcome and the next likely step points at `feature/codex-adapter` implementation from updated `main` |

## Acceptance Criteria

The task is done only when all of the following are true:

- the repository contains one reusable starter prompt for the Codex adapter implementation branch
- the repository contains one detailed implementation plan for the Codex adapter under `docs/superpowers/plans/`
- the planning assets keep the adapter strictly downstream of the frozen ASCP v0.1 contracts
- the docs index and status log make the new planning assets discoverable from repository state alone
- no protocol-core or adapter runtime code changes are mixed into this planning branch

## Next Likely Step

Create `feature/codex-adapter` from updated `main`, use the new starter prompt plus detailed plan, and implement the adapter as an optional downstream runtime integration without silently redefining ASCP semantics.

## Completion Outcome

- Status: complete on `feature/codex-adapter-planning`
- Validation evidence:
  - reviewed `docs/prompts/codex-adapter.md` against the external Codex adapter brief and current repository prompt-pack conventions
  - reviewed `docs/superpowers/plans/2026-04-26-codex-adapter.md` for branch scope, dependency gates, file paths, and concrete task sequencing
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `README.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/prompts/README.md`
  - `docs/prompts/codex-adapter.md`
  - `docs/superpowers/plans/2026-04-26-codex-adapter.md`
  - `docs/status.md`
