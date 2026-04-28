import { describe, expect, it } from "vitest";

import { createAuthorizer } from "../../src/auth/authorizer.js";

describe("createAuthorizer", () => {
  it("builds request context for an authenticated device with matching scope", () => {
    const authorizer = createAuthorizer();

    expect(
      authorizer.createRequestContext({
        connectionAuth: {
          authenticated: true,
          deviceId: "daemon:device:test-1",
          scopes: ["write:sessions"],
          transportMode: "loopback"
        },
        correlationId: "corr-1",
        method: "sessions.send_input",
        requestId: "req-1"
      })
    ).toMatchObject({
      correlationId: "corr-1",
      deviceId: "daemon:device:test-1",
      method: "sessions.send_input",
      requestId: "req-1",
      scopes: ["write:sessions"],
      transportMode: "loopback"
    });
  });

  it("throws UNAUTHORIZED for missing auth and FORBIDDEN for missing scope", () => {
    const authorizer = createAuthorizer();

    expect(() =>
      authorizer.createRequestContext({
        connectionAuth: {
          authenticated: false,
          errorMessage: "Device authentication required.",
          scopes: [],
          transportMode: "loopback"
        },
        correlationId: "corr-unauth",
        method: "sessions.list",
        requestId: "req-2"
      })
    ).toThrowError("Device authentication required.");

    expect(() =>
      authorizer.createRequestContext({
        connectionAuth: {
          authenticated: true,
          deviceId: "daemon:device:test-1",
          scopes: ["read:sessions"],
          transportMode: "loopback"
        },
        correlationId: "corr-forbidden",
        method: "sessions.send_input",
        requestId: "req-3"
      })
    ).toThrowError("Missing scope: write:sessions");
  });
});
