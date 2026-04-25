// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AscpSessionSubscriptionAccepted _$AscpSessionSubscriptionAcceptedFromJson(
  Map<String, dynamic> json,
) => _AscpSessionSubscriptionAccepted(
  subscriptionId: json['subscription_id'] as String,
  sessionId: json['session_id'] as String,
  snapshotEmitted: json['snapshot_emitted'] as bool,
);

Map<String, dynamic> _$AscpSessionSubscriptionAcceptedToJson(
  _AscpSessionSubscriptionAccepted instance,
) => <String, dynamic>{
  'subscription_id': instance.subscriptionId,
  'session_id': instance.sessionId,
  'snapshot_emitted': instance.snapshotEmitted,
};
