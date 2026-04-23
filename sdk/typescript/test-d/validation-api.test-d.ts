import type {
  CoreMethodResponse,
  ValidationResult
} from "../src/validation/index.js";
import type { Session } from "../src/index.js";
import {
  parseCoreEntity,
  safeParseCoreEntity,
  safeParseMethodResponse
} from "../src/validation/index.js";

const session = parseCoreEntity("Session", {
  id: "sess_123",
  runtime_id: "runtime_01",
  status: "running",
  created_at: "2026-04-24T00:00:00Z",
  updated_at: "2026-04-24T00:00:00Z"
});

const sessionResult: ValidationResult<Session> = safeParseCoreEntity("Session", session);
const sessionsListResponse: ValidationResult<CoreMethodResponse<"sessions.list">> =
  safeParseMethodResponse("sessions.list", {
    jsonrpc: "2.0",
    id: "req_1",
    result: {
      sessions: [session],
      next_cursor: null
    }
  });

void sessionResult;
void sessionsListResponse;
