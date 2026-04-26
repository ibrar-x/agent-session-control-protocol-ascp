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
});

describe("getLiveSmokeUsage", () => {
  it("renders usage for all supported commands", () => {
    expect(getLiveSmokeUsage()).toContain("discover");
    expect(getLiveSmokeUsage()).toContain("send-input");
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
});
