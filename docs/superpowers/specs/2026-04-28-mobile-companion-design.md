# Mobile Companion App Design

## Goal

Design a mobile companion app for ASCP that supports host pairing, trusted-device onboarding, session browsing, remote session control, approvals, and lightweight operational inspection from a phone-first interface.

This is a mobile client design only. It must stay downstream of the existing daemon pairing backend, host trust model, and frozen ASCP contracts.

## Scope

Included:

- first-run connection and trust onboarding
- QR/code pairing claim flow
- secure device credential storage and reconnect handling
- session list, session detail, and live status visibility
- transcript viewing and message input for remote session control
- approvals queue for pending actions
- artifacts, diffs, and trusted-device inspection
- app settings, connection status, and transport-state messaging
- a shadcn-style mobile design system and component guidance

Excluded:

- protocol changes
- daemon backend changes
- host-console changes
- desktop-first layouts
- model inference APIs
- vendor-specific runtime assumptions

## Product Direction

The mobile app should feel like a reliable field control surface, not a reduced desktop clone.

It should answer three questions quickly:

1. Is this host trusted and connected?
2. What sessions need attention right now?
3. What can I safely do from here?

The app should be clear about transport and trust boundaries. If the daemon transport is not trusted or not available, the UI must show that state explicitly rather than implying full control.

## Core Jobs

The app should support these top-level jobs:

- pair with a host daemon using code or QR
- confirm trust and store credentials securely on device
- browse active and historical sessions
- inspect a session timeline and its current run state
- send messages or commands to a selected session
- review and respond to pending approvals
- inspect artifacts and diffs tied to a session
- manage trusted devices and revoke access when needed

## Information Architecture

Use a bottom-navigation mobile shell with five primary destinations:

1. `Home` - connection summary, trust state, and priority work queue
2. `Sessions` - session list and session detail
3. `Approvals` - pending approvals and blocked requests
4. `Inspect` - artifacts, diffs, and recent run history
5. `Settings` - trusted devices, transport state, and app preferences

Why this structure:

- it keeps the most urgent work visible in one thumb zone
- it avoids overloading a single scrolling screen
- it maps cleanly to the daemon-backed operating model

## Screen Structure

### 1. Home

Purpose:

- show whether the host is paired, reachable, and trusted
- surface the most urgent next action
- provide a fast entry into pairing, sessions, or approvals

Content:

- host identity and trust badge
- current transport state
- active session summary
- pending approvals count
- last sync or reconnect time
- primary action button depending on state

States:

- unpaired
- pairing in progress
- trusted and connected
- trusted but temporarily disconnected
- trust revoked or expired

### 2. Sessions

Purpose:

- browse all sessions with clear state visibility
- open one session into a focused detail view

Content:

- session search or filter chips
- session cards with status, runtime, updated time, and blocked badges
- pull-to-refresh
- session detail screen or expandable sheet

Session detail should include:

- title and status
- transcript timeline
- current run summary
- live indicator or degraded-state notice
- composer for sending input when allowed

### 3. Approvals

Purpose:

- surface pending approval items without forcing the user through session detail first

Content:

- approval cards with risk level and action type
- the owning session context
- approve and reject actions
- compact historical record for resolved items

### 4. Inspect

Purpose:

- provide a compact operational view for artifacts and diffs

Content:

- recent artifacts
- diff summaries
- expandable file or patch detail
- quick jump back to the owning session

### 5. Settings

Purpose:

- manage device trust and app-level controls

Content:

- trusted devices list
- revoke controls
- host connection details
- transport mode and security messaging
- offline cache and sync preferences

## Pairing Flow

The pairing flow should be simple and visible enough to complete in under a minute.

Recommended steps:

1. scan QR or enter pairing code
2. confirm host identity details
3. submit claim
4. wait for host approval
5. receive device secret and store it securely
6. transition to the trusted home state

Design requirements:

- show the raw code clearly in monospace
- support QR scanning and manual fallback input
- keep the claim state visible while polling
- surface approval, rejection, expiry, and consumed states distinctly
- never hide a failed pairing behind a generic error toast

## Remote Control Flow

The remote-control experience should feel lightweight and safe on mobile.

Primary controls:

- send message or command
- pause or stop a session when permitted
- respond to approvals
- refresh or reconnect

Constraints:

- actions that mutate state should live behind a clear confirmation surface when risk is non-trivial
- when the user cannot act, the UI should explain why with a visible permission or state badge
- long text should collapse into readable cards, not overflow the viewport

## Data Model

The mobile app should organize state into five main stores:

- `connectionState`
- `pairingState`
- `sessionState`
- `approvalState`
- `deviceState`

Recommended derived groups:

- priority queue for the Home screen
- pending approvals pulled from session and approval state
- active session list filtered by current search and status
- trusted device list with revoke eligibility

The pairing and trust state must remain separate from session browsing state so reconnect or revocation events do not corrupt the current session view.

## Design System

Use shadcn-style components as the foundation and extend them with a focused mobile system.

### Core primitives

- `Button`
- `Card`
- `Badge`
- `Tabs`
- `Sheet`
- `Dialog`
- `Input`
- `Textarea`
- `Separator`
- `Skeleton`
- `ScrollArea`
- `DropdownMenu` or `Popover` where needed

### Component patterns

- `AppShell` - safe-area-aware bottom navigation and page framing
- `StatusBadge` - trust, session, approval, and transport states
- `MetricCard` - compact summary tiles for counts and sync status
- `SessionCard` - list item with status, badges, and timestamp
- `TimelineItem` - conversation, approval, or system event entry
- `ActionSheet` - mobile-first confirm or choose action surface
- `EmptyState` - clear next-step messaging for no data or blocked states
- `CodeBlock` - copyable code and identifiers in mono style

### Visual system

Tone:

- dark technical base
- restrained accent color usage
- operational clarity over decorative effects

Suggested palette direction:

- background: graphite / near-black
- surface: layered charcoal cards
- primary accent: cyan or electric blue
- success: green
- warning: amber
- destructive: red

Typography:

- use a purposeful display face for headings
- use a highly readable sans for body text
- use monospace for codes, IDs, diffs, and timestamps when density matters

Spacing and shape:

- slightly rounded cards and sheets
- compact but breathable spacing
- large enough touch targets for one-handed use

Motion:

- subtle page transitions
- bottom-sheet motion for actions
- light list refresh feedback
- no decorative motion that competes with the operational data

## Navigation Behavior

Navigation should be bottom-tab based on mobile and predictable across re-entry.

Rules:

- keep the current tab visible at all times
- preserve the last selected session when returning to `Sessions`
- preserve the last active approval context when returning to `Approvals`
- show a trust or connection change immediately in the shell header
- use sheets for deeper actions instead of pushing everything into full screens

## Loading And Error Rules

The app should prefer truthful stale-state handling over blanking everything out.

Required states:

- loading
- live
- snapshot-only or stale
- disconnected
- error

Behavior:

- the Home shell should stay usable even if one data source fails
- session detail should not keep old data while a new session loads
- approval and device panels should fail independently
- retry actions should be local to the failing area

## Trust And Security Rules

The mobile app must treat device trust as first-class.

Rules:

- store the raw device secret only in secure device storage
- never surface secret material after onboarding unless explicitly necessary for recovery
- show when the host is trusted, untrusted, revoked, or unreachable
- do not imply network trust if the transport is not secure enough for the current mode
- make revoke and sign-out actions easy to find in settings

## Testing Direction

This slice should define tests for:

- onboarding state transitions
- transport-state messaging
- bottom-nav workspace switching
- session selection and detail persistence
- pending approval derivation
- trust revocation handling
- destructive action confirmation surfaces

Manual validation should confirm:

- pairing can be completed from QR or code entry
- the app can recover after reconnect without losing the trusted host identity
- sessions remain readable on a narrow viewport
- approvals can be handled quickly with one or two taps
- destructive actions are not hidden behind ambiguous UI

## Acceptance Criteria

This design is satisfied when:

- the mobile app supports pairing and remote control as a single coherent companion flow
- the app exposes clear trust and transport status at all times
- sessions, approvals, inspection, and settings each have a focused mobile surface
- the UI uses shadcn-style components as the base system
- the design system is reusable enough to guide implementation without inventing new patterns ad hoc
