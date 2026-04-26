import type { EventEnvelope, FlexibleObject } from "../models/types.js";

export function createEventEnvelope<TPayload extends FlexibleObject>(
  event: EventEnvelope<TPayload>
): EventEnvelope<TPayload> {
  return event;
}
