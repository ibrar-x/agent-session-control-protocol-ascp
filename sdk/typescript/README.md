# TypeScript SDK

This directory is reserved for the ASCP TypeScript SDK package.

It is the first implementation target in this workspace.

The expected responsibilities come from `../../ASCP_TypeScript_SDK_Implementation_Plan.md`:

- strongly typed ASCP models
- request and response method clients
- event envelope models
- JSON Schema-backed validation
- stdio and WebSocket transport support
- replay helpers
- auth hooks
- integration examples for Node.js consumers

The next feature branch should scaffold this package without widening immediately into transport or client work unless the active plan says otherwise.
