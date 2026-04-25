---
name: ascp-typescript-sdk-foundation
description: Use when creating or revising the TypeScript SDK package scaffold, typed model surface, export strategy, or schema-to-type generation approach.
---

# ASCP TypeScript SDK Foundation

## Overview

Use this skill for the TypeScript SDK foundation layer. The objective is to create a clean package shape that stays faithful to the upstream ASCP schemas and keeps later validation, transport, and replay work easy to add.

## Focus Areas

- package scaffold
- public export surface
- model organization
- generated versus hand-authored type strategy
- Node.js and TypeScript toolchain choices
- type tests or generation checks

## Working Rules

- Start from the upstream schema files and TypeScript SDK implementation plan.
- Keep protocol nouns and method names exact.
- Prefer thin helpers over convenience abstractions that hide ASCP semantics.
- Make the generation strategy explicit if types come from schema assets.
- Keep the future validation and transport layers from having to restructure the package immediately.

## Common Failure Modes

- inventing SDK-only DTO shapes that drift from upstream contracts
- coupling the model layer to a transport implementation
- hiding extension fields in a way that loses information
- optimizing for framework style instead of protocol fidelity

## Done Criteria

The work is complete when the package scaffold, model strategy, and public exports are explicit enough that validation and transport work can continue without rethinking the foundation.
