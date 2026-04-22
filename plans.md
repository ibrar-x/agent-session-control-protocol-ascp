# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Project context reference
- Branch: `feature/project-context-reference`
- Goal: add a single comprehensive markdown reference that explains what the ASCP repository contains, what has been completed, how the work is organized, and how a future contributor should navigate it
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `README.md`
  - `docs/README.md`
  - `docs/repo-operating-system.md`
  - `docs/protocol-usage-and-dto-generation.md`
  - `reference-client/README.md`
  - `mock-server/README.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `schema/`
  - `spec/`
  - `examples/`
  - `conformance/`
  - `scripts/`
  - `.agents/skills/`
  - recent git history

## Scope

Included in this branch:

- one context-reference markdown file under `docs/`
- documentation updates that point readers to the new file
- checkpoint updates so future sessions can discover the new reference from repository state

Explicitly out of scope:

- protocol behavior changes
- schema, example, conformance, mock-server, or reference-client implementation changes
- new downstream features

## Planned Files

Files to add:

- `docs/project-context-reference.md`

Files to update:

- `plans.md`
- `docs/README.md`
- `docs/status.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | write the branch plan and define the documentation scope | `plans.md` reflects the dedicated documentation branch and names the new context-reference deliverable |
| done | add the comprehensive ASCP context reference document | `docs/project-context-reference.md` explains the repository purpose, protocol scope, completed workstreams, directory layout, validation surface, and recommended reading order |
| done | link and checkpoint the new reference | `docs/README.md` links to the new file and `docs/status.md` records the branch outcome for future sessions |

## Acceptance Criteria

The task is done only when all of the following are true:

- the repository contains one clear markdown file that summarizes the full ASCP workspace for future reference
- the file accurately reflects what exists on disk in `schema/`, `spec/`, `examples/`, `conformance/`, `mock-server/`, `reference-client/`, `docs/`, and `.agents/skills/`
- the docs index points readers to the new reference file
- the status log records the new documentation checkpoint

## Next Likely Step

Merge this documentation branch into `main` so the repo-level context reference becomes part of the default bootstrap path for future sessions.

## Completion Outcome

- Status: complete on `feature/project-context-reference`
- Validation evidence:
  - reviewed `docs/project-context-reference.md` against the current repository layout and status log
  - confirmed the docs index links to the new reference file
  - `git diff --check`
- Documentation updated:
  - `plans.md`
  - `docs/project-context-reference.md`
  - `docs/README.md`
  - `docs/status.md`
