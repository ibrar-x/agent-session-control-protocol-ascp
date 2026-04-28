export type PairingSessionStatus =
  | "pending_host_claim"
  | "pending_host_approval"
  | "approved"
  | "rejected"
  | "expired"
  | "consumed";

export interface PairingSessionRecord {
  sessionId: string;
  code: string;
  claimToken: string | null;
  requestedScopes: string[];
  status: PairingSessionStatus;
  createdAt: string;
  expiresAt: string;
  claimedAt: string | null;
  approvedAt: string | null;
  rejectedAt: string | null;
  consumedAt: string | null;
  deviceLabel: string | null;
  issuedDeviceId: string | null;
  qrPayload: string;
  error: string | null;
  isRefreshing: boolean;
  copiedCode: boolean;
  lastUpdatedAt: string;
}

export interface TrustedDeviceRecord {
  deviceId: string;
  displayName: string;
  scopes: string[];
  pairedAt: string;
  lastSeenAt: string | null;
  revoked: boolean;
  revokedAt: string | null;
  status: "active" | "revoked";
}

export interface PairingCreateFormState {
  requestedScopes: string[];
  ttlMinutes: number;
}

export interface PairingWorkspaceState {
  createForm: PairingCreateFormState;
  devices: TrustedDeviceRecord[];
  error: string | null;
  isLoaded: boolean;
  isLoading: boolean;
  isSubmitting: boolean;
  lastLoadedAt: string | null;
  sessions: PairingSessionRecord[];
}
