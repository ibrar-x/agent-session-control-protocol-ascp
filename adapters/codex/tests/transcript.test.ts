import { describe, expect, it } from "vitest";

import { extractTranscriptEvents } from "../src/transcript.js";

describe("extractTranscriptEvents", () => {
  it("extracts historical user messages from content arrays", () => {
    const events = extractTranscriptEvents({
      id: "thread_history",
      turns: [
        {
          id: "turn_1",
          status: "completed",
          startedAt: 1_777_252_212,
          completedAt: 1_777_252_220,
          items: [
            {
              type: "userMessage",
              id: "item_1",
              content: [
                {
                  type: "text",
                  text: "Say only yes."
                }
              ]
            }
          ]
        }
      ]
    } as never);

    expect(events).toEqual([
      expect.objectContaining({
        type: "message.user",
        payload: expect.objectContaining({
          content: "Say only yes."
        })
      })
    ]);
  });
});
