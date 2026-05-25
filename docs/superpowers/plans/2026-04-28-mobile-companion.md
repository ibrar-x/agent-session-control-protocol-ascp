# Mobile Companion Flutter App Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the Continuum mobile companion app in Flutter for ASCP host pairing, trusted-device onboarding, live session observation, real-time control, approvals, artifacts, diffs, and settings.

**Architecture:** Use a feature-first Flutter structure where each feature owns its presentation, application state, domain models, data sources, and tests. Keep ASCP protocol contracts in a shared typed client layer, keep host pairing/trust separate from session control, and use WebSocket as the primary real-time transport with HTTP fallback for daemon pairing and resource reads.

**Tech Stack:** Flutter, Dart, `flutter_shadcn` CLI, shadcn Flutter registry components, Riverpod 3 as default state management, Dio for HTTP, `web_socket_channel` for WebSocket streams, GoRouter for navigation, Freezed/json_serializable for immutable protocol models, secure storage and local auth for trust material, Drift for durable local cache, Flutter widget/golden tests.

---

## Source Material

- `AGENTS.md`
- `protocol/ASCP_Protocol_Detailed_Spec_v0_1.md`
- `protocol/ASCP_Protocol_PRD_and_Build_Guide.md`
- `internal/plans.md`
- `internal/status.md`
- `apps/mobile/index.html`
- `apps/mobile/sessio.html`
- `/Users/ibrar/Desktop/infinora.noworkspace/Continuum App/Continuum Design System/BUILD_ORDER.md`
- `/Users/ibrar/Desktop/infinora.noworkspace/Continuum App/Continuum Design System/colors_and_type.css`

## Product Boundary

This app is a downstream ASCP client. It must not redefine ASCP core method names, event names, session statuses, replay semantics, approval semantics, or host trust behavior.

Included:

- Flutter app scaffold under `apps/mobile`
- feature-first folder structure
- design token port from the Continuum Design System
- shadcn Flutter UI component installation plan
- pairing by QR and manual code
- trusted-device storage and biometric gate
- ASCP host discovery, capability discovery, session list/get/start/resume/stop, input send, subscriptions, approvals, artifacts, and diffs
- replay-aware WebSocket reconnect behavior
- offline/degraded state visibility
- TDD and widget/golden test requirements

Excluded:

- protocol schema changes
- daemon backend changes
- host-console UI changes
- model inference APIs
- runtime-specific planning UI
- vendor billing or cloud runtime assumptions

## Current Package Research

Package versions were checked from pub.dev on 2026-05-25. Pin exact compatible versions during implementation after `flutter pub outdated` confirms the local Flutter/Dart SDK constraints.

### Required Runtime Dependencies

| Purpose | Package | Researched Version | Decision |
| --- | --- | ---: | --- |
| State management and dependency injection | `flutter_riverpod` | `3.3.1` | Default choice |
| Riverpod annotations | `riverpod_annotation` | `4.0.2` | Use for generated providers |
| Event/state alternative | `flutter_bloc` | `9.1.1` | Allowed only for complex event machines if justified |
| Core BLoC package | `bloc` | `9.2.1` | Only if BLoC is chosen for a specific feature |
| HTTP client | `dio` | `5.9.2` | Use for pairing, discovery, artifacts, diffs, and non-streaming methods |
| WebSocket client | `web_socket_channel` | `3.0.3` | Use for ASCP JSON-RPC streaming subscriptions |
| Routing | `go_router` | `17.2.3` | Use shell routes for tab navigation and deep links |
| Immutable models | `freezed_annotation` | `3.1.0` | Runtime annotations |
| Secure trust storage | `flutter_secure_storage` | `10.3.0` | Store tokens, device secret, host trust material |
| Biometric/passcode gate | `local_auth` | `3.0.1` | Protect high-risk actions and secret reveal/delete |
| Connectivity hints | `connectivity_plus` | `7.1.1` | Show network class only; never treat as proof of reachability |
| Non-secret preferences | `shared_preferences` | `2.5.5` | Theme, last host, UX settings only |
| QR scanner | `mobile_scanner` | `7.2.0` | Camera-based host pairing scan |
| QR generator if needed for debug/dev | `qr_flutter` | `4.1.0` | Optional developer diagnostics only |
| Permissions | `permission_handler` | `12.0.1` | Camera permission and OS settings handoff |
| Local relational cache | `drift` | `2.33.0` | Cache sessions, events, artifacts, approvals, replay cursors |
| SQLite binaries | `sqlite3_flutter_libs` | `0.6.0+eol` | Drift runtime support |
| File paths | `path_provider` | `2.1.5` | Drift database path and exported artifact cache |

### Required Dev Dependencies

| Purpose | Package | Researched Version | Decision |
| --- | --- | ---: | --- |
| Code generation | `build_runner` | `2.15.0` | Run after model/provider edits |
| Immutable class generator | `freezed` | `3.2.5` | Generate value types and unions |
| JSON serialization | `json_serializable` | `6.14.0` | Generate ASCP request/response/event JSON |
| Riverpod provider generator | `riverpod_generator` | `4.0.3` | Generate typed providers |
| Mocking | `mocktail` | `1.0.5` | Repository, transport, storage, and clock tests |
| Golden/widget testing | `golden_toolkit` | `0.15.0` | Screen and component visual regression |
| Flutter lint baseline | `flutter_lints` | `6.0.0` | Minimum lint layer |
| Stricter lint preset | `very_good_analysis` | `10.2.0` | Prefer for production app discipline |

## State Management Decision

Use Riverpod as the default because this app needs dependency injection, async state, stream lifecycles, generated providers, and testable overrides more than ceremony-heavy event logs.

Allowed pattern:

- `AsyncNotifier` / generated `@riverpod` providers for async features
- `StateNotifier` only if a feature needs explicit reducer-like state transitions
- repository interfaces injected through providers
- provider overrides in tests for transport, storage, clock, and auth

BLoC is allowed only when a feature has a truly complex event machine where event replay/readability is more valuable than provider ergonomics. If BLoC is used, it must stay inside that feature folder and expose a simple boundary to the rest of the app.

## Flutter shadcn CLI Rules

`flutter_shadcn` is the source of truth for registry setup, discovery, installation, theme application, validation, audit, and dependency checks.

Required first commands after the Flutter app exists:

```bash
cd apps/mobile
flutter pub get
flutter_shadcn init --yes
flutter_shadcn registries --json
flutter_shadcn default
flutter_shadcn doctor --json
```

If the CLI is missing:

```bash
dart pub global activate flutter_shadcn_cli
export PATH="$PATH:$HOME/.pub-cache/bin"
flutter_shadcn version
```

Install registry components only after `init` and only after a dry run:

```bash
cd apps/mobile
flutter_shadcn dry-run \
  @shadcn/app \
  @shadcn/scaffold \
  @shadcn/card \
  @shadcn/button \
  @shadcn/badge \
  @shadcn/tabs \
  @shadcn/navigation_bar \
  @shadcn/dialog \
  @shadcn/drawer \
  @shadcn/toast \
  @shadcn/form \
  @shadcn/input \
  @shadcn/text_field \
  @shadcn/text_area \
  @shadcn/input_otp \
  @shadcn/switch \
  @shadcn/checkbox \
  @shadcn/skeleton \
  @shadcn/empty_state \
  @shadcn/code_snippet \
  @shadcn/timeline \
  @shadcn/refresh_trigger \
  @shadcn/tooltip \
  --json
flutter_shadcn add \
  @shadcn/app \
  @shadcn/scaffold \
  @shadcn/card \
  @shadcn/button \
  @shadcn/badge \
  @shadcn/tabs \
  @shadcn/navigation_bar \
  @shadcn/dialog \
  @shadcn/drawer \
  @shadcn/toast \
  @shadcn/form \
  @shadcn/input \
  @shadcn/text_field \
  @shadcn/text_area \
  @shadcn/input_otp \
  @shadcn/switch \
  @shadcn/checkbox \
  @shadcn/skeleton \
  @shadcn/empty_state \
  @shadcn/code_snippet \
  @shadcn/timeline \
  @shadcn/refresh_trigger \
  @shadcn/tooltip
flutter_shadcn validate --json
flutter_shadcn audit --json
flutter_shadcn deps --json
```

UI rules:

- Use shadcn components for controls, surfaces, overlays, forms, navigation, and status display before custom widgets.
- Do not introduce Material/Cupertino controls when the shadcn registry has an equivalent.
- Use Flutter primitives for layout only when no registry abstraction is better.
- Do not hardcode colors when design tokens or shadcn theme tokens can express the value.
- Run `flutter_shadcn validate --json`, `flutter_shadcn audit --json`, and `flutter_shadcn deps --json` after component changes.

## Feature-First Folder Structure

Create this structure under `apps/mobile`:

```text
apps/mobile/
├── pubspec.yaml
├── analysis_options.yaml
├── build.yaml
├── README.md
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── continuum_app.dart
│   │   ├── app_router.dart
│   │   ├── app_bootstrap.dart
│   │   └── app_lifecycle_observer.dart
│   ├── core/
│   │   ├── ascp/
│   │   │   ├── ascp_method.dart
│   │   │   ├── ascp_error.dart
│   │   │   ├── ascp_envelope.dart
│   │   │   ├── ascp_event.dart
│   │   │   ├── ascp_models.dart
│   │   │   └── generated/
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   └── environment.dart
│   │   ├── database/
│   │   │   ├── continuum_database.dart
│   │   │   ├── tables.dart
│   │   │   └── migrations.dart
│   │   ├── design_system/
│   │   │   ├── continuum_tokens.dart
│   │   │   ├── continuum_theme.dart
│   │   │   ├── status_colors.dart
│   │   │   └── widgets/
│   │   ├── errors/
│   │   │   ├── app_exception.dart
│   │   │   └── error_mapper.dart
│   │   ├── network/
│   │   │   ├── dio_provider.dart
│   │   │   ├── http_json_rpc_client.dart
│   │   │   ├── websocket_json_rpc_client.dart
│   │   │   ├── reconnect_policy.dart
│   │   │   └── transport_state.dart
│   │   ├── security/
│   │   │   ├── secure_store.dart
│   │   │   ├── local_auth_gate.dart
│   │   │   └── trust_material.dart
│   │   └── testing/
│   │       ├── fake_clock.dart
│   │       ├── fake_transport.dart
│   │       └── provider_overrides.dart
│   ├── features/
│   │   ├── home/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   ├── presentation/
│   │   │   └── application/
│   │   ├── pairing/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   ├── presentation/
│   │   │   └── application/
│   │   ├── sessions/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   ├── presentation/
│   │   │   └── application/
│   │   ├── approvals/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   ├── presentation/
│   │   │   └── application/
│   │   ├── inspect/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   ├── presentation/
│   │   │   └── application/
│   │   └── settings/
│   │       ├── data/
│   │       ├── domain/
│   │       ├── presentation/
│   │       └── application/
│   └── l10n/
├── test/
│   ├── core/
│   ├── features/
│   └── widget/
├── integration_test/
│   ├── pairing_flow_test.dart
│   ├── session_reconnect_test.dart
│   └── approval_response_test.dart
└── test_goldens/
    ├── pairing/
    ├── sessions/
    ├── approvals/
    └── settings/
```

Feature folder responsibilities:

- `domain/`: pure Dart value objects, enums, and business rules.
- `data/`: repositories, DTO mappers, remote/local data sources.
- `application/`: Riverpod providers, notifiers, use cases, orchestration.
- `presentation/`: screens, widgets, and feature-local shadcn composition.

## Design System Translation Plan

The Continuum Design System `BUILD_ORDER.md` defines the build sequence. The Flutter app should preserve that sequence:

1. Base colors
2. Semantic colors
3. Typography scale
4. Spacing and radii
5. Motion tokens
6. Accessibility
7. Bottom navigation
8. Status chips
9. Pairing card
10. Session list item
11. Dialogs and toasts
12. Settings form
13. Device detail sheet
14. Home dashboard
15. Approvals screen
16. Settings screen
17. Trusted devices
18. Artifact viewer
19. Active session
20. Interactive app integration

Port token values into `lib/core/design_system/continuum_tokens.dart`:

```dart
class ContinuumColorTokens {
  static const bgSurface = Color(0xFF29261F);
  static const bgElevated = Color(0xFF332F28);
  static const bgOverlay = Color(0xFF3D3930);
  static const border = Color(0xFF4E4942);
  static const textPrimary = Color(0xFFD4CFC6);
  static const mutedText = Color(0xFF9A9488);
  static const mono = Color(0xFFA09A8E);
  static const accent = Color(0xFFC07349);
  static const accentForeground = Color(0xFF1A1208);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFD9512A);
}
```

Token rules:

- Use `Inter` for UI text and `ProtoMono` or a bundled monospace fallback for IDs/codes.
- Keep spacing on a 4px base unit.
- Keep compact operational layouts; no marketing hero screens.
- Use shadcn theme extension points before custom styling.
- Golden-test every token-dependent component in light/dark or supported modes before building full screens.

## ASCP Transport Architecture

Use two client surfaces:

1. `HttpJsonRpcClient`
   - pairing claim
   - mobile claim polling
   - capabilities discovery
   - artifacts and diffs reads
   - trusted-device list/revoke where the daemon exposes REST-style admin endpoints

2. `WebSocketJsonRpcClient`
   - `sessions.subscribe`
   - event stream consumption
   - `sessions.send_input`
   - `approvals.respond`
   - reconnect and replay cursor flow

WebSocket behavior:

- maintain one active connection per trusted host
- authenticate with trusted-device secret from secure storage
- track transport states: `idle`, `connecting`, `connected`, `reconnecting`, `offline`, `authFailed`, `revoked`, `unsupported`
- persist the last replay sequence per session in Drift
- reconnect with exponential backoff and jitter
- after reconnect, call `sessions.subscribe` with the last durable sequence if replay is advertised
- if replay is not advertised, show a degraded state and refresh session snapshots
- ignore unknown event fields safely
- never invent missing sequence numbers on the mobile client

## App Routes

Use `go_router` with a shell route:

```text
/
├── /pairing
├── /home
├── /sessions
│   └── /sessions/:sessionId
├── /approvals
│   └── /approvals/:approvalId
├── /inspect
│   ├── /inspect/artifacts/:artifactId
│   └── /inspect/diffs/:diffId
└── /settings
    ├── /settings/devices
    └── /settings/devices/:deviceId
```

Routing rules:

- Untrusted users land on `/pairing`.
- Trusted but disconnected users land on `/home` with degraded transport state.
- Deep links to session/approval/detail pages must verify trust first.
- Pairing result links should be parsed but never trusted without host confirmation and secure storage write.

## TDD Rules

Development is test-driven. For every feature task:

1. Write a failing pure Dart unit test for domain/application behavior.
2. Run the focused test and confirm the expected failure.
3. Implement the minimal code.
4. Run the focused test until it passes.
5. Add widget/golden coverage for UI states.
6. Run feature tests plus `flutter analyze`.
7. Commit only after docs and tracker files are updated.

Minimum test matrix:

- pairing step derivation
- claim polling states
- secure storage write timing
- biometric gate failure and success
- ASCP method serialization
- ASCP event parsing with unknown fields
- WebSocket reconnect and replay cursor
- session list filters
- session detail transcript ordering
- approval queue actions
- artifact/diff mapping
- trusted-device revoke flow
- bottom navigation route persistence
- golden states for every screen from `BUILD_ORDER.md`

## Implementation Tasks

### Task 1: Scaffold Flutter App and Tooling

**Files:**

- Create: `apps/mobile/pubspec.yaml`
- Create: `apps/mobile/analysis_options.yaml`
- Create: `apps/mobile/build.yaml`
- Create: `apps/mobile/lib/main.dart`
- Create: `apps/mobile/lib/app/continuum_app.dart`
- Create: `apps/mobile/lib/app/app_bootstrap.dart`
- Create: `apps/mobile/test/smoke/app_bootstrap_test.dart`
- Modify: `apps/mobile/README.md`

- [x] **Step 1: Write failing bootstrap test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app_bootstrap.dart';

void main() {
  test('app bootstrap exposes required startup services', () {
    final bootstrap = createAppBootstrap();

    expect(bootstrap.hasRouter, isTrue);
    expect(bootstrap.hasSecureStore, isTrue);
    expect(bootstrap.hasTransportClients, isTrue);
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/smoke/app_bootstrap_test.dart
```

Expected: FAIL because the Flutter app and bootstrap module do not exist.

- [x] **Step 3: Create Flutter project in place**

Run:

```bash
cd apps/mobile
flutter create --platforms=ios,android --org app.continuum .
flutter pub add flutter_riverpod riverpod_annotation dio web_socket_channel go_router freezed_annotation json_annotation flutter_secure_storage local_auth connectivity_plus shared_preferences mobile_scanner qr_flutter permission_handler drift sqlite3_flutter_libs path_provider
flutter pub add --dev build_runner freezed json_serializable riverpod_generator mocktail golden_toolkit flutter_lints very_good_analysis
flutter pub get
```

- [x] **Step 4: Initialize Flutter shadcn CLI**

Run:

```bash
cd apps/mobile
flutter_shadcn init --yes
flutter_shadcn registries --json
flutter_shadcn default
flutter_shadcn doctor --json
```

Expected: CLI reports valid Flutter project and usable registry state.

- [x] **Step 5: Implement bootstrap service flags**

Create `AppBootstrap` as a small immutable object with `hasRouter`, `hasSecureStore`, and `hasTransportClients` fields. Wire `main.dart` through `ProviderScope`.

- [x] **Step 6: Verify**

Run:

```bash
cd apps/mobile
flutter test test/smoke/app_bootstrap_test.dart
flutter analyze
```

Expected: PASS.

### Task 2: Port Design Tokens and Install UI Primitives

**Files:**

- Create: `apps/mobile/lib/core/design_system/continuum_tokens.dart`
- Create: `apps/mobile/lib/core/design_system/continuum_theme.dart`
- Create: `apps/mobile/lib/core/design_system/status_colors.dart`
- Create: `apps/mobile/lib/core/design_system/widgets/continuum_status_badge.dart`
- Create: `apps/mobile/test/core/design_system/continuum_tokens_test.dart`
- Create: `apps/mobile/test_goldens/design_system/status_badge_golden_test.dart`

- [x] **Step 1: Write failing token tests**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/design_system/continuum_tokens.dart';

void main() {
  test('Continuum tokens preserve source design system colors', () {
    expect(ContinuumColorTokens.bgSurface.value, 0xFF29261F);
    expect(ContinuumColorTokens.bgElevated.value, 0xFF332F28);
    expect(ContinuumColorTokens.accent.value, 0xFFC07349);
    expect(ContinuumColorTokens.danger.value, 0xFFD9512A);
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/core/design_system/continuum_tokens_test.dart
```

Expected: FAIL because tokens are not implemented.

- [x] **Step 3: Dry-run and install shadcn primitives**

Run the component dry-run/add commands from the Flutter shadcn CLI section above.

- [x] **Step 4: Implement tokens, theme adapter, and status badge**

Use source token values from `BUILD_ORDER.md`. Keep the theme adapter isolated so later shadcn registry updates do not require touching feature widgets.

- [x] **Step 5: Verify design tooling**

Checkpoint: `flutter test`, `flutter analyze`, `flutter_shadcn validate --json`, `flutter_shadcn audit --json`, and `flutter_shadcn deps --json` pass for the Flutter foundation. The local registry manifest was repaired to include the markdown live preview dependency, and the additional planned primitives were installed through the CLI dry-run/add flow.

Run:

```bash
cd apps/mobile
flutter test test/core/design_system/continuum_tokens_test.dart
flutter_shadcn validate --json
flutter_shadcn audit --json
flutter_shadcn deps --json
```

Expected: PASS and no shadcn diagnostics requiring manual repair.

### Task 3: Build ASCP Model and JSON-RPC Foundation

**Files:**

- Create: `apps/mobile/lib/core/ascp/ascp_method.dart`
- Create: `apps/mobile/lib/core/ascp/ascp_error.dart`
- Create: `apps/mobile/lib/core/ascp/ascp_envelope.dart`
- Create: `apps/mobile/lib/core/ascp/ascp_event.dart`
- Create: `apps/mobile/lib/core/ascp/ascp_models.dart`
- Create: `apps/mobile/test/core/ascp/ascp_envelope_test.dart`
- Create: `apps/mobile/test/core/ascp/ascp_event_test.dart`

- [x] **Step 1: Write failing ASCP serialization tests**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/ascp/ascp_method.dart';

void main() {
  test('ASCP core method names stay exact', () {
    expect(AscpMethod.sessionsList.value, 'sessions.list');
    expect(AscpMethod.sessionsSubscribe.value, 'sessions.subscribe');
    expect(AscpMethod.approvalsRespond.value, 'approvals.respond');
    expect(AscpMethod.diffsGet.value, 'diffs.get');
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/core/ascp/ascp_envelope_test.dart
```

Expected: FAIL because ASCP model files do not exist.

- [x] **Step 3: Implement exact method enums and JSON envelopes**

Use Freezed/json_serializable. Include exact core methods from `AGENTS.md` and preserve unknown JSON fields in event payload maps where a typed object is not yet implemented.

- [x] **Step 4: Generate code and verify**

Run:

```bash
cd apps/mobile
dart run build_runner build --delete-conflicting-outputs
flutter test test/core/ascp
```

Expected: PASS. Current implementation uses hand-written pure Dart value types for the foundation and does not require generated files yet.

### Task 4: Implement Transport Layer

**Files:**

- Create: `apps/mobile/lib/core/network/http_json_rpc_client.dart`
- Create: `apps/mobile/lib/core/network/websocket_json_rpc_client.dart`
- Create: `apps/mobile/lib/core/network/reconnect_policy.dart`
- Create: `apps/mobile/lib/core/network/transport_state.dart`
- Create: `apps/mobile/test/core/network/reconnect_policy_test.dart`
- Create: `apps/mobile/test/core/network/websocket_json_rpc_client_test.dart`

- [x] **Step 1: Write failing reconnect tests**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/reconnect_policy.dart';

void main() {
  test('reconnect policy caps exponential delay and adds jitter range', () {
    final policy = ReconnectPolicy(baseMs: 250, maxMs: 8000, jitterRatio: 0.2);

    expect(policy.delayForAttempt(0).inMilliseconds, greaterThanOrEqualTo(200));
    expect(policy.delayForAttempt(0).inMilliseconds, lessThanOrEqualTo(300));
    expect(policy.delayForAttempt(10).inMilliseconds, lessThanOrEqualTo(9600));
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/core/network/reconnect_policy_test.dart
```

Expected: FAIL.

- [x] **Step 3: Implement HTTP and WebSocket JSON-RPC clients**

HTTP uses Dio with timeouts, auth interceptors, and structured error mapping. WebSocket uses `web_socket_channel`, tracks request IDs, emits typed stream states, and supports reconnect/re-subscribe handoff.

- [x] **Step 4: Verify**

Run:

```bash
cd apps/mobile
flutter test test/core/network
```

Expected: PASS.

### Task 5: Implement Secure Trust and Pairing Feature

**Files:**

- Create: `apps/mobile/lib/core/security/secure_store.dart`
- Create: `apps/mobile/lib/core/security/local_auth_gate.dart`
- Create: `apps/mobile/lib/core/security/trust_material.dart`
- Create: `apps/mobile/lib/features/pairing/domain/pairing_state.dart`
- Create: `apps/mobile/lib/features/pairing/data/pairing_repository.dart`
- Create: `apps/mobile/lib/features/pairing/application/pairing_controller.dart`
- Create: `apps/mobile/lib/features/pairing/presentation/pairing_screen.dart`
- Create: `apps/mobile/test/features/pairing/pairing_controller_test.dart`
- Create: `apps/mobile/test/widget/pairing_screen_test.dart`

- [x] **Step 1: Write failing pairing state tests**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/pairing/domain/pairing_state.dart';

void main() {
  test('pairing states keep claim and host approval separate', () {
    expect(PairingStatus.pendingClaim.nextVisibleStep, PairingVisibleStep.claiming);
    expect(PairingStatus.pendingHostApproval.nextVisibleStep, PairingVisibleStep.waitingForHost);
    expect(PairingStatus.approved.nextVisibleStep, PairingVisibleStep.trusted);
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/features/pairing/pairing_controller_test.dart
```

Expected: FAIL.

- [ ] **Step 3: Implement pairing repository and controller**

Support:

- QR scan payload parsing
- manual pairing code entry with OTP input
- claim request
- polling until `pending_host_approval`, `approved`, `rejected`, `expired`, or `consumed`
- secure write only after host approval
- explicit errors for expired, rejected, revoked, unreachable, and malformed QR states

- [ ] **Step 4: Build pairing UI with shadcn components**

Use `@shadcn/input_otp`, `@shadcn/button`, `@shadcn/card`, `@shadcn/dialog`, `@shadcn/toast`, `@shadcn/skeleton`, and `mobile_scanner`.

- [ ] **Step 5: Verify**

Run:

```bash
cd apps/mobile
flutter test test/features/pairing
flutter test test/widget/pairing_screen_test.dart
```

Expected: PASS.

### Task 6: Implement App Shell, Navigation, and Home

**Files:**

- Create: `apps/mobile/lib/app/app_router.dart`
- Create: `apps/mobile/lib/features/home/application/home_controller.dart`
- Create: `apps/mobile/lib/features/home/domain/priority_work_item.dart`
- Create: `apps/mobile/lib/features/home/presentation/home_screen.dart`
- Create: `apps/mobile/lib/core/design_system/widgets/continuum_bottom_nav.dart`
- Create: `apps/mobile/test/features/home/home_controller_test.dart`
- Create: `apps/mobile/test/widget/app_shell_test.dart`

- [x] **Step 1: Write failing navigation guard tests**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/app_router.dart';

void main() {
  test('untrusted route guard sends users to pairing', () {
    final location = resolveInitialLocation(isTrusted: false, requestedPath: '/sessions');
    expect(location, '/pairing');
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/widget/app_shell_test.dart
```

Expected: FAIL.

- [x] **Step 3: Implement shell route and home priority queue**

Home summarizes trust, connection, active sessions, pending approvals, and last replay sync. Keep bottom navigation safe-area aware.

- [x] **Step 4: Verify**

Run:

```bash
cd apps/mobile
flutter test test/features/home test/widget/app_shell_test.dart
```

Expected: PASS.

### Task 7: Implement Sessions and Live Timeline

**Files:**

- Create: `apps/mobile/lib/features/sessions/domain/session_filters.dart`
- Create: `apps/mobile/lib/features/sessions/data/session_repository.dart`
- Create: `apps/mobile/lib/features/sessions/application/session_list_controller.dart`
- Create: `apps/mobile/lib/features/sessions/application/session_detail_controller.dart`
- Create: `apps/mobile/lib/features/sessions/presentation/session_list_screen.dart`
- Create: `apps/mobile/lib/features/sessions/presentation/session_detail_screen.dart`
- Create: `apps/mobile/lib/features/sessions/presentation/widgets/session_card.dart`
- Create: `apps/mobile/lib/features/sessions/presentation/widgets/timeline_view.dart`
- Create: `apps/mobile/lib/features/sessions/presentation/widgets/session_composer.dart`
- Create: `apps/mobile/test/features/sessions/session_detail_controller_test.dart`
- Create: `apps/mobile/test/widget/session_detail_screen_test.dart`

- [x] **Step 1: Write failing replay ordering tests**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/sessions/application/session_detail_controller.dart';

void main() {
  test('timeline keeps events ordered by ASCP sequence', () {
    final ordered = orderTimelineEvents([
      FakeTimelineEvent(sequence: 3, id: 'third'),
      FakeTimelineEvent(sequence: 1, id: 'first'),
      FakeTimelineEvent(sequence: 2, id: 'second'),
    ]);

    expect(ordered.map((event) => event.id), ['first', 'second', 'third']);
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/features/sessions/session_detail_controller_test.dart
```

Expected: FAIL.

- [ ] **Step 3: Implement session list/detail controllers**

Support:

- `sessions.list`
- `sessions.get`
- `sessions.resume`
- `sessions.stop`
- `sessions.send_input`
- `sessions.subscribe`
- `sessions.unsubscribe`
- replay cursor persistence
- live transcript updates
- degraded state when replay is unsupported

- [ ] **Step 4: Build session UI**

Use shadcn `card`, `badge`, `timeline`, `text_area`, `button`, `refresh_trigger`, `code_snippet`, and `drawer` components.

- [ ] **Step 5: Verify**

Run:

```bash
cd apps/mobile
flutter test test/features/sessions test/widget/session_detail_screen_test.dart
```

Expected: PASS.

### Task 8: Implement Approvals

**Files:**

- Create: `apps/mobile/lib/features/approvals/domain/approval_view_model.dart`
- Create: `apps/mobile/lib/features/approvals/data/approval_repository.dart`
- Create: `apps/mobile/lib/features/approvals/application/approval_queue_controller.dart`
- Create: `apps/mobile/lib/features/approvals/presentation/approvals_screen.dart`
- Create: `apps/mobile/lib/features/approvals/presentation/widgets/approval_card.dart`
- Create: `apps/mobile/test/features/approvals/approval_queue_controller_test.dart`
- Create: `apps/mobile/test/widget/approvals_screen_test.dart`

- [x] **Step 1: Write failing approval actionability tests**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/approvals/domain/approval_view_model.dart';

void main() {
  test('approval derived from unsupported runtime is visible but not actionable', () {
    final approval = ApprovalViewModel.pending(
      id: 'appr_1',
      sessionId: 'sess_1',
      isActionable: false,
      reason: 'approval_respond capability is false',
    );

    expect(approval.isActionable, isFalse);
    expect(approval.reason, contains('approval_respond'));
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/features/approvals/approval_queue_controller_test.dart
```

Expected: FAIL.

- [ ] **Step 3: Implement approvals repository and queue**

Support:

- `approvals.list`
- `approvals.respond`
- pending, approved, denied, expired, and non-actionable states
- confirmation sheet before high-risk approval
- audit-visible actor attribution where returned by the host

- [ ] **Step 4: Verify**

Run:

```bash
cd apps/mobile
flutter test test/features/approvals test/widget/approvals_screen_test.dart
```

Expected: PASS.

### Task 9: Implement Inspect, Artifacts, and Diffs

**Files:**

- Create: `apps/mobile/lib/features/inspect/data/inspect_repository.dart`
- Create: `apps/mobile/lib/features/inspect/application/inspect_controller.dart`
- Create: `apps/mobile/lib/features/inspect/presentation/inspect_screen.dart`
- Create: `apps/mobile/lib/features/inspect/presentation/artifact_detail_screen.dart`
- Create: `apps/mobile/lib/features/inspect/presentation/diff_detail_screen.dart`
- Create: `apps/mobile/test/features/inspect/inspect_controller_test.dart`
- Create: `apps/mobile/test/widget/inspect_screen_test.dart`

- [x] **Step 1: Write failing artifact/diff mapping tests**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/inspect/application/inspect_controller.dart';

void main() {
  test('inspect priority groups diffs before passive artifacts', () {
    final items = prioritizeInspectItems([
      FakeInspectItem.artifact('artifact_1'),
      FakeInspectItem.diff('diff_1'),
    ]);

    expect(items.first.id, 'diff_1');
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/features/inspect/inspect_controller_test.dart
```

Expected: FAIL.

- [ ] **Step 3: Implement inspect flows**

Support:

- `artifacts.list`
- `artifacts.get`
- `diffs.get`
- compact mobile diff display
- jump back to owning session
- clear unsupported/degraded states

- [ ] **Step 4: Verify**

Run:

```bash
cd apps/mobile
flutter test test/features/inspect test/widget/inspect_screen_test.dart
```

Expected: PASS.

### Task 10: Implement Settings and Trusted Devices

**Files:**

- Create: `apps/mobile/lib/features/settings/domain/trusted_device.dart`
- Create: `apps/mobile/lib/features/settings/data/settings_repository.dart`
- Create: `apps/mobile/lib/features/settings/application/settings_controller.dart`
- Create: `apps/mobile/lib/features/settings/presentation/settings_screen.dart`
- Create: `apps/mobile/lib/features/settings/presentation/trusted_devices_screen.dart`
- Create: `apps/mobile/test/features/settings/settings_controller_test.dart`
- Create: `apps/mobile/test/widget/settings_screen_test.dart`

- [x] **Step 1: Write failing revoke tests**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/settings/domain/trusted_device.dart';

void main() {
  test('current device revoke requires biometric confirmation', () {
    final device = TrustedDevice.current(id: 'device_1', displayName: 'This iPhone');
    expect(device.requiresLocalAuthForRevoke, isTrue);
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/features/settings/settings_controller_test.dart
```

Expected: FAIL.

- [ ] **Step 3: Implement settings and trusted-device management**

Support:

- device inventory
- local app preferences
- transport diagnostics
- biometric-gated destructive actions
- secure storage reset
- host trust revocation

- [ ] **Step 4: Verify**

Run:

```bash
cd apps/mobile
flutter test test/features/settings test/widget/settings_screen_test.dart
```

Expected: PASS.

### Task 11: Add Local Cache and Offline/Replay Persistence

**Files:**

- Create: `apps/mobile/lib/core/database/continuum_database.dart`
- Create: `apps/mobile/lib/core/database/tables.dart`
- Create: `apps/mobile/lib/core/database/migrations.dart`
- Create: `apps/mobile/test/core/database/continuum_database_test.dart`

- [x] **Step 1: Write failing cursor persistence test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/database/continuum_database.dart';

void main() {
  test('stores replay cursor per host and session', () async {
    final db = ContinuumDatabase.inMemory();

    await db.saveReplayCursor(hostId: 'host_1', sessionId: 'sess_1', sequence: 42);

    expect(await db.readReplayCursor(hostId: 'host_1', sessionId: 'sess_1'), 42);
  });
}
```

- [x] **Step 2: Run failing test**

Run:

```bash
cd apps/mobile
flutter test test/core/database/continuum_database_test.dart
```

Expected: FAIL.

- [ ] **Step 3: Implement Drift tables**

Tables:

- `trusted_hosts`
- `trusted_devices`
- `sessions`
- `session_events`
- `approvals`
- `artifacts`
- `diffs`
- `replay_cursors`

- [ ] **Step 4: Verify**

Run:

```bash
cd apps/mobile
dart run build_runner build --delete-conflicting-outputs
flutter test test/core/database
```

Expected: PASS.

### Task 12: Integration Tests, Golden Tests, and Documentation

**Files:**

- Create: `apps/mobile/integration_test/pairing_flow_test.dart`
- Create: `apps/mobile/integration_test/session_reconnect_test.dart`
- Create: `apps/mobile/integration_test/approval_response_test.dart`
- Create: `apps/mobile/test_goldens/pairing/pairing_screen_golden_test.dart`
- Create: `apps/mobile/test_goldens/sessions/session_detail_golden_test.dart`
- Create: `apps/mobile/test_goldens/approvals/approvals_screen_golden_test.dart`
- Create: `apps/mobile/README.md`
- Modify: `internal/plans.md`
- Modify: `internal/status.md`

- [x] **Step 1: Write integration tests against a mock ASCP host**

Cover:

- first-run pairing
- approved trust storage
- WebSocket subscribe/replay after reconnect
- approval response round trip

- [x] **Step 2: Add golden tests for design-system build order**

Golden states must cover:

- unpaired home
- QR/manual pairing
- waiting host approval
- trusted connected home
- disconnected home
- session list
- active session
- approvals pending and empty
- artifact/diff detail
- settings and trusted devices

- [x] **Step 3: Update docs**

`apps/mobile/README.md` must include:

- architecture summary
- feature-first folder rules
- Flutter shadcn CLI workflow
- package decisions
- TDD workflow
- local test commands
- ASCP scope boundaries

- [ ] **Step 4: Full verification**

Run:

```bash
cd apps/mobile
flutter_shadcn validate --json
flutter_shadcn audit --json
flutter_shadcn deps --json
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
flutter test integration_test
```

Expected: PASS.

Implementation checkpoint on 2026-05-25:

- Added integration-style shell coverage under `apps/mobile/test/integration/mobile_shell_flow_test.dart` for first-run pairing and trusted sessions-to-approvals navigation.
- Added golden smoke coverage under `apps/mobile/test_goldens/mobile_shell_golden_test.dart` for first-run pairing and trusted sessions shells.
- Updated `apps/mobile/README.md`, `internal/plans.md`, and `internal/status.md`.
- Full verification is tracked in the active session output because it must be rerun after every implementation change.

## Definition of Done

The mobile app task is done when:

- Flutter app exists under `apps/mobile`
- architecture follows the feature-first folder structure in this plan
- Riverpod is the default state layer and provider overrides exist for tests
- `flutter_shadcn` has initialized the app and installed required shadcn components through dry-run-first workflow
- design tokens match the Continuum Design System source values
- pairing supports QR and manual code
- device secret is stored only after host approval
- WebSocket transport supports reconnect and replay-aware subscription
- sessions, approvals, artifacts, diffs, and settings have tested UI states
- unknown ASCP fields are ignored safely
- unsupported host capabilities produce explicit degraded UI
- all unit, widget, golden, integration, analyze, shadcn validation, audit, and dependency checks pass
- `internal/plans.md` and `internal/status.md` are updated before commit

## Execution Notes

Recommended implementation mode:

1. Use `superpowers:subagent-driven-development` for each task in this plan.
2. Commit after each completed task.
3. Push each completed branch checkpoint.
4. Merge back to `main` only after full verification passes.

Do not begin by redesigning ASCP or the daemon. The first executable task is Flutter scaffolding plus design-system foundation.
