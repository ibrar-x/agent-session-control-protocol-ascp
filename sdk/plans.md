# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: SDK repository bootstrap and delivery roadmap
- Branch: `feature/sdk-repo-bootstrap`
- Goal: create the SDK-only repository operating system, documentation scaffold, local skill pack, and end-to-end build roadmap so future work can start with the TypeScript SDK and continue through final SDK delivery without reconstructing intent from chat history
- Active language target: repository bootstrap only, with TypeScript as the next implementation target
- Source inputs:
  - `AGENTS.md`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../ASCP_Protocol_PRD_and_Build_Guide.md`
  - `../schema/`
  - `../spec/`
  - `../examples/`
  - `../conformance/`
  - `../mock-server/README.md`
  - `../reference-client/README.md`
  - `../../ASCP_TypeScript_SDK_Implementation_Plan.md`
  - `../../ASCP_Dart_SDK_Implementation_Plan.md`
  - `../../ASCP_Next_Phase_Master_Roadmap.md`

## Scope

Included in this branch:

- repository-specific `AGENTS.md`
- initial `README.md`
- `plans.md`
- `docs/status.md`
- docs index and repository-context documents
- one end-to-end roadmap document with compact execution prompts
- prompt starters for the first SDK workstreams
- repo-local skills for SDK workflow and TypeScript-first implementation
- placeholder language directories for `typescript/` and `dart/`

Explicitly out of scope:

- TypeScript package implementation
- Dart package implementation
- protocol changes
- adapter, daemon, or app work

## Planned Files

Files to add:

- `AGENTS.md`
- `README.md`
- `plans.md`
- `docs/README.md`
- `docs/project-context-reference.md`
- `docs/repo-operating-system.md`
- `docs/sdk-build-roadmap.md`
- `docs/status.md`
- `docs/prompts/README.md`
- `docs/prompts/typescript-sdk-foundation.md`
- `docs/prompts/typescript-sdk-validation.md`
- `docs/prompts/typescript-sdk-transport-client.md`
- `docs/prompts/dart-sdk-planning.md`
- `.agents/skills/ascp-sdk-task-operating-system/SKILL.md`
- `.agents/skills/ascp-sdk-documentation-discipline/SKILL.md`
- `.agents/skills/ascp-typescript-sdk-foundation/SKILL.md`
- `.agents/skills/ascp-typescript-sdk-transport-client/SKILL.md`
- `.agents/skills/ascp-typescript-sdk-validation-replay/SKILL.md`
- `.agents/skills/ascp-dart-sdk-planning/SKILL.md`
- `typescript/README.md`
- `dart/README.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | define the SDK-only repository boundary and operating rules | `AGENTS.md` makes the workspace SDK-only, TypeScript-first, and explicitly downstream from the parent ASCP protocol assets |
| done | bootstrap the repository planning and checkpoint files | `plans.md` and `docs/status.md` let a future session identify the active feature and next likely step |
| done | add the SDK documentation scaffold | `README.md`, `docs/README.md`, `docs/project-context-reference.md`, and `docs/repo-operating-system.md` explain the workspace purpose, sources, and continuation model |
| done | add the end-to-end SDK delivery roadmap | `docs/sdk-build-roadmap.md` sequences the full TypeScript-first then Dart workstreams and provides compact prompts that reference the files each step must read |
| done | add prompt starters and local skills | `docs/prompts/` and `.agents/skills/` provide reusable guidance for TypeScript-first SDK work and later Dart planning |
| done | reserve the language package roots | `typescript/` and `dart/` exist with short READMEs that explain intended future use |

## Acceptance Criteria

The task is done only when all of the following are true:

- the SDK workspace has a repository-specific `AGENTS.md`
- the workspace contains `plans.md` and `docs/status.md`
- the documentation index points to upstream ASCP assets and local SDK workflow files
- the workspace contains one roadmap document that can drive the SDK effort from bootstrap through both language packages
- local skills exist for repository workflow, documentation discipline, TypeScript SDK work, and future Dart planning
- the next TypeScript SDK implementation slice is discoverable from repository files alone

## Next Likely Step

Create `feature/typescript-sdk-foundation` from updated `main` and scaffold the initial TypeScript package structure, public exports, and model/validation generation approach without widening into transport or client work yet.

## Completion Outcome

- Status: complete on `feature/sdk-repo-bootstrap`
- Validation evidence:
  - reviewed the new workspace files against the parent ASCP repo structure and downstream planning documents
  - confirmed the documentation index points to the correct upstream and local sources
  - `git diff --check`
- Documentation updated:
  - `AGENTS.md`
  - `README.md`
  - `plans.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/repo-operating-system.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/status.md`
  - `docs/prompts/README.md`
