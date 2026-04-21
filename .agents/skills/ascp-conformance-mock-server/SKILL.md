---
name: ascp-conformance-mock-server
description: Use when building ASCP compatibility levels, schema fixtures, validators, golden examples, conformance tests, or a mock protocol server.
---

# ASCP Conformance And Mock Server

## Overview

Use this skill when turning the written protocol into something another team can test against. A protocol is only real when independent implementations can validate behavior consistently.

## Output Types

- compatibility matrix
- schema-valid fixtures
- golden request, response, and event examples
- replay test cases
- auth failure tests
- extension ignore-behavior tests
- mock server behavior notes

## Compatibility Targets

- `ASCP Core Compatible`
- `ASCP Interactive`
- `ASCP Approval-Aware`
- `ASCP Artifact-Aware`
- `ASCP Replay-Capable`

## Working Rules

- Publish concrete fixtures, not only prose.
- Validate examples against schemas.
- Test replay ordering and snapshot boundaries explicitly.
- Verify unknown extensions are ignored safely.
- Keep the mock server aligned with the detailed spec rather than runtime-specific shortcuts.

## Common Failure Modes

- claiming compatibility without listing supported methods and events
- omitting replay retention behavior
- building a mock server that invents undocumented payload fields
- treating conformance as a future concern

## Done Criteria

The work is complete when another implementer can run fixtures and tests against an ASCP surface and determine compatibility level without informal interpretation.
