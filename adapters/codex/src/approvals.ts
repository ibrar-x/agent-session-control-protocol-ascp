import { createEventEnvelope, type ApprovalRequest, type EventEnvelope } from "ascp-sdk-typescript";

import type { CodexJsonRpcMessage } from "./app-server-client.js";
import type { CodexDiscovery } from "./discovery.js";
import { toApprovalId, toRunId, toSessionId } from "./ids.js";

const CODEX_APPROVAL_METHODS = [
  "item/commandExecution/requestApproval",
  "item/fileChange/requestApproval",
  "item/permissions/requestApproval"
] as const;

type CodexApprovalMethod = (typeof CODEX_APPROVAL_METHODS)[number];

export interface CodexApprovalMappingOptions {
  now?: () => string;
  seq?: number;
}

export interface CodexApprovalRequestMessage extends CodexJsonRpcMessage {
  method: CodexApprovalMethod;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function readString(record: Record<string, unknown>, key: string): string | undefined {
  const value = record[key];
  return typeof value === "string" && value.length > 0 ? value : undefined;
}

function readStringArray(record: Record<string, unknown>, key: string): string[] | undefined {
  const value = record[key];

  if (!Array.isArray(value)) {
    return undefined;
  }

  const normalized = value.filter((entry): entry is string => typeof entry === "string" && entry.length > 0);

  return normalized.length > 0 ? normalized : undefined;
}

function eventNow(options: CodexApprovalMappingOptions): string {
  return options.now?.() ?? new Date().toISOString();
}

function createCodexEventId(...parts: string[]): string {
  return `codex:event:${parts.join(":")}`;
}

function isCodexApprovalMethod(method: string): method is CodexApprovalMethod {
  return (CODEX_APPROVAL_METHODS as readonly string[]).includes(method);
}

function requireParams(message: CodexApprovalRequestMessage): Record<string, unknown> {
  if (!isRecord(message.params)) {
    throw new Error(`Codex approval request ${message.method} is missing params.`);
  }

  return message.params;
}

function resolveApprovalIdentity(params: Record<string, unknown>): {
  approvalId: string;
  itemId: string;
  threadId: string;
  turnId: string | undefined;
} {
  const itemId = readString(params, "itemId");
  const threadId = readString(params, "threadId");

  if (itemId === undefined || threadId === undefined) {
    throw new Error("Codex approval request is missing required itemId or threadId.");
  }

  return {
    approvalId: readString(params, "approvalId") ?? itemId,
    itemId,
    threadId,
    turnId: readString(params, "turnId")
  };
}

function buildCommandApproval(
  identity: ReturnType<typeof resolveApprovalIdentity>,
  params: Record<string, unknown>,
  options: CodexApprovalMappingOptions
): ApprovalRequest {
  return {
    id: toApprovalId(identity.approvalId),
    session_id: toSessionId(identity.threadId),
    ...(identity.turnId !== undefined ? { run_id: toRunId(identity.threadId, identity.turnId) } : {}),
    kind: "command",
    status: "pending",
    title: "Approve shell command",
    ...(readString(params, "reason") !== undefined ? { description: readString(params, "reason") } : {}),
    risk_level: "medium",
    payload: {
      item_id: identity.itemId,
      ...(readString(params, "command") !== undefined ? { command: readString(params, "command") } : {}),
      ...(readString(params, "cwd") !== undefined ? { cwd: readString(params, "cwd") } : {})
    },
    metadata: {
      source: "runtime-native",
      adapter_kind: "codex",
      derivation_reason: null,
      native_status: "waiting_approval"
    },
    created_at: eventNow(options)
  };
}

function buildFileChangeApproval(
  identity: ReturnType<typeof resolveApprovalIdentity>,
  params: Record<string, unknown>,
  options: CodexApprovalMappingOptions
): ApprovalRequest {
  return {
    id: toApprovalId(identity.approvalId),
    session_id: toSessionId(identity.threadId),
    ...(identity.turnId !== undefined ? { run_id: toRunId(identity.threadId, identity.turnId) } : {}),
    kind: "file_write",
    status: "pending",
    title: "Approve file changes",
    ...(readString(params, "reason") !== undefined ? { description: readString(params, "reason") } : {}),
    risk_level: "medium",
    payload: {
      item_id: identity.itemId,
      ...(readString(params, "grantRoot") !== undefined ? { grant_root: readString(params, "grantRoot") } : {})
    },
    metadata: {
      source: "runtime-native",
      adapter_kind: "codex",
      derivation_reason: null,
      native_status: "waiting_approval"
    },
    created_at: eventNow(options)
  };
}

function buildPermissionsApproval(
  identity: ReturnType<typeof resolveApprovalIdentity>,
  params: Record<string, unknown>,
  options: CodexApprovalMappingOptions
): ApprovalRequest {
  const permissions = readStringArray(params, "permissions");
  const isNetworkRequest = permissions?.some((permission) => permission.includes("network")) ?? false;

  return {
    id: toApprovalId(identity.approvalId),
    session_id: toSessionId(identity.threadId),
    ...(identity.turnId !== undefined ? { run_id: toRunId(identity.threadId, identity.turnId) } : {}),
    kind: isNetworkRequest ? "network" : "generic",
    status: "pending",
    title: "Approve elevated permissions",
    ...(readString(params, "reason") !== undefined ? { description: readString(params, "reason") } : {}),
    risk_level: isNetworkRequest ? "high" : "medium",
    payload: {
      item_id: identity.itemId,
      ...(readString(params, "cwd") !== undefined ? { cwd: readString(params, "cwd") } : {}),
      ...(permissions !== undefined ? { permissions } : {})
    },
    metadata: {
      source: "runtime-native",
      adapter_kind: "codex",
      derivation_reason: null,
      native_status: "waiting_approval"
    },
    created_at: eventNow(options)
  };
}

export function mapApprovalRequest(
  message: CodexApprovalRequestMessage,
  options: CodexApprovalMappingOptions = {}
): ApprovalRequest {
  if (!isCodexApprovalMethod(message.method)) {
    throw new Error(`Unsupported Codex approval request method: ${message.method}`);
  }

  const params = requireParams(message);
  const identity = resolveApprovalIdentity(params);

  switch (message.method) {
    case "item/commandExecution/requestApproval":
      return buildCommandApproval(identity, params, options);
    case "item/fileChange/requestApproval":
      return buildFileChangeApproval(identity, params, options);
    case "item/permissions/requestApproval":
      return buildPermissionsApproval(identity, params, options);
  }
}

export function mapApprovalRequestToEvent(
  message: CodexApprovalRequestMessage,
  options: CodexApprovalMappingOptions = {}
): EventEnvelope<Record<string, unknown>> {
  const approval = mapApprovalRequest(message, options);
  const rawApprovalId = approval.id.startsWith("codex:") ? approval.id.slice("codex:".length) : approval.id;
  const turnId = typeof approval.run_id === "string" ? approval.run_id.split(":").at(-1) : undefined;
  const threadId = approval.session_id.startsWith("codex:")
    ? approval.session_id.slice("codex:".length)
    : approval.session_id;

  return createEventEnvelope({
    id: createCodexEventId(
      "approval_requested",
      threadId,
      turnId ?? "unknown_turn",
      rawApprovalId
    ),
    type: "approval.requested",
    ts: eventNow(options),
    session_id: approval.session_id,
    ...(typeof approval.run_id === "string" ? { run_id: approval.run_id } : {}),
    ...(options.seq !== undefined ? { seq: options.seq } : {}),
    payload: {
      approval
    }
  });
}

export function canRespondToApprovals(
  discovery: Pick<CodexDiscovery, "supportsApprovalRespond">
): boolean {
  return discovery.supportsApprovalRespond === true;
}
