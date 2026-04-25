# ASCP Project Context Reference

This document is the repository-wide context reference for the **Agent Session & Control Protocol (ASCP)** workspace. It is meant to give a future contributor enough context to understand what this project is, what has already been built, where the important files live, and how to continue without relying on hidden chat history.

## Summary

This repository is a protocol-first ASCP v0.1 workspace. Its main job is to make the protocol explicit, testable, and implementation-ready before any product UI or vendor-specific runtime work.

At this point the repository contains:

- source-of-truth protocol documents
- canonical JSON Schemas
- request, response, error, and event examples
- replay, auth, extension, and compatibility specifications
- conformance fixtures and validators
- a deterministic mock server
- a downstream reference client
- an optional downstream Codex adapter planning pack
- repository workflow documents and prompt starters for future work

## What ASCP Is

ASCP is a vendor-neutral control plane for:

- discovering hosts and runtimes
- listing and reading sessions
- starting, resuming, stopping, and steering long-running sessions
- subscribing to typed events
- replaying events after reconnect
- handling approvals
- reading artifact and diff metadata

ASCP is intentionally not:

- a model inference API
- a prompt format standard
- a tool schema standard
- a UI system
- an agent-planning specification
- a vendor billing or cloud product specification

## Source Of Truth

Read these first when protocol meaning matters:

1. `ASCP_Protocol_Detailed_Spec_v0_1.md`
2. `ASCP_Protocol_PRD_and_Build_Guide.md`

Conflict rule:

- use the detailed spec for exact contracts, payloads, schemas, compatibility, and compliance behavior
- use the PRD/build guide for scope, sequencing, intent, and repository shape

## Core Protocol Principles

The repository follows these principles from the source docs:

- session-first
- capability-based
- event-driven
- transport-neutral
- replay-safe
- auditable
- explicit and boring

In practice, that means:

- JSON payloads with stable field names
- JSON Schema as the contract language
- additive evolution instead of breaking reshapes
- safe ignore behavior for unknown fields and extensions
- exact method and event naming from the spec

## Current Repository Status

The protocol-first ASCP v0.1 workspace is complete on `main` for its intended repository scope.

That means the repository now has a full protocol-definition surface plus executable and downstream proof assets. It does not mean ASCP is a production standard or that product integrations are finished. It means the v0.1 contract set is explicit enough to implement against without guessing.

## Frozen Core Surface

### Canonical objects

- `Host`
- `Runtime`
- `Session`
- `Run`
- `ApprovalRequest`
- `Artifact`
- `DiffSummary`
- `EventEnvelope`

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

### Core compatibility levels

- `ASCP Core Compatible`
- `ASCP Interactive`
- `ASCP Approval-Aware`
- `ASCP Artifact-Aware`
- `ASCP Replay-Capable`

## What Has Been Completed

The repository was built in workstreams. Each workstream has its own outputs and leaves evidence in repository files and the status log.

### 1. Repository operating system

Purpose:
- define how agents work in this repo without drifting or mixing features

Main outputs:
- `AGENTS.md`
- `docs/repo-operating-system.md`
- the planning and checkpointing discipline around `plans.md` and `docs/status.md`

What it established:
- bootstrap order for new conversations
- one-feature-per-branch discipline
- documentation-before-commit discipline
- checkpointing after each completed task

### 2. Prompt pack

Purpose:
- make each feature branch reproducible from repo state

Main outputs:
- `docs/prompts/README.md`
- prompt starters for schema foundation, method contracts, event contracts, replay semantics, auth and approvals, extensions, conformance, mock server, reference client, and Codex adapter

What it established:
- future conversations can start from an explicit feature boundary instead of reconstructing intent manually
- optional downstream runtime-integration work can now bootstrap from a dedicated Codex adapter prompt instead of re-deriving its dependency gates

### 3. Schema foundation

Purpose:
- define the canonical nouns and shared contract layer

Main outputs:
- `schema/ascp-core.schema.json`
- `schema/ascp-capabilities.schema.json`
- `schema/ascp-errors.schema.json`
- core examples under `examples/core/`
- `docs/schema-foundation.md`

What it established:
- normalized object shapes
- shared timestamps, IDs, status enums, and capability/error structures

### 4. Method contracts

Purpose:
- freeze exact request and response shapes for the method surface

Main outputs:
- `schema/ascp-methods.schema.json`
- `spec/methods.md`
- request examples under `examples/requests/`
- success examples under `examples/responses/`
- method error examples under `examples/errors/`
- `scripts/validate_method_contracts.sh`

What it established:
- exact request params and response envelopes for every core method
- method-specific error coverage

### 5. Event contracts

Purpose:
- freeze exact event payload definitions

Main outputs:
- `schema/ascp-events.schema.json`
- `spec/events.md`
- event examples under `examples/events/`
- `scripts/validate_event_contracts.sh`

What it established:
- exact `EventEnvelope` payload expectations across lifecycle, transcript, tool, approval, artifact, sync, and error events

### 6. Replay semantics

Purpose:
- make reconnect and event recovery behavior explicit and testable

Main outputs:
- `spec/replay.md`
- replay fixtures under `conformance/fixtures/replay/`
- replay validator under `conformance/tests/validate_replay_semantics.py`
- `scripts/validate_replay_semantics.sh`

What it established:
- snapshot versus replay boundaries
- `from_seq`, `from_event_id`, and opaque cursor recovery patterns
- retention-limited fallback expectations

### 7. Auth and approvals

Purpose:
- define protocol-level hooks for authorization and approval handling

Main outputs:
- `spec/auth.md`
- auth fixtures under `conformance/fixtures/auth/`
- auth validator under `conformance/tests/validate_auth_semantics.py`
- approval examples under `examples/approvals/`
- `scripts/validate_auth_semantics.sh`

What it established:
- method scope expectations
- approval lifecycle shapes
- `UNAUTHORIZED` versus `FORBIDDEN` distinction
- audit and actor-attribution hooks

### 8. Extensions

Purpose:
- allow additive vendor-specific behavior without redefining core semantics

Main outputs:
- `spec/extensions.md`
- extension fixtures under `conformance/fixtures/extensions/`
- extension examples under `examples/extensions/`
- extension validator under `conformance/tests/validate_extension_semantics.py`
- `scripts/validate_extension_semantics.sh`

What it established:
- namespaced extension behavior
- ignore-safe handling for unknown extensions
- open-versus-closed boundary around core contracts

### 9. Conformance

Purpose:
- turn the protocol into something implementations can claim and test

Main outputs:
- `spec/compatibility.md`
- `conformance/fixtures/compatibility/compatibility-matrix.json`
- `conformance/fixtures/compatibility/golden-examples.json`
- `conformance/validators/compatibility.py`
- `conformance/tests/validate_conformance.py`
- `scripts/validate_conformance.sh`

What it established:
- a cumulative compatibility ladder
- machine-readable evidence mapping
- composed validation across schema, replay, auth, and extension rules

### 10. Mock server

Purpose:
- provide a deterministic executable proof implementation of the frozen contract set

Main outputs:
- `mock-server/src/mock_server/`
- `mock-server/fixtures/state.json`
- `mock-server/sample-event-streams/sess_abc123.json`
- `mock-server/tests/validate_mock_server.py`
- `mock-server/README.md`
- `scripts/validate_mock_server.sh`

What it established:
- line-oriented stdio JSON-RPC request handling
- seeded host, runtime, session, approval, artifact, and diff state
- deterministic subscribe/replay behavior with `sync.snapshot`, `sync.replayed`, and `sync.cursor_advanced`

### 11. Reference client

Purpose:
- prove that a downstream consumer can use the published protocol assets without hidden assumptions

Main outputs:
- `reference-client/src/reference_client/`
- `reference-client/tests/validate_reference_client.py`
- `reference-client/README.md`
- `scripts/validate_reference_client.sh`

What it established:
- a thin Python client over the stdio mock
- schema validation of consumed method responses and events
- end-to-end discovery, session inspection, approval/artifact/diff reads, live input, and subscribe/replay demo coverage

## Repository Layout

### Root

Important files:

- `README.md`: top-level project summary and current status
- `AGENTS.md`: repository workflow rules for agents
- `plans.md`: active branch plan
- `ASCP_Protocol_Detailed_Spec_v0_1.md`: exact protocol contracts
- `ASCP_Protocol_PRD_and_Build_Guide.md`: scope and build sequencing

### `schema/`

Contains canonical JSON Schemas:

- `ascp-core.schema.json`
- `ascp-capabilities.schema.json`
- `ascp-errors.schema.json`
- `ascp-methods.schema.json`
- `ascp-events.schema.json`

Use these as the primary machine-readable contract source for DTO generation and validation.

### `spec/`

Contains normative explanatory specs layered on top of the schema foundation:

- `methods.md`
- `events.md`
- `replay.md`
- `auth.md`
- `extensions.md`
- `compatibility.md`

Use these when you need semantic rules, not just raw schema structure.

### `examples/`

Contains schema-valid concrete payloads grouped by concern:

- `capabilities/`
- `core/`
- `requests/`
- `responses/`
- `errors/`
- `events/`
- `approvals/`
- `extensions/`

Use these as golden payload examples for consumers, validators, or future SDK work.

### `conformance/`

Contains compatibility evidence, fixtures, validators, and composed tests:

- `fixtures/replay/`
- `fixtures/auth/`
- `fixtures/extensions/`
- `fixtures/compatibility/`
- `validators/compatibility.py`
- `tests/validate_*.py`

Use this area to prove compatibility claims rather than only describing them in prose.

### `mock-server/`

Contains the deterministic proof implementation:

- `src/mock_server/server.py`
- `src/mock_server/cli.py`
- `src/mock_server/fixtures.py`
- `fixtures/state.json`
- `sample-event-streams/sess_abc123.json`
- `tests/validate_mock_server.py`

Use this when you need an executable ASCP surface.

### `reference-client/`

Contains the downstream proof consumer:

- `src/reference_client/client.py`
- `src/reference_client/stdio_transport.py`
- `src/reference_client/schema_validation.py`
- `src/reference_client/demo.py`
- `tests/validate_reference_client.py`

Use this when you need to see one clean client-side interpretation of the frozen ASCP contracts.

### `docs/`

Contains explanatory and workflow docs:

- `README.md`
- `status.md`
- `repo-operating-system.md`
- `schema-foundation.md`
- `protocol-usage-and-dto-generation.md`
- `prompts/`
- `superpowers/`

Use `docs/status.md` for branch-by-branch recovery context and `docs/prompts/` for starting new scoped conversations.

### `.agents/skills/`

Contains repo-local agent guidance for ASCP-specific workstreams:

- `ascp-schema-foundation`
- `ascp-method-contracts`
- `ascp-event-replay`
- `ascp-auth-approvals`
- `ascp-conformance-mock-server`
- `ascp-documentation-discipline`
- `ascp-task-operating-system`

These are not protocol deliverables. They are workflow aids for future agent sessions.

### `scripts/`

Contains the main validation entrypoints:

- `validate_method_contracts.sh`
- `validate_event_contracts.sh`
- `validate_replay_semantics.sh`
- `validate_auth_semantics.sh`
- `validate_extension_semantics.sh`
- `validate_conformance.sh`
- `validate_mock_server.sh`
- `validate_reference_client.sh`

## Validation Surface

These are the main repeatable validation commands currently available:

```bash
./scripts/validate_method_contracts.sh
./scripts/validate_event_contracts.sh
./scripts/validate_replay_semantics.sh
./scripts/validate_auth_semantics.sh
./scripts/validate_extension_semantics.sh
./scripts/validate_conformance.sh
./scripts/validate_mock_server.sh
./scripts/validate_reference_client.sh
```

Reference-client demo:

```bash
PYTHONPATH="$PWD/reference-client/src" python3 -m reference_client.demo
```

Mock-server direct run:

```bash
python3 mock-server/src/mock_server/cli.py
```

## Recommended Reading Orders

### If you are new to the repository

1. `README.md`
2. `AGENTS.md`
3. `docs/project-context-reference.md`
4. `docs/README.md`
5. `docs/status.md`

### If you need the exact protocol contracts

1. `ASCP_Protocol_Detailed_Spec_v0_1.md`
2. `schema/`
3. `spec/`
4. `examples/`
5. `conformance/fixtures/compatibility/`

### If you are building a consumer or SDK

1. `docs/protocol-usage-and-dto-generation.md`
2. `schema/`
3. `examples/`
4. `mock-server/README.md`
5. `reference-client/README.md`

### If you are resuming work as an agent

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. this file
5. the prompt starter in `docs/prompts/` that matches the intended branch

## Git And Workstream History

The repository was developed as a sequence of scoped branches. The important completed slices are:

- `feature/schema-foundation`
- `feature/method-contracts`
- `feature/event-contracts`
- `feature/replay-semantics`
- `feature/auth-approvals`
- `feature/extensions`
- `feature/conformance`
- `feature/mock-server`
- `feature/reference-client`

Those slices are summarized in `docs/status.md`. The main branch now represents the integrated ASCP v0.1 protocol workspace plus the downstream proof client.

## What Is Intentionally Not Here

The repository intentionally does not include:

- a production runtime
- a hosted control plane
- a product UI
- mobile or web apps
- vendor-specific auth implementation
- multi-language SDK packages
- model APIs or planning internals

If new work starts adding those concerns, it should be treated as a downstream or future-spec task, not silently mixed into the protocol-core branch.

## How To Continue Safely

If you are starting a new task:

1. start from updated `main`
2. read `AGENTS.md`
3. read `plans.md` and `docs/status.md`
4. define one feature boundary
5. create a new branch for that feature
6. update `plans.md` before implementation
7. update documentation before commit
8. add a checkpoint entry to `docs/status.md`

## Short Status Statement

The ASCP repository currently contains an implementation-ready protocol workspace for the published v0.1 contract set, a deterministic executable mock, a small downstream reference client, and planning assets for an optional Codex runtime adapter. The next work, if any, should be treated as optional downstream consumer or adapter work, or as a deliberate future revision of the ASCP specification.

## Optional Downstream Follow-On Work

The protocol-core workspace is complete on `main`, but the repository now also contains planning assets for one optional downstream runtime-integration branch:

- `docs/prompts/codex-adapter.md`
- `docs/superpowers/plans/2026-04-26-codex-adapter.md`

That work should stay clearly downstream of the frozen ASCP v0.1 contracts. It is intended to prove real-runtime mapping against Codex, not to reopen method, event, replay, or approval semantics.
