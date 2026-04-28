import { describe, expect, it } from "vitest";

import { openDaemonDatabase } from "../src/sqlite.js";
import { createEventStore } from "../src/stores/event-store.js";

describe("event store", () => {
  it("rejects synthetic replay-control envelopes from durable event persistence", () => {
    const database = openDaemonDatabase(":memory:");
    const store = createEventStore(database);

    expect(() =>
      store.append({
        id: "snapshot-1",
        type: "sync.snapshot",
        ts: "2026-04-27T00:00:00.000Z",
        session_id: "codex:thread-1",
        payload: {}
      })
    ).toThrow("Synthetic replay-control events must not be persisted");

    expect(() =>
      store.append({
        id: "replayed-1",
        type: "sync.replayed",
        ts: "2026-04-27T00:00:01.000Z",
        session_id: "codex:thread-1",
        payload: {}
      })
    ).toThrow("Synthetic replay-control events must not be persisted");
  });

  it("assigns durable per-session seq values instead of trusting fixture seq", () => {
    const database = openDaemonDatabase(":memory:");
    const store = createEventStore(database);

    const first = store.append({
      id: "event-1",
      type: "message.user",
      ts: "2026-04-27T00:00:00.000Z",
      session_id: "codex:thread-1",
      payload: { text: "hello" }
    });

    expect(first.seq).toBe(1);
  });

  it("replays events after seq or event id with session-local ordering", () => {
    const database = openDaemonDatabase(":memory:");
    const store = createEventStore(database);

    const first = store.append({
      id: "event-1",
      type: "message.user",
      ts: "2026-04-27T00:00:00.000Z",
      session_id: "codex:thread-1",
      payload: { text: "hello" }
    });
    const second = store.append({
      id: "event-2",
      type: "message.assistant",
      ts: "2026-04-27T00:00:01.000Z",
      session_id: "codex:thread-1",
      payload: { text: "world" }
    });
    const otherSession = store.append({
      id: "event-3",
      type: "message.user",
      ts: "2026-04-27T00:00:02.000Z",
      session_id: "codex:thread-2",
      payload: { text: "independent" }
    });

    expect(first.seq).toBe(1);
    expect(second.seq).toBe(2);
    expect(otherSession.seq).toBe(1);
    expect(store.listAfterSeq("codex:thread-1", 0).map((event) => event.id)).toEqual([
      "event-1",
      "event-2"
    ]);
    expect(store.listAfterSeq("codex:thread-1", 1).map((event) => event.id)).toEqual(["event-2"]);
    expect(store.listAfterEventId("codex:thread-1", "event-1").map((event) => event.id)).toEqual([
      "event-2"
    ]);
  });
});
