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

function requireDependency<T extends (...args: never[]) => Promise<unknown>>(
  dependency: T | undefined,
  message: string
): T {
  if (dependency === undefined) {
    throw new Error(message);
  }

  return dependency;
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
