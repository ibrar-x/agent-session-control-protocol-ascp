import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_app.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Pairing Flow', () {
    setUp(() async {
      final isRunning = await DaemonClient.isDaemonRunning();
      if (!isRunning) {
        fail('ASCP daemon is not running at ${DaemonClient.adminBaseUrl}');
      }
    });

    testWidgets('shows first-run pairing screen on fresh install',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Continuum'), findsOneWidget);
      expect(find.text('Unpaired'), findsOneWidget);
      expect(find.text('Scanning'), findsOneWidget);
      expect(find.text('Pair New Device'), findsOneWidget);
      expect(find.text('or enter code'), findsOneWidget);
    });

    testWidgets('taps Enter code manually and shows text field',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('or enter code'));
      await tester.pumpAndSettle();

      expect(find.byType(EditableText), findsWidgets);
      expect(find.text('Verify'), findsOneWidget);
      expect(find.text('Enter Pairing Code'), findsOneWidget);
    });

    testWidgets('enters pairing code and submits to daemon', (tester) async {
      final session = await DaemonClient.createPairingSession();
      final code = session['code'] as String;
      final sessionId = session['session_id'] as String;

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('or enter code'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(EditableText).first,
        '127.0.0.1:8767:$code',
      );

      await tester.tap(find.text('Verify'));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 3));
      final sessions = await DaemonClient.getPairingSessions();
      final claimedSession = sessions.firstWhere(
        (s) => s['session_id'] == sessionId,
        orElse: () => {},
      );

      expect(claimedSession.isNotEmpty, true);
      expect(
        claimedSession['status'],
        anyOf(equals('pending_host_claim'), equals('pending_host_approval')),
      );
    });

    testWidgets('transitions to trusted shell after approval', (tester) async {
      final session = await DaemonClient.createPairingSession();
      final code = session['code'] as String;
      final sessionId = session['session_id'] as String;

      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('or enter code'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(EditableText).first,
        '127.0.0.1:8767:$code',
      );

      await tester.tap(find.text('Verify'));
      await tester.pump(const Duration(seconds: 2));

      await DaemonClient.approvePairingSession(sessionId);

      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Tap Continue on the "Device Paired" screen to transition to trusted shell
      if (find.text('Continue').evaluate().isNotEmpty) {
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Sessions'), findsOneWidget);
      expect(find.text('Approvals'), findsOneWidget);
    });
  });
}
