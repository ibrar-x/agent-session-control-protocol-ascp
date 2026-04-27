import { describe, expect, it } from "vitest";

import { mapNotificationToEvents } from "../src/events.js";

const NOW = "2026-04-26T12:00:00Z";

describe("mapNotificationToEvents", () => {
  it("maps turn/started into a run.started event", () => {
    const [event] = mapNotificationToEvents(
      {
        method: "turn/started",
        params: {
          threadId: "thread_1",
          turn: {
            id: "turn_1",
            status: "inProgress",
            startedAt: 1_745_661_900
          }
        }
      },
      {
        seq: 5,
        now: () => NOW
      }
    );

    expect(event).toEqual({
      id: "codex:event:turn_started:thread_1:turn_1",
      type: "run.started",
      ts: "2025-04-26T10:05:00.000Z",
      session_id: "codex:thread_1",
      run_id: "codex:thread_1:turn_1",
      seq: 5,
      payload: {
        run: {
          id: "codex:thread_1:turn_1",
          session_id: "codex:thread_1",
          status: "running",
          started_at: "2025-04-26T10:05:00.000Z"
        }
      }
    });
  });

  it("maps turn/completed into assistant completion plus run.completed events", () => {
    const [messageEvent, runEvent] = mapNotificationToEvents(
      {
        method: "turn/completed",
        params: {
          threadId: "thread_1",
          turn: {
            id: "turn_1",
            status: "completed",
            startedAt: 1_745_661_900,
            completedAt: 1_745_662_140,
            exitCode: 0,
            items: [
              {
                type: "agentMessage",
                id: "item_1",
                text: "Finished the requested change."
              }
            ]
          }
        }
      },
      {
        now: () => NOW
      }
    );

    expect(messageEvent).toEqual({
      id: "codex:event:agent_message_completed:thread_1:turn_1:item_1",
      type: "message.assistant.completed",
      ts: "2025-04-26T10:09:00.000Z",
      session_id: "codex:thread_1",
      run_id: "codex:thread_1:turn_1",
      payload: {
        message_id: "codex:message:thread_1:item_1",
        content: "Finished the requested change."
      }
    });

    expect(runEvent).toEqual({
      id: "codex:event:turn_completed:thread_1:turn_1",
      type: "run.completed",
      ts: "2025-04-26T10:09:00.000Z",
      session_id: "codex:thread_1",
      run_id: "codex:thread_1:turn_1",
      payload: {
        run_id: "codex:thread_1:turn_1",
        ended_at: "2025-04-26T10:09:00.000Z",
        exit_code: 0
      }
    });
  });

  it("maps agentMessageDelta into a message.assistant.delta event", () => {
    const [event] = mapNotificationToEvents(
      {
        method: "agentMessageDelta",
        params: {
          threadId: "thread_1",
          turnId: "turn_1",
          itemId: "item_1",
          delta: "Hello from Codex"
        }
      },
      {
        seq: 13,
        now: () => NOW
      }
    );

    expect(event).toEqual({
      id: "codex:event:agent_message_delta:thread_1:turn_1:item_1",
      type: "message.assistant.delta",
      ts: NOW,
      session_id: "codex:thread_1",
      run_id: "codex:thread_1:turn_1",
      seq: 13,
      payload: {
        message_id: "codex:message:thread_1:item_1",
        delta: "Hello from Codex"
      }
    });
  });

  it("maps turn/diff/updated into a conservative diff.updated event", () => {
    const [event] = mapNotificationToEvents(
      {
        method: "turn/diff/updated",
        params: {
          threadId: "thread_1",
          turnId: "turn_1",
          diff: "--- a/file.ts\n+++ b/file.ts"
        }
      },
      {
        now: () => NOW
      }
    );

    expect(event).toEqual({
      id: "codex:event:turn_diff_updated:thread_1:turn_1",
      type: "diff.updated",
      ts: NOW,
      session_id: "codex:thread_1",
      run_id: "codex:thread_1:turn_1",
      payload: {
        session_id: "codex:thread_1",
        run_id: "codex:thread_1:turn_1",
        changed_fields: ["x_codex_diff"]
      }
    });
  });

  it("returns no events for unsupported notifications", () => {
    expect(
      mapNotificationToEvents(
        {
          method: "thread/status/changed",
          params: {
            threadId: "thread_1"
          }
        },
        {
          now: () => NOW
        }
      )
    ).toEqual([]);
  });
});
