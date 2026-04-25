import {
  AscpClient,
  ASCP_PROTOCOL_VERSION,
  replayFromSeq,
  type Session
} from "ascp-sdk-typescript";
import { createBufferedAnalyticsRecorder } from "ascp-sdk-typescript/analytics";
import type { AscpTransport } from "ascp-sdk-typescript/transport";
import {
  parseCoreEntity,
  type ValidationResult
} from "ascp-sdk-typescript/validation";

declare function expectType<T>(value: T): void;
declare const transport: AscpTransport;

const session = parseCoreEntity("Session", {
  id: "sess_release_01",
  runtime_id: "runtime_01",
  status: "running",
  created_at: "2026-04-25T00:00:00Z",
  updated_at: "2026-04-25T00:00:00Z"
});
const recorder = createBufferedAnalyticsRecorder();
const client = new AscpClient({ transport });
const replayRequest = replayFromSeq({
  session_id: session.id,
  from_seq: 1,
  include_snapshot: true
});

expectType<string>(ASCP_PROTOCOL_VERSION);
expectType<Session>(session);
expectType<ValidationResult<Session>>({
  success: true,
  data: session
});
expectType<AscpClient>(client);

void recorder;
void replayRequest;
