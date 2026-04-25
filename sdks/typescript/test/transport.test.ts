import { once } from "node:events";
import { createServer } from "node:http";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { afterEach, describe, expect, it } from "vitest";
import { WebSocketServer } from "ws";

import type { EventEnvelope } from "../src/models/index.js";
import {
  AscpStdioTransport,
  AscpTransportError,
  AscpWebSocketTransport,
  type AscpTransportSubscription
} from "../src/transport/index.js";

const TEST_DIR = dirname(fileURLToPath(import.meta.url));
const SDK_DIR = resolve(TEST_DIR, "..");
const REPO_DIR = resolve(SDK_DIR, "../..");
const MOCK_SERVER_CLI = resolve(REPO_DIR, "services/mock-server/src/mock_server/cli.py");

const openTransports = new Set<{ close(): Promise<void> }>();

afterEach(async () => {
  await Promise.all([...openTransports].map((transport) => transport.close()));
  openTransports.clear();
});

function trackTransport<T extends { close(): Promise<void> }>(transport: T): T {
  openTransports.add(transport);
  return transport;
}

async function nextEvent(
  subscription: AscpTransportSubscription,
  timeoutMs = 2_000
): Promise<EventEnvelope> {
  const iterator = subscription[Symbol.asyncIterator]();
  let timeoutHandle: ReturnType<typeof setTimeout> | undefined;

  const timer = new Promise<never>((_, reject) => {
    timeoutHandle = setTimeout(() => {
      reject(new Error(`Timed out waiting for transport event after ${timeoutMs}ms.`));
    }, timeoutMs);
  });

  const result = await Promise.race([iterator.next(), timer]).finally(() => {
    if (timeoutHandle !== undefined) {
      clearTimeout(timeoutHandle);
    }
  });

  if (result.done) {
    throw new Error("Transport subscription closed before an event was received.");
  }

  return result.value;
}

describe("transport layer", () => {
  it("reaches the upstream mock server through the stdio transport", async () => {
    const transport = trackTransport(
      new AscpStdioTransport({
        command: ["python3", MOCK_SERVER_CLI],
        cwd: REPO_DIR
      })
    );

    await transport.connect();

    const response = await transport.request("capabilities.get");

    expect("result" in response).toBe(true);

    if ("result" in response) {
      expect(response.result.host.id).toBe("host_01");
      expect(response.result.transports).toEqual(
        expect.arrayContaining(["websocket", "http_sse", "relay"])
      );
      expect(response.result.capabilities.stream_events).toBe(true);
    }
  });

  it("streams session events after a subscribe request over stdio", async () => {
    const transport = trackTransport(
      new AscpStdioTransport({
        command: ["python3", MOCK_SERVER_CLI],
        cwd: REPO_DIR
      })
    );

    await transport.connect();

    const subscription = transport.subscribe();
    const response = await transport.request("sessions.subscribe", {
      session_id: "sess_abc123",
      include_snapshot: true,
      from_seq: 34
    });

    expect("result" in response).toBe(true);

    const firstEvent = await nextEvent(subscription);
    const eventTypes = [firstEvent.type];

    while (!eventTypes.includes("sync.replayed") && eventTypes.length < 6) {
      eventTypes.push((await nextEvent(subscription)).type);
    }

    expect(firstEvent.session_id).toBe("sess_abc123");
    expect(eventTypes).toContain("sync.snapshot");
    expect(eventTypes).toContain("sync.replayed");

    await subscription.close();
  });

  it("normalizes malformed stdio output into transport protocol errors", async () => {
    const transport = trackTransport(
      new AscpStdioTransport({
        command: [
          process.execPath,
          "-e",
          [
            "process.stdin.setEncoding('utf8');",
            "process.stdin.once('data', () => {",
            "  process.stdout.write('not-json\\n');",
            "});"
          ].join("")
        ],
        cwd: SDK_DIR
      })
    );

    await transport.connect();

    await expect(transport.request("capabilities.get")).rejects.toMatchObject({
      name: "AscpTransportError",
      code: "TRANSPORT_PROTOCOL"
    } satisfies Partial<AscpTransportError>);
  });

  it("dispatches request responses and streamed events over WebSocket", async () => {
    const httpServer = createServer();
    const webSocketServer = new WebSocketServer({ server: httpServer });

    webSocketServer.on("connection", (socket) => {
      socket.on("message", (raw) => {
        const request = JSON.parse(String(raw)) as {
          id: string | number;
          method: string;
        };

        socket.send(
          JSON.stringify({
            jsonrpc: "2.0",
            id: request.id,
            result: {
              session_id: "sess_abc123",
              subscription_id: "sub_123",
              snapshot_emitted: true
            }
          })
        );

        socket.send(
          JSON.stringify({
            id: "evt_1",
            type: "sync.snapshot",
            ts: "2026-04-24T00:00:00Z",
            session_id: "sess_abc123",
            payload: {
              session: {
                id: "sess_abc123",
                runtime_id: "runtime_local_01",
                status: "running",
                created_at: "2026-04-24T00:00:00Z",
                updated_at: "2026-04-24T00:00:00Z"
              },
              pending_approvals: []
            }
          })
        );
      });
    });

    httpServer.listen(0, "127.0.0.1");
    await once(httpServer, "listening");

    const address = httpServer.address();

    if (address === null || typeof address === "string") {
      throw new Error("WebSocket test server did not expose a numeric port.");
    }

    const transport = trackTransport(
      new AscpWebSocketTransport({
        url: `ws://127.0.0.1:${address.port}`
      })
    );

    await transport.connect();

    const subscription = transport.subscribe();
    const response = await transport.request("sessions.subscribe", {
      session_id: "sess_abc123",
      include_snapshot: true
    });

    expect("result" in response).toBe(true);

    const event = await nextEvent(subscription);

    expect(event.type).toBe("sync.snapshot");
    expect(event.session_id).toBe("sess_abc123");

    await subscription.close();
    await transport.close();
    await new Promise<void>((resolvePromise, rejectPromise) => {
      webSocketServer.close((error) => {
        if (error) {
          rejectPromise(error);
          return;
        }

        resolvePromise();
      });
    });
    await new Promise<void>((resolvePromise, rejectPromise) => {
      httpServer.close((error) => {
        if (error) {
          rejectPromise(error);
          return;
        }

        resolvePromise();
      });
    });
  });

  it("normalizes WebSocket connection failures", async () => {
    const transport = trackTransport(
      new AscpWebSocketTransport({
        url: "ws://127.0.0.1:1"
      })
    );

    await expect(transport.connect()).rejects.toMatchObject({
      name: "AscpTransportError",
      code: "TRANSPORT_CONNECTION"
    } satisfies Partial<AscpTransportError>);
  });
});
