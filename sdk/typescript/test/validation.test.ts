import { describe, expect, it } from "vitest";

import messageAssistantDeltaExample from "../../examples/events/message-assistant-delta.json";
import sessionExample from "../../examples/core/session.json";
import sessionsListErrorExample from "../../examples/errors/sessions-list.json";
import sessionsListResponseExample from "../../examples/responses/sessions-list.json";
import {
  AscpValidationError,
  parseCoreEntity,
  parseCoreEventEnvelope,
  safeParseCoreEntity,
  safeParseMethodResponse
} from "../src/validation/index.js";

describe("validation helpers", () => {
  it("safe parses a schema-valid core entity example", () => {
    const result = safeParseCoreEntity("Session", sessionExample);

    expect(result.success).toBe(true);

    if (result.success) {
      expect(result.data.status).toBe("running");
      expect(result.data.id).toBe("sess_abc123");
    }
  });

  it("throws actionable errors for invalid core entities", () => {
    const invalidSession = {
      ...sessionExample,
      status: "sleeping"
    };

    expect(() => parseCoreEntity("Session", invalidSession)).toThrowError(
      AscpValidationError
    );

    try {
      parseCoreEntity("Session", invalidSession);
    } catch (error) {
      expect(error).toBeInstanceOf(AscpValidationError);

      const validationError = error as AscpValidationError;

      expect(validationError.target).toBe("Session");
      expect(validationError.issues).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            keyword: "enum",
            path: "/status"
          })
        ])
      );
    }
  });

  it("safe parses a schema-valid method success response", () => {
    const result = safeParseMethodResponse(
      "sessions.list",
      sessionsListResponseExample
    );

    expect(result.success).toBe(true);

    if (result.success) {
      expect(result.data.result.sessions).toHaveLength(1);
      expect(result.data.result.next_cursor).toBeNull();
    }
  });

  it("safe parses a schema-valid method error response", () => {
    const result = safeParseMethodResponse("sessions.list", sessionsListErrorExample);

    expect(result.success).toBe(true);

    if (result.success) {
      expect(result.data.error.code).toBe("FORBIDDEN");
      expect(result.data.error.details).toEqual(
        expect.objectContaining({
          method: "sessions.list"
        })
      );
    }
  });

  it("reports nested method response failures with the result path", () => {
    const invalidResponse = {
      ...sessionsListResponseExample,
      result: {
        ...sessionsListResponseExample.result,
        sessions: sessionsListResponseExample.result.sessions.map((session) => ({
          ...session,
          created_at: "not-a-timestamp"
        }))
      }
    };

    const result = safeParseMethodResponse("sessions.list", invalidResponse);

    expect(result.success).toBe(false);

    if (!result.success) {
      expect(result.error.target).toBe("sessions.list response");
      expect(result.error.issues).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            path: "/result/sessions/0/created_at"
          })
        ])
      );
    }
  });

  it("parses a schema-valid core event envelope", () => {
    const event = parseCoreEventEnvelope(messageAssistantDeltaExample);

    expect(event.type).toBe("message.assistant.delta");
    expect(event.payload.delta).toContain("source of the failure");
  });

  it("reports payload-level errors for invalid core event envelopes", () => {
    const invalidEvent = {
      ...messageAssistantDeltaExample,
      payload: {
        message_id: messageAssistantDeltaExample.payload.message_id
      }
    };

    expect(() => parseCoreEventEnvelope(invalidEvent)).toThrowError(
      AscpValidationError
    );

    try {
      parseCoreEventEnvelope(invalidEvent);
    } catch (error) {
      expect(error).toBeInstanceOf(AscpValidationError);

      const validationError = error as AscpValidationError;

      expect(validationError.target).toBe("message.assistant.delta event");
      expect(validationError.issues).toEqual(
        expect.arrayContaining([
          expect.objectContaining({
            keyword: "required",
            path: "/payload"
          })
        ])
      );
    }
  });
});
