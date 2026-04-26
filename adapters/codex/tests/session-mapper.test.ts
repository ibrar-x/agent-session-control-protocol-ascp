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
    expect(mapThreadStatus({ type: "active", activeFlags: ["waitingOnInput"] })).toBe(
      "waiting_input"
    );
    expect(mapThreadStatus({ type: "systemError" })).toBe("failed");
    expect(mapThreadStatus({ type: "completed" })).toBe("completed");
    expect(mapThreadStatus({ type: "unknown" })).toBe("disconnected");
  });
});

describe("mapTurnStatus", () => {
  it("maps turn statuses conservatively into ASCP run statuses", () => {
    expect(mapTurnStatus("queued")).toBe("starting");
    expect(mapTurnStatus("in_progress")).toBe("running");
    expect(mapTurnStatus("paused")).toBe("paused");
    expect(mapTurnStatus("completed")).toBe("completed");
    expect(mapTurnStatus("failed")).toBe("failed");
    expect(mapTurnStatus("cancelled")).toBe("cancelled");
    expect(mapTurnStatus("mystery")).toBe("starting");
  });
});

describe("mapThreadToSession", () => {
  it("normalizes a Codex thread into exact ASCP session fields", () => {
    const session = mapThreadToSession({
      id: "019dc70f",
      name: "Fix failing tests",
      cwd: "/tmp/worktree",
      createdAt: "2026-04-26T10:00:00Z",
      updatedAt: "2026-04-26T10:12:00Z",
      lastActivityAt: "2026-04-26T10:12:00Z",
      preview: "Working through checkout flow failures",
      activeTurnId: "turn_1",
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
      created_at: "2026-04-26T10:00:00Z",
      updated_at: "2026-04-26T10:12:00Z",
      last_activity_at: "2026-04-26T10:12:00Z",
      summary: "Working through checkout flow failures",
      active_run_id: "codex:019dc70f:turn_1",
      metadata: {
        source: "codex"
      }
    });
  });
});

describe("mapTurnToRun", () => {
  it("normalizes a Codex turn into exact ASCP run fields", () => {
    const run = mapTurnToRun(
      {
        id: "turn_1",
        status: "in_progress",
        startedAt: "2026-04-26T10:05:00Z",
        completedAt: null
      },
      "codex:019dc70f"
    );

    expect(run).toEqual({
      id: "codex:019dc70f:turn_1",
      session_id: "codex:019dc70f",
      status: "running",
      started_at: "2026-04-26T10:05:00Z",
      ended_at: null
    });
  });

  it("preserves terminal turn details when the Codex shape is explicit", () => {
    const run = mapTurnToRun(
      {
        id: "turn_2",
        status: "failed",
        startedAt: "2026-04-26T10:05:00Z",
        completedAt: "2026-04-26T10:09:00Z",
        exitCode: 1
      },
      "codex:019dc70f"
    );

    expect(run).toEqual({
      id: "codex:019dc70f:turn_2",
      session_id: "codex:019dc70f",
      status: "failed",
      started_at: "2026-04-26T10:05:00Z",
      ended_at: "2026-04-26T10:09:00Z",
      exit_code: 1
    });
  });
});
