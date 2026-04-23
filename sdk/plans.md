# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: SDK branch documentation and prompt discipline
- Branch: `feature/sdk-branch-documentation`
- Goal: document the completed TypeScript foundation branch in detail and tighten the prompt and roadmap guidance so every future SDK branch leaves behind detailed usage, rationale, verification, and handoff documentation
- Active language target: repository docs and workflow
- Source inputs:
  - `AGENTS.md`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/README.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/prompts/README.md`
  - `docs/prompts/typescript-sdk-foundation.md`
  - `docs/prompts/typescript-sdk-validation.md`
  - `docs/prompts/typescript-sdk-transport-client.md`
  - `docs/prompts/dart-sdk-planning.md`
  - `typescript/README.md`
  - `typescript/package.json`
  - `typescript/src/metadata.ts`
  - `typescript/src/models/types.ts`
  - `typescript/src/methods/types.ts`
  - `docs/project-context-reference.md`

## Scope

Included in this branch:

- a detailed branch reference for the completed TypeScript SDK foundation work
- documentation of how to use the foundation output from the current repository state
- explicit rationale, alternatives considered, verification evidence, limitations, and next-step handoff notes for the foundation branch
- prompt starter updates that require detailed branch documentation on future SDK branches
- roadmap updates that carry the same documentation expectation across the full SDK sequence

Explicitly out of scope:

- new TypeScript SDK runtime behavior
- validation, transport, replay, or client implementation
- Dart package implementation
- protocol changes

## Planned Files

Files to add:

- `docs/branches/typescript-sdk-foundation.md`
- prompt and roadmap doc updates

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | document the TypeScript foundation branch in detail | a dedicated branch reference explains usage, scope, rationale, alternatives, verification evidence, limitations, and next-step handoff |
| done | wire the new branch reference into the docs index and continuation files | `docs/README.md` and any relevant workflow docs point to the branch reference cleanly |
| done | require the same documentation discipline in future prompts and roadmap steps | the prompt pack and roadmap explicitly require branch-level usage and rationale documentation before closeout |
| done | leave a checkpoint for this documentation branch | `docs/status.md` records the branch, summary, updated docs, and next likely step |

## Acceptance Criteria

The task is done only when all of the following are true:

- the completed TypeScript foundation branch has a dedicated detailed reference document under `docs/`
- the branch reference explains how to use the current foundation output and why it was shaped the way it was
- future prompt starters and the roadmap require the same depth of branch documentation
- the repository checkpoint files make this documentation work and the next likely SDK branch obvious

## Next Likely Step

Create `feature/typescript-sdk-validation` from updated `main` and implement the schema-backed validation layer using the documented foundation surface and branch reference as the handoff context.

## Completion Outcome

- Status: complete on `feature/sdk-branch-documentation`
- Validation evidence:
  - `npm run check` in `typescript/`
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/status.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/prompts/README.md`
  - `docs/prompts/typescript-sdk-foundation.md`
  - `docs/prompts/typescript-sdk-validation.md`
  - `docs/prompts/typescript-sdk-transport-client.md`
  - `docs/prompts/dart-sdk-planning.md`
  - `docs/branches/typescript-sdk-foundation.md`
  - `typescript/README.md`
