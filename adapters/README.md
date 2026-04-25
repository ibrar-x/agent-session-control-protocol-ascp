# Adapters

Runtime-specific ASCP integrations live here.

Dependency rule:

- adapters may depend on `protocol/`, `packages/`, and `sdks/`
- adapters must not be depended on directly by apps; app-facing consumption should flow through SDK or service boundaries

Current placeholders:

- `codex/`
- `claude/`
- `gemini/`
