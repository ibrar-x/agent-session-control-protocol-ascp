# XCUITest Integration Design

## Overview

Full end-to-end test coverage for the Continuum mobile app using Flutter's `integration_test` package with XCUITest as the iOS driver. Tests run against the real ASCP daemon (127.0.0.1:8765/8767) to verify the complete pairing, session, approval, and device management flows.

## Architecture

```
┌─────────────────────────────────────────┐
│  integration_test/                      │
│  ├── app_test.dart  (Dart test code)    │
│  └── driver.dart    (XCUITest driver)   │
└─────────────────────────────────────────┘
              │
              │ flutter test
              ▼
┌─────────────────────────────────────────┐
│  XCUITest (iOS native)                  │
│  - Launches app in simulator            │
│  - Translates Flutter commands to       │
│    native UI actions                    │
│  - Handles taps, text entry, scrolls    │
└─────────────────────────────────────────┘
              │
              │ HTTP requests
              ▼
┌─────────────────────────────────────────┐
│  ASCP Daemon (127.0.0.1:8765/8767)      │
│  - Real pairing/session/approval flow   │
│  - Tests verify state via admin API     │
└─────────────────────────────────────────┘
```

**Key points:**
- Tests written in Dart using `flutter_test` API
- XCUITest acts as the driver (handles native UI interaction)
- Tests can make HTTP calls to daemon to verify backend state
- Single test can check both UI and backend in one flow

## Test Structure & Coverage

### File Organization

```
integration_test/
├── app_test.dart              # Main test suite
├── pairing_flow_test.dart     # First-run pairing scenarios
├── dashboard_test.dart        # Home dashboard with live data
├── sessions_test.dart         # Sessions list and detail
├── approvals_test.dart        # Approvals queue
├── inspect_test.dart          # Inspect/artifacts
├── settings_test.dart         # Settings and device management
└── helpers/
    ├── daemon_client.dart     # HTTP client for daemon API
    └── test_data.dart         # Shared test fixtures
```

### Test Scenarios

#### 1. Pairing Flow (`pairing_flow_test.dart`)

- First-run screen appears on fresh install
- Tap "Enter code manually" transitions to code entry
- Enter valid pairing code (127.0.0.1:8767:PAIR-XXXX)
- Verify daemon receives claim request
- Approve pairing via daemon admin API
- Verify app transitions to trusted shell
- Verify trust material is stored

#### 2. Dashboard (`dashboard_test.dart`)

- Dashboard loads after pairing
- Active sessions count matches daemon state
- Pending approvals count matches daemon state
- Paired devices list shows current device
- Tap session card navigates to detail

#### 3. Sessions (`sessions_test.dart`)

- Sessions list loads from daemon
- Running sessions appear first
- Tap session opens detail view
- Session detail shows timeline events
- Composer input works (sessions.send_input)

#### 4. Approvals (`approvals_test.dart`)

- Approvals queue loads pending items
- Pending approvals show approve/deny buttons
- Tap approve sends approval to daemon
- Approval status updates in UI
- Non-actionable approvals show read-only

#### 5. Inspect (`inspect_test.dart`)

- Inspect tab loads artifacts/diffs
- Empty state when no session selected
- Tap artifact shows detail

#### 6. Settings (`settings_test.dart`)

- Settings shows current device info
- Trusted devices list loads from daemon
- Revoke device removes from list
- Diagnostics show connection state

## Setup & Dependencies

### Required Packages

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
  http: ^1.2.0  # For daemon API calls
```

### iOS XCUITest Target Setup

The `integration_test` package automatically configures XCUITest when you run tests. No manual Xcode configuration needed. However, we need to ensure:

1. **RunnerUITests target exists** in `ios/Runner.xcodeproj`
   - If missing, create via Xcode: File → New → Target → UI Testing Bundle
   - Or add manually to `.pbxproj`

2. **Info.plist permissions** for network access:
   ```xml
   <key>NSAppTransportSecurity</key>
   <dict>
     <key>NSAllowsLocalNetworking</key>
     <true/>
   </dict>
   ```

### Test Driver File

`integration_test/driver.dart`:

```dart
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
```

### Running Tests

```bash
# Run all integration tests
flutter test integration_test/

# Run specific test file
flutter test integration_test/pairing_flow_test.dart

# Run with verbose output
flutter test integration_test/ --verbose

# Run on specific device
flutter test integration_test/ -d iPhone-16e
```

### Daemon Requirements

Tests assume daemon is running at:
- WebSocket: `ws://127.0.0.1:8765`
- Admin HTTP: `http://127.0.0.1:8767`

We'll add a test helper that verifies daemon connectivity before running tests.

## Example Test Implementation

```dart
testWidgets('pairing flow - manual code entry', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  
  // Tap "Enter code manually"
  await tester.tap(find.text('Enter code manually'));
  await tester.pumpAndSettle();
  
  // Enter pairing code
  await tester.enterText(find.byType(TextField), '127.0.0.1:8767:PAIR-TEST');
  await tester.tap(find.text('Submit'));
  await tester.pumpAndSettle();
  
  // Verify daemon received the claim
  final response = await http.get(Uri.parse('http://127.0.0.1:8767/admin/pairing/sessions'));
  expect(response.body, contains('PAIR-TEST'));
});
```

## Success Criteria

- All 6 test files pass against real daemon
- Tests verify both UI state and daemon state
- Tests run reliably in CI (no flaky timing issues)
- Documentation includes setup instructions and troubleshooting guide
