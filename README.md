# Agent Session & Control Protocol (ASCP)

ASCP is a vendor-neutral, session-first protocol for discovering, observing, controlling, resuming, and approving long-running AI agent sessions across clients, hosts, and runtimes.

This repository currently serves as the protocol workspace for ASCP. The two source documents in the root define the protocol direction and the implementation-oriented draft specification:

- [`ASCP_Protocol_PRD_and_Build_Guide.md`](./ASCP_Protocol_PRD_and_Build_Guide.md)
- [`ASCP_Protocol_Detailed_Spec_v0_1.md`](./ASCP_Protocol_Detailed_Spec_v0_1.md)

## What ASCP Covers

ASCP standardizes the session control plane around:

- host discovery
- runtime discovery
- capability advertisement
- session list, read, start, resume, and stop
- user input submission
- live event subscriptions
- replay after reconnect
- approvals
- artifact metadata
- diff metadata
- auth hooks
- error semantics
- versioning and extensions
- conformance levels

ASCP does not attempt to standardize model APIs, prompt formats, tool schemas, UI systems, agent planning internals, or vendor billing.

## Design Principles

The protocol is guided by seven core principles from the source docs:

- session-first
- capability-based
- event-driven
- transport-neutral
- replay-safe
- auditable
- explicit and boring

In practice, that means explicit JSON payloads, stable field names, JSON Schema validation, additive evolution, and predictable replay behavior.

## Canonical Objects

The current draft spec centers on these protocol nouns:

- `Host`
- `Runtime`
- `Session`
- `Run`
- `ApprovalRequest`
- `Artifact`
- `DiffSummary`
- `EventEnvelope`

These are the base units for method contracts, event payloads, and conformance fixtures.

## Core Method Surface

The v0.1 draft keeps the method surface intentionally small:

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

These methods are expected to run over a transport-neutral protocol surface, with JSON-RPC 2.0 recommended where request/response semantics are needed.

## Event Model

ASCP is event-driven. The draft spec defines exact payloads for:

- session lifecycle events
- run lifecycle events
- transcript events
- tool activity events
- terminal fallback events
- approval events
- artifact and diff events
- sync and connectivity events
- error events

Replay matters. Implementations that advertise replay support are expected to preserve ordering, support cursor-based recovery, and distinguish snapshot state from replayed history.

## Security And Compatibility

The protocol defines vendor-neutral hooks for:

- actor identity
- device identity
- scopes and permissions
- audit correlation
- approval attribution

The current compatibility ladder is:

- `ASCP Core Compatible`
- `ASCP Interactive`
- `ASCP Approval-Aware`
- `ASCP Artifact-Aware`
- `ASCP Replay-Capable`

## Repository Guidance

The repo now includes:

- [`AGENTS.md`](./AGENTS.md) for project-specific guidance to AI coding agents
- [`plans.md`](./plans.md) for the active scoped task list
- [`docs/status.md`](./docs/status.md) for checkpoint logging between sessions
- [`docs/README.md`](./docs/README.md) for a navigable documentation index
- [`docs/protocol-usage-and-dto-generation.md`](./docs/protocol-usage-and-dto-generation.md) for consumer guidance and schema-driven DTO generation options
- [`reference-client/README.md`](./reference-client/README.md) for the downstream proof client that consumes the frozen mock and schemas
- [`.agents/skills/`](./.agents/skills/) for reusable ASCP build skills
- [`mock-server/README.md`](./mock-server/README.md) for the deterministic proof mock

The detailed spec recommends growing the repository toward a protocol-first layout with documentation, schemas, examples, conformance fixtures, and a mock server before any product UI work.

## Suggested Build Order

The source documents are consistent on the early implementation sequence:

1. freeze scope and design principles
2. define canonical schemas
3. define capability and error documents
4. define request and response contracts
5. define exact event payloads
6. document replay semantics
7. document auth hooks and approval behavior
8. define extension rules
9. publish conformance fixtures and validators
10. build a mock server

## Local Skill Pack

The repo-local skill pack is focused on the main ASCP workstreams:

- `ascp-schema-foundation`
- `ascp-method-contracts`
- `ascp-event-replay`
- `ascp-auth-approvals`
- `ascp-conformance-mock-server`
- `ascp-documentation-discipline`
- `ascp-task-operating-system`

These are intended to help future agents keep protocol work aligned with the draft spec instead of drifting into product assumptions.

## Current Status

The protocol-first ASCP v0.1 workspace is complete on `main` for its intended repository scope.

Completed repository outputs now include:

- canonical schemas under `schema/`
- request, response, error, and event examples under `examples/`
- normative method, event, replay, auth, extension, and compatibility specs under `spec/`
- compatibility fixtures and validators under `conformance/`
- a deterministic proof implementation under `mock-server/`
- a downstream proof client under `reference-client/`
- a docs index and consumer guide under `docs/`

That does not make ASCP a frozen production standard. It means this repository now contains an implementation-ready protocol workspace for the published v0.1 contract set.

Any next branch should still be treated as optional downstream work or a future ASCP revision, not as unfinished protocol-core work hidden on `main`.
