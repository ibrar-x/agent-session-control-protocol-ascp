---
name: ascp-typescript-sdk-validation-replay
description: Use when building or revising the TypeScript SDK validation layer, event parsing, replay helpers, or schema-backed safety checks.
---

# ASCP TypeScript SDK Validation And Replay

## Overview

Use this skill when TypeScript SDK work touches schema validation, event envelopes, or replay helpers. The goal is to keep parsing safe, replay behavior faithful, and errors actionable.

## Focus Areas

- AJV setup
- schema loading or embedding
- entity validation
- method response validation
- event envelope validation
- replay cursor helpers
- snapshot versus replay handling

## Working Rules

- Use upstream schema files and replay specs as the source of truth.
- Preserve unknown extension fields unless strict mode is explicitly required.
- Distinguish validation failures from transport failures.
- Keep replay helpers thin and protocol-faithful.
- Use upstream examples and replay fixtures to prove behavior whenever practical.

## Common Failure Modes

- flattening replay semantics into vague convenience helpers
- discarding cursor information that downstream consumers may need
- losing extension fields during parsing
- returning validation errors that hide which schema rule failed

## Done Criteria

The work is complete when the TypeScript SDK can validate core ASCP payloads safely, parse event streams predictably, and support replay-oriented consumers without guessing protocol meaning.
