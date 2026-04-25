// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AscpSessionSubscriptionAccepted {

@JsonKey(name: 'subscription_id') String get subscriptionId;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'snapshot_emitted') bool get snapshotEmitted;
/// Create a copy of AscpSessionSubscriptionAccepted
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionSubscriptionAcceptedCopyWith<AscpSessionSubscriptionAccepted> get copyWith => _$AscpSessionSubscriptionAcceptedCopyWithImpl<AscpSessionSubscriptionAccepted>(this as AscpSessionSubscriptionAccepted, _$identity);

  /// Serializes this AscpSessionSubscriptionAccepted to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionSubscriptionAccepted&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.snapshotEmitted, snapshotEmitted) || other.snapshotEmitted == snapshotEmitted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscriptionId,sessionId,snapshotEmitted);

@override
String toString() {
  return 'AscpSessionSubscriptionAccepted(subscriptionId: $subscriptionId, sessionId: $sessionId, snapshotEmitted: $snapshotEmitted)';
}


}

/// @nodoc
abstract mixin class $AscpSessionSubscriptionAcceptedCopyWith<$Res>  {
  factory $AscpSessionSubscriptionAcceptedCopyWith(AscpSessionSubscriptionAccepted value, $Res Function(AscpSessionSubscriptionAccepted) _then) = _$AscpSessionSubscriptionAcceptedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'subscription_id') String subscriptionId,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'snapshot_emitted') bool snapshotEmitted
});




}
/// @nodoc
class _$AscpSessionSubscriptionAcceptedCopyWithImpl<$Res>
    implements $AscpSessionSubscriptionAcceptedCopyWith<$Res> {
  _$AscpSessionSubscriptionAcceptedCopyWithImpl(this._self, this._then);

  final AscpSessionSubscriptionAccepted _self;
  final $Res Function(AscpSessionSubscriptionAccepted) _then;

/// Create a copy of AscpSessionSubscriptionAccepted
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subscriptionId = null,Object? sessionId = null,Object? snapshotEmitted = null,}) {
  return _then(_self.copyWith(
subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,snapshotEmitted: null == snapshotEmitted ? _self.snapshotEmitted : snapshotEmitted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionSubscriptionAccepted].
extension AscpSessionSubscriptionAcceptedPatterns on AscpSessionSubscriptionAccepted {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionSubscriptionAccepted value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionSubscriptionAccepted() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionSubscriptionAccepted value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionSubscriptionAccepted():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionSubscriptionAccepted value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionSubscriptionAccepted() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'subscription_id')  String subscriptionId, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'snapshot_emitted')  bool snapshotEmitted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionSubscriptionAccepted() when $default != null:
return $default(_that.subscriptionId,_that.sessionId,_that.snapshotEmitted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'subscription_id')  String subscriptionId, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'snapshot_emitted')  bool snapshotEmitted)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionSubscriptionAccepted():
return $default(_that.subscriptionId,_that.sessionId,_that.snapshotEmitted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'subscription_id')  String subscriptionId, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'snapshot_emitted')  bool snapshotEmitted)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionSubscriptionAccepted() when $default != null:
return $default(_that.subscriptionId,_that.sessionId,_that.snapshotEmitted);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSessionSubscriptionAccepted implements AscpSessionSubscriptionAccepted {
  const _AscpSessionSubscriptionAccepted({@JsonKey(name: 'subscription_id') required this.subscriptionId, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'snapshot_emitted') required this.snapshotEmitted});
  factory _AscpSessionSubscriptionAccepted.fromJson(Map<String, dynamic> json) => _$AscpSessionSubscriptionAcceptedFromJson(json);

@override@JsonKey(name: 'subscription_id') final  String subscriptionId;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'snapshot_emitted') final  bool snapshotEmitted;

/// Create a copy of AscpSessionSubscriptionAccepted
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionSubscriptionAcceptedCopyWith<_AscpSessionSubscriptionAccepted> get copyWith => __$AscpSessionSubscriptionAcceptedCopyWithImpl<_AscpSessionSubscriptionAccepted>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionSubscriptionAcceptedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionSubscriptionAccepted&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.snapshotEmitted, snapshotEmitted) || other.snapshotEmitted == snapshotEmitted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscriptionId,sessionId,snapshotEmitted);

@override
String toString() {
  return 'AscpSessionSubscriptionAccepted(subscriptionId: $subscriptionId, sessionId: $sessionId, snapshotEmitted: $snapshotEmitted)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionSubscriptionAcceptedCopyWith<$Res> implements $AscpSessionSubscriptionAcceptedCopyWith<$Res> {
  factory _$AscpSessionSubscriptionAcceptedCopyWith(_AscpSessionSubscriptionAccepted value, $Res Function(_AscpSessionSubscriptionAccepted) _then) = __$AscpSessionSubscriptionAcceptedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'subscription_id') String subscriptionId,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'snapshot_emitted') bool snapshotEmitted
});




}
/// @nodoc
class __$AscpSessionSubscriptionAcceptedCopyWithImpl<$Res>
    implements _$AscpSessionSubscriptionAcceptedCopyWith<$Res> {
  __$AscpSessionSubscriptionAcceptedCopyWithImpl(this._self, this._then);

  final _AscpSessionSubscriptionAccepted _self;
  final $Res Function(_AscpSessionSubscriptionAccepted) _then;

/// Create a copy of AscpSessionSubscriptionAccepted
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subscriptionId = null,Object? sessionId = null,Object? snapshotEmitted = null,}) {
  return _then(_AscpSessionSubscriptionAccepted(
subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,snapshotEmitted: null == snapshotEmitted ? _self.snapshotEmitted : snapshotEmitted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
