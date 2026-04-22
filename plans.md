# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Repository close-out
- Branch: `main`
- Goal: leave the ASCP v0.1 protocol workspace in a clean closed-out state on `main`, with documentation that makes protocol completion explicit and with optional downstream work separated into prompt-driven follow-on branches
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/prompts/README.md`
  - current chat request for a `reference-client` starter prompt plus repository close-out cleanup

## Repository State

- The protocol-first ASCP v0.1 build sequence is complete on `main`.
- Completed repository outputs now include schema foundation, method contracts, event contracts, replay semantics, auth and approvals, extensions, conformance evidence, a deterministic mock server, and documentation for protocol usage plus DTO generation.
- There is no active unfinished protocol feature on `main`.
- Any next work should be treated as optional downstream work or an intentional future revision of the ASCP specification.

## Scope

Included in this cleanup:

- add a starter prompt for an optional `feature/reference-client` branch
- update workflow and repository docs so `main` reads as closed out rather than mid-feature
- checkpoint the repository state so future sessions do not infer unfinished protocol work from stale planning files

Explicitly out of scope:

- new protocol design work
- reference-client implementation
- schema, spec, conformance, or mock-server changes beyond documentation needed for close-out

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | add a `reference-client` starter prompt | `docs/prompts/reference-client.md` exists and scopes the branch as optional downstream consumer work |
| done | rewrite repository planning state for `main` | `plans.md` reflects closed-out protocol completion on `main` instead of pointing at a completed feature branch |
| done | update close-out documentation and checkpoint it | repository docs make protocol completion explicit, `docs/status.md` records the close-out checkpoint, and the prompt pack reflects the new downstream option |

## Acceptance Criteria

The cleanup is complete only when all of the following are true:

- `main` no longer appears to have an active unfinished protocol feature
- the prompt pack includes a clear starter prompt for `feature/reference-client`
- repository-level docs distinguish completed ASCP protocol work from optional downstream work
- the status log records the close-out so a future session can resume from repository state without hidden chat context

## Next Likely Step

If new work is desired, start from updated `main` and open a dedicated downstream branch such as `feature/reference-client`. Otherwise, leave the repository on `main` as the closed-out ASCP v0.1 protocol workspace.

## Completion Outcome

- Status: complete on `main`
- Validation evidence: `./scripts/validate_mock_server.sh` completed successfully after the close-out rewrite and confirmed the mock-server validation suite still passed
- Documentation updated:
  - `plans.md`
  - `README.md`
  - `docs/status.md`
  - `docs/README.md`
  - `docs/prompts/README.md`
  - `docs/prompts/reference-client.md`
- Recommended next branch after completion: `feature/reference-client`, only if downstream consumer work is desired
