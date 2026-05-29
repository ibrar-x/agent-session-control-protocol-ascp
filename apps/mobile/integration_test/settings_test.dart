import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:integration_test/integration_test.dart';
import 'test_app.dart' as app;
import 'helpers/daemon_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings', () {
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

      await tester.tap(find.text('Enter code manually'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(EditableText),
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

    testWidgets('shows settings screen', (tester) async {
      await completePairing(tester);

      // Navigate to Settings tab
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify settings screen appears
      expect(find.text('Settings'), findsWidgets);
    });

    testWidgets('shows trusted devices section', (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify trusted devices section exists
      expect(find.text('TRUSTED DEVICES'), findsOneWidget);
    });

    testWidgets('shows connection diagnostics', (tester) async {
      await completePairing(tester);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Verify connection diagnostics section
      expect(find.text('CONNECTION'), findsOneWidget);
    });
  });
}
