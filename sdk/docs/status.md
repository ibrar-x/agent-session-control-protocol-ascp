# ASCP SDK Status Log

Use this file as a session-to-session checkpoint log. Each completed task should add a concise entry.

## Entry Template

### YYYY-MM-DD - Short Task Name

- Branch:
- Commit:
- Summary:
- Documentation updated:
- Next likely step:

## Entries

### 2026-04-24 - TypeScript SDK transport layer

- Branch: `feature/typescript-sdk-transport`
- Commit: `not committed`
- Summary: added a transport entry point for the TypeScript SDK with shared request and subscription contracts, implemented persistent stdio and WebSocket adapters, normalized transport-level failures into `AscpTransportError`, and covered the new surface with focused runtime and type-level tests including stdio mock-server integration
- Documentation updated: `plans.md`, `README.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/sdk-build-roadmap.md`, `docs/status.md`, `docs/branches/typescript-sdk-transport.md`, `typescript/README.md`, `typescript/package.json`
- Next likely step: create `feature/typescript-sdk-client` from updated `main` and build typed ASCP method wrappers on top of `ascp-sdk-typescript/transport` plus `ascp-sdk-typescript/validation` instead of re-implementing request execution or transport error handling

### 2026-04-24 - TypeScript SDK validation layer

- Branch: `feature/typescript-sdk-validation`
- Commit: `not committed`
- Summary: added an AJV-backed validation entry point for the TypeScript SDK, vendored the upstream ASCP schema set into the package, exposed safe parse and assert helpers for core entities, method responses, and event envelopes, and covered the new surface with focused runtime and type-level tests
- Documentation updated: `plans.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/status.md`, `docs/branches/typescript-sdk-validation.md`, `typescript/README.md`
- Next likely step: create `feature/typescript-sdk-transport` from updated `main` and build stdio plus WebSocket transport primitives on top of `ascp-sdk-typescript/validation` instead of re-implementing payload checks

### 2026-04-24 - SDK branch documentation discipline

- Branch: `feature/sdk-branch-documentation`
- Commit: `not committed`
- Summary: added a dedicated branch reference for the completed TypeScript SDK foundation work and updated the prompt pack plus roadmap so every future SDK branch must document usage, rationale, alternatives, verification evidence, limitations, and handoff context before closeout
- Documentation updated: `plans.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/status.md`, `docs/sdk-build-roadmap.md`, `docs/prompts/README.md`, `docs/prompts/typescript-sdk-foundation.md`, `docs/prompts/typescript-sdk-validation.md`, `docs/prompts/typescript-sdk-transport-client.md`, `docs/prompts/dart-sdk-planning.md`, `docs/branches/typescript-sdk-foundation.md`, `typescript/README.md`
- Next likely step: create `feature/typescript-sdk-validation` from updated `main` and use the new foundation branch reference plus validation prompt to implement schema-backed parsing without restructuring the package

### 2026-04-23 - TypeScript SDK foundation

- Branch: `feature/typescript-sdk-foundation`
- Commit: `not committed`
- Summary: scaffolded the TypeScript SDK package with an installable package baseline, explicit root and subpath exports, authored core protocol models and request/event/error surfaces, reserved directories for later validation/transport/replay/auth work, and baseline runtime plus type-level checks
- Documentation updated: `plans.md`, `README.md`, `docs/project-context-reference.md`, `docs/status.md`, `docs/prompts/typescript-sdk-foundation.md`, `docs/prompts/typescript-sdk-validation.md`, `docs/prompts/typescript-sdk-transport-client.md`, `docs/prompts/dart-sdk-planning.md`, `typescript/README.md`
- Next likely step: create `feature/typescript-sdk-validation` from updated `main` and add schema loading, AJV-backed validators, and validation error formatting on top of the existing foundation package shape

### 2026-04-22 - SDK repository bootstrap

- Branch: `feature/sdk-repo-bootstrap`
- Commit: `not committed`
- Summary: bootstrapped the downstream ASCP SDK workspace with SDK-only repository rules, an active plan, a resumable status log, a docs index, an end-to-end SDK delivery roadmap, prompt starters for the first workstreams, a local SDK skill pack, and placeholder roots for the TypeScript-first package layout
- Documentation updated: `AGENTS.md`, `README.md`, `plans.md`, `docs/README.md`, `docs/project-context-reference.md`, `docs/repo-operating-system.md`, `docs/sdk-build-roadmap.md`, `docs/status.md`, `docs/prompts/README.md`, `docs/prompts/typescript-sdk-foundation.md`, `docs/prompts/typescript-sdk-validation.md`, `docs/prompts/typescript-sdk-transport-client.md`, `docs/prompts/dart-sdk-planning.md`, `typescript/README.md`, `dart/README.md`
- Next likely step: create `feature/typescript-sdk-foundation` from updated `main` and scaffold the initial TypeScript package structure, model strategy, and public exports without widening into transport or client work
