import '../../../core/ascp/ascp_method.dart';
import '../../../core/network/json_rpc_client.dart';
import '../domain/timeline_event.dart';

abstract interface class SessionRepository {
  Future<List<SessionSummary>> listSessions();

  Future<List<TimelineEvent>> readTimeline(String sessionId);

  Future<void> sendInput({required String sessionId, required String text});
}

abstract interface class SessionSubscriptionRepository {
  Future<SessionEventSubscription> subscribeTimeline({
    required String sessionId,
    int? fromSequence,
  });
}

class SessionEventSubscription {
  const SessionEventSubscription({
    required this.id,
    required this.events,
    required Future<void> Function() cancel,
  }) : _cancel = cancel;

  final String id;
  final Stream<TimelineEvent> events;
  final Future<void> Function() _cancel;

  Future<void> cancel() => _cancel();
}

class MemorySessionRepository implements SessionRepository {
  MemorySessionRepository({
    List<SessionSummary> sessions = const [],
    Map<String, List<TimelineEvent>> timelines = const {},
  }) : _sessions = [...sessions],
       _timelines = timelines.map((key, value) => MapEntry(key, [...value]));

  final List<SessionSummary> _sessions;
  final Map<String, List<TimelineEvent>> _timelines;
  final List<String> sentInputs = [];

  @override
  Future<List<SessionSummary>> listSessions() async => [..._sessions];

  @override
  Future<List<TimelineEvent>> readTimeline(String sessionId) async {
    return [...?_timelines[sessionId]];
  }

  @override
  Future<void> sendInput({
    required String sessionId,
    required String text,
  }) async {
    sentInputs.add('$sessionId:$text');
  }
}

class AscpSessionRepository implements SessionRepository {
  const AscpSessionRepository({required this.client});

  final JsonRpcClient client;

  @override
  Future<List<SessionSummary>> listSessions() async {
    final result = await client.call(
      id: 'sessions.list',
      method: AscpMethod.sessionsList,
    );
    if (result is! Map) {
      return const [];
    }
    final sessions = result['sessions'];
    if (sessions is! List) {
      return const [];
    }
    return sessions.whereType<Map>().map((session) {
      final json = Map<String, Object?>.from(session);
      return SessionSummary(
        id: json['id'] as String? ?? '',
        title:
            json['title'] as String? ??
            json['id'] as String? ??
            'Untitled session',
        status: json['status'] as String? ?? 'idle',
        updatedAt:
            DateTime.tryParse(json['updated_at'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
      );
    }).toList();
  }

  @override
  Future<List<TimelineEvent>> readTimeline(String sessionId) async {
    final result = await client.call(
      id: 'sessions.get',
      method: AscpMethod.sessionsGet,
      params: {'session_id': sessionId, 'include_events': true},
    );
    if (result is! Map) {
      return const [];
    }
    final events = result['events'];
    if (events is! List) {
      return const [];
    }
    return events.whereType<Map>().map((event) {
      final json = Map<String, Object?>.from(event);
      return TimelineEvent(
        sequence: json['seq'] as int?,
        id: json['id'] as String? ?? '',
        label: json['type'] as String? ?? 'event',
      );
    }).toList();
  }

  @override
  Future<void> sendInput({
    required String sessionId,
    required String text,
  }) async {
    await client.call(
      id: 'sessions.send_input',
      method: AscpMethod.sessionsSendInput,
      params: {
        'session_id': sessionId,
        'input': {'kind': 'text', 'text': text},
      },
    );
  }
}

class AscpSessionSubscriptionRepository
    implements SessionSubscriptionRepository {
  const AscpSessionSubscriptionRepository({required this.client});

  final EventJsonRpcClient client;

  @override
  Future<SessionEventSubscription> subscribeTimeline({
    required String sessionId,
    int? fromSequence,
  }) async {
    final params = <String, Object?>{'session_id': sessionId};
    if (fromSequence != null) {
      params['from_seq'] = fromSequence;
    }

    final result = await client.call(
      id: 'sessions.subscribe',
      method: AscpMethod.sessionsSubscribe,
      params: params,
    );
    if (result is! Map) {
      throw const FormatException(
        'sessions.subscribe result must be an object.',
      );
    }
    final subscriptionId = result['subscription_id'];
    if (subscriptionId is! String) {
      throw const FormatException(
        'sessions.subscribe requires subscription_id.',
      );
    }

    return SessionEventSubscription(
      id: subscriptionId,
      events: client.events
          .where((event) => event.sessionId == sessionId)
          .map(
            (event) => TimelineEvent(
              sequence: event.sequence,
              id: event.id,
              label: event.rawType,
            ),
          ),
      cancel: () async {
        await client.call(
          id: 'sessions.unsubscribe',
          method: AscpMethod.sessionsUnsubscribe,
          params: {'subscription_id': subscriptionId},
        );
      },
    );
  }
}
