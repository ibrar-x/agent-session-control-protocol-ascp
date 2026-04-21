---
name: ascp-method-contracts
description: Use when defining or updating ASCP JSON-RPC methods, request and response envelopes, validation behavior, or method-level error handling.
---

# ASCP Method Contracts

## Overview

Use this skill for the ASCP control-plane methods. The objective is to keep the method surface small, exact, and portable across hosts and runtimes.

## Core Surface

- `capabilities.get`
- `hosts.get`
- `runtimes.list`
- `sessions.list`
- `sessions.get`
- `sessions.start`
- `sessions.resume`
- `sessions.stop`
- `sessions.send_input`
- `sessions.subscribe`
- `sessions.unsubscribe`
- `approvals.list`
- `approvals.respond`
- `artifacts.list`
- `artifacts.get`
- `diffs.get`

## Working Rules

- Use JSON-RPC 2.0 envelopes where request/response semantics apply.
- Echo request `id` in success or error responses.
- Never return both `result` and `error`.
- Keep request params explicit and bounded.
- Map failures into the published ASCP error catalog instead of inventing ad hoc errors.
- Respect capability advertisement. Unsupported behavior should surface as `UNSUPPORTED`, not silent omission.

## Review Checklist

- Are required params explicit?
- Are optional params documented?
- Is the success payload normalized?
- Are expected error codes listed?
- Does the method preserve transport neutrality?

## Done Criteria

The work is complete when another implementer can build the method without guessing request shape, response shape, or failure semantics.
