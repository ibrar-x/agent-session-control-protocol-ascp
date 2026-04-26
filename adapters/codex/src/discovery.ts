import type {
  CodexAppServerInitializeResult,
  CodexObservedSurface
} from "./app-server-client.js";
export type { CodexObservedSurface } from "./app-server-client.js";

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

export const VERIFIED_CODEX_APPROVAL_REQUESTS = true;
export const VERIFIED_CODEX_APPROVAL_RESPOND = false;
export const VERIFIED_CODEX_DIFF_READS = false;

export interface CodexDiscovery {
  runtimeAvailable: boolean;
  runtimeId: typeof CODEX_RUNTIME_ID;
  version: string | null;
  verifiedAppServerMethods: string[];
  observedAppServerMethods: string[];
  appServerMethods: string[];
  verifiedNotifications: string[];
  observedNotifications: string[];
  notifications: string[];
  supportsApprovalRequests: boolean;
  supportsApprovalRespond: boolean;
  supportsDiffReads: boolean;
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

function selectObservedValues(
  liveValues: string[],
  fallbackValues: string[]
): string[] {
  if (liveValues.length > 0) {
    return liveValues;
  }

  return fallbackValues;
}

function hasObservedSurfaceEvidence(surface: CodexObservedSurface): boolean {
  return (
    normalizeValues(surface.methods).length > 0 ||
    normalizeValues(surface.notifications).length > 0 ||
    surface.approvalRequestsObserved !== undefined ||
    surface.approvalRespondSupported !== undefined ||
    surface.diffReadSupported !== undefined
  );
}

function mergeVerifiedWithObserved(verifiedValues: readonly string[], observedValues: string[]): string[] {
  const merged = new Set<string>(verifiedValues);

  for (const observedValue of observedValues) {
    merged.add(observedValue);
  }

  return [...merged];
}

function resolveObservedBoolean(
  liveValue: boolean | undefined,
  fallbackValue: boolean | undefined,
  verifiedValue: boolean
): boolean {
  if (liveValue !== undefined) {
    return liveValue;
  }

  if (fallbackValue !== undefined) {
    return fallbackValue;
  }

  return verifiedValue;
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
  liveObservedSurface?: CodexObservedSurface;
  fallbackObservedSurface?: CodexObservedSurface;
  runtimeAvailable?: boolean;
}): CodexDiscovery {
  const runtimeAvailable = options.runtimeAvailable ?? true;
  const verifiedAppServerMethods = [...VERIFIED_CODEX_APP_SERVER_METHODS];
  const verifiedNotifications = [...VERIFIED_CODEX_APP_SERVER_NOTIFICATIONS];
  const liveObservedSurface = options.liveObservedSurface ?? {};
  const fallbackObservedSurface =
    hasObservedSurfaceEvidence(liveObservedSurface) ? {} : (options.fallbackObservedSurface ?? {});
  const observedAppServerMethods = selectObservedValues(
    normalizeValues(liveObservedSurface.methods),
    normalizeValues(fallbackObservedSurface.methods)
  );
  const observedNotifications = selectObservedValues(
    normalizeValues(liveObservedSurface.notifications),
    normalizeValues(fallbackObservedSurface.notifications)
  );

  if (!runtimeAvailable) {
    return {
      runtimeAvailable: false,
      runtimeId: CODEX_RUNTIME_ID,
      version: null,
      verifiedAppServerMethods,
      observedAppServerMethods: [],
      appServerMethods: [],
      verifiedNotifications,
      observedNotifications: [],
      notifications: [],
      supportsApprovalRequests: false,
      supportsApprovalRespond: false,
      supportsDiffReads: false
    };
  }

  const appServerMethods = mergeVerifiedWithObserved(
    VERIFIED_CODEX_APP_SERVER_METHODS,
    observedAppServerMethods
  );
  const notifications = mergeVerifiedWithObserved(
    VERIFIED_CODEX_APP_SERVER_NOTIFICATIONS,
    observedNotifications
  );
  const supportsApprovalRequests = resolveObservedBoolean(
    liveObservedSurface.approvalRequestsObserved,
    fallbackObservedSurface.approvalRequestsObserved,
    VERIFIED_CODEX_APPROVAL_REQUESTS
  );
  const supportsApprovalRespond =
    supportsApprovalRequests &&
    resolveObservedBoolean(
      liveObservedSurface.approvalRespondSupported,
      fallbackObservedSurface.approvalRespondSupported,
      VERIFIED_CODEX_APPROVAL_RESPOND
    );
  const supportsDiffReads = resolveObservedBoolean(
    liveObservedSurface.diffReadSupported,
    fallbackObservedSurface.diffReadSupported,
    VERIFIED_CODEX_DIFF_READS
  );

  return {
    runtimeAvailable: true,
    runtimeId: CODEX_RUNTIME_ID,
    version: extractCodexVersion(options.initializeResult),
    verifiedAppServerMethods,
    observedAppServerMethods,
    appServerMethods,
    verifiedNotifications,
    observedNotifications,
    notifications,
    supportsApprovalRequests,
    supportsApprovalRespond,
    supportsDiffReads
  };
}

export async function discoverCodexRuntime(
  client: CodexDiscoveryClient,
  observedSurface?: CodexObservedSurface
): Promise<CodexDiscovery> {
  try {
    const initializeResult = await client.initialize();
    const liveObservedSurface = client.getObservedSurface?.() ?? {};

    return buildCodexDiscovery({
      initializeResult,
      liveObservedSurface,
      fallbackObservedSurface: observedSurface,
      runtimeAvailable: true
    });
  } catch {
    return buildCodexDiscovery({
      runtimeAvailable: false
    });
  }
}
