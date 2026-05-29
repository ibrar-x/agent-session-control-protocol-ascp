import 'dart:async';

import '../domain/timeline_event.dart';
import '../data/session_repository.dart';

class SessionDetailController {
  SessionDetailController({
    required this.sessionId,
    required this.repository,
    this.subscriptionRepository,
  });

  final String sessionId;
  final SessionRepository repository;
  final SessionSubscriptionRepository? subscriptionRepository;
  List<TimelineEvent> timeline = const [];
  SessionEventSubscription? _subscription;
  StreamSubscription<TimelineEvent>? _eventSubscription;

  Future<void> load({void Function()? onEvent}) async {
    timeline = orderTimelineEvents(await repository.readTimeline(sessionId));
    final liveRepository = subscriptionRepository;
    if (liveRepository == null) {
      return;
    }
    _subscription = await liveRepository.subscribeTimeline(
      sessionId: sessionId,
      fromSequence: _lastSequence(),
    );
    _eventSubscription = _subscription!.events.listen((event) {
      append(event);
      onEvent?.call();
    });
  }

  void append(TimelineEvent event) {
    timeline = orderTimelineEvents([...timeline, event]);
  }

  Future<void> sendInput(String text) {
    return repository.sendInput(sessionId: sessionId, text: text);
  }

  Future<void> dispose() async {
    await _eventSubscription?.cancel();
    await _subscription?.cancel();
  }

  int? _lastSequence() {
    int? last;
    for (final event in timeline) {
      final sequence = event.sequence;
      if (sequence != null && (last == null || sequence > last)) {
        last = sequence;
      }
    }
    return last;
  }
}

List<TimelineEvent> orderTimelineEvents(List<TimelineEvent> events) {
  final ordered = [...events]
    ..sort((a, b) {
      final left = a.sequence;
      final right = b.sequence;
      if (left == null && right == null) {
        return a.id.compareTo(b.id);
      }
      if (left == null) {
        return 1;
      }
      if (right == null) {
        return -1;
      }
      return left.compareTo(right);
    });
  return ordered;
}
