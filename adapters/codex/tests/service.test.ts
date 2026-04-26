import { describe, expect, it } from "vitest";

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
      replay_supported: false,
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
});
