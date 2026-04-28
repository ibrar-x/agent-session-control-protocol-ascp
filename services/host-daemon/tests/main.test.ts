import { describe, expect, it, vi } from "vitest";

import { startHostDaemon } from "../src/main.js";

describe("startHostDaemon", () => {
  it("creates the configured runtime and starts the reusable host service", async () => {
    const runtime = {
      capabilitiesGet: vi.fn(),
      hostsGet: vi.fn()
    };
    const createRuntime = vi.fn(() => runtime);
    const adminListen = vi.fn(async () => {});
    const adminClose = vi.fn(async () => {});
    const listen = vi.fn(async () => {});
    const close = vi.fn(async () => {});
    const createHostService = vi.fn(() => ({
      url: "ws://127.0.0.1:8765",
      listen,
      close
    }));
    const createAdminServer = vi.fn(() => ({
      url: "http://127.0.0.1:8766",
      listen: adminListen,
      close: adminClose
    }));

    const daemon = await startHostDaemon({
      config: {
        adminPort: 8766,
        authTransport: "loopback",
        databasePath: ":memory:",
        host: "127.0.0.1",
        port: 8765,
        runtime: "codex"
      },
      runtimeRegistry: {
        createRuntime
      },
      createAdminServer,
      createHostService
    });

    expect(createRuntime).toHaveBeenCalledWith("codex");
    expect(createAdminServer).toHaveBeenCalledWith({
      host: "127.0.0.1",
      pairingService: expect.objectContaining({
        startPairing: expect.any(Function)
      }),
      port: 8766
    });
    expect(createHostService).toHaveBeenCalledTimes(1);
    expect(createHostService.mock.calls[0]?.[0]).toEqual(
      expect.objectContaining({
        authorizeConnection: expect.any(Function),
        createRequestContext: expect.any(Function),
        host: "127.0.0.1",
        onRequestAudit: expect.any(Function),
        port: 8765,
        runtime: expect.objectContaining({
          capabilitiesGet: expect.any(Function),
          hostsGet: expect.any(Function),
          sessionsSubscribe: expect.any(Function),
          sessionsUnsubscribe: expect.any(Function),
          drainSubscriptionEvents: expect.any(Function)
        })
      })
    );
    await expect(createHostService.mock.calls[0]?.[0].runtime.capabilitiesGet()).resolves.toMatchObject(
      {
        auth: {
          transport: "loopback"
        }
      }
    );
    expect(adminListen).toHaveBeenCalledTimes(1);
    expect(listen).toHaveBeenCalledTimes(1);
    expect(daemon.url).toBe("ws://127.0.0.1:8765");
    expect(daemon.adminUrl).toBe("http://127.0.0.1:8766");
    expect(typeof daemon.pairingBackendService.startPairing).toBe("function");
    expect(typeof daemon.pairingService.pairDevice).toBe("function");

    await daemon.close();

    expect(adminClose).toHaveBeenCalledTimes(1);
    expect(close).toHaveBeenCalledTimes(1);
  });
});
