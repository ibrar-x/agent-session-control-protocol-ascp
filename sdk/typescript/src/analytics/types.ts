import {
  ASCP_PROTOCOL_VERSION,
  ASCP_SDK_PACKAGE_NAME,
  ASCP_SDK_PACKAGE_VERSION
} from "../metadata.js";

export const ASCP_ANALYTICS_EVENT_NAMES = [
  "transport.closed",
  "transport.connect.failed",
  "transport.connect.started",
  "transport.connect.succeeded",
  "transport.event.received",
  "transport.request.completed",
  "transport.request.failed",
  "transport.request.started",
  "transport.stream.invalid_message"
] as const;

export type AscpAnalyticsEventName = (typeof ASCP_ANALYTICS_EVENT_NAMES)[number];

export type AscpDiagnosticCategory = "transport" | "validation";

export interface AscpDiagnostic {
  category: AscpDiagnosticCategory;
  code: string;
  location: string;
  summary: string;
  actions: string[];
  details?: Record<string, unknown> | undefined;
}

export interface AscpAnalyticsContext {
  packageName: string;
  packageVersion: string;
  protocolVersion: string;
  transport?: string;
  method?: string;
  requestId?: string | number;
  eventType?: string;
  target?: string;
}

export interface AscpAnalyticsEvent {
  name: AscpAnalyticsEventName;
  ts: string;
  context: AscpAnalyticsContext;
  data?: Record<string, unknown>;
  diagnostic?: AscpDiagnostic;
}

export interface AscpAnalyticsRecorder {
  record(event: AscpAnalyticsEvent): void;
}

export interface BufferedAnalyticsRecorder extends AscpAnalyticsRecorder {
  readonly events: AscpAnalyticsEvent[];
  reset(): void;
}

export function createAnalyticsContext(
  overrides: Partial<Omit<AscpAnalyticsContext, "packageName" | "packageVersion" | "protocolVersion">> = {}
): AscpAnalyticsContext {
  return {
    packageName: ASCP_SDK_PACKAGE_NAME,
    packageVersion: ASCP_SDK_PACKAGE_VERSION,
    protocolVersion: ASCP_PROTOCOL_VERSION,
    ...overrides
  };
}

export function createBufferedAnalyticsRecorder(): BufferedAnalyticsRecorder {
  const events: AscpAnalyticsEvent[] = [];

  return {
    events,
    record(event) {
      events.push(event);
    },
    reset() {
      events.length = 0;
    }
  };
}

export function emitAnalyticsEvent(
  recorder: AscpAnalyticsRecorder | undefined,
  event: Omit<AscpAnalyticsEvent, "ts">
): void {
  if (recorder === undefined) {
    return;
  }

  try {
    recorder.record({
      ...event,
      ts: new Date().toISOString()
    });
  } catch {
    // Analytics must never break the SDK control flow.
  }
}
