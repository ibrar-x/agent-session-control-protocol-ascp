# Changelog

## 0.1.0 - 2026-04-25

Initial release-ready Dart SDK package for ASCP protocol `0.1.0`.

Highlights:

- immutable ASCP core models and shared JSON-RPC envelopes
- typed params and result models for the ASCP core method set
- thin `AscpClient` wrappers for discovery, session, approval, artifact, and diff methods
- replaceable stdio and WebSocket transports
- stream-based event access through transport and client event streams
- replay helpers for `from_seq`, `from_event_id`, and additive opaque cursor extension fields
- callback-based validation hooks for outgoing params, incoming results, and streamed events
- transport-level auth hooks for stdio environment injection and WebSocket headers
- focused tests plus a deterministic mock-server example
- release checks for public library boundaries, analyzer health, tests, examples, and package dry-run

Known limits carried into the first release:

- the package does not include Flutter widgets, app state, caching, or persistence helpers
- the package does not embed a full Dart schema registry; validation remains hook-based
- WebSocket transport is implemented and locally tested, but the deterministic upstream mock-server proof currently uses stdio
- opaque cursor replay is represented as additive extension fields because ASCP core `sessions.subscribe` does not define a `cursor` param

Versioning decision:

- the Dart package stays at `0.1.0` to align with the upstream ASCP protocol `0.1.0`
- until the protocol and SDK surface both reach `1.0.0`, breaking SDK refinements may land in a minor version
- patch releases should preserve the documented root and secondary public library boundary
