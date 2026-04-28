import { afterEach, describe, expect, it } from "vitest";

import { startHostDaemon, type RunningHostDaemon } from "../../src/main.js";

const daemonsToClose = new Set<RunningHostDaemon>();

afterEach(async () => {
  for (const daemon of daemonsToClose) {
    await daemon.close();
  }

  daemonsToClose.clear();
});

describe("pairing admin server", () => {
  it("creates pairing sessions, approves them, and revokes trusted devices over loopback HTTP", async () => {
    const daemon = await createPairingHarness();
    daemonsToClose.add(daemon);

    const createResponse = await requestJson(daemon.adminUrl, "POST", "/admin/pairing/sessions", {
      requested_scopes: ["read:hosts", "read:sessions"]
    });

    expect(createResponse).toMatchObject({
      code: expect.stringMatching(/^[A-Z0-9-]+$/),
      expires_at: expect.any(String),
      session_id: expect.any(String)
    });

    const claimResponse = await requestJson(daemon.adminUrl, "POST", "/pairing/claim", {
      code: createResponse.code,
      device_label: "QA phone"
    });

    await requestJson(
      daemon.adminUrl,
      "POST",
      `/admin/pairing/sessions/${createResponse.session_id}/approve`,
      {}
    );

    const pollResponse = await requestJson(
      daemon.adminUrl,
      "GET",
      `/pairing/claims/${claimResponse.claim_token}`
    );

    expect(pollResponse).toMatchObject({
      status: "approved",
      credentials: {
        device_id: expect.any(String),
        device_secret: expect.any(String)
      }
    });

    const devicesResponse = await requestJson(daemon.adminUrl, "GET", "/admin/trusted-devices");
    expect(devicesResponse.devices).toHaveLength(1);

    const revokeResponse = await requestJson(
      daemon.adminUrl,
      "POST",
      `/admin/trusted-devices/${encodeURIComponent(pollResponse.credentials.device_id)}/revoke`,
      {}
    );
    expect(revokeResponse).toMatchObject({
      device_id: pollResponse.credentials.device_id,
      revoked: true
    });
  });

  it("returns 409 for duplicate claims", async () => {
    const daemon = await createPairingHarness();
    daemonsToClose.add(daemon);

    const createResponse = await requestJson(daemon.adminUrl, "POST", "/admin/pairing/sessions", {
      requested_scopes: ["read:sessions"]
    });

    await requestJson(daemon.adminUrl, "POST", "/pairing/claim", {
      code: createResponse.code,
      device_label: "Phone A"
    });

    const duplicate = await requestJson(daemon.adminUrl, "POST", "/pairing/claim", {
      code: createResponse.code,
      device_label: "Phone B"
    });

    expect(duplicate).toMatchObject({
      code: "ALREADY_CLAIMED"
    });
  });
});

async function createPairingHarness(): Promise<RunningHostDaemon> {
  return startHostDaemon({
    config: {
      adminPort: 0,
      authTransport: "loopback",
      databasePath: ":memory:",
      host: "127.0.0.1",
      port: 0,
      runtime: "codex"
    },
    runtimeRegistry: {
      createRuntime: () => ({
        capabilitiesGet: async () => ({
          capabilities: {
            replay: true
          },
          host: {
            id: "host:1",
            status: "online",
            transports: ["websocket"]
          },
          protocol_version: "0.1.0",
          runtimes: [],
          transports: ["websocket"]
        }),
        hostsGet: async () => ({
          host: {
            id: "host:1",
            status: "online",
            transports: ["websocket"]
          }
        })
      })
    }
  });
}

async function requestJson(
  baseUrl: string,
  method: "GET" | "POST",
  pathname: string,
  body?: Record<string, unknown>
): Promise<Record<string, any>> {
  const response = await fetch(new URL(pathname, baseUrl), {
    body: body === undefined ? undefined : JSON.stringify(body),
    headers: {
      "content-type": "application/json"
    },
    method
  });

  return (await response.json()) as Record<string, any>;
}
