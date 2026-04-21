# Schema Foundation Starter Prompt

Use this prompt to start the `schema foundation` feature for ASCP.

```md
You are starting the ASCP `schema foundation` feature in `/Users/ibrar/Desktop/infinora.noworkspace/agent-session-control-protocol-ascp`.

This repository is protocol-first. Do not build UI, product behavior, or runtime-specific extras. Stay inside the schema foundation slice only.

## Branch

- Use feature branch: `feature/schema-foundation`
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

When reading the specs, focus first on:

- detailed spec sections 4, 5, 6, 11, 13, 14, 15, 16, and 17
- PRD sections 5, 6, 11, 12, 14, 16, 17, 18, and 19

## Feature Boundary

This feature is only for freezing the canonical protocol nouns and shared validation assets.

Stay inside:

- canonical object schemas
- shared envelope schema material
- capability schema
- error schema
- schema-valid examples for the core objects
- supporting documentation needed to anchor those schemas

Do not move ahead into:

- per-method request and response contract implementation
- event payload fixture expansion beyond what is needed for `EventEnvelope`
- replay flow implementation
- auth middleware behavior
- conformance harnesses
- mock server behavior

## Required Deliverables

Create or update the minimum assets needed for schema foundation:

- `schema/ascp-core.schema.json`
- `schema/ascp-capabilities.schema.json`
- `schema/ascp-errors.schema.json`
- schema-valid examples for `Host`, `Runtime`, `Session`, `Run`, `ApprovalRequest`, `Artifact`, `DiffSummary`, and `EventEnvelope`
- any supporting protocol docs required to explain scope, design-principle assumptions, or versioning assumptions used by the schemas

Prefer the repository shapes recommended by the specs if new directories are needed:

- `schema/`
- `examples/`
- `docs/`

## Acceptance Criteria

The feature is done only when:

- canonical objects from the detailed spec validate without guessing
- required fields, optional fields, enums, and exact field names match the detailed spec
- capability and error examples validate against their schemas
- unknown fields are handled in a way that preserves additive evolution and safe ignore behavior
- documentation is updated enough that a later agent can start method contracts without reconstructing schema intent from chat history

## Working Rules

- Treat `ASCP_Protocol_Detailed_Spec_v0_1.md` as the source of truth for exact shapes
- Use `ASCP_Protocol_PRD_and_Build_Guide.md` for repository shape and build intent
- Keep examples schema-valid
- Prefer explicit JSON objects and stable field names
- Do not redefine semantics through extensions
- Update `plans.md` for the active scoped task before implementation
- Add a checkpoint entry to `docs/status.md` when the task is complete

## What To Report Before Coding

After bootstrap, report:

1. whether the repository already contains any schema or example assets
2. the exact files you plan to add or modify
3. the narrow task list for this feature branch

Then implement only this slice.
```
