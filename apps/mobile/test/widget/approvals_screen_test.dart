import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/approvals/application/approval_queue_controller.dart';
import 'package:mobile/features/approvals/data/approval_repository.dart';
import 'package:mobile/features/approvals/domain/approval_view_model.dart';
import 'package:mobile/features/approvals/presentation/approvals_screen.dart';

void main() {
  testWidgets('approvals screen renders queue title', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ApprovalsScreen(),
      ),
    );

    expect(find.text('Approvals'), findsOneWidget);
  });

  testWidgets(
    'approvals screen shows no pending actions subtitle when queue is empty',
    (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ApprovalsScreen(),
        ),
      );
      await tester.pump();

      expect(find.text('No pending actions'), findsOneWidget);
    },
  );

  testWidgets('approvals screen shows singular pending action subtitle', (
    tester,
  ) async {
    final controller = ApprovalQueueController(
      repository: MemoryApprovalRepository(
        approvals: [
          ApprovalViewModel.pending(
            id: 'approval_1',
            sessionId: 'sess_1',
            isActionable: true,
            reason: 'Run command',
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ApprovalsScreen(controller: controller),
      ),
    );
    await tester.pump();

    expect(find.text('1 pending action'), findsOneWidget);
  });

  testWidgets('approvals screen shows plural pending actions subtitle', (
    tester,
  ) async {
    final controller = ApprovalQueueController(
      repository: MemoryApprovalRepository(
        approvals: [
          ApprovalViewModel.pending(
            id: 'approval_1',
            sessionId: 'sess_1',
            isActionable: true,
            reason: 'Run command',
          ),
          ApprovalViewModel.pending(
            id: 'approval_2',
            sessionId: 'sess_2',
            isActionable: true,
            reason: 'Write file',
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ApprovalsScreen(controller: controller),
      ),
    );
    await tester.pump();

    expect(find.text('2 pending actions'), findsOneWidget);
  });

  testWidgets('approvals screen renders pending approvals', (tester) async {
    final controller = ApprovalQueueController(
      repository: MemoryApprovalRepository(
        approvals: [
          ApprovalViewModel.pending(
            id: 'approval_1',
            sessionId: 'sess_1',
            isActionable: true,
            reason: 'Run command',
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ApprovalsScreen(controller: controller),
      ),
    );
    await tester.pump();

    expect(find.text('Run command'), findsOneWidget);
    expect(find.text('Approve'), findsOneWidget);
    expect(find.text('Reject'), findsOneWidget);
  });

  testWidgets('approvals screen delegates approve action', (tester) async {
    final repository = MemoryApprovalRepository(
      approvals: [
        ApprovalViewModel.pending(
          id: 'approval_1',
          sessionId: 'sess_1',
          isActionable: true,
          reason: 'Run command',
        ),
      ],
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ApprovalsScreen(
          controller: ApprovalQueueController(repository: repository),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Approve'));
    await tester.pump();

    expect(repository.responses, ['approval_1:approved']);
  });
}
