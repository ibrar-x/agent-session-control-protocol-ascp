import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/app/continuum_app.dart';
import 'package:mobile/app/mobile_dependencies.dart';
import 'package:mobile/features/approvals/application/approval_queue_controller.dart';
import 'package:mobile/features/approvals/data/approval_repository.dart';
import 'package:mobile/features/approvals/domain/approval_view_model.dart';
import 'package:mobile/features/sessions/application/session_list_controller.dart';
import 'package:mobile/features/sessions/data/session_repository.dart';
import 'package:mobile/features/sessions/domain/timeline_event.dart';

void main() {
  testWidgets('first-run shell exposes pairing scan and manual paths', (
    tester,
  ) async {
    await tester.pumpWidget(const ContinuumMobileApp());

    expect(find.text('Continuum'), findsOneWidget);
    expect(find.text('Pair a host'), findsOneWidget);
    expect(find.text('Scan QR code'), findsOneWidget);

    await tester.tap(find.text('Enter code manually'));
    await tester.pump();

    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('trusted shell can move from sessions to approvals', (
    tester,
  ) async {
    final dependencies = MobileDependencies.memory(
      sessionListController: SessionListController(
        repository: MemorySessionRepository(
          sessions: [
            SessionSummary(
              id: 'sess_live',
              title: 'Live ASCP session',
              status: 'running',
              updatedAt: DateTime.utc(2026, 5, 25, 13),
            ),
          ],
        ),
      ),
      approvalQueueController: ApprovalQueueController(
        repository: MemoryApprovalRepository(
          approvals: [
            ApprovalViewModel.pending(
              id: 'approval_live',
              sessionId: 'sess_live',
              isActionable: true,
              reason: 'Allow command',
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(
      ContinuumMobileApp(isTrusted: true, dependencies: dependencies),
    );

    await tester.tap(find.text('Sessions').last);
    await tester.pump();
    await tester.pump();
    expect(find.text('Live ASCP session'), findsOneWidget);

    await tester.tap(find.text('Approvals').last);
    await tester.pump();
    await tester.pump();
    expect(find.text('Allow command'), findsOneWidget);
  });
}
