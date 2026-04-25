# ASCP SDKs

This tree holds language bindings that consume the protocol assets under [`../protocol/`](../protocol/).

Current packages:

- [`typescript/`](./typescript/)
- [`dart/`](./dart/)

Shared SDK rules:

- SDKs stay downstream of `protocol/`
- SDKs may grow shared internals into `../packages/` when duplication becomes real
- SDKs must not redefine ASCP method names, event names, or replay semantics

Key upstream inputs:

- [`../protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`](../protocol/ASCP_Protocol_Detailed_Spec_v0_1.md)
- [`../protocol/ASCP_Protocol_PRD_and_Build_Guide.md`](../protocol/ASCP_Protocol_PRD_and_Build_Guide.md)
- [`../protocol/schema/`](../protocol/schema/)
- [`../protocol/spec/`](../protocol/spec/)
- [`../protocol/examples/`](../protocol/examples/)
- [`../protocol/conformance/`](../protocol/conformance/)
- [`../services/mock-server/README.md`](../services/mock-server/README.md)
- [`../apps/reference-client/README.md`](../apps/reference-client/README.md)
