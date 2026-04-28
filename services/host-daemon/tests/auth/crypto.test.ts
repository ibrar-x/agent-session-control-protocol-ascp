import { describe, expect, it } from "vitest";

import { createDeviceSecretVerifier, verifyDeviceSecret } from "../../src/auth/crypto.js";

describe("device secret crypto", () => {
  it("verifies the original secret and rejects a different one", async () => {
    const verifier = await createDeviceSecretVerifier("top-secret-device-key");

    await expect(verifyDeviceSecret(verifier, "top-secret-device-key")).resolves.toBe(true);
    await expect(verifyDeviceSecret(verifier, "wrong-secret")).resolves.toBe(false);
  });

  it("derives unique verifier material for the same secret", async () => {
    const first = await createDeviceSecretVerifier("shared-secret");
    const second = await createDeviceSecretVerifier("shared-secret");

    expect(first.kdf).toBe("scrypt");
    expect(first.secretSalt).not.toBe(second.secretSalt);
    expect(first.secretVerifier).not.toBe(second.secretVerifier);
  });
});
