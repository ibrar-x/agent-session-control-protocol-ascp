import { describe, expect, it } from "vitest";

import {
  mapThreadStatus,
  mapThreadToSession,
  mapTurnStatus,
  mapTurnToRun
} from "../src/session-mapper.js";

describe("mapThreadStatus", () => {
  it("maps explicit Codex thread states conservatively", () => {
    expect(mapThreadStatus({ type: "idle" })).toBe("idle");
    expect(mapThreadStatus({ type: "active" })).toBe("running");
    expect(mapThreadStatus({ type: "active", activeFlags: ["waitingOnApproval"] })).toBe(
      "waiting_approval"
    );
    expect(mapThreadStatus({ type: "active", activeFlags: ["waitingOnUserInput"] })).toBe(
      "waiting_input"
    );
    expect(mapThreadStatus({ type: "active", active_flags: ["waiting_on_user_input"] })).toBe(
      "waiting_input"
    );
    expect(mapThreadStatus({ type: "systemError" })).toBe("failed");
    expect(mapThreadStatus({ type: "notLoaded" })).toBe("idle");
    expect(mapThreadStatus({ type: "unknown" })).toBe("disconnected");
  });
});

describe("mapTurnStatus", () => {
  it("maps real Codex turn statuses conservatively into ASCP run statuses", () => {
    expect(mapTurnStatus({ status: "inProgress" })).toBe("running");
    expect(mapTurnStatus({ status: "completed" })).toBe("completed");
    expect(mapTurnStatus({ status: "failed" })).toBe("failed");
    expect(mapTurnStatus({ status: "interrupted" })).toBe("cancelled");
    expect(mapTurnStatus({ status: "mystery" })).toBe("starting");
  });

  it("does not treat an ended turn with missing status as starting", () => {
    expect(mapTurnStatus({ completedAt: 1_745_663_340 })).toBe("failed");
  });
});

describe("mapThreadToSession", () => {
  it("normalizes a real-shape Codex thread into exact ASCP session fields", () => {
    const session = mapThreadToSession({
      id: "019dc70f",
      name: "Fix failing tests",
      cwd: "/tmp/worktree",
      createdAt: 1_745_661_600,
      updatedAt: 1_745_662_320,
      lastActivityAt: 1_745_662_320,
      preview: "Working through checkout flow failures",
      status: {
        type: "idle"
      }
    });

    expect(session).toEqual({
      id: "codex:019dc70f",
      runtime_id: "codex_local",
      title: "Fix failing tests",
      workspace: "/tmp/worktree",
      status: "idle",
      created_at: "2025-04-26T10:00:00.000Z",
      updated_at: "2025-04-26T10:12:00.000Z",
      last_activity_at: "2025-04-26T10:12:00.000Z",
      summary: "Working through checkout flow failures",
      metadata: {
        source: "codex"
      }
    });
  });

  it("keeps ISO-string timestamp fallback support when present", () => {
    const session = mapThreadToSession({
      id: "thread_2",
      created_at: "2026-04-26T10:00:00Z",
      updated_at: "2026-04-26T10:12:00Z",
      status: {
        type: "active",
        active_flags: ["waiting_on_user_input"]
      }
    });

    expect(session).toMatchObject({
      id: "codex:thread_2",
      status: "waiting_input",
      created_at: "2026-04-26T10:00:00Z",
      updated_at: "2026-04-26T10:12:00Z"
    });
  });
});

describe("mapTurnToRun", () => {
  it("normalizes a real-shape Codex turn into exact ASCP run fields with canonical ids", () => {
    const run = mapTurnToRun(
      {
        id: "turn_1",
        status: "inProgress",
        startedAt: 1_745_661_900,
        completedAt: null
      },
      "019dc70f"
    );

    expect(run).toEqual({
      id: "codex:019dc70f:turn_1",
      session_id: "codex:019dc70f",
      status: "running",
      started_at: "2025-04-26T10:05:00.000Z",
      ended_at: null
    });
  });

  it("preserves terminal turn details when the Codex shape is explicit", () => {
    const run = mapTurnToRun(
      {
        id: "turn_2",
        status: "failed",
        startedAt: 1_745_661_900,
        completedAt: 1_745_662_140,
        exitCode: 1
      },
      "019dc70f"
    );

    expect(run).toEqual({
      id: "codex:019dc70f:turn_2",
      session_id: "codex:019dc70f",
      status: "failed",
      started_at: "2025-04-26T10:05:00.000Z",
      ended_at: "2025-04-26T10:09:00.000Z",
      exit_code: 1
    });
  });

  it("uses created_at fallback when a turn exposes mixed-case timestamp fields", () => {
    const run = mapTurnToRun(
      {
        id: "turn_3",
        created_at: "2026-04-26T10:05:00Z",
        status: "completed",
        ended_at: "2026-04-26T10:09:00Z"
      },
      "thread_3"
    );

    expect(run).toEqual({
      id: "codex:thread_3:turn_3",
      session_id: "codex:thread_3",
      status: "completed",
      started_at: "2026-04-26T10:05:00Z",
      ended_at: "2026-04-26T10:09:00Z"
    });
  });

  it("maps a terminal turn with missing status conservatively", () => {
    const run = mapTurnToRun(
      {
        id: "turn_4",
        startedAt: 1_745_661_900,
        completedAt: 1_745_662_140
      },
      "thread_4"
    );

    expect(run).toEqual({
      id: "codex:thread_4:turn_4",
      session_id: "codex:thread_4",
      status: "failed",
      started_at: "2025-04-26T10:05:00.000Z",
      ended_at: "2025-04-26T10:09:00.000Z"
    });
  });
});
