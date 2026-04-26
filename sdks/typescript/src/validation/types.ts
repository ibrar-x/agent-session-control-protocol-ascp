import type { CoreEventEnvelope, CoreEventType } from "../events/types.js";
import type { ErrorObject } from "../errors/types.js";
import type {
  ApprovalsListResult,
  ApprovalsRespondResult,
  ArtifactsGetResult,
  ArtifactsListResult,
  CapabilitiesGetResult,
  CoreMethodName,
  DiffsGetResult,
  HostsGetResult,
  RuntimesListResult,
  SessionsGetResult,
  SessionsListResult,
  SessionsResumeResult,
  SessionsSendInputResult,
  SessionsStartResult,
  SessionsStopResult,
  SessionsSubscribeResult,
  SessionsUnsubscribeResult
} from "../methods/types.js";
import type {
  ApprovalRequest,
  Artifact,
  Capabilities,
  CapabilityDocument,
  DiffSummary,
  ErrorResponseEnvelope,
  EventEnvelope,
  Host,
  InputRequest,
  ResponseEnvelope,
  Run,
  Session,
  SuccessResponseEnvelope,
  Runtime
} from "../models/types.js";

export type CoreEntityName =
  | "Capabilities"
  | "CapabilityDocument"
  | "Host"
  | "Runtime"
  | "Session"
  | "Run"
  | "ApprovalRequest"
  | "InputRequest"
  | "Artifact"
  | "DiffSummary"
  | "EventEnvelope"
  | "ErrorObject";

export interface CoreEntityMap {
  Capabilities: Capabilities;
  CapabilityDocument: CapabilityDocument;
  Host: Host;
  Runtime: Runtime;
  Session: Session;
  Run: Run;
  ApprovalRequest: ApprovalRequest;
  InputRequest: InputRequest;
  Artifact: Artifact;
  DiffSummary: DiffSummary;
  EventEnvelope: EventEnvelope;
  ErrorObject: ErrorObject;
}

export interface CoreMethodSuccessResultMap {
  "capabilities.get": CapabilitiesGetResult;
  "hosts.get": HostsGetResult;
  "runtimes.list": RuntimesListResult;
  "sessions.list": SessionsListResult;
  "sessions.get": SessionsGetResult;
  "sessions.start": SessionsStartResult;
  "sessions.resume": SessionsResumeResult;
  "sessions.stop": SessionsStopResult;
  "sessions.send_input": SessionsSendInputResult;
  "sessions.subscribe": SessionsSubscribeResult;
  "sessions.unsubscribe": SessionsUnsubscribeResult;
  "approvals.list": ApprovalsListResult;
  "approvals.respond": ApprovalsRespondResult;
  "artifacts.list": ArtifactsListResult;
  "artifacts.get": ArtifactsGetResult;
  "diffs.get": DiffsGetResult;
}

export type CoreMethodSuccessResponse<
  TMethod extends CoreMethodName = CoreMethodName
> = SuccessResponseEnvelope<CoreMethodSuccessResultMap[TMethod]>;

export type CoreMethodResponseMap = {
  [TMethod in CoreMethodName]:
    | CoreMethodSuccessResponse<TMethod>
    | ErrorResponseEnvelope;
};

export type CoreMethodResponse<
  TMethod extends CoreMethodName = CoreMethodName
> = CoreMethodResponseMap[TMethod];

export interface ValidationIssue {
  keyword: string;
  path: string;
  schemaPath: string;
  message: string;
  params: Record<string, unknown>;
}

export class AscpValidationError extends Error {
  readonly target: string;
  readonly issues: ValidationIssue[];

  constructor(target: string, issues: ValidationIssue[], message?: string) {
    super(message ?? `ASCP validation failed for ${target}.`);
    this.name = "AscpValidationError";
    this.target = target;
    this.issues = issues;
  }
}

export interface ValidationSuccess<T> {
  success: true;
  data: T;
}

export interface ValidationFailure {
  success: false;
  error: AscpValidationError;
}

export type ValidationResult<T> = ValidationSuccess<T> | ValidationFailure;

export type CoreEventEnvelopeResult<
  TEvent extends CoreEventType = CoreEventType
> = Extract<CoreEventEnvelope, { type: TEvent }>;

export type AnyMethodResponse = ResponseEnvelope<Record<string, unknown>>;
