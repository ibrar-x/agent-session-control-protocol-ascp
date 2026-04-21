# AGENTS.md

## Purpose

This repository is a protocol-first workspace for the **Agent Session & Control Protocol (ASCP)**.

Treat these two files as the current source material:

1. `ASCP_Protocol_Detailed_Spec_v0_1.md`
2. `ASCP_Protocol_PRD_and_Build_Guide.md`

If they disagree, prefer:

1. `ASCP_Protocol_Detailed_Spec_v0_1.md` for exact contracts, payloads, schemas, and compliance behavior
2. `ASCP_Protocol_PRD_and_Build_Guide.md` for scope, sequencing, design intent, and repository shape

ASCP is not a product UI spec. It is not a model API. It is not an agent-planning spec. It is a vendor-neutral control plane for discovering, observing, resuming, steering, and approving long-running agent sessions.

## Protocol Constraints

All work in this repository should preserve the protocol principles defined in the source docs:

- Session-first
- Capability-based
- Event-driven
- Transport-neutral
- Replay-safe
- Auditable
- Explicit and boring

That means:

- prefer explicit JSON objects and stable field names
- use JSON Schema for protocol objects
- evolve additively
- ignore unknown fields safely
- do not redefine core semantics through extensions
- keep method and event names exactly aligned with the spec

## Current Scope

ASCP currently covers:

- host discovery
- runtime discovery
- capability advertisement
- session list, get, start, resume, stop
- input submission
- event subscriptions
- replay after reconnect
- approvals
- artifact metadata
- diff metadata
- error semantics
- auth hooks
- versioning
- conformance

ASCP explicitly does not standardize:

- model inference APIs
- prompt formats
- tool schemas
- memory formats
- UI systems
- agent planning internals
- vendor billing

Do not expand scope casually. If a change drifts into product behavior or vendor-specific runtime internals, stop and treat it as out of scope unless the spec is being intentionally revised.

## Source-Of-Truth Names

Keep these names exact unless the spec is deliberately version-bumped:

### Core methods

- `capabilities.get`
- `hosts.get`
- `runtimes.list`
- `sessions.list`
- `sessions.get`
- `sessions.start`
- `sessions.resume`
- `sessions.stop`
- `sessions.send_input`
- `sessions.subscribe`
- `sessions.unsubscribe`
- `approvals.list`
- `approvals.respond`
- `artifacts.list`
- `artifacts.get`
- `diffs.get`

### Core session statuses

- `idle`
- `running`
- `waiting_input`
- `waiting_approval`
- `completed`
- `failed`
- `stopped`
- `disconnected`

### Core event families

- session lifecycle
- run lifecycle
- transcript
- tool activity
- terminal fallback
- approvals
- artifacts and diffs
- sync and connectivity
- errors

### Compatibility levels

- `ASCP Core Compatible`
- `ASCP Interactive`
- `ASCP Approval-Aware`
- `ASCP Artifact-Aware`
- `ASCP Replay-Capable`

## Implementation Order

When building the protocol, follow this order unless there is a strong reason not to:

1. Canonical schemas
2. Capability document
3. Error schema and catalog
4. Method request and response contracts
5. Event payload definitions
6. Replay semantics
7. Auth hooks and approval behavior
8. Extensions model
9. Conformance fixtures and validators
10. Mock server

Do not start with a mobile app, dashboard, or runtime-specific UI. The first proof of ASCP should be schemas, examples, validation, and conformance.

## Working Rules For Agents

- Read the detailed spec before changing protocol nouns, method shapes, or event payloads.
- Keep examples schema-valid.
- Prefer additive evolution over breaking shape changes.
- When introducing extensions, namespace them and keep them outside core semantics.
- If a runtime cannot support replay safely, advertise `replay=false` rather than guessing.
- If a runtime cannot provide stable sequence numbers, the host should synthesize them or disable replay support.
- Treat audit fields, actor attribution, and approval history as first-class protocol concerns.
- Keep repository additions aligned with the suggested layouts from the source documents.

## Git Workflow Discipline

Agents working in this repository should use a strict feature workflow:

- Before starting a new feature branch, fetch and pull the latest changes from `main`.
- Track remote changes actively so the current task is based on the latest repository state.
- If new upstream changes exist that affect the same area of work, sync them before continuing.
- Do not start new implementation work on stale local history when a simple sync would prevent future conflicts.
- Create a new branch for every new feature or materially separate task.
- Branches should start from the latest up-to-date `main`, not from an outdated local branch.
- Do not continue unrelated feature work on the current branch just because the conversation kept going.
- If the conversation starts drifting into a different feature, stop and warn the user that the request appears to be a separate feature based on the current chat history and repository context.
- Use the current conversation history to judge whether the requested work is still part of the same feature, refinement, or bugfix.
- If it is clearly a new feature, tell the user and recommend continuing on a new branch so the current work stays coherent.

## Pull And Conflict Prevention

Agents should actively reduce merge conflict risk before and after implementation:

- Fetch remote changes before starting work and again before merging completed work.
- Check whether `main` has advanced since the feature branch was created.
- If `main` has advanced, integrate the latest `main` into the feature branch before final merge so conflicts are handled intentionally.
- Do not wait until the very end of a long task to discover the branch is stale.
- If conflict risk is high or actual conflicts appear, stop and resolve them carefully instead of pushing uncertain merges.
- The goal is that each finished task merges cleanly and the next task starts from a fresh, current `main`.

## Commit And Push Discipline

Agents should treat a completed task as a git checkpoint:

- Commit every time a task is done.
- Push after each completed task commit.
- Do not bundle unrelated finished work into one catch-all commit.
- Use meaningful commit messages that describe the completed unit of work.
- Before committing, confirm that the branch contains only the intended task outcome.
- After the task branch is pushed and validated, merge it into `main`, push `main`, and checkout `main` again so the local repository is ready for the next task.

This repository should accumulate small, reviewable checkpoints instead of large mixed batches.

## End-Of-Task Repository State

When a task is complete, the repository should be left in a predictable state:

1. commit the completed task
2. push the feature branch
3. sync with the latest `main` if needed
4. merge the completed branch into `main`
5. push `main`
6. checkout `main`
7. pull `main` so the next task starts fresh

If repository rules or conflicts prevent automatic merge, the agent should say so explicitly. Otherwise, the default expectation is to finish on updated `main`, not to leave completed work stranded on a feature branch.

## Documentation Before Commit

Documentation is a required part of task completion in this repository.

- Before committing, make sure the relevant work is documented.
- Documentation should be updated before the commit, not deferred until later.
- Keep documentation separate from code where possible, using dedicated docs, specs, examples, or protocol notes instead of burying rationale in implementation files.
- If a change affects protocol behavior, schemas, events, replay semantics, compatibility, auth hooks, or workflow expectations, update the corresponding documentation in the same task.
- If the work is not documented well enough for another implementer to understand it, it is not ready to commit.

## Expected Repository Growth

As this repository matures, prefer a structure close to:

```text
README.md
AGENTS.md
docs/
spec/ or schema/
examples/
conformance/
mock-server/ or mock/
.agents/skills/
```

## Definition Of Done For Protocol Work

A protocol task is not done just because prose exists. It is done when the relevant behavior is explicit, testable, and implementation-ready. Prefer outputs that reduce guessing:

- schema files
- exact request and response examples
- exact event payloads
- compatibility notes
- replay rules
- auth scope notes
- conformance fixtures

If a proposed change makes ASCP less precise, less replay-safe, or harder to validate, it is probably the wrong change.
