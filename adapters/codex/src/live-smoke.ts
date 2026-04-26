import { createInterface } from "node:readline/promises";

import type {
  ApprovalStatus,
  ArtifactKind,
  Session,
  SessionsGetResult,
  SessionsListResult
} from "ascp-sdk-typescript";

export type LiveSmokeCommand =
  | { mode: "interactive" }
  | { mode: "command"; command: "discover" }
  | { mode: "command"; command: "list"; limit?: number }
  | { mode: "command"; command: "get"; sessionId?: string; includeRuns?: boolean }
  | { mode: "command"; command: "resume"; sessionId?: string }
  | { mode: "command"; command: "send-input"; sessionId?: string; inputText?: string }
  | {
      mode: "command";
      command: "sessions.subscribe";
      sessionId?: string;
      fromSeq?: number;
      fromEventId?: string;
      includeSnapshot?: boolean;
    }
  | { mode: "command"; command: "sessions.unsubscribe"; subscriptionId?: string }
  | {
      mode: "command";
      command: "approvals.list";
      sessionId?: string;
      status?: ApprovalStatus;
      limit?: number;
      cursor?: string;
    }
  | {
      mode: "command";
      command: "approvals.respond";
      approvalId?: string;
      decision?: "approved" | "rejected";
      note?: string;
    }
  | {
      mode: "command";
      command: "artifacts.list";
      sessionId?: string;
      runId?: string;
      kind?: ArtifactKind;
    }
  | { mode: "command"; command: "artifacts.get"; artifactId?: string }
  | { mode: "command"; command: "diffs.get"; sessionId?: string; runId?: string };

export interface LiveSmokeDependencies {
  discover?: () => Promise<unknown>;
  listSessions?: (params: { limit?: number }) => Promise<unknown>;
  getSession?: (params: { session_id: string; include_runs?: boolean }) => Promise<unknown>;
  resumeSession?: (params: { session_id: string }) => Promise<unknown>;
  sendInput?: (params: { session_id: string; input: string }) => Promise<unknown>;
  subscribeSession?: (params: {
    session_id: string;
    from_seq?: number;
    from_event_id?: string;
    include_snapshot?: boolean;
  }) => Promise<unknown>;
  unsubscribeSession?: (params: { subscription_id: string }) => Promise<unknown>;
  listApprovals?: (params: {
    session_id?: string;
    status?: ApprovalStatus;
    limit?: number;
    cursor?: string;
  }) => Promise<unknown>;
  respondApproval?: (params: {
    approval_id: string;
    decision: "approved" | "rejected";
    note?: string;
  }) => Promise<unknown>;
  listArtifacts?: (params: {
    session_id: string;
    run_id?: string;
    kind?: ArtifactKind;
  }) => Promise<unknown>;
  getArtifact?: (params: { artifact_id: string }) => Promise<unknown>;
  getDiff?: (params: { session_id: string; run_id: string }) => Promise<unknown>;
  drainSubscriptionEvents?: (params: { subscription_id: string; limit?: number }) => Promise<unknown> | unknown;
}

export interface LiveSmokeDispatchResult {
  kind:
    | "interactive"
    | "discovery"
    | "list"
    | "get"
    | "resume"
    | "send-input"
    | "sessions.subscribe"
    | "sessions.unsubscribe"
    | "approvals.list"
    | "approvals.respond"
    | "artifacts.list"
    | "artifacts.get"
    | "diffs.get";
  data: unknown;
}

const DEFAULT_LIST_LIMIT = 5;
const SUPPORTED_COMMANDS = [
  "discover",
  "list",
  "get",
  "resume",
  "send-input",
  "sessions.subscribe",
  "sessions.unsubscribe",
  "approvals.list",
  "approvals.respond",
  "artifacts.list",
  "artifacts.get",
  "diffs.get"
] as const;
const APPROVAL_DECISIONS = ["approved", "rejected"] as const;
const APPROVAL_STATUSES: ApprovalStatus[] = [
  "pending",
  "approved",
  "rejected",
  "expired",
  "cancelled"
];

function requireDependency<T extends (...args: never[]) => Promise<unknown>>(
  dependency: T | undefined,
  message: string
): T {
  if (dependency === undefined) {
    throw new Error(message);
  }

  return dependency;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function parseLimit(value: string | undefined): number | undefined {
  if (value === undefined) {
    return undefined;
  }

  const parsed = Number(value);

  return Number.isInteger(parsed) && parsed > 0 ? parsed : undefined;
}

function parseNonNegativeInteger(value: string | undefined): number | undefined {
  if (value === undefined) {
    return undefined;
  }

  const parsed = Number(value);

  return Number.isInteger(parsed) && parsed >= 0 ? parsed : undefined;
}

function readRequiredOptionValue(args: string[], option: string, index: number): string {
  const value = args[index + 1];

  if (value === undefined || value.startsWith("--")) {
    throw new Error(`The ${option} option requires a value.`);
  }

  return value;
}

function parseSendInputText(args: string[]): string | undefined {
  const text = args.join(" ");

  return text.length > 0 ? text : undefined;
}

function parseSessionId(args: string[]): string | undefined {
  if (args.length === 0) {
    return undefined;
  }

  return args[0].startsWith("--") ? undefined : args[0];
}

function expectNoArguments(command: string, args: string[]): void {
  if (args.length > 0) {
    throw new Error(`The ${command} command does not accept arguments.`);
  }
}

function parseListCommand(args: string[]): Extract<LiveSmokeCommand, { command: "list" }> {
  if (args.length === 0) {
    return {
      mode: "command",
      command: "list"
    };
  }

  if (args.length !== 2 || args[0] !== "--limit") {
    throw new Error(`Unsupported arguments for list: ${args.join(" ")}`);
  }

  const limit = parseLimit(args[1]);

  if (limit === undefined) {
    throw new Error("The --limit option requires a positive integer.");
  }

  return {
    mode: "command",
    command: "list",
    limit
  };
}

function parseGetCommand(args: string[]): Extract<LiveSmokeCommand, { command: "get" }> {
  const sessionId = parseSessionId(args);
  const remainder = sessionId === undefined ? args : args.slice(1);

  for (const arg of remainder) {
    if (arg !== "--runs") {
      throw new Error(`Unsupported option for get: ${arg}`);
    }
  }

  return {
    mode: "command",
    command: "get",
    sessionId,
    includeRuns: remainder.includes("--runs") ? true : undefined
  };
}

function parseResumeCommand(args: string[]): Extract<LiveSmokeCommand, { command: "resume" }> {
  const sessionId = parseSessionId(args);
  const remainder = sessionId === undefined ? args : args.slice(1);

  if (remainder.length === 0) {
    return {
      mode: "command",
      command: "resume",
      sessionId
    };
  }

  if (remainder[0]?.startsWith("--")) {
    throw new Error(`Unsupported option for resume: ${remainder[0]}`);
  }

  throw new Error("The resume command does not accept extra positional arguments.");
}

function parseSubscribeCommand(args: string[]): Extract<LiveSmokeCommand, { command: "sessions.subscribe" }> {
  let sessionId: string | undefined;
  let fromSeq: number | undefined;
  let fromEventId: string | undefined;
  let includeSnapshot = false;

  for (let index = 0; index < args.length; index += 1) {
    const token = args[index];

    if (token === "--from-seq") {
      const parsed = parseNonNegativeInteger(readRequiredOptionValue(args, "--from-seq", index));

      if (parsed === undefined) {
        throw new Error("The --from-seq option requires a non-negative integer.");
      }

      fromSeq = parsed;
      index += 1;
      continue;
    }

    if (token === "--from-event-id") {
      fromEventId = readRequiredOptionValue(args, "--from-event-id", index);
      index += 1;
      continue;
    }

    if (token === "--session-id") {
      sessionId = readRequiredOptionValue(args, "--session-id", index);
      index += 1;
      continue;
    }

    if (token === "--snapshot") {
      includeSnapshot = true;
      continue;
    }

    if (token.startsWith("--")) {
      throw new Error(`Unsupported option for sessions.subscribe: ${token}`);
    }

    if (sessionId !== undefined) {
      throw new Error("The sessions.subscribe command does not accept extra positional arguments.");
    }

    sessionId = token;
  }

  return {
    mode: "command",
    command: "sessions.subscribe",
    sessionId,
    fromSeq,
    fromEventId,
    includeSnapshot: includeSnapshot ? true : undefined
  };
}

function parseUnsubscribeCommand(args: string[]): Extract<LiveSmokeCommand, { command: "sessions.unsubscribe" }> {
  const subscriptionId = parseSessionId(args);
  const remainder = subscriptionId === undefined ? args : args.slice(1);

  if (remainder.length === 0) {
    return {
      mode: "command",
      command: "sessions.unsubscribe",
      subscriptionId
    };
  }

  if (remainder[0]?.startsWith("--")) {
    throw new Error(`Unsupported option for sessions.unsubscribe: ${remainder[0]}`);
  }

  throw new Error("The sessions.unsubscribe command does not accept extra positional arguments.");
}

function parseApprovalsListCommand(args: string[]): Extract<LiveSmokeCommand, { command: "approvals.list" }> {
  let sessionId: string | undefined;
  let status: ApprovalStatus | undefined;
  let limit: number | undefined;
  let cursor: string | undefined;

  for (let index = 0; index < args.length; index += 1) {
    const token = args[index];

    if (token === "--session-id") {
      sessionId = readRequiredOptionValue(args, "--session-id", index);
      index += 1;
      continue;
    }

    if (token === "--status") {
      const value = readRequiredOptionValue(args, "--status", index);

      if (!APPROVAL_STATUSES.includes(value as ApprovalStatus)) {
        throw new Error(`Unsupported approval status: ${value}`);
      }

      status = value as ApprovalStatus;
      index += 1;
      continue;
    }

    if (token === "--limit") {
      const parsed = parseLimit(readRequiredOptionValue(args, "--limit", index));

      if (parsed === undefined) {
        throw new Error("The --limit option requires a positive integer.");
      }

      limit = parsed;
      index += 1;
      continue;
    }

    if (token === "--cursor") {
      cursor = readRequiredOptionValue(args, "--cursor", index);
      index += 1;
      continue;
    }

    if (token.startsWith("--")) {
      throw new Error(`Unsupported option for approvals.list: ${token}`);
    }

    if (sessionId !== undefined) {
      throw new Error("The approvals.list command does not accept extra positional arguments.");
    }

    sessionId = token;
  }

  return {
    mode: "command",
    command: "approvals.list",
    sessionId,
    status,
    limit,
    cursor
  };
}

function parseApprovalsRespondCommand(args: string[]): Extract<LiveSmokeCommand, { command: "approvals.respond" }> {
  let approvalId: string | undefined;
  let decision: "approved" | "rejected" | undefined;
  const noteParts: string[] = [];

  for (let index = 0; index < args.length; index += 1) {
    const token = args[index];

    if (token === "--note") {
      noteParts.push(readRequiredOptionValue(args, "--note", index));
      index += 1;
      continue;
    }

    if (token.startsWith("--")) {
      throw new Error(`Unsupported option for approvals.respond: ${token}`);
    }

    if (approvalId === undefined) {
      approvalId = token;
      continue;
    }

    if (decision === undefined) {
      if (!APPROVAL_DECISIONS.includes(token as (typeof APPROVAL_DECISIONS)[number])) {
        throw new Error(`Unsupported approval decision: ${token}`);
      }

      decision = token as "approved" | "rejected";
      continue;
    }

    noteParts.push(token);
  }

  return {
    mode: "command",
    command: "approvals.respond",
    approvalId,
    decision,
    note: noteParts.length === 0 ? undefined : noteParts.join(" ")
  };
}

function parseArtifactsListCommand(args: string[]): Extract<LiveSmokeCommand, { command: "artifacts.list" }> {
  let sessionId: string | undefined;
  let runId: string | undefined;
  let kind: ArtifactKind | undefined;

  for (let index = 0; index < args.length; index += 1) {
    const token = args[index];

    if (token === "--session-id") {
      sessionId = readRequiredOptionValue(args, "--session-id", index);
      index += 1;
      continue;
    }

    if (token === "--run-id") {
      runId = readRequiredOptionValue(args, "--run-id", index);
      index += 1;
      continue;
    }

    if (token === "--kind") {
      kind = readRequiredOptionValue(args, "--kind", index) as ArtifactKind;
      index += 1;
      continue;
    }

    if (token.startsWith("--")) {
      throw new Error(`Unsupported option for artifacts.list: ${token}`);
    }

    if (sessionId !== undefined) {
      throw new Error("The artifacts.list command does not accept extra positional arguments.");
    }

    sessionId = token;
  }

  return {
    mode: "command",
    command: "artifacts.list",
    sessionId,
    runId,
    kind
  };
}

function parseArtifactsGetCommand(args: string[]): Extract<LiveSmokeCommand, { command: "artifacts.get" }> {
  const artifactId = parseSessionId(args);
  const remainder = artifactId === undefined ? args : args.slice(1);

  if (remainder.length === 0) {
    return {
      mode: "command",
      command: "artifacts.get",
      artifactId
    };
  }

  if (remainder[0]?.startsWith("--")) {
    throw new Error(`Unsupported option for artifacts.get: ${remainder[0]}`);
  }

  throw new Error("The artifacts.get command does not accept extra positional arguments.");
}

function parseDiffsGetCommand(args: string[]): Extract<LiveSmokeCommand, { command: "diffs.get" }> {
  let sessionId: string | undefined;
  let runId: string | undefined;

  for (let index = 0; index < args.length; index += 1) {
    const token = args[index];

    if (token === "--session-id") {
      sessionId = readRequiredOptionValue(args, "--session-id", index);
      index += 1;
      continue;
    }

    if (token === "--run-id") {
      runId = readRequiredOptionValue(args, "--run-id", index);
      index += 1;
      continue;
    }

    if (token.startsWith("--")) {
      throw new Error(`Unsupported option for diffs.get: ${token}`);
    }

    if (sessionId === undefined) {
      sessionId = token;
      continue;
    }

    if (runId === undefined) {
      runId = token;
      continue;
    }

    throw new Error("The diffs.get command does not accept extra positional arguments.");
  }

  return {
    mode: "command",
    command: "diffs.get",
    sessionId,
    runId
  };
}

function writeLine(output: NodeJS.WritableStream, line = ""): void {
  output.write(`${line}\n`);
}

function stringifyValue(value: unknown): string {
  return JSON.stringify(value, null, 2);
}

function asSessionsListResult(value: unknown): SessionsListResult | undefined {
  if (!isRecord(value) || !Array.isArray(value.sessions)) {
    return undefined;
  }

  return value as SessionsListResult;
}

function asSessionsGetResult(value: unknown): SessionsGetResult | undefined {
  if (!isRecord(value) || !isRecord(value.session)) {
    return undefined;
  }

  return value as SessionsGetResult;
}

function isUnavailableDiscovery(value: unknown): boolean {
  return isRecord(value) && value.runtimeAvailable === false;
}

function renderCompactSessionSummary(session: Session, index?: number): string {
  const prefix = index === undefined ? "-" : `${index + 1}.`;
  const title = session.title ?? "(untitled)";
  const activity = session.last_activity_at ?? session.updated_at;

  return `${prefix} ${session.id} [${session.status}] ${title} @ ${activity}`;
}

function readStringField(value: unknown, key: string): string | undefined {
  if (!isRecord(value)) {
    return undefined;
  }

  const fieldValue = value[key];

  return typeof fieldValue === "string" ? fieldValue : undefined;
}

function renderLiveSmokeValue(result: LiveSmokeDispatchResult): string {
  switch (result.kind) {
    case "discovery":
      return stringifyValue(result.data);
    case "list": {
      const response = asSessionsListResult(result.data);

      if (response === undefined) {
        return stringifyValue(result.data);
      }

      if (response.sessions.length === 0) {
        return "No sessions found.";
      }

      return response.sessions.map((session, index) => renderCompactSessionSummary(session, index)).join("\n");
    }
    case "get": {
      const response = asSessionsGetResult(result.data);

      if (response === undefined) {
        return stringifyValue(result.data);
      }

      const lines = [renderCompactSessionSummary(response.session)];

      if (Array.isArray(response.runs)) {
        lines.push(`runs: ${response.runs.length}`);
      }

      if (Array.isArray(response.pending_approvals)) {
        lines.push(`pending_approvals: ${response.pending_approvals.length}`);
      }

      lines.push(stringifyValue(result.data));
      return lines.join("\n");
    }
    case "resume":
    case "send-input":
    case "sessions.subscribe":
    case "sessions.unsubscribe":
    case "approvals.list":
    case "approvals.respond":
    case "artifacts.list":
    case "artifacts.get":
    case "diffs.get":
      return stringifyValue(result.data);
    case "interactive":
      return "Interactive mode selected.";
  }
}

async function promptForChoice(
  prompt: string,
  ask: (promptText: string) => Promise<string>
): Promise<string> {
  return (await ask(prompt)).trim();
}

async function confirmMutatingAction(
  ask: (promptText: string) => Promise<string>,
  prompt: string
): Promise<boolean> {
  const answer = (await ask(`${prompt} [y/N] `)).trim().toLowerCase();
  return answer === "y" || answer === "yes";
}

async function chooseSession(
  ask: (promptText: string) => Promise<string>,
  output: NodeJS.WritableStream,
  sessions: Session[]
): Promise<Session | "refresh" | "quit"> {
  writeLine(output, "");
  writeLine(output, "Recent sessions:");

  for (const [index, session] of sessions.entries()) {
    writeLine(output, renderCompactSessionSummary(session, index));
  }

  writeLine(output, "");
  writeLine(output, "Choose a session number, `r` to refresh, or `q` to quit.");

  const answer = await promptForChoice("> ", ask);

  if (answer === "q") {
    return "quit";
  }

  if (answer === "r") {
    return "refresh";
  }

  const index = Number(answer);

  if (!Number.isInteger(index) || index < 1 || index > sessions.length) {
    writeLine(output, "Invalid selection.");
    return "refresh";
  }

  return sessions[index - 1];
}

export async function runInteractiveSessionMenu(
  ask: (promptText: string) => Promise<string>,
  output: NodeJS.WritableStream,
  session: Session,
  deps: LiveSmokeDependencies
): Promise<"back" | "quit"> {
  while (true) {
    writeLine(output, "");
    writeLine(output, `Selected ${session.id}`);
    writeLine(
      output,
      "Actions: `g` get, `r` resume, `s` send input, `p` subscribe+drain, `a` approvals, `t` artifacts, `d` diff, `b` back, `q` quit."
    );

    const action = await promptForChoice("> ", ask);

    if (action === "b") {
      return "back";
    }

    if (action === "q") {
      return "quit";
    }

    if (action === "g") {
      try {
        const includeRuns = await confirmMutatingAction(ask, "Include runs in the session read?");
        const result = await runLiveSmokeCommand(
          {
            mode: "command",
            command: "get",
            sessionId: session.id,
            includeRuns
          },
          deps
        );
        writeLine(output, renderLiveSmokeValue(result));
      } catch (error) {
        writeLine(output, `Action failed: ${error instanceof Error ? error.message : String(error)}`);
      }
      continue;
    }

    if (action === "r") {
      const confirmed = await confirmMutatingAction(
        ask,
        `Resume session ${session.id}?`
      );

      if (!confirmed) {
        writeLine(output, "Resume cancelled.");
        continue;
      }

      try {
        const result = await runLiveSmokeCommand(
          {
            mode: "command",
            command: "resume",
            sessionId: session.id
          },
          deps
        );
        writeLine(output, renderLiveSmokeValue(result));
      } catch (error) {
        writeLine(output, `Action failed: ${error instanceof Error ? error.message : String(error)}`);
      }
      continue;
    }

    if (action === "s") {
      const inputText = await promptForChoice("Input text: ", ask);

      if (inputText.length === 0) {
        writeLine(output, "Send input cancelled.");
        continue;
      }

      const confirmed = await confirmMutatingAction(
        ask,
        `Send input to session ${session.id}?`
      );

      if (!confirmed) {
        writeLine(output, "Send input cancelled.");
        continue;
      }

      try {
        const result = await runLiveSmokeCommand(
          {
            mode: "command",
            command: "send-input",
            sessionId: session.id,
            inputText
          },
          deps
        );
        writeLine(output, renderLiveSmokeValue(result));
      } catch (error) {
        writeLine(output, `Action failed: ${error instanceof Error ? error.message : String(error)}`);
      }
      continue;
    }

    if (action === "p") {
      const includeSnapshot = await confirmMutatingAction(ask, "Include snapshot in subscription?");
      const fromSeqInput = await promptForChoice("Replay from seq (blank for none): ", ask);
      const fromEventIdInput = await promptForChoice("Replay from event id (blank for none): ", ask);
      const fromSeq =
        fromSeqInput.length === 0 ? undefined : parseNonNegativeInteger(fromSeqInput);
      const fromEventId = fromEventIdInput.length === 0 ? undefined : fromEventIdInput;

      if (fromSeqInput.length > 0 && fromSeq === undefined) {
        writeLine(output, "The replay sequence must be a non-negative integer.");
        continue;
      }

      try {
        const subscribeResult = await runLiveSmokeCommand(
          {
            mode: "command",
            command: "sessions.subscribe",
            sessionId: session.id,
            fromSeq,
            fromEventId,
            includeSnapshot
          },
          deps
        );
        writeLine(output, renderLiveSmokeValue(subscribeResult));

        const subscriptionId = readStringField(subscribeResult.data, "subscription_id");

        if (subscriptionId === undefined) {
          writeLine(output, "No subscription id returned; skipping event drain.");
          continue;
        }

        const drainInput = await promptForChoice("Drain event count (blank=all, 0=skip): ", ask);

        if (drainInput !== "0") {
          const drainLimit =
            drainInput.length === 0 ? undefined : parseLimit(drainInput);

          if (drainInput.length > 0 && drainLimit === undefined) {
            writeLine(output, "Drain count must be a positive integer, 0, or blank.");
          } else if (deps.drainSubscriptionEvents === undefined) {
            writeLine(output, "Event drain dependency is unavailable.");
          } else {
            const drainedEvents = await Promise.resolve(
              deps.drainSubscriptionEvents({
                subscription_id: subscriptionId,
                limit: drainLimit
              })
            );
            writeLine(output, stringifyValue(drainedEvents));
          }
        }

        const shouldUnsubscribe = await confirmMutatingAction(
          ask,
          `Unsubscribe ${subscriptionId}?`
        );

        if (shouldUnsubscribe) {
          const unsubscribeResult = await runLiveSmokeCommand(
            {
              mode: "command",
              command: "sessions.unsubscribe",
              subscriptionId
            },
            deps
          );
          writeLine(output, renderLiveSmokeValue(unsubscribeResult));
        }
      } catch (error) {
        writeLine(output, `Action failed: ${error instanceof Error ? error.message : String(error)}`);
      }
      continue;
    }

    if (action === "a") {
      const statusInput = await promptForChoice("Status filter (blank for all): ", ask);
      const status = statusInput.length === 0 ? undefined : statusInput;

      if (status !== undefined && !APPROVAL_STATUSES.includes(status as ApprovalStatus)) {
        writeLine(output, `Unsupported approval status: ${status}`);
        continue;
      }

      try {
        const listResult = await runLiveSmokeCommand(
          {
            mode: "command",
            command: "approvals.list",
            sessionId: session.id,
            status: status as ApprovalStatus | undefined
          },
          deps
        );
        writeLine(output, renderLiveSmokeValue(listResult));

        const approvalId = await promptForChoice("Approval id to respond (blank to skip): ", ask);

        if (approvalId.length === 0) {
          continue;
        }

        const decision = await promptForChoice("Decision (`approved` or `rejected`): ", ask);

        if (!APPROVAL_DECISIONS.includes(decision as (typeof APPROVAL_DECISIONS)[number])) {
          writeLine(output, `Unsupported approval decision: ${decision}`);
          continue;
        }

        const note = await promptForChoice("Optional note (blank for none): ", ask);
        const confirmed = await confirmMutatingAction(
          ask,
          `Respond to approval ${approvalId} as ${decision}?`
        );

        if (!confirmed) {
          writeLine(output, "Approval response cancelled.");
          continue;
        }

        const respondResult = await runLiveSmokeCommand(
          {
            mode: "command",
            command: "approvals.respond",
            approvalId,
            decision: decision as "approved" | "rejected",
            note: note.length === 0 ? undefined : note
          },
          deps
        );
        writeLine(output, renderLiveSmokeValue(respondResult));
      } catch (error) {
        writeLine(output, `Action failed: ${error instanceof Error ? error.message : String(error)}`);
      }
      continue;
    }

    if (action === "t") {
      const runId = await promptForChoice("Run id filter (blank for all runs): ", ask);
      const kind = await promptForChoice("Artifact kind filter (blank for all): ", ask);

      try {
        const listResult = await runLiveSmokeCommand(
          {
            mode: "command",
            command: "artifacts.list",
            sessionId: session.id,
            runId: runId.length === 0 ? undefined : runId,
            kind: kind.length === 0 ? undefined : (kind as ArtifactKind)
          },
          deps
        );
        writeLine(output, renderLiveSmokeValue(listResult));

        const artifactId = await promptForChoice("Artifact id to fetch (blank to skip): ", ask);

        if (artifactId.length === 0) {
          continue;
        }

        const artifactResult = await runLiveSmokeCommand(
          {
            mode: "command",
            command: "artifacts.get",
            artifactId
          },
          deps
        );
        writeLine(output, renderLiveSmokeValue(artifactResult));
      } catch (error) {
        writeLine(output, `Action failed: ${error instanceof Error ? error.message : String(error)}`);
      }
      continue;
    }

    if (action === "d") {
      const runId = await promptForChoice("Run id for diff: ", ask);

      if (runId.length === 0) {
        writeLine(output, "Diff lookup cancelled.");
        continue;
      }

      try {
        const diffResult = await runLiveSmokeCommand(
          {
            mode: "command",
            command: "diffs.get",
            sessionId: session.id,
            runId
          },
          deps
        );
        writeLine(output, renderLiveSmokeValue(diffResult));
      } catch (error) {
        writeLine(output, `Action failed: ${error instanceof Error ? error.message : String(error)}`);
      }
      continue;
    }

    writeLine(output, "Unsupported action.");
  }
}

export function getLiveSmokeUsage(): string {
  return [
    "Codex live smoke script",
    "",
    "Usage:",
    "  npm --workspace @ascp/adapter-codex run live",
    "  npm --workspace @ascp/adapter-codex run live -- discover",
    "  npm --workspace @ascp/adapter-codex run live -- list --limit 5",
    "  npm --workspace @ascp/adapter-codex run live -- get codex:thread_id --runs",
    "  npm --workspace @ascp/adapter-codex run live -- resume codex:thread_id",
    "  npm --workspace @ascp/adapter-codex run live -- send-input codex:thread_id continue",
    "  npm --workspace @ascp/adapter-codex run live -- sessions.subscribe codex:thread_id --snapshot --from-seq 12",
    "  npm --workspace @ascp/adapter-codex run live -- sessions.unsubscribe codex:subscription:thread:1",
    "  npm --workspace @ascp/adapter-codex run live -- approvals.list --session-id codex:thread_id --status pending",
    "  npm --workspace @ascp/adapter-codex run live -- approvals.respond codex:approval_1 approved --note approved_in_smoke",
    "  npm --workspace @ascp/adapter-codex run live -- artifacts.list codex:thread_id --run-id codex:run_1 --kind diff",
    "  npm --workspace @ascp/adapter-codex run live -- artifacts.get codex:artifact_1",
    "  npm --workspace @ascp/adapter-codex run live -- diffs.get codex:thread_id codex:run_1",
    "",
    `Supported commands: ${SUPPORTED_COMMANDS.join(", ")}`,
    "Aliases: subscribe, unsubscribe, approvals-list, approvals-respond, artifacts-list, artifacts-get, diffs-get"
  ].join("\n");
}

export function parseLiveSmokeCommand(argv: string[]): LiveSmokeCommand {
  if (argv.length === 0) {
    return { mode: "interactive" };
  }

  const [command, ...rest] = argv;

  switch (command) {
    case "discover":
      expectNoArguments(command, rest);
      return {
        mode: "command",
        command: "discover"
      };
    case "list":
      return parseListCommand(rest);
    case "get":
      return parseGetCommand(rest);
    case "resume":
      return parseResumeCommand(rest);
    case "send-input":
      return {
        mode: "command",
        command: "send-input",
        sessionId: parseSessionId(rest),
        inputText: parseSendInputText(rest.slice(1))
      };
    case "sessions.subscribe":
    case "subscribe":
      return parseSubscribeCommand(rest);
    case "sessions.unsubscribe":
    case "unsubscribe":
      return parseUnsubscribeCommand(rest);
    case "approvals.list":
    case "approvals-list":
      return parseApprovalsListCommand(rest);
    case "approvals.respond":
    case "approvals-respond":
      return parseApprovalsRespondCommand(rest);
    case "artifacts.list":
    case "artifacts-list":
      return parseArtifactsListCommand(rest);
    case "artifacts.get":
    case "artifacts-get":
      return parseArtifactsGetCommand(rest);
    case "diffs.get":
    case "diffs-get":
      return parseDiffsGetCommand(rest);
    default:
      throw new Error(`Unsupported live smoke command: ${command}`);
  }
}

export function validateLiveSmokeCommand(command: LiveSmokeCommand): LiveSmokeCommand {
  if (command.mode !== "command") {
    return command;
  }

  switch (command.command) {
    case "discover":
    case "list":
    case "approvals.list":
      return command;
    case "get":
      if (command.sessionId === undefined) {
        throw new Error("The get command requires a session_id.");
      }
      return command;
    case "resume":
      if (command.sessionId === undefined) {
        throw new Error("The resume command requires a session_id.");
      }
      return command;
    case "send-input":
      if (command.sessionId === undefined) {
        throw new Error("The send-input command requires a session_id.");
      }

      if (command.inputText === undefined) {
        throw new Error("The send-input command requires input text.");
      }
      return command;
    case "sessions.subscribe":
      if (command.sessionId === undefined) {
        throw new Error("The sessions.subscribe command requires a session_id.");
      }
      return command;
    case "sessions.unsubscribe":
      if (command.subscriptionId === undefined) {
        throw new Error("The sessions.unsubscribe command requires a subscription_id.");
      }
      return command;
    case "approvals.respond":
      if (command.approvalId === undefined) {
        throw new Error("The approvals.respond command requires an approval_id.");
      }

      if (command.decision === undefined) {
        throw new Error("The approvals.respond command requires a decision.");
      }
      return command;
    case "artifacts.list":
      if (command.sessionId === undefined) {
        throw new Error("The artifacts.list command requires a session_id.");
      }
      return command;
    case "artifacts.get":
      if (command.artifactId === undefined) {
        throw new Error("The artifacts.get command requires an artifact_id.");
      }
      return command;
    case "diffs.get":
      if (command.sessionId === undefined) {
        throw new Error("The diffs.get command requires a session_id.");
      }

      if (command.runId === undefined) {
        throw new Error("The diffs.get command requires a run_id.");
      }
      return command;
  }
}

export async function runLiveSmokeCommand(
  command: LiveSmokeCommand,
  deps: LiveSmokeDependencies
): Promise<LiveSmokeDispatchResult> {
  if (command.mode !== "command") {
    return {
      kind: "interactive",
      data: null
    };
  }

  validateLiveSmokeCommand(command);

  switch (command.command) {
    case "discover":
      return {
        kind: "discovery",
        data: await requireDependency(deps.discover, "The discover command requires a discover dependency.")()
      };
    case "list":
      return {
        kind: "list",
        data: await requireDependency(
          deps.listSessions,
          "The list command requires a listSessions dependency."
        )({ limit: command.limit })
      };
    case "get":
      if (command.sessionId === undefined) {
        throw new Error("The get command requires a session_id.");
      }

      return {
        kind: "get",
        data: await requireDependency(
          deps.getSession,
          "The get command requires a getSession dependency."
        )({
          session_id: command.sessionId,
          include_runs: command.includeRuns
        })
      };
    case "resume":
      if (command.sessionId === undefined) {
        throw new Error("The resume command requires a session_id.");
      }

      return {
        kind: "resume",
        data: await requireDependency(
          deps.resumeSession,
          "The resume command requires a resumeSession dependency."
        )({
          session_id: command.sessionId
        })
      };
    case "send-input":
      if (command.sessionId === undefined) {
        throw new Error("The send-input command requires a session_id.");
      }

      if (command.inputText === undefined) {
        throw new Error("The send-input command requires input text.");
      }

      return {
        kind: "send-input",
        data: await requireDependency(
          deps.sendInput,
          "The send-input command requires a sendInput dependency."
        )({
          session_id: command.sessionId,
          input: command.inputText
        })
      };
    case "sessions.subscribe":
      if (command.sessionId === undefined) {
        throw new Error("The sessions.subscribe command requires a session_id.");
      }

      return {
        kind: "sessions.subscribe",
        data: await requireDependency(
          deps.subscribeSession,
          "The sessions.subscribe command requires a subscribeSession dependency."
        )({
          session_id: command.sessionId,
          from_seq: command.fromSeq,
          from_event_id: command.fromEventId,
          include_snapshot: command.includeSnapshot
        })
      };
    case "sessions.unsubscribe":
      if (command.subscriptionId === undefined) {
        throw new Error("The sessions.unsubscribe command requires a subscription_id.");
      }

      return {
        kind: "sessions.unsubscribe",
        data: await requireDependency(
          deps.unsubscribeSession,
          "The sessions.unsubscribe command requires an unsubscribeSession dependency."
        )({
          subscription_id: command.subscriptionId
        })
      };
    case "approvals.list":
      return {
        kind: "approvals.list",
        data: await requireDependency(
          deps.listApprovals,
          "The approvals.list command requires a listApprovals dependency."
        )({
          session_id: command.sessionId,
          status: command.status,
          limit: command.limit,
          cursor: command.cursor
        })
      };
    case "approvals.respond":
      if (command.approvalId === undefined) {
        throw new Error("The approvals.respond command requires an approval_id.");
      }

      if (command.decision === undefined) {
        throw new Error("The approvals.respond command requires a decision.");
      }

      return {
        kind: "approvals.respond",
        data: await requireDependency(
          deps.respondApproval,
          "The approvals.respond command requires a respondApproval dependency."
        )({
          approval_id: command.approvalId,
          decision: command.decision,
          note: command.note
        })
      };
    case "artifacts.list":
      if (command.sessionId === undefined) {
        throw new Error("The artifacts.list command requires a session_id.");
      }

      return {
        kind: "artifacts.list",
        data: await requireDependency(
          deps.listArtifacts,
          "The artifacts.list command requires a listArtifacts dependency."
        )({
          session_id: command.sessionId,
          run_id: command.runId,
          kind: command.kind
        })
      };
    case "artifacts.get":
      if (command.artifactId === undefined) {
        throw new Error("The artifacts.get command requires an artifact_id.");
      }

      return {
        kind: "artifacts.get",
        data: await requireDependency(
          deps.getArtifact,
          "The artifacts.get command requires a getArtifact dependency."
        )({
          artifact_id: command.artifactId
        })
      };
    case "diffs.get":
      if (command.sessionId === undefined) {
        throw new Error("The diffs.get command requires a session_id.");
      }

      if (command.runId === undefined) {
        throw new Error("The diffs.get command requires a run_id.");
      }

      return {
        kind: "diffs.get",
        data: await requireDependency(
          deps.getDiff,
          "The diffs.get command requires a getDiff dependency."
        )({
          session_id: command.sessionId,
          run_id: command.runId
        })
      };
  }
}

export function writeLiveSmokeResult(
  output: NodeJS.WritableStream,
  result: LiveSmokeDispatchResult
): void {
  writeLine(output, renderLiveSmokeValue(result));
}

export async function runInteractiveLiveSmoke(options: {
  input: NodeJS.ReadableStream;
  output: NodeJS.WritableStream;
  deps: LiveSmokeDependencies;
}): Promise<void> {
  const readline = createInterface({
    input: options.input,
    output: options.output
  });

  try {
    const ask = async (promptText: string): Promise<string> => readline.question(promptText);

    writeLine(options.output, "Codex adapter interactive smoke test");
    writeLine(options.output, "Session menu includes subscribe/replay, approvals, artifacts, and diffs actions.");
    writeLine(options.output, "");

    const discoveryResult = await runLiveSmokeCommand(
      {
        mode: "command",
        command: "discover"
      },
      options.deps
    );
    writeLine(options.output, renderLiveSmokeValue(discoveryResult));

    if (isUnavailableDiscovery(discoveryResult.data)) {
      writeLine(options.output, "Codex runtime is unavailable. Exiting interactive smoke test.");
      return;
    }

    while (true) {
      const listResult = await runLiveSmokeCommand(
        {
          mode: "command",
          command: "list",
          limit: DEFAULT_LIST_LIMIT
        },
        options.deps
      );
      const listResponse = asSessionsListResult(listResult.data);

      if (listResponse === undefined) {
        writeLine(options.output, stringifyValue(listResult.data));
        return;
      }

      if (listResponse.sessions.length === 0) {
        writeLine(options.output, "No sessions available for interactive actions.");
        return;
      }

      const selection = await chooseSession(ask, options.output, listResponse.sessions);

      if (selection === "quit") {
        return;
      }

      if (selection === "refresh") {
        continue;
      }

      const action = await runInteractiveSessionMenu(ask, options.output, selection, options.deps);

      if (action === "quit") {
        return;
      }
    }
  } finally {
    readline.close();
  }
}
