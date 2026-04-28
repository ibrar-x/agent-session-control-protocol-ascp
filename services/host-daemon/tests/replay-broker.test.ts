import { describe, expect, it } from "vitest";
import { createEventEnvelope } from "ascp-sdk-typescript";

import { openDaemonDatabase } from "../src/sqlite.js";
import { createReplayBroker } from "../src/replay-broker.js";
import { createEventStore } from "../src/stores/event-store.js";
import { createSessionStore } from "../src/stores/session-store.js";

describe("replay broker", () => {
  it("serves a snapshot with completeness metadata, replayed stored events, and sync.replayed", () => {
    const database = openDaemonDatabase(":memory:");
    const sessionStore = createSessionStore(database);
    const eventStore = createEventStore(database);

    sessionStore.upsertSeededSnapshot({
      sessionId: "codex:thread-1",
      runtimeId: "codex_local",
      session: {
        id: "codex:thread-1",
        runtime_id: "codex_local",
        status: "running",
        created_at: "2026-04-27T00:00:00.000Z",
        updated_at: "2026-04-27T00:00:00.000Z"
      },
      activeRun: null,
      pendingApprovals: [],
      pendingInputs: [],
      snapshotOrigin: "seeded_snapshot",
      completeness: "partial",
      missingFields: ["active_run"],
      missingReasons: { active_run: "runtime_omitted" },
      attachmentStatus: "attached"
    });

    eventStore.append(
      createEventEnvelope({
        id: "event-1",
        type: "message.user",
        ts: "2026-04-27T00:00:01.000Z",
        session_id: "codex:thread-1",
        payload: { text: "hi" }
      })
    );

    const broker = createReplayBroker({ sessionStore, eventStore });
    const { events } = broker.createSubscription({
      sessionId: "codex:thread-1",
      includeSnapshot: true,
      fromSeq: 0
    });

    expect(events[0]?.type).toBe("sync.snapshot");
    expect(events[0]?.payload.metadata?.completeness).toBe("partial");
    expect(events[1]?.type).toBe("message.user");
    expect(events[2]?.type).toBe("sync.replayed");
  });

  it("surfaces detached seeded baselines and still allows replay of previously stored events", () => {
    const database = openDaemonDatabase(":memory:");
    const sessionStore = createSessionStore(database);
    const eventStore = createEventStore(database);

    sessionStore.upsertSeededSnapshot({
      sessionId: "codex:thread-2",
      runtimeId: "codex_local",
      session: {
        id: "codex:thread-2",
        runtime_id: "codex_local",
        status: "idle",
        created_at: "2026-04-27T00:00:00.000Z",
        updated_at: "2026-04-27T00:00:00.000Z"
      },
      activeRun: null,
      pendingApprovals: [],
      pendingInputs: [],
      snapshotOrigin: "seeded_snapshot",
      completeness: "complete",
      missingFields: [],
      missingReasons: {},
      attachmentStatus: "detached"
    });

    eventStore.append(
      createEventEnvelope({
        id: "event-detached-1",
        type: "message.user",
        ts: "2026-04-27T00:00:01.000Z",
        session_id: "codex:thread-2",
        payload: { text: "historic" }
      })
    );

    const broker = createReplayBroker({ sessionStore, eventStore });
    const { events } = broker.createSubscription({
      sessionId: "codex:thread-2",
      includeSnapshot: true,
      fromSeq: 0
    });

    expect(events[0]?.payload.metadata.attachment_status).toBe("detached");
    expect(events[1]?.type).toBe("message.user");
    expect(events[2]?.type).toBe("sync.replayed");
  });
});
