---
name: ascp-schema-foundation
description: Use when creating or revising ASCP core schemas, capability documents, enum sets, or canonical protocol objects from the detailed specification.
---

# ASCP Schema Foundation

## Overview

Use this skill when protocol work touches the canonical ASCP nouns or their JSON Schema representation. The goal is to keep schemas minimal, explicit, and aligned with the detailed spec.

## Focus Areas

- `Host`, `Runtime`, `Session`, `Run`
- `ApprovalRequest`, `Artifact`, `DiffSummary`, `EventEnvelope`
- capability flags
- enums, required fields, optional fields
- RFC3339 UTC timestamps

## Working Rules

- Start from `ASCP_Protocol_Detailed_Spec_v0_1.md`, not intuition.
- Preserve exact enum names from the spec.
- Prefer additive fields over shape changes.
- Keep `additionalProperties` permissive unless the spec explicitly tightens behavior.
- Use schema examples that reflect realistic session-control flows.
- Validate examples against the schema before claiming the change is done.

## Common Failure Modes

- mixing product metadata into core protocol entities
- making optional fields required without a versioning reason
- changing field names for style rather than compatibility
- inventing new status values or capability flags outside extensions

## Done Criteria

The work is complete when the schema, examples, and documented field rules all agree with the detailed spec and no client has to guess entity meaning.
