import type {
  AscpReplayRequest,
  AscpReplaySubscription,
  ErrorObject,
  EventEnvelope,
  Session,
  SessionsListParams
} from "../src/index.js";
import { replayFromSeq } from "../src/index.js";

const session: Session = {
  id: "sess_123",
  runtime_id: "runtime_01",
  status: "running",
  created_at: "2026-04-23T00:00:00Z",
  updated_at: "2026-04-23T00:00:00Z"
};

const params: SessionsListParams = {
  limit: 25,
  status: "running"
};

const event: EventEnvelope = {
  id: "evt_1",
  type: "message.assistant.delta",
  ts: "2026-04-23T00:00:00Z",
  session_id: session.id,
  seq: 1,
  payload: {
    delta: "hello",
    message_id: "msg_1"
  }
};

const errorObject: ErrorObject = {
  code: "INTERNAL_ERROR",
  message: "unexpected",
  retryable: false
};

const replayRequest: AscpReplayRequest = replayFromSeq({
  session_id: "sess_123",
  from_seq: 34,
  include_snapshot: true
});

declare const replaySubscription: AscpReplaySubscription;

void params;
void event;
void errorObject;
void replayRequest;
void replaySubscription;
