import 'package:freezed_annotation/freezed_annotation.dart';

import '../errors/protocol_error.dart';

part 'envelopes.freezed.dart';
part 'envelopes.g.dart';

@freezed
abstract class AscpEventEnvelope with _$AscpEventEnvelope {
  @JsonSerializable(explicitToJson: true)
  const factory AscpEventEnvelope({
    required String id,
    required String type,
    required String ts,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'run_id') String? runId,
    int? seq,
    required Map<String, Object?> payload,
  }) = _AscpEventEnvelope;

  factory AscpEventEnvelope.fromJson(Map<String, Object?> json) =>
      _$AscpEventEnvelopeFromJson(json.cast<String, dynamic>());
}

@freezed
abstract class AscpRequestEnvelope with _$AscpRequestEnvelope {
  @JsonSerializable(explicitToJson: true)
  const factory AscpRequestEnvelope({
    required String jsonrpc,
    Object? id,
    required String method,
    Map<String, Object?>? params,
  }) = _AscpRequestEnvelope;

  factory AscpRequestEnvelope.fromJson(Map<String, Object?> json) =>
      _$AscpRequestEnvelopeFromJson(json.cast<String, dynamic>());
}

@Freezed(genericArgumentFactories: true)
abstract class AscpMethodSuccessResponse<T>
    with _$AscpMethodSuccessResponse<T> {
  @JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
  const factory AscpMethodSuccessResponse({
    required String jsonrpc,
    required Object? id,
    required T result,
  }) = _AscpMethodSuccessResponse<T>;

  factory AscpMethodSuccessResponse.fromJson(
    Map<String, Object?> json,
    T Function(Object? json) fromJsonT,
  ) => _$AscpMethodSuccessResponseFromJson(
    json.cast<String, dynamic>(),
    fromJsonT,
  );
}

@freezed
abstract class AscpMethodErrorResponse with _$AscpMethodErrorResponse {
  @JsonSerializable(explicitToJson: true)
  const factory AscpMethodErrorResponse({
    required String jsonrpc,
    required Object? id,
    required AscpProtocolError error,
  }) = _AscpMethodErrorResponse;

  factory AscpMethodErrorResponse.fromJson(Map<String, Object?> json) =>
      _$AscpMethodErrorResponseFromJson(json.cast<String, dynamic>());
}
