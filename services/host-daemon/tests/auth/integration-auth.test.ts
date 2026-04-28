import { afterEach, describe, expect, it, vi } from "vitest";
import WebSocket from "ws";

import { startHostDaemon, type RunningHostDaemon } from "../../src/main.js";

const daemonsToClose = new Set<RunningHostDaemon>();

afterEach(async () => {
  for (const daemon of daemonsToClose) {
    await daemon.close();
  }

  daemonsToClose.clear();
});

describe("host daemon auth integration", () => {
  it("allows paired devices to read sessions and forbids missing write scope", async () => {
    const daemon = await startHostDaemon({
      config: {
        adminPort: 0,
        authTransport: "loopback",
        databasePath: ":memory:",
        host: "127.0.0.1",
        port: 0,
        runtime: "codex"
      },
      runtimeRegistry: {
        createRuntime: () => ({
          capabilitiesGet: async () => ({
            capabilities: {
              replay: true,
              session_list: true
            },
            host: {
              id: "host:1",
              status: "online",
              transports: ["websocket"]
            },
            protocol_version: "0.1.0",
            runtimes: [],
            transports: ["websocket"]
          }),
          hostsGet: async () => ({
            host: {
              id: "host:1",
              status: "online",
              transports: ["websocket"]
            }
          }),
          sessionsList: vi.fn(async () => ({
            sessions: [
              {
                id: "session:1",
                runtime_id: "runtime:codex",
                status: "running"
              }
            ]
          })),
          sessionsSendInput: vi.fn(async () => ({
            accepted: true
          }))
        })
      }
    });
    daemonsToClose.add(daemon);

    const pair = await daemon.pairingService.pairDevice({
      displayName: "QA phone",
      scopes: ["read:hosts", "read:sessions"]
    });

    const listResponse = await sendAuthenticatedJsonRpc(daemon.url, pair, {
      id: "1",
      jsonrpc: "2.0",
      method: "sessions.list",
      params: {}
    });
    const writeResponse = await sendAuthenticatedJsonRpc(daemon.url, pair, {
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

    expect(listResponse).toMatchObject({
      id: "1",
      result: {
        sessions: [
          {
            id: "session:1"
          }
        ]
      }
    });
    expect(writeResponse).toMatchObject({
      error: {
        code: "FORBIDDEN"
      },
      id: "2"
    });
  });
});

async function sendAuthenticatedJsonRpc(
  url: string,
  pair: { deviceId: string; deviceSecret: string },
  payload: Record<string, unknown>
): Promise<Record<string, unknown>> {
  const socket = new WebSocket(url, {
    headers: {
      "x-ascp-device-id": pair.deviceId,
      "x-ascp-device-secret": pair.deviceSecret
    }
  });

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
