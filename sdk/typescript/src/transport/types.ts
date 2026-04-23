import type { CoreMethodName } from "../methods/types.js";
import type {
  ApprovalsListParams,
  ApprovalsRespondParams,
  ArtifactsGetParams,
  ArtifactsListParams,
  CapabilitiesGetParams,
  DiffsGetParams,
  HostsGetParams,
  RuntimesListParams,
  SessionsGetParams,
  SessionsListParams,
  SessionsResumeParams,
  SessionsSendInputParams,
  SessionsStartParams,
  SessionsStopParams,
  SessionsSubscribeParams,
  SessionsUnsubscribeParams
} from "../methods/types.js";
import type { EventEnvelope } from "../models/types.js";
import type { CoreMethodResponse } from "../validation/types.js";

export interface CoreMethodParamsMap {
  "capabilities.get": CapabilitiesGetParams;
  "hosts.get": HostsGetParams;
  "runtimes.list": RuntimesListParams;
  "sessions.list": SessionsListParams;
  "sessions.get": SessionsGetParams;
  "sessions.start": SessionsStartParams;
  "sessions.resume": SessionsResumeParams;
  "sessions.stop": SessionsStopParams;
  "sessions.send_input": SessionsSendInputParams;
  "sessions.subscribe": SessionsSubscribeParams;
  "sessions.unsubscribe": SessionsUnsubscribeParams;
  "approvals.list": ApprovalsListParams;
  "approvals.respond": ApprovalsRespondParams;
  "artifacts.list": ArtifactsListParams;
  "artifacts.get": ArtifactsGetParams;
  "diffs.get": DiffsGetParams;
}

export interface AscpTransportRequestOptions {
  signal?: AbortSignal;
  timeoutMs?: number;
}

export interface AscpTransportSubscription extends AsyncIterable<EventEnvelope> {
  close(): Promise<void>;
}

export interface AscpTransport {
  readonly kind: string;
  connect(): Promise<void>;
  close(): Promise<void>;
  request<TMethod extends CoreMethodName>(
    method: TMethod,
    params?: CoreMethodParamsMap[TMethod],
    options?: AscpTransportRequestOptions
  ): Promise<CoreMethodResponse<TMethod>>;
  subscribe(): AscpTransportSubscription;
}
