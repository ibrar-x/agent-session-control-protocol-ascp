import 'dart:async';

import '../client/client.dart';
import '../events/sync_events.dart';
import '../methods/methods.dart';
import '../models/envelopes.dart';
import '../models/json_types.dart';
import '../transport/transport.dart';

final class AscpReplayConfigurationException implements Exception {
  const AscpReplayConfigurationException(this.message);

  final String message;

  @override
  String toString() => 'AscpReplayConfigurationException: $message';
}

final class AscpReplayRequest {
  const AscpReplayRequest._({required this.kind, required this.params});

  final String kind;
  final AscpSessionsSubscribeParams params;
}

AscpReplayRequest replayFromSeq({
  required String sessionId,
  required int fromSeq,
  bool? includeSnapshot,
}) {
  return AscpReplayRequest._(
    kind: 'from_seq',
    params: AscpSessionsSubscribeParams(
      sessionId: sessionId,
      fromSeq: fromSeq,
      includeSnapshot: includeSnapshot,
    ),
  );
}

AscpReplayRequest replayAfterEventId({
  required String sessionId,
  required String fromEventId,
  bool? includeSnapshot,
}) {
  return AscpReplayRequest._(
    kind: 'from_event_id',
    params: AscpSessionsSubscribeParams(
      sessionId: sessionId,
      fromEventId: fromEventId,
      includeSnapshot: includeSnapshot,
    ),
  );
}

AscpReplayRequest replayWithOpaqueCursor({
  required String sessionId,
  bool? includeSnapshot,
  required AscpJsonMap extensionFields,
}) {
  final params = AscpSessionsSubscribeParams(
    sessionId: sessionId,
    includeSnapshot: includeSnapshot,
    extensionFields: extensionFields,
  );
  try {
    params.toTransportJson();
  } on ArgumentError catch (error) {
    throw AscpReplayConfigurationException(error.message as String);
  }

  return AscpReplayRequest._(kind: 'opaque_cursor', params: params);
}

AscpJsonMap buildReplaySubscribeParams(AscpReplayRequest request) =>
    request.params.toTransportJson();

final class AscpReplayStreamItem {
  const AscpReplayStreamItem({
    required this.kind,
    required this.event,
    this.cursor,
    this.streamPhase,
  });

  final String kind;
  final AscpEventEnvelope event;
  final String? cursor;
  final String? streamPhase;
}

final class AscpReplaySubscription {
  AscpReplaySubscription._({
    required this.client,
    required this.request,
    required this.subscribeResult,
    required StreamSubscription<AscpEventEnvelope> streamSubscription,
  }) : _streamSubscription = streamSubscription;

  final AscpClient client;
  final AscpReplayRequest request;
  final AscpSessionsSubscribeResult subscribeResult;
  final StreamController<AscpReplayStreamItem> _controller =
      StreamController<AscpReplayStreamItem>();
  final StreamSubscription<AscpEventEnvelope> _streamSubscription;

  bool _closed = false;
  bool _replayPhase = true;
  String? cursor;
  AscpSyncReplayedEvent? lastReplayed;
  AscpSyncSnapshotEvent? lastSnapshot;

  Stream<AscpReplayStreamItem> get stream => _controller.stream;

  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;

    await _streamSubscription.cancel();
    await client.unsubscribe(
      AscpSessionsUnsubscribeParams(
        subscriptionId: subscribeResult.subscriptionId,
      ),
    );
    await _controller.close();
  }

  void addEvent(AscpEventEnvelope event) {
    if (event.sessionId != subscribeResult.sessionId) {
      return;
    }

    switch (event.type) {
      case 'sync.snapshot':
        final snapshot = AscpSyncSnapshotEvent.fromJson(event.toJson());
        lastSnapshot = snapshot;
        _controller.add(AscpReplayStreamItem(kind: 'snapshot', event: event));
        return;
      case 'sync.replayed':
        final replayed = AscpSyncReplayedEvent.fromJson(event.toJson());
        lastReplayed = replayed;
        _replayPhase = false;
        _controller.add(
          AscpReplayStreamItem(kind: 'replay_complete', event: event),
        );
        return;
      case 'sync.cursor_advanced':
        final advanced = AscpSyncCursorAdvancedEvent.fromJson(event.toJson());
        cursor = advanced.payload.cursor;
        _controller.add(
          AscpReplayStreamItem(
            kind: 'cursor_advanced',
            event: event,
            cursor: cursor,
            streamPhase: _replayPhase ? 'replay' : 'live',
          ),
        );
        return;
      default:
        _controller.add(
          AscpReplayStreamItem(
            kind: _replayPhase ? 'replay_event' : 'live_event',
            event: event,
          ),
        );
    }
  }
}

Future<AscpReplaySubscription> subscribeWithReplay({
  required AscpClient client,
  required AscpReplayRequest request,
  AscpTransportRequestOptions? options,
}) {
  return subscribeWithReplayHelper(
    client: client,
    request: request,
    options: options,
  );
}

Future<AscpReplaySubscription> subscribeWithReplayHelper({
  required AscpClient client,
  required AscpReplayRequest request,
  AscpTransportRequestOptions? options,
}) async {
  late AscpReplaySubscription replaySubscription;
  final streamSubscription = client
      .sessionEvents(request.params.sessionId)
      .listen((event) => replaySubscription.addEvent(event));

  try {
    final subscribeResult = await client.subscribe(
      request.params,
      options: options,
    );
    replaySubscription = AscpReplaySubscription._(
      client: client,
      request: request,
      subscribeResult: subscribeResult,
      streamSubscription: streamSubscription,
    );
    return replaySubscription;
  } catch (_) {
    await streamSubscription.cancel();
    rethrow;
  }
}
