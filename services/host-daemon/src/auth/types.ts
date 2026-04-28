export type AuthTransportMode = "loopback" | "tls";

export type DeviceSecretKdf = "scrypt";

export interface DeviceSecretKdfParams {
  N: number;
  r: number;
  p: number;
  keylen: number;
}

export interface DeviceSecretVerifierRecord {
  kdf: DeviceSecretKdf;
  kdfParams: DeviceSecretKdfParams;
  secretSalt: string;
  secretVerifier: string;
}

export interface TrustedDeviceRecord extends DeviceSecretVerifierRecord {
  deviceId: string;
  displayName: string;
  scopes: string[];
  pairedAt: string;
  lastSeenAt: string | null;
  revoked: boolean;
  revokedAt: string | null;
}

export interface TrustedDeviceUpsertInput extends DeviceSecretVerifierRecord {
  deviceId: string;
  displayName: string;
  scopes: string[];
}

export interface PairDeviceResult {
  deviceId: string;
  deviceSecret: string;
  record: TrustedDeviceRecord;
}

export type AuditAuthState = "authenticated" | "unauthenticated";
export type AuditAuthorizationState = "allowed" | "denied" | "not_checked";
export type AuditOutcome = "allowed" | "rejected" | "errored";
export type AuditStage = "received" | "completed";

export interface AuditLogRecord {
  correlationId: string;
  ts: string;
  stage: AuditStage;
  method: string;
  requestId: string | null;
  deviceId: string | null;
  actorId: string | null;
  transportMode: AuthTransportMode;
  authState: AuditAuthState;
  authorizationState: AuditAuthorizationState;
  outcome: AuditOutcome;
  errorCode: string | null;
  details: Record<string, unknown> | null;
}

export interface AuditLogInput {
  correlationId: string;
  stage: AuditStage;
  method: string;
  transportMode: AuthTransportMode;
  authState: AuditAuthState;
  authorizationState: AuditAuthorizationState;
  outcome: AuditOutcome;
  ts?: string;
  requestId?: string | null;
  deviceId?: string | null;
  actorId?: string | null;
  errorCode?: string | null;
  details?: Record<string, unknown> | null;
}
