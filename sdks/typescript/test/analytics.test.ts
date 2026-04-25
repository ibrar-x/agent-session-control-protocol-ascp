import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

import { describe, expect, it } from "vitest";

import packageJson from "../package.json";
import sessionExample from "../../../protocol/examples/core/session.json";
import {
  createBufferedAnalyticsRecorder,
  describeTransportError,
  describeValidationError
} from "../src/analytics/index.js";
import { AscpStdioTransport, AscpTransportError } from "../src/transport/index.js";
import { parseCoreEntity } from "../src/validation/index.js";
import { AscpValidationError } from "../src/validation/types.js";

const TEST_DIR = dirname(fileURLToPath(import.meta.url));
const SDK_DIR = resolve(TEST_DIR, "..");
const REPO_DIR = resolve(SDK_DIR, "../..");
const MOCK_SERVER_CLI = resolve(REPO_DIR, "services/mock-server/src/mock_server/cli.py");

describe("analytics and production hardening", () => {
  it("records opt-in transport analytics without capturing raw request payloads", async () => {
    const recorder = createBufferedAnalyticsRecorder();
    const transport = new AscpStdioTransport({
      command: ["python3", MOCK_SERVER_CLI],
      cwd: REPO_DIR,
      analytics: recorder
    });

    await transport.connect();
    await transport.request("capabilities.get");
    await transport.close();

    const eventNames = recorder.events.map((event) => event.name);

    expect(eventNames).toEqual(
      expect.arrayContaining([
        "transport.connect.started",
        "transport.connect.succeeded",
        "transport.request.started",
        "transport.request.completed",
        "transport.closed"
      ])
    );

    const completedEvent = recorder.events.find(
      (event) => event.name === "transport.request.completed"
    );

    expect(completedEvent?.context.method).toBe("capabilities.get");
    expect(completedEvent?.context.packageName).toBe("ascp-sdk-typescript");
    expect(completedEvent?.data).not.toHaveProperty("params");
    expect(completedEvent?.data).not.toHaveProperty("result");
  });

  it("attaches remediation diagnostics to transport failures", async () => {
    const recorder = createBufferedAnalyticsRecorder();
    const transport = new AscpStdioTransport({
      command: [
        process.execPath,
        "-e",
        [
          "process.stdin.setEncoding('utf8');",
          "process.stdin.once('data', () => {",
          "  process.stdout.write('not-json\\n');",
          "});"
        ].join("")
      ],
      cwd: SDK_DIR,
      analytics: recorder
    });

    await transport.connect();

    await expect(transport.request("capabilities.get")).rejects.toBeInstanceOf(
      AscpTransportError
    );

    const failedEvent = recorder.events.find(
      (event) => event.name === "transport.request.failed"
    );

    expect(failedEvent?.diagnostic).toEqual(
      expect.objectContaining({
        category: "transport",
        code: "TRANSPORT_PROTOCOL"
      })
    );
    expect(failedEvent?.diagnostic?.actions.join(" ")).toContain("JSON");

    await transport.close();
  });

  it("describes validation failures with target, path, and likely fixes", () => {
    const invalidSession = {
      ...sessionExample,
      status: "sleeping"
    };

    try {
      parseCoreEntity("Session", invalidSession);
      throw new Error("Expected validation failure.");
    } catch (error) {
      expect(error).toBeInstanceOf(AscpValidationError);

      const diagnostic = describeValidationError(error as AscpValidationError);

      expect(diagnostic.category).toBe("validation");
      expect(diagnostic.location).toContain("Session");
      expect(diagnostic.location).toContain("/status");
      expect(diagnostic.actions.join(" ")).toContain("schema");
    }
  });

  it("describes transport failures with location and remediation guidance", () => {
    const diagnostic = describeTransportError(
      new AscpTransportError({
        code: "TRANSPORT_TIMEOUT",
        transport: "stdio",
        message: "Request timed out."
      })
    );

    expect(diagnostic.category).toBe("transport");
    expect(diagnostic.location).toBe("stdio");
    expect(diagnostic.actions.join(" ")).toContain("timeout");
  });

  it("declares production package metadata for repository, bugs, homepage, and keywords", () => {
    expect(packageJson.repository).toEqual(
      expect.objectContaining({
        type: "git"
      })
    );
    expect(packageJson.bugs).toEqual(
      expect.objectContaining({
        url: expect.stringContaining("github.com")
      })
    );
    expect(packageJson.homepage).toContain("#readme");
    expect(packageJson.keywords).toEqual(
      expect.arrayContaining(["ascp", "typescript", "sdk"])
    );
  });
});
