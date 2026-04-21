# Extensions Starter Prompt

Use this prompt to start the `extensions` workstream for ASCP.

```md
You are starting the ASCP `extensions` workstream in `/Users/ibrar/Desktop/infinora.noworkspace/agent-session-control-protocol-ascp`.

This workstream locks down how vendors extend ASCP without redefining core semantics. Keep the work narrow and protocol-first.

## Branch

- Preferred branch strategy: keep this as a bounded refinement on the active contract-hardening branch if the work is small
- If the extension work becomes materially separate, use feature branch: `feature/extensions`
- Start from the latest `main`

## Bootstrap From Repository State First

Read these files before planning or implementation:

1. `AGENTS.md`
2. `plans.md`
3. `docs/status.md`
4. `ASCP_Protocol_Detailed_Spec_v0_1.md`
5. `ASCP_Protocol_PRD_and_Build_Guide.md`
6. `README.md`
7. `docs/repo-operating-system.md`

Then read upstream outputs if they exist:

- canonical schemas under `schema/`
- method contract outputs
- event contract outputs
- capability document outputs
- any existing extension-related docs or examples

When reading the specs, focus first on:

- detailed spec sections 12, 13, 14, 16, and 17
- PRD sections 12, 13, 16, 17, 18, and 19

## Dependency Gate

This workstream depends on schema foundation, method contracts, and event contracts.

If those outputs are missing or unstable, stop and report that the dependency gate is not met. Do not define extension handling against a moving core contract.

## Feature Boundary

Stay inside:

- extension rules
- namespacing rules
- capability advertisement for extensions
- unknown-extension handling
- extension examples and ignore-safe fixtures

Do not move ahead into:

- vendor-specific feature design
- new core semantics disguised as extension work
- mock server or conformance implementation beyond minimal fixtures needed for extension behavior

## Required Deliverables

Create or update the assets needed to make extension handling explicit:

- extension rules documentation
- namespaced examples for methods, events, fields, and capability flags
- fixtures showing safe handling of unknown extension fields and events
- capability advertisement examples for active extensions

Prefer repository locations such as:

- `docs/`
- `examples/`
- `conformance/fixtures/`

## Acceptance Criteria

The work is done only when:

- extension rules are explicit and consistent
- extensions do not redefine core semantics
- namespacing guidance is concrete enough to implement
- unknown extension behavior is explicit and safe by default
- the work can support later conformance checks without reopening core semantics

## Working Rules

- Preserve the boring core protocol
- Keep extension semantics additive
- Do not let extension examples silently mutate core fields
- Update `plans.md` before implementation
- Add a checkpoint entry to `docs/status.md` when complete

## What To Report Before Coding

After bootstrap, report:

1. whether upstream core contract outputs are present and stable enough
2. whether this work should stay on an adjacent branch or become `feature/extensions`
3. which docs and fixtures you will add or modify

Then implement only the extensions slice.
```
