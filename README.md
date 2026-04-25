# Agent Session & Control Protocol (ASCP)

ASCP is a vendor-neutral, session-first control plane for discovering, observing, controlling, resuming, and approving long-running agent sessions across hosts, runtimes, clients, and adapters.

This repository is now organized as a production-grade monorepo with strict dependency direction:

`protocol -> packages -> sdks -> adapters -> apps`

## Monorepo Layout

```text
ascp/
├── protocol/
├── packages/
├── sdks/
├── adapters/
├── apps/
├── services/
├── tooling/
├── docs/
├── package.json
├── melos.yaml
└── turbo.json
```

## Current Modules

- [`protocol/`](./protocol/): canonical schemas, detailed spec, PRD/build guide, examples, and conformance assets
- [`packages/`](./packages/): shared-package placeholders for future common modules
- [`sdks/`](./sdks/): existing TypeScript and Dart SDK workspaces
- [`adapters/`](./adapters/): placeholder runtime-adapter boundaries for Codex, Claude, and Gemini
- [`apps/reference-client/`](./apps/reference-client/): downstream proof client
- [`apps/web/`](./apps/web/): placeholder future web app boundary
- [`services/mock-server/`](./services/mock-server/): deterministic protocol mock server
- [`tooling/`](./tooling/): validation wrappers and future generators
- [`docs/`](./docs/): repository architecture, workflow, and continuation docs

## Source Of Truth

When protocol meaning matters, start here:

1. [`protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`](./protocol/ASCP_Protocol_Detailed_Spec_v0_1.md)
2. [`protocol/ASCP_Protocol_PRD_and_Build_Guide.md`](./protocol/ASCP_Protocol_PRD_and_Build_Guide.md)

If they disagree, use the detailed spec for exact contracts and the PRD/build guide for scope, sequencing, and repository intent.

## Protocol Scope

ASCP covers:

- host and runtime discovery
- capability advertisement
- session list, get, start, resume, stop, and input submission
- live subscriptions and replay after reconnect
- approvals
- artifact and diff metadata
- auth hooks
- error semantics
- extensions and conformance

ASCP does not standardize model APIs, prompt formats, tool schemas, UI systems, agent planning internals, or vendor billing.

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

## Architecture Notes

- `protocol/` remains the single source of truth.
- `packages/` are scaffolded now so shared code has a dedicated home instead of leaking into SDKs or apps later.
- `sdks/` hold language bindings only.
- `adapters/` are downstream integration boundaries and are scaffold-only in this branch.
- `apps/` should consume SDKs rather than adapter internals.
- `services/` can depend directly on protocol truth when they are protocol-facing infrastructure.

## More Context

- [`docs/README.md`](./docs/README.md)
- [`docs/architecture/system-design.md`](./docs/architecture/system-design.md)
- [`docs/architecture/dependency-graph.md`](./docs/architecture/dependency-graph.md)
- [`docs/project-context-reference.md`](./docs/project-context-reference.md)
- [`AGENTS.md`](./AGENTS.md)
