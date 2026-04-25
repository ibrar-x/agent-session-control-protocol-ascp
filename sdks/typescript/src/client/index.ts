import type { ErrorCode, ErrorObject } from "../errors/index.js";
import type {
  ApprovalsListParams,
  ApprovalsRespondParams,
  ArtifactsGetParams,
  ArtifactsListParams,
  CapabilitiesGetResult,
  DiffsGetParams,
  HostsGetResult,
  RuntimesListParams,
  RuntimesListResult,
  SessionsGetParams,
  SessionsGetResult,
  SessionsListParams,
  SessionsListResult,
  SessionsResumeParams,
  SessionsResumeResult,
  SessionsSendInputParams,
  SessionsSendInputResult,
  SessionsStartParams,
  SessionsStartResult,
  SessionsStopParams,
  SessionsStopResult,
  SessionsSubscribeParams,
  SessionsSubscribeResult,
  SessionsUnsubscribeParams,
  SessionsUnsubscribeResult,
  ApprovalsListResult,
  ApprovalsRespondResult,
  ArtifactsListResult,
  ArtifactsGetResult,
  DiffsGetResult,
  CoreMethodName
} from "../methods/index.js";
import type { ErrorResponseEnvelope } from "../models/index.js";
import type {
  AscpTransport,
  AscpTransportRequestOptions,
  AscpTransportSubscription,
  CoreMethodParamsMap
} from "../transport/index.js";
import type {
  CoreMethodSuccessResultMap
} from "../validation/index.js";

export type AscpClientRequestOptions = AscpTransportRequestOptions;

export interface AscpClientOptions {
  transport: AscpTransport;
}

export interface AscpProtocolErrorOptions<TMethod extends CoreMethodName> {
  method: TMethod;
  response: ErrorResponseEnvelope;
}

export class AscpProtocolError<
  TMethod extends CoreMethodName = CoreMethodName
> extends Error {
  readonly method: TMethod;
  readonly response: ErrorResponseEnvelope;
  readonly errorObject: ErrorObject;
  readonly code: ErrorCode;
  readonly retryable: boolean;
  readonly correlationId: string | undefined;

  constructor(options: AscpProtocolErrorOptions<TMethod>) {
    super(options.response.error.message);
    this.name = "AscpProtocolError";
    this.method = options.method;
    this.response = options.response;
    this.errorObject = options.response.error;
    this.code = options.response.error.code;
    this.retryable = options.response.error.retryable;
    this.correlationId = options.response.error.correlation_id;
  }
}

export function createAscpClient(options: AscpClientOptions): AscpClient {
  return new AscpClient(options);
}

export function defineAscpParams<TParams extends Record<string, unknown>>(
  params: TParams
): TParams {
  return params;
}

export class AscpClient {
  readonly transport: AscpTransport;

  constructor(options: AscpClientOptions) {
    this.transport = options.transport;
  }

  connect(): Promise<void> {
    return this.transport.connect();
  }

  close(): Promise<void> {
    return this.transport.close();
  }

  events(): AscpTransportSubscription {
    return this.transport.subscribe();
  }

  getCapabilities(
    options?: AscpClientRequestOptions
  ): Promise<CapabilitiesGetResult> {
    return this.request("capabilities.get", undefined, options);
  }

  getHost(options?: AscpClientRequestOptions): Promise<HostsGetResult> {
    return this.request("hosts.get", undefined, options);
  }

  listRuntimes(
    params?: RuntimesListParams,
    options?: AscpClientRequestOptions
  ): Promise<RuntimesListResult> {
    return this.request("runtimes.list", params, options);
  }

  listSessions(
    params?: SessionsListParams,
    options?: AscpClientRequestOptions
  ): Promise<SessionsListResult> {
    return this.request("sessions.list", params, options);
  }

  getSession(
    params: SessionsGetParams,
    options?: AscpClientRequestOptions
  ): Promise<SessionsGetResult> {
    return this.request("sessions.get", params, options);
  }

  startSession(
    params: SessionsStartParams,
    options?: AscpClientRequestOptions
  ): Promise<SessionsStartResult> {
    return this.request("sessions.start", params, options);
  }

  resumeSession(
    params: SessionsResumeParams,
    options?: AscpClientRequestOptions
  ): Promise<SessionsResumeResult> {
    return this.request("sessions.resume", params, options);
  }

  stopSession(
    params: SessionsStopParams,
    options?: AscpClientRequestOptions
  ): Promise<SessionsStopResult> {
    return this.request("sessions.stop", params, options);
  }

  sendInput(
    params: SessionsSendInputParams,
    options?: AscpClientRequestOptions
  ): Promise<SessionsSendInputResult> {
    return this.request("sessions.send_input", params, options);
  }

  subscribe(
    params: SessionsSubscribeParams,
    options?: AscpClientRequestOptions
  ): Promise<SessionsSubscribeResult> {
    return this.request("sessions.subscribe", params, options);
  }

  unsubscribe(
    params: SessionsUnsubscribeParams,
    options?: AscpClientRequestOptions
  ): Promise<SessionsUnsubscribeResult> {
    return this.request("sessions.unsubscribe", params, options);
  }

  listApprovals(
    params?: ApprovalsListParams,
    options?: AscpClientRequestOptions
  ): Promise<ApprovalsListResult> {
    return this.request("approvals.list", params, options);
  }

  respondApproval(
    params: ApprovalsRespondParams,
    options?: AscpClientRequestOptions
  ): Promise<ApprovalsRespondResult> {
    return this.request("approvals.respond", params, options);
  }

  listArtifacts(
    params: ArtifactsListParams,
    options?: AscpClientRequestOptions
  ): Promise<ArtifactsListResult> {
    return this.request("artifacts.list", params, options);
  }

  getArtifact(
    params: ArtifactsGetParams,
    options?: AscpClientRequestOptions
  ): Promise<ArtifactsGetResult> {
    return this.request("artifacts.get", params, options);
  }

  getDiff(
    params: DiffsGetParams,
    options?: AscpClientRequestOptions
  ): Promise<DiffsGetResult> {
    return this.request("diffs.get", params, options);
  }

  private async request<TMethod extends CoreMethodName>(
    method: TMethod,
    params: CoreMethodParamsMap[TMethod] | undefined,
    options: AscpClientRequestOptions | undefined
  ): Promise<CoreMethodSuccessResultMap[TMethod]> {
    const response = await this.transport.request(method, params, options);

    if ("error" in response) {
      throw new AscpProtocolError({
        method,
        response: response as ErrorResponseEnvelope
      });
    }

    return response.result;
  }
}
