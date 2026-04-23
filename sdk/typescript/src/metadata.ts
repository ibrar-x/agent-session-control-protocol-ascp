export const ASCP_PROTOCOL_VERSION = "0.1.0";

export const ASCP_SCHEMA_MODULES = [
  "ascp-core",
  "ascp-capabilities",
  "ascp-methods",
  "ascp-events",
  "ascp-errors"
] as const;

export const ASCP_MODEL_STRATEGY = Object.freeze({
  source: "../schema and ../examples",
  generator: null,
  authoring: "hand-authored-schema-indexed",
  publicBarrels: ["models", "methods", "events", "errors"] as const
});
