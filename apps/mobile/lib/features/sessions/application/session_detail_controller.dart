import '../domain/timeline_event.dart';
import '../data/session_repository.dart';

class SessionDetailController {
  SessionDetailController({
    required this.sessionId,
    required this.repository,
  });

  final String sessionId;
  final SessionRepository repository;
  List<TimelineEvent> timeline = const [];

  Future<void> load() async {
    timeline = orderTimelineEvents(await repository.readTimeline(sessionId));
  }

  void append(TimelineEvent event) {
    timeline = orderTimelineEvents([...timeline, event]);
  }

  Future<void> sendInput(String text) {
    return repository.sendInput(sessionId: sessionId, text: text);
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
