import type { ErrorObject } from "../errors/types.js";

export type Id = string;
export type RequestId = string | number;
export type TimestampUtc = string;
export type StringMapValue = string | number | boolean | null;
export type StringMap = Record<string, StringMapValue>;
export type FlexibleObject = Record<string, unknown>;

export const ASCP_TRANSPORTS = [
  "websocket",
  "http_sse",
  "unix_socket",
  "named_pipe",
  "stdio",
  "relay"
] as const;

export type Transport = (typeof ASCP_TRANSPORTS)[number];
export type HostStatus = "online" | "offline" | "degraded" | "unknown";
export type AdapterKind = "native" | "wrapper" | "pty";

export interface Capabilities {
  session_list?: boolean;
  session_resume?: boolean;
  session_start?: boolean;
  session_stop?: boolean;
  stream_events?: boolean;
  transcript_read?: boolean;
  message_send?: boolean;
  approval_requests?: boolean;
  approval_respond?: boolean;
  artifacts?: boolean;
  diffs?: boolean;
  terminal_passthrough?: boolean;
  notifications?: boolean;
  checkpoints?: boolean;
  replay?: boolean;
  multi_workspace?: boolean;
  [key: string]: unknown;
}

export interface Host {
  id: Id;
  name: string;
  platform?: string;
  arch?: string;
  labels?: StringMap;
  status?: HostStatus;
  transports?: Transport[];
  [key: string]: unknown;
}

export interface Runtime {
  id: Id;
  kind: string;
  display_name: string;
  version: string;
  adapter_kind?: AdapterKind;
  capabilities?: Capabilities;
  [key: string]: unknown;
}

export interface CapabilityDocument {
  protocol_version: string;
  host: Host;
  runtimes: Runtime[];
  transports: Transport[];
  capabilities: Capabilities;
  extensions?: string[];
  [key: string]: unknown;
}

export const ASCP_SESSION_STATUSES = [
  "idle",
  "running",
  "waiting_input",
  "waiting_approval",
  "completed",
  "failed",
  "stopped",
  "disconnected"
] as const;

export type SessionStatus = (typeof ASCP_SESSION_STATUSES)[number];

export interface Session {
  id: Id;
  runtime_id: Id;
  status: SessionStatus;
  created_at: TimestampUtc;
  updated_at: TimestampUtc;
  title?: string;
  workspace?: string;
  last_activity_at?: TimestampUtc;
  summary?: string;
  active_run_id?: Id;
  metadata?: StringMap;
  [key: string]: unknown;
}

export const ASCP_RUN_STATUSES = [
  "starting",
  "running",
  "paused",
  "completed",
  "failed",
  "cancelled"
] as const;

export type RunStatus = (typeof ASCP_RUN_STATUSES)[number];

export interface Run {
  id: Id;
  session_id: Id;
  status: RunStatus;
  started_at: TimestampUtc;
  ended_at?: TimestampUtc | null;
  exit_code?: number | null;
  [key: string]: unknown;
}

export const ASCP_APPROVAL_KINDS = [
  "command",
  "file_write",
  "network",
  "tool",
  "generic"
] as const;

export const ASCP_APPROVAL_STATUSES = [
  "pending",
  "approved",
  "rejected",
  "expired",
  "cancelled"
] as const;

export const ASCP_RISK_LEVELS = ["low", "medium", "high", "critical"] as const;

export type ApprovalKind = (typeof ASCP_APPROVAL_KINDS)[number];
export type ApprovalStatus = (typeof ASCP_APPROVAL_STATUSES)[number];
export type RiskLevel = (typeof ASCP_RISK_LEVELS)[number];

export interface ApprovalRequest {
  id: Id;
  session_id: Id;
  kind: ApprovalKind;
  status: ApprovalStatus;
  created_at: TimestampUtc;
  run_id?: Id;
  title?: string;
  description?: string;
  risk_level?: RiskLevel;
  payload?: FlexibleObject;
  resolved_at?: TimestampUtc | null;
  [key: string]: unknown;
}

export const ASCP_ARTIFACT_KINDS = [
  "file",
  "diff",
  "patch",
  "image",
  "log",
  "report",
  "other"
] as const;

export type ArtifactKind = (typeof ASCP_ARTIFACT_KINDS)[number];

export interface Artifact {
  id: Id;
  session_id: Id;
  kind: ArtifactKind;
  created_at: TimestampUtc;
  run_id?: Id;
  name?: string;
  uri?: string;
  mime_type?: string;
  size_bytes?: number;
  metadata?: StringMap;
  [key: string]: unknown;
}

export const ASCP_DIFF_CHANGE_TYPES = [
  "added",
  "modified",
  "deleted",
  "renamed"
] as const;

export type DiffChangeType = (typeof ASCP_DIFF_CHANGE_TYPES)[number];

export interface DiffFile {
  path: string;
  change_type: DiffChangeType;
  insertions?: number;
  deletions?: number;
  [key: string]: unknown;
}

export interface DiffSummary {
  session_id: Id;
  files_changed: number;
  run_id?: Id;
  insertions?: number;
  deletions?: number;
  files?: DiffFile[];
  [key: string]: unknown;
}

export interface EventEnvelope<TPayload extends FlexibleObject = FlexibleObject> {
  id: Id;
  type: string;
  ts: TimestampUtc;
  session_id: Id;
  payload: TPayload;
  run_id?: Id;
  seq?: number;
  [key: string]: unknown;
}

export interface RequestEnvelope<TParams extends FlexibleObject = FlexibleObject> {
  jsonrpc: "2.0";
  method: string;
  id?: RequestId;
  params?: TParams;
  [key: string]: unknown;
}

export interface SuccessResponseEnvelope<TResult extends FlexibleObject = FlexibleObject> {
  jsonrpc: "2.0";
  id: RequestId;
  result: TResult;
  [key: string]: unknown;
}

export interface ErrorResponseEnvelope {
  jsonrpc: "2.0";
  id: RequestId;
  error: ErrorObject;
  [key: string]: unknown;
}

export type ResponseEnvelope<TResult extends FlexibleObject = FlexibleObject> =
  | SuccessResponseEnvelope<TResult>
  | ErrorResponseEnvelope;
