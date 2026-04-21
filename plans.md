# ASCP Task Plan

This file is the active task list for the repository. Keep it scoped to the current feature or tightly related refinement only.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Mark task status as work progresses.
- Do not mix unrelated features into the same active plan.
- If the conversation drifts, stop and split the new work into a new branch and a new scoped plan.

## Active Feature

- Feature name: Repository operating system for ASCP work
- Branch: `feature/repo-operating-system`
- Goal: turn repo workflow expectations into explicit planning, documentation, checkpointing, and drift-control assets
- Source inputs:
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - current chat requirements about task generation, scoped branches, documentation, and checkpoints

## Task List

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | tighten `AGENTS.md` for intake, planning, drift control, and checkpoints | agent rules explicitly require plan creation, branch scoping, drift warnings, documentation, commit, and push discipline |
| done | create `plans.md` as the repository task control file | repository has a persistent place for active feature scope, tasks, and acceptance criteria |
| done | create `docs/status.md` for checkpoint logging | repository has a persistent session-to-session checkpoint log |
| done | create a repo-local planning skill | future agents can follow a repeatable intake-to-checkpoint workflow |
| done | document the workflow in `docs/repo-operating-system.md` and `README.md` | workflow is described outside code and discoverable by future contributors |

## Current Done Check

- Active feature docs created
- Agent rules updated
- Planning and checkpoint files added
- Documentation skill support extended with workflow skill

## Next Candidate Features

These are not part of the active branch unless explicitly selected:

- schema file extraction from the detailed spec
- method request and response fixture generation
- event payload fixture generation
- conformance test scaffolding
- mock server scaffolding
