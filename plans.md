# ASCP Task Plan

This file tracks the active scoped work for the current branch.

## Planning Rules

- One active feature per branch.
- Update this file before implementation starts.
- Keep the plan scoped to the current feature only.
- Record the source documents that define the work.
- Mark task status as work progresses so a new session can resume cleanly.

## Active State

- Feature name: Protocol interaction contract for blocked approvals and blocked input
- Branch: `branch-protocol-interaction-contract`
- Goal: extend the protocol so mobile and other clients can receive actionable approval and input requests from any adapter while keeping existing core method names and preserving truthful adapter-specific translation boundaries
- Source inputs:
  - `AGENTS.md`
  - `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
  - `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
  - `protocol/spec/auth.md`
  - `protocol/spec/methods.md`
  - `protocol/spec/events.md`
  - `plans.md`
  - `docs/status.md`
  - `adapters/codex/src/approvals.ts`
  - `adapters/codex/src/service.ts`

## Scope

Included in this branch:

- define additive protocol support for blocked interaction requests without changing existing core method names
- extend the protocol core approval contract with normative provenance and actionability rules
- add a canonical `InputRequest` noun and related session and event surfaces
- document the translation boundary so adapters, not the host, derive actionable requests from runtime-native blocked state
- update protocol examples, schemas, and validation assets so future adapter authors can implement the contract without reading Codex-specific code

Explicitly out of scope:

- Codex adapter translation logic
- host-service implementation work
- browser console or mobile app UI work
- new top-level core method names such as `respondToApproval` or `respondToInput`
- non-additive protocol redesign

## Planned Files

Files to add or modify:

- `plans.md`
- `docs/status.md`
- `docs/superpowers/specs/2026-04-27-interaction-contract-design.md`
- `protocol/schema/ascp-core.schema.json`
- `protocol/schema/ascp-methods.schema.json`
- `protocol/schema/ascp-events.schema.json`
- `protocol/spec/auth.md`
- `protocol/spec/methods.md`
- `protocol/spec/events.md`
- `protocol/spec/compatibility.md`
- `protocol/examples/requests/`
- `protocol/examples/responses/`
- `protocol/examples/events/`
- `protocol/examples/errors/`
- `protocol/conformance/`
- `sdks/typescript/src/models/types.ts`
- `sdks/typescript/src/methods/types.ts`
- `sdks/typescript/src/events/types.ts`
- `sdks/typescript/src/validation/`

## Tasks

| Status | Task | Acceptance Criteria |
| --- | --- | --- |
| completed | define interaction-contract design | written design covers approval provenance, input request shape, lifecycle events, actionability rules, and adapter translation boundaries |
| completed | patch protocol schemas and specs | protocol schemas, method contracts, event contracts, and auth semantics validate the new interaction surfaces without changing existing core method names |
| completed | patch protocol examples and conformance assets | request, response, and event examples plus validation fixtures prove the new protocol surfaces unambiguously |
| completed | update TypeScript SDK protocol models | SDK types and bundled validation schemas expose the new core nouns and result fields cleanly |
| completed | document and checkpoint protocol patch | plans and status log explain the new contract and prepare the follow-up adapter branch |

## Acceptance Criteria

The task is done only when all of the following are true:

- `ApprovalRequest` provenance and actionability rules are explicit and schema-backed
- `InputRequest` is defined once in the protocol layer with clear lifecycle semantics
- `sessions.get` can surface pending blocked inputs without introducing new core method names
- adapter translation responsibility is documented as adapter-specific, not host-specific
- examples and validators make the contract implementable for a second adapter author without reading Codex code

## Next Likely Step

Merge the protocol interaction-contract patch into `main`, then start a fresh adapter branch from updated `main` to implement Codex translation and response routing against the frozen protocol contract.
