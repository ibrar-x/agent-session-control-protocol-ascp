#!/usr/bin/env node

import {
  getLiveSmokeUsage,
  parseLiveSmokeCommand,
  runInteractiveLiveSmoke,
  runLiveSmokeWatch,
  runLiveSmokeCommand,
  validateLiveSmokeCommand,
  writeLiveSmokeResult
} from "../dist/live-smoke.js";
import {
  CodexAdapterService,
  CodexAppServerClient,
  discoverCodexRuntime
} from "../dist/index.js";

const argv = process.argv.slice(2);

if (argv.length > 0 && (argv[0] === "help" || argv[0] === "--help" || argv[0] === "-h")) {
  process.stdout.write(`${getLiveSmokeUsage()}\n`);
  process.exit(0);
}

const client = new CodexAppServerClient();
const service = new CodexAdapterService(client);
const subscribeSession = (params) => service.sessionsSubscribe(params);
const unsubscribeSession = (params) => service.sessionsUnsubscribe(params);
const listApprovals = (params) => service.approvalsList(params);
const respondApproval = (params) => service.approvalsRespond(params);
const listArtifacts = (params) => service.artifactsList(params);
const getArtifact = (params) => service.artifactsGet(params);
const getDiff = (params) => service.diffsGet(params);
const drainSubscriptionEvents = (paramsOrSubscriptionId, maybeLimit) => {
  if (typeof paramsOrSubscriptionId === "string") {
    return service.drainSubscriptionEvents(paramsOrSubscriptionId, maybeLimit);
  }

  if (typeof paramsOrSubscriptionId === "object" && paramsOrSubscriptionId !== null) {
    const subscriptionId =
      typeof paramsOrSubscriptionId.subscription_id === "string"
        ? paramsOrSubscriptionId.subscription_id
        : typeof paramsOrSubscriptionId.subscriptionId === "string"
          ? paramsOrSubscriptionId.subscriptionId
          : undefined;
    const limit =
      typeof paramsOrSubscriptionId.limit === "number" && Number.isFinite(paramsOrSubscriptionId.limit)
        ? paramsOrSubscriptionId.limit
        : undefined;

    if (subscriptionId !== undefined) {
      return service.drainSubscriptionEvents(subscriptionId, limit);
    }
  }

  throw new Error("The drain subscription command requires a subscription_id.");
};

const deps = {
  discover: () => discoverCodexRuntime(client),
  listSessions: (params) => service.sessionsList(params),
  getSession: (params) => service.sessionsGet(params),
  resumeSession: (params) => service.sessionsResume(params),
  sendInput: (params) => service.sessionsSendInput(params),
  subscribeSession,
  unsubscribeSession,
  listApprovals,
  respondApproval,
  listArtifacts,
  getArtifact,
  getDiff,
  drainSubscriptionEvents,
  sessionsSubscribe: subscribeSession,
  sessionsUnsubscribe: unsubscribeSession,
  approvalsList: listApprovals,
  approvalsRespond: respondApproval,
  artifactsList: listArtifacts,
  artifactsGet: getArtifact,
  diffsGet: getDiff,
  drainSubscription: drainSubscriptionEvents
};

try {
  const parsed = parseLiveSmokeCommand(argv);

  if (parsed.mode === "interactive") {
    await runInteractiveLiveSmoke({
      input: process.stdin,
      output: process.stdout,
      deps
    });
  } else if (parsed.command === "watch") {
    const validated = validateLiveSmokeCommand(parsed);
    const result = await runLiveSmokeWatch({
      command: validated,
      deps,
      output: process.stdout
    });
    writeLiveSmokeResult(process.stdout, result);
  } else {
    const result = await runLiveSmokeCommand(validateLiveSmokeCommand(parsed), deps);
    writeLiveSmokeResult(process.stdout, result);
  }
} catch (error) {
  const message = error instanceof Error ? error.message : String(error);
  process.stderr.write(`${message}\n`);

  if (argv.length > 0) {
    process.stderr.write(`${getLiveSmokeUsage()}\n`);
  }

  process.exitCode = 1;
} finally {
  await client.close();
}
