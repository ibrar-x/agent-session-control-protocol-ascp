# Codex Live Smoke Script Design

## Goal

Add a testable live-runtime script for the Codex adapter that supports both:

- guided interactive testing from a terminal
- direct command-style invocation for repeatable manual checks

The script should exercise the already implemented adapter surface against the real `codex app-server` without pretending unsupported ASCP features exist.

## Scope

Included:

- one checked-in script under `adapters/codex/scripts/`
- dual-mode UX:
  - interactive mode when run with no subcommand
  - subcommand mode when invoked with explicit actions
- live testing of:
  - runtime discovery
  - `sessions.list`
  - `sessions.get`
  - `sessions.resume`
  - `sessions.send_input`
- clear terminal output for both success and failure paths
- a package script alias so the flow is easy to run from the repo root
- focused tests for argument parsing and command dispatch where practical
- README updates documenting how to use the script

Excluded:

- implementing `sessions.subscribe`
- streaming ASCP event subscriptions
- replay, artifacts, approval response, or advertised diff reads
- product UI or browser-based controls

## User Problem

The adapter is implemented as a library. That is enough for tests and direct Node snippets, but it is awkward for repeated real-runtime validation because users must keep writing inline scripts or editing ad hoc commands. The repository needs one stable, testable entrypoint that makes live checks easy without widening the adapter surface itself.

## Approaches Considered

### 1. Interactive-only script

Pros:

- simplest guided experience
- best for exploratory manual testing

Cons:

- poor fit for repeatability
- awkward to document exact non-interactive checks
- harder to use in quick regression workflows

### 2. Subcommands-only CLI

Pros:

- easiest to automate
- straightforward documentation and copy-paste examples

Cons:

- worse human testing experience
- forces users to keep copying session IDs and arguments
- no guided flow for first-time validation

### 3. Recommended: one dual-mode script

Pros:

- guided interactive mode for exploration
- direct subcommands for repeatability
- shared adapter logic in one place
- smallest long-term maintenance cost

Cons:

- slightly more script logic than a single-mode tool

## Recommended Design

Add:

- `adapters/codex/scripts/live-smoke.mjs`

Modify:

- `adapters/codex/package.json`
- `adapters/codex/README.md`
- test files under `adapters/codex/tests/` as needed for command parsing or flow helpers

The package script alias should be:

```json
"live": "node ./scripts/live-smoke.mjs"
```

## Script Modes

### Interactive mode

Behavior when run with no positional subcommand:

```bash
npm --workspace @ascp/adapter-codex run live
```

Flow:

1. print a short banner explaining supported and unsupported live checks
2. run discovery and show runtime/version/capability fallback summary
3. list recent sessions
4. prompt the user to choose a session by index or by explicit session ID
5. prompt for next action:
   - inspect session
   - inspect session with runs
   - resume session
   - send input
   - quit
6. require explicit confirmation before mutating actions:
   - `resume`
   - `send-input`
7. print formatted JSON results
8. optionally loop back to the action menu until the user exits

### Subcommand mode

Supported commands:

- `discover`
- `list`
- `get`
- `resume`
- `send-input`

Examples:

```bash
npm --workspace @ascp/adapter-codex run live -- discover
npm --workspace @ascp/adapter-codex run live -- list --limit 5
npm --workspace @ascp/adapter-codex run live -- get codex:thread_id --runs
npm --workspace @ascp/adapter-codex run live -- resume codex:thread_id
npm --workspace @ascp/adapter-codex run live -- send-input codex:thread_id "Continue from the current state."
```

Subcommand behavior:

- `discover`
  - runs adapter discovery and prints normalized runtime info
- `list`
  - runs `sessions.list`
  - supports `--limit <n>`
- `get`
  - requires `session_id`
  - supports `--runs`
- `resume`
  - requires `session_id`
- `send-input`
  - requires `session_id`
  - requires input text as the trailing argument

## Output Rules

The script should optimize for terminal readability rather than raw protocol dumps only.

Recommended output structure:

- a short action header
- one compact human-readable summary line when useful
- pretty JSON payload after the summary

Examples:

- discovery:
  - runtime available
  - version
  - conservative capability flags
- list:
  - count of sessions returned
  - numbered compact list before full JSON in interactive mode

The script should never claim unsupported adapter features are available. It should explicitly note:

- `sessions.subscribe` is unsupported
- replay is unsupported
- artifacts are unsupported
- approval response is unsupported

## Safety Rules

Read-only operations should be the default path.

Mutating operations must be explicit:

- subcommand mode is explicit by construction
- interactive mode must require a confirmation prompt before `resume` and `send-input`

The script must not:

- fabricate streaming support
- hide adapter errors
- silently swallow Codex runtime failures

## Error Handling

For adapter or runtime failures:

- print a short error summary
- include adapter error code when available
- exit with non-zero status in subcommand mode
- remain in the menu or return to action selection in interactive mode when reasonable

For invalid CLI usage:

- print a concise usage summary
- exit with non-zero status

## Internal Structure

Keep the script small and split only if needed.

Preferred structure:

- lightweight argument parser inside the script
- small helper functions for:
  - printing usage
  - rendering session lists
  - prompting
  - confirmation
  - action dispatch

Do not introduce a new generic CLI framework for this branch.

## Testing Strategy

Add focused tests around pure logic, not full TTY emulation.

Recommended coverage:

- argument parsing for subcommands and flags
- dispatch routing for supported commands
- validation failures for missing `session_id` or missing input text
- formatting helpers if they hold non-trivial logic

Do not block the branch on exhaustive interactive terminal simulation.

## Acceptance Criteria

This script feature is done when:

- `npm --workspace @ascp/adapter-codex run live` opens a guided interactive flow
- `npm --workspace @ascp/adapter-codex run live -- <subcommand>` supports direct invocation
- the script exercises the real adapter service against `codex app-server`
- unsupported live features are reported honestly
- the README documents the script clearly
- focused tests cover non-trivial script logic

## Rationale

This design proves the adapter against a real runtime in a reusable way while keeping the adapter boundary intact. It improves operability and demos without widening ASCP claims or inventing a host surface that does not exist yet.
