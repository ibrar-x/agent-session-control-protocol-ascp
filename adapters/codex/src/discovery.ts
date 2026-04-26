import type {
  CodexAppServerInitializeResult,
  CodexObservedSurface
} from "./app-server-client.js";

export const CODEX_RUNTIME_ID = "codex_local";

export const VERIFIED_CODEX_APP_SERVER_METHODS = [
  "initialize",
  "thread/list",
  "thread/read",
  "thread/start",
  "thread/resume",
  "turn/start",
  "turn/steer"
] as const;

export const VERIFIED_CODEX_APP_SERVER_NOTIFICATIONS = [
  "thread/started",
  "thread/status/changed",
  "turn/started",
  "turn/completed",
  "turn/diff/updated"
] as const;

export interface CodexDiscovery {
  runtimeAvailable: boolean;
  runtimeId: typeof CODEX_RUNTIME_ID;
  version: string | null;
  appServerMethods: string[];
  notifications: string[];
  supportsApprovalRequests: boolean;
  supportsApprovalRespond: boolean;
  supportsTurnDiffs: boolean;
}

export interface CodexDiscoveryClient {
  initialize(): Promise<CodexAppServerInitializeResult>;
  getObservedSurface?(): CodexObservedSurface;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function normalizeValues(values?: Iterable<string>): string[] {
  if (values === undefined) {
    return [];
  }

  const normalized = new Set<string>();

  for (const value of values) {
    if (typeof value === "string" && value.length > 0) {
      normalized.add(value);
    }
  }

  return [...normalized];
}

export function extractCodexVersion(initializeResult?: CodexAppServerInitializeResult | null): string | null {
  if (initializeResult === undefined || initializeResult === null) {
    return null;
  }

  if (
    isRecord(initializeResult.serverInfo) &&
    typeof initializeResult.serverInfo.version === "string" &&
    initializeResult.serverInfo.version.length > 0
  ) {
    return initializeResult.serverInfo.version;
  }

  const candidates = [
    initializeResult.userAgent,
    isRecord(initializeResult.serverInfo) ? initializeResult.serverInfo.userAgent : undefined
  ];

  for (const candidate of candidates) {
    if (typeof candidate !== "string") {
      continue;
    }

    const match = candidate.match(/(\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?)/);

    if (match?.[1] !== undefined) {
      return match[1];
    }
  }

  return null;
}

export function buildCodexDiscovery(options: {
  initializeResult?: CodexAppServerInitializeResult | null;
  observedSurface?: CodexObservedSurface;
  runtimeAvailable?: boolean;
}): CodexDiscovery {
  const runtimeAvailable = options.runtimeAvailable ?? true;

  if (!runtimeAvailable) {
    return {
      runtimeAvailable: false,
      runtimeId: CODEX_RUNTIME_ID,
      version: null,
      appServerMethods: [],
      notifications: [],
      supportsApprovalRequests: false,
      supportsApprovalRespond: false,
      supportsTurnDiffs: false
    };
  }

  const appServerMethods = normalizeValues(options.observedSurface?.methods);
  const notifications = normalizeValues(options.observedSurface?.notifications);
  const supportsApprovalRequests = options.observedSurface?.approvalRequestsObserved ?? false;
  const supportsApprovalRespond =
    supportsApprovalRequests && (options.observedSurface?.approvalRespondSupported ?? false);

  return {
    runtimeAvailable: true,
    runtimeId: CODEX_RUNTIME_ID,
    version: extractCodexVersion(options.initializeResult),
    appServerMethods,
    notifications,
    supportsApprovalRequests,
    supportsApprovalRespond,
    supportsTurnDiffs: notifications.includes("turn/diff/updated")
  };
}

export async function discoverCodexRuntime(
  client: CodexDiscoveryClient,
  observedSurface?: CodexObservedSurface
): Promise<CodexDiscovery> {
  try {
    const initializeResult = await client.initialize();
    const effectiveObservedSurface = observedSurface ?? client.getObservedSurface?.() ?? {};

    return buildCodexDiscovery({
      initializeResult,
      observedSurface: effectiveObservedSurface,
      runtimeAvailable: true
    });
  } catch {
    return buildCodexDiscovery({
      runtimeAvailable: false
    });
  }
}
