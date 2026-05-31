# Live-Readiness Audit — Continuum Mobile

**Date:** 2026-05-31  
**Auditor:** Kiro (AgentForge subagent)  
**Scope:** Report-only. No source modifications.

---

## Summary

The app has a clean dual-mode architecture (`MobileDependencies.memory()` vs `.live()`). Live mode is fully wired through `--dart-define` environment variables and Riverpod providers. All core features have ASCP-backed or daemon-backed repository implementations. Two presentation-layer fallbacks and one unused ASCP method represent the only gaps.

**Verdict: READY for live integration testing with minor caveats below.**

---

## 1. Mode Switching & Hardcoded Values

| Item | Status | File | Notes |
|------|--------|------|-------|
| Mode selection via `CONTINUUM_MOBILE_MODE` | ✅ Live-backed | `lib/app/mobile_providers.dart:38` | Falls back to memory if not `"live"` |
| Default `hostId = 'host_1'` | ⚠️ Memory-only default | `lib/app/mobile_providers.dart:11`, `mobile_dependencies.dart:34` | Only used when env vars are missing; live path reads `CONTINUUM_HOST_ID` |
| Default `activeSessionId = 'session_1'` | ⚠️ Memory-only default | Same files | Same — only used in memory fallback |
| `DaemonSettingsRepository.diagnostics` hardcoded `state: 'connected'` | ⚠️ Hardcoded | `lib/features/settings/data/settings_repository.dart:57` | `readDiagnostics()` returns a const value even in live mode |

---

## 2. Feature-by-Feature Live Backing

### Pairing

| Component | Live-backed? | Implementation | File |
|-----------|-------------|----------------|------|
| Claim flow | ✅ | `DaemonPairingRepository.claim()` → `POST /pairing/claim` | `lib/features/pairing/data/pairing_repository.dart:175` |
| Poll flow | ✅ | `DaemonPairingRepository.poll()` → `GET /pairing/claims/:token` | Same file, line 195 |
| QR scanner | ✅ | `MobileScannerPairingScanner` (mobile_scanner) | `lib/features/pairing/presentation/mobile_scanner_pairing_scanner.dart` |
| Manual entry parser | ✅ | `parseManualPairingPayload()` supports code-only, JSON, host:port:code, URI | Same repo file |
| Trust material storage | ✅ | `FlutterSecureStore` in live mode | `lib/core/security/secure_store.dart:19` |
| Local auth gate | ✅ | `DeviceLocalAuthGate` (biometric) in live mode | `lib/core/security/local_auth_gate.dart:13` |

### Sessions / Chat

| Component | Live-backed? | Implementation | File |
|-----------|-------------|----------------|------|
| List sessions | ✅ | `AscpSessionRepository` → `sessions.list` | `lib/features/sessions/data/session_repository.dart:70` |
| Read timeline | ✅ | `AscpSessionRepository` → `sessions.get` with `include_events: true` | Same file, line 99 |
| Send input | ✅ | `AscpSessionRepository` → `sessions.send_input` | Same file, line 128 |
| Live subscription | ✅ | `AscpSessionSubscriptionRepository` → `sessions.subscribe` over WebSocket | Same file, line 157 |
| Authenticated WS | ✅ | `AuthenticatedWebSocketJsonRpcClient` reads trust material for headers | `lib/core/network/websocket_json_rpc_client.dart:107` |
| Replay from cursor | ✅ | `fromSequence` param passed to subscribe; Drift persists cursors | `lib/core/database/continuum_database.dart:95` |

### Approvals

| Component | Live-backed? | Implementation | File |
|-----------|-------------|----------------|------|
| List approvals | ✅ | `AscpApprovalRepository` → `approvals.list` | `lib/features/approvals/data/approval_repository.dart:46` |
| Respond (approve/reject) | ✅ | `AscpApprovalRepository` → `approvals.respond` | Same file, line 70 |

### Inspect / Artifacts

| Component | Live-backed? | Implementation | File |
|-----------|-------------|----------------|------|
| List artifacts | ✅ | `AscpInspectRepository` → `artifacts.list` | `lib/features/inspect/data/inspect_repository.dart:63` |
| Get artifact detail | ✅ | `AscpInspectRepository` → `artifacts.get` | Same file, line 91 |
| Get diff detail | ✅ | `AscpInspectRepository` → `diffs.get` | Same file, line 109 |

### Devices / Settings

| Component | Live-backed? | Implementation | File |
|-----------|-------------|----------------|------|
| List trusted devices | ✅ | `DaemonSettingsRepository` → `GET /admin/trusted-devices` | `lib/features/settings/data/settings_repository.dart:65` |
| Revoke device | ✅ | `DaemonSettingsRepository` → `POST /admin/trusted-devices/:id/revoke` | Same file, line 82 |
| Transport diagnostics | ⚠️ Hardcoded | Returns const `TransportDiagnostics(state: 'connected', ...)` | Same file, line 57 |

### Model Switching

| Component | Live-backed? | Implementation | File |
|-----------|-------------|----------------|------|
| Display current model | ✅ (read-only) | `SessionDetailController.currentModel` extracts from timeline events | `lib/features/sessions/application/session_detail_controller.dart:50` |
| Switch/select model | ❌ Not implemented | `AscpMethod.runtimesList` is declared but no UI or controller calls it | `lib/core/ascp/ascp_method.dart:4` |

---

## 3. Presentation-Layer Fallbacks (Non-Blocking)

| Issue | File | Impact |
|-------|------|--------|
| `SettingsScreen` default constructor creates `MemorySettingsRepository` | `lib/features/settings/presentation/settings_screen.dart:16` | Only triggers if screen is instantiated without passing a controller (e.g., deep-link edge case). Shell passes live controller. |
| `DevicesScreen` default constructor creates `MemorySettingsRepository` | `lib/features/settings/presentation/devices_screen.dart:15` | Same pattern. |
| `DevicesScreen._fallbackDevices` shows hardcoded demo devices when list is empty | `lib/features/settings/presentation/devices_screen.dart:360` | Visible to user if daemon returns empty list. |
| `ContinuumTrustedShell` falls back to `MobileDependencies.memory()` if provider throws | `lib/app/continuum_app.dart:92,115` | Defensive catch; should not fire in live mode. |

---

## 4. Blockers

| # | Severity | Description |
|---|----------|-------------|
| 1 | **Low** | `DaemonSettingsRepository.readDiagnostics()` is hardcoded — diagnostics screen will always show "connected" regardless of actual transport state. |
| 2 | **Low** | `_fallbackDevices` in `DevicesScreen` shows demo entries when the daemon returns an empty device list, which may confuse users on a fresh pair. |

No **high-severity** blockers. All ASCP and daemon endpoints are wired.

---

## 5. Recommendations

1. **Wire live diagnostics.** Add a daemon or ASCP endpoint (e.g., `GET /admin/diagnostics`) and replace the const `TransportDiagnostics` in `DaemonSettingsRepository`.

2. **Remove or guard `_fallbackDevices`.** Show an empty-state message instead of hardcoded demo devices when the daemon returns zero trusted devices.

3. **Expose `runtimes.list` for model switching.** The ASCP method enum already declares `runtimesList`. Add a repository + UI picker so users can switch models from the session detail screen.

4. **Eliminate presentation-layer memory fallbacks.** `SettingsScreen` and `DevicesScreen` default constructors should require a controller (or assert live mode) to prevent accidental memory-mode rendering in production.

5. **Integration-test the full live path.** The existing `integration_test/test_app.dart` still uses `MobileDependencies.memory()`. Add a live-mode integration test profile that runs against the daemon.

---

## 6. Files Referenced

```
lib/app/mobile_providers.dart
lib/app/mobile_dependencies.dart
lib/app/continuum_app.dart
lib/core/ascp/ascp_method.dart
lib/core/network/websocket_json_rpc_client.dart
lib/core/network/reconnect_policy.dart
lib/core/security/secure_store.dart
lib/core/security/local_auth_gate.dart
lib/core/database/continuum_database.dart
lib/features/sessions/data/session_repository.dart
lib/features/sessions/application/session_detail_controller.dart
lib/features/sessions/presentation/session_detail_screen.dart
lib/features/approvals/data/approval_repository.dart
lib/features/inspect/data/inspect_repository.dart
lib/features/pairing/data/pairing_repository.dart
lib/features/settings/data/settings_repository.dart
lib/features/settings/presentation/settings_screen.dart
lib/features/settings/presentation/devices_screen.dart
integration_test/test_app.dart
```
