import type { CoreMethodName } from "../methods/types.js";
import type { EventEnvelope, RequestEnvelope, RequestId } from "../models/types.js";
import type { CoreMethodResponse } from "../validation/types.js";
import { AsyncQueue } from "./async-queue.js";
import {
  type AscpTransportError,
  createTransportError,
  normalizeTransportError
} from "./errors.js";
import type {
  AscpInstrumentedTransportOptions,
  AscpTransport,
  AscpTransportRequestOptions,
  AscpTransportSubscription,
  CoreMethodParamsMap
} from "./types.js";

interface BrowserWebSocketMessageEvent {
  data: unknown;
}

interface BrowserWebSocketCloseEvent {
  code: number;
  reason: string;
}

interface BrowserWebSocketLike {
  binaryType?: "blob" | "arraybuffer";
  onclose: ((event: BrowserWebSocketCloseEvent) => void) | null;
  onerror: ((event: unknown) => void) | null;
  onmessage: ((event: BrowserWebSocketMessageEvent) => void) | null;
  onopen: ((event: unknown) => void) | null;
  readonly readyState: number;
  close(code?: number, reason?: string): void;
  send(data: string): void;
}

export interface BrowserWebSocketConstructor {
  new (url: string, protocols?: string | string[]): BrowserWebSocketLike;
}

export interface AscpBrowserWebSocketTransportOptions
  extends AscpInstrumentedTransportOptions {
  connectTimeoutMs?: number;
  protocols?: string | string[];
  url: string;
  webSocketConstructor?: BrowserWebSocketConstructor;
}

interface PendingRequest<TMethod extends CoreMethodName> {
  cleanup: () => void;
  method: TMethod;
  reject: (reason?: unknown) => void;
  resolve: (value: CoreMethodResponse<CoreMethodName>) => void;
}

class QueueBackedSubscription implements AscpTransportSubscription {
  private readonly queue = new AsyncQueue<EventEnvelope>();
  private readonly onClose: () => void;
  private closed = false;

  constructor(onClose: () => void) {
    this.onClose = onClose;
  }

  push(event: EventEnvelope): void {
    this.queue.push(event);
  }

  fail(error: unknown): void {
    this.queue.fail(error);
  }

  async close(): Promise<void> {
    if (this.closed) {
      return;
    }

    this.closed = true;
    this.onClose();
    this.queue.close();
  }

  [Symbol.asyncIterator](): AsyncIterator<EventEnvelope> {
    return this.queue[Symbol.asyncIterator]();
  }
}

const SOCKET_OPEN = 1;
const SOCKET_CLOSING = 2;
const SOCKET_CLOSED = 3;

export class AscpBrowserWebSocketTransport implements AscpTransport {
  readonly kind = "browser_websocket";

  private readonly options: AscpBrowserWebSocketTransportOptions;
  private readonly textDecoder = new TextDecoder();
  private socket: BrowserWebSocketLike | null = null;
  private closed = false;
  private connected = false;
  private connectPromise: Promise<void> | null = null;
  private nextRequestId = 1;
  private readonly pendingRequests = new Map<RequestId, PendingRequest<CoreMethodName>>();
  private readonly subscriptions = new Set<QueueBackedSubscription>();

  constructor(options: AscpBrowserWebSocketTransportOptions) {
    this.options = options;
  }

  async connect(): Promise<void> {
    if (this.closed) {
      throw createTransportError({
        code: "TRANSPORT_CLOSED",
        transport: this.kind,
        message: "browser websocket transport is already closed.",
        retryable: false
      });
    }

    if (this.connected) {
      return;
    }

    if (this.connectPromise !== null) {
      return this.connectPromise;
    }

    this.connectPromise = this.openConnection().finally(() => {
      this.connectPromise = null;
    });

    return this.connectPromise;
  }

  async close(): Promise<void> {
    if (this.closed) {
      return;
    }

    this.closed = true;
    this.connected = false;

    this.failPendingAndSubscriptions(
      createTransportError({
        code: "TRANSPORT_CLOSED",
        transport: this.kind,
        message: "browser_websocket transport closed.",
        retryable: false
      })
    );

    await this.closeConnection();
  }

  subscribe(): AscpTransportSubscription {
    const subscription = new QueueBackedSubscription(() => {
      this.subscriptions.delete(subscription);
    });

    this.subscriptions.add(subscription);

    return subscription;
  }

  async request<TMethod extends CoreMethodName>(
    method: TMethod,
    params?: CoreMethodParamsMap[TMethod],
    options: AscpTransportRequestOptions = {}
  ): Promise<CoreMethodResponse<TMethod>> {
    await this.connect();

    if (!this.connected) {
      throw createTransportError({
        code: "TRANSPORT_CONNECTION",
        transport: this.kind,
        message: "browser websocket transport is not connected."
      });
    }

    const requestId = this.nextRequestId++;
    const request: RequestEnvelope = {
      jsonrpc: "2.0",
      id: requestId,
      method
    };

    if (params !== undefined) {
      request.params = params;
    }

    const responsePromise = new Promise<CoreMethodResponse<TMethod>>((resolve, reject) => {
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
          reject(
            createTransportError({
              code: "TRANSPORT_TIMEOUT",
              transport: this.kind,
              message: `${method} request timed out after ${options.timeoutMs}ms.`,
              details: {
                method,
                timeoutMs: options.timeoutMs
              }
            })
          );
        }, options.timeoutMs);

        cleanupParts.push(() => {
          clearTimeout(timeout);
        });
      }

      if (options.signal !== undefined) {
        if (options.signal.aborted) {
          cleanup();
          reject(
            createTransportError({
              code: "TRANSPORT_ABORTED",
              transport: this.kind,
              message: `${method} request was aborted.`,
              details: {
                method
              },
              retryable: false
            })
          );
          return;
        }

        const onAbort = () => {
          cleanup();
          reject(
            createTransportError({
              code: "TRANSPORT_ABORTED",
              transport: this.kind,
              message: `${method} request was aborted.`,
              details: {
                method
              },
              retryable: false
            })
          );
        };

        options.signal.addEventListener("abort", onAbort, {
          once: true
        });
        cleanupParts.push(() => {
          options.signal?.removeEventListener("abort", onAbort);
        });
      }

      this.pendingRequests.set(requestId, {
        cleanup,
        method,
        reject,
        resolve: resolve as (value: CoreMethodResponse<CoreMethodName>) => void
      });
    });

    try {
      await this.sendSerialized(JSON.stringify(request));
    } catch (error) {
      this.pendingRequests.get(requestId)?.cleanup();
      throw normalizeTransportError(error, {
        code: "TRANSPORT_IO",
        transport: this.kind,
        message: `Failed to send ${method} request over ${this.kind}.`,
        details: {
          method
        }
      });
    }

    return responsePromise;
  }

  private async openConnection(): Promise<void> {
    if (this.socket !== null) {
      return;
    }

    const WebSocketConstructor = this.resolveWebSocketConstructor();

    if (WebSocketConstructor === undefined) {
      throw createTransportError({
        code: "TRANSPORT_CONNECTION",
        transport: this.kind,
        message: "Browser WebSocket constructor is unavailable in this environment.",
        retryable: false
      });
    }

    const socket =
      this.options.protocols === undefined
        ? new WebSocketConstructor(this.options.url)
        : new WebSocketConstructor(this.options.url, this.options.protocols);

    this.socket = socket;

    if (socket.binaryType !== undefined) {
      socket.binaryType = "arraybuffer";
    }

    await new Promise<void>((resolve, reject) => {
      let timeoutHandle: ReturnType<typeof setTimeout> | undefined;

      const cleanup = () => {
        if (timeoutHandle !== undefined) {
          clearTimeout(timeoutHandle);
        }

        socket.onopen = null;
        socket.onerror = null;
        socket.onclose = null;
      };

      socket.onopen = () => {
        cleanup();
        this.connected = true;
        resolve();
      };

      socket.onerror = () => {
        cleanup();
        this.socket = null;
        this.connected = false;
        reject(new Error("Browser websocket failed while opening."));
      };

      socket.onclose = (event) => {
        cleanup();
        this.socket = null;
        this.connected = false;
        reject(
          createTransportError({
            code: "TRANSPORT_CONNECTION",
            transport: this.kind,
            message: "Browser websocket closed before it finished connecting.",
            details: {
              code: event.code,
              reason: event.reason
            }
          })
        );
      };

      if (this.options.connectTimeoutMs !== undefined) {
        timeoutHandle = setTimeout(() => {
          cleanup();
          this.socket = null;
          this.connected = false;
          reject(
            createTransportError({
              code: "TRANSPORT_TIMEOUT",
              transport: this.kind,
              message: `Browser websocket connect timed out after ${this.options.connectTimeoutMs}ms.`,
              details: {
                timeoutMs: this.options.connectTimeoutMs
              }
            })
          );
        }, this.options.connectTimeoutMs);
      }
    });

    socket.onmessage = (event) => {
      try {
        this.handleSerializedMessage(this.toText(event.data));
      } catch (error) {
        this.handleConnectionFailure(
          error,
          "Browser websocket emitted an unsupported message payload."
        );
      }
    };

    socket.onerror = (error) => {
      this.failPendingAndSubscriptions(
        normalizeTransportError(error, {
          code: "TRANSPORT_IO",
          transport: this.kind,
          message: "Browser websocket emitted an error."
        })
      );
    };

    socket.onclose = (event) => {
      if (this.socket === null) {
        return;
      }

      this.socket = null;

      this.handleConnectionFailure(
        createTransportError({
          code: "TRANSPORT_CONNECTION",
          transport: this.kind,
          message: "Browser websocket closed unexpectedly.",
          details: {
            code: event.code,
            reason: event.reason
          }
        }),
        "Browser websocket closed unexpectedly."
      );
    };
  }

  private async closeConnection(): Promise<void> {
    const socket = this.socket;
    this.socket = null;
    this.connected = false;

    if (socket === null) {
      return;
    }

    if (
      socket.readyState === SOCKET_CLOSING ||
      socket.readyState === SOCKET_CLOSED
    ) {
      return;
    }

    await new Promise<void>((resolve) => {
      const previousOnClose = socket.onclose;
      let settled = false;

      const settle = () => {
        if (settled) {
          return;
        }

        settled = true;
        resolve();
      };

      socket.onclose = (event) => {
        previousOnClose?.(event);
        settle();
      };

      socket.close();
      setTimeout(settle, 250);
    });
  }

  private async sendSerialized(messageText: string): Promise<void> {
    const socket = this.socket;

    if (socket === null || socket.readyState !== SOCKET_OPEN) {
      throw createTransportError({
        code: "TRANSPORT_CLOSED",
        transport: this.kind,
        message: "Browser websocket transport is not open.",
        retryable: false
      });
    }

    socket.send(messageText);
  }

  private resolveWebSocketConstructor():
    | BrowserWebSocketConstructor
    | undefined {
    if (this.options.webSocketConstructor !== undefined) {
      return this.options.webSocketConstructor;
    }

    const globalWebSocket = (globalThis as { WebSocket?: unknown }).WebSocket;

    if (typeof globalWebSocket === "function") {
      return globalWebSocket as BrowserWebSocketConstructor;
    }

    return undefined;
  }

  private toText(data: unknown): string {
    if (typeof data === "string") {
      return data;
    }

    if (data instanceof ArrayBuffer) {
      return this.textDecoder.decode(new Uint8Array(data));
    }

    if (ArrayBuffer.isView(data)) {
      return this.textDecoder.decode(
        new Uint8Array(data.buffer, data.byteOffset, data.byteLength)
      );
    }

    throw createTransportError({
      code: "TRANSPORT_PROTOCOL",
      transport: this.kind,
      message: "Browser websocket received a non-text message payload.",
      details: {
        payloadType: typeof data
      }
    });
  }

  private handleSerializedMessage(messageText: string): void {
    let value: unknown;

    try {
      value = JSON.parse(messageText);
    } catch (error) {
      this.failPendingAndSubscriptions(
        normalizeTransportError(error, {
          code: "TRANSPORT_PROTOCOL",
          transport: this.kind,
          message: `Received malformed JSON over ${this.kind}.`,
          details: {
            raw: messageText
          }
        })
      );
      return;
    }

    if (this.isResponseEnvelope(value)) {
      this.handleResponse(value);
      return;
    }

    this.handleEvent(value);
  }

  private handleResponse(value: Record<string, unknown>): void {
    const requestId = value.id as RequestId;
    const pending = this.pendingRequests.get(requestId);

    if (pending === undefined) {
      return;
    }

    if (!this.isResponseEnvelope(value)) {
      pending.cleanup();
      pending.reject(
        createTransportError({
          code: "TRANSPORT_PROTOCOL",
          transport: this.kind,
          message: `Received an invalid ${pending.method} response over ${this.kind}.`,
          details: {
            method: pending.method,
            requestId
          }
        })
      );
      return;
    }

    pending.cleanup();
    pending.resolve(value as CoreMethodResponse<CoreMethodName>);
  }

  private handleEvent(value: unknown): void {
    if (!this.isEventEnvelope(value)) {
      this.failPendingAndSubscriptions(
        createTransportError({
          code: "TRANSPORT_PROTOCOL",
          transport: this.kind,
          message: `Received an invalid ASCP event envelope over ${this.kind}.`
        })
      );
      return;
    }

    for (const subscription of this.subscriptions) {
      subscription.push(value);
    }
  }

  private handleConnectionFailure(error: unknown, message: string): void {
    this.connected = false;
    this.failPendingAndSubscriptions(
      normalizeTransportError(error, {
        code: "TRANSPORT_CONNECTION",
        transport: this.kind,
        message
      })
    );
  }

  private failPendingAndSubscriptions(error: AscpTransportError): void {
    for (const pending of this.pendingRequests.values()) {
      pending.cleanup();
      pending.reject(error);
    }

    for (const subscription of this.subscriptions) {
      subscription.fail(error);
    }
  }

  private isResponseEnvelope(value: unknown): value is Record<string, unknown> {
    if (typeof value !== "object" || value === null) {
      return false;
    }

    const record = value as Record<string, unknown>;

    return (
      record.jsonrpc === "2.0" &&
      Object.hasOwn(record, "id") &&
      (Object.hasOwn(record, "result") || Object.hasOwn(record, "error"))
    );
  }

  private isEventEnvelope(value: unknown): value is EventEnvelope {
    if (typeof value !== "object" || value === null) {
      return false;
    }

    const record = value as Record<string, unknown>;

    return (
      typeof record.id === "string" &&
      typeof record.type === "string" &&
      typeof record.ts === "string" &&
      typeof record.session_id === "string" &&
      typeof record.payload === "object" &&
      record.payload !== null
    );
  }
}
