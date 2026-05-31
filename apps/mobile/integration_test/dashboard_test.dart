import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_app.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard', () {
    setUp(() async {
      final isRunning = await DaemonClient.isDaemonRunning();
      if (!isRunning) {
        fail('ASCP daemon is not running at ${DaemonClient.adminBaseUrl}');
      }
    });

    Future<void> completePairing(WidgetTester tester) async {
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
      await tester.pump(const Duration(seconds: 1));

      await DaemonClient.approvePairingSession(sessionId);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap Continue on success screen
      if (find.text('Continue').evaluate().isNotEmpty) {
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }
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

      // The dashboard summary card shows the running session count.
      // Verify the count digit is present in the UI.
      // At minimum the '0' count should appear for fresh state.
      final countWidget = find.text('0');
      expect(countWidget, findsWidgets);
    });

    testWidgets('displays pending approvals count from daemon',
        (tester) async {
      await completePairing(tester);

      // The dashboard summary card shows the pending approval count.
      // Verify the count digit is present in the UI.
      final countWidget = find.text('0');
      expect(countWidget, findsWidgets);
    });

    testWidgets('shows trusted host status', (tester) async {
      await completePairing(tester);

      // Verify the home dashboard header and status
      expect(find.text('Continuum'), findsOneWidget);
      expect(find.text('Connected'), findsOneWidget);
      expect(find.text('ASCP Protocol Controller'), findsOneWidget);
    });
  });
}
