import '../data/session_repository.dart';
import '../domain/session_filters.dart';
import '../domain/timeline_event.dart';

class SessionListController {
  const SessionListController({required this.repository});

  final SessionRepository repository;

  Future<List<SessionSummary>> load({SessionFilters filters = const SessionFilters()}) async {
    final sessions = await repository.listSessions();
    final filtered = sessions
        .where(
          (session) => filters.accepts(
            statusName: session.status,
            title: session.title,
          ),
        )
        .toList();
    filtered.sort(_compareSessions);
    return filtered;
  }

  int _compareSessions(SessionSummary a, SessionSummary b) {
    final byStatus = _statusRank(a.status).compareTo(_statusRank(b.status));
    if (byStatus != 0) {
      return byStatus;
    }
    return b.updatedAt.compareTo(a.updatedAt);
  }

  int _statusRank(String status) {
    return switch (status) {
      'running' => 0,
      'waiting_approval' => 1,
      'waiting_input' => 2,
      'idle' => 3,
      'completed' => 4,
      'failed' => 5,
      'stopped' => 6,
      'disconnected' => 7,
      _ => 8,
    };
  }
}
