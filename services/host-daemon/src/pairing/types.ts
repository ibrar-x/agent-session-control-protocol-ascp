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
}
