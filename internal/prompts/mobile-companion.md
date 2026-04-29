# Mobile Companion App Starter Prompt

Use this prompt when starting implementation of the ASCP mobile companion app.

## Read First

Read these files before coding:

1. `AGENTS.md`
2. `internal/plans.md`
3. `internal/status.md`
4. `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
5. `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
6. `docs/superpowers/specs/2026-04-28-mobile-companion-design.md`
7. `docs/superpowers/plans/2026-04-28-mobile-companion.md`

## What To Build

Build a phone-first ASCP companion app that does all of the following:

- pair with the host daemon through QR or code entry
- confirm and store trust securely on the device
- browse sessions and open a focused session detail view
- send input to a selected session when allowed
- review and respond to approvals
- inspect artifacts and diffs in a compact mobile layout
- manage trusted devices and revoke access

## Design Rules

- use shadcn-style components as the UI base
- keep the visual language dark, technical, and deliberate
- use a bottom-navigation shell
- keep trust/pairing state separate from session state
- show transport and trust failures explicitly
- use sheets and dialogs for destructive or high-risk actions
- prefer compact cards and readable timelines over dense dashboards

## Implementation Order

1. build the design tokens and shared shell primitives
2. build pairing and trust onboarding
3. build sessions, approvals, and inspection screens
4. wire responsive navigation and error handling
5. add tests for state derivation and navigation behavior
6. update the mobile README with operator instructions

## Local Constraints

- do not invent protocol methods or backend endpoints
- do not claim transport trust that the daemon cannot actually provide
- do not mix mobile pairing state into session detail state
- do not let stale data remain visible while loading a new session
