# AgentForge Task: Live Continuum Mobile QA With iOS Debugger Skill

You are an external CLI subagent. Codex is the orchestrator/reviewer only.

Working directory:
`/Users/ibrar/Desktop/infinora.noworkspace/Continuum App/agent-session-control-protocol-ascp/apps/mobile`

Repo root:
`/Users/ibrar/Desktop/infinora.noworkspace/Continuum App/agent-session-control-protocol-ascp`

Use the installed `ios-debugger-agent` skill if your environment exposes it. OpenCode also has `XcodeBuildMCP` configured; use it if available. If MCP UI automation is not available inside this agent, run shell-level Flutter/iOS simulator commands and state that limitation clearly in the report.

Important constraints:
- Do not modify app source code for this task.
- You may create or overwrite only this report file:
  `apps/mobile/qa-reports/2026-05-31-opencode-live-full-qa.md`
- Run the real backend/host daemon, not memory mode.
- Test the live Flutter app against daemon endpoints.
- Verify pairing uses a fresh six-digit numeric code.
- Verify the app can build/run for iOS simulator with live dart-defines.
- Verify session chat/live behavior as far as the current backend supports it.
- Verify hardcoded demo values are not still driving the live Home/session detail surfaces.
- Verify model switching: if unsupported by protocol/backend, report it as an unsupported live capability, not a pass.
- Include exact commands, observed results, screenshots/log paths if captured, and failure details.

Suggested live daemon command from repo root:

```bash
ASCP_HOST=127.0.0.1 ASCP_PORT=9875 ASCP_ADMIN_PORT=9876 \
ASCP_DATABASE_PATH=/private/tmp/continuum-mobile-subagent-live-qa.sqlite \
npm --workspace @ascp/host-daemon run start
```

Suggested pairing session command:

```bash
curl -s -X POST -H 'Content-Type: application/json' \
  -d '{"requested_scopes":["read:hosts","read:runtimes","read:sessions","write:sessions","read:approvals","write:approvals","read:artifacts"]}' \
  http://127.0.0.1:9876/admin/pairing/sessions
```

Suggested Flutter live build command:

```bash
flutter build ios --simulator --debug \
  --dart-define=CONTINUUM_MOBILE_MODE=live \
  --dart-define=CONTINUUM_ASCP_RPC_ENDPOINT=http://127.0.0.1:9875/rpc \
  --dart-define=CONTINUUM_ASCP_WS_ENDPOINT=ws://127.0.0.1:9875/rpc \
  --dart-define=CONTINUUM_DAEMON_ADMIN_BASE_URL=http://127.0.0.1:9876 \
  --dart-define=CONTINUUM_HOST_ID=host_local \
  --dart-define=CONTINUUM_ACTIVE_SESSION_ID=sess_active \
  --dart-define=CONTINUUM_DEVICE_ID=device_mobile
```

Also run:

```bash
flutter analyze
flutter test
flutter_shadcn validate --json
flutter_shadcn audit --json
flutter_shadcn deps --json
npm --workspace @ascp/host-daemon run test
```

Report format:

```markdown
# OpenCode Live Full QA Report

## Environment
...

## Backend
...

## iOS Simulator
...

## Pairing
...

## Sessions And Chat
...

## Approvals
...

## Inspect / Artifacts
...

## Settings / Devices
...

## Hardcoded Live Data Audit
...

## Model Switching
...

## Verification Matrix
| Area | Result | Evidence |
| --- | --- | --- |

## Blockers
...

## Recommendations
...
```
