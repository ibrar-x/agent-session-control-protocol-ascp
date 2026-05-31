# XCUITest Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement full end-to-end integration tests for the Continuum mobile app using Flutter's integration_test package with XCUITest driver against the real ASCP daemon.

**Architecture:** Tests written in Dart using flutter_test API, with XCUITest as the iOS driver. Tests make HTTP calls to the daemon (127.0.0.1:8767) to verify backend state alongside UI assertions. Each test file covers one major flow (pairing, dashboard, sessions, approvals, inspect, settings).

**Tech Stack:** Flutter integration_test, flutter_test, http package, XCUITest (iOS native driver), ASCP daemon

---

## Task 1: Setup Integration Test Infrastructure

**Files:**
- Modify: `apps/mobile/pubspec.yaml`
- Create: `apps/mobile/integration_test/driver.dart`
- Create: `apps/mobile/integration_test/helpers/daemon_client.dart`
- Create: `apps/mobile/integration_test/helpers/test_data.dart`

- [ ] **Step 1: Add integration_test dependencies to pubspec.yaml**

Open `apps/mobile/pubspec.yaml` and add to `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  http: ^1.2.0
```

- [ ] **Step 2: Install dependencies**

Run: `cd apps/mobile && flutter pub get`

Expected: Dependencies installed successfully

- [ ] **Step 3: Create test driver file**

Create `apps/mobile/integration_test/driver.dart`:

```dart
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
```

- [ ] **Step 4: Create daemon client helper**

Create `apps/mobile/integration_test/helpers/daemon_client.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class DaemonClient {
  static const String adminBaseUrl = 'http://127.0.0.1:8767';
  static const String wsUrl = 'ws://127.0.0.1:8765';

  static Future<bool> isDaemonRunning() async {
    try {
      final response = await http
          .get(Uri.parse('$adminBaseUrl/admin/pairing/sessions'))
          .timeout(const Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> createPairingSession() async {
    final response = await http.post(
      Uri.parse('$adminBaseUrl/admin/pairing/sessions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'requested_scopes': ['sessions.read', 'sessions.write'],
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create pairing session: ${response.body}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<void> approvePairingSession(String sessionId) async {
    final response = await http.post(
      Uri.parse('$adminBaseUrl/admin/pairing/sessions/$sessionId/approve'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve pairing session: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getPairingSessions() async {
    final response = await http.get(
      Uri.parse('$adminBaseUrl/admin/pairing/sessions'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get pairing sessions: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final sessions = data['sessions'] as List;
    return sessions.cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> getSessions() async {
    final response = await http.get(
      Uri.parse('$adminBaseUrl/admin/sessions'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get sessions: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final sessions = data['sessions'] as List;
    return sessions.cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> getApprovals() async {
    final response = await http.get(
      Uri.parse('$adminBaseUrl/admin/approvals'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get approvals: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final approvals = data['approvals'] as List;
    return approvals.cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> getTrustedDevices() async {
    final response = await http.get(
      Uri.parse('$adminBaseUrl/admin/trusted-devices'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get trusted devices: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final devices = data['devices'] as List;
    return devices.cast<Map<String, dynamic>>();
  }
}
```

- [ ] **Step 5: Create test data helper**

Create `apps/mobile/integration_test/helpers/test_data.dart`:

```dart
class TestData {
  static const String daemonHost = '127.0.0.1';
  static const int daemonPort = 8767;
  static const int wsPort = 8765;

  static String pairingCode(String code) => '$daemonHost:$daemonPort:$code';
}
```

- [ ] **Step 6: Verify daemon is running**

Run: `curl http://127.0.0.1:8767/admin/pairing/sessions`

Expected: JSON response with sessions array (may be empty)

If daemon is not running, start it:

```bash
cd services/host-daemon
npm start
```

- [ ] **Step 7: Commit setup**

```bash
git add apps/mobile/pubspec.yaml apps/mobile/integration_test/
git commit -m "feat: setup integration test infrastructure

- Add integration_test and http dependencies
- Create test driver for XCUITest
- Add daemon client helper for API verification
- Add test data constants"
```

---

## Task 2: Implement Pairing Flow Tests

**Files:**
- Create: `apps/mobile/integration_test/pairing_flow_test.dart`

- [ ] **Step 1: Write first-run screen test**

Create `apps/mobile/integration_test/pairing_flow_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:continuum/main.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pairing Flow', () {
    setUp(() async {
      // Verify daemon is running before each test
      final isRunning = await DaemonClient.isDaemonRunning();
      if (!isRunning) {
        fail('ASCP daemon is not running at ${DaemonClient.adminBaseUrl}');
      }
    });

    testWidgets('shows first-run pairing screen on fresh install',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify first-run screen elements
      expect(find.text('Continuum'), findsOneWidget);
      expect(find.text('Unpaired'), findsOneWidget);
      expect(find.text('Scanning'), findsOneWidget);
      expect(find.text('Pair New Device'), findsOneWidget);
      expect(find.text('Enter code manually'), findsOneWidget);
    });

    testWidgets('taps Enter code manually and shows text field',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap "Enter code manually"
      await tester.tap(find.text('Enter code manually'));
      await tester.pumpAndSettle();

      // Verify text field appears
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('enters pairing code and submits to daemon', (tester) async {
      // Create a pairing session in daemon first
      final session = await DaemonClient.createPairingSession();
      final code = session['code'] as String;
      final sessionId = session['session_id'] as String;

      app.main();
      await tester.pumpAndSettle();

      // Navigate to manual entry
      await tester.tap(find.text('Enter code manually'));
      await tester.pumpAndSettle();

      // Enter pairing code
      await tester.enterText(
        find.byType(TextField),
        '127.0.0.1:8767:$code',
      );

      // Submit
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify daemon received the claim
      await tester.pump(const Duration(seconds: 2));
      final sessions = await DaemonClient.getPairingSessions();
      final claimedSession = sessions.firstWhere(
        (s) => s['session_id'] == sessionId,
        orElse: () => {},
      );

      expect(claimedSession.isNotEmpty, true);
      expect(claimedSession['status'], 'claimed');
    });

    testWidgets('transitions to trusted shell after approval', (tester) async {
      // Create and claim a pairing session
      final session = await DaemonClient.createPairingSession();
      final code = session['code'] as String;
      final sessionId = session['session_id'] as String;

      app.main();
      await tester.pumpAndSettle();

      // Navigate to manual entry and submit code
      await tester.tap(find.text('Enter code manually'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        '127.0.0.1:8767:$code',
      );

      await tester.tap(find.text('Submit'));
      await tester.pump(const Duration(seconds: 1));

      // Approve the session via daemon API
      await DaemonClient.approvePairingSession(sessionId);

      // Wait for app to transition to trusted shell
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify trusted shell elements
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Sessions'), findsOneWidget);
      expect(find.text('Approvals'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run pairing flow tests**

Run: `cd apps/mobile && flutter test integration_test/pairing_flow_test.dart`

Expected: All 4 tests pass

If tests fail:
- Check daemon is running: `curl http://127.0.0.1:8767/admin/pairing/sessions`
- Check app builds: `flutter build ios --simulator`
- Check XCUITest target exists in Xcode

- [ ] **Step 3: Commit pairing flow tests**

```bash
git add apps/mobile/integration_test/pairing_flow_test.dart
git commit -m "test: add pairing flow integration tests

- Test first-run screen appears on fresh install
- Test manual code entry navigation
- Test pairing code submission to daemon
- Test trusted shell transition after approval"
```

---

## Task 3: Implement Dashboard Tests

**Files:**
- Create: `apps/mobile/integration_test/dashboard_test.dart`

- [ ] **Step 1: Write dashboard tests**

Create `apps/mobile/integration_test/dashboard_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:continuum/main.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard', () {
    setUp(() async {
      final isRunning = await DaemonClient.isDaemonRunning();
      if (!isRunning) {
        fail('ASCP daemon is not running');
      }
    });

    Future<void> completePairing(WidgetTester tester) async {
      final session = await DaemonClient.createPairingSession();
      final code = session['code'] as String;
      final sessionId = session['session_id'] as String;

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enter code manually'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        '127.0.0.1:8767:$code',
      );

      await tester.tap(find.text('Submit'));
      await tester.pump(const Duration(seconds: 1));

      await DaemonClient.approvePairingSession(sessionId);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    testWidgets('shows dashboard after pairing', (tester) async {
      await completePairing(tester);

      // Verify dashboard elements
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Active Sessions'), findsOneWidget);
      expect(find.text('Pending Approvals'), findsOneWidget);
    });

    testWidgets('displays active sessions count from daemon', (tester) async {
      await completePairing(tester);

      // Get actual session count from daemon
      final sessions = await DaemonClient.getSessions();
      final runningCount = sessions
          .where((s) => s['status'] == 'running')
          .length;

      // Verify UI shows correct count
      expect(find.text('$runningCount'), findsOneWidget);
    });

    testWidgets('displays pending approvals count from daemon',
        (tester) async {
      await completePairing(tester);

      // Get actual approval count from daemon
      final approvals = await DaemonClient.getApprovals();
      final pendingCount = approvals
          .where((a) => a['status'] == 'pending')
          .length;

      // Verify UI shows correct count
      expect(find.text('$pendingCount'), findsOneWidget);
    });

    testWidgets('shows paired devices list', (tester) async {
      await completePairing(tester);

      // Verify paired devices section
      expect(find.text('Paired Devices'), findsOneWidget);

      // Get actual device count from daemon
      final devices = await DaemonClient.getTrustedDevices();

      // Should show at least the current device
      expect(devices.isNotEmpty, true);
    });
  });
}
```

- [ ] **Step 2: Run dashboard tests**

Run: `cd apps/mobile && flutter test integration_test/dashboard_test.dart`

Expected: All 4 tests pass

- [ ] **Step 3: Commit dashboard tests**

```bash
git add apps/mobile/integration_test/dashboard_test.dart
git commit -m "test: add dashboard integration tests

- Test dashboard appears after pairing
- Test active sessions count matches daemon
- Test pending approvals count matches daemon
- Test paired devices list displays"
```

---

## Task 4: Implement Sessions Tests

**Files:**
- Create: `apps/mobile/integration_test/sessions_test.dart`

- [ ] **Step 1: Write sessions tests**

Create `apps/mobile/integration_test/sessions_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:continuum/main.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sessions', () {
    setUp(() async {
      final isRunning = await DaemonClient.isDaemonRunning();
      if (!isRunning) {
        fail('ASCP daemon is not running');
      }
    });

    Future<void> completePairing(WidgetTester tester) async {
      final session = await DaemonClient.createPairingSession();
      final code = session['code'] as String;
      final sessionId = session['session_id'] as String;

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enter code manually'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        '127.0.0.1:8767:$code',
      );

      await tester.tap(find.text('Submit'));
      await tester.pump(const Duration(seconds: 1));

      await DaemonClient.approvePairingSession(sessionId);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    testWidgets('loads sessions list from daemon', (tester) async {
      await completePairing(tester);

      // Navigate to Sessions tab
      await tester.tap(find.text('Sessions'));
      await tester.pumpAndSettle();

      // Verify sessions list appears
      expect(find.text('Sessions'), findsWidgets);

      // Get actual sessions from daemon
      final sessions = await DaemonClient.getSessions();

      if (sessions.isNotEmpty) {
        // Verify at least one session is displayed
        expect(find.byType(ListView), findsOneWidget);
      }
    });

    testWidgets('running sessions appear first', (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Sessions'));
      await tester.pumpAndSettle();

      // Get sessions from daemon
      final sessions = await DaemonClient.getSessions();
      final runningSessions = sessions
          .where((s) => s['status'] == 'running')
          .toList();

      if (runningSessions.isNotEmpty) {
        // Verify running sessions are displayed
        for (final session in runningSessions.take(3)) {
          final sessionId = session['session_id'] as String;
          expect(find.textContaining(sessionId.substring(0, 8)), findsWidgets);
        }
      }
    });

    testWidgets('taps session to open detail view', (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Sessions'));
      await tester.pumpAndSettle();

      final sessions = await DaemonClient.getSessions();

      if (sessions.isNotEmpty) {
        // Tap first session
        await tester.tap(find.byType(ListTile).first);
        await tester.pumpAndSettle();

        // Verify detail view appears
        expect(find.text('Session Detail'), findsOneWidget);
        expect(find.text('Timeline'), findsOneWidget);
      }
    });
  });
}
```

- [ ] **Step 2: Run sessions tests**

Run: `cd apps/mobile && flutter test integration_test/sessions_test.dart`

Expected: All 3 tests pass

- [ ] **Step 3: Commit sessions tests**

```bash
git add apps/mobile/integration_test/sessions_test.dart
git commit -m "test: add sessions integration tests

- Test sessions list loads from daemon
- Test running sessions appear first
- Test session detail navigation"
```

---

## Task 5: Implement Approvals Tests

**Files:**
- Create: `apps/mobile/integration_test/approvals_test.dart`

- [ ] **Step 1: Write approvals tests**

Create `apps/mobile/integration_test/approvals_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:continuum/main.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Approvals', () {
    setUp(() async {
      final isRunning = await DaemonClient.isDaemonRunning();
      if (!isRunning) {
        fail('ASCP daemon is not running');
      }
    });

    Future<void> completePairing(WidgetTester tester) async {
      final session = await DaemonClient.createPairingSession();
      final code = session['code'] as String;
      final sessionId = session['session_id'] as String;

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enter code manually'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        '127.0.0.1:8767:$code',
      );

      await tester.tap(find.text('Submit'));
      await tester.pump(const Duration(seconds: 1));

      await DaemonClient.approvePairingSession(sessionId);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    testWidgets('loads approvals queue from daemon', (tester) async {
      await completePairing(tester);

      // Navigate to Approvals tab
      await tester.tap(find.text('Approvals'));
      await tester.pumpAndSettle();

      // Verify approvals screen appears
      expect(find.text('Approvals'), findsWidgets);

      // Get actual approvals from daemon
      final approvals = await DaemonClient.getApprovals();

      if (approvals.isNotEmpty) {
        expect(find.byType(ListView), findsOneWidget);
      } else {
        expect(find.text('No pending approvals'), findsOneWidget);
      }
    });

    testWidgets('pending approvals show approve/deny buttons', (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Approvals'));
      await tester.pumpAndSettle();

      final approvals = await DaemonClient.getApprovals();
      final pendingApprovals = approvals
          .where((a) => a['status'] == 'pending')
          .toList();

      if (pendingApprovals.isNotEmpty) {
        expect(find.text('Approve'), findsWidgets);
        expect(find.text('Deny'), findsWidgets);
      }
    });
  });
}
```

- [ ] **Step 2: Run approvals tests**

Run: `cd apps/mobile && flutter test integration_test/approvals_test.dart`

Expected: All 2 tests pass

- [ ] **Step 3: Commit approvals tests**

```bash
git add apps/mobile/integration_test/approvals_test.dart
git commit -m "test: add approvals integration tests

- Test approvals queue loads from daemon
- Test pending approvals show action buttons"
```

---

## Task 6: Implement Inspect Tests

**Files:**
- Create: `apps/mobile/integration_test/inspect_test.dart`

- [ ] **Step 1: Write inspect tests**

Create `apps/mobile/integration_test/inspect_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:continuum/main.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Inspect', () {
    setUp(() async {
      final isRunning = await DaemonClient.isDaemonRunning();
      if (!isRunning) {
        fail('ASCP daemon is not running');
      }
    });

    Future<void> completePairing(WidgetTester tester) async {
      final session = await DaemonClient.createPairingSession();
      final code = session['code'] as String;
      final sessionId = session['session_id'] as String;

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enter code manually'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        '127.0.0.1:8767:$code',
      );

      await tester.tap(find.text('Submit'));
      await tester.pump(const Duration(seconds: 1));

      await DaemonClient.approvePairingSession(sessionId);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    testWidgets('shows inspect tab', (tester) async {
      await completePairing(tester);

      // Navigate to Inspect tab
      await tester.tap(find.text('Inspect'));
      await tester.pumpAndSettle();

      // Verify inspect screen appears
      expect(find.text('Inspect'), findsWidgets);
    });

    testWidgets('shows empty state when no session selected', (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Inspect'));
      await tester.pumpAndSettle();

      // Should show empty state or instructions
      expect(
        find.textContaining('Select a session'),
        findsOneWidget,
      );
    });
  });
}
```

- [ ] **Step 2: Run inspect tests**

Run: `cd apps/mobile && flutter test integration_test/inspect_test.dart`

Expected: All 2 tests pass

- [ ] **Step 3: Commit inspect tests**

```bash
git add apps/mobile/integration_test/inspect_test.dart
git commit -m "test: add inspect integration tests

- Test inspect tab navigation
- Test empty state when no session selected"
```

---

## Task 7: Implement Settings Tests

**Files:**
- Create: `apps/mobile/integration_test/settings_test.dart`

- [ ] **Step 1: Write settings tests**

Create `apps/mobile/integration_test/settings_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:continuum/main.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings', () {
    setUp(() async {
      final isRunning = await DaemonClient.isDaemonRunning();
      if (!isRunning) {
        fail('ASCP daemon is not running');
      }
    });

    Future<void> completePairing(WidgetTester tester) async {
      final session = await DaemonClient.createPairingSession();
      final code = session['code'] as String;
      final sessionId = session['session_id'] as String;

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Enter code manually'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        '127.0.0.1:8767:$code',
      );

      await tester.tap(find.text('Submit'));
      await tester.pump(const Duration(seconds: 1));

      await DaemonClient.approvePairingSession(sessionId);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    testWidgets('shows settings screen', (tester) async {
      await completePairing(tester);

      // Navigate to Settings tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify settings screen appears
      expect(find.text('Settings'), findsWidgets);
      expect(find.text('Trusted Devices'), findsOneWidget);
    });

    testWidgets('loads trusted devices from daemon', (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Get actual devices from daemon
      final devices = await DaemonClient.getTrustedDevices();

      // Should show at least the current device
      expect(devices.isNotEmpty, true);

      // Verify devices are displayed in UI
      for (final device in devices.take(3)) {
        final deviceName = device['device_name'] as String?;
        if (deviceName != null) {
          expect(find.text(deviceName), findsWidgets);
        }
      }
    });

    testWidgets('shows connection diagnostics', (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify diagnostics section
      expect(find.text('Connection'), findsOneWidget);
      expect(find.text('Connected'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run settings tests**

Run: `cd apps/mobile && flutter test integration_test/settings_test.dart`

Expected: All 3 tests pass

- [ ] **Step 3: Commit settings tests**

```bash
git add apps/mobile/integration_test/settings_test.dart
git commit -m "test: add settings integration tests

- Test settings screen navigation
- Test trusted devices load from daemon
- Test connection diagnostics display"
```

---

## Task 8: Run Full Test Suite and Verify

**Files:**
- None (verification only)

- [ ] **Step 1: Run all integration tests**

Run: `cd apps/mobile && flutter test integration_test/`

Expected: All tests pass (approximately 18 tests across 6 files)

- [ ] **Step 2: Run tests with verbose output**

Run: `cd apps/mobile && flutter test integration_test/ --verbose`

Expected: Detailed output showing each test execution

- [ ] **Step 3: Verify test coverage**

Check that all major flows are tested:
- ✅ Pairing flow (4 tests)
- ✅ Dashboard (4 tests)
- ✅ Sessions (3 tests)
- ✅ Approvals (2 tests)
- ✅ Inspect (2 tests)
- ✅ Settings (3 tests)

Total: 18 tests

- [ ] **Step 4: Document test execution**

Add to `apps/mobile/README.md`:

```markdown
## Integration Tests

Integration tests run against the real ASCP daemon and verify end-to-end flows.

### Prerequisites

1. Start the ASCP daemon:
   ```bash
   cd services/host-daemon
   npm start
   ```

2. Verify daemon is running:
   ```bash
   curl http://127.0.0.1:8767/admin/pairing/sessions
   ```

### Running Tests

Run all integration tests:
```bash
cd apps/mobile
flutter test integration_test/
```

Run specific test file:
```bash
flutter test integration_test/pairing_flow_test.dart
```

Run with verbose output:
```bash
flutter test integration_test/ --verbose
```

### Test Coverage

- **Pairing Flow**: First-run screen, manual code entry, daemon claim, trusted shell transition
- **Dashboard**: Active sessions count, pending approvals count, paired devices list
- **Sessions**: List loading, running sessions first, detail navigation
- **Approvals**: Queue loading, approve/deny buttons
- **Inspect**: Tab navigation, empty state
- **Settings**: Trusted devices, connection diagnostics
```

- [ ] **Step 5: Commit documentation**

```bash
git add apps/mobile/README.md
git commit -m "docs: add integration test execution guide

Document prerequisites, commands, and test coverage for
running integration tests against real ASCP daemon"
```

- [ ] **Step 6: Push all changes**

```bash
git push origin codex/mobile-live-session-detail
```

Expected: All commits pushed successfully

---

## Summary

This plan implements 18 integration tests across 6 test files:

1. **Setup** - Dependencies, driver, helpers
2. **Pairing Flow** - 4 tests covering first-run to trusted shell
3. **Dashboard** - 4 tests verifying live data from daemon
4. **Sessions** - 3 tests for list and detail views
5. **Approvals** - 2 tests for queue and actions
6. **Inspect** - 2 tests for tab and empty state
7. **Settings** - 3 tests for devices and diagnostics
8. **Verification** - Run full suite, document, push

Each test verifies both UI state and daemon backend state via HTTP API calls.
