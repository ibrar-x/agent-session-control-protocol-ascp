import { describe, expect, it } from "vitest";

import {
  parseLiveSmokeCommand,
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
