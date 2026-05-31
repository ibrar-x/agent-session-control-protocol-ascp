WORKING DIRECTORY: /Users/ibrar/Desktop/infinora.noworkspace/Continuum App/agent-session-control-protocol-ascp/apps/mobile

PROJECT: Flutter/Riverpod ASCP mobile companion. Codex is orchestrator/verifier; you are the implementation subagent.

TASK [T3-kiro-auto]: Fix the active session/chat live-flow model so it is not just hardcoded label strings.

FILES TO INSPECT FIRST:
- lib/features/sessions/domain/timeline_event.dart
- lib/features/sessions/data/session_repository.dart
- lib/features/sessions/application/session_detail_controller.dart
- lib/features/sessions/presentation/session_detail_screen.dart
- lib/app/continuum_app.dart
- test/features/sessions/session_detail_controller_test.dart
- test/widget/session_detail_screen_test.dart

REQUIREMENTS:
1. Preserve ASCP method names: sessions.get, sessions.subscribe, sessions.unsubscribe, sessions.send_input.
2. TimelineEvent should carry event type, payload/details, role/content/tool/approval metadata as structured data where possible, while preserving existing tests or updating them thoughtfully.
3. Active session screen must render real-time transcript/thinking/tool/terminal/approval events from ASCP payloads, not demo strings only.
4. Header data such as session title/status/duration/model must come from session summary/detail data if available or be absent/neutral, not static fake values like 28:14.
5. Add a model selector surface in the chat composer/header if repository exposes model options; if not, create a clearly testable abstraction that can be wired to live backend later without hardcoded fake model behavior in live mode.
6. Keep UI close to the provided chat screenshot: warm light background, compact header, approval pill when status needs approval, large readable chat, composer at bottom.
7. Add/adjust focused tests for structured event mapping and send_input.
8. Do not modify unrelated files. Do not commit.

Use the globally installed ios-debugger-agent skill only if you run simulator checks. Write a concise report to qa-reports/agent-forge-kiro-live-chat.md describing files changed, test commands, and any remaining gaps.
