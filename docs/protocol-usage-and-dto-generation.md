# Using ASCP

ASCP is a vendor-neutral control plane for discovering hosts and runtimes, inspecting long-running sessions, steering those sessions, responding to approvals, and retrieving artifact or diff metadata. The protocol is useful anywhere a client needs to observe and control an agent runtime without depending on a product-specific UI.

## Where ASCP Fits

Typical uses include:

- desktop and mobile session viewers that need discovery, resume, replay, and live event subscriptions
- hosted control planes that normalize different agent runtimes behind one method and event surface
- QA and conformance harnesses that need deterministic fixtures and replay-safe event streams
- SDKs or adapters that translate ASCP sessions into local typed models for higher-level applications

## Typical Consumer Flow

1. call `capabilities.get`
2. inspect the host, runtime list, and capability flags
3. call `sessions.list` or `sessions.get`
4. subscribe with `sessions.subscribe` for live events and replay
5. send user steering with `sessions.send_input`
6. inspect approvals, artifacts, and diffs when the capability document advertises them

The mock on this branch is designed to exercise that exact control flow with deterministic responses.

## Working With The Schemas

The schema files under [`../schema/`](../schema/) are the source for DTO generation:

- `ascp-core.schema.json`
- `ascp-capabilities.schema.json`
- `ascp-errors.schema.json`
- `ascp-methods.schema.json`
- `ascp-events.schema.json`

For most consumers, generate DTOs from these files and keep protocol transport code separate from the generated model layer.

## DTO generation

There are several workable approaches depending on the target language.

### TypeScript

Use [`json-schema-to-typescript`](https://github.com/bcherny/json-schema-to-typescript) when you want interfaces or types from the published schema files.

```bash
npx json-schema-to-typescript schema/ascp-core.schema.json > generated/ascp-core.d.ts
npx json-schema-to-typescript schema/ascp-methods.schema.json > generated/ascp-methods.d.ts
npx json-schema-to-typescript schema/ascp-events.schema.json > generated/ascp-events.d.ts
```

### Multi-language DTOs

Use [`quicktype`](https://github.com/glideapps/quicktype) when you need DTOs for multiple languages from the same schema sources.

```bash
quicktype --src schema/ascp-core.schema.json --src-lang schema --lang typescript --out generated/ascp-core.ts
quicktype --src schema/ascp-events.schema.json --src-lang schema --lang swift --out generated/ASCPEvents.swift
```

### Python models

Use [`datamodel-code-generator`](https://github.com/koxudaxi/datamodel-code-generator) when you want Pydantic models from the schema files.

```bash
datamodel-codegen --input schema/ascp-core.schema.json --input-file-type jsonschema --output generated/ascp_core_models.py
datamodel-codegen --input schema/ascp-methods.schema.json --input-file-type jsonschema --output generated/ascp_method_models.py
```

## Practical DTO Strategy

The cleanest setup for most consumers is:

- generate DTOs from the frozen schema files
- keep a thin transport adapter that reads and writes ASCP JSON envelopes
- map transport envelopes to generated DTOs close to the edge
- treat extensions as additive fields or namespaced event types so core DTOs stay stable

## Notes On Schema Shape

The repository uses `$defs` heavily. Some generators emit one file per root schema, while others flatten or inline definitions. If your tool cannot target `$defs` cleanly, generate from the whole schema file first and then add a thin handwritten wrapper layer around the DTOs you actually expose to application code.

## Recommended Repository Usage

- use `examples/` for golden sample payloads during consumer development
- use `conformance/` to verify compatibility claims
- use `mock-server/` when you want a deterministic executable surface for client integration work

This keeps the protocol source of truth in the schemas and specs, while generated DTOs remain a convenience layer rather than a competing definition of ASCP.
