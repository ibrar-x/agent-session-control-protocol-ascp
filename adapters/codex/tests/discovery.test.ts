import { chmod, mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";

import { afterEach, describe, expect, it } from "vitest";

import {
  CODEX_RUNTIME_ID,
  VERIFIED_CODEX_APP_SERVER_METHODS,
  VERIFIED_CODEX_APP_SERVER_NOTIFICATIONS,
  buildCodexDiscovery,
  discoverCodexRuntime,
  type CodexDiscoveryClient
} from "../src/discovery.js";
import {
  CodexAppServerClient,
  StdioCodexAppServerTransport,
  type CodexAppServerInitializeResult,
  type CodexAppServerRequestOptions,
  type CodexAppServerTransport,
  type CodexJsonRpcNotification,
  type CodexObservedSurface
} from "../src/app-server-client.js";

const TEMP_DIRS: string[] = [];

async function createTempDir(): Promise<string> {
  const directory = await mkdtemp(join(tmpdir(), "codex-adapter-"));
  TEMP_DIRS.push(directory);
  return directory;
}

async function writeExecutableScript(filePath: string, body: string): Promise<void> {
  await writeFile(filePath, `#!/usr/bin/env node\n${body}`, "utf8");
  await chmod(filePath, 0o755);
}

afterEach(async () => {
  while (TEMP_DIRS.length > 0) {
    const directory = TEMP_DIRS.pop();

    if (directory !== undefined) {
      await rm(directory, { force: true, recursive: true });
    }
  }
});

class FakeDiscoveryClient implements CodexDiscoveryClient {
  private readonly error: Error | null;
  private readonly initializeResult: CodexAppServerInitializeResult | null;
  private readonly observedSurface: CodexObservedSurface;

  constructor(options: {
    error?: Error;
    initializeResult?: CodexAppServerInitializeResult;
    observedSurface?: CodexObservedSurface;
  }) {
    this.error = options.error ?? null;
    this.initializeResult = options.initializeResult ?? null;
    this.observedSurface = options.observedSurface ?? {};
  }

  async initialize(): Promise<CodexAppServerInitializeResult> {
    if (this.error !== null) {
      throw this.error;
    }

    return this.initializeResult ?? {};
  }

  getObservedSurface(): CodexObservedSurface {
    return this.observedSurface;
  }
}

class FakeTransport implements CodexAppServerTransport {
  private readonly responses = new Map<string, unknown>();
  private readonly failures = new Map<string, Error>();

  async close(): Promise<void> {}

  async connect(): Promise<void> {}

  onNotification(_listener: (notification: CodexJsonRpcNotification) => void): () => void {
    return () => {};
  }

  queueSuccess(method: string, result: unknown): void {
    this.responses.set(method, result);
  }

  queueFailure(method: string, error: Error): void {
    this.failures.set(method, error);
  }

  async request<TResult = unknown>(
    method: string,
    _params?: Record<string, unknown>,
    _options?: CodexAppServerRequestOptions
  ): Promise<TResult> {
    const failure = this.failures.get(method);

    if (failure !== undefined) {
      throw failure;
    }

    return this.responses.get(method) as TResult;
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
      verifiedAppServerMethods: [...VERIFIED_CODEX_APP_SERVER_METHODS],
      observedAppServerMethods: [
        "initialize",
        "thread/list",
        "thread/read",
        "thread/start",
        "thread/resume",
        "turn/start",
        "turn/steer"
      ],
      appServerMethods: [
        "initialize",
        "thread/list",
        "thread/read",
        "thread/start",
        "thread/resume",
        "turn/start",
        "turn/steer"
      ],
      verifiedNotifications: [...VERIFIED_CODEX_APP_SERVER_NOTIFICATIONS],
      observedNotifications: [
        "thread/started",
        "thread/status/changed",
        "turn/started",
        "turn/completed",
        "turn/diff/updated"
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
      supportsDiffReads: false
    });
  });

  it("falls back to the user agent for version detection when server info omits it", () => {
    const discovery = buildCodexDiscovery({
      runtimeAvailable: true,
      initializeResult: {
        userAgent: "codex-cli/0.31.2"
      },
      liveObservedSurface: {
        methods: ["initialize", "thread/list"],
        notifications: []
      }
    });

    expect(discovery.version).toBe("0.31.2");
  });

  it("uses verified official surfaces for a fresh client path without manual prepopulation", async () => {
    const discovery = await discoverCodexRuntime(
      new FakeDiscoveryClient({
        initializeResult: {
          serverInfo: {
            version: "0.34.0"
          }
        },
        observedSurface: {}
      })
    );

    expect(discovery.runtimeId).toBe(CODEX_RUNTIME_ID);
    expect(discovery.appServerMethods).toEqual([...VERIFIED_CODEX_APP_SERVER_METHODS]);
    expect(discovery.notifications).toEqual([...VERIFIED_CODEX_APP_SERVER_NOTIFICATIONS]);
    expect(discovery.supportsApprovalRequests).toBe(true);
    expect(discovery.supportsApprovalRespond).toBe(false);
    expect(discovery.supportsDiffReads).toBe(false);
  });

  it("treats caller-supplied observed surface as fallback instead of overriding live runtime observations", async () => {
    const discovery = await discoverCodexRuntime(
      new FakeDiscoveryClient({
        initializeResult: {
          serverInfo: {
            version: "0.34.0"
          }
        },
        observedSurface: {
          methods: ["thread/read"],
          notifications: ["turn/completed"],
          approvalRequestsObserved: false,
          approvalRespondSupported: false
        }
      }),
      {
        methods: ["x/fallback-only-method"],
        notifications: ["x/fallback-only-notification"],
        approvalRequestsObserved: true,
        approvalRespondSupported: true,
        diffReadSupported: true
      }
    );

    expect(discovery.observedAppServerMethods).toEqual(["thread/read"]);
    expect(discovery.appServerMethods).not.toContain("x/fallback-only-method");
    expect(discovery.observedNotifications).toEqual(["turn/completed"]);
    expect(discovery.notifications).not.toContain("x/fallback-only-notification");
    expect(discovery.supportsApprovalRequests).toBe(false);
    expect(discovery.supportsApprovalRespond).toBe(false);
    expect(discovery.supportsDiffReads).toBe(false);
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
      verifiedAppServerMethods: [...VERIFIED_CODEX_APP_SERVER_METHODS],
      observedAppServerMethods: [],
      appServerMethods: [],
      verifiedNotifications: [...VERIFIED_CODEX_APP_SERVER_NOTIFICATIONS],
      observedNotifications: [],
      notifications: [],
      supportsApprovalRequests: false,
      supportsApprovalRespond: false,
      supportsDiffReads: false
    });
  });
});

describe("CodexAppServerClient", () => {
  it("records a method only after a successful RPC response", async () => {
    const transport = new FakeTransport();
    transport.queueFailure("thread/list", new Error("boom"));
    transport.queueSuccess("thread/read", { ok: true });

    const client = new CodexAppServerClient({
      transport
    });

    await expect(client.threadList()).rejects.toThrow("boom");
    expect(client.getObservedSurface().methods ?? []).toEqual([]);

    await expect(client.threadRead("thread_1")).resolves.toEqual({ ok: true });
    expect(client.getObservedSurface().methods ?? []).toEqual(["thread/read"]);
  });
});

describe("StdioCodexAppServerTransport", () => {
  it("resets state after a spawn failure so a later retry can connect", async () => {
    const directory = await createTempDir();
    const serverPath = join(directory, "codex-app-server");
    const transport = new StdioCodexAppServerTransport({
      command: [serverPath]
    });

    await expect(transport.connect()).rejects.toBeInstanceOf(Error);
    expect((transport as unknown as { child: unknown }).child).toBeNull();

    await writeExecutableScript(
      serverPath,
      `
process.stdin.setEncoding("utf8");
let buffer = "";
process.stdin.on("data", (chunk) => {
  buffer += chunk;
  const lines = buffer.split("\\n");
  buffer = lines.pop() ?? "";
  for (const line of lines) {
    if (line.trim().length === 0) continue;
    const request = JSON.parse(line);
    process.stdout.write(JSON.stringify({ jsonrpc: "2.0", id: request.id, result: { ok: true } }) + "\\n");
  }
});
setInterval(() => {}, 1_000);
`
    );

    await expect(transport.request("initialize", {})).resolves.toEqual({ ok: true });
    await transport.close();
  });

  it("converts malformed stdout JSON into a transport failure and allows retry", async () => {
    const directory = await createTempDir();
    const serverPath = join(directory, "codex-app-server");
    const transport = new StdioCodexAppServerTransport({
      command: [serverPath]
    });

    await writeExecutableScript(
      serverPath,
      `
process.stdout.write("not json\\n");
setInterval(() => {}, 1_000);
`
    );

    await expect(transport.request("initialize", {})).rejects.toThrow(
      "Failed to parse Codex app-server JSON-RPC message."
    );
    expect((transport as unknown as { child: unknown }).child).toBeNull();

    await writeExecutableScript(
      serverPath,
      `
process.stdin.setEncoding("utf8");
let buffer = "";
process.stdin.on("data", (chunk) => {
  buffer += chunk;
  const lines = buffer.split("\\n");
  buffer = lines.pop() ?? "";
  for (const line of lines) {
    if (line.trim().length === 0) continue;
    const request = JSON.parse(line);
    process.stdout.write(JSON.stringify({ jsonrpc: "2.0", id: request.id, result: { ok: true, method: request.method } }) + "\\n");
  }
});
setInterval(() => {}, 1_000);
`
    );

    await expect(transport.request("initialize", {})).resolves.toEqual({
      ok: true,
      method: "initialize"
    });
    await transport.close();
  });
});
