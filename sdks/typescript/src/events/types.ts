import type { EventEnvelope, FlexibleObject } from "../models/types.js";

export const ASCP_CORE_EVENT_TYPES = [
  "approval.approved",
  "approval.expired",
  "approval.rejected",
  "approval.requested",
  "approval.updated",
  "input.completed",
  "input.expired",
  "input.requested",
  "artifact.created",
  "artifact.updated",
  "connection.state_changed",
  "diff.ready",
  "diff.updated",
  "error.fatal",
  "error.transient",
  "message.assistant.completed",
  "message.assistant.delta",
  "message.assistant.started",
  "message.system",
  "message.user",
  "run.cancelled",
  "run.completed",
  "run.failed",
  "run.paused",
  "run.resumed",
  "run.started",
  "session.created",
  "session.deleted",
  "session.status_changed",
  "session.updated",
  "sync.cursor_advanced",
  "sync.replayed",
  "sync.snapshot",
  "terminal.closed",
  "terminal.opened",
  "terminal.output",
  "terminal.resize_requested",
  "tool.completed",
  "tool.failed",
  "tool.started",
  "tool.stderr",
  "tool.stdout"
] as const;

export type CoreEventType = (typeof ASCP_CORE_EVENT_TYPES)[number];

export type CoreEventEnvelope<
  TType extends CoreEventType = CoreEventType,
  TPayload extends FlexibleObject = FlexibleObject
> = EventEnvelope<TPayload> & { type: TType };
