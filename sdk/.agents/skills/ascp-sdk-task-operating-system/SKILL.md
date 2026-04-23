---
name: ascp-sdk-task-operating-system
description: Use when starting or continuing ASCP SDK repository work that needs intake, feature scoping, planning, checkpointing, and drift control across sessions.
---

# ASCP SDK Task Operating System

## Overview

Use this skill to run the repository workflow for the ASCP SDK workspace. It turns loose SDK requests into a controlled loop that future sessions can resume without guessing.

## Core Loop

1. intake upstream protocol assets and local SDK plans
2. define the active SDK feature boundary
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

## Feature Boundary Rules

- One active feature per branch.
- Keep TypeScript and Dart work on separate branches unless the branch is explicitly scoped to shared docs or repo workflow.
- Do not silently mix SDK work with adapters, daemons, or product surfaces.
- Treat protocol ambiguities as upstream issues to document, not SDK behavior to invent.

## Done Criteria

The repository operating system is working when a future session can determine the active SDK feature, the language target, the task state, and the next likely step directly from repository files.
