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
  const notifications = new Set(discovery.notifications);
  const hasEventNotifications =
    notifications.has("turn/started") ||
    notifications.has("turn/completed") ||
    notifications.has("agentMessageDelta");
  const canReadThreadState = methods.has("thread/read");
  const supportsStreaming = canReadThreadState && hasEventNotifications;

  return {
    session_list: methods.has("thread/list"),
    session_resume: methods.has("thread/resume"),
    session_start: methods.has("thread/start"),
    session_stop: false,
    stream_events: supportsStreaming,
    transcript_read: canReadThreadState,
    message_send: methods.has("turn/start") || methods.has("turn/steer"),
    approval_requests: discovery.supportsApprovalRequests,
    approval_respond: discovery.supportsApprovalRespond,
    artifacts: canReadThreadState,
    diffs: canReadThreadState,
    terminal_passthrough: false,
    notifications: supportsStreaming,
    checkpoints: false,
    replay: supportsStreaming,
    multi_workspace: false
  };
}
