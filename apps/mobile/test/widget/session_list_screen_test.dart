import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/sessions/application/session_list_controller.dart';
import 'package:mobile/features/sessions/data/session_repository.dart';
import 'package:mobile/features/sessions/domain/timeline_event.dart';
import 'package:mobile/features/sessions/presentation/session_list_screen.dart';

void main() {
  testWidgets('session list screen renders loaded sessions in priority order', (
    tester,
  ) async {
    final controller = SessionListController(
      repository: MemorySessionRepository(
        sessions: [
          SessionSummary(
            id: 'sess_done',
            title: 'Completed run',
            status: 'completed',
            updatedAt: DateTime.utc(2026, 5, 25, 10),
          ),
          SessionSummary(
            id: 'sess_run',
            title: 'Live build',
            status: 'running',
            updatedAt: DateTime.utc(2026, 5, 25, 9),
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SessionListScreen(controller: controller),
      ),
    );
    await tester.pump();

    expect(find.text('Live build'), findsOneWidget);
    expect(find.text('running'), findsOneWidget);
    expect(find.text('Completed run'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Live build')).dy,
      lessThan(tester.getTopLeft(find.text('Completed run')).dy),
    );
  });

  testWidgets('session list screen renders empty state', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SessionListScreen(
          controller: SessionListController(
            repository: MemorySessionRepository(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('No active sessions'), findsOneWidget);
  });
}
