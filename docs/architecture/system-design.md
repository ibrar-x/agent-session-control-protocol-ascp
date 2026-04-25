# ASCP Monorepo System Design

## Summary

The repository is organized as a modular monorepo with a protocol-first dependency flow:

`protocol -> packages -> sdks -> adapters -> apps`

`services/` hosts executable infrastructure such as the deterministic mock server. `tooling/` hosts orchestration and validation entrypoints that operate across the tree.

## Module Roles

- `protocol/`: canonical schemas, detailed spec, PRD/build guide, examples, and conformance evidence
- `packages/`: future shared implementation modules that stay downstream of protocol truth and upstream of language/runtime packages
- `sdks/`: language bindings and SDK-specific docs
- `adapters/`: runtime integrations that translate external agent systems into ASCP
- `apps/`: user-facing or proof-client application surfaces
- `services/`: backend or testable executable surfaces such as the mock server
- `tooling/`: scripts and orchestration config
- `docs/`: repo-level architecture, workflow, and continuation docs

## Boundary Rules

- `protocol/` is the single source of truth for ASCP contracts.
- `packages/` may consume protocol assets but must not depend on SDK, adapter, app, or service modules.
- `sdks/` expose language-specific consumption layers over protocol contracts and shared packages.
- `adapters/` sit downstream of SDKs and shared packages; they do not redefine protocol semantics.
- `apps/` consume stable SDK surfaces and should avoid direct adapter coupling.
- `services/` may exercise protocol assets directly when they are protocol-facing infrastructure.

## Current Implementation Notes

- The existing TypeScript and Dart SDKs were moved under `sdks/` without widening their public behavior.
- The deterministic mock server now lives under `services/mock-server/`.
- The downstream proof client now lives under `apps/reference-client/`.
- Root workspace orchestration is intentionally light: npm workspaces cover Node-based modules, `melos` covers the Dart package, and shell validators keep protocol and Python surfaces executable.
