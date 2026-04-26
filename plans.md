# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Codex live smoke script
- Branch: `feature/codex-live-smoke-script`
- Goal: add a checked-in live test script for the Codex adapter that supports both an interactive terminal flow and direct CLI subcommands over the real `codex app-server`
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `adapters/codex/README.md`
  - `adapters/codex/package.json`
  - `adapters/codex/src/app-server-client.ts`
  - `adapters/codex/src/discovery.ts`
  - `adapters/codex/src/service.ts`
  - `docs/superpowers/specs/2026-04-26-codex-live-smoke-script-design.md`
  - live smoke behavior already verified on `main`

## Scope

Included in this branch:

- add one dual-mode live smoke entrypoint for the Codex adapter
- support interactive no-arg execution
- support direct subcommands for discovery, list, get, resume, and send-input
- add focused tests for parsing and dispatch logic
- document how to run the script honestly against the real runtime

Explicitly out of scope:

- implementing `sessions.subscribe`
- replay, artifacts, approval response, or diff-read support
- any protocol or adapter capability widening
- browser UI or daemon work

## Planned Files

Files to add:

- `adapters/codex/scripts/live-smoke.mjs`
- `adapters/codex/src/live-smoke.ts`
- `adapters/codex/tests/live-smoke.test.ts`

Files to modify:

- `adapters/codex/package.json`
- `adapters/codex/README.md`
- `docs/superpowers/plans/2026-04-26-codex-live-smoke-script.md`
- `plans.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | add a testable live smoke command module | command parsing, validation, and action dispatch live in a normal TypeScript module with focused tests |
| completed | add the executable script wrapper and npm alias | `npm --workspace @ascp/adapter-codex run live` works in interactive mode and `run live -- <subcommand>` works directly |
| completed | document and verify the live smoke flow | the README documents usage clearly and the adapter build/tests still pass |

## Acceptance Criteria

The task is done only when all of the following are true:

- `npm --workspace @ascp/adapter-codex run live` opens a guided interactive terminal flow
- `npm --workspace @ascp/adapter-codex run live -- <subcommand>` supports direct invocation
- the script uses the real adapter service layer and honest runtime discovery
- unsupported features remain explicitly unsupported
- focused script tests pass along with the existing adapter checks

## Next Likely Step

Review the finished live smoke script branch, then push and merge it if the checked-in interactive and subcommand workflow is accepted.
