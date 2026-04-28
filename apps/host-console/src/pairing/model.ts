import type {
  PairingCreateFormState,
  PairingSessionRecord,
  PairingWorkspaceState,
  TrustedDeviceRecord
} from "./types";

export const DEFAULT_PAIRING_SCOPES = ["read:hosts", "read:runtimes", "read:sessions"];
export const ACTIVE_POLLING_MS = 3_000;
export const IDLE_REFRESH_MS = 30_000;

export function createPairingWorkspaceState(): PairingWorkspaceState {
  return {
    createForm: {
      requestedScopes: [...DEFAULT_PAIRING_SCOPES],
      ttlMinutes: 5
    },
    devices: [],
    error: null,
    isLoaded: false,
    isLoading: false,
    isSubmitting: false,
    lastLoadedAt: null,
    sessions: []
  };
}

export function deriveApprovalQueue(sessions: PairingSessionRecord[]): PairingSessionRecord[] {
  return sessions
    .filter((session) => session.status === "pending_host_approval")
    .sort((left, right) => left.createdAt.localeCompare(right.createdAt));
}

export function shouldUseActivePolling(sessions: PairingSessionRecord[]): boolean {
  return sessions.some(
    (session) =>
      session.status === "pending_host_claim" ||
      session.status === "pending_host_approval" ||
      session.status === "approved"
  );
}

export function mergePairingSession(
  sessions: PairingSessionRecord[],
  nextSession: PairingSessionRecord
): PairingSessionRecord[] {
  const existingIndex = sessions.findIndex((session) => session.sessionId === nextSession.sessionId);
  const merged =
    existingIndex === -1
      ? [...sessions, nextSession]
      : sessions.map((session) =>
          session.sessionId === nextSession.sessionId ? nextSession : session
        );

  return merged.sort((left, right) => right.createdAt.localeCompare(left.createdAt));
}

export function replacePairingSessions(
  _existing: PairingSessionRecord[],
  nextSessions: PairingSessionRecord[]
): PairingSessionRecord[] {
  return [...nextSessions].sort((left, right) => right.createdAt.localeCompare(left.createdAt));
}

export function updateTrustedDeviceList(
  _existing: TrustedDeviceRecord[],
  nextDevices: TrustedDeviceRecord[]
): TrustedDeviceRecord[] {
  return [...nextDevices].sort((left, right) => right.pairedAt.localeCompare(left.pairedAt));
}

export function updateCreateForm(
  form: PairingCreateFormState,
  nextPatch: Partial<PairingCreateFormState>
): PairingCreateFormState {
  return {
    ...form,
    ...nextPatch
  };
}

export function markCopiedCode(
  sessions: PairingSessionRecord[],
  sessionId: string,
  copiedCode: boolean
): PairingSessionRecord[] {
  return sessions.map((session) =>
    session.sessionId === sessionId ? { ...session, copiedCode } : session
  );
}
