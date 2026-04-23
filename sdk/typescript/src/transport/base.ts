import {
  createAnalyticsContext,
  describeTransportError,
  emitAnalyticsEvent,
  type AscpAnalyticsRecorder,
  type AscpDiagnostic
} from "../analytics/index.js";
import {
  safeParseEventEnvelope,
  safeParseMethodResponse,
  type CoreMethodResponse
} from "../validation/index.js";
import type { CoreMethodName } from "../methods/types.js";
import type { EventEnvelope, RequestEnvelope, RequestId } from "../models/types.js";
import { AsyncQueue } from "./async-queue.js";
import {
  AscpTransportError,
  createTransportError,
  normalizeTransportError
} from "./errors.js";
import type {
  AscpTransport,
  AscpTransportRequestOptions,
  AscpTransportSubscription,
  CoreMethodParamsMap
} from "./types.js";

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

export abstract class BaseAscpTransport implements AscpTransport {
  readonly kind: string;
  private readonly analytics: AscpAnalyticsRecorder | undefined;

  private closed = false;
  private connected = false;
  private connectPromise: Promise<void> | null = null;
  private nextRequestId = 1;
  private readonly pendingRequests = new Map<RequestId, PendingRequest<CoreMethodName>>();
  private readonly subscriptions = new Set<QueueBackedSubscription>();

  protected constructor(kind: string, analytics?: AscpAnalyticsRecorder) {
    this.kind = kind;
    this.analytics = analytics;
  }

  async connect(): Promise<void> {
    if (this.closed) {
      const error = createTransportError({
        code: "TRANSPORT_CLOSED",
        transport: this.kind,
        message: `${this.kind} transport is already closed.`,
        retryable: false
      });

      this.emitFailureAnalytics("transport.connect.failed", error);
      throw error;
    }

    if (this.connected) {
      return;
    }

    if (this.connectPromise !== null) {
      return this.connectPromise;
    }

    this.emitAnalytics("transport.connect.started");

    this.connectPromise = this.openConnection()
      .then(() => {
        this.connected = true;
        this.emitAnalytics("transport.connect.succeeded");
      })
      .catch((error) => {
        const normalizedError = normalizeTransportError(error, {
          code: "TRANSPORT_CONNECTION",
          transport: this.kind,
          message: `Failed to connect ${this.kind} transport.`
        });

        this.emitFailureAnalytics("transport.connect.failed", normalizedError);
        throw normalizedError;
      })
      .finally(() => {
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
        message: `${this.kind} transport closed.`,
        retryable: false
      })
    );

    await this.closeConnection();
    this.emitAnalytics("transport.closed");
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
        message: `${this.kind} transport is not connected.`
      });
    }

    const requestId = this.nextRequestId++;
    this.emitAnalytics("transport.request.started", {
      method,
      requestId
    });

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
          const error = createTransportError({
            code: "TRANSPORT_TIMEOUT",
            transport: this.kind,
            message: `${method} request timed out after ${options.timeoutMs}ms.`,
            details: {
              method,
              timeoutMs: options.timeoutMs
            }
          });
          this.emitFailureAnalytics("transport.request.failed", error, {
            method,
            requestId
          });
          reject(error);
        }, options.timeoutMs);

        cleanupParts.push(() => {
          clearTimeout(timeout);
        });
      }

      if (options.signal !== undefined) {
        if (options.signal.aborted) {
          cleanup();
          const error = createTransportError({
            code: "TRANSPORT_ABORTED",
            transport: this.kind,
            message: `${method} request was aborted.`,
            details: {
              method
            },
            retryable: false
          });
          this.emitFailureAnalytics("transport.request.failed", error, {
            method,
            requestId
          });
          reject(error);
          return;
        }

        const onAbort = () => {
          cleanup();
          const error = createTransportError({
            code: "TRANSPORT_ABORTED",
            transport: this.kind,
            message: `${method} request was aborted.`,
            details: {
              method
            },
            retryable: false
          });
          this.emitFailureAnalytics("transport.request.failed", error, {
            method,
            requestId
          });
          reject(error);
        };

        options.signal.addEventListener("abort", onAbort, { once: true });
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
      const normalizedError = normalizeTransportError(error, {
        code: "TRANSPORT_IO",
        transport: this.kind,
        message: `Failed to send ${method} request over ${this.kind}.`,
        details: {
          method
        }
      });
      this.emitFailureAnalytics("transport.request.failed", normalizedError, {
        method,
        requestId
      });
      throw normalizedError;
    }

    return responsePromise;
  }

  protected handleSerializedMessage(messageText: string): void {
    let value: unknown;

    try {
      value = JSON.parse(messageText);
    } catch (error) {
      const normalizedError = normalizeTransportError(error, {
        code: "TRANSPORT_PROTOCOL",
        transport: this.kind,
        message: `Received malformed JSON over ${this.kind}.`,
        details: {
          raw: messageText
        }
      });

      this.emitFailureAnalytics("transport.stream.invalid_message", normalizedError);
      this.failPendingAndSubscriptions(normalizedError);
      return;
    }

    if (this.isResponseEnvelope(value)) {
      this.handleResponse(value);
      return;
    }

    this.handleEvent(value);
  }

  protected handleConnectionFailure(error: unknown, message: string): void {
    this.connected = false;
    const normalizedError = normalizeTransportError(error, {
      code: "TRANSPORT_CONNECTION",
      transport: this.kind,
      message
    });
    this.emitFailureAnalytics("transport.connect.failed", normalizedError);
    this.failPendingAndSubscriptions(normalizedError);
  }

  protected handleIoFailure(error: unknown, message: string): void {
    const normalizedError = normalizeTransportError(error, {
      code: "TRANSPORT_IO",
      transport: this.kind,
      message
    });
    this.failPendingAndSubscriptions(normalizedError);
  }

  protected markConnected(): void {
    this.connected = true;
  }

  protected abstract closeConnection(): Promise<void>;
  protected abstract openConnection(): Promise<void>;
  protected abstract sendSerialized(messageText: string): Promise<void>;

  private failPendingAndSubscriptions(error: AscpTransportError): void {
    for (const [requestId, pending] of this.pendingRequests.entries()) {
      pending.cleanup();
      this.emitFailureAnalytics("transport.request.failed", error, {
        method: pending.method,
        requestId
      });
      pending.reject(error);
    }

    for (const subscription of this.subscriptions) {
      subscription.fail(error);
    }
  }

  private handleEvent(value: unknown): void {
    const result = safeParseEventEnvelope(value);

    if (!result.success) {
      const error = createTransportError({
        code: "TRANSPORT_PROTOCOL",
        transport: this.kind,
        message: `Received an invalid ASCP event envelope over ${this.kind}.`,
        cause: result.error,
        details: {
          target: result.error.target
        }
      });
      this.emitFailureAnalytics("transport.stream.invalid_message", error, {
        target: result.error.target
      });
      this.failPendingAndSubscriptions(error);
      return;
    }

    this.emitAnalytics("transport.event.received", {
      eventType: result.data.type
    });

    for (const subscription of this.subscriptions) {
      subscription.push(result.data);
    }
  }

  private handleResponse(value: Record<string, unknown>): void {
    const requestId = value.id as RequestId;
    const pending = this.pendingRequests.get(requestId);

    if (pending === undefined) {
      return;
    }

    const result = safeParseMethodResponse(pending.method, value);

    if (!result.success) {
      pending.cleanup();
      const error = createTransportError({
        code: "TRANSPORT_PROTOCOL",
        transport: this.kind,
        message: `Received an invalid ${pending.method} response over ${this.kind}.`,
        cause: result.error,
        details: {
          method: pending.method,
          requestId
        }
      });
      this.emitFailureAnalytics("transport.request.failed", error, {
        method: pending.method,
        requestId
      });
      pending.reject(error);
      return;
    }

    pending.cleanup();
    this.emitAnalytics("transport.request.completed", {
      method: pending.method,
      requestId
    }, {
      responseKind: "result" in result.data ? "result" : "error"
    });
    pending.resolve(result.data);
  }

  private emitAnalytics(
    name:
      | "transport.closed"
      | "transport.connect.started"
      | "transport.connect.succeeded"
      | "transport.event.received"
      | "transport.request.completed"
      | "transport.request.started",
    context: Partial<{
      eventType: string;
      method: string;
      requestId: RequestId;
      target: string;
    }> = {},
    data?: Record<string, unknown>
  ): void {
    emitAnalyticsEvent(this.analytics, {
      name,
      context: createAnalyticsContext({
        transport: this.kind,
        ...context
      }),
      ...(data !== undefined ? { data } : {})
    });
  }

  private emitFailureAnalytics(
    name:
      | "transport.connect.failed"
      | "transport.request.failed"
      | "transport.stream.invalid_message",
    error: AscpTransportError,
    context: Partial<{
      eventType: string;
      method: string;
      requestId: RequestId;
      target: string;
    }> = {}
  ): void {
    const diagnostic = describeTransportError(error);

    emitAnalyticsEvent(this.analytics, {
      name,
      context: createAnalyticsContext({
        transport: this.kind,
        ...context
      }),
      diagnostic,
      data: {
        retryable: error.retryable
      }
    });
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
}
