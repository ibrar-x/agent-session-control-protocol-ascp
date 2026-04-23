---
name: ascp-typescript-sdk-transport-client
description: Use when building or revising the TypeScript SDK transport adapters, subscription flow, method wrappers, or protocol error normalization.
---

# ASCP TypeScript SDK Transport And Client

## Overview

Use this skill for the executable TypeScript SDK surface. The objective is to make the SDK usable against the ASCP mock server and future host surfaces without turning it into a daemon or adapter.

## Focus Areas

- stdio transport
- WebSocket transport
- request and response flow
- subscribe and unsubscribe flow
- typed method wrappers
- protocol error normalization

## Working Rules

- Keep transport replaceable.
- Keep method names and params aligned with upstream specs.
- Use the parent mock server as the first integration target.
- Respect capability advertisement rather than inventing fallback behavior.
- Do not mix cache or UI concerns into the SDK.

## Review Checklist

- Does the transport stay independent of package consumers?
- Do the client wrappers match the upstream method surface exactly?
- Are errors normalized without hiding the original protocol details?
- Can the mock server be exercised end to end through the SDK?

## Done Criteria

The work is complete when another implementer can use the SDK to call core ASCP methods and subscribe to events without hand-writing transport and envelope logic.
