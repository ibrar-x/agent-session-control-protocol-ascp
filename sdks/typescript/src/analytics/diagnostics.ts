import type { AscpTransportError } from "../transport/errors.js";
import type { AscpValidationError, ValidationIssue } from "../validation/types.js";
import type { AscpDiagnostic } from "./types.js";

function validationIssueHint(issue: ValidationIssue | undefined): string[] {
  if (issue === undefined) {
    return [
      "Inspect the payload against the upstream ASCP schema for the reported target.",
      "Compare the payload with a schema-valid example before retrying."
    ];
  }

  switch (issue.keyword) {
    case "enum":
      return [
        "Compare the failing field against the allowed schema enum values.",
        "Check whether the runtime emitted a misspelled or unsupported value."
      ];
    case "required":
      return [
        "Add the missing required field before sending or consuming this payload.",
        "Compare the payload with the upstream schema-valid example for this target."
      ];
    case "format":
      return [
        "Re-check the field format against the upstream schema constraint.",
        "Validate timestamps, identifiers, and URIs before retrying."
      ];
    default:
      return [
        "Inspect the failing payload path against the schema rule shown in the error.",
        "Compare the payload with a schema-valid example before retrying."
      ];
  }
}

export function describeTransportError(error: AscpTransportError): AscpDiagnostic {
  const base = {
    category: "transport" as const,
    code: error.code,
    location: error.transport,
    summary: error.message,
    details: error.details
  };

  switch (error.code) {
    case "TRANSPORT_PROTOCOL":
      return {
        ...base,
        actions: [
          "Inspect the host output for invalid JSON or non-ASCP lines.",
          "Verify the host returns JSON-RPC 2.0 responses and ASCP event envelopes.",
          "Re-run the same flow against the mock server to isolate whether the bug is in the host or the consumer."
        ]
      };
    case "TRANSPORT_TIMEOUT":
      return {
        ...base,
        actions: [
          "Check whether the host is still processing the request or has stalled.",
          "Increase the request timeout only after confirming the host behavior is expected.",
          "Inspect request-specific logs around the timed-out method before retrying."
        ]
      };
    case "TRANSPORT_CONNECTION":
      return {
        ...base,
        actions: [
          "Verify the target process or socket is reachable from the current runtime.",
          "Check startup logs and connection parameters before retrying.",
          "Reproduce with the deterministic mock server to separate environment issues from SDK issues."
        ]
      };
    case "TRANSPORT_IO":
      return {
        ...base,
        actions: [
          "Inspect the underlying process or socket for write/read failures.",
          "Check whether the transport was closed or became unwritable mid-request.",
          "Retry only after confirming the target connection is healthy."
        ]
      };
    default:
      return {
        ...base,
        actions: [
          "Inspect the transport configuration and runtime logs for this failure.",
          "Reproduce the issue with a minimal request flow before changing client behavior."
        ]
      };
  }
}

export function describeValidationError(error: AscpValidationError): AscpDiagnostic {
  const firstIssue = error.issues[0];

  return {
    category: "validation",
    code: firstIssue?.keyword ?? "validation",
    location:
      firstIssue !== undefined
        ? `${error.target} ${firstIssue.path}`
        : error.target,
    summary: error.message,
    actions: validationIssueHint(firstIssue),
    details:
      firstIssue !== undefined
        ? {
            path: firstIssue.path,
            schemaPath: firstIssue.schemaPath
          }
        : undefined
  };
}
