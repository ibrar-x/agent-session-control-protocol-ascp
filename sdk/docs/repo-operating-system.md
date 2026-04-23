# ASCP SDK Repository Operating System

## Purpose

This repository uses a strict workflow so AI agents and humans can build downstream ASCP SDKs without losing scope, reopening protocol-core work accidentally, or relying on hidden chat context.

The operating system for this repo is:

1. intake the upstream protocol assets and local SDK plan
2. generate a scoped task plan
3. keep work to one feature per branch
4. require documentation before commit
5. checkpoint after each task
6. warn when conversation drift introduces a different feature

## Workflow

### 1. Intake

Before implementation, gather the active inputs:

- current chat requirements
- `AGENTS.md`
- `plans.md`
- `docs/status.md`
- upstream ASCP protocol assets
- the relevant SDK implementation plan
- current branch purpose

The goal is to identify the exact SDK feature boundary before implementation starts.

### 2. Plan

Write or update `plans.md` with:

- active feature name
- active branch
- active language target
- source inputs
- scope and out-of-scope notes
- task list
- acceptance criteria
- validation plan

The plan should describe only the current feature or a tightly related refinement.

### 3. Scope To One Feature

Every materially separate SDK feature should have its own branch.

If a request does not belong to the active feature:

- warn the user
- identify it as a separate feature
- recommend switching to a new branch
- do not silently add it to the current plan

Examples of drift:

- mixing TypeScript foundation work with Dart implementation
- mixing SDK work with Codex adapter or daemon work
- mixing validation work with unrelated repository docs unless the docs are required for the same feature

### 4. Document Before Commit

Before committing, update the documentation that explains the change.

Possible documentation locations:

- `README.md`
- `AGENTS.md`
- `plans.md`
- `docs/status.md`
- `docs/`
- `typescript/README.md`
- `dart/README.md`

Code should not be the only place where important behavior is explained.

### 5. Validate Against Upstream Truth

Whenever the feature touches protocol parsing, transport behavior, or replay handling:

- compare against the upstream schema files
- compare against the upstream examples
- use the parent mock server when integration behavior matters
- prefer evidence-backed validation over intuition

The SDK should consume ASCP correctly, not reinterpret it creatively.

### 6. Checkpoint After Each Task

After a task is completed:

- update `plans.md`
- add an entry to `docs/status.md`
- commit the finished task
- push the branch when appropriate

The repository should always contain enough written state for a future session to resume safely.

## Minimum Files

The operating system depends on these repository files:

- `AGENTS.md`
- `plans.md`
- `docs/status.md`

These files should stay current as work progresses.

## Done Criteria

The repository operating system is working when a future session can determine:

- the active SDK feature
- the current language target
- the last completed checkpoint
- the next likely step

without relying on private chat context.
