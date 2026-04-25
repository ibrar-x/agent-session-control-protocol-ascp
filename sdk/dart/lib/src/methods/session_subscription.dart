import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_subscription.freezed.dart';
part 'session_subscription.g.dart';

@freezed
abstract class AscpSessionSubscriptionAccepted
    with _$AscpSessionSubscriptionAccepted {
  @JsonSerializable(explicitToJson: true)
  const factory AscpSessionSubscriptionAccepted({
    @JsonKey(name: 'subscription_id') required String subscriptionId,
    @JsonKey(name: 'session_id') required String sessionId,
    @JsonKey(name: 'snapshot_emitted') required bool snapshotEmitted,
  }) = _AscpSessionSubscriptionAccepted;

  factory AscpSessionSubscriptionAccepted.fromJson(Map<String, Object?> json) =>
      _$AscpSessionSubscriptionAcceptedFromJson(json.cast<String, dynamic>());
}
