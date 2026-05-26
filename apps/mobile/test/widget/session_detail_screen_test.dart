import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/sessions/application/session_detail_controller.dart';
import 'package:mobile/features/sessions/data/session_repository.dart';
import 'package:mobile/features/sessions/domain/timeline_event.dart';
import 'package:mobile/features/sessions/presentation/session_detail_screen.dart';

void main() {
  testWidgets('session detail screen renders session id', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SessionDetailScreen(sessionId: 'sess_1'),
      ),
    );

    expect(find.text('Session sess_1'), findsOneWidget);
  });

  testWidgets('session detail screen loads ordered timeline', (tester) async {
    final controller = SessionDetailController(
      sessionId: 'sess_1',
      repository: MemorySessionRepository(
        timelines: const {
          'sess_1': [
            TimelineEvent(sequence: 2, id: 'evt_2', label: 'Second'),
            TimelineEvent(sequence: 1, id: 'evt_1', label: 'First'),
          ],
        },
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SessionDetailScreen(sessionId: 'sess_1', controller: controller),
      ),
    );
    await tester.pump();

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('First')).dy,
      lessThan(tester.getTopLeft(find.text('Second')).dy),
    );
  });

  testWidgets('session detail screen sends text input', (tester) async {
    final repository = MemorySessionRepository();
    final controller = SessionDetailController(
      sessionId: 'sess_1',
      repository: repository,
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SessionDetailScreen(sessionId: 'sess_1', controller: controller),
      ),
    );
    await tester.pump();
    await tester.enterText(find.byType(EditableText), 'hello host');
    await tester.tap(find.text('Send'));
    await tester.pump();

    expect(repository.sentInputs, ['sess_1:hello host']);
  });
}
