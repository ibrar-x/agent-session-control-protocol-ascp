export type LiveSmokeCommand =
  | { mode: "interactive" }
  | { mode: "command"; command: "discover" }
  | { mode: "command"; command: "list"; limit?: number }
  | { mode: "command"; command: "get"; sessionId?: string; includeRuns?: boolean }
  | { mode: "command"; command: "resume"; sessionId?: string }
  | { mode: "command"; command: "send-input"; sessionId?: string; inputText?: string };

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
