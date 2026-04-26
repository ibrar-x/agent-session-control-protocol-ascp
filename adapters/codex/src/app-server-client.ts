import { spawn, type ChildProcessWithoutNullStreams } from "node:child_process";
import { createInterface, type Interface as ReadLineInterface } from "node:readline";

export interface CodexJsonRpcMessage {
  jsonrpc?: "2.0";
  id?: string | number;
  method?: string;
  params?: unknown;
  result?: unknown;
  error?: unknown;
}

export interface CodexJsonRpcNotification extends CodexJsonRpcMessage {
  id?: undefined;
  method: string;
}

export interface CodexAppServerInitializeResult extends Record<string, unknown> {
  userAgent?: string;
  codexHome?: string;
  serverInfo?: {
    name?: string;
    version?: string;
    userAgent?: string;
    [key: string]: unknown;
  };
}

export interface CodexObservedSurface {
  methods?: Iterable<string>;
  notifications?: Iterable<string>;
  approvalRequestsObserved?: boolean;
  approvalRespondSupported?: boolean;
}

export interface CodexAppServerRequestOptions {
  signal?: AbortSignal;
  timeoutMs?: number;
}

export interface CodexAppServerTransport {
  close(): Promise<void>;
  connect(): Promise<void>;
  onNotification(listener: (notification: CodexJsonRpcNotification) => void): () => void;
  request<TResult = unknown>(
    method: string,
    params?: Record<string, unknown>,
    options?: CodexAppServerRequestOptions
  ): Promise<TResult>;
}

export interface CodexAppServerClientOptions {
  command?: readonly [string, ...string[]];
  cwd?: string;
  env?: NodeJS.ProcessEnv;
  observedSurface?: CodexObservedSurface;
  timeoutMs?: number;
  transport?: CodexAppServerTransport;
}

interface PendingRequest {
  cleanup: () => void;
  reject: (reason?: unknown) => void;
  resolve: (value: unknown) => void;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function normalizeValues(values?: Iterable<string>): string[] {
  if (values === undefined) {
    return [];
  }

  const normalized = new Set<string>();

  for (const value of values) {
    if (typeof value === "string" && value.length > 0) {
      normalized.add(value);
    }
  }

  return [...normalized];
}

export class CodexJsonRpcError extends Error {
  readonly code: number | null;
  readonly data: unknown;

  constructor(error: unknown) {
    const code = isRecord(error) && typeof error.code === "number" ? error.code : null;
    const message =
      isRecord(error) && typeof error.message === "string"
        ? error.message
        : "Codex app-server returned a JSON-RPC error.";

    super(message);
    this.name = "CodexJsonRpcError";
    this.code = code;
    this.data = isRecord(error) ? error.data : undefined;
  }
}

export class StdioCodexAppServerTransport implements CodexAppServerTransport {
  private readonly command: readonly [string, ...string[]];
  private readonly cwd: string | undefined;
  private readonly env: NodeJS.ProcessEnv | undefined;
  private readonly listeners = new Set<(notification: CodexJsonRpcNotification) => void>();
  private readonly pendingRequests = new Map<number, PendingRequest>();

  private child: ChildProcessWithoutNullStreams | null = null;
  private stdoutReader: ReadLineInterface | null = null;
  private connectPromise: Promise<void> | null = null;
  private nextRequestId = 1;

  constructor(options: {
    command?: readonly [string, ...string[]];
    cwd?: string;
    env?: NodeJS.ProcessEnv;
  } = {}) {
    this.command = options.command ?? ["codex", "app-server"];
    this.cwd = options.cwd;
    this.env = options.env;
  }

  async connect(): Promise<void> {
    if (this.child !== null) {
      return;
    }

    if (this.connectPromise !== null) {
      return this.connectPromise;
    }

    this.connectPromise = new Promise<void>((resolve, reject) => {
      const [command, ...args] = this.command;
      const child = spawn(command, args, {
        cwd: this.cwd,
        env: this.env,
        stdio: "pipe"
      });
      let settled = false;
      let stderrBuffer = "";

      this.child = child;
      const stdoutReader = createInterface({
        input: child.stdout,
        crlfDelay: Infinity
      });
      this.stdoutReader = stdoutReader;

      stdoutReader.on("line", (line) => {
        this.handleLine(line, child, stdoutReader, () => stderrBuffer);
      });

      child.stderr.setEncoding("utf8");
      child.stderr.on("data", (chunk: string) => {
        stderrBuffer = `${stderrBuffer}${chunk}`.slice(-4_096);
      });

      child.once("spawn", () => {
        settled = true;
        resolve();
      });

      child.once("error", (error) => {
        if (!settled) {
          settled = true;
          reject(error);
        }

        this.handleTransportFailure(error, child, stdoutReader);
      });

      child.once("exit", (code, signal) => {
        const error = new Error(
          `Codex app-server exited unexpectedly (code=${String(code)}, signal=${String(signal)}).`
        );

        if (!settled) {
          settled = true;
          reject(error);
        }

        this.handleTransportFailure(error, child, stdoutReader);
      });
    }).finally(() => {
      this.connectPromise = null;
    });

    return this.connectPromise;
  }

  async close(): Promise<void> {
    this.failPending(new Error("Codex app-server transport closed."));

    const child = this.child;
    this.child = null;

    this.stdoutReader?.close();
    this.stdoutReader = null;

    if (child === null) {
      return;
    }

    if (!child.stdin.destroyed) {
      child.stdin.end();
    }

    if (!child.killed) {
      child.kill();
    }

    await new Promise<void>((resolve) => {
      child.once("exit", () => {
        resolve();
      });
      child.once("close", () => {
        resolve();
      });
      setTimeout(resolve, 250);
    });
  }

  onNotification(listener: (notification: CodexJsonRpcNotification) => void): () => void {
    this.listeners.add(listener);

    return () => {
      this.listeners.delete(listener);
    };
  }

  async request<TResult = unknown>(
    method: string,
    params?: Record<string, unknown>,
    options: CodexAppServerRequestOptions = {}
  ): Promise<TResult> {
    await this.connect();

    const child = this.child;

    if (child === null || child.stdin.destroyed) {
      throw new Error("Codex app-server transport is not writable.");
    }

    const requestId = this.nextRequestId++;
    const request: CodexJsonRpcMessage = {
      jsonrpc: "2.0",
      id: requestId,
      method
    };

    if (params !== undefined) {
      request.params = params;
    }

    return new Promise<TResult>((resolve, reject) => {
      const cleanupParts: Array<() => void> = [];

      const cleanup = () => {
        this.pendingRequests.delete(requestId);

        while (cleanupParts.length > 0) {
          cleanupParts.pop()?.();
        }
      };

      if (options.timeoutMs !== undefined) {
        const timeout = setTimeout(() => {
          cleanup();
          reject(new Error(`Codex app-server request timed out after ${options.timeoutMs}ms.`));
        }, options.timeoutMs);

        cleanupParts.push(() => {
          clearTimeout(timeout);
        });
      }

      if (options.signal !== undefined) {
        if (options.signal.aborted) {
          cleanup();
          reject(new Error(`Codex app-server request for ${method} was aborted.`));
          return;
        }

        const onAbort = () => {
          cleanup();
          reject(new Error(`Codex app-server request for ${method} was aborted.`));
        };

        options.signal.addEventListener("abort", onAbort, { once: true });
        cleanupParts.push(() => {
          options.signal?.removeEventListener("abort", onAbort);
        });
      }

      this.pendingRequests.set(requestId, {
        cleanup,
        reject,
        resolve: (value) => {
          resolve(value as TResult);
        }
      });

      child.stdin.write(`${JSON.stringify(request)}\n`, (error) => {
        if (error) {
          cleanup();
          reject(error);
        }
      });
    });
  }

  private failPending(error: unknown): void {
    for (const pending of this.pendingRequests.values()) {
      pending.cleanup();
      pending.reject(error);
    }

    this.pendingRequests.clear();
  }

  private handleTransportFailure(
    error: unknown,
    child: ChildProcessWithoutNullStreams | null,
    stdoutReader: ReadLineInterface | null
  ): void {
    this.resetConnectionState(child, stdoutReader);
    this.failPending(error);
  }

  private resetConnectionState(
    child: ChildProcessWithoutNullStreams | null = this.child,
    stdoutReader: ReadLineInterface | null = this.stdoutReader
  ): void {
    if (this.child === child) {
      this.child = null;
    }

    if (this.stdoutReader === stdoutReader) {
      this.stdoutReader = null;
    }

    stdoutReader?.removeAllListeners();
    stdoutReader?.close();

    if (child === null) {
      return;
    }

    child.removeAllListeners();
    child.stdin.removeAllListeners();
    child.stdout.removeAllListeners();
    child.stderr.removeAllListeners();

    if (!child.stdin.destroyed) {
      child.stdin.destroy();
    }

    if (!child.stdout.destroyed) {
      child.stdout.destroy();
    }

    if (!child.stderr.destroyed) {
      child.stderr.destroy();
    }

    if (child.exitCode === null && child.signalCode === null && !child.killed) {
      child.kill();
    }
  }

  private handleLine(
    line: string,
    child: ChildProcessWithoutNullStreams | null,
    stdoutReader: ReadLineInterface | null,
    getStderrBuffer: () => string
  ): void {
    let message: CodexJsonRpcMessage;

    try {
      const parsed = JSON.parse(line) as unknown;

      if (!isRecord(parsed)) {
        throw new Error("Codex app-server emitted a non-object JSON-RPC message.");
      }

      message = parsed as CodexJsonRpcMessage;
    } catch (error) {
      this.handleTransportFailure(
        new Error(
          `Failed to parse Codex app-server JSON-RPC message.${getStderrBuffer() ? ` stderr=${getStderrBuffer()}` : ""}`
        ),
        child,
        stdoutReader
      );
      return;
    }

    if (message.id !== undefined) {
      const pending = this.pendingRequests.get(Number(message.id));

      if (pending === undefined) {
        return;
      }

      pending.cleanup();

      if (message.error !== undefined) {
        pending.reject(new CodexJsonRpcError(message.error));
        return;
      }

      pending.resolve(message.result);
      return;
    }

    if (typeof message.method !== "string") {
      return;
    }

    const notification: CodexJsonRpcNotification = {
      jsonrpc: "2.0",
      method: message.method,
      params: message.params
    };

    for (const listener of this.listeners) {
      listener(notification);
    }
  }
}

export class CodexAppServerClient {
  private readonly transport: CodexAppServerTransport;
  private readonly defaultTimeoutMs: number | undefined;
  private readonly observedMethods = new Set<string>();
  private readonly observedNotifications = new Set<string>();
  private approvalRequestsObserved: boolean | undefined;
  private approvalRespondSupported: boolean | undefined;
  private readonly removeTransportListener: (() => void) | null;

  constructor(options: CodexAppServerClientOptions = {}) {
    this.transport =
      options.transport ??
      new StdioCodexAppServerTransport({
        command: options.command,
        cwd: options.cwd,
        env: options.env
      });

    this.defaultTimeoutMs = options.timeoutMs;

    for (const method of normalizeValues(options.observedSurface?.methods)) {
      this.observedMethods.add(method);
    }

    for (const notification of normalizeValues(options.observedSurface?.notifications)) {
      this.observedNotifications.add(notification);
    }

    this.approvalRequestsObserved = options.observedSurface?.approvalRequestsObserved;
    this.approvalRespondSupported = options.observedSurface?.approvalRespondSupported;

    this.removeTransportListener = this.transport.onNotification((notification) => {
      this.observedNotifications.add(notification.method);
    });
  }

  async close(): Promise<void> {
    this.removeTransportListener?.();
    await this.transport.close();
  }

  getObservedSurface(): CodexObservedSurface {
    return {
      methods: [...this.observedMethods],
      notifications: [...this.observedNotifications],
      approvalRequestsObserved: this.approvalRequestsObserved,
      approvalRespondSupported: this.approvalRespondSupported
    };
  }

  markApprovalRequestObserved(): void {
    this.approvalRequestsObserved = true;
  }

  markApprovalResponseSupported(): void {
    this.approvalRespondSupported = true;
  }

  async initialize(): Promise<CodexAppServerInitializeResult> {
    return this.request<CodexAppServerInitializeResult>("initialize", {
      clientInfo: {
        name: "@ascp/adapter-codex",
        version: "0.1.0"
      },
      capabilities: {}
    });
  }

  async threadList(limit = 20): Promise<unknown> {
    return this.request("thread/list", {
      limit
    });
  }

  async threadRead(threadId: string): Promise<unknown> {
    return this.request("thread/read", {
      threadId
    });
  }

  async threadStart(params: Record<string, unknown>): Promise<unknown> {
    return this.request("thread/start", params);
  }

  async threadResume(threadId: string): Promise<unknown> {
    return this.request("thread/resume", {
      threadId
    });
  }

  async turnStart(params: Record<string, unknown>): Promise<unknown> {
    return this.request("turn/start", params);
  }

  async turnSteer(params: Record<string, unknown>): Promise<unknown> {
    return this.request("turn/steer", params);
  }

  async request<TResult = unknown>(
    method: string,
    params?: Record<string, unknown>,
    options?: CodexAppServerRequestOptions
  ): Promise<TResult> {
    const result = await this.transport.request<TResult>(method, params, {
      timeoutMs: options?.timeoutMs ?? this.defaultTimeoutMs,
      signal: options?.signal
    });

    this.observedMethods.add(method);

    return result;
  }
}
