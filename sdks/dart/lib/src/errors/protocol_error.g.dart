// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AscpProtocolError _$AscpProtocolErrorFromJson(Map<String, dynamic> json) =>
    _AscpProtocolError(
      code: json['code'] as String,
      message: json['message'] as String,
      retryable: json['retryable'] as bool,
      details: json['details'] as Map<String, dynamic>?,
      correlationId: json['correlation_id'] as String?,
    );

Map<String, dynamic> _$AscpProtocolErrorToJson(_AscpProtocolError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'retryable': instance.retryable,
      'details': instance.details,
      'correlation_id': instance.correlationId,
    };
