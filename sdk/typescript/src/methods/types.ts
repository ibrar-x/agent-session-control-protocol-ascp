import type {
  ApprovalRequest,
  ApprovalStatus,
  Artifact,
  ArtifactKind,
  CapabilityDocument,
  DiffSummary,
  FlexibleObject,
  Host,
  Id,
  RequestEnvelope,
  ResponseEnvelope,
  Runtime,
  Session,
  SessionStatus,
  StringMap,
  SuccessResponseEnvelope
} from "../models/types.js";

export const ASCP_CORE_METHOD_NAMES = [
  "capabilities.get",
  "hosts.get",
  "runtimes.list",
  "sessions.list",
  "sessions.get",
  "sessions.start",
  "sessions.resume",
  "sessions.stop",
  "sessions.send_input",
  "sessions.subscribe",
  "sessions.unsubscribe",
  "approvals.list",
  "approvals.respond",
  "artifacts.list",
  "artifacts.get",
  "diffs.get"
] as const;

export type CoreMethodName = (typeof ASCP_CORE_METHOD_NAMES)[number];
export type Cursor = string;
export type NullableCursor = Cursor | null;
export type InputKind = "text" | "instruction" | "reply" | "control";
export type StopMode = "graceful" | "force";
export type ApprovalDecision = "approved" | "rejected";

export type CapabilitiesGetParams = FlexibleObject;
export type HostsGetParams = FlexibleObject;

export interface RuntimesListParams extends FlexibleObject {
  kind?: string;
  adapter_kind?: "native" | "wrapper" | "pty";
}

export interface SessionsListParams extends FlexibleObject {
  runtime_id?: Id;
  status?: SessionStatus;
  workspace?: string;
  updated_after?: string;
  search_text?: string;
  limit?: number;
  cursor?: Cursor;
}

export interface SessionsGetParams extends FlexibleObject {
  session_id: Id;
  include_runs?: boolean;
  include_pending_approvals?: boolean;
}

export interface SessionsStartParams extends FlexibleObject {
  runtime_id: Id;
  workspace?: string;
  title?: string;
  initial_prompt?: string;
  metadata?: StringMap;
}

export interface SessionsResumeParams extends FlexibleObject {
  session_id: Id;
  runtime_id?: Id;
}

export interface SessionsStopParams extends FlexibleObject {
  session_id: Id;
  mode?: StopMode;
  reason?: string;
}

export interface SessionsSendInputParams extends FlexibleObject {
  session_id: Id;
  input: string;
  input_kind?: InputKind;
  metadata?: FlexibleObject;
}

export interface SessionsSubscribeParams extends FlexibleObject {
  session_id: Id;
  from_seq?: number;
  from_event_id?: Id;
  cursor?: Cursor;
  include_snapshot?: boolean;
}

export interface SessionsUnsubscribeParams extends FlexibleObject {
  subscription_id: Id;
}

export interface ApprovalsListParams extends FlexibleObject {
  session_id?: Id;
  status?: ApprovalStatus;
  limit?: number;
  cursor?: Cursor;
}

export interface ApprovalsRespondParams extends FlexibleObject {
  approval_id: Id;
  decision: ApprovalDecision;
  note?: string;
}

export interface ArtifactsListParams extends FlexibleObject {
  session_id: Id;
  run_id?: Id;
  kind?: ArtifactKind;
}

export interface ArtifactsGetParams extends FlexibleObject {
  artifact_id: Id;
}

export interface DiffsGetParams extends FlexibleObject {
  session_id: Id;
  run_id: Id;
}

export type CapabilitiesGetResult = CapabilityDocument;

export interface HostsGetResult extends FlexibleObject {
  host: Host;
}

export interface RuntimesListResult extends FlexibleObject {
  runtimes: Runtime[];
}

export interface SessionsListResult extends FlexibleObject {
  sessions: Session[];
  next_cursor?: NullableCursor;
}

export interface SessionsGetResult extends FlexibleObject {
  session: Session;
  runs?: Array<Record<string, unknown>>;
  pending_approvals?: ApprovalRequest[];
}

export interface SessionsStartResult extends FlexibleObject {
  session: Session;
}

export interface SessionsResumeResult extends FlexibleObject {
  session: Session;
  replay_supported?: boolean;
  snapshot_emitted?: boolean;
}

export interface SessionsStopResult extends FlexibleObject {
  session_id: Id;
  status: SessionStatus;
}

export interface SessionsSendInputResult extends FlexibleObject {
  session_id: Id;
  accepted: boolean;
}

export interface SessionsSubscribeResult extends FlexibleObject {
  session_id: Id;
  subscription_id: Id;
  snapshot_emitted?: boolean;
}

export interface SessionsUnsubscribeResult extends FlexibleObject {
  subscription_id: Id;
  unsubscribed: boolean;
}

export interface ApprovalsListResult extends FlexibleObject {
  approvals: ApprovalRequest[];
  next_cursor?: NullableCursor;
}

export interface ApprovalsRespondResult extends FlexibleObject {
  approval_id: Id;
  status: ApprovalStatus;
}

export interface ArtifactsListResult extends FlexibleObject {
  artifacts: Artifact[];
}

export interface ArtifactsGetResult extends FlexibleObject {
  artifact: Artifact;
}

export interface DiffsGetResult extends FlexibleObject {
  diff: DiffSummary;
}

export type CoreMethodRequestEnvelope<
  TMethod extends CoreMethodName,
  TParams extends FlexibleObject
> = RequestEnvelope<TParams> & { method: TMethod };

export type CoreMethodResponseEnvelope<TResult extends FlexibleObject> =
  ResponseEnvelope<TResult>;

export type CapabilitiesGetRequest = CoreMethodRequestEnvelope<
  "capabilities.get",
  CapabilitiesGetParams
>;
export type CapabilitiesGetResponse =
  CoreMethodResponseEnvelope<CapabilitiesGetResult>;

export type SessionsListRequest = CoreMethodRequestEnvelope<
  "sessions.list",
  SessionsListParams
>;
export type SessionsListResponse = SuccessResponseEnvelope<SessionsListResult>;
