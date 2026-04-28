import { describe, expect, it, vi } from "vitest";

import { createAuthAwareRuntime } from "../../src/auth/runtime.js";

describe("createAuthAwareRuntime", () => {
  it("adds auth.transport metadata to capabilities.get", async () => {
    const runtime = createAuthAwareRuntime({
      runtime: {
        capabilitiesGet: vi.fn(async () => ({
          capabilities: {
            replay: true
          },
          host: {
            id: "host:1",
            status: "online",
            transports: ["websocket"]
          },
          protocol_version: "0.1.0",
          runtimes: [],
          transports: ["websocket"]
        })),
        hostsGet: vi.fn(async () => ({
          host: {
            id: "host:1",
            status: "online",
            transports: ["websocket"]
          }
        }))
      },
      transportMode: "loopback"
    });

    await expect(runtime.capabilitiesGet()).resolves.toMatchObject({
      auth: {
        transport: "loopback"
      }
    });
  });
});
