---
name: ascp-sdk-documentation-discipline
description: Use when documenting ASCP SDK feature work, package-shape decisions, workflow rules, or validation behavior before commit.
---

# ASCP SDK Documentation Discipline

## Overview

Use this skill whenever work in the ASCP SDK repository needs documentation before commit. The goal is to make every completed SDK task understandable without forcing readers to reconstruct intent from code alone.

## Core Rules

- Document the work before committing.
- Keep documentation separate from code when possible.
- If the SDK surface depends on upstream protocol constraints, point to the exact upstream source.
- If the work changes workflow expectations for future contributors or agents, update the relevant workflow document in the same task.

## Documentation Placement

- `README.md` for repository purpose, status, and onboarding context
- `AGENTS.md` for agent workflow rules and contribution discipline
- `plans.md` for the active scoped task
- `docs/status.md` for checkpoints
- `docs/` for architecture, validation, and workflow notes
- language package READMEs for package-specific usage and structure

## Done Criteria

The work is documented well enough when someone new to the task can understand what changed, why it changed, what it depends on upstream, and how to continue without private chat context.
