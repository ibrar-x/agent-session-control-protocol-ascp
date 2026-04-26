import type { CodexDiscovery } from "./discovery.js";

export interface CodexResolvedCapabilities {
  session_list: boolean;
  session_resume: boolean;
  session_start: boolean;
  session_stop: boolean;
  stream_events: boolean;
  transcript_read: boolean;
  message_send: boolean;
  approval_requests: boolean;
  approval_respond: boolean;
  artifacts: boolean;
  diffs: boolean;
  terminal_passthrough: boolean;
  notifications: boolean;
  checkpoints: boolean;
  replay: boolean;
  multi_workspace: boolean;
}

function falseCapabilities(): CodexResolvedCapabilities {
  return {
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
  };
}

export function resolveCodexCapabilities(discovery: CodexDiscovery): CodexResolvedCapabilities {
  if (!discovery.runtimeAvailable) {
    return falseCapabilities();
  }

  const methods = new Set(discovery.appServerMethods);
  const streamEvents = discovery.notifications.length > 0;
  const approvalRequests = discovery.supportsApprovalRequests;

  return {
    session_list: methods.has("thread/list"),
    session_resume: methods.has("thread/resume"),
    session_start: methods.has("thread/start"),
    session_stop: false,
    stream_events: streamEvents,
    transcript_read: methods.has("thread/read"),
    message_send: methods.has("turn/start") || methods.has("turn/steer"),
    approval_requests: approvalRequests,
    approval_respond: approvalRequests && discovery.supportsApprovalRespond,
    artifacts: false,
    diffs: discovery.supportsDiffReads,
    terminal_passthrough: false,
    notifications: streamEvents,
    checkpoints: false,
    replay: false,
    multi_workspace: false
  };
}
