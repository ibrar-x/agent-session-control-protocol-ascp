import { describe, expect, it, vi } from "vitest";
import type { AscpHostRuntime } from "@ascp/host-service";
import { createEventEnvelope } from "ascp-sdk-typescript";

import { startHostDaemon } from "../src/main.js";

describe("host-daemon replay integration", () => {
  it("wraps sessions.subscribe around seeded snapshot plus persisted replay", async () => {
    const listeners: Array<(event: ReturnType<typeof createEventEnvelope>) => void> = [];
    let capturedRuntime: AscpHostRuntime | null = null;

    const runtime: AscpHostRuntime = {
      capabilitiesGet: vi.fn(async () => ({}) as never),
      hostsGet: vi.fn(async () => ({}) as never),
      sessionsGet: vi.fn(async () => ({
        session: {
          id: "codex:thread-1",
          runtime_id: "codex_local",
          status: "running",
          created_at: "2026-04-27T00:00:00.000Z",
          updated_at: "2026-04-27T00:00:00.000Z"
        },
        pending_approvals: [],
        pending_inputs: []
      })),
      onEvent: vi.fn((listener) => {
        listeners.push(listener);
        return () => {};
      })
    };

    const daemon = await startHostDaemon({
      config: {
        adminPort: 0,
        authTransport: "loopback",
        databasePath: ":memory:",
        host: "127.0.0.1",
        port: 8765,
        runtime: "codex"
      },
      runtimeRegistry: {
        createRuntime: vi.fn(() => runtime)
      },
      createHostService: vi.fn(({ runtime: providedRuntime }) => {
        capturedRuntime = providedRuntime;
        return {
          url: "ws://127.0.0.1:8765",
          listen: async () => {},
          close: async () => {}
        };
      })
    });

    const firstSubscription = await capturedRuntime?.sessionsSubscribe?.({
      session_id: "codex:thread-1",
      include_snapshot: true,
      from_seq: 0
    });

    listeners[0]?.(
      createEventEnvelope({
        id: "event-1",
        type: "message.user",
        ts: "2026-04-27T00:00:01.000Z",
        session_id: "codex:thread-1",
        payload: { text: "hi" }
      })
    );

    capturedRuntime?.drainSubscriptionEvents?.(firstSubscription!.subscription_id);

    const secondSubscription = await capturedRuntime?.sessionsSubscribe?.({
      session_id: "codex:thread-1",
      include_snapshot: true,
      from_seq: 0
    });
    const drained = capturedRuntime?.drainSubscriptionEvents?.(secondSubscription!.subscription_id);

    expect(secondSubscription?.snapshot_emitted).toBe(true);
    expect(drained?.[0]?.type).toBe("sync.snapshot");
    expect(drained?.[1]?.type).toBe("message.user");
    expect(drained?.[2]?.type).toBe("sync.replayed");

    await daemon.close();
  });
});
