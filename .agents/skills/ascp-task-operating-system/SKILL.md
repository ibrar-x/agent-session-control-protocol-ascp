---
name: ascp-task-operating-system
description: Use when starting or continuing ASCP repository work that needs spec intake, task planning, feature scoping, documentation checkpoints, and drift control across sessions.
---

# ASCP Task Operating System

## Overview

Use this skill to run the repository workflow for ASCP work. It turns loose requests into a controlled loop that future sessions can resume without guessing.

## Core Loop

1. intake docs and specs
2. define the active feature boundary
3. create or update the active plan
4. execute only the scoped feature work
5. update documentation before commit
6. checkpoint the task
7. commit
8. push

## Required Repository Files

- `AGENTS.md`
- `plans.md`
- `docs/status.md`

If one is missing, create it before claiming the repository workflow is in place.

## Intake Rules

Read the active source material first:

- relevant spec files
- current chat request
- current branch purpose
- existing plan and status log

Do not start implementation until the current feature boundary is clear.

## Feature Boundary Rules

- One active feature per branch.
- Refinements and bugfixes for that feature can stay on the same branch.
- A materially different request is a new feature.
- If a request is a new feature, warn the user explicitly and recommend a new branch.
- Do not silently widen the active branch scope.

## Planning Rules

The active plan should include:

- feature name
- branch name
- source inputs
- task list
- acceptance criteria

The plan should be precise enough that another agent can continue the feature without reconstructing intent from chat history.

## Documentation Rules

Before commit:

- update the relevant documentation
- keep docs separate from code when appropriate
- ensure workflow or protocol changes are written down where future contributors will look first

## Checkpoint Rules

After each completed task:

- update task status in `plans.md`
- add a concise entry in `docs/status.md`
- record branch, summary, documents changed, and next likely step

## Common Failure Modes

- starting implementation without an active plan
- mixing multiple features on one branch
- handling drift silently
- committing before documentation is updated
- finishing work without a written checkpoint

## Done Criteria

The repository operating system is working when a future session can determine the active feature, the task state, the last completed checkpoint, and the next likely step directly from repository files.
