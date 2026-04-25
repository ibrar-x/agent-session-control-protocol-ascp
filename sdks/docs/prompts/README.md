# SDK Prompt Starters

These prompt starters exist so a new conversation can begin from a clear SDK feature boundary instead of reconstructing intent manually.

## Available Prompt Starters

- `typescript-sdk-foundation.md`
- `typescript-sdk-validation.md`
- `typescript-sdk-transport-client.md`
- `dart-sdk-planning.md`

## How To Use Them

- start from `AGENTS.md`
- read `plans.md` and `docs/status.md`
- open the relevant prompt starter for the next unfinished feature
- keep the branch scoped to that feature only

These prompts are intentionally narrow. They are meant to reduce drift, not to replace the upstream protocol sources.

For runtime-facing TypeScript branches, prompt starters should also be treated as preserving the repository-wide observability rules from `AGENTS.md`:

- keep analytics and observability opt-in rather than silent
- keep diagnostics actionable enough to identify failure location and likely remediation
- keep production-facing package metadata current when the published package surface changes

## Documentation Expectation For Every Branch

Each prompt starter should be treated as requiring branch-level documentation before commit.

At minimum, the branch documentation should explain:

- what the branch adds and what remains out of scope
- how to use the current branch output locally
- what upstream ASCP sources were relied on
- the implementation thought process and the constraints that shaped the design
- why the chosen approach was used instead of the most plausible alternatives
- verification commands and what they prove
- known limitations, deferred work, and follow-on risks
- the next likely branch and the clean handoff context for it
