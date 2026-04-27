# Docs Restructure Design Spec

**Date:** 2026-04-27
**Status:** Approved

## Summary

Restructure all ASCP documentation to separate user-facing, developer-facing, and internal content. Move all public-facing docs to the `apps/web` Next.js docs site with clear Learn / Reference / Build sections. Move internal agent workflow assets to a dedicated `internal/` repo directory.

## Motivation

- Current docs mix user and developer content in the same files, creating confusion
- No clear flow or direction — readers don't know what to read first
- Internal AI agent prompts, plans, and status logs are interleaved with public docs
- Redundancy exists between `docs/` and `apps/web/content/docs/`

## Architecture

```
apps/web/content/docs/
├── index.mdx              # Landing with Learn / Reference / Build cards
├── learn/                 # USER-FACING
│   ├── 01-what-is-ascp.mdx
│   ├── 02-quick-start.mdx
│   ├── 03-core-concepts/
│   ├── 04-sdk-guides/
│   └── 05-ecosystem/
├── reference/             # DEVELOPER-FACING (protocol contracts)
│   ├── 01-methods.mdx
│   ├── 02-events.mdx
│   ├── 03-errors.mdx
│   ├── 04-schemas.mdx
│   ├── 05-auth-approvals.mdx
│   ├── 06-replay-streaming.mdx
│   ├── 07-extensions.mdx
│   └── 08-conformance.mdx
└── build/                 # DEVELOPER-FACING (implementation)
    ├── 01-typescript-sdk.mdx
    ├── 02-dart-sdk.mdx
    ├── 03-adapters.mdx
    ├── 04-mock-server.mdx
    ├── 05-contributing.mdx
    └── 06-architecture.mdx

internal/                  # REPO-ONLY, never in website
├── README.md
├── plans.md
├── status.md
├── repo-operating-system.md
├── prompts/
└── superpowers/
    ├── specs/
    └── plans/
```

## Navigation Rules

1. Learn → can link to Reference with visual badge `[Technical Reference →]`
2. Reference → can link to Build with visual badge `[Implementation Guide →]`
3. Build → can link to Reference for protocol details
4. Learn NEVER links to Build
5. Internal content is never served by the website

## Migration Plan

| Source | Destination |
|--------|-------------|
| `docs/README.md` | `apps/web/.../index.mdx` + `internal/README.md` |
| `docs/project-context-reference.md` | `apps/web/.../build/06-architecture.mdx` |
| `docs/protocol-usage-and-dto-generation.md` | `apps/web/.../build/01-typescript-sdk.mdx` |
| `docs/schema-foundation.md` | `apps/web/.../reference/04-schemas.mdx` |
| `docs/repo-operating-system.md` | `internal/repo-operating-system.md` |
| `docs/status.md` | `internal/status.md` |
| `docs/architecture/system-design.md` | `apps/web/.../build/06-architecture.mdx` |
| `docs/architecture/dependency-graph.md` | `apps/web/.../build/06-architecture.mdx` |
| `docs/prompts/*` | `internal/prompts/*` |
| `docs/superpowers/*` | `internal/superpowers/*` |
| `plans.md` | `internal/plans.md` |
| `apps/web/.../getting-started/*` | `apps/web/.../learn/` |
| `apps/web/.../core-concepts/*` | `apps/web/.../learn/03-core-concepts/` |
| `apps/web/.../api-reference/*` | `apps/web/.../reference/` |
| `apps/web/.../authentication/*` | `apps/web/.../reference/05-auth-approvals.mdx` |
| `apps/web/.../advanced/*` | `apps/web/.../reference/` |
| `apps/web/.../contributing/*` | `apps/web/.../build/05-contributing.mdx` |
| `apps/web/.../ecosystem/*` | `apps/web/.../learn/05-ecosystem/` |
| `apps/web/.../sdks/*` | `apps/web/.../build/` |
| Root `opencode_*.png` | `apps/web/public/images/` |

## What Gets Removed

- `docs/` directory (fully cleaned up)
- Root-level design screenshots and `.txt` files (moved to website assets)
- Old website section directories after migration

## Reference Updates

All files referencing old paths will be updated:
- `AGENTS.md` → `internal/status.md`, `internal/plans.md`
- `README.md` → website link, `internal/README.md`
- `internal/plans.md` → `internal/status.md`, `internal/superpowers/`
- `internal/status.md` → `internal/superpowers/`
- Prompt files → `internal/prompts/*` paths
- Website MDX files → `learn/`, `reference/`, `build/` paths
- Package/Adapter READMEs → website paths or `internal/` as appropriate

## Acceptance Criteria

- [ ] Learn / Reference / Build sections exist in `apps/web/content/docs/`
- [ ] `internal/` directory contains all internal workflow files
- [ ] `docs/` directory is removed
- [ ] No user is presented with mixed user+developer content in the same page
- [ ] Website landing page shows clear Learn / Reference / Build entry points
- [ ] Internal content is not reachable from the website
- [ ] All internal references (file paths in markdown) updated
- [ ] Website sidebar navigation reflects three clean sections
- [ ] `AGENTS.md` and `README.md` reference correct paths
