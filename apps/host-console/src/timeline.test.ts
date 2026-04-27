import { describe, expect, it } from "vitest";

import { buildTimeline } from "./timeline";

describe("buildTimeline", () => {
  it("accumulates assistant deltas into one in-progress bubble and replaces it on completion", () => {
    const timeline = buildTimeline(
      [
        {
          id: "event_1",
          type: "message.assistant.delta",
          ts: "2026-04-27T12:00:00.000Z",
          session_id: "codex:session_1",
          payload: {
            message_id: "codex:message:session_1:item_1",
            delta: "Hel"
          }
        },
        {
          id: "event_2",
          type: "message.assistant.delta",
          ts: "2026-04-27T12:00:01.000Z",
          session_id: "codex:session_1",
          payload: {
            message_id: "codex:message:session_1:item_1",
            delta: "lo"
          }
        },
        {
          id: "event_3",
          type: "message.assistant.completed",
          ts: "2026-04-27T12:00:02.000Z",
          session_id: "codex:session_1",
          payload: {
            message_id: "codex:message:session_1:item_1",
            content: "Hello"
          }
        }
      ],
      [],
      []
    );

    expect(timeline).toEqual([
      expect.objectContaining({
        kind: "assistant",
        body: "Hello",
        ts: "2026-04-27T12:00:02.000Z"
      })
    ]);
  });

  it("keeps distinct assistant messages separate when message ids differ", () => {
    const timeline = buildTimeline(
      [
        {
          id: "event_1",
          type: "message.assistant.delta",
          ts: "2026-04-27T12:00:00.000Z",
          session_id: "codex:session_1",
          payload: {
            message_id: "codex:message:session_1:item_1",
            delta: "Hello"
          }
        },
        {
          id: "event_2",
          type: "message.assistant.delta",
          ts: "2026-04-27T12:00:01.000Z",
          session_id: "codex:session_1",
          payload: {
            message_id: "codex:message:session_1:item_2",
            delta: "World"
          }
        }
      ],
      [],
      []
    );

    expect(timeline).toEqual([
      expect.objectContaining({
        kind: "assistant",
        body: "Hello"
      }),
      expect.objectContaining({
        kind: "assistant",
        body: "World"
      })
    ]);
  });
});
