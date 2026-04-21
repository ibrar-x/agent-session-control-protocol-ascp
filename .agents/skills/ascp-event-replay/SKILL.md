---
name: ascp-event-replay
description: Use when working on ASCP event payloads, session streaming, reconnect behavior, cursor handling, sequence rules, or replay semantics.
---

# ASCP Event Replay

## Overview

Use this skill when touching the live stream side of ASCP. Events are the protocol's observable state surface, so ordering, payload stability, and reconnect semantics matter more than convenience.

## Event Areas

- session lifecycle events
- run lifecycle events
- transcript events
- tool activity events
- terminal fallback events
- approval events
- artifact and diff events
- sync and connectivity events
- error events

## Replay Rules

- `EventEnvelope` is mandatory for streamed events.
- `seq` should be monotonic per session stream.
- replay preserves original ordering where ordering exists
- snapshots describe current state and must not masquerade as history
- clients may resume from `from_seq`, `from_event_id`, or an opaque cursor when supported
- if replay cannot be supported safely, advertise `replay=false`

## Common Failure Modes

- emitting partial payload shapes that differ from the spec
- mixing live snapshots with replayed history
- reusing sequence numbers
- treating PTY fallback as an excuse to avoid normalized event envelopes

## Done Criteria

The work is complete when a reconnecting client can recover session state and continue consuming the stream without guessing ordering or event meaning.
