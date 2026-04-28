import { describe, expect, it } from "vitest";

import { openDaemonDatabase } from "../src/sqlite.js";
import { createSessionStore } from "../src/stores/session-store.js";

describe("session store", () => {
  it("persists a seeded baseline with completeness and attachment metadata", () => {
    const database = openDaemonDatabase(":memory:");
    const store = createSessionStore(database);

    store.upsertSeededSnapshot({
      sessionId: "codex:thread-1",
      runtimeId: "codex_local",
      session: {
        id: "codex:thread-1",
        runtime_id: "codex_local",
        status: "running",
        created_at: "2026-04-27T00:00:00.000Z",
        updated_at: "2026-04-27T00:00:00.000Z"
      },
      activeRun: null,
      pendingApprovals: [],
      pendingInputs: [],
      snapshotOrigin: "seeded_snapshot",
      completeness: "partial",
      missingFields: ["active_run"],
      missingReasons: { active_run: "runtime_omitted" },
      attachmentStatus: "attached"
    });

    expect(store.getSnapshot("codex:thread-1")).toEqual(
      expect.objectContaining({
        sessionId: "codex:thread-1",
        runtimeId: "codex_local",
        completeness: "partial",
        missingFields: ["active_run"],
        missingReasons: { active_run: "runtime_omitted" },
        attachmentStatus: "attached",
        snapshotOrigin: "seeded_snapshot"
      })
    );
  });
});
