# ASCP Task Plan

This file tracks the active scoped feature for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active Feature

- Feature name: Conformance
- Branch: `feature/conformance`
- Goal: turn the frozen ASCP v0.1 protocol contracts into evidence-backed compatibility claims through a compatibility matrix, golden example manifests, and a top-level conformance validator without reopening schema, method, event, replay, auth, or extension design
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/prompts/conformance.md`
  - `schema/ascp-core.schema.json`
  - `schema/ascp-capabilities.schema.json`
  - `schema/ascp-errors.schema.json`
  - `schema/ascp-methods.schema.json`
  - `schema/ascp-events.schema.json`
  - `spec/methods.md`
  - `spec/events.md`
  - `spec/replay.md`
  - `spec/auth.md`
  - `spec/extensions.md`
  - protocol examples under `examples/`
  - replay, auth, and extension fixtures under `conformance/fixtures/`
  - current chat requirements for the conformance slice only

## Bootstrap Outcome

- The repository-level workstream breakdown already exists.
- The dependency gate for conformance is met: schema foundation, method contracts, event contracts, replay semantics, auth and approvals, and extension rules are present on `main`.
- Existing branch outputs already provide schema-valid protocol nouns, request and response examples for the full core method surface, one example for every core event type, replay fixture manifests, auth and approval fixtures, and extension ignore-behavior fixtures.
- The remaining gap is the top-level conformance layer: there is no dedicated compatibility document, no machine-readable compatibility matrix, no golden example manifest spanning the compatibility ladder, and no repeatable harness that composes the earlier validators into evidence-backed compatibility claims.
- This branch starts from up-to-date `main` at commit `f5b281c`.

## Feature Boundary

Included in this branch:

- normative compatibility documentation in `spec/compatibility.md`
- a machine-readable compatibility matrix tied to exact methods, events, capabilities, and evidence paths
- golden example manifests covering requests, responses, events, replay flows, auth failures, and extension handling
- a top-level conformance validator and shell entrypoint that validate the compatibility claims and compose the existing contract validators
- checkpoint updates for this branch only

Explicitly out of scope:

- mock server runtime behavior or transport implementation
- new protocol nouns, method params, event payloads, or auth semantics
- reopening replay, extension, or approval rules except to detect and report a validation gap
- product client code, SDK code, or UI behavior
- vendor-specific compatibility programs beyond the ASCP v0.1 levels

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | rewrite the active branch plan for conformance | `plans.md` records the conformance branch, source inputs, dependency gate, feature boundary, task list, and acceptance criteria |
| done | add the normative compatibility document | `spec/compatibility.md` defines each compatibility level, the required methods, events, and capability evidence, and the evidence model for conformance claims |
| done | add machine-readable compatibility fixtures | `conformance/fixtures/compatibility/` contains a compatibility matrix and golden example manifests that point to concrete requests, responses, events, replay flows, auth failures, and extension fixtures |
| done | add a repeatable top-level conformance validator | `conformance/validators/compatibility.py`, `conformance/tests/validate_conformance.py`, and `scripts/validate_conformance.sh` validate the compatibility manifests, schema-backed golden examples, and composed upstream validators |
| done | verify conformance assets and checkpoint the branch | fresh conformance validation passes, `plans.md` is updated to reflect completion, and `docs/status.md` records the conformance checkpoint |

## Acceptance Criteria

The feature is complete only when all of the following are true:

- compatibility levels are explicit and consistent with the detailed spec and PRD
- schema validity is testable through the conformance harness
- method request and response validation is testable through the conformance harness
- event payload validation is testable through the conformance harness
- replay ordering and snapshot boundaries are testable through referenced replay fixtures and validation
- auth failure handling is testable through referenced auth fixtures and validation
- unknown extension ignore behavior is testable through referenced extension fixtures and validation
- compatibility claims are backed by concrete fixtures and validators rather than prose only

## Next Likely Step

After this branch is complete, the next feature should be `feature/mock-server`, using the conformance matrix and golden fixtures as stable inputs rather than redefining compatibility behavior inside the mock implementation.

## Completion Outcome

- Status: complete on `feature/conformance`
- Validation evidence: `./scripts/validate_conformance.sh` completed successfully and validated 5 compatibility levels, 7 golden scenarios, 76 schema-backed evidence files, and 5 composed validator scripts
- Merge target: `main`
- Recommended next branch after completion: `feature/mock-server`
- Recommended current scope:
  - evidence-backed compatibility claims tied to the frozen ASCP v0.1 contract surface
  - machine-readable golden manifests for request, response, event, replay, auth, and extension evidence
  - a top-level conformance harness that composes the existing contract validators without reopening upstream semantics
