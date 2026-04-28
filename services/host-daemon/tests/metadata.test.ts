import { describe, expect, it } from "vitest";

import { buildSnapshotMetadata } from "../src/metadata.js";

describe("buildSnapshotMetadata", () => {
  it("marks seeded baselines as partial when required fields are missing", () => {
    expect(
      buildSnapshotMetadata({
        snapshotOrigin: "seeded_snapshot",
        attachmentStatus: "attached",
        activeRun: undefined,
        pendingApprovals: [],
        pendingInputs: []
      })
    ).toEqual({
      snapshotOrigin: "seeded_snapshot",
      completeness: "partial",
      missingFields: ["active_run"],
      missingReasons: { active_run: "runtime_omitted" },
      attachmentStatus: "attached"
    });
  });

  it("marks live-stream state as complete when required fields are present", () => {
    expect(
      buildSnapshotMetadata({
        snapshotOrigin: "live_stream",
        attachmentStatus: "detached",
        activeRun: null,
        pendingApprovals: [],
        pendingInputs: []
      })
    ).toEqual({
      snapshotOrigin: "live_stream",
      completeness: "complete",
      missingFields: [],
      missingReasons: {},
      attachmentStatus: "detached"
    });
  });
});
