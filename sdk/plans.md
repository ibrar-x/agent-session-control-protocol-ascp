# ASCP SDK Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Dart SDK planning refresh
- Branch: `feature/dart-sdk-planning`
- Goal: confirm the Dart SDK package scope, layout, model and codec direction, validation and replay plan, and the first implementation handoff now that the TypeScript SDK acts as the stable downstream reference package
- Active language target: Dart SDK planning
- Source inputs:
  - `AGENTS.md`
  - `../AGENTS.md`
  - `../ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `../ASCP_Protocol_PRD_and_Build_Guide.md`
  - `../schema/`
  - `../spec/`
  - `../examples/`
  - `README.md`
  - `plans.md`
  - `docs/status.md`
  - `docs/README.md`
  - `docs/project-context-reference.md`
  - `docs/sdk-build-roadmap.md`
  - `docs/branches/typescript-sdk-release-readiness.md`
  - `docs/prompts/dart-sdk-planning.md`
  - `typescript/README.md`
  - `typescript/CHANGELOG.md`
  - `typescript/package.json`
  - `typescript/src/index.ts`
  - `dart/README.md`
  - `../../ASCP_Dart_SDK_Implementation_Plan.md`
  - `../../ASCP_Next_Phase_Master_Roadmap.md`

## Scope

Included in this branch:

- confirm the Dart SDK boundary as a pure Dart package that stays separate from Flutter UI work and product-layer transport choices
- choose the Dart package layout and public library seams using the TypeScript SDK as the first downstream reference while translating the export model to Dart conventions
- make the Dart model, JSON codec, event parsing, validation, subscription, and replay direction explicit enough that implementation can start without reopening foundation architecture questions
- document how future contributors should read and use the planning outputs from this branch

Explicitly out of scope:

- protocol-core schema or spec changes
- Dart package implementation beyond documentation and planning artifacts
- Flutter UI work or app-level state management
- choosing app-layer transport clients or mobile architecture details
- changing ASCP field names into Dart-specific aliases
- reopening the TypeScript package surface beyond what is needed to cite it as the reference package

## Planned Files

Files to add:

- `docs/branches/dart-sdk-planning.md`

Files expected to change:

- `plans.md`
- `README.md`
- `docs/README.md`
- `docs/project-context-reference.md`
- `docs/sdk-build-roadmap.md`
- `docs/status.md`
- `dart/README.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | replace the stale active plan with a Dart planning branch plan | `plans.md` scopes the branch to Dart planning only, lists the source inputs, and names the implementation handoff branch |
| done | document the Dart package direction and tradeoffs | the branch reference plus `dart/README.md` explain the package layout, model and codec strategy, subscription and replay shape, alternatives, and open assumptions |
| done | align shared workspace docs with the new branch | shared docs point readers to the Dart planning outputs instead of outdated TypeScript-next-step guidance |
| done | leave a resumable checkpoint for the implementation branch | `docs/status.md` records the planning summary, touched docs, and the exact next branch to open |

## Acceptance Criteria

The task is done only when all of the following are true:

- the Dart package scope is explicit and stays free of Flutter UI or protocol-core drift
- the package layout, library boundaries, model and codec direction, validation hooks, and replay surface are documented concretely enough that `feature/dart-sdk-foundation` can start without re-deciding scope
- the planning outputs explain which TypeScript release-readiness boundaries should be mirrored conceptually and which should be translated for Dart-specific tooling
- the branch documentation states the chosen direction, rejected alternatives, acceptable planning-time assumptions, and the first implementation branch handoff

## Next Likely Step

Start `feature/dart-sdk-foundation` from updated `main` and scaffold the pure Dart package, root and sub-library layout, generated model and codec workflow, and example-backed baseline tests described by this planning branch.
