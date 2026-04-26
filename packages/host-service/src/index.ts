import { createServer, type Server as HttpServer } from "node:http";
import type {
  ApprovalsListParams,
  ApprovalsListResult,
  ApprovalsRespondParams,
  ApprovalsRespondResult,
  ArtifactsGetParams,
  ArtifactsGetResult,
  ArtifactsListParams,
  ArtifactsListResult,
  CapabilitiesGetResult,
  CoreMethodName,
  DiffsGetParams,
  DiffsGetResult,
  ErrorCode,
  EventEnvelope,
  HostsGetResult,
  RequestEnvelope,
  RequestId,
  RuntimesListParams,
  RuntimesListResult,
  SessionsGetParams,
  SessionsGetResult,
  SessionsListParams,
  SessionsListResult,
  SessionsResumeParams,
  SessionsResumeResult,
  SessionsSendInputParams,
  SessionsSendInputResult,
  SessionsStartParams,
  SessionsStartResult,
  SessionsStopParams,
  SessionsStopResult,
  SessionsSubscribeParams,
  SessionsSubscribeResult,
  SessionsUnsubscribeParams,
  SessionsUnsubscribeResult
} from "ascp-sdk-typescript";
import WebSocket, { WebSocketServer, type RawData } from "ws";

type MaybePromise<T> = Promise<T> | T;
type JsonObject = Record<string, unknown>;

export interface AscpHostRuntime {
  capabilitiesGet(): MaybePromise<CapabilitiesGetResult>;
  hostsGet(): MaybePromise<HostsGetResult>;
  runtimesList?(params?: RuntimesListParams): MaybePromise<RuntimesListResult>;
  sessionsList?(params?: SessionsListParams): MaybePromise<SessionsListResult>;
  sessionsGet?(params: SessionsGetParams): MaybePromise<SessionsGetResult>;
  sessionsStart?(params: SessionsStartParams): MaybePromise<SessionsStartResult>;
  sessionsResume?(params: SessionsResumeParams): MaybePromise<SessionsResumeResult>;
  sessionsStop?(params: SessionsStopParams): MaybePromise<SessionsStopResult>;
  sessionsSendInput?(params: SessionsSendInputParams): MaybePromise<SessionsSendInputResult>;
  sessionsSubscribe?(params: SessionsSubscribeParams): MaybePromise<SessionsSubscribeResult>;
  sessionsUnsubscribe?(params: SessionsUnsubscribeParams): MaybePromise<SessionsUnsubscribeResult>;
  approvalsList?(params?: ApprovalsListParams): MaybePromise<ApprovalsListResult>;
  approvalsRespond?(params: ApprovalsRespondParams): MaybePromise<ApprovalsRespondResult>;
  artifactsList?(params: ArtifactsListParams): MaybePromise<ArtifactsListResult>;
  artifactsGet?(params: ArtifactsGetParams): MaybePromise<ArtifactsGetResult>;
  diffsGet?(params: DiffsGetParams): MaybePromise<DiffsGetResult>;
  drainSubscriptionEvents?(
    subscriptionId: string,
    limit?: number
  ): EventEnvelope<Record<string, unknown>>[];
  onEvent?(listener: (event: EventEnvelope<Record<string, unknown>>) => void): () => void;
  close?(): MaybePromise<void>;
}

export interface AscpHostServiceOptions {
  runtime: AscpHostRuntime;
  host?: string;
  port?: number;
}

export interface AscpHostService {
  readonly url: string;
  listen(): Promise<void>;
  close(): Promise<void>;
}

interface SocketSubscription {
  sessionId: string;
  socket: WebSocket;
  subscriptionId: string;
}

interface JsonRpcSuccess<TResult extends JsonObject = JsonObject> {
  id: RequestId;
  jsonrpc: "2.0";
  result: TResult;
}

interface JsonRpcFailure {
  error: {
    code: ErrorCode;
    details: JsonObject | null;
    message: string;
    retryable: boolean;
  };
  id: RequestId | null;
  jsonrpc: "2.0";
}

const METHOD_NAMES: readonly CoreMethodName[] = [
  "capabilities.get",
  "hosts.get",
  "runtimes.list",
  "sessions.list",
  "sessions.get",
  "sessions.start",
  "sessions.resume",
  "sessions.stop",
  "sessions.send_input",
  "sessions.subscribe",
  "sessions.unsubscribe",
  "approvals.list",
  "approvals.respond",
  "artifacts.list",
  "artifacts.get",
  "diffs.get"
];

function isObject(value: unknown): value is JsonObject {
  return typeof value === "object" && value !== null;
}

function createUnsupportedError(method: string): Error {
  const error = new Error(`Unsupported ASCP method: ${method}`);
  (error as Error & {
    ascpCode?: ErrorCode;
    ascpDetails?: JsonObject;
    ascpRetryable?: boolean;
  }).ascpCode = "UNSUPPORTED";
  (error as Error & {
    ascpCode?: ErrorCode;
    ascpDetails?: JsonObject;
    ascpRetryable?: boolean;
  }).ascpDetails = {
    method
  };
  (error as Error & {
    ascpCode?: ErrorCode;
    ascpDetails?: JsonObject;
    ascpRetryable?: boolean;
  }).ascpRetryable = false;
  return error;
}

function normalizeError(error: unknown, fallbackMethod?: string): JsonRpcFailure["error"] {
  if (isObject(error)) {
    const code = typeof error.code === "string" ? (error.code as ErrorCode) : undefined;
    const message = typeof error.message === "string" ? error.message : undefined;
    const retryable = typeof error.retryable === "boolean" ? error.retryable : undefined;
    const details = isObject(error.details) ? error.details : null;

    if (code !== undefined && message !== undefined) {
      return {
        code,
        message,
        retryable: retryable ?? false,
        details
      };
    }

    const ascpCode =
      typeof error.ascpCode === "string" ? (error.ascpCode as ErrorCode) : undefined;
    const ascpRetryable =
      typeof error.ascpRetryable === "boolean" ? error.ascpRetryable : undefined;
    const ascpDetails = isObject(error.ascpDetails) ? error.ascpDetails : null;

    if (ascpCode !== undefined && message !== undefined) {
      return {
        code: ascpCode,
        message,
        retryable: ascpRetryable ?? false,
        details: ascpDetails
      };
    }
  }

  return {
    code: "RUNTIME_ERROR",
    message:
      error instanceof Error
        ? error.message
        : `ASCP host request failed${fallbackMethod ? ` for ${fallbackMethod}` : ""}.`,
    retryable: false,
    details: fallbackMethod === undefined ? null : { method: fallbackMethod }
  };
}

function isRequestEnvelope(value: unknown): value is RequestEnvelope<JsonObject> {
  return (
    isObject(value) &&
    value.jsonrpc === "2.0" &&
    typeof value.method === "string" &&
    ("id" in value ? typeof value.id === "string" || typeof value.id === "number" : true) &&
    (!("params" in value) || value.params === undefined || isObject(value.params))
  );
}

class WebSocketAscpHostService implements AscpHostService {
  private readonly runtime: AscpHostRuntime;
  private readonly host: string;
  private readonly port: number;
  private readonly httpServer: HttpServer;
  private readonly webSocketServer: WebSocketServer;
  private readonly sockets = new Set<WebSocket>();
  private readonly subscriptions = new Map<string, SocketSubscription>();
  private readonly removeRuntimeListener: (() => void) | null;
  private listening = false;
  private resolvedUrl = "";

  constructor(options: AscpHostServiceOptions) {
    this.runtime = options.runtime;
    this.host = options.host ?? "127.0.0.1";
    this.port = options.port ?? 0;
    this.httpServer = createServer((_request, response) => {
      response.statusCode = 404;
      response.end("Not Found");
    });
    this.webSocketServer = new WebSocketServer({
      noServer: true
    });
    this.removeRuntimeListener =
      this.runtime.onEvent?.((event) => {
        this.broadcastEvent(event);
      }) ?? null;

    this.httpServer.on("upgrade", (request, socket, head) => {
      this.webSocketServer.handleUpgrade(request, socket, head, (client: WebSocket) => {
        this.webSocketServer.emit("connection", client, request);
      });
    });

    this.webSocketServer.on("connection", (socket: WebSocket) => {
      this.sockets.add(socket);

      socket.on("message", (chunk: RawData) => {
        const text =
          typeof chunk === "string" ? chunk : Buffer.isBuffer(chunk) ? chunk.toString("utf8") : "";
        void this.handleSocketMessage(socket, text);
      });

      socket.on("close", () => {
        this.sockets.delete(socket);
        void this.cleanupSocketSubscriptions(socket);
      });
    });
  }

  get url(): string {
    if (this.resolvedUrl.length === 0) {
      throw new Error("ASCP host service is not listening.");
    }

    return this.resolvedUrl;
  }

  async listen(): Promise<void> {
    if (this.listening) {
      return;
    }

    await new Promise<void>((resolve, reject) => {
      const onError = (error: Error) => {
        this.httpServer.off("listening", onListening);
        reject(error);
      };

      const onListening = () => {
        this.httpServer.off("error", onError);
        resolve();
      };

      this.httpServer.once("error", onError);
      this.httpServer.once("listening", onListening);
      this.httpServer.listen(this.port, this.host);
    });

    const address = this.httpServer.address();

    if (address === null || typeof address === "string") {
      throw new Error("ASCP host service failed to resolve a listening address.");
    }

    this.resolvedUrl = `ws://${this.host}:${address.port}`;
    this.listening = true;
  }

  async close(): Promise<void> {
    const closePromises: Array<Promise<void>> = [];

    for (const socket of this.sockets) {
      closePromises.push(
        new Promise<void>((resolve) => {
          socket.once("close", () => resolve());
          socket.close();
          setTimeout(resolve, 250);
        })
      );
    }

    this.sockets.clear();
    this.subscriptions.clear();
    this.removeRuntimeListener?.();
    await this.runtime.close?.();

    await Promise.all(closePromises);

    await new Promise<void>((resolve, reject) => {
      this.webSocketServer.close((error?: Error) => {
        if (error) {
          reject(error);
          return;
        }

        this.httpServer.close((serverError) => {
          if (serverError) {
            reject(serverError);
            return;
          }

          resolve();
        });
      });
    });
  }

  private async handleSocketMessage(socket: WebSocket, text: string): Promise<void> {
    let value: unknown;

    try {
      value = JSON.parse(text);
    } catch {
      this.sendFailure(socket, {
        jsonrpc: "2.0",
        id: null,
        error: {
          code: "INVALID_REQUEST",
          message: "Malformed JSON-RPC payload.",
          retryable: false,
          details: null
        }
      });
      return;
    }

    if (!isRequestEnvelope(value) || value.id === undefined || !METHOD_NAMES.includes(value.method as CoreMethodName)) {
      this.sendFailure(socket, {
        jsonrpc: "2.0",
        id:
          isObject(value) && Object.hasOwn(value, "id")
            ? ((value as { id?: RequestId }).id ?? null)
            : null,
        error: {
          code: "INVALID_REQUEST",
          message: "Invalid ASCP JSON-RPC request envelope.",
          retryable: false,
          details: null
        }
      });
      return;
    }

    try {
      const result = await this.dispatch(value.method as CoreMethodName, value.params ?? {});

      if (value.method === "sessions.subscribe") {
        const subscribeResult = result as SessionsSubscribeResult;
        this.subscriptions.set(subscribeResult.subscription_id, {
          socket,
          subscriptionId: subscribeResult.subscription_id,
          sessionId: subscribeResult.session_id
        });

        for (const event of this.runtime.drainSubscriptionEvents?.(subscribeResult.subscription_id) ?? []) {
          this.sendEvent(socket, event);
        }
      } else if (value.method === "sessions.unsubscribe") {
        const unsubscribeParams = value.params as SessionsUnsubscribeParams;
        this.subscriptions.delete(unsubscribeParams.subscription_id);
      }

      this.sendSuccess(socket, {
        jsonrpc: "2.0",
        id: value.id,
        result
      });
    } catch (error) {
      this.sendFailure(socket, {
        jsonrpc: "2.0",
        id: value.id,
        error: normalizeError(error, value.method)
      });
    }
  }

  private async cleanupSocketSubscriptions(socket: WebSocket): Promise<void> {
    const subscriptionIds = [...this.subscriptions.values()]
      .filter((subscription) => subscription.socket === socket)
      .map((subscription) => subscription.subscriptionId);

    for (const subscriptionId of subscriptionIds) {
      this.subscriptions.delete(subscriptionId);

      if (this.runtime.sessionsUnsubscribe === undefined) {
        continue;
      }

      try {
        await this.runtime.sessionsUnsubscribe({
          subscription_id: subscriptionId
        });
      } catch {
        // Best-effort cleanup.
      }
    }
  }

  private broadcastEvent(event: EventEnvelope<Record<string, unknown>>): void {
    for (const subscription of this.subscriptions.values()) {
      if (subscription.sessionId !== event.session_id) {
        continue;
      }

      this.sendEvent(subscription.socket, event);
    }
  }

  private sendSuccess(socket: WebSocket, response: JsonRpcSuccess): void {
    if (socket.readyState !== WebSocket.OPEN) {
      return;
    }

    socket.send(JSON.stringify(response));
  }

  private sendFailure(socket: WebSocket, response: JsonRpcFailure): void {
    if (socket.readyState !== WebSocket.OPEN) {
      return;
    }

    socket.send(JSON.stringify(response));
  }

  private sendEvent(socket: WebSocket, event: EventEnvelope<Record<string, unknown>>): void {
    if (socket.readyState !== WebSocket.OPEN) {
      return;
    }

    socket.send(JSON.stringify(event));
  }

  private async dispatch(method: CoreMethodName, rawParams: JsonObject): Promise<JsonObject> {
    switch (method) {
      case "capabilities.get":
        return this.runtime.capabilitiesGet();
      case "hosts.get":
        return this.runtime.hostsGet();
      case "runtimes.list":
        if (this.runtime.runtimesList === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.runtimesList(rawParams as RuntimesListParams);
      case "sessions.list":
        if (this.runtime.sessionsList === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.sessionsList(rawParams as SessionsListParams);
      case "sessions.get":
        if (this.runtime.sessionsGet === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.sessionsGet(rawParams as SessionsGetParams);
      case "sessions.start":
        if (this.runtime.sessionsStart === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.sessionsStart(rawParams as SessionsStartParams);
      case "sessions.resume":
        if (this.runtime.sessionsResume === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.sessionsResume(rawParams as SessionsResumeParams);
      case "sessions.stop":
        if (this.runtime.sessionsStop === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.sessionsStop(rawParams as SessionsStopParams);
      case "sessions.send_input":
        if (this.runtime.sessionsSendInput === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.sessionsSendInput(rawParams as SessionsSendInputParams);
      case "sessions.subscribe":
        if (this.runtime.sessionsSubscribe === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.sessionsSubscribe(rawParams as SessionsSubscribeParams);
      case "sessions.unsubscribe":
        if (this.runtime.sessionsUnsubscribe === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.sessionsUnsubscribe(rawParams as SessionsUnsubscribeParams);
      case "approvals.list":
        if (this.runtime.approvalsList === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.approvalsList(rawParams as ApprovalsListParams);
      case "approvals.respond":
        if (this.runtime.approvalsRespond === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.approvalsRespond(rawParams as ApprovalsRespondParams);
      case "artifacts.list":
        if (this.runtime.artifactsList === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.artifactsList(rawParams as ArtifactsListParams);
      case "artifacts.get":
        if (this.runtime.artifactsGet === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.artifactsGet(rawParams as ArtifactsGetParams);
      case "diffs.get":
        if (this.runtime.diffsGet === undefined) {
          throw createUnsupportedError(method);
        }
        return this.runtime.diffsGet(rawParams as DiffsGetParams);
    }

    throw createUnsupportedError(method);
  }
}

export function createAscpHostService(options: AscpHostServiceOptions): AscpHostService {
  return new WebSocketAscpHostService(options);
}
