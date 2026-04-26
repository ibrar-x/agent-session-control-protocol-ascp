import { describe, expect, it } from "vitest";

import { resolveCodexCapabilities } from "../src/capabilities.js";
import type { CodexDiscovery } from "../src/discovery.js";

const BASE_DISCOVERY: CodexDiscovery = {
  runtimeAvailable: true,
  runtimeId: "codex_local",
  version: "0.34.0",
  appServerMethods: [
    "initialize",
    "thread/list",
    "thread/read",
    "thread/start",
    "thread/resume",
    "turn/start",
    "turn/steer"
  ],
  notifications: [
    "thread/started",
    "thread/status/changed",
    "turn/started",
    "turn/completed",
    "turn/diff/updated"
  ],
  verifiedAppServerMethods: [
    "initialize",
    "thread/list",
    "thread/read",
    "thread/start",
    "thread/resume",
    "turn/start",
    "turn/steer"
  ],
  observedAppServerMethods: [
    "thread/list",
    "thread/read",
    "thread/start",
    "thread/resume",
    "turn/start",
    "turn/steer"
  ],
  verifiedNotifications: [
    "thread/started",
    "thread/status/changed",
    "turn/started",
    "turn/completed",
    "turn/diff/updated"
  ],
  observedNotifications: [
    "thread/started",
    "thread/status/changed",
    "turn/started",
    "turn/completed",
    "turn/diff/updated"
  ],
  supportsApprovalRequests: true,
  supportsApprovalRespond: false,
  supportsDiffReads: false
};

describe("resolveCodexCapabilities", () => {
  it("marks replay unsupported when no official replay surface is observed", () => {
    expect(resolveCodexCapabilities(BASE_DISCOVERY).replay).toBe(false);
  });

  it("keeps artifacts unsupported when no official artifact surface is observed", () => {
    expect(resolveCodexCapabilities(BASE_DISCOVERY).artifacts).toBe(false);
  });

  it("maps only observed official surfaces and defaults ambiguous capabilities to false", () => {
    expect(resolveCodexCapabilities(BASE_DISCOVERY)).toEqual({
      session_list: true,
      session_resume: true,
      session_start: true,
      session_stop: false,
      stream_events: false,
      transcript_read: true,
      message_send: true,
      approval_requests: false,
      approval_respond: false,
      artifacts: false,
      diffs: false,
      terminal_passthrough: false,
      notifications: false,
      checkpoints: false,
      replay: false,
      multi_workspace: false
    });
  });

  it("advertises no runtime capabilities when discovery says Codex is unavailable", () => {
    expect(
      resolveCodexCapabilities({
        ...BASE_DISCOVERY,
        runtimeAvailable: false
      })
    ).toEqual({
      session_list: false,
      session_resume: false,
      session_start: false,
      session_stop: false,
      stream_events: false,
      transcript_read: false,
      message_send: false,
      approval_requests: false,
      approval_respond: false,
      artifacts: false,
      diffs: false,
      terminal_passthrough: false,
      notifications: false,
      checkpoints: false,
      replay: false,
      multi_workspace: false
    });
  });
});
