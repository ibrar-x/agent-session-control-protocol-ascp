# ASCP Task Plan

This file tracks the active scoped feature for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active Feature

- Feature name: Extensions
- Branch: `feature/extensions`
- Goal: make ASCP extension rules, namespacing expectations, capability advertisement, and ignore-safe behavior explicit and testable on top of the frozen schema, method, event, replay, and auth contracts without widening into vendor-specific feature design or mock-server logic
- Source inputs:
  - `AGENTS.md`
  - `plans.md`
  - `docs/status.md`
  - `ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `ASCP_Protocol_PRD_and_Build_Guide.md`
  - `README.md`
  - `docs/repo-operating-system.md`
  - `docs/prompts/extensions.md`
  - `docs/superpowers/specs/2026-04-22-extensions-design.md`
  - `spec/methods.md`
  - `spec/events.md`
  - `spec/replay.md`
  - `spec/auth.md`
  - `schema/ascp-core.schema.json`
  - `schema/ascp-capabilities.schema.json`
  - `schema/ascp-methods.schema.json`
  - `schema/ascp-events.schema.json`
  - capability-, method-, event-, and auth-related examples under `examples/`
  - current chat requirements for the extensions slice only

## Bootstrap Outcome

- The repository-level workstream breakdown already exists.
- The dependency gate for extensions is met: schema foundation, method contracts, event contracts, replay semantics, and auth hooks are present and merged on `main`.
- Frozen upstream contracts already provide the open capability document, open core entities, flexible request and event envelopes, and closed method-param and core-event-payload schemas that extension rules must respect.
- Existing extension material is limited to brief spec text and one capability example; there is no dedicated normative extension document, no focused extension fixture set, and no extension-specific validator yet.
- This branch starts from up-to-date `main` at commit `ad1f483`.

## Feature Boundary

Included in this branch:

- normative extension semantics in `spec/extensions.md`
- concrete namespacing rules for extension methods, events, fields, and capability flags
- capability advertisement guidance for active extensions
- explicit unknown-extension handling rules
- explicit documentation of open additive surfaces versus closed frozen schemas
- extension-focused examples and minimal conformance validation

Explicitly out of scope:

- vendor-specific extension feature design or policy behavior
- transport-level extension negotiation or discovery handshakes
- mock-server runtime logic beyond what is needed to express fixtures
- reopening frozen core method params, core event payload contracts, or auth semantics unless a contradiction is discovered
- broader compatibility-matrix or mock-server work beyond the extensions slice

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| done | rewrite the active branch plan for extensions | `plans.md` records the extensions branch, source inputs, dependency gate, feature boundary, task list, and acceptance criteria |
| done | add the normative extensions document | `spec/extensions.md` defines extension rules, namespacing, capability advertisement, unknown handling, and the open-versus-closed schema boundary |
| done | add extension examples | `examples/capabilities/` and `examples/extensions/` contain concrete namespaced method, event, field, and capability examples aligned with the frozen schemas |
| done | add repeatable extension validation | `scripts/validate_extension_semantics.sh` and `conformance/tests/validate_extension_semantics.py` validate the extension fixture set and extension-specific invariants |
| done | verify extension assets and checkpoint the branch | fresh extension validation passes, `plans.md` is updated to reflect completion, and `docs/status.md` records the extensions checkpoint |

## Acceptance Criteria

The feature is complete only when all of the following are true:

- extension rules are explicit and consistent with the source specs
- namespacing guidance is concrete for methods, events, fields, and capability flags
- capability advertisement for active extensions is documented and illustrated
- unknown extension fields and unknown extension events are explicitly ignore-safe by default
- the open-versus-closed schema boundary is documented so later branches do not add inline fields to frozen core params or exact core event payloads
- resulting docs, examples, and fixtures are sufficient for later conformance work without reopening core semantics

## Next Likely Step

After this branch is complete, the next feature should be the broader `conformance` slice or `mock-server`, using the extension rules from this branch as stable inputs rather than reopening namespacing semantics.

## Completion Outcome

- Status: complete on `feature/extensions`
- Validation evidence: `./scripts/validate_extension_semantics.sh` completed successfully and validated 5 extension surfaces and 5 ignore-behavior rules
- Merge target: `main`
- Recommended next branch after completion: `feature/conformance` or `feature/mock-server`
- Recommended current scope:
  - extension rules, namespacing, and capability advertisement built on the frozen schema and contract surface
  - ignore-safe behavior for unknown extension fields and namespaced events
  - explicit open-versus-closed schema guidance for later conformance work
