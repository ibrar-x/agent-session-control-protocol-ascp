// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'protocol_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AscpProtocolError {

 String get code; String get message; bool get retryable; Map<String, Object?>? get details;@JsonKey(name: 'correlation_id') String? get correlationId;
/// Create a copy of AscpProtocolError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpProtocolErrorCopyWith<AscpProtocolError> get copyWith => _$AscpProtocolErrorCopyWithImpl<AscpProtocolError>(this as AscpProtocolError, _$identity);

  /// Serializes this AscpProtocolError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpProtocolError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.correlationId, correlationId) || other.correlationId == correlationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,retryable,const DeepCollectionEquality().hash(details),correlationId);

@override
String toString() {
  return 'AscpProtocolError(code: $code, message: $message, retryable: $retryable, details: $details, correlationId: $correlationId)';
}


}

/// @nodoc
abstract mixin class $AscpProtocolErrorCopyWith<$Res>  {
  factory $AscpProtocolErrorCopyWith(AscpProtocolError value, $Res Function(AscpProtocolError) _then) = _$AscpProtocolErrorCopyWithImpl;
@useResult
$Res call({
 String code, String message, bool retryable, Map<String, Object?>? details,@JsonKey(name: 'correlation_id') String? correlationId
});




}
/// @nodoc
class _$AscpProtocolErrorCopyWithImpl<$Res>
    implements $AscpProtocolErrorCopyWith<$Res> {
  _$AscpProtocolErrorCopyWithImpl(this._self, this._then);

  final AscpProtocolError _self;
  final $Res Function(AscpProtocolError) _then;

/// Create a copy of AscpProtocolError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? retryable = null,Object? details = freezed,Object? correlationId = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,correlationId: freezed == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpProtocolError].
extension AscpProtocolErrorPatterns on AscpProtocolError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpProtocolError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpProtocolError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpProtocolError value)  $default,){
final _that = this;
switch (_that) {
case _AscpProtocolError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpProtocolError value)?  $default,){
final _that = this;
switch (_that) {
case _AscpProtocolError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  bool retryable,  Map<String, Object?>? details, @JsonKey(name: 'correlation_id')  String? correlationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpProtocolError() when $default != null:
return $default(_that.code,_that.message,_that.retryable,_that.details,_that.correlationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  bool retryable,  Map<String, Object?>? details, @JsonKey(name: 'correlation_id')  String? correlationId)  $default,) {final _that = this;
switch (_that) {
case _AscpProtocolError():
return $default(_that.code,_that.message,_that.retryable,_that.details,_that.correlationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  bool retryable,  Map<String, Object?>? details, @JsonKey(name: 'correlation_id')  String? correlationId)?  $default,) {final _that = this;
switch (_that) {
case _AscpProtocolError() when $default != null:
return $default(_that.code,_that.message,_that.retryable,_that.details,_that.correlationId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpProtocolError implements AscpProtocolError {
  const _AscpProtocolError({required this.code, required this.message, required this.retryable, final  Map<String, Object?>? details, @JsonKey(name: 'correlation_id') this.correlationId}): _details = details;
  factory _AscpProtocolError.fromJson(Map<String, dynamic> json) => _$AscpProtocolErrorFromJson(json);

@override final  String code;
@override final  String message;
@override final  bool retryable;
 final  Map<String, Object?>? _details;
@override Map<String, Object?>? get details {
  final value = _details;
  if (value == null) return null;
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'correlation_id') final  String? correlationId;

/// Create a copy of AscpProtocolError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpProtocolErrorCopyWith<_AscpProtocolError> get copyWith => __$AscpProtocolErrorCopyWithImpl<_AscpProtocolError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpProtocolErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpProtocolError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.retryable, retryable) || other.retryable == retryable)&&const DeepCollectionEquality().equals(other._details, _details)&&(identical(other.correlationId, correlationId) || other.correlationId == correlationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,retryable,const DeepCollectionEquality().hash(_details),correlationId);

@override
String toString() {
  return 'AscpProtocolError(code: $code, message: $message, retryable: $retryable, details: $details, correlationId: $correlationId)';
}


}

/// @nodoc
abstract mixin class _$AscpProtocolErrorCopyWith<$Res> implements $AscpProtocolErrorCopyWith<$Res> {
  factory _$AscpProtocolErrorCopyWith(_AscpProtocolError value, $Res Function(_AscpProtocolError) _then) = __$AscpProtocolErrorCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, bool retryable, Map<String, Object?>? details,@JsonKey(name: 'correlation_id') String? correlationId
});




}
/// @nodoc
class __$AscpProtocolErrorCopyWithImpl<$Res>
    implements _$AscpProtocolErrorCopyWith<$Res> {
  __$AscpProtocolErrorCopyWithImpl(this._self, this._then);

  final _AscpProtocolError _self;
  final $Res Function(_AscpProtocolError) _then;

/// Create a copy of AscpProtocolError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? retryable = null,Object? details = freezed,Object? correlationId = freezed,}) {
  return _then(_AscpProtocolError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,retryable: null == retryable ? _self.retryable : retryable // ignore: cast_nullable_to_non_nullable
as bool,details: freezed == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,correlationId: freezed == correlationId ? _self.correlationId : correlationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
