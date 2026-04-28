import { randomBytes, scrypt as scryptCallback, timingSafeEqual } from "node:crypto";
const SCRYPT_PARAMS = {
    N: 16_384,
    r: 8,
    p: 1,
    keylen: 32
};
function scrypt(secret, salt, keylen, options) {
    return new Promise((resolve, reject) => {
        scryptCallback(secret, salt, keylen, options, (error, derivedKey) => {
            if (error) {
                reject(error);
                return;
            }
            resolve(derivedKey);
        });
    });
}
export async function createDeviceSecretVerifier(secret) {
    const salt = randomBytes(16);
    const derived = await scrypt(secret, salt, SCRYPT_PARAMS.keylen, {
        N: SCRYPT_PARAMS.N,
        r: SCRYPT_PARAMS.r,
        p: SCRYPT_PARAMS.p
    });
    return {
        kdf: "scrypt",
        kdfParams: { ...SCRYPT_PARAMS },
        secretSalt: salt.toString("base64"),
        secretVerifier: derived.toString("base64")
    };
}
export async function verifyDeviceSecret(record, presentedSecret) {
    if (record.kdf !== "scrypt") {
        return false;
    }
    const expected = Buffer.from(record.secretVerifier, "base64");
    const derived = await scrypt(presentedSecret, Buffer.from(record.secretSalt, "base64"), record.kdfParams.keylen, {
        N: record.kdfParams.N,
        r: record.kdfParams.r,
        p: record.kdfParams.p
    });
    if (expected.length !== derived.length) {
        return false;
    }
    return timingSafeEqual(expected, derived);
}
//# sourceMappingURL=crypto.js.map