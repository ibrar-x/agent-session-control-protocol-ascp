import { Readable, Writable } from "node:stream";

import { describe, expect, it } from "vitest";

import {
  getLiveSmokeUsage,
  parseLiveSmokeCommand,
  runInteractiveLiveSmoke,
  runInteractiveSessionMenu,
  runLiveSmokeCommand,
  validateLiveSmokeCommand
} from "../src/live-smoke.js";

describe("parseLiveSmokeCommand", () => {
  it("defaults to interactive mode with no args", () => {
    expect(parseLiveSmokeCommand([])).toEqual({
      mode: "interactive"
    });
  });

  it("parses list with a numeric limit", () => {
    expect(parseLiveSmokeCommand(["list", "--limit", "5"])).toEqual({
      mode: "command",
      command: "list",
      limit: 5
    });
  });

  it("parses get with runs enabled", () => {
    expect(parseLiveSmokeCommand(["get", "codex:thread_1", "--runs"])).toEqual({
      mode: "command",
      command: "get",
      sessionId: "codex:thread_1",
      includeRuns: true
    });
  });

  it("does not treat an option token as the session id for get", () => {
    expect(parseLiveSmokeCommand(["get", "--runs"])).toEqual({
      mode: "command",
      command: "get",
      sessionId: undefined,
      includeRuns: true
    });
  });

  it("preserves trailing send-input text verbatim", () => {
    expect(
      parseLiveSmokeCommand([
        "send-input",
        "codex:thread_1",
        "--help",
        "--fast",
        "continue"
      ])
    ).toEqual({
      mode: "command",
      command: "send-input",
      sessionId: "codex:thread_1",
      inputText: "--help --fast continue"
    });
  });

  it("parses sessions.subscribe with replay options", () => {
    expect(
      parseLiveSmokeCommand([
        "sessions.subscribe",
        "codex:thread_1",
        "--from-seq",
        "12",
        "--from-event-id",
        "codex:event_4",
        "--snapshot"
      ])
    ).toEqual({
      mode: "command",
      command: "sessions.subscribe",
      sessionId: "codex:thread_1",
      fromSeq: 12,
      fromEventId: "codex:event_4",
      includeSnapshot: true
    });
  });

  it("parses approvals.respond with decision and note", () => {
    expect(
      parseLiveSmokeCommand([
        "approvals.respond",
        "codex:approval_1",
        "approved",
        "looks",
        "good"
      ])
    ).toEqual({
      mode: "command",
      command: "approvals.respond",
      approvalId: "codex:approval_1",
      decision: "approved",
      note: "looks good"
    });
  });

  it("parses artifacts and diffs commands", () => {
    expect(
      parseLiveSmokeCommand([
        "artifacts.list",
        "codex:thread_1",
        "--run-id",
        "codex:run_1",
        "--kind",
        "diff"
      ])
    ).toEqual({
      mode: "command",
      command: "artifacts.list",
      sessionId: "codex:thread_1",
      runId: "codex:run_1",
      kind: "diff"
    });

    expect(parseLiveSmokeCommand(["diffs.get", "codex:thread_1", "codex:run_1"])).toEqual({
      mode: "command",
      command: "diffs.get",
      sessionId: "codex:thread_1",
      runId: "codex:run_1"
    });
  });

  it("rejects extra arguments for discover", () => {
    expect(() => parseLiveSmokeCommand(["discover", "extra"])).toThrow(
      "The discover command does not accept arguments."
    );
  });

  it("rejects an invalid list limit", () => {
    expect(() => parseLiveSmokeCommand(["list", "--limit", "nope"])).toThrow(
      "The --limit option requires a positive integer."
    );
  });

  it("rejects unknown flags for resume", () => {
    expect(() => parseLiveSmokeCommand(["resume", "codex:thread_1", "--oops"])).toThrow(
      "Unsupported option for resume: --oops"
    );
  });

  it("rejects invalid replay sequence for sessions.subscribe", () => {
    expect(() =>
      parseLiveSmokeCommand(["sessions.subscribe", "codex:thread_1", "--from-seq", "-1"])
    ).toThrow("The --from-seq option requires a non-negative integer.");
  });
});

describe("validateLiveSmokeCommand", () => {
  it("rejects get without a session id", () => {
    expect(() =>
      validateLiveSmokeCommand({
        mode: "command",
        command: "get"
      })
    ).toThrow("The get command requires a session_id.");
  });

  it("rejects resume without a session id", () => {
    expect(() =>
      validateLiveSmokeCommand({
        mode: "command",
        command: "resume"
      })
    ).toThrow("The resume command requires a session_id.");
  });

  it("rejects send-input without text", () => {
    expect(() =>
      validateLiveSmokeCommand({
        mode: "command",
        command: "send-input",
        sessionId: "codex:thread_1"
      })
    ).toThrow("The send-input command requires input text.");
  });

  it("rejects send-input without a session id", () => {
    expect(() =>
      validateLiveSmokeCommand({
        mode: "command",
        command: "send-input",
        inputText: "continue"
      })
    ).toThrow("The send-input command requires a session_id.");
  });

  it("rejects sessions.subscribe without a session id", () => {
    expect(() =>
      validateLiveSmokeCommand({
        mode: "command",
        command: "sessions.subscribe"
      })
    ).toThrow("The sessions.subscribe command requires a session_id.");
  });

  it("rejects approvals.respond without decision", () => {
    expect(() =>
      validateLiveSmokeCommand({
        mode: "command",
        command: "approvals.respond",
        approvalId: "codex:approval_1"
      })
    ).toThrow("The approvals.respond command requires a decision.");
  });

  it("rejects diffs.get without run id", () => {
    expect(() =>
      validateLiveSmokeCommand({
        mode: "command",
        command: "diffs.get",
        sessionId: "codex:thread_1"
      })
    ).toThrow("The diffs.get command requires a run_id.");
  });
});

describe("getLiveSmokeUsage", () => {
  it("renders usage for all supported commands", () => {
    expect(getLiveSmokeUsage()).toContain("discover");
    expect(getLiveSmokeUsage()).toContain("send-input");
    expect(getLiveSmokeUsage()).toContain("sessions.subscribe");
    expect(getLiveSmokeUsage()).toContain("approvals.respond");
    expect(getLiveSmokeUsage()).toContain("npm --workspace @ascp/adapter-codex run live");
  });
});

describe("runLiveSmokeCommand", () => {
  it("returns interactive early without calling dependencies", async () => {
    const calls: string[] = [];

    const result = await runLiveSmokeCommand(
      { mode: "interactive" },
      {
        discover: async () => {
          calls.push("discover");
          return { runtimeAvailable: true, runtimeId: "codex_local" };
        }
      }
    );

    expect(calls).toEqual([]);
    expect(result).toEqual({
      kind: "interactive",
      data: null
    });
  });

  it("dispatches discover through runtime discovery", async () => {
    const calls: string[] = [];

    const result = await runLiveSmokeCommand(
      { mode: "command", command: "discover" },
      {
        discover: async () => {
          calls.push("discover");
          return { runtimeAvailable: true, runtimeId: "codex_local" };
        }
      }
    );

    expect(calls).toEqual(["discover"]);
    expect(result.kind).toBe("discovery");
  });

  it("dispatches list with limit", async () => {
    const calls: Array<Record<string, unknown>> = [];

    const result = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "list",
        limit: 5
      },
      {
        listSessions: async (params) => {
          calls.push(params);
          return { sessions: [], next_cursor: null };
        }
      }
    );

    expect(calls).toEqual([
      {
        limit: 5
      }
    ]);
    expect(result.kind).toBe("list");
  });

  it("dispatches get with includeRuns", async () => {
    const calls: Array<Record<string, unknown>> = [];

    const result = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "get",
        sessionId: "codex:thread_1",
        includeRuns: true
      },
      {
        getSession: async (params) => {
          calls.push(params);
          return { session: { id: "codex:thread_1" }, runs: [] };
        }
      }
    );

    expect(calls).toEqual([
      {
        session_id: "codex:thread_1",
        include_runs: true
      }
    ]);
    expect(result.kind).toBe("get");
  });

  it("dispatches resume with session id", async () => {
    const calls: Array<Record<string, unknown>> = [];

    const result = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "resume",
        sessionId: "codex:thread_1"
      },
      {
        resumeSession: async (params) => {
          calls.push(params);
          return { session: { id: "codex:thread_1" } };
        }
      }
    );

    expect(calls).toEqual([
      {
        session_id: "codex:thread_1"
      }
    ]);
    expect(result.kind).toBe("resume");
  });

  it("dispatches send-input with session id and input text", async () => {
    const calls: Array<Record<string, unknown>> = [];

    const result = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "send-input",
        sessionId: "codex:thread_1",
        inputText: "continue"
      },
      {
        sendInput: async (params) => {
          calls.push(params);
          return { session: { id: "codex:thread_1" } };
        }
      }
    );

    expect(calls).toEqual([
      {
        session_id: "codex:thread_1",
        input: "continue"
      }
    ]);
    expect(result.kind).toBe("send-input");
  });

  it("dispatches sessions.subscribe with replay params", async () => {
    const calls: Array<Record<string, unknown>> = [];

    const result = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "sessions.subscribe",
        sessionId: "codex:thread_1",
        fromSeq: 5,
        fromEventId: "codex:event_1",
        includeSnapshot: true
      },
      {
        subscribeSession: async (params) => {
          calls.push(params);
          return { session_id: "codex:thread_1", subscription_id: "codex:subscription:1" };
        }
      }
    );

    expect(calls).toEqual([
      {
        session_id: "codex:thread_1",
        from_seq: 5,
        from_event_id: "codex:event_1",
        include_snapshot: true
      }
    ]);
    expect(result.kind).toBe("sessions.subscribe");
  });

  it("dispatches sessions.unsubscribe", async () => {
    const calls: Array<Record<string, unknown>> = [];

    const result = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "sessions.unsubscribe",
        subscriptionId: "codex:subscription:1"
      },
      {
        unsubscribeSession: async (params) => {
          calls.push(params);
          return { subscription_id: "codex:subscription:1", unsubscribed: true };
        }
      }
    );

    expect(calls).toEqual([
      {
        subscription_id: "codex:subscription:1"
      }
    ]);
    expect(result.kind).toBe("sessions.unsubscribe");
  });

  it("dispatches approvals list and respond", async () => {
    const listCalls: Array<Record<string, unknown>> = [];
    const respondCalls: Array<Record<string, unknown>> = [];

    const listResult = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "approvals.list",
        sessionId: "codex:thread_1",
        status: "pending",
        limit: 10,
        cursor: "2"
      },
      {
        listApprovals: async (params) => {
          listCalls.push(params);
          return { approvals: [], next_cursor: null };
        }
      }
    );

    const respondResult = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "approvals.respond",
        approvalId: "codex:approval_1",
        decision: "approved",
        note: "looks safe"
      },
      {
        respondApproval: async (params) => {
          respondCalls.push(params);
          return { approval_id: "codex:approval_1", status: "approved" };
        }
      }
    );

    expect(listCalls).toEqual([
      {
        session_id: "codex:thread_1",
        status: "pending",
        limit: 10,
        cursor: "2"
      }
    ]);
    expect(respondCalls).toEqual([
      {
        approval_id: "codex:approval_1",
        decision: "approved",
        note: "looks safe"
      }
    ]);
    expect(listResult.kind).toBe("approvals.list");
    expect(respondResult.kind).toBe("approvals.respond");
  });

  it("dispatches artifacts and diffs commands", async () => {
    const artifactListCalls: Array<Record<string, unknown>> = [];
    const artifactGetCalls: Array<Record<string, unknown>> = [];
    const diffCalls: Array<Record<string, unknown>> = [];

    const listResult = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "artifacts.list",
        sessionId: "codex:thread_1",
        runId: "codex:run_1",
        kind: "diff"
      },
      {
        listArtifacts: async (params) => {
          artifactListCalls.push(params);
          return { artifacts: [] };
        }
      }
    );

    const getResult = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "artifacts.get",
        artifactId: "codex:artifact_1"
      },
      {
        getArtifact: async (params) => {
          artifactGetCalls.push(params);
          return { artifact: { id: "codex:artifact_1" } };
        }
      }
    );

    const diffResult = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "diffs.get",
        sessionId: "codex:thread_1",
        runId: "codex:run_1"
      },
      {
        getDiff: async (params) => {
          diffCalls.push(params);
          return { diff: { session_id: "codex:thread_1", run_id: "codex:run_1", files_changed: 0 } };
        }
      }
    );

    expect(artifactListCalls).toEqual([
      {
        session_id: "codex:thread_1",
        run_id: "codex:run_1",
        kind: "diff"
      }
    ]);
    expect(artifactGetCalls).toEqual([
      {
        artifact_id: "codex:artifact_1"
      }
    ]);
    expect(diffCalls).toEqual([
      {
        session_id: "codex:thread_1",
        run_id: "codex:run_1"
      }
    ]);
    expect(listResult.kind).toBe("artifacts.list");
    expect(getResult.kind).toBe("artifacts.get");
    expect(diffResult.kind).toBe("diffs.get");
  });
});

describe("runInteractiveLiveSmoke", () => {
  it("exits cleanly when discovery reports no runtime", async () => {
    const calls: string[] = [];
    let output = "";

    const input = Readable.from([]);
    const sink = new Writable({
      write(chunk, _encoding, callback) {
        output += chunk.toString();
        callback();
      }
    });

    await runInteractiveLiveSmoke({
      input,
      output: sink,
      deps: {
        discover: async () => {
          calls.push("discover");
          return {
            runtimeAvailable: false,
            runtimeId: "codex_local"
          };
        },
        listSessions: async () => {
          calls.push("list");
          return { sessions: [], next_cursor: null };
        }
      }
    });

    expect(calls).toEqual(["discover"]);
    expect(output).toContain('"runtimeAvailable": false');
    expect(output).toContain("Codex runtime is unavailable");
  });

  it("keeps the session menu alive after an action failure", async () => {
    let output = "";
    const getCalls: string[] = [];
    const sink = new Writable({
      write(chunk, _encoding, callback) {
        output += chunk.toString();
        callback();
      }
    });
    const answers = ["g", "y", "q"];

    const result = await runInteractiveSessionMenu(
      async () => answers.shift() ?? "q",
      sink,
      {
        id: "codex:thread_1",
        runtime_id: "codex_local",
        status: "idle",
        created_at: "2026-04-26T19:00:00.000Z",
        updated_at: "2026-04-26T19:00:00.000Z",
        title: "Test session"
      },
      {
        getSession: async (params) => {
          getCalls.push(String(params.session_id));
          throw new Error("Session read failed.");
        }
      }
    );

    expect(getCalls).toEqual(["codex:thread_1"]);
    expect(result).toBe("quit");
    expect(output).toContain("Action failed: Session read failed.");
    expect(output).toContain("Selected codex:thread_1");
  });

  it("supports interactive subscribe, approvals, artifacts, and diff actions", async () => {
    let output = "";
    const subscribeCalls: Array<Record<string, unknown>> = [];
    const drainCalls: Array<Record<string, unknown>> = [];
    const unsubscribeCalls: Array<Record<string, unknown>> = [];
    const approvalListCalls: Array<Record<string, unknown>> = [];
    const approvalRespondCalls: Array<Record<string, unknown>> = [];
    const artifactListCalls: Array<Record<string, unknown>> = [];
    const artifactGetCalls: Array<Record<string, unknown>> = [];
    const diffCalls: Array<Record<string, unknown>> = [];
    const sink = new Writable({
      write(chunk, _encoding, callback) {
        output += chunk.toString();
        callback();
      }
    });
    const answers = [
      "p",
      "y",
      "3",
      "",
      "",
      "y",
      "a",
      "pending",
      "codex:approval_1",
      "approved",
      "looks safe",
      "y",
      "t",
      "codex:run_1",
      "diff",
      "codex:artifact_1",
      "d",
      "codex:run_1",
      "q"
    ];

    const result = await runInteractiveSessionMenu(
      async () => answers.shift() ?? "q",
      sink,
      {
        id: "codex:thread_1",
        runtime_id: "codex_local",
        status: "idle",
        created_at: "2026-04-26T19:00:00.000Z",
        updated_at: "2026-04-26T19:00:00.000Z",
        title: "Test session"
      },
      {
        subscribeSession: async (params) => {
          subscribeCalls.push(params);
          return {
            session_id: "codex:thread_1",
            subscription_id: "codex:subscription:1",
            snapshot_emitted: true
          };
        },
        drainSubscriptionEvents: (params) => {
          drainCalls.push(params);
          return [{ id: "codex:event:1", seq: 4 }];
        },
        unsubscribeSession: async (params) => {
          unsubscribeCalls.push(params);
          return {
            subscription_id: String(params.subscription_id),
            unsubscribed: true
          };
        },
        listApprovals: async (params) => {
          approvalListCalls.push(params);
          return {
            approvals: [
              {
                id: "codex:approval_1",
                session_id: "codex:thread_1",
                kind: "command",
                status: "pending",
                created_at: "2026-04-26T19:00:00.000Z"
              }
            ],
            next_cursor: null
          };
        },
        respondApproval: async (params) => {
          approvalRespondCalls.push(params);
          return { approval_id: "codex:approval_1", status: "approved" };
        },
        listArtifacts: async (params) => {
          artifactListCalls.push(params);
          return {
            artifacts: [
              {
                id: "codex:artifact_1",
                session_id: "codex:thread_1",
                kind: "diff",
                created_at: "2026-04-26T19:00:00.000Z"
              }
            ]
          };
        },
        getArtifact: async (params) => {
          artifactGetCalls.push(params);
          return {
            artifact: {
              id: "codex:artifact_1",
              session_id: "codex:thread_1",
              kind: "diff",
              created_at: "2026-04-26T19:00:00.000Z"
            }
          };
        },
        getDiff: async (params) => {
          diffCalls.push(params);
          return {
            diff: {
              session_id: "codex:thread_1",
              run_id: "codex:run_1",
              files_changed: 2
            }
          };
        }
      }
    );

    expect(subscribeCalls).toEqual([
      {
        session_id: "codex:thread_1",
        from_seq: 3,
        from_event_id: undefined,
        include_snapshot: true
      }
    ]);
    expect(drainCalls).toEqual([
      {
        subscription_id: "codex:subscription:1",
        limit: undefined
      }
    ]);
    expect(unsubscribeCalls).toEqual([
      {
        subscription_id: "codex:subscription:1"
      }
    ]);
    expect(approvalListCalls).toEqual([
      {
        session_id: "codex:thread_1",
        status: "pending",
        limit: undefined,
        cursor: undefined
      }
    ]);
    expect(approvalRespondCalls).toEqual([
      {
        approval_id: "codex:approval_1",
        decision: "approved",
        note: "looks safe"
      }
    ]);
    expect(artifactListCalls).toEqual([
      {
        session_id: "codex:thread_1",
        run_id: "codex:run_1",
        kind: "diff"
      }
    ]);
    expect(artifactGetCalls).toEqual([
      {
        artifact_id: "codex:artifact_1"
      }
    ]);
    expect(diffCalls).toEqual([
      {
        session_id: "codex:thread_1",
        run_id: "codex:run_1"
      }
    ]);
    expect(result).toBe("quit");
    expect(output).toContain("subscribe+drain");
    expect(output).toContain("codex:subscription:1");
  });
});
