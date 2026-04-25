import type {
  AscpAnalyticsEvent,
  AscpAnalyticsRecorder,
  AscpDiagnostic
} from "../src/analytics/index.js";
import { createBufferedAnalyticsRecorder } from "../src/analytics/index.js";
import type { AscpStdioTransportOptions } from "../src/transport/index.js";

const recorder = createBufferedAnalyticsRecorder();

const transportOptions: AscpStdioTransportOptions = {
  command: ["python3", "mock.py"],
  analytics: recorder
};

const recorderContract: AscpAnalyticsRecorder = recorder;
const event: AscpAnalyticsEvent = recorder.events[0] ?? {
  name: "transport.closed",
  ts: new Date().toISOString(),
  context: {
    packageName: "ascp-sdk-typescript",
    packageVersion: "0.1.0",
    protocolVersion: "0.1.0"
  }
};
const diagnostic: AscpDiagnostic = {
  category: "transport",
  code: "TRANSPORT_TIMEOUT",
  location: "stdio",
  summary: "request timed out",
  actions: ["Increase the timeout or inspect the host."]
};

void transportOptions;
void recorderContract;
void event;
void diagnostic;
