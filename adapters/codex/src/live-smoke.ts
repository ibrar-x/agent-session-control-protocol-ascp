import { createInterface } from "node:readline/promises";

import type { Session, SessionsGetResult, SessionsListResult } from "ascp-sdk-typescript";

export type LiveSmokeCommand =
  | { mode: "interactive" }
  | { mode: "command"; command: "discover" }
  | { mode: "command"; command: "list"; limit?: number }
  | { mode: "command"; command: "get"; sessionId?: string; includeRuns?: boolean }
  | { mode: "command"; command: "resume"; sessionId?: string }
  | { mode: "command"; command: "send-input"; sessionId?: string; inputText?: string };

export interface LiveSmokeDependencies {
  discover?: () => Promise<unknown>;
  listSessions?: (params: { limit?: number }) => Promise<unknown>;
  getSession?: (params: { session_id: string; include_runs?: boolean }) => Promise<unknown>;
  resumeSession?: (params: { session_id: string }) => Promise<unknown>;
  sendInput?: (params: { session_id: string; input: string }) => Promise<unknown>;
}

export interface LiveSmokeDispatchResult {
  kind: "interactive" | "discovery" | "list" | "get" | "resume" | "send-input";
  data: unknown;
}

const DEFAULT_LIST_LIMIT = 5;
const SUPPORTED_COMMANDS = ["discover", "list", "get", "resume", "send-input"] as const;
const UNSUPPORTED_FEATURE_NOTE =
  "Unsupported here: subscribe/unsubscribe, replay streams, artifacts, diffs, approvals.";

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

function readOptionValue(args: string[], option: string): string | undefined {
  for (let index = 0; index < args.length; index += 1) {
    if (args[index] === option) {
      return args[index + 1];
    }
  }

  return undefined;
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

async function handleInteractiveSession(
  ask: (promptText: string) => Promise<string>,
  output: NodeJS.WritableStream,
  session: Session,
  deps: LiveSmokeDependencies
): Promise<"back" | "quit"> {
  while (true) {
    writeLine(output, "");
    writeLine(output, `Selected ${session.id}`);
    writeLine(output, "Actions: `g` get, `r` resume, `s` send input, `b` back, `q` quit.");
    writeLine(output, UNSUPPORTED_FEATURE_NOTE);

    const action = await promptForChoice("> ", ask);

    if (action === "b") {
      return "back";
    }

    if (action === "q") {
      return "quit";
    }

    if (action === "g") {
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

      const result = await runLiveSmokeCommand(
        {
          mode: "command",
          command: "resume",
          sessionId: session.id
        },
        deps
      );
      writeLine(output, renderLiveSmokeValue(result));
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
    "",
    `Supported commands: ${SUPPORTED_COMMANDS.join(", ")}`,
    UNSUPPORTED_FEATURE_NOTE
  ].join("\n");
}

export function parseLiveSmokeCommand(argv: string[]): LiveSmokeCommand {
  if (argv.length === 0) {
    return { mode: "interactive" };
  }

  const [command, ...rest] = argv;

  switch (command) {
    case "discover":
      return {
        mode: "command",
        command: "discover"
      };
    case "list":
      return {
        mode: "command",
        command: "list",
        limit: parseLimit(readOptionValue(rest, "--limit"))
      };
    case "get":
      return {
        mode: "command",
        command: "get",
        sessionId: parseSessionId(rest),
        includeRuns: rest.includes("--runs") ? true : undefined
      };
    case "resume":
      return {
        mode: "command",
        command: "resume",
        sessionId: parseSessionId(rest)
      };
    case "send-input":
      return {
        mode: "command",
        command: "send-input",
        sessionId: parseSessionId(rest),
        inputText: parseSendInputText(rest.slice(1))
      };
    default:
      throw new Error(`Unsupported live smoke command: ${command}`);
  }
}

export function validateLiveSmokeCommand(command: LiveSmokeCommand): LiveSmokeCommand {
  if (command.mode !== "command") {
    return command;
  }

  if (command.command === "get" && command.sessionId === undefined) {
    throw new Error("The get command requires a session_id.");
  }

  if (command.command === "resume" && command.sessionId === undefined) {
    throw new Error("The resume command requires a session_id.");
  }

  if (command.command === "send-input" && command.sessionId === undefined) {
    throw new Error("The send-input command requires a session_id.");
  }

  if (command.command === "send-input" && command.inputText === undefined) {
    throw new Error("The send-input command requires input text.");
  }

  return command;
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
    writeLine(options.output, UNSUPPORTED_FEATURE_NOTE);
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

      const action = await handleInteractiveSession(ask, options.output, selection, options.deps);

      if (action === "quit") {
        return;
      }
    }
  } finally {
    readline.close();
  }
}
