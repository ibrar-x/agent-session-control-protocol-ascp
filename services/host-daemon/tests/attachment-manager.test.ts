import { describe, expect, it, vi } from "vitest";
import { createEventEnvelope } from "ascp-sdk-typescript";

import { createAttachmentManager } from "../src/attachment-manager.js";
import { openDaemonDatabase } from "../src/sqlite.js";
import { createCursorStore } from "../src/stores/cursor-store.js";
import { createEventStore } from "../src/stores/event-store.js";
import { createSessionStore } from "../src/stores/session-store.js";

describe("attachment manager", () => {
  it("seeds a baseline, persists normalized live events, and advances cursor state with zero subscribers", async () => {
    const database = openDaemonDatabase(":memory:");
    const sessionStore = createSessionStore(database);
    const eventStore = createEventStore(database);
    const cursorStore = createCursorStore(database);
    const listeners: Array<(event: ReturnType<typeof createEventEnvelope>) => void> = [];

    const runtime = {
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
      onEvent: vi.fn((listener: (event: ReturnType<typeof createEventEnvelope>) => void) => {
        listeners.push(listener);
        return () => {};
      })
    };

    const manager = createAttachmentManager({
      runtime,
      sessionStore,
      eventStore,
      cursorStore
    });

    await manager.attachSession("codex:thread-1");

    listeners[0]?.(
      createEventEnvelope({
        id: "event-1",
        type: "message.user",
        ts: "2026-04-27T00:00:01.000Z",
        session_id: "codex:thread-1",
        seq: 99,
        payload: { text: "hi" }
      })
    );

    expect(sessionStore.getSnapshot("codex:thread-1")).toEqual(
      expect.objectContaining({
        attachmentStatus: "attached",
        snapshotOrigin: "seeded_snapshot",
        completeness: "partial",
        missingFields: ["active_run"]
      })
    );
    expect(eventStore.listAfterSeq("codex:thread-1", 0)[0]?.seq).toBe(1);
    expect(eventStore.listAfterSeq("codex:thread-1", 0)[0]?.id).toBe("event-1");
    expect(cursorStore.getCursor("codex:thread-1")?.lastSeq).toBe(1);
  });
});
