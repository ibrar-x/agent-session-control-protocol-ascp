import 'package:freezed_annotation/freezed_annotation.dart';

part 'protocol_error.freezed.dart';
part 'protocol_error.g.dart';

@freezed
abstract class AscpProtocolError with _$AscpProtocolError {
  @JsonSerializable(explicitToJson: true)
  const factory AscpProtocolError({
    required String code,
    required String message,
    required bool retryable,
    Map<String, Object?>? details,
    @JsonKey(name: 'correlation_id') String? correlationId,
  }) = _AscpProtocolError;

  factory AscpProtocolError.fromJson(Map<String, Object?> json) =>
      _$AscpProtocolErrorFromJson(json.cast<String, dynamic>());
}
