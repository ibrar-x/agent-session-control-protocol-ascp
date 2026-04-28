import { describe, expect, it } from "vitest";

import { openDaemonDatabase } from "../src/sqlite.js";
import { createCursorStore } from "../src/stores/cursor-store.js";

describe("cursor store", () => {
  it("persists origin, durable position, and opaque cursor json", () => {
    const database = openDaemonDatabase(":memory:");
    const store = createCursorStore(database);

    store.initializeSeededCursor("codex:thread-1", { remote_cursor: "seed-1" });
    store.recordLivePosition({
      sessionId: "codex:thread-1",
      lastSeq: 2,
      lastEventId: "event-2",
      cursor: { remote_cursor: "live-2" }
    });

    expect(store.getCursor("codex:thread-1")).toEqual({
      sessionId: "codex:thread-1",
      origin: "live_stream",
      lastSeq: 2,
      lastEventId: "event-2",
      cursor: { remote_cursor: "live-2" }
    });
  });

  it("does not downgrade a live cursor when seeded initialization runs again", () => {
    const database = openDaemonDatabase(":memory:");
    const store = createCursorStore(database);

    store.recordLivePosition({
      sessionId: "codex:thread-1",
      lastSeq: 2,
      lastEventId: "event-2",
      cursor: { remote_cursor: "live-2" }
    });

    const stored = store.initializeSeededCursor("codex:thread-1", { remote_cursor: "seed-1" });

    expect(stored).toEqual({
      sessionId: "codex:thread-1",
      origin: "live_stream",
      lastSeq: 2,
      lastEventId: "event-2",
      cursor: { remote_cursor: "live-2" }
    });
  });
});
