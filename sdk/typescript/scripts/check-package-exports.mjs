import assert from "node:assert/strict";

const root = await import("ascp-sdk-typescript");
const analytics = await import("ascp-sdk-typescript/analytics");
const client = await import("ascp-sdk-typescript/client");
const replay = await import("ascp-sdk-typescript/replay");
const transport = await import("ascp-sdk-typescript/transport");
const validation = await import("ascp-sdk-typescript/validation");

assert.equal(root.ASCP_SDK_PACKAGE_NAME, "ascp-sdk-typescript");
assert.equal(root.ASCP_SDK_PACKAGE_VERSION, "0.1.0");
assert.equal(root.ASCP_PROTOCOL_VERSION, "0.1.0");

assert.equal(typeof root.AscpClient, "function");
assert.equal(typeof root.AscpProtocolError, "function");
assert.equal(typeof root.createAscpClient, "function");
assert.equal(typeof root.defineAscpParams, "function");
assert.equal(typeof root.replayFromSeq, "function");
assert.equal(typeof root.replayAfterEventId, "function");
assert.equal(typeof root.replayWithOpaqueCursor, "function");
assert.equal(typeof root.subscribeWithReplay, "function");

assert.ok(!Object.hasOwn(root, "AscpStdioTransport"));
assert.ok(!Object.hasOwn(root, "safeParseCoreEntity"));
assert.ok(!Object.hasOwn(root, "createBufferedAnalyticsRecorder"));

assert.equal(typeof analytics.createBufferedAnalyticsRecorder, "function");
assert.equal(typeof analytics.describeTransportError, "function");
assert.equal(typeof client.AscpClient, "function");
assert.equal(typeof replay.subscribeWithReplay, "function");
assert.equal(typeof transport.AscpStdioTransport, "function");
assert.equal(typeof transport.AscpWebSocketTransport, "function");
assert.equal(typeof validation.safeParseCoreEntity, "function");

console.log("Package export boundaries resolved successfully.");
