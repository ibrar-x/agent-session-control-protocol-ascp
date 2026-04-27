import { describe, expect, it } from "vitest";

import { buildSessionSubscriptionRequest } from "./subscriptions";

describe("buildSessionSubscriptionRequest", () => {
  it("requests snapshot plus replay-safe history for reopened sessions", () => {
    expect(buildSessionSubscriptionRequest("codex:session_1")).toEqual({
      session_id: "codex:session_1",
      include_snapshot: true,
      from_seq: 0
    });
  });
});
