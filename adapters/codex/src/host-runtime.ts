import { arch, hostname, platform } from "node:os";

import type {
  ApprovalsListParams,
  ApprovalsListResult,
  ApprovalsRespondParams,
  ApprovalsRespondResult,
  ArtifactsGetParams,
  ArtifactsGetResult,
  ArtifactsListParams,
  ArtifactsListResult,
  Capabilities,
  CapabilitiesGetResult,
  DiffsGetParams,
  DiffsGetResult,
  HostsGetResult,
  RuntimesListParams,
  RuntimesListResult,
  SessionsGetParams,
  SessionsGetResult,
  SessionsListParams,
  SessionsListResult,
  SessionsStartParams,
  SessionsStartResult,
  SessionsResumeParams,
  SessionsResumeResult,
  SessionsSendInputParams,
  SessionsSendInputResult,
  SessionsSubscribeParams,
  SessionsSubscribeResult,
  SessionsUnsubscribeParams,
  SessionsUnsubscribeResult
} from "ascp-sdk-typescript";
import type { AscpHostRuntime } from "@ascp/host-service";

import { CodexAppServerClient } from "./app-server-client.js";
import { resolveCodexCapabilities } from "./capabilities.js";
import { CODEX_RUNTIME_ID, discoverCodexRuntime, type CodexDiscoveryClient } from "./discovery.js";
import type { CodexServiceClient } from "./service.js";
import { CodexAdapterService } from "./service.js";

const LOCAL_HOST_ID = `host:${hostname()}`;
const HOST_TRANSPORTS = ["websocket"] as const;
const HOST_PROTOCOL_VERSION = "0.1.0";
const CODEX_RUNTIME_KIND = "codex";
const CODEX_ADAPTER_KIND = "wrapper" as const;

function matchesRuntimeFilter(params: RuntimesListParams | undefined): boolean {
  if (params?.kind !== undefined && params.kind !== CODEX_RUNTIME_KIND) {
    return false;
  }

  if (params?.adapter_kind !== undefined && params.adapter_kind !== CODEX_ADAPTER_KIND) {
    return false;
  }

  return true;
}

export class CodexHostRuntime implements AscpHostRuntime {
  private readonly service: CodexAdapterService;
  private readonly discoveryClient: CodexDiscoveryClient;

  constructor(client: CodexServiceClient & CodexDiscoveryClient) {
    this.discoveryClient = client;
    this.service = new CodexAdapterService(client);
  }

  async capabilitiesGet(): Promise<CapabilitiesGetResult> {
    const discovery = await discoverCodexRuntime(this.discoveryClient);
    const capabilities = resolveCodexCapabilities(discovery) as Capabilities;
    const runtimes = discovery.runtimeAvailable
      ? [
          {
            id: discovery.runtimeId,
            kind: CODEX_RUNTIME_KIND,
            display_name: "Codex",
            version: discovery.version ?? "unknown",
            adapter_kind: CODEX_ADAPTER_KIND,
            capabilities
          }
        ]
      : [];

    return {
      protocol_version: HOST_PROTOCOL_VERSION,
      host: this.buildHost(),
      runtimes,
      transports: [...HOST_TRANSPORTS],
      capabilities
    };
  }

  async hostsGet(): Promise<HostsGetResult> {
    return {
      host: this.buildHost()
    };
  }

  async runtimesList(params?: RuntimesListParams): Promise<RuntimesListResult> {
    const capabilityDocument = await this.capabilitiesGet();

    return {
      runtimes: matchesRuntimeFilter(params) ? capabilityDocument.runtimes : []
    };
  }

  sessionsList(params?: SessionsListParams): Promise<SessionsListResult> {
    return this.service.sessionsList(params);
  }

  sessionsStart(params: SessionsStartParams): Promise<SessionsStartResult> {
    return this.service.sessionsStart(params);
  }

  sessionsGet(params: SessionsGetParams): Promise<SessionsGetResult> {
    return this.service.sessionsGet(params);
  }

  sessionsResume(params: SessionsResumeParams): Promise<SessionsResumeResult> {
    return this.service.sessionsResume(params);
  }

  sessionsSendInput(params: SessionsSendInputParams): Promise<SessionsSendInputResult> {
    return this.service.sessionsSendInput(params);
  }

  sessionsSubscribe(params: SessionsSubscribeParams): Promise<SessionsSubscribeResult> {
    return this.service.sessionsSubscribe(params);
  }

  sessionsUnsubscribe(params: SessionsUnsubscribeParams): Promise<SessionsUnsubscribeResult> {
    return this.service.sessionsUnsubscribe(params);
  }

  approvalsList(params?: ApprovalsListParams): Promise<ApprovalsListResult> {
    return this.service.approvalsList(params);
  }

  approvalsRespond(params: ApprovalsRespondParams): Promise<ApprovalsRespondResult> {
    return this.service.approvalsRespond(params);
  }

  artifactsList(params: ArtifactsListParams): Promise<ArtifactsListResult> {
    return this.service.artifactsList(params);
  }

  artifactsGet(params: ArtifactsGetParams): Promise<ArtifactsGetResult> {
    return this.service.artifactsGet(params);
  }

  diffsGet(params: DiffsGetParams): Promise<DiffsGetResult> {
    return this.service.diffsGet(params);
  }

  drainSubscriptionEvents(subscriptionId: string, limit?: number) {
    return this.service.drainSubscriptionEvents(subscriptionId, limit);
  }

  onEvent(listener: Parameters<NonNullable<AscpHostRuntime["onEvent"]>>[0]): () => void {
    return this.service.onEvent(listener);
  }

  close(): void {
    this.service.close();
  }

  private buildHost(): HostsGetResult["host"] {
    return {
      id: LOCAL_HOST_ID,
      name: "Local ASCP Host",
      platform: platform(),
      arch: arch(),
      status: "online",
      transports: [...HOST_TRANSPORTS],
      labels: {
        source: "codex"
      }
    };
  }
}

export function createCodexHostRuntime(
  client: CodexServiceClient & CodexDiscoveryClient
): CodexHostRuntime {
  return new CodexHostRuntime(client);
}

export function createDefaultCodexHostRuntime(
  client: CodexServiceClient & CodexDiscoveryClient = new CodexAppServerClient()
): CodexHostRuntime {
  return createCodexHostRuntime(client);
}
