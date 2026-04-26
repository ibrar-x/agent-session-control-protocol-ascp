import { describe, expect, it } from "vitest";

import { createEventEnvelope, createSuccessResponse } from "../src/index.js";

describe("generic ASCP builders", () => {
  it("creates a success response envelope", () => {
    expect(
      createSuccessResponse("req-1", { session_id: "sess_1", accepted: true })
    ).toEqual({
      jsonrpc: "2.0",
      id: "req-1",
      result: { session_id: "sess_1", accepted: true }
    });
  });

  it("creates an event envelope with ASCP field names", () => {
    expect(
      createEventEnvelope({
        id: "evt_1",
        type: "run.started",
        ts: "2026-04-26T10:00:00Z",
        session_id: "sess_1",
        payload: { run_id: "run_1" }
      })
    ).toEqual({
      id: "evt_1",
      type: "run.started",
      ts: "2026-04-26T10:00:00Z",
      session_id: "sess_1",
      payload: { run_id: "run_1" }
    });
  });
});
