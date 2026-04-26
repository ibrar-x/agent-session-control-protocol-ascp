# @ascp/host-service

Reusable local ASCP host service for exposing an adapter or runtime implementation over WebSocket JSON-RPC with pushed `EventEnvelope` delivery.

## Scope

- single-user local host process
- ASCP JSON-RPC request routing over WebSocket
- push-style subscription event delivery to connected clients
- runtime-neutral handler boundary so downstream adapters can plug in later

## Current Intended Use

This package is the reusable host layer. The Codex-specific runtime binding and launch script live under [`adapters/codex`](/Users/ibrar/Desktop/infinora.noworkspace/Continuum%20App/agent-session-control-protocol-ascp/adapters/codex).

## Verify

```bash
npm --workspace @ascp/host-service run check
```
