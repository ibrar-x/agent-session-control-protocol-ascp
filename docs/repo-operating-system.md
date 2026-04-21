# ASCP Repository Operating System

## Purpose

This repository uses a strict workflow so AI agents and humans can execute long-running protocol work without losing scope, mixing features, or relying on hidden chat context.

The operating system for the repo is:

1. intake docs and specs
2. generate a task plan
3. keep work scoped to one feature per branch
4. require documentation before commit
5. checkpoint after each task
6. warn when conversation drift introduces a different feature

## Workflow

### 1. Intake

Before implementation, gather the active inputs:

- source specs
- current chat requirements
- relevant repository files
- current branch purpose

The goal is to identify the exact feature boundary before any implementation starts.

### 2. Plan

Write or update `plans.md` with:

- active feature name
- active branch
- source inputs
- task list
- acceptance criteria

The plan should describe only the current feature or a tightly related refinement.

### 3. Scope To One Feature

Every materially separate feature should have its own branch.

If a request does not belong to the active feature:

- warn the user
- identify it as a separate feature
- recommend switching to a new branch
- do not silently add it to the current plan

### 4. Document Before Commit

Before committing, update the documentation that explains the change.

Possible documentation locations:

- `README.md`
- `AGENTS.md`
- `docs/`
- `spec/`
- `schema/`
- `examples/`
- `conformance/`

Code should not be the only place where important behavior is explained.

### 5. Checkpoint After Each Task

After a task is completed:

- update `plans.md`
- add an entry to `docs/status.md`
- commit the finished task
- push the branch

The repository should always contain enough written state for a future session to resume safely.

### 6. Detect Drift

Conversation drift is treated as a workflow event, not a minor inconvenience.

Drift signals include:

- a request that changes the branch purpose
- a request that introduces a different deliverable
- a request that belongs to a future milestone rather than the active one
- a request that would make the current plan multi-feature

When drift is detected, the agent should say so explicitly and protect the current branch from mixed work.

## Minimum Files

The operating system depends on these repository files:

- `AGENTS.md`
- `plans.md`
- `docs/status.md`

These files should stay current as work progresses.
