import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_app.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sessions', () {
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

    testWidgets('loads sessions list from daemon', (tester) async {
      await completePairing(tester);

      // Navigate to Sessions tab
      await tester.tap(find.text('Sessions'));
      await tester.pumpAndSettle();

      // Verify sessions list or empty state appears
      expect(find.text('Sessions'), findsWidgets);

      // Verify at least one session is displayed or empty state
      final hasEmpty = find.textContaining('No active sessions').evaluate().isNotEmpty;
      final hasList = find.byType(ListView).evaluate().isNotEmpty;
      expect(hasEmpty || hasList, true);
    });

    testWidgets('taps session to open detail view', (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Sessions'));
      await tester.pumpAndSettle();

      // If sessions exist, tap one to open detail view
      final hasSessions = find.textContaining('No active sessions').evaluate().isEmpty;
      if (hasSessions) {
        // Session items are GestureDetector widgets inside ListView
        final gestureDetectors = find.descendant(
          of: find.byType(ListView),
          matching: find.byType(GestureDetector),
        );
        if (gestureDetectors.evaluate().isNotEmpty) {
          await tester.tap(gestureDetectors.first);
          await tester.pumpAndSettle();

          // Verify detail view appears with Live feed header
          expect(find.text('Live feed'), findsOneWidget);
        }
      } else {
        // Verify empty state is shown
        expect(find.textContaining('No active sessions'), findsOneWidget);
      }
    });
  });
}
