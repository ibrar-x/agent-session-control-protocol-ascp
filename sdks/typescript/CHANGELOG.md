# Changelog

## 0.1.0 - 2026-04-25

Initial release-ready TypeScript SDK reference package for ASCP protocol `0.1.0`.

Highlights:

- stable root happy-path surface for package metadata, `AscpClient`, replay helpers, and core protocol types
- dedicated subpath surfaces for `validation`, `transport`, `analytics`, `client`, and `replay`
- AJV-backed schema validation with packaged upstream ASCP schema snapshots
- stdio and WebSocket transports
- typed wrappers for the ASCP core method set
- replay helpers that preserve `from_seq`, `from_event_id`, and opaque cursor extension handling
- end-to-end examples and mock-server integration tests
- release smoke checks for package exports, type resolution, and npm tarball contents

Known limits carried into the first release:

- auth hooks remain intentionally deferred; the SDK only preserves the upstream auth and error semantics that already exist
- streamed extension events stay envelope-first unless consumers opt into exact core-event validation
- the SDK remains intentionally thin and does not rename ASCP field names into SDK-specific DTO aliases

Versioning decision:

- the package stays at `0.1.0` to align the first downstream reference release with the upstream ASCP protocol `0.1.0`
- until the protocol and SDK surface both reach `1.0.0`, breaking SDK refinements may land in a minor version
- additive SDK improvements should stay additive to the ASCP protocol and preserve the documented root-versus-subpath package boundary
