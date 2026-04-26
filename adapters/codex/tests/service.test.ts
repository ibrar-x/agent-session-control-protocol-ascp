import { describe, expect, it } from "vitest";

import { CodexJsonRpcError } from "../src/app-server-client.js";
import { CODEX_RUNTIME_ID } from "../src/discovery.js";
import { CodexAdapterService } from "../src/service.js";

class FakeCodexClient {
  threadListResult: unknown = {
    data: []
  };
  threadReadResult: unknown = {
    thread: null
  };
  threadResumeResult: unknown = {
    thread: null
  };
  turnStartResult: unknown = {
    turn: {
      id: "turn_new"
    }
  };
  turnSteerResult: unknown = {
    turnId: "turn_active"
  };
  requestResults = new Map<string, unknown>();
  requestErrors = new Map<string, unknown>();
  requestedMethods: Array<{ method: string; params: Record<string, unknown> | undefined }> = [];
  private readonly threadReadById = new Map<string, unknown>();
  private readonly notificationListeners = new Set<(notification: { method: string; params?: unknown }) => void>();
  approvalRequestsObserved = false;
  approvalRespondSupported = false;

  lastThreadReadOptions: { threadId: string; includeTurns?: boolean } | null = null;
  lastThreadResumeId: string | null = null;
  lastTurnStartParams: Record<string, unknown> | null = null;
  lastTurnSteerParams: Record<string, unknown> | null = null;

  async threadList(): Promise<unknown> {
    return this.threadListResult;
  }

  async threadRead(threadId: string, options: { includeTurns?: boolean } = {}): Promise<unknown> {
    this.lastThreadReadOptions = {
      threadId,
      includeTurns: options.includeTurns
    };

    if (this.threadReadById.has(threadId)) {
      return this.threadReadById.get(threadId);
    }

    return this.threadReadResult;
  }

  async threadResume(threadId: string): Promise<unknown> {
    this.lastThreadResumeId = threadId;
    return this.threadResumeResult;
  }

  async turnStart(params: Record<string, unknown>): Promise<unknown> {
    this.lastTurnStartParams = params;
    return this.turnStartResult;
  }

  async turnSteer(params: Record<string, unknown>): Promise<unknown> {
    this.lastTurnSteerParams = params;
    return this.turnSteerResult;
  }

  onNotification(listener: (notification: { method: string; params?: unknown }) => void): () => void {
    this.notificationListeners.add(listener);

    return () => {
      this.notificationListeners.delete(listener);
    };
  }

  emitNotification(notification: { method: string; params?: unknown }): void {
    for (const listener of this.notificationListeners) {
      listener(notification);
    }
  }

  async request(method: string, params?: Record<string, unknown>): Promise<unknown> {
    this.requestedMethods.push({
      method,
      params
    });

    const error = this.requestErrors.get(method);

    if (error !== undefined) {
      throw error;
    }

    if (this.requestResults.has(method)) {
      return this.requestResults.get(method);
    }

    return { ok: true };
  }

  setThreadReadResult(threadId: string, value: unknown): void {
    this.threadReadById.set(threadId, value);
  }

  markApprovalRequestObserved(): void {
    this.approvalRequestsObserved = true;
  }

  markApprovalResponseSupported(): void {
    this.approvalRespondSupported = true;
  }
}

function makeThread(overrides: Record<string, unknown> = {}): Record<string, unknown> {
  return {
    id: "thread_1",
    name: "Codex task",
    cwd: "/tmp/worktree",
    createdAt: 1_745_661_600,
    updatedAt: 1_745_662_320,
    preview: "Preview text",
    status: {
      type: "idle"
    },
    turns: [],
    ...overrides
  };
}

describe("CodexAdapterService", () => {
  it("lists Codex sessions as ASCP-shaped results", async () => {
    const client = new FakeCodexClient();
    client.threadListResult = {
      data: [makeThread()],
      nextCursor: "cursor_2"
    };

    const service = new CodexAdapterService(client);

    await expect(service.sessionsList({ runtime_id: CODEX_RUNTIME_ID })).resolves.toMatchObject({
      sessions: [
        {
          id: "codex:thread_1",
          runtime_id: CODEX_RUNTIME_ID,
          status: "idle"
        }
      ],
      next_cursor: "cursor_2"
    });
  });

  it("returns NOT_FOUND when sessions.get cannot resolve the session", async () => {
    const service = new CodexAdapterService(new FakeCodexClient());

    await expect(service.sessionsGet({ session_id: "codex:missing" })).rejects.toMatchObject({
      code: "NOT_FOUND"
    });
  });

  it("reads a session and includes runs when requested", async () => {
    const client = new FakeCodexClient();
    client.threadReadResult = {
      thread: makeThread({
        turns: [
          {
            id: "turn_1",
            status: "completed",
            startedAt: 1_745_661_900,
            completedAt: 1_745_662_140
          }
        ]
      })
    };

    const service = new CodexAdapterService(client);
    const result = await service.sessionsGet({
      session_id: "codex:thread_1",
      include_runs: true
    });

    expect(client.lastThreadReadOptions).toEqual({
      threadId: "thread_1",
      includeTurns: true
    });
    expect(result).toMatchObject({
      session: {
        id: "codex:thread_1"
      },
      runs: [
        {
          id: "codex:thread_1:turn_1",
          session_id: "codex:thread_1",
          status: "completed"
        }
      ]
    });
  });

  it("skips incomplete turns instead of failing sessions.get when include_runs is requested", async () => {
    const client = new FakeCodexClient();
    client.threadReadResult = {
      thread: makeThread({
        turns: [
          {
            id: "turn_complete",
            status: "completed",
            startedAt: 1_745_661_900,
            completedAt: 1_745_662_140
          },
          {
            id: "turn_incomplete",
            status: "inProgress"
          }
        ]
      })
    };

    const service = new CodexAdapterService(client);
    const result = await service.sessionsGet({
      session_id: "codex:thread_1",
      include_runs: true
    });

    expect(result.runs).toEqual([
      expect.objectContaining({
        id: "codex:thread_1:turn_complete",
        session_id: "codex:thread_1",
        status: "completed"
      })
    ]);
  });

  it("resumes a session with honest replay flags", async () => {
    const client = new FakeCodexClient();
    client.threadResumeResult = {
      thread: makeThread({
        id: "thread_2"
      })
    };

    const service = new CodexAdapterService(client);

    await expect(service.sessionsResume({ session_id: "codex:thread_2" })).resolves.toEqual({
      session: expect.objectContaining({
        id: "codex:thread_2"
      }),
      replay_supported: true,
      snapshot_emitted: false
    });
  });

  it("steers the active in-progress turn when sending input", async () => {
    const client = new FakeCodexClient();
    client.threadReadResult = {
      thread: makeThread({
        status: {
          type: "active"
        },
        turns: [
          {
            id: "turn_active",
            status: "inProgress",
            startedAt: 1_745_661_900
          }
        ]
      })
    };

    const service = new CodexAdapterService(client);

    await expect(
      service.sessionsSendInput({
        session_id: "codex:thread_1",
        input: "continue"
      })
    ).resolves.toEqual({
      session_id: "codex:thread_1",
      accepted: true
    });

    expect(client.lastTurnSteerParams).toEqual({
      threadId: "thread_1",
      expectedTurnId: "turn_active",
      input: [
        {
          type: "text",
          text: "continue"
        }
      ]
    });
    expect(client.lastTurnStartParams).toBeNull();
  });

  it("starts a new turn when no active in-progress turn exists", async () => {
    const client = new FakeCodexClient();
    client.threadReadResult = {
      thread: makeThread({
        turns: []
      })
    };
    client.threadResumeResult = {
      thread: makeThread({
        turns: []
      })
    };

    const service = new CodexAdapterService(client);

    await expect(
      service.sessionsSendInput({
        session_id: "codex:thread_1",
        input: "continue"
      })
    ).resolves.toEqual({
      session_id: "codex:thread_1",
      accepted: true
    });

    expect(client.lastTurnStartParams).toEqual({
      threadId: "thread_1",
      input: [
        {
          type: "text",
          text: "continue"
        }
      ]
    });
    expect(client.lastThreadResumeId).toBe("thread_1");
    expect(client.lastTurnSteerParams).toBeNull();
  });

  it("resumes a persisted thread before starting a new turn", async () => {
    const client = new FakeCodexClient();
    client.threadReadResult = {
      thread: makeThread({
        id: "thread_2",
        turns: []
      })
    };
    client.threadResumeResult = {
      thread: makeThread({
        id: "thread_2",
        turns: []
      })
    };

    const service = new CodexAdapterService(client);

    await expect(
      service.sessionsSendInput({
        session_id: "codex:thread_2",
        input: "summarize this"
      })
    ).resolves.toEqual({
      session_id: "codex:thread_2",
      accepted: true
    });

    expect(client.lastThreadReadOptions).toEqual({
      threadId: "thread_2",
      includeTurns: true
    });
    expect(client.lastThreadResumeId).toBe("thread_2");
    expect(client.lastTurnStartParams).toEqual({
      threadId: "thread_2",
      input: [
        {
          type: "text",
          text: "summarize this"
        }
      ]
    });
  });

  it("creates subscription snapshots and streams mapped live events", async () => {
    const client = new FakeCodexClient();
    client.threadReadResult = {
      thread: makeThread({
        id: "thread_1",
        turns: []
      })
    };

    const service = new CodexAdapterService(client);

    const subscribeResult = await service.sessionsSubscribe({
      session_id: "codex:thread_1",
      include_snapshot: true
    });

    expect(subscribeResult).toMatchObject({
      session_id: "codex:thread_1",
      snapshot_emitted: true
    });

    const initialEvents = service.drainSubscriptionEvents(subscribeResult.subscription_id);
    expect(initialEvents.some((event) => event.type === "sync.snapshot")).toBe(true);

    client.emitNotification({
      method: "turn/started",
      params: {
        threadId: "thread_1",
        turn: {
          id: "turn_live",
          status: "inProgress",
          startedAt: 1_745_662_000
        }
      }
    });

    const streamed = service.drainSubscriptionEvents(subscribeResult.subscription_id);
    expect(streamed).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          type: "run.started",
          session_id: "codex:thread_1"
        })
      ])
    );
  });

  it("supports replay from seq for subscribe", async () => {
    const client = new FakeCodexClient();
    client.threadReadResult = {
      thread: makeThread({
        id: "thread_1",
        turns: []
      })
    };

    const service = new CodexAdapterService(client);

    client.emitNotification({
      method: "turn/started",
      params: {
        threadId: "thread_1",
        turn: {
          id: "turn_1",
          status: "inProgress",
          startedAt: 1_745_662_000
        }
      }
    });
    client.emitNotification({
      method: "turn/completed",
      params: {
        threadId: "thread_1",
        turn: {
          id: "turn_1",
          status: "completed",
          completedAt: 1_745_662_050
        }
      }
    });

    const subscribeResult = await service.sessionsSubscribe({
      session_id: "codex:thread_1",
      from_seq: 1
    });
    const replayEvents = service.drainSubscriptionEvents(subscribeResult.subscription_id);

    expect(replayEvents.some((event) => event.type === "sync.replayed")).toBe(true);
    expect(replayEvents.some((event) => event.type === "run.completed")).toBe(true);
  });

  it("lists approval requests observed from Codex approval notifications", async () => {
    const client = new FakeCodexClient();
    const service = new CodexAdapterService(client);

    client.emitNotification({
      method: "item/commandExecution/requestApproval",
      params: {
        approvalId: "approval_1",
        itemId: "item_1",
        threadId: "thread_1",
        turnId: "turn_1",
        command: "npm test",
        cwd: "/tmp/worktree",
        reason: "Needs execution"
      }
    });

    const result = await service.approvalsList({
      session_id: "codex:thread_1"
    });

    expect(result.approvals).toEqual(
      expect.arrayContaining([
        expect.objectContaining({
          id: "codex:approval_1",
          session_id: "codex:thread_1",
          status: "pending"
        })
      ])
    );
  });

  it("responds to approvals when Codex approval response method is available", async () => {
    const client = new FakeCodexClient();
    client.requestResults.set("approval/respond", {
      status: "approved"
    });
    const service = new CodexAdapterService(client);

    client.emitNotification({
      method: "item/commandExecution/requestApproval",
      params: {
        approvalId: "approval_2",
        itemId: "item_2",
        threadId: "thread_1"
      }
    });

    await expect(
      service.approvalsRespond({
        approval_id: "codex:approval_2",
        decision: "approved"
      })
    ).resolves.toEqual({
      approval_id: "codex:approval_2",
      status: "approved"
    });

    expect(client.requestedMethods[0]).toMatchObject({
      method: "approval/respond",
      params: expect.objectContaining({
        approvalId: "approval_2",
        decision: "approved"
      })
    });
  });

  it("returns UNSUPPORTED when approval responses are not available", async () => {
    const client = new FakeCodexClient();
    client.requestErrors.set("approval/respond", new CodexJsonRpcError({
      code: -32601,
      message: "Method not found"
    }));
    const service = new CodexAdapterService(client);

    client.emitNotification({
      method: "item/commandExecution/requestApproval",
      params: {
        approvalId: "approval_3",
        itemId: "item_3",
        threadId: "thread_1"
      }
    });

    await expect(
      service.approvalsRespond({
        approval_id: "codex:approval_3",
        decision: "rejected"
      })
    ).rejects.toMatchObject({
      code: "UNSUPPORTED"
    });
  });

  it("derives diffs and artifacts from file change turn items", async () => {
    const client = new FakeCodexClient();
    client.threadReadResult = {
      thread: makeThread({
        id: "thread_1",
        turns: [
          {
            id: "turn_1",
            status: "completed",
            startedAt: 1_745_662_000,
            completedAt: 1_745_662_020,
            items: [
              {
                type: "fileChange",
                id: "file_change_1",
                changes: [
                  {
                    path: "/tmp/worktree/src/service.ts",
                    kind: {
                      type: "update"
                    },
                    diff: [
                      "@@ -1 +1,2 @@",
                      "-old line",
                      "+new line",
                      "+added line"
                    ].join("\n")
                  }
                ]
              }
            ]
          }
        ]
      })
    };

    const service = new CodexAdapterService(client);

    await expect(
      service.diffsGet({
        session_id: "codex:thread_1",
        run_id: "codex:thread_1:turn_1"
      })
    ).resolves.toEqual({
      diff: {
        session_id: "codex:thread_1",
        run_id: "codex:thread_1:turn_1",
        files_changed: 1,
        insertions: 2,
        deletions: 1,
        files: [
          {
            path: "/tmp/worktree/src/service.ts",
            change_type: "modified",
            insertions: 2,
            deletions: 1
          }
        ]
      }
    });

    const artifacts = await service.artifactsList({
      session_id: "codex:thread_1",
      run_id: "codex:thread_1:turn_1"
    });

    expect(artifacts.artifacts).toHaveLength(1);
    expect(artifacts.artifacts[0]).toMatchObject({
      id: "codex:artifact:thread_1:turn_1:file_change_1:0",
      session_id: "codex:thread_1",
      run_id: "codex:thread_1:turn_1",
      kind: "diff"
    });

    await expect(
      service.artifactsGet({
        artifact_id: "codex:artifact:thread_1:turn_1:file_change_1:0"
      })
    ).resolves.toMatchObject({
      artifact: {
        id: "codex:artifact:thread_1:turn_1:file_change_1:0",
        session_id: "codex:thread_1"
      }
    });
  });
});
