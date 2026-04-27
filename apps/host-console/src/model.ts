import type {
  ApprovalRequest,
  Artifact,
  DiffSummary,
  EventEnvelope,
  InputRequest,
  Run,
  Session
} from "ascp-sdk-typescript/models";

export type SessionViewMode = "loading" | "live" | "snapshot-only" | "error";
export type LivePausedReason = "subscribe_failed" | "subscription_dropped";

export interface SessionViewState {
  sessionId: string;
  mode: SessionViewMode;
  session: Session | null;
  runs: Run[];
  currentRun: Run | null;
  approvals: ApprovalRequest[];
  inputs: InputRequest[];
  artifacts: Artifact[];
  artifactDetail: Artifact | null;
  diff: DiffSummary | null;
  events: EventEnvelope[];
  expanded: {
    artifacts: boolean;
    diff: boolean;
    events: boolean;
    capabilities: boolean;
  };
  livePausedReason?: LivePausedReason;
}

export interface InteractionTimelineItem {
  id: string;
  kind: "approval" | "input";
  state: "pending" | "answered" | "expired";
  ts: string;
  approval?: ApprovalRequest;
  input?: InputRequest;
}

interface InteractionTimelineSource {
  approvals: ApprovalRequest[];
  inputs: InputRequest[];
}

interface HydrateSessionSnapshotOptions {
  sessionId: string;
  session: Session;
  runs: Run[];
  approvals: ApprovalRequest[];
  inputs: InputRequest[];
}

function baseView(sessionId: string): SessionViewState {
  return {
    sessionId,
    mode: "loading",
    session: null,
    runs: [],
    currentRun: null,
    approvals: [],
    inputs: [],
    artifacts: [],
    artifactDetail: null,
    diff: null,
    events: [],
    expanded: {
      artifacts: false,
      diff: false,
      events: false,
      capabilities: false
    }
  };
}

export function createLoadingSessionView(sessionId: string): SessionViewState {
  return baseView(sessionId);
}

export function createSnapshotOnlySessionView(options: {
  sessionId: string;
  pausedReason: LivePausedReason;
}): SessionViewState {
  return {
    ...baseView(options.sessionId),
    mode: "snapshot-only",
    livePausedReason: options.pausedReason
  };
}

export function hydrateSessionSnapshot(
  options: HydrateSessionSnapshotOptions
): SessionViewState {
  const sortedRuns = [...options.runs].sort((left, right) => right.started_at.localeCompare(left.started_at));

  return {
    ...baseView(options.sessionId),
    mode: "live",
    session: options.session,
    runs: sortedRuns,
    currentRun: sortedRuns[0] ?? null,
    approvals: options.approvals,
    inputs: options.inputs
  };
}

function isResolvedStatus(status: string): boolean {
  return status !== "pending";
}

export function mergeApprovals(
  existing: ApprovalRequest[],
  nextPending: ApprovalRequest[]
): ApprovalRequest[] {
  const nextPendingIds = new Set(nextPending.map((approval) => approval.id));
  const retainedResolved = existing.filter(
    (approval) => isResolvedStatus(approval.status) && !nextPendingIds.has(approval.id)
  );

  return [...nextPending, ...retainedResolved].sort((left, right) =>
    left.created_at.localeCompare(right.created_at)
  );
}

export function mergeInputs(
  existing: InputRequest[],
  nextPending: InputRequest[]
): InputRequest[] {
  const nextPendingIds = new Set(nextPending.map((input) => input.id));
  const retainedResolved = existing.filter(
    (input) => isResolvedStatus(input.status) && !nextPendingIds.has(input.id)
  );

  return [...nextPending, ...retainedResolved].sort((left, right) =>
    left.created_at.localeCompare(right.created_at)
  );
}

function approvalState(approval: ApprovalRequest): InteractionTimelineItem["state"] {
  switch (approval.status) {
    case "approved":
    case "rejected":
      return "answered";
    case "expired":
    case "cancelled":
      return "expired";
    default:
      return "pending";
  }
}

function inputState(input: InputRequest): InteractionTimelineItem["state"] {
  switch (input.status) {
    case "answered":
      return "answered";
    case "expired":
    case "cancelled":
      return "expired";
    default:
      return "pending";
  }
}

export function buildInteractionTimelineItems(
  source: InteractionTimelineSource
): InteractionTimelineItem[] {
  const items: InteractionTimelineItem[] = [
    ...source.approvals.map((approval) => ({
      id: approval.id,
      kind: "approval" as const,
      state: approvalState(approval),
      ts: approval.resolved_at ?? approval.created_at,
      approval
    })),
    ...source.inputs.map((input) => ({
      id: input.id,
      kind: "input" as const,
      state: inputState(input),
      ts: input.created_at,
      input
    }))
  ];

  return items.sort((left, right) => left.ts.localeCompare(right.ts));
}
