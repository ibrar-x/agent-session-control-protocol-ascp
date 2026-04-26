import { describe, expect, it } from "vitest";

import { toApprovalId, toRunId, toSessionId } from "../src/ids.js";

describe("Codex adapter ids", () => {
  it("builds deterministic ids", () => {
    expect(toSessionId("thread_123")).toBe("codex:thread_123");
    expect(toRunId("thread_123", "turn_9")).toBe("codex:thread_123:turn_9");
    expect(toApprovalId("apr_7")).toBe("codex:apr_7");
  });
});
