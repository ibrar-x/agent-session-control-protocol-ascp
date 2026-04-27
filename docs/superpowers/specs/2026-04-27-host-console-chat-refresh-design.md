# Host Console Chat Refresh Design

## Goal

Refresh `apps/host-console` from a panel-heavy operator console into a believable chat-style app demo that still proves the live ASCP host surfaces working together.

The demo should make it obvious how a user would:

- switch between multiple live sessions
- read the conversation timeline
- see blocked approval or input moments in context
- respond to the agent
- inspect live operational state and raw protocol data when needed

This is a frontend/demo slice. It must stay downstream of the existing host and adapter behavior already implemented in the repository.

## Scope

Included:

- redesign the browser console layout and interaction model
- make the selected session experience chat-first
- surface approvals and blocked input requests inline in the timeline
- keep a layered operator rail for summary-first then raw JSON inspection
- preserve multi-session switching
- reflect degraded live-subscription state explicitly

Excluded:

- protocol changes
- host-service auth or multi-client work
- mobile UI implementation
- new ASCP methods
- backend redesign of the host or Codex adapter

## User Experience Direction

The web demo should feel like a serious operational chat app, not a debugging dashboard.

The selected session is the primary object. The interface is organized into three zones:

1. session switcher
2. chat timeline and composer
3. operator rail

The visual tone should stay aligned with the current repo direction: warm, dark, deliberate, and technical. The new layout should feel calmer and more app-like than the current dense grid.

## Layout

### Left: Session Switcher

Purpose:

- keep multiple sessions visible
- let the user jump across sessions without losing the overall operator context

Contents per row:

- session title or fallback id
- session status pill
- updated time
- live/unread indicator
- blocked badges when applicable:
  - waiting approval
  - waiting input

Behavior:

- selecting a session immediately clears the center and right panes into a loading state
- the previous session detail must not remain visible while the next session loads
- the session list itself remains stable during the switch

### Center: Chat Workspace

Purpose:

- show the selected session as a conversation, not as detached transport data

Contents:

- header for selected session
- conversation timeline
- bottom-anchored composer

Header elements:

- session title
- session status
- minimal live indicator when subscription is healthy
- expanded degraded-state notice only when live updates are paused or broken

Timeline elements:

- user messages
- assistant messages
- commentary/system status blocks
- inline approval cards
- inline blocked input cards
- inline artifact/diff notices when useful

Composer:

- persistent text entry area
- send action
- disabled state when no session is selected

### Right: Operator Rail

Purpose:

- keep operational state visible without overwhelming the main conversation
- support compact-first inspection with expandable raw JSON

Card order:

1. live state
2. session summary
3. current run
4. pending interactions
5. artifacts and diff summary
6. recent events
7. capabilities / raw protocol detail

This order is intentional. `Current run` must sit above `Pending interactions` so blocked state stays close to the active execution context.

## Live State Model

The selected session detail must operate in one of four UI states:

- `loading`
- `live`
- `snapshot-only`
- `error`

### Loading

Shown immediately on session switch.

Behavior:

- clear prior chat and rail content
- show skeleton placeholders in center and right panes
- keep the session list interactive

### Live

Shown after:

1. session snapshot has loaded
2. subscription has attached successfully

Behavior:

- chat timeline renders current session data
- operator rail renders normal compact cards
- live state is indicated quietly, not loudly

Healthy live indicator:

- small green status dot or compact live badge
- no loud banner

### Snapshot-only

Shown when:

1. the session snapshot loaded successfully
2. live subscription failed or dropped

Behavior:

- keep the last successful snapshot visible
- show a visible `Live updates paused` banner in the rail
- mirror the degraded state in the chat header
- present a retry action
- make stale-risk visible so users do not assume the blocked state is current

This state is preferable to silently showing aging snapshot data.

### Error

Shown when the session snapshot itself cannot be loaded.

Behavior:

- show an error block in center and rail
- offer retry
- never keep stale detail from the previous session visible

## State Management Contract

The selected session detail must be controlled by one shared selection-driven state model.

The chat pane and operator rail must not load independently in a way that allows them to disagree.

Required sequence on session selection:

1. set selected session id
2. clear selected-session detail state
3. set `loading`
4. load session snapshot:
   - session
   - runs
   - pending approvals
   - pending inputs
5. hydrate the main chat and rail from that snapshot
6. attach the live subscription
7. if subscribe succeeds, set `live`
8. if subscribe fails after snapshot, set `snapshot-only`
9. lazily load secondary detail only when the user explicitly expands the relevant rail card

The inline interaction cards in chat and the `Pending interactions` rail card must read from the same normalized store so they cannot drift.

## Conversation Timeline Model

The timeline is the primary storytelling surface of the demo.

It should show the agent flow in order, not as disconnected utility panels.

### Message Types

The timeline should support these rendered item types:

- user message
- assistant message
- commentary/system update
- approval request card
- input request card
- artifact/diff activity notice

### Interaction Cards

Approval cards and input cards must be distinct from each other and from assistant bubbles, but they should still feel like part of the conversation flow.

Design rules:

- left-anchored in the timeline
- card treatment rather than bubble treatment
- subtle accent strip or accent edge
- icon + label for interaction type
- visible lifecycle state

Approval card states:

- pending
- answered
- expired

Input card states:

- pending
- answered
- expired

Resolved behavior:

- once answered, the card collapses into a compact historical state in place
- it must not disappear from the conversation history
- history continuity matters more than visual tidiness here

These cards are part of the chat record, not modal interruptions.

## Pending Interactions Model

The rail `Pending interactions` card summarizes the same objects rendered inline in chat.

Compact view should show:

- count
- top pending item
- whether items are approvals or input requests

Expanded view should show:

- per-item detail
- action buttons where appropriate
- raw JSON payload disclosure

The compact and inline views must stay consistent because they are backed by the same normalized interaction state.

## Artifacts and Diff Presentation

Artifacts and diffs should stay secondary in this demo, but visible enough to prove the runtime integration.

### Secondary detail loading rule

Secondary detail must use one explicit trigger across the rail:

- compact artifact/diff summary is derived from already loaded session state when possible
- full artifact list loads only when the user expands the `Artifacts and diff summary` rail card
- diff detail loads only when the user explicitly opens the diff section inside that expanded card
- do not prefetch full artifact lists or diff detail automatically after subscription attach

This rule is intentional. It keeps the selected-session load path stable and prevents different rail cards from drifting into inconsistent fetch behavior.

Operator rail compact state:

- artifact count
- files changed
- insertions/deletions summary

Expanded state:

- artifact list
- diff summary
- raw JSON sections

In chat, artifact/diff notices should be lightweight event-style chips or compact activity cards, not large transcript interruptions.

## Event Presentation

The recent-events card should be summary-first.

Compact mode:

- recent event type list
- timestamp
- count or live pulse

Expanded mode:

- raw event envelopes
- sequence numbers
- JSON payloads

This keeps the UI useful to both product-style review and protocol debugging.

## Raw JSON Disclosure Pattern

Raw protocol data remains important in this demo, but it should be hidden behind deliberate disclosure.

Pattern:

- every major rail card has a compact summary
- each card can expand
- expanded mode can show structured detail first, raw JSON second

This layered approach satisfies both:

- “show me the app flow”
- “prove the API payloads are real”

without turning the whole screen into a JSON wall.

## Visual Hierarchy

### Healthy State

Healthy state should be quiet:

- no permanent loud success banners
- minimal live indicator
- restrained accents

### Degraded State

Degraded state should be noticeable:

- paused live updates
- dropped subscription
- snapshot-only mode
- session load errors

These should promote into visible banners or warning cards because stale interaction state is safety-significant.

## Interaction Actions

The demo should support these visible actions:

- connect / reconnect to host
- refresh session list
- select session
- send input
- approve
- reject
- retry live attach
- open artifacts
- open diff detail
- expand raw JSON

The interaction model should prefer inline actions when they are part of the conversation flow, and rail actions when they are diagnostic or secondary.

## Implementation Notes

### Reuse existing API wiring

The redesign should keep the current browser client stack:

- `createAscpClient`
- `AscpBrowserWebSocketTransport`
- current host methods for sessions, approvals, artifacts, diffs, and subscriptions

### Normalize UI data once

Create a single selected-session view model that merges:

- snapshot data
- live event updates
- pending interaction state
- run context

That model should drive both the center timeline and the operator rail.

### Avoid stale cross-session bleed

This is a hard rule:

- never show prior session approvals, inputs, run state, or artifacts while a new session is loading

Blanking to loading is the correct behavior.

## Testing Strategy

The implementation phase should verify:

- multi-session switching clears stale detail immediately
- snapshot-only mode is visible when subscribe fails
- pending approvals render both inline and in the rail
- pending inputs render both inline and in the rail
- answered interaction cards collapse in place
- healthy connection state remains visually quiet
- raw JSON remains accessible under expanded sections
- live host integration still works in the browser with the current ASCP stack

## Recommended Approach

Use the messenger-first workspace approach:

- primary chat pane
- layered operator rail
- lightweight session switcher

This best balances:

- believable product direction
- real ASCP protocol visibility
- live multi-session operator flow

The demo should look like the beginning of the real app, not like a temporary dev console.
