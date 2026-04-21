---
name: ascp-auth-approvals
description: Use when defining ASCP approval flows, auth hooks, scopes, actor attribution, or security-sensitive method behavior.
---

# ASCP Auth And Approvals

## Overview

Use this skill for the protocol security surface. ASCP does not mandate one auth vendor, but it does require predictable hooks for identity, authorization, and approval attribution.

## Focus Areas

- approval request and response objects
- approval event flow
- actor and device attribution
- correlation IDs
- scope checks for sensitive methods
- `UNAUTHORIZED` vs `FORBIDDEN`

## Sensitive Methods

Treat these as explicit control operations:

- `sessions.start`
- `sessions.resume`
- `sessions.stop`
- `sessions.send_input`
- `approvals.respond`

## Working Rules

- Keep auth vendor-neutral.
- Document recommended scopes clearly.
- Attribute approval outcomes to `actor_id`, and where supported `device_id` and `correlation_id`.
- Keep approval state transitions explicit and auditable.
- Protect artifact access when session output may expose code or sensitive data.

## Common Failure Modes

- collapsing auth and approval into one vague concept
- returning `FORBIDDEN` when auth is actually missing
- omitting attribution from high-risk control actions
- leaving approval payload risk unclear

## Done Criteria

The work is complete when a host implementer can plug ASCP into an auth layer and produce auditable approval behavior without inventing missing protocol hooks.
