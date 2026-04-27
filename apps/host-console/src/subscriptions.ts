import type { SessionsSubscribeParams } from "ascp-sdk-typescript/models";

export function buildSessionSubscriptionRequest(sessionId: string): SessionsSubscribeParams {
  return {
    session_id: sessionId,
    include_snapshot: true,
    from_seq: 0
  };
}
