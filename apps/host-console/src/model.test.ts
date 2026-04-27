import { describe, expect, it } from "vitest";

import {
  buildInteractionTimelineItems,
  createLoadingSessionView,
  createSnapshotOnlySessionView,
  hydrateSessionSnapshot,
  mergeApprovals,
  mergeInputs
} from "./model";

describe("host-console model", () => {
  it("clears stale session detail immediately on session switch", () => {
    expect(createLoadingSessionView("codex:next-session")).toEqual({
      sessionId: "codex:next-session",
      mode: "loading",
      session: null,
      runs: [],
      currentRun: null,
      approvals: [],
      inputs: [],
      artifacts: [],
      artifactDetail: null,
      diff: null,
      events: [],
      expanded: {
        artifacts: false,
        diff: false,
        events: false,
        capabilities: false
      }
    });
  });

  it("marks snapshot-only mode when live attach fails after snapshot load", () => {
    const view = createSnapshotOnlySessionView({
      sessionId: "codex:session_1",
      pausedReason: "subscribe_failed"
    });

    expect(view.mode).toBe("snapshot-only");
    expect(view.livePausedReason).toBe("subscribe_failed");
  });

  it("keeps answered interaction cards inline in the timeline", () => {
    const items = buildInteractionTimelineItems({
      approvals: [
        {
          id: "codex:approval_1",
          session_id: "codex:session_1",
          kind: "command",
          status: "approved",
          title: "Approve command",
          risk_level: "medium",
          payload: {},
          created_at: "2026-04-27T12:00:00.000Z",
          resolved_at: "2026-04-27T12:01:00.000Z"
        }
      ],
      inputs: []
    });

    expect(items).toEqual([
      expect.objectContaining({
        kind: "approval",
        state: "answered"
      })
    ]);
  });

  it("keeps artifact and diff detail unloaded until the rail section is explicitly opened", () => {
    const view = hydrateSessionSnapshot({
      sessionId: "codex:session_1",
      session: {
        id: "codex:session_1",
        runtime_id: "codex_local",
        status: "idle",
        created_at: "2026-04-27T12:00:00.000Z",
        updated_at: "2026-04-27T12:00:00.000Z",
        metadata: {
          source: "codex"
        }
      },
      runs: [],
      approvals: [],
      inputs: []
    });

    expect(view.artifacts).toEqual([]);
    expect(view.diff).toBeNull();
    expect(view.expanded.artifacts).toBe(false);
    expect(view.expanded.diff).toBe(false);
  });

  it("retains resolved interactions when a new snapshot only contains pending items", () => {
    const resolvedApproval = {
      id: "codex:approval_resolved",
      session_id: "codex:session_1",
      kind: "generic",
      status: "approved",
      created_at: "2026-04-27T12:00:00.000Z",
      resolved_at: "2026-04-27T12:01:00.000Z"
    };
    const pendingApproval = {
      id: "codex:approval_pending",
      session_id: "codex:session_1",
      kind: "generic",
      status: "pending",
      created_at: "2026-04-27T12:02:00.000Z"
    };
    const answeredInput = {
      id: "codex:input_answered",
      session_id: "codex:session_1",
      question: "Proceed?",
      input_type: "confirm",
      status: "answered",
      created_at: "2026-04-27T12:03:00.000Z",
      metadata: {}
    };
    const pendingInput = {
      id: "codex:input_pending",
      session_id: "codex:session_1",
      question: "Choose target",
      input_type: "choice",
      status: "pending",
      created_at: "2026-04-27T12:04:00.000Z",
      choices: ["staging", "production"],
      metadata: {}
    };

    expect(mergeApprovals([resolvedApproval as never], [pendingApproval as never])).toEqual([
      resolvedApproval,
      pendingApproval
    ]);
    expect(mergeInputs([answeredInput as never], [pendingInput as never])).toEqual([
      answeredInput,
      pendingInput
    ]);
  });
});
