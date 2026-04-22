# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Reference client
- Branch: `feature/reference-client`
- Goal: add a small deterministic downstream reference client that consumes the frozen ASCP v0.1 schemas, examples, and mock-server surface without redefining protocol behavior
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/protocol-usage-and-dto-generation.md`
  - `docs/prompts/reference-client.md`
  - `mock-server/README.md`
  - `schema/`
  - `examples/`
  - `spec/compatibility.md`
  - `conformance/fixtures/compatibility/`
  - `mock-server/`
  - `mock-server/tests/`
  - `conformance/tests/`
  - `scripts/`

## Dependency Check

- The upstream ASCP protocol workspace is complete and stable enough for downstream client work on this branch.
- Frozen inputs available for consumption:
  - canonical schemas under `schema/`
  - request, response, error, and event examples under `examples/`
  - compatibility notes and manifests under `spec/compatibility.md` and `conformance/fixtures/compatibility/`
  - deterministic executable mock surface under `mock-server/`
  - repeatable validators under `mock-server/tests/`, `conformance/tests/`, and `scripts/`
- No dependency gap blocks the reference-client slice.

## Planned Files

Files to add:

- `reference-client/README.md`
- `reference-client/src/reference_client/__init__.py`
- `reference-client/src/reference_client/client.py`
- `reference-client/src/reference_client/schema_validation.py`
- `reference-client/src/reference_client/stdio_transport.py`
- `reference-client/src/reference_client/demo.py`
- `reference-client/tests/validate_reference_client.py`
- `scripts/validate_reference_client.sh`

Files to update:

- `plans.md`
- `docs/status.md`
- `README.md`
- `docs/README.md`

## Scope

Included in this branch:

- a minimal stdio JSON-RPC transport for the existing mock server
- a small client layer for discovery, session reads, subscribe/replay, approvals, artifacts, and diffs
- schema-aware validation that proves the client is consuming published ASCP v0.1 contracts
- a repeatable demo or validator script for downstream usage
- documentation that explains what the reference client proves and what remains out of scope

Explicitly out of scope:

- protocol redesign
- new ASCP methods, events, schemas, or extensions
- a new runtime implementation parallel to the existing mock server
- production auth stacks
- multi-language SDK packaging

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | define the downstream client layout and branch plan | `plans.md` reflects this branch, confirms dependency stability, and lists the files plus acceptance criteria for the reference-client slice |
| done | add schema-aware failing tests for the downstream client flows | `reference-client/tests/validate_reference_client.py` failed first against missing client code and now covers discovery, session inspection, approvals/artifacts/diffs, and subscribe/replay behavior |
| done | implement the reference client and demo surface | `reference-client/src/reference_client/` talks to the existing mock-server stdio JSON-RPC surface and exposes the scoped flows without redefining ASCP contracts |
| done | document and validate the feature | `reference-client/README.md` and repo docs describe scope and limitations, `scripts/validate_reference_client.sh` passes, and `docs/status.md` records the completed checkpoint |

## Acceptance Criteria

The feature is done only when all of the following are true:

- the client can fetch capabilities and runtimes from the mock server
- the client can inspect sessions, approvals, artifacts, and diffs
- the client can subscribe, observe snapshot plus replay events, and capture the replay cursor
- the client validates consumed method responses and events against the published ASCP schemas
- the client remains strictly downstream of the frozen ASCP v0.1 contracts and documents its scope limits

## Next Likely Step

Merge this downstream proof-client slice to `main` and leave the repository clean on updated `main`. Any later follow-on work should stay explicitly downstream, such as richer SDK ergonomics or interoperability experiments.

## Completion Outcome

- Status: complete on `feature/reference-client`
- Validation evidence:
  - `./scripts/validate_reference_client.sh`
  - `./scripts/validate_mock_server.sh`
  - `PYTHONPATH="$PWD/reference-client/src" python3 -m reference_client.demo`
- Documentation updated:
  - `plans.md`
  - `docs/status.md`
  - `README.md`
  - `docs/README.md`
  - `reference-client/README.md`
