# ASCP Project Context Reference

## Summary

This repository is the ASCP monorepo. It keeps protocol truth, downstream SDKs, executable proof surfaces, and future adapter/app boundaries in one repository while preserving strict dependency direction.

## Source Of Truth

Read these first when protocol meaning matters:

1. `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
2. `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`

Use the detailed spec for exact contracts and the PRD/build guide for scope, sequencing, and repository shape.

## Current Layout

- `protocol/`: schemas, spec docs, examples, conformance fixtures/tests/validators
- `packages/`: placeholder shared modules for future common logic
- `sdks/`: TypeScript and Dart SDK workspaces plus SDK-specific docs
- `adapters/`: placeholder runtime integration boundaries
- `apps/reference-client/`: downstream proof client
- `services/mock-server/`: deterministic mock server
- `tooling/`: validation scripts and future generators
- `docs/`: architecture and repository operating docs

## Dependency Direction

`protocol -> packages -> sdks -> adapters -> apps`

Additional rules:

- `services/` may depend directly on `protocol/` when they are protocol infrastructure
- `tooling/` may orchestrate any module but should not become a runtime dependency

## What Already Exists

- complete ASCP v0.1 protocol assets under `protocol/`
- a TypeScript SDK under `sdks/typescript/`
- a Dart SDK under `sdks/dart/`
- a deterministic mock server under `services/mock-server/`
- a downstream proof client under `apps/reference-client/`
- a Codex adapter planning pack under `docs/prompts/codex-adapter.md` and `docs/superpowers/plans/2026-04-26-codex-adapter.md`

## Validation Entry Points

- `bash tooling/scripts/validate_method_contracts.sh`
- `bash tooling/scripts/validate_event_contracts.sh`
- `bash tooling/scripts/validate_replay_semantics.sh`
- `bash tooling/scripts/validate_auth_semantics.sh`
- `bash tooling/scripts/validate_extension_semantics.sh`
- `bash tooling/scripts/validate_conformance.sh`
- `bash tooling/scripts/validate_mock_server.sh`
- `bash tooling/scripts/validate_reference_client.sh`
- `npm --workspace sdks/typescript run check`

## Continuation Rules

- keep protocol changes inside `protocol/`
- keep shared reusable code out of apps and adapters when it belongs in `packages/`
- keep apps downstream of SDK surfaces
- do not silently redefine ASCP semantics inside SDKs, adapters, or services
