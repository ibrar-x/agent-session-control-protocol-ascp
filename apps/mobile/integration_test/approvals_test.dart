import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'test_app.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Approvals', () {
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

    testWidgets('loads approvals queue', (tester) async {
      await completePairing(tester);

      // Navigate to Approvals tab
      await tester.tap(find.text('Approvals'));
      await tester.pumpAndSettle();

      // Verify approvals screen appears
      expect(find.text('Approvals'), findsWidgets);

      // Verify at least one approval is displayed or empty state
      final hasApprovals = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmpty = find.textContaining('No pending approvals').evaluate().isNotEmpty;
      expect(hasApprovals || hasEmpty, true);
    });

    testWidgets('shows approve/deny buttons for pending approvals',
        (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Approvals'));
      await tester.pumpAndSettle();

      // Check if there are any pending approvals
      final hasPending = find.text('Approve').evaluate().isNotEmpty;

      if (hasPending) {
        // Verify approve/deny buttons exist
        expect(find.text('Approve'), findsWidgets);
        expect(find.text('Reject'), findsWidgets);
      }
    });
  });
}
