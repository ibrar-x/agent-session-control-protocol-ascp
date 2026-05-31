import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/sessions/application/session_detail_controller.dart';
import 'package:mobile/features/sessions/data/session_repository.dart';
import 'package:mobile/features/sessions/domain/timeline_event.dart';
import 'package:mobile/features/sessions/presentation/session_detail_screen.dart';

void main() {
  testWidgets('session detail screen renders chat header and session id', (
    tester,
  ) async {
    final controller = SessionDetailController(
      sessionId: 'sess_1',
      repository: MemorySessionRepository(
        sessions: [
          SessionSummary(
            id: 'sess_1',
            title: 'refactor-auth',
            status: 'waiting_approval',
            updatedAt: DateTime(2026, 5, 31),
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SessionDetailScreen(sessionId: 'sess_1', controller: controller),
      ),
    );
    await tester.pump();

    expect(find.text('refactor-auth'), findsOneWidget);
    expect(find.text('● Approval needed'), findsOneWidget);
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
    await tester.tap(find.text('🎙'));
    await tester.pump();

    expect(repository.sentInputs, ['sess_1:hello host']);
  });

  testWidgets('session detail screen renders live subscription events', (
    tester,
  ) async {
    final repository = MemorySessionRepository();
    final subscriptionRepository = _FakeSubscriptionRepository();
    final controller = SessionDetailController(
      sessionId: 'sess_1',
      repository: repository,
      subscriptionRepository: subscriptionRepository,
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SessionDetailScreen(sessionId: 'sess_1', controller: controller),
      ),
    );
    await tester.pumpAndSettle();

    subscriptionRepository.add(
      const TimelineEvent(
        sequence: 7,
        id: 'evt_tool',
        label: 'tool.started read_file',
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('tool.started'), findsOneWidget);
    expect(find.text('read_file'), findsOneWidget);
    expect(find.text('sess_1'), findsOneWidget);
  });

  testWidgets('session detail screen styles approval and terminal events', (
    tester,
  ) async {
    final controller = SessionDetailController(
      sessionId: 'sess_1',
      repository: MemorySessionRepository(
        timelines: const {
          'sess_1': [
            TimelineEvent(
              sequence: 1,
              id: 'evt_approval',
              label: 'approval.request run npm test',
            ),
            TimelineEvent(
              sequence: 2,
              id: 'evt_terminal',
              label: 'terminal.output test output',
            ),
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

    expect(find.text('Approval requested'), findsOneWidget);
    expect(find.text('Approve'), findsOneWidget);
    expect(find.text('Deny'), findsOneWidget);
    expect(find.text('Terminal'), findsOneWidget);
    expect(find.text('test output'), findsOneWidget);
  });
}

class _FakeSubscriptionRepository implements SessionSubscriptionRepository {
  final _controller = StreamController<TimelineEvent>.broadcast();

  void add(TimelineEvent event) {
    _controller.add(event);
  }

  @override
  Future<SessionEventSubscription> subscribeTimeline({
    required String sessionId,
    int? fromSequence,
  }) async {
    return SessionEventSubscription(
      id: 'sub_$sessionId',
      events: _controller.stream,
      cancel: () => _controller.close(),
    );
  }
}
