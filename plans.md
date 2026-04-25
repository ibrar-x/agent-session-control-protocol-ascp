# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Production-grade monorepo restructure
- Branch: `branch-ascp-monorepo-structure`
- Goal: convert the repository from a protocol-first single-workspace layout into a production-grade ASCP monorepo with strict dependency boundaries, conservative file moves, root workspace orchestration, and updated documentation while preserving the existing protocol and SDK outputs
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `README.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
  - the user-provided "ASCP Monorepo — Production-Grade Structure"
  - `protocol/schema/`
  - `protocol/spec/`
  - `protocol/examples/`
  - `protocol/conformance/`
  - `services/mock-server/`
  - `apps/reference-client/`
  - `sdks/`
  - recent git history

## Scope

Included in this branch:

- move the repository into the target monorepo layout under `protocol/`, `packages/`, `sdks/`, `adapters/`, `apps/`, `services/`, `tooling/`, and `docs/`
- preserve ASCP protocol contracts while relocating protocol truth into `protocol/`
- preserve the existing TypeScript and Dart SDKs while relocating them under `sdks/`
- preserve the existing reference client and mock server while relocating them under `apps/` and `services/`
- add root workspace scaffolding with npm workspaces, `turbo.json`, and `melos.yaml`
- scaffold placeholder package directories for future shared packages, adapters, and apps
- update scripts, docs, tests, and path references so the moved repository remains coherent

Explicitly out of scope:

- changing ASCP core method, event, schema, replay, auth, extension, or compatibility semantics
- implementing the Codex adapter or any other new runtime adapter
- building product UI beyond placeholder module scaffolds
- widening the protocol scope beyond the current source documents

## Planned Files

Files to add:

- `package.json`
- `turbo.json`
- `melos.yaml`
- `packages/README.md`
- `packages/core/README.md`
- `packages/transport/README.md`
- `packages/event-engine/README.md`
- `packages/auth/README.md`
- `packages/utils/README.md`
- `adapters/README.md`
- `adapters/codex/README.md`
- `adapters/claude/README.md`
- `adapters/gemini/README.md`
- `apps/README.md`
- `apps/web/README.md`
- `services/README.md`
- `tooling/README.md`
- `tooling/scripts/README.md`
- `tooling/generators/README.md`
- `docs/architecture/system-design.md`
- `docs/architecture/dependency-graph.md`

Files to move and update:

- `schema/` -> `protocol/schema/`
- `spec/` -> `protocol/spec/`
- `examples/` -> `protocol/examples/`
- `conformance/` -> `protocol/conformance/`
- `mock-server/` -> `services/mock-server/`
- `reference-client/` -> `apps/reference-client/`
- `sdk/` -> `sdks/`
- `scripts/` -> `tooling/scripts/`
- root protocol source docs -> `protocol/`
- root and repo docs that reference old paths

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | rewrite the active plan for the monorepo migration branch | `plans.md` scopes the branch to repository architecture only and names the user monorepo structure plus ASCP source docs as inputs |
| done | move the repository into the target monorepo layout | the repository contains `protocol/`, `packages/`, `sdks/`, `adapters/`, `apps/`, `services/`, `tooling/`, and `docs/` with existing code/assets relocated conservatively |
| done | add root workspace scaffolding and placeholder module boundaries | root `package.json`, `turbo.json`, and `melos.yaml` exist and future module placeholders document the dependency direction without leaking reverse dependencies |
| done | update path-sensitive code, scripts, and docs | validation scripts, SDK tests/examples, mock-server fixtures, and repository docs all point at the new locations |
| done | checkpoint and close out the branch | `docs/status.md` records the monorepo migration, validation evidence is captured, and the branch is committed, pushed, merged, and closed out on `main` |

## Acceptance Criteria

The task is done only when all of the following are true:

- protocol source-of-truth assets live under `protocol/`
- SDKs live under `sdks/`
- the reference client lives under `apps/reference-client/`
- the mock server lives under `services/mock-server/`
- root workspace files document and orchestrate the monorepo shape
- placeholder module directories exist for `packages/`, `adapters/`, and future apps/services where requested
- documentation explains the dependency direction `protocol -> packages -> sdks -> adapters -> apps`
- the existing validation entrypoints still run successfully from the new structure

## Next Likely Step

Start the next shared-package, adapter, app, or service feature from updated `main` using the monorepo layout as the new repository baseline.

## Completion Outcome

- Status: complete and merged to `main` from `branch-ascp-monorepo-structure`
- Validation evidence:
  - `git diff --check`
  - `bash tooling/scripts/validate_method_contracts.sh`
  - `bash tooling/scripts/validate_event_contracts.sh`
  - `bash tooling/scripts/validate_replay_semantics.sh`
  - `bash tooling/scripts/validate_auth_semantics.sh`
  - `bash tooling/scripts/validate_extension_semantics.sh`
  - `bash tooling/scripts/validate_conformance.sh`
  - `bash tooling/scripts/validate_mock_server.sh`
  - `bash tooling/scripts/validate_reference_client.sh`
  - `npm --workspace sdks/typescript run check`
- Documentation updated:
  - `README.md`
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/architecture/system-design.md`
  - `docs/architecture/dependency-graph.md`
  - `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
  - `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `packages/README.md`
  - `adapters/README.md`
  - `apps/README.md`
  - `services/README.md`
  - `tooling/README.md`
