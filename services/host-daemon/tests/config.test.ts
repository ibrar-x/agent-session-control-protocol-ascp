import { describe, expect, it } from "vitest";

import { resolveDaemonConfig } from "../src/config.js";

describe("resolveDaemonConfig", () => {
  it("uses local defaults for the codex daemon", () => {
    expect(resolveDaemonConfig({})).toEqual({
      adminPort: 8766,
      authTransport: "loopback",
      databasePath: ".ascp/host-daemon.sqlite",
      host: "127.0.0.1",
      port: 8765,
      runtime: "codex"
    });
  });

  it("allows env overrides for runtime, host, and port", () => {
    expect(
      resolveDaemonConfig({
        ASCP_HOST: "0.0.0.0",
        ASCP_ADMIN_PORT: "9101",
        ASCP_DATABASE_PATH: "/tmp/ascp.sqlite",
        ASCP_AUTH_TRANSPORT: "tls",
        ASCP_PORT: "9000",
        ASCP_RUNTIME: "codex"
      })
    ).toEqual({
      adminPort: 9101,
      authTransport: "tls",
      databasePath: "/tmp/ascp.sqlite",
      host: "0.0.0.0",
      port: 9000,
      runtime: "codex"
    });
  });

  it("honors explicit defaults when env values are absent", () => {
    expect(
      resolveDaemonConfig(
        {},
        {
          adminPort: 9200,
          authTransport: "loopback",
          databasePath: "/tmp/default.sqlite",
          host: "localhost",
          port: 9100,
          runtime: "codex"
        }
      )
    ).toEqual({
      adminPort: 9200,
      authTransport: "loopback",
      databasePath: "/tmp/default.sqlite",
      host: "localhost",
      port: 9100,
      runtime: "codex"
    });
  });

  it("rejects invalid ports", () => {
    expect(() =>
      resolveDaemonConfig({
        ASCP_PORT: "-1"
      })
    ).toThrow("Invalid ASCP_PORT value: -1");
  });

  it("rejects non-local bindings for loopback auth mode", () => {
    expect(() =>
      resolveDaemonConfig({
        ASCP_HOST: "0.0.0.0",
        ASCP_AUTH_TRANSPORT: "loopback"
      })
    ).toThrow("ASCP auth transport loopback requires a local-only host binding: 0.0.0.0");
  });
});
