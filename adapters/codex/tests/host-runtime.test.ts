import { describe, expect, it } from "vitest";

import { CodexHostRuntime, createCodexHostRuntime, createDefaultCodexHostRuntime } from "../src/host-runtime.js";
import type {
  CodexAppServerInitializeResult,
  CodexJsonRpcNotification,
  CodexObservedSurface
} from "../src/app-server-client.js";

class FakeCodexClient {
  readonly notifications: Array<(notification: CodexJsonRpcNotification) => void> = [];
  observedSurface: CodexObservedSurface = {
    methods: [
      "initialize",
      "thread/list",
      "thread/read",
      "thread/start",
      "thread/resume",
      "turn/start",
      "turn/steer"
    ],
    notifications: [
      "turn/started",
      "turn/completed"
    ]
  };
  initializeResult: CodexAppServerInitializeResult = {
    serverInfo: {
      name: "codex-app-server",
      version: "0.34.0"
    }
  };
  threadListResult: unknown = {
    data: []
  };
  threadReadResult: unknown = {
    thread: {
      id: "thread-1",
      title: "Test session",
      status: "idle",
      createdAt: "2026-04-26T00:00:00.000Z",
      updatedAt: "2026-04-26T00:00:00.000Z",
      turns: []
    }
  };
  threadStartResult: unknown = {
    thread: {
      id: "thread-start",
      title: "Started session",
      status: {
        type: "idle"
      },
      createdAt: "2026-04-26T00:00:00.000Z",
      updatedAt: "2026-04-26T00:00:00.000Z",
      turns: []
    }
  };

  async initialize(): Promise<CodexAppServerInitializeResult> {
    return this.initializeResult;
  }

  getObservedSurface(): CodexObservedSurface {
    return this.observedSurface;
  }

  async threadList(): Promise<unknown> {
    return this.threadListResult;
  }

  async threadRead(): Promise<unknown> {
    return this.threadReadResult;
  }

  async threadStart(): Promise<unknown> {
    return this.threadStartResult;
  }

  async threadResume(): Promise<unknown> {
    return this.threadReadResult;
  }

  async turnStart(): Promise<unknown> {
    return {};
  }

  async turnSteer(): Promise<unknown> {
    return {};
  }

  onNotification(listener: (notification: CodexJsonRpcNotification) => void): () => void {
    this.notifications.push(listener);
    return () => {};
  }
}

describe("createCodexHostRuntime", () => {
  it("builds a truthful capability document and runtime list from discovery", async () => {
    const runtime = createCodexHostRuntime(new FakeCodexClient());
    const capabilities = await runtime.capabilitiesGet();
    const runtimes = await runtime.runtimesList();

    expect(capabilities.protocol_version).toBe("0.1.0");
    expect(capabilities.transports).toEqual(["websocket"]);
    expect(capabilities.runtimes).toHaveLength(1);
    expect(capabilities.runtimes[0]?.id).toBe("codex_local");
    expect(capabilities.capabilities.stream_events).toBe(true);
    expect(runtimes.runtimes[0]?.display_name).toBe("Codex");
  });

  it("filters runtimes and forwards session reads to the underlying adapter service", async () => {
    const runtime = createCodexHostRuntime(new FakeCodexClient());
    const emptyRuntimes = await runtime.runtimesList({
      kind: "other"
    });
    const sessions = await runtime.sessionsList({
      runtime_id: "codex_local"
    });

    expect(emptyRuntimes.runtimes).toEqual([]);
    expect(sessions.sessions).toEqual([]);
  });

  it("forwards sessions.start to the adapter service", async () => {
    const runtime = createCodexHostRuntime(new FakeCodexClient());
    const started = await runtime.sessionsStart({
      runtime_id: "codex_local"
    });

    expect(started.session.id).toBe("codex:thread-start");
  });

  it("exposes a default runtime constructor so daemon bootstrap does not build Codex wiring itself", () => {
    const runtime = createDefaultCodexHostRuntime(new FakeCodexClient());

    expect(runtime).toBeInstanceOf(CodexHostRuntime);
  });
});
