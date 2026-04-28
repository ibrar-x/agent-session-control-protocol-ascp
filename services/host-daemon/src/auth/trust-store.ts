import type { DaemonDatabase } from "../sqlite.js";
import type { TrustedDeviceRecord, TrustedDeviceUpsertInput } from "./types.js";

interface TrustedDeviceRow {
  device_id: string;
  display_name: string;
  scopes_json: string;
  paired_at: string;
  last_seen_at: string | null;
  revoked: number;
  revoked_at: string | null;
  secret_salt: string;
  secret_verifier: string;
  kdf: "scrypt";
  kdf_params_json: string;
}

function serialize(value: unknown): string {
  return JSON.stringify(value);
}

function parseJson<TValue>(value: string): TValue {
  return JSON.parse(value) as TValue;
}

function hydrateTrustedDevice(row: TrustedDeviceRow): TrustedDeviceRecord {
  return {
    deviceId: row.device_id,
    displayName: row.display_name,
    scopes: parseJson<string[]>(row.scopes_json),
    pairedAt: row.paired_at,
    lastSeenAt: row.last_seen_at,
    revoked: row.revoked === 1,
    revokedAt: row.revoked_at,
    secretSalt: row.secret_salt,
    secretVerifier: row.secret_verifier,
    kdf: row.kdf,
    kdfParams: parseJson<TrustedDeviceRecord["kdfParams"]>(row.kdf_params_json)
  };
}

export interface TrustStore {
  getDevice(deviceId: string): TrustedDeviceRecord | null;
  listDevices(): TrustedDeviceRecord[];
  upsertDevice(device: TrustedDeviceUpsertInput): TrustedDeviceRecord;
  recordSeen(deviceId: string, seenAt?: string): TrustedDeviceRecord | null;
  revokeDevice(deviceId: string, revokedAt?: string): TrustedDeviceRecord | null;
}

export function createTrustStore(database: DaemonDatabase): TrustStore {
  const selectDevice = database.prepare(`
    SELECT
      device_id,
      display_name,
      scopes_json,
      paired_at,
      last_seen_at,
      revoked,
      revoked_at,
      secret_salt,
      secret_verifier,
      kdf,
      kdf_params_json
    FROM daemon_trusted_devices
    WHERE device_id = ?
  `);
  const selectDevices = database.prepare(`
    SELECT
      device_id,
      display_name,
      scopes_json,
      paired_at,
      last_seen_at,
      revoked,
      revoked_at,
      secret_salt,
      secret_verifier,
      kdf,
      kdf_params_json
    FROM daemon_trusted_devices
    ORDER BY paired_at ASC
  `);
  const upsertDevice = database.prepare(`
    INSERT INTO daemon_trusted_devices (
      device_id,
      display_name,
      scopes_json,
      paired_at,
      last_seen_at,
      revoked,
      revoked_at,
      secret_salt,
      secret_verifier,
      kdf,
      kdf_params_json
    ) VALUES (
      @device_id,
      @display_name,
      @scopes_json,
      @paired_at,
      @last_seen_at,
      @revoked,
      @revoked_at,
      @secret_salt,
      @secret_verifier,
      @kdf,
      @kdf_params_json
    )
    ON CONFLICT(device_id) DO UPDATE SET
      display_name = excluded.display_name,
      scopes_json = excluded.scopes_json,
      last_seen_at = excluded.last_seen_at,
      revoked = excluded.revoked,
      revoked_at = excluded.revoked_at,
      secret_salt = excluded.secret_salt,
      secret_verifier = excluded.secret_verifier,
      kdf = excluded.kdf,
      kdf_params_json = excluded.kdf_params_json
  `);
  const updateLastSeen = database.prepare(`
    UPDATE daemon_trusted_devices
    SET last_seen_at = ?
    WHERE device_id = ?
  `);
  const revokeDevice = database.prepare(`
    UPDATE daemon_trusted_devices
    SET revoked = 1,
        revoked_at = ?
    WHERE device_id = ?
  `);

  return {
    getDevice(deviceId) {
      const row = selectDevice.get(deviceId) as TrustedDeviceRow | undefined;
      return row === undefined ? null : hydrateTrustedDevice(row);
    },
    listDevices() {
      return (selectDevices.all() as unknown as TrustedDeviceRow[]).map(hydrateTrustedDevice);
    },
    upsertDevice(device) {
      const existing = this.getDevice(device.deviceId);
      const pairedAt = existing?.pairedAt ?? new Date().toISOString();

      upsertDevice.run({
        device_id: device.deviceId,
        display_name: device.displayName,
        scopes_json: serialize(device.scopes),
        paired_at: pairedAt,
        last_seen_at: existing?.lastSeenAt ?? null,
        revoked: existing?.revoked === true ? 1 : 0,
        revoked_at: existing?.revokedAt ?? null,
        secret_salt: device.secretSalt,
        secret_verifier: device.secretVerifier,
        kdf: device.kdf,
        kdf_params_json: serialize(device.kdfParams)
      });

      const stored = this.getDevice(device.deviceId);

      if (stored === null) {
        throw new Error(`Failed to persist trusted device: ${device.deviceId}`);
      }

      return stored;
    },
    recordSeen(deviceId, seenAt = new Date().toISOString()) {
      updateLastSeen.run(seenAt, deviceId);
      return this.getDevice(deviceId);
    },
    revokeDevice(deviceId, revokedAt = new Date().toISOString()) {
      revokeDevice.run(revokedAt, deviceId);
      return this.getDevice(deviceId);
    }
  };
}
