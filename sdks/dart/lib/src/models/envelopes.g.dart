// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envelopes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AscpEventEnvelope _$AscpEventEnvelopeFromJson(Map<String, dynamic> json) =>
    _AscpEventEnvelope(
      id: json['id'] as String,
      type: json['type'] as String,
      ts: json['ts'] as String,
      sessionId: json['session_id'] as String,
      runId: json['run_id'] as String?,
      seq: (json['seq'] as num?)?.toInt(),
      payload: json['payload'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$AscpEventEnvelopeToJson(_AscpEventEnvelope instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'ts': instance.ts,
      'session_id': instance.sessionId,
      'run_id': instance.runId,
      'seq': instance.seq,
      'payload': instance.payload,
    };

_AscpRequestEnvelope _$AscpRequestEnvelopeFromJson(Map<String, dynamic> json) =>
    _AscpRequestEnvelope(
      jsonrpc: json['jsonrpc'] as String,
      id: json['id'],
      method: json['method'] as String,
      params: json['params'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AscpRequestEnvelopeToJson(
  _AscpRequestEnvelope instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'method': instance.method,
  'params': instance.params,
};

_AscpMethodSuccessResponse<T> _$AscpMethodSuccessResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _AscpMethodSuccessResponse<T>(
  jsonrpc: json['jsonrpc'] as String,
  id: json['id'],
  result: fromJsonT(json['result']),
);

Map<String, dynamic> _$AscpMethodSuccessResponseToJson<T>(
  _AscpMethodSuccessResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'result': toJsonT(instance.result),
};

_AscpMethodErrorResponse _$AscpMethodErrorResponseFromJson(
  Map<String, dynamic> json,
) => _AscpMethodErrorResponse(
  jsonrpc: json['jsonrpc'] as String,
  id: json['id'],
  error: AscpProtocolError.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AscpMethodErrorResponseToJson(
  _AscpMethodErrorResponse instance,
) => <String, dynamic>{
  'jsonrpc': instance.jsonrpc,
  'id': instance.id,
  'error': instance.error.toJson(),
};
