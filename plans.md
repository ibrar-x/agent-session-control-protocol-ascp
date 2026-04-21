# ASCP Task Plan

This file tracks the active scoped feature for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active Feature

- Feature name: Mock server
- Branch: `feature/mock-server`
- Goal: build a deterministic proof implementation of the frozen ASCP v0.1 method and event surface that reuses the repository's canonical schemas, examples, replay fixtures, auth fixtures, and conformance matrix instead of inventing new protocol behavior
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/prompts/mock-server.md`
  - canonical schemas under `schema/`
  - request, response, error, capability, and entity examples under `examples/`
  - replay, auth, extension, and compatibility fixtures under `conformance/fixtures/`
  - validators and harnesses under `conformance/validators/`, `conformance/tests/`, and `scripts/`
  - `spec/methods.md`
  - `spec/events.md`
  - `spec/replay.md`
  - `spec/auth.md`
  - `spec/extensions.md`
  - `spec/compatibility.md`
  - current chat requirements for the mock-server slice plus the tightly related docs index and protocol-usage guide

## Bootstrap Outcome

- The repository-level workstream breakdown already exists.
- The dependency gate for `feature/mock-server` is met on `main` at commit `a0cf6d7`: schema foundation, method contracts, event contracts, replay semantics, auth and approvals, extensions, and the top-level conformance matrix are already present.
- The repository already contains schema-valid capability, request, response, event, entity, replay, auth, extension, and compatibility fixtures that the mock can treat as frozen inputs.
- The remaining gap is an executable proof surface: there is no deterministic mock host, no replay-aware event stream implementation, no mock-server-specific validator, and no documentation that points protocol consumers at a concrete mock entrypoint.

## Feature Boundary

Included in this branch:

- deterministic mock fixture data for host, runtime, session, run, approval, artifact, and diff state
- a deterministic ASCP mock implementation under `mock-server/` that serves the frozen method surface over a simple JSON-RPC stdio transport
- sample event streams and replay behavior that align with the frozen event and replay specs
- a mock-server validator and shell entrypoint that prove the mock returns schema-valid responses and deterministic replay output
- mock-server documentation that explains supported behavior, transport assumptions, and out-of-scope areas
- a docs index plus one protocol usage and DTO-generation guide requested in the current chat

Explicitly out of scope:

- product UI, dashboards, or vendor-specific runtime behavior
- redefining protocol nouns, method shapes, events, replay semantics, auth semantics, or compatibility levels
- shipping SDK packages or generated DTOs for a particular language in this branch
- a broad documentation rewrite beyond the requested index and usage/codegen guide

## Planned Files

Expected new or updated paths for this branch:

- `mock-server/README.md`
- `mock-server/fixtures/`
- `mock-server/sample-event-streams/`
- `mock-server/src/mock_server/`
- `mock-server/tests/validate_mock_server.py`
- `scripts/validate_mock_server.sh`
- `docs/README.md`
- `docs/protocol-usage-and-dto-generation.md`
- `README.md`
- `plans.md`
- `docs/status.md`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | rewrite the active branch plan for mock-server | `plans.md` records the mock-server branch, source inputs, dependency gate, feature boundary, planned files, and acceptance criteria |
| done | add failing validator tests for the mock surface | a dedicated mock-server validator exists, fails before implementation, and checks discovery, session inspection, approval and artifact reads, subscription replay, and docs outputs |
| done | implement deterministic mock fixtures and stdio JSON-RPC behavior | `mock-server/` contains reusable fixtures, a deterministic mock implementation, sample event streams, and schema-valid method responses aligned with the frozen examples |
| done | add repeatable mock verification entrypoints | `scripts/validate_mock_server.sh` runs the mock-server validator cleanly and can be composed with the existing conformance harness |
| done | add scoped documentation for the mock and docs index | the repo has a docs index, a protocol usage and DTO-generation guide, and mock-server documentation that explains how consumers should use the proof implementation |
| done | verify the branch and checkpoint it | fresh validation passes, `plans.md` reflects completion, and `docs/status.md` records the mock-server checkpoint |

## Acceptance Criteria

The feature is complete only when all of the following are true:

- a client can call discovery methods and inspect sessions, approvals, artifacts, and diffs from the mock without guessing payload shapes
- the mock returns schema-valid method responses for the supported deterministic paths
- the mock emits deterministic event streams and replay output consistent with `spec/events.md`, `spec/replay.md`, and the compatibility fixtures
- snapshot versus replay boundaries are explicit and testable
- the mock stays proof-oriented and documents any deliberately unsupported or transport-specific behavior
- the docs index makes the current repository documentation navigable without hidden chat context
- the protocol usage guide explains how ASCP can be consumed and how DTOs can be generated from the schema files without turning this branch into a language-specific SDK project

## Next Likely Step

After this branch is complete, the next useful task should build on the mock as a protocol-consumer reference or expand conformance around real client interoperability without changing the frozen ASCP v0.1 contracts.

## Completion Outcome

- Status: complete on `feature/mock-server`
- Validation evidence: `./scripts/validate_mock_server.sh` completed successfully and validated 6 mock-server checks covering discovery, session reads, approval resolution, artifact and diff reads, replay-aware subscription output, CLI streaming, and documentation presence
- Documentation updated:
  - `plans.md`
  - `docs/status.md`
  - `README.md`
  - `docs/README.md`
  - `docs/protocol-usage-and-dto-generation.md`
  - `mock-server/README.md`
- Recommended next branch after completion: either a protocol-consumer reference client or additional interoperability coverage built on top of the mock without changing ASCP v0.1 contracts
