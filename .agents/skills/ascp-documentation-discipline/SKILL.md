---
name: ascp-documentation-discipline
description: Use when documenting ASCP feature work, protocol changes, repo workflow decisions, or implementation outputs before commit, especially when docs must stay separate from code.
---

# ASCP Documentation Discipline

## Overview

Use this skill whenever work in the ASCP repository needs documentation before commit. The goal is to make every completed task understandable without forcing readers to reconstruct intent from code alone.

Documentation in this repository is not an afterthought. It is part of the definition of done.

## Core Rules

- Document the work before committing.
- Keep documentation separate from code when possible.
- Prefer dedicated docs, specs, examples, and protocol notes over implementation-only explanation.
- If the work changes protocol behavior, document the protocol behavior directly.
- If the work changes workflow expectations for contributors or agents, update the relevant workflow document in the same task.

## When To Use

Use this skill when:

- adding a new ASCP feature or protocol surface
- changing schemas, methods, events, replay rules, auth hooks, or compatibility levels
- introducing repository workflow rules
- creating conformance assets or mock-server behavior
- finishing any task that would be unclear without written context

Do not skip this skill just because the change feels small. Small protocol changes often create hidden compatibility risk.

## Documentation Placement

Choose the narrowest correct location for the documentation:

- `README.md` for repository purpose, status, structure, and onboarding context
- `AGENTS.md` for agent workflow rules and contribution discipline
- `docs/` for explanatory protocol guides, design notes, and workflow references
- `spec/` or `schema/` for normative protocol material
- `examples/` for concrete request, response, error, and event samples
- `conformance/` for fixtures, validators, compatibility notes, and tests

Do not hide normative protocol behavior inside commit messages or only inside code comments.

## Required Documentation Outline

When documenting a completed task, use this outline and keep only the sections that apply:

1. Summary
   State what changed in one short paragraph.

2. Motivation
   Explain why the change was needed.

3. Scope
   State what is included and what is not included.

4. Protocol Impact
   Describe affected objects, methods, events, schemas, compatibility levels, or workflow rules.

5. Implementation Notes
   Record decisions another contributor would otherwise have to rediscover.

6. Examples Or Fixtures
   Add or update concrete examples when behavior changed.

7. Validation
   Note how the documented behavior was checked or how it should be verified.

8. Follow-Up
   Record remaining work only if it is real and specific.

## Documentation Standards

- Be explicit.
- Use the exact protocol names from the spec.
- Prefer stable terminology over stylistic variation.
- Separate normative rules from explanatory guidance.
- Keep examples consistent with the current spec version.
- Write so another implementer can act without guessing.

## Common Failure Modes

- code changed but docs stayed stale
- docs describe intent but not exact protocol impact
- behavior changed without example updates
- workflow rules were discussed in chat but never written down
- rationale exists only in a commit message

## Pre-Commit Checklist

Before committing, verify all of the following:

- the relevant documentation file was updated
- the documentation is separate from code where appropriate
- protocol names match the source of truth
- examples and fixtures reflect the documented behavior
- the documentation is sufficient for another implementer to continue the work

## Done Criteria

The work is documented well enough when someone new to the task can understand what changed, why it changed, what it affects, and how to continue without depending on private chat context.
