import { describe, expect, it } from "vitest";

import {
  ASCP_MODEL_STRATEGY,
  ASCP_PROTOCOL_VERSION,
  ASCP_SCHEMA_MODULES
} from "../src/metadata.js";

describe("foundation metadata", () => {
  it("pins the ASCP protocol version for the generated model surface", () => {
    expect(ASCP_PROTOCOL_VERSION).toBe("0.1.0");
  });

  it("describes the upstream schema inputs used for model generation", () => {
    expect(ASCP_MODEL_STRATEGY.generator).toBeNull();
    expect(ASCP_MODEL_STRATEGY.authoring).toBe("hand-authored-schema-indexed");
    expect(ASCP_MODEL_STRATEGY.publicBarrels).toContain("analytics");
    expect(ASCP_SCHEMA_MODULES).toEqual([
      "ascp-core",
      "ascp-capabilities",
      "ascp-methods",
      "ascp-events",
      "ascp-errors"
    ]);
  });
});
