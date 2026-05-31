# AgentForge Task: Live Data / Hardcoded Value Audit

You are an external CLI subagent. Codex is the orchestrator/reviewer only.

Working directory:
`/Users/ibrar/Desktop/infinora.noworkspace/Continuum App/agent-session-control-protocol-ascp/apps/mobile`

Repo root:
`/Users/ibrar/Desktop/infinora.noworkspace/Continuum App/agent-session-control-protocol-ascp`

Task:
Audit the Flutter mobile app for hardcoded demo values that would make live mode misleading.

Constraints:
- Do not modify app source code.
- Create or overwrite only:
  `apps/mobile/qa-reports/2026-05-31-blackbox-hardcoded-live-audit.md`
- Focus on `apps/mobile/lib`, `apps/mobile/test`, and live dependency wiring.
- Identify whether Home, Sessions, session detail/chat, Approvals, Inspect/Artifacts, Devices, Settings, pairing, and model switching are backed by live repositories/controllers or fixed sample data.
- For each issue include exact file path, line reference if possible, why it matters for live QA, and recommended fix.
- If a value is only a memory/test fixture and not used in live mode, mark it as acceptable.

Report format:

```markdown
# Blackbox Hardcoded Live Data Audit

## Summary

## Findings
| Severity | Area | File | Evidence | Recommendation |
| --- | --- | --- | --- | --- |

## Acceptable Test Fixtures

## Live Capability Gaps

## Recommended Next Fix Order
```
