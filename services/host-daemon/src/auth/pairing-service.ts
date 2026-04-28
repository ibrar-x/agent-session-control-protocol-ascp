import { randomBytes, randomUUID } from "node:crypto";

import { createDeviceSecretVerifier } from "./crypto.js";
import type { PairDeviceResult } from "./types.js";
import type { TrustStore } from "./trust-store.js";

export interface PairingService {
  pairDevice(input: { displayName: string; scopes: string[] }): Promise<PairDeviceResult>;
}

export function createPairingService(deps: { trustStore: TrustStore }): PairingService {
  return {
    async pairDevice(input) {
      const deviceSecret = randomBytes(32).toString("base64url");
      const verifier = await createDeviceSecretVerifier(deviceSecret);
      const deviceId = `daemon:device:${randomUUID()}`;
      const record = deps.trustStore.upsertDevice({
        deviceId,
        displayName: input.displayName,
        scopes: input.scopes,
        ...verifier
      });

      return {
        deviceId,
        deviceSecret,
        record
      };
    }
  };
}
