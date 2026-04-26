import { describe, expect, it } from "vitest";

import {
  buildCodexDiscovery,
  discoverCodexRuntime,
  type CodexDiscoveryClient,
  type CodexObservedSurface
} from "../src/discovery.js";

class FakeDiscoveryClient implements CodexDiscoveryClient {
  private readonly error: Error | null;
  private readonly initializeResult: Record<string, unknown> | null;
  private readonly observedSurface: CodexObservedSurface;

  constructor(options: {
    error?: Error;
    initializeResult?: Record<string, unknown>;
    observedSurface?: CodexObservedSurface;
  }) {
    this.error = options.error ?? null;
    this.initializeResult = options.initializeResult ?? null;
    this.observedSurface = options.observedSurface ?? {};
  }

  async initialize(): Promise<Record<string, unknown>> {
    if (this.error !== null) {
      throw this.error;
    }

    return this.initializeResult ?? {};
  }

  getObservedSurface(): CodexObservedSurface {
    return this.observedSurface;
  }
}

describe("discoverCodexRuntime", () => {
  it("derives runtime availability, version, and observed surface from initialize metadata", async () => {
    const discovery = await discoverCodexRuntime(
      new FakeDiscoveryClient({
        initializeResult: {
          serverInfo: {
            name: "codex-app-server",
            version: "0.34.0"
          },
          userAgent: "codex-cli/0.34.0"
        },
        observedSurface: {
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
            "thread/started",
            "thread/status/changed",
            "turn/started",
            "turn/completed",
            "turn/diff/updated"
          ],
          approvalRequestsObserved: true
        }
      })
    );

    expect(discovery).toEqual({
      runtimeAvailable: true,
      runtimeId: "codex_local",
      version: "0.34.0",
      appServerMethods: [
        "initialize",
        "thread/list",
        "thread/read",
        "thread/start",
        "thread/resume",
        "turn/start",
        "turn/steer"
      ],
      notifications: [
        "thread/started",
        "thread/status/changed",
        "turn/started",
        "turn/completed",
        "turn/diff/updated"
      ],
      supportsApprovalRequests: true,
      supportsApprovalRespond: false,
      supportsTurnDiffs: true
    });
  });

  it("falls back to the user agent for version detection when server info omits it", () => {
    const discovery = buildCodexDiscovery({
      runtimeAvailable: true,
      initializeResult: {
        userAgent: "codex-cli/0.31.2"
      },
      observedSurface: {
        methods: ["initialize", "thread/list"],
        notifications: []
      }
    });

    expect(discovery.version).toBe("0.31.2");
  });

  it("reports the runtime as unavailable when initialize fails", async () => {
    const discovery = await discoverCodexRuntime(
      new FakeDiscoveryClient({
        error: new Error("codex app-server unavailable")
      })
    );

    expect(discovery).toEqual({
      runtimeAvailable: false,
      runtimeId: "codex_local",
      version: null,
      appServerMethods: [],
      notifications: [],
      supportsApprovalRequests: false,
      supportsApprovalRespond: false,
      supportsTurnDiffs: false
    });
  });
});
