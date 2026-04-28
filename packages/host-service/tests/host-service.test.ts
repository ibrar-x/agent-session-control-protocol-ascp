import { afterEach, describe, expect, it } from "vitest";
import WebSocket from "ws";
import {
  createAscpClient,
  createEventEnvelope,
  type CapabilitiesGetResult,
  type EventEnvelope,
  type HostsGetResult,
  type SessionsSubscribeResult
} from "ascp-sdk-typescript";
import { AscpWebSocketTransport } from "ascp-sdk-typescript/transport";

import {
  createAscpHostService,
  type AscpHostRuntime,
  type AscpHostService,
  type RequestAuditEntry
} from "../src/index.js";

class FakeRuntime implements AscpHostRuntime {
  readonly capabilities: CapabilitiesGetResult = {
    protocol_version: "0.1.0",
    host: {
      id: "host:local",
      name: "Local Host",
      status: "online",
      transports: ["websocket"]
    },
    runtimes: [
      {
        id: "runtime:fake",
        kind: "fake",
        display_name: "Fake Runtime",
        version: "0.1.0",
        capabilities: {
          session_list: true,
          session_resume: true,
          stream_events: true,
          replay: true
        }
      }
    ],
    transports: ["websocket"],
    capabilities: {
      session_list: true,
      session_resume: true,
      stream_events: true,
      replay: true
    }
  };

  readonly host: HostsGetResult = {
    host: this.capabilities.host
  };

  private readonly subscriptionQueues = new Map<string, EventEnvelope<Record<string, unknown>>[]>();
  private readonly listeners = new Set<(event: EventEnvelope<Record<string, unknown>>) => void>();
  unsubscribedIds: string[] = [];

  async capabilitiesGet(): Promise<CapabilitiesGetResult> {
    return this.capabilities;
  }

  async hostsGet(): Promise<HostsGetResult> {
    return this.host;
  }

  async sessionsSubscribe(): Promise<SessionsSubscribeResult> {
    const subscriptionId = `sub:${this.subscriptionQueues.size + 1}`;
    this.subscriptionQueues.set(subscriptionId, [
      createEventEnvelope({
        id: `${subscriptionId}:snapshot`,
        type: "sync.snapshot",
        ts: "2026-04-26T00:00:00.000Z",
        session_id: "session:1",
        seq: 1,
        payload: {
          hello: "snapshot"
        }
      })
    ]);

    return {
      session_id: "session:1",
      subscription_id: subscriptionId,
      snapshot_emitted: true
    };
  }

  async sessionsUnsubscribe(params: { subscription_id: string }): Promise<{ subscription_id: string; unsubscribed: boolean }> {
    this.unsubscribedIds.push(params.subscription_id);
    return {
      subscription_id: params.subscription_id,
      unsubscribed: true
    };
  }

  drainSubscriptionEvents(subscriptionId: string): EventEnvelope<Record<string, unknown>>[] {
    const queue = this.subscriptionQueues.get(subscriptionId) ?? [];
    this.subscriptionQueues.set(subscriptionId, []);
    return queue;
  }

  onEvent(listener: (event: EventEnvelope<Record<string, unknown>>) => void): () => void {
    this.listeners.add(listener);
    return () => {
      this.listeners.delete(listener);
    };
  }

  emit(event: EventEnvelope<Record<string, unknown>>): void {
    for (const listener of this.listeners) {
      listener(event);
    }
  }
}

const servicesToClose = new Set<AscpHostService>();

afterEach(async () => {
  for (const service of servicesToClose) {
    await service.close();
  }

  servicesToClose.clear();
});

describe("createAscpHostService", () => {
  it("routes JSON-RPC requests over websocket", async () => {
    const runtime = new FakeRuntime();
    const service = createAscpHostService({
      runtime,
      port: 0
    });
    servicesToClose.add(service);

    await service.listen();

    const transport = new AscpWebSocketTransport({
      url: service.url
    });
    const client = createAscpClient({
      transport
    });

    const capabilities = await client.getCapabilities();
    const host = await client.getHost();

    expect(capabilities.protocol_version).toBe("0.1.0");
    expect(host.host.id).toBe("host:local");

    await client.close();
  });

  it("pushes replay and live events to subscribed websocket clients", async () => {
    const runtime = new FakeRuntime();
    const service = createAscpHostService({
      runtime,
      port: 0
    });
    servicesToClose.add(service);

    await service.listen();

    const transport = new AscpWebSocketTransport({
      url: service.url
    });
    const client = createAscpClient({
      transport
    });
    const stream = client.events()[Symbol.asyncIterator]();

    const subscription = await client.subscribe({
      session_id: "session:1",
      include_snapshot: true
    });

    runtime.emit(
      createEventEnvelope({
        id: "event:2",
        type: "message.assistant.delta",
        ts: "2026-04-26T00:00:01.000Z",
        session_id: "session:1",
        seq: 2,
        payload: {
          delta: "yes"
        }
      })
    );

    const first = await stream.next();
    const second = await stream.next();

    expect(subscription.subscription_id).toBe("sub:1");
    expect(first.value?.type).toBe("sync.snapshot");
    expect(second.value?.type).toBe("message.assistant.delta");

    await client.close();
  });

  it("cleans up runtime subscriptions when a client unsubscribes", async () => {
    const runtime = new FakeRuntime();
    const service = createAscpHostService({
      runtime,
      port: 0
    });
    servicesToClose.add(service);

    await service.listen();

    const transport = new AscpWebSocketTransport({
      url: service.url
    });
    const client = createAscpClient({
      transport
    });

    const subscription = await client.subscribe({
      session_id: "session:1",
      include_snapshot: true
    });

    const result = await client.unsubscribe({
      subscription_id: subscription.subscription_id
    });

    expect(result.unsubscribed).toBe(true);
    expect(runtime.unsubscribedIds).toEqual(["sub:1"]);

    await client.close();
  });

  it("returns UNAUTHORIZED when an unauthenticated socket tries to call a method", async () => {
    const runtime = new FakeRuntime();
    const service = createAscpHostService({
      runtime,
      port: 0,
      authorizeConnection: async () => ({
        authenticated: false,
        errorMessage: "Device authentication required.",
        scopes: [],
        transportMode: "loopback"
      }),
      createRequestContext: async ({ connectionAuth, correlationId, method, requestId }) => {
        if (!connectionAuth.authenticated) {
          throw {
            code: "UNAUTHORIZED",
            message: connectionAuth.errorMessage ?? "Device authentication required.",
            retryable: false,
            details: {
              correlation_id: correlationId,
              method
            }
          };
        }

        return {
          correlationId,
          method,
          requestId,
          scopes: connectionAuth.scopes,
          transportMode: connectionAuth.transportMode
        };
      }
    });
    servicesToClose.add(service);

    await service.listen();

    const response = await sendRawJsonRpc(service.url, {
      id: "1",
      jsonrpc: "2.0",
      method: "sessions.list",
      params: {}
    });

    expect(response).toMatchObject({
      error: {
        code: "UNAUTHORIZED"
      },
      id: "1"
    });
  });

  it("returns FORBIDDEN and emits audit entries when a socket lacks scope", async () => {
    const runtime = new FakeRuntime();
    const auditEntries: RequestAuditEntry[] = [];
    const service = createAscpHostService({
      runtime,
      port: 0,
      authorizeConnection: async () => ({
        authenticated: true,
        deviceId: "daemon:device:test-1",
        scopes: ["read:sessions"],
        transportMode: "loopback"
      }),
      createRequestContext: async ({ connectionAuth, correlationId, method, requestId }) => {
        if (!connectionAuth.scopes.includes("write:sessions")) {
          throw {
            code: "FORBIDDEN",
            message: "Missing scope: write:sessions",
            retryable: false,
            details: {
              correlation_id: correlationId,
              method
            }
          };
        }

        return {
          correlationId,
          method,
          requestId,
          deviceId: connectionAuth.deviceId,
          scopes: connectionAuth.scopes,
          transportMode: connectionAuth.transportMode
        };
      },
      onRequestAudit: async (entry) => {
        auditEntries.push(entry);
      }
    });
    servicesToClose.add(service);

    await service.listen();

    const response = await sendRawJsonRpc(service.url, {
      id: "2",
      jsonrpc: "2.0",
      method: "sessions.send_input",
      params: {
        session_id: "session:1",
        input: {
          text: "hi",
          type: "text"
        }
      }
    });

    expect(response).toMatchObject({
      error: {
        code: "FORBIDDEN"
      }
    });
    expect(auditEntries).toHaveLength(2);
    expect(auditEntries[0]).toMatchObject({
      stage: "received",
      authenticated: true,
      method: "sessions.send_input"
    });
    expect(auditEntries[1]).toMatchObject({
      stage: "completed",
      errorCode: "FORBIDDEN",
      outcome: "rejected"
    });
    expect(auditEntries[0]?.correlationId).toBe(auditEntries[1]?.correlationId);
  });
});

async function sendRawJsonRpc(url: string, payload: Record<string, unknown>): Promise<Record<string, unknown>> {
  const socket = new WebSocket(url);

  await new Promise<void>((resolve, reject) => {
    socket.once("open", () => resolve());
    socket.once("error", (error) => reject(error));
  });

  const response = await new Promise<Record<string, unknown>>((resolve, reject) => {
    socket.once("message", (chunk) => {
      try {
        resolve(JSON.parse(chunk.toString()) as Record<string, unknown>);
      } catch (error) {
        reject(error);
      }
    });
    socket.once("error", (error) => reject(error));
    socket.send(JSON.stringify(payload));
  });

  socket.close();
  return response;
}
