import '../methods/methods.dart';
import '../models/envelopes.dart';
import '../models/json_types.dart';
import '../transport/transport.dart';
import '../validation/validation.dart';
import 'protocol_error.dart';

final class AscpClient {
  AscpClient({
    required this.transport,
    this.validationHooks = const AscpValidationHooks(),
  });

  final AscpTransport transport;
  final AscpValidationHooks validationHooks;

  Stream<AscpEventEnvelope> get events => transport.events.map((event) {
    validationHooks.validateEvent?.call(event);
    return event;
  });

  Stream<AscpEventEnvelope> sessionEvents(String sessionId) =>
      events.where((event) => event.sessionId == sessionId);

  Future<void> connect() => transport.connect();

  Future<void> close() => transport.close();

  Future<AscpCapabilitiesDocument> getCapabilities({
    AscpTransportRequestOptions? options,
  }) => _request(
    'capabilities.get',
    options: options,
    decode: AscpCapabilitiesDocument.fromJson,
  );

  Future<AscpHostsGetResult> getHost({AscpTransportRequestOptions? options}) =>
      _request(
        'hosts.get',
        options: options,
        decode: AscpHostsGetResult.fromJson,
      );

  Future<AscpRuntimesListResult> listRuntimes(
    AscpRuntimesListParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'runtimes.list',
    params: params,
    options: options,
    decode: AscpRuntimesListResult.fromJson,
  );

  Future<AscpSessionsListResult> listSessions(
    AscpSessionsListParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'sessions.list',
    params: params,
    options: options,
    decode: AscpSessionsListResult.fromJson,
  );

  Future<AscpSessionsGetResult> getSession(
    AscpSessionsGetParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'sessions.get',
    params: params,
    options: options,
    decode: AscpSessionsGetResult.fromJson,
  );

  Future<AscpSessionsStartResult> startSession(
    AscpSessionsStartParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'sessions.start',
    params: params,
    options: options,
    decode: AscpSessionsStartResult.fromJson,
  );

  Future<AscpSessionsResumeResult> resumeSession(
    AscpSessionsResumeParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'sessions.resume',
    params: params,
    options: options,
    decode: AscpSessionsResumeResult.fromJson,
  );

  Future<AscpSessionsStopResult> stopSession(
    AscpSessionsStopParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'sessions.stop',
    params: params,
    options: options,
    decode: AscpSessionsStopResult.fromJson,
  );

  Future<AscpSessionsSendInputResult> sendInput(
    AscpSessionsSendInputParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'sessions.send_input',
    params: params,
    options: options,
    decode: AscpSessionsSendInputResult.fromJson,
  );

  Future<AscpSessionsSubscribeResult> subscribe(
    AscpSessionsSubscribeParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'sessions.subscribe',
    params: params,
    options: options,
    decode: AscpSessionsSubscribeResult.fromJson,
  );

  Future<AscpSessionsUnsubscribeResult> unsubscribe(
    AscpSessionsUnsubscribeParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'sessions.unsubscribe',
    params: params,
    options: options,
    decode: AscpSessionsUnsubscribeResult.fromJson,
  );

  Future<AscpApprovalsListResult> listApprovals(
    AscpApprovalsListParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'approvals.list',
    params: params,
    options: options,
    decode: AscpApprovalsListResult.fromJson,
  );

  Future<AscpApprovalsRespondResult> respondApproval(
    AscpApprovalsRespondParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'approvals.respond',
    params: params,
    options: options,
    decode: AscpApprovalsRespondResult.fromJson,
  );

  Future<AscpArtifactsListResult> listArtifacts(
    AscpArtifactsListParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'artifacts.list',
    params: params,
    options: options,
    decode: AscpArtifactsListResult.fromJson,
  );

  Future<AscpArtifactsGetResult> getArtifact(
    AscpArtifactsGetParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'artifacts.get',
    params: params,
    options: options,
    decode: AscpArtifactsGetResult.fromJson,
  );

  Future<AscpDiffsGetResult> getDiff(
    AscpDiffsGetParams params, {
    AscpTransportRequestOptions? options,
  }) => _request(
    'diffs.get',
    params: params,
    options: options,
    decode: AscpDiffsGetResult.fromJson,
  );

  Future<T> _request<T>(
    String method, {
    Object? params,
    AscpTransportRequestOptions? options,
    required T Function(AscpJsonMap json) decode,
  }) async {
    final encodedParams = _encodeParams(params);
    if (encodedParams != null) {
      validationHooks.validateParams?.call(method, encodedParams);
    }

    final response = await transport.request(
      method,
      params: encodedParams,
      options: options,
    );

    if (response is AscpTransportErrorResponse) {
      throw AscpProtocolException(method: method, response: response);
    }

    final successResponse = response as AscpTransportSuccessResponse;
    final result = ascpRequireJsonObject(
      successResponse.result,
      context: '$method result',
    );
    validationHooks.validateResult?.call(method, result);
    return decode(result);
  }

  AscpJsonMap? _encodeParams(Object? params) {
    return switch (params) {
      null => null,
      AscpJsonMap() => params,
      AscpRuntimesListParams() => params.toJson(),
      AscpSessionsListParams() => params.toJson(),
      AscpSessionsGetParams() => params.toJson(),
      AscpSessionsStartParams() => params.toJson(),
      AscpSessionsResumeParams() => params.toJson(),
      AscpSessionsStopParams() => params.toJson(),
      AscpSessionsSendInputParams() => params.toJson(),
      AscpSessionsSubscribeParams() => params.toTransportJson(),
      AscpSessionsUnsubscribeParams() => params.toJson(),
      AscpApprovalsListParams() => params.toJson(),
      AscpApprovalsRespondParams() => params.toJson(),
      AscpArtifactsListParams() => params.toJson(),
      AscpArtifactsGetParams() => params.toJson(),
      AscpDiffsGetParams() => params.toJson(),
      _ => throw ArgumentError.value(
        params,
        'params',
        'Unsupported ASCP request params type.',
      ),
    };
  }
}
