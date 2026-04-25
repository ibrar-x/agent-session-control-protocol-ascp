import '../models/envelopes.dart';
import '../models/json_types.dart';

typedef AscpValidateParams = void Function(String method, AscpJsonMap params);
typedef AscpValidateResult = void Function(String method, AscpJsonMap result);
typedef AscpValidateEvent = void Function(AscpEventEnvelope event);

final class AscpValidationHooks {
  const AscpValidationHooks({
    this.validateParams,
    this.validateResult,
    this.validateEvent,
  });

  final AscpValidateParams? validateParams;
  final AscpValidateResult? validateResult;
  final AscpValidateEvent? validateEvent;
}

final class AscpValidationException implements Exception {
  const AscpValidationException({required this.context, required this.message});

  final String context;
  final String message;

  @override
  String toString() => 'AscpValidationException($context): $message';
}

AscpJsonMap ascpRequireJsonObject(Object? value, {required String context}) {
  if (value is Map<String, Object?>) {
    return value;
  }

  if (value is Map) {
    return value.cast<String, Object?>();
  }

  throw AscpValidationException(
    context: context,
    message: 'Expected a JSON object.',
  );
}

T ascpDecodeJsonObject<T>(
  Object? value, {
  required String context,
  required T Function(AscpJsonMap json) fromJson,
}) {
  return fromJson(ascpRequireJsonObject(value, context: context));
}
