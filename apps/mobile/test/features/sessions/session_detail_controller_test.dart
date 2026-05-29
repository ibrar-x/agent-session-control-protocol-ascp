import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mobile/core/ascp/ascp_models.dart';
import 'package:mobile/features/sessions/application/session_detail_controller.dart';
import 'package:mobile/features/sessions/application/session_list_controller.dart';
import 'package:mobile/features/sessions/data/session_repository.dart';
import 'package:mobile/features/sessions/domain/session_filters.dart';
import 'package:mobile/features/sessions/domain/timeline_event.dart';
import 'package:mobile/core/network/http_json_rpc_client.dart';
import 'package:mobile/core/network/websocket_json_rpc_client.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  test('timeline keeps events ordered by ASCP sequence', () {
    final ordered = orderTimelineEvents([
      const TimelineEvent(sequence: 3, id: 'third', label: 'Third'),
      const TimelineEvent(sequence: 1, id: 'first', label: 'First'),
      const TimelineEvent(sequence: 2, id: 'second', label: 'Second'),
    ]);

    expect(ordered.map((event) => event.id), ['first', 'second', 'third']);
  });

  test(
    'timeline leaves unsequenced mobile-local events after sequenced events',
    () {
      final ordered = orderTimelineEvents([
        const TimelineEvent(sequence: null, id: 'local', label: 'Local draft'),
        const TimelineEvent(sequence: 1, id: 'remote', label: 'Remote event'),
      ]);

      expect(ordered.map((event) => event.id), ['remote', 'local']);
    },
  );

  test('session filters accept matching status and query', () {
    const filters = SessionFilters(
      statuses: {AscpSessionStatus.running},
      query: 'build',
    );

    expect(
      filters.accepts(
        status: AscpSessionStatus.running,
        title: 'Build mobile app',
      ),
      isTrue,
    );
    expect(
      filters.accepts(
        status: AscpSessionStatus.completed,
        title: 'Build mobile app',
      ),
      isFalse,
    );
  });

  test('session list controller orders running sessions first', () async {
    final controller = SessionListController(
      repository: MemorySessionRepository(
        sessions: [
          SessionSummary(
            id: 'completed',
            title: 'Completed',
            status: 'completed',
            updatedAt: DateTime(2026, 5, 25, 10),
          ),
          SessionSummary(
            id: 'running',
            title: 'Running',
            status: 'running',
            updatedAt: DateTime(2026, 5, 25, 9),
          ),
        ],
      ),
    );

    final sessions = await controller.load();

    expect(sessions.map((session) => session.id), ['running', 'completed']);
  });

  test('session detail controller appends events in sequence order', () {
    final controller =
        SessionDetailController(
            sessionId: 'sess_1',
            repository: MemorySessionRepository(),
          )
          ..append(
            const TimelineEvent(sequence: 2, id: 'second', label: 'Second'),
          )
          ..append(
            const TimelineEvent(sequence: 1, id: 'first', label: 'First'),
          );

    expect(controller.timeline.map((event) => event.id), ['first', 'second']);
  });

  test('session detail controller delegates send input', () async {
    final repository = MemorySessionRepository();
    final controller = SessionDetailController(
      sessionId: 'sess_1',
      repository: repository,
    );

    await controller.sendInput('hello');

    expect(repository.sentInputs, ['sess_1:hello']);
  });

  test('ASCP session repository maps sessions.list response', () async {
    final dio = Dio()
      ..httpClientAdapter = _FakeAdapter(
        '{"jsonrpc":"2.0","id":"sessions.list","result":{"sessions":[{"id":"sess_1","title":"Build","status":"running","updated_at":"2026-05-25T10:00:00Z"}]}}',
      );
    final repository = AscpSessionRepository(
      client: HttpJsonRpcClient(
        dio: dio,
        endpoint: Uri.parse('http://host/rpc'),
      ),
    );

    final sessions = await repository.listSessions();

    expect(sessions.single.id, 'sess_1');
    expect(sessions.single.status, 'running');
  });

  test('ASCP session repository maps timeline payload content', () async {
    final dio = Dio()
      ..httpClientAdapter = _FakeAdapter(
        '{"jsonrpc":"2.0","id":"sessions.get","result":{"events":[{"id":"evt_1","type":"message.user","seq":1,"payload":{"content":"hello from host"}},{"id":"evt_2","type":"run.failed","seq":2,"payload":{"message":"Usage limit"}}]}}',
      );
    final repository = AscpSessionRepository(
      client: HttpJsonRpcClient(
        dio: dio,
        endpoint: Uri.parse('http://host/rpc'),
      ),
    );

    final timeline = await repository.readTimeline('sess_1');

    expect(timeline.first.label, 'message.user hello from host');
    expect(timeline.last.label, 'run.failed Usage limit');
  });

  test('ASCP session repository delegates send input method', () async {
    final adapter = _RecordingAdapter(
      '{"jsonrpc":"2.0","id":"sessions.send_input","result":{"accepted":true}}',
    );
    final dio = Dio()..httpClientAdapter = adapter;
    final repository = AscpSessionRepository(
      client: HttpJsonRpcClient(
        dio: dio,
        endpoint: Uri.parse('http://host/rpc'),
      ),
    );

    await repository.sendInput(sessionId: 'sess_1', text: 'hello');

    expect(adapter.requestBody, contains('sessions.send_input'));
    expect(adapter.requestBody, contains('"input":"hello"'));
    expect(adapter.requestBody, contains('"input_kind":"instruction"'));
    expect(adapter.requestBody, isNot(contains('"kind":"text"')));
  });

  test('ASCP session subscription repository maps replay events', () async {
    final channel = _FakeWebSocketChannel();
    final client = WebSocketJsonRpcClient(channel: channel);
    final repository = AscpSessionSubscriptionRepository(client: client);

    final pending = repository.subscribeTimeline(
      sessionId: 'sess_1',
      fromSequence: 7,
    );
    await Future<void>.delayed(Duration.zero);
    expect(channel.sent.single as String, contains('sessions.subscribe'));
    expect(channel.sent.single as String, contains('"from_seq":7'));

    channel.serverSend({
      'jsonrpc': '2.0',
      'id': 'sessions.subscribe',
      'result': {'subscription_id': 'sub_1'},
    });
    final subscription = await pending;

    final eventFuture = subscription.events.first;
    channel.serverSend({
      'id': 'evt_other',
      'type': 'message.user',
      'ts': '2026-05-25T10:00:00Z',
      'session_id': 'other',
      'seq': 8,
      'payload': {'text': 'ignored'},
    });
    channel.serverSend({
      'id': 'evt_1',
      'type': 'message.user',
      'ts': '2026-05-25T10:00:01Z',
      'session_id': 'sess_1',
      'seq': 9,
      'payload': {'text': 'hello'},
    });

    final event = await eventFuture;
    expect(event.id, 'evt_1');
    expect(event.sequence, 9);
    expect(event.label, 'message.user hello');

    final cancel = subscription.cancel();
    await Future<void>.delayed(Duration.zero);
    expect(channel.sent.last as String, contains('sessions.unsubscribe'));
    channel.serverSend({
      'jsonrpc': '2.0',
      'id': 'sessions.unsubscribe',
      'result': {'ok': true},
    });
    await cancel;
    await client.close();
  });
}

class _FakeAdapter implements HttpClientAdapter {
  const _FakeAdapter(this.body);

  final String body;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class _RecordingAdapter extends _FakeAdapter {
  _RecordingAdapter(super.body);

  String requestBody = '';

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final chunks = <int>[];
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        chunks.addAll(chunk);
      }
    }
    requestBody = String.fromCharCodes(chunks);
    return super.fetch(options, requestStream, cancelFuture);
  }
}

class _FakeWebSocketChannel extends StreamChannelMixin
    implements WebSocketChannel {
  final _incoming = StreamController<Object?>();
  final _outgoing = StreamController<Object?>();
  final List<Object?> sent = [];

  _FakeWebSocketChannel() {
    _outgoing.stream.listen(sent.add);
  }

  void serverSend(Map<String, Object?> json) {
    _incoming.add(jsonEncode(json));
  }

  @override
  Stream get stream => _incoming.stream;

  @override
  WebSocketSink get sink => _FakeWebSocketSink(_outgoing);

  @override
  int? get closeCode => null;

  @override
  String? get closeReason => null;

  @override
  String? get protocol => null;

  @override
  Future<void> get ready => Future.value();
}

class _FakeWebSocketSink implements WebSocketSink {
  _FakeWebSocketSink(this._controller);

  final StreamController<Object?> _controller;

  @override
  void add(Object? data) {
    _controller.add(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  @override
  Future<void> addStream(Stream stream) => _controller.addStream(stream);

  @override
  Future<void> close([int? closeCode, String? closeReason]) =>
      _controller.close();

  @override
  Future<void> get done => _controller.done;
}
