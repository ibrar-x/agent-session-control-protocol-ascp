// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'envelopes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AscpEventEnvelope {

 String get id; String get type; String get ts;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'run_id') String? get runId; int? get seq; Map<String, Object?> get payload;
/// Create a copy of AscpEventEnvelope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpEventEnvelopeCopyWith<AscpEventEnvelope> get copyWith => _$AscpEventEnvelopeCopyWithImpl<AscpEventEnvelope>(this as AscpEventEnvelope, _$identity);

  /// Serializes this AscpEventEnvelope to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpEventEnvelope&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.seq, seq) || other.seq == seq)&&const DeepCollectionEquality().equals(other.payload, payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,ts,sessionId,runId,seq,const DeepCollectionEquality().hash(payload));

@override
String toString() {
  return 'AscpEventEnvelope(id: $id, type: $type, ts: $ts, sessionId: $sessionId, runId: $runId, seq: $seq, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $AscpEventEnvelopeCopyWith<$Res>  {
  factory $AscpEventEnvelopeCopyWith(AscpEventEnvelope value, $Res Function(AscpEventEnvelope) _then) = _$AscpEventEnvelopeCopyWithImpl;
@useResult
$Res call({
 String id, String type, String ts,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, int? seq, Map<String, Object?> payload
});




}
/// @nodoc
class _$AscpEventEnvelopeCopyWithImpl<$Res>
    implements $AscpEventEnvelopeCopyWith<$Res> {
  _$AscpEventEnvelopeCopyWithImpl(this._self, this._then);

  final AscpEventEnvelope _self;
  final $Res Function(AscpEventEnvelope) _then;

/// Create a copy of AscpEventEnvelope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? ts = null,Object? sessionId = null,Object? runId = freezed,Object? seq = freezed,Object? payload = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,seq: freezed == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpEventEnvelope].
extension AscpEventEnvelopePatterns on AscpEventEnvelope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpEventEnvelope value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpEventEnvelope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpEventEnvelope value)  $default,){
final _that = this;
switch (_that) {
case _AscpEventEnvelope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpEventEnvelope value)?  $default,){
final _that = this;
switch (_that) {
case _AscpEventEnvelope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  Map<String, Object?> payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpEventEnvelope() when $default != null:
return $default(_that.id,_that.type,_that.ts,_that.sessionId,_that.runId,_that.seq,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  Map<String, Object?> payload)  $default,) {final _that = this;
switch (_that) {
case _AscpEventEnvelope():
return $default(_that.id,_that.type,_that.ts,_that.sessionId,_that.runId,_that.seq,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  Map<String, Object?> payload)?  $default,) {final _that = this;
switch (_that) {
case _AscpEventEnvelope() when $default != null:
return $default(_that.id,_that.type,_that.ts,_that.sessionId,_that.runId,_that.seq,_that.payload);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpEventEnvelope implements AscpEventEnvelope {
  const _AscpEventEnvelope({required this.id, required this.type, required this.ts, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'run_id') this.runId, this.seq, required final  Map<String, Object?> payload}): _payload = payload;
  factory _AscpEventEnvelope.fromJson(Map<String, dynamic> json) => _$AscpEventEnvelopeFromJson(json);

@override final  String id;
@override final  String type;
@override final  String ts;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'run_id') final  String? runId;
@override final  int? seq;
 final  Map<String, Object?> _payload;
@override Map<String, Object?> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}


/// Create a copy of AscpEventEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpEventEnvelopeCopyWith<_AscpEventEnvelope> get copyWith => __$AscpEventEnvelopeCopyWithImpl<_AscpEventEnvelope>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpEventEnvelopeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpEventEnvelope&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.seq, seq) || other.seq == seq)&&const DeepCollectionEquality().equals(other._payload, _payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,ts,sessionId,runId,seq,const DeepCollectionEquality().hash(_payload));

@override
String toString() {
  return 'AscpEventEnvelope(id: $id, type: $type, ts: $ts, sessionId: $sessionId, runId: $runId, seq: $seq, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$AscpEventEnvelopeCopyWith<$Res> implements $AscpEventEnvelopeCopyWith<$Res> {
  factory _$AscpEventEnvelopeCopyWith(_AscpEventEnvelope value, $Res Function(_AscpEventEnvelope) _then) = __$AscpEventEnvelopeCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String ts,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, int? seq, Map<String, Object?> payload
});




}
/// @nodoc
class __$AscpEventEnvelopeCopyWithImpl<$Res>
    implements _$AscpEventEnvelopeCopyWith<$Res> {
  __$AscpEventEnvelopeCopyWithImpl(this._self, this._then);

  final _AscpEventEnvelope _self;
  final $Res Function(_AscpEventEnvelope) _then;

/// Create a copy of AscpEventEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? ts = null,Object? sessionId = null,Object? runId = freezed,Object? seq = freezed,Object? payload = null,}) {
  return _then(_AscpEventEnvelope(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,seq: freezed == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int?,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}


/// @nodoc
mixin _$AscpRequestEnvelope {

 String get jsonrpc; Object? get id; String get method; Map<String, Object?>? get params;
/// Create a copy of AscpRequestEnvelope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpRequestEnvelopeCopyWith<AscpRequestEnvelope> get copyWith => _$AscpRequestEnvelopeCopyWithImpl<AscpRequestEnvelope>(this as AscpRequestEnvelope, _$identity);

  /// Serializes this AscpRequestEnvelope to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpRequestEnvelope&&(identical(other.jsonrpc, jsonrpc) || other.jsonrpc == jsonrpc)&&const DeepCollectionEquality().equals(other.id, id)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.params, params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jsonrpc,const DeepCollectionEquality().hash(id),method,const DeepCollectionEquality().hash(params));

@override
String toString() {
  return 'AscpRequestEnvelope(jsonrpc: $jsonrpc, id: $id, method: $method, params: $params)';
}


}

/// @nodoc
abstract mixin class $AscpRequestEnvelopeCopyWith<$Res>  {
  factory $AscpRequestEnvelopeCopyWith(AscpRequestEnvelope value, $Res Function(AscpRequestEnvelope) _then) = _$AscpRequestEnvelopeCopyWithImpl;
@useResult
$Res call({
 String jsonrpc, Object? id, String method, Map<String, Object?>? params
});




}
/// @nodoc
class _$AscpRequestEnvelopeCopyWithImpl<$Res>
    implements $AscpRequestEnvelopeCopyWith<$Res> {
  _$AscpRequestEnvelopeCopyWithImpl(this._self, this._then);

  final AscpRequestEnvelope _self;
  final $Res Function(AscpRequestEnvelope) _then;

/// Create a copy of AscpRequestEnvelope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jsonrpc = null,Object? id = freezed,Object? method = null,Object? params = freezed,}) {
  return _then(_self.copyWith(
jsonrpc: null == jsonrpc ? _self.jsonrpc : jsonrpc // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id ,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,params: freezed == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpRequestEnvelope].
extension AscpRequestEnvelopePatterns on AscpRequestEnvelope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpRequestEnvelope value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpRequestEnvelope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpRequestEnvelope value)  $default,){
final _that = this;
switch (_that) {
case _AscpRequestEnvelope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpRequestEnvelope value)?  $default,){
final _that = this;
switch (_that) {
case _AscpRequestEnvelope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jsonrpc,  Object? id,  String method,  Map<String, Object?>? params)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpRequestEnvelope() when $default != null:
return $default(_that.jsonrpc,_that.id,_that.method,_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jsonrpc,  Object? id,  String method,  Map<String, Object?>? params)  $default,) {final _that = this;
switch (_that) {
case _AscpRequestEnvelope():
return $default(_that.jsonrpc,_that.id,_that.method,_that.params);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jsonrpc,  Object? id,  String method,  Map<String, Object?>? params)?  $default,) {final _that = this;
switch (_that) {
case _AscpRequestEnvelope() when $default != null:
return $default(_that.jsonrpc,_that.id,_that.method,_that.params);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpRequestEnvelope implements AscpRequestEnvelope {
  const _AscpRequestEnvelope({required this.jsonrpc, this.id, required this.method, final  Map<String, Object?>? params}): _params = params;
  factory _AscpRequestEnvelope.fromJson(Map<String, dynamic> json) => _$AscpRequestEnvelopeFromJson(json);

@override final  String jsonrpc;
@override final  Object? id;
@override final  String method;
 final  Map<String, Object?>? _params;
@override Map<String, Object?>? get params {
  final value = _params;
  if (value == null) return null;
  if (_params is EqualUnmodifiableMapView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AscpRequestEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpRequestEnvelopeCopyWith<_AscpRequestEnvelope> get copyWith => __$AscpRequestEnvelopeCopyWithImpl<_AscpRequestEnvelope>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpRequestEnvelopeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpRequestEnvelope&&(identical(other.jsonrpc, jsonrpc) || other.jsonrpc == jsonrpc)&&const DeepCollectionEquality().equals(other.id, id)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other._params, _params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jsonrpc,const DeepCollectionEquality().hash(id),method,const DeepCollectionEquality().hash(_params));

@override
String toString() {
  return 'AscpRequestEnvelope(jsonrpc: $jsonrpc, id: $id, method: $method, params: $params)';
}


}

/// @nodoc
abstract mixin class _$AscpRequestEnvelopeCopyWith<$Res> implements $AscpRequestEnvelopeCopyWith<$Res> {
  factory _$AscpRequestEnvelopeCopyWith(_AscpRequestEnvelope value, $Res Function(_AscpRequestEnvelope) _then) = __$AscpRequestEnvelopeCopyWithImpl;
@override @useResult
$Res call({
 String jsonrpc, Object? id, String method, Map<String, Object?>? params
});




}
/// @nodoc
class __$AscpRequestEnvelopeCopyWithImpl<$Res>
    implements _$AscpRequestEnvelopeCopyWith<$Res> {
  __$AscpRequestEnvelopeCopyWithImpl(this._self, this._then);

  final _AscpRequestEnvelope _self;
  final $Res Function(_AscpRequestEnvelope) _then;

/// Create a copy of AscpRequestEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jsonrpc = null,Object? id = freezed,Object? method = null,Object? params = freezed,}) {
  return _then(_AscpRequestEnvelope(
jsonrpc: null == jsonrpc ? _self.jsonrpc : jsonrpc // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id ,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,params: freezed == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}


}


/// @nodoc
mixin _$AscpMethodSuccessResponse<T> {

 String get jsonrpc; Object? get id; T get result;
/// Create a copy of AscpMethodSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpMethodSuccessResponseCopyWith<T, AscpMethodSuccessResponse<T>> get copyWith => _$AscpMethodSuccessResponseCopyWithImpl<T, AscpMethodSuccessResponse<T>>(this as AscpMethodSuccessResponse<T>, _$identity);

  /// Serializes this AscpMethodSuccessResponse to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT);


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpMethodSuccessResponse<T>&&(identical(other.jsonrpc, jsonrpc) || other.jsonrpc == jsonrpc)&&const DeepCollectionEquality().equals(other.id, id)&&const DeepCollectionEquality().equals(other.result, result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jsonrpc,const DeepCollectionEquality().hash(id),const DeepCollectionEquality().hash(result));

@override
String toString() {
  return 'AscpMethodSuccessResponse<$T>(jsonrpc: $jsonrpc, id: $id, result: $result)';
}


}

/// @nodoc
abstract mixin class $AscpMethodSuccessResponseCopyWith<T,$Res>  {
  factory $AscpMethodSuccessResponseCopyWith(AscpMethodSuccessResponse<T> value, $Res Function(AscpMethodSuccessResponse<T>) _then) = _$AscpMethodSuccessResponseCopyWithImpl;
@useResult
$Res call({
 String jsonrpc, Object? id, T result
});




}
/// @nodoc
class _$AscpMethodSuccessResponseCopyWithImpl<T,$Res>
    implements $AscpMethodSuccessResponseCopyWith<T, $Res> {
  _$AscpMethodSuccessResponseCopyWithImpl(this._self, this._then);

  final AscpMethodSuccessResponse<T> _self;
  final $Res Function(AscpMethodSuccessResponse<T>) _then;

/// Create a copy of AscpMethodSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jsonrpc = null,Object? id = freezed,Object? result = freezed,}) {
  return _then(_self.copyWith(
jsonrpc: null == jsonrpc ? _self.jsonrpc : jsonrpc // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id ,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as T,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpMethodSuccessResponse].
extension AscpMethodSuccessResponsePatterns<T> on AscpMethodSuccessResponse<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpMethodSuccessResponse<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpMethodSuccessResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpMethodSuccessResponse<T> value)  $default,){
final _that = this;
switch (_that) {
case _AscpMethodSuccessResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpMethodSuccessResponse<T> value)?  $default,){
final _that = this;
switch (_that) {
case _AscpMethodSuccessResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jsonrpc,  Object? id,  T result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpMethodSuccessResponse() when $default != null:
return $default(_that.jsonrpc,_that.id,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jsonrpc,  Object? id,  T result)  $default,) {final _that = this;
switch (_that) {
case _AscpMethodSuccessResponse():
return $default(_that.jsonrpc,_that.id,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jsonrpc,  Object? id,  T result)?  $default,) {final _that = this;
switch (_that) {
case _AscpMethodSuccessResponse() when $default != null:
return $default(_that.jsonrpc,_that.id,_that.result);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class _AscpMethodSuccessResponse<T> implements AscpMethodSuccessResponse<T> {
  const _AscpMethodSuccessResponse({required this.jsonrpc, required this.id, required this.result});
  factory _AscpMethodSuccessResponse.fromJson(Map<String, dynamic> json,T Function(Object?) fromJsonT) => _$AscpMethodSuccessResponseFromJson(json,fromJsonT);

@override final  String jsonrpc;
@override final  Object? id;
@override final  T result;

/// Create a copy of AscpMethodSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpMethodSuccessResponseCopyWith<T, _AscpMethodSuccessResponse<T>> get copyWith => __$AscpMethodSuccessResponseCopyWithImpl<T, _AscpMethodSuccessResponse<T>>(this, _$identity);

@override
Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
  return _$AscpMethodSuccessResponseToJson<T>(this, toJsonT);
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpMethodSuccessResponse<T>&&(identical(other.jsonrpc, jsonrpc) || other.jsonrpc == jsonrpc)&&const DeepCollectionEquality().equals(other.id, id)&&const DeepCollectionEquality().equals(other.result, result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jsonrpc,const DeepCollectionEquality().hash(id),const DeepCollectionEquality().hash(result));

@override
String toString() {
  return 'AscpMethodSuccessResponse<$T>(jsonrpc: $jsonrpc, id: $id, result: $result)';
}


}

/// @nodoc
abstract mixin class _$AscpMethodSuccessResponseCopyWith<T,$Res> implements $AscpMethodSuccessResponseCopyWith<T, $Res> {
  factory _$AscpMethodSuccessResponseCopyWith(_AscpMethodSuccessResponse<T> value, $Res Function(_AscpMethodSuccessResponse<T>) _then) = __$AscpMethodSuccessResponseCopyWithImpl;
@override @useResult
$Res call({
 String jsonrpc, Object? id, T result
});




}
/// @nodoc
class __$AscpMethodSuccessResponseCopyWithImpl<T,$Res>
    implements _$AscpMethodSuccessResponseCopyWith<T, $Res> {
  __$AscpMethodSuccessResponseCopyWithImpl(this._self, this._then);

  final _AscpMethodSuccessResponse<T> _self;
  final $Res Function(_AscpMethodSuccessResponse<T>) _then;

/// Create a copy of AscpMethodSuccessResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jsonrpc = null,Object? id = freezed,Object? result = freezed,}) {
  return _then(_AscpMethodSuccessResponse<T>(
jsonrpc: null == jsonrpc ? _self.jsonrpc : jsonrpc // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id ,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}


/// @nodoc
mixin _$AscpMethodErrorResponse {

 String get jsonrpc; Object? get id; AscpProtocolError get error;
/// Create a copy of AscpMethodErrorResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpMethodErrorResponseCopyWith<AscpMethodErrorResponse> get copyWith => _$AscpMethodErrorResponseCopyWithImpl<AscpMethodErrorResponse>(this as AscpMethodErrorResponse, _$identity);

  /// Serializes this AscpMethodErrorResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpMethodErrorResponse&&(identical(other.jsonrpc, jsonrpc) || other.jsonrpc == jsonrpc)&&const DeepCollectionEquality().equals(other.id, id)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jsonrpc,const DeepCollectionEquality().hash(id),error);

@override
String toString() {
  return 'AscpMethodErrorResponse(jsonrpc: $jsonrpc, id: $id, error: $error)';
}


}

/// @nodoc
abstract mixin class $AscpMethodErrorResponseCopyWith<$Res>  {
  factory $AscpMethodErrorResponseCopyWith(AscpMethodErrorResponse value, $Res Function(AscpMethodErrorResponse) _then) = _$AscpMethodErrorResponseCopyWithImpl;
@useResult
$Res call({
 String jsonrpc, Object? id, AscpProtocolError error
});


$AscpProtocolErrorCopyWith<$Res> get error;

}
/// @nodoc
class _$AscpMethodErrorResponseCopyWithImpl<$Res>
    implements $AscpMethodErrorResponseCopyWith<$Res> {
  _$AscpMethodErrorResponseCopyWithImpl(this._self, this._then);

  final AscpMethodErrorResponse _self;
  final $Res Function(AscpMethodErrorResponse) _then;

/// Create a copy of AscpMethodErrorResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jsonrpc = null,Object? id = freezed,Object? error = null,}) {
  return _then(_self.copyWith(
jsonrpc: null == jsonrpc ? _self.jsonrpc : jsonrpc // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id ,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AscpProtocolError,
  ));
}
/// Create a copy of AscpMethodErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpProtocolErrorCopyWith<$Res> get error {
  
  return $AscpProtocolErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpMethodErrorResponse].
extension AscpMethodErrorResponsePatterns on AscpMethodErrorResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpMethodErrorResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpMethodErrorResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpMethodErrorResponse value)  $default,){
final _that = this;
switch (_that) {
case _AscpMethodErrorResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpMethodErrorResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AscpMethodErrorResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jsonrpc,  Object? id,  AscpProtocolError error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpMethodErrorResponse() when $default != null:
return $default(_that.jsonrpc,_that.id,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jsonrpc,  Object? id,  AscpProtocolError error)  $default,) {final _that = this;
switch (_that) {
case _AscpMethodErrorResponse():
return $default(_that.jsonrpc,_that.id,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jsonrpc,  Object? id,  AscpProtocolError error)?  $default,) {final _that = this;
switch (_that) {
case _AscpMethodErrorResponse() when $default != null:
return $default(_that.jsonrpc,_that.id,_that.error);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpMethodErrorResponse implements AscpMethodErrorResponse {
  const _AscpMethodErrorResponse({required this.jsonrpc, required this.id, required this.error});
  factory _AscpMethodErrorResponse.fromJson(Map<String, dynamic> json) => _$AscpMethodErrorResponseFromJson(json);

@override final  String jsonrpc;
@override final  Object? id;
@override final  AscpProtocolError error;

/// Create a copy of AscpMethodErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpMethodErrorResponseCopyWith<_AscpMethodErrorResponse> get copyWith => __$AscpMethodErrorResponseCopyWithImpl<_AscpMethodErrorResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpMethodErrorResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpMethodErrorResponse&&(identical(other.jsonrpc, jsonrpc) || other.jsonrpc == jsonrpc)&&const DeepCollectionEquality().equals(other.id, id)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jsonrpc,const DeepCollectionEquality().hash(id),error);

@override
String toString() {
  return 'AscpMethodErrorResponse(jsonrpc: $jsonrpc, id: $id, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AscpMethodErrorResponseCopyWith<$Res> implements $AscpMethodErrorResponseCopyWith<$Res> {
  factory _$AscpMethodErrorResponseCopyWith(_AscpMethodErrorResponse value, $Res Function(_AscpMethodErrorResponse) _then) = __$AscpMethodErrorResponseCopyWithImpl;
@override @useResult
$Res call({
 String jsonrpc, Object? id, AscpProtocolError error
});


@override $AscpProtocolErrorCopyWith<$Res> get error;

}
/// @nodoc
class __$AscpMethodErrorResponseCopyWithImpl<$Res>
    implements _$AscpMethodErrorResponseCopyWith<$Res> {
  __$AscpMethodErrorResponseCopyWithImpl(this._self, this._then);

  final _AscpMethodErrorResponse _self;
  final $Res Function(_AscpMethodErrorResponse) _then;

/// Create a copy of AscpMethodErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jsonrpc = null,Object? id = freezed,Object? error = null,}) {
  return _then(_AscpMethodErrorResponse(
jsonrpc: null == jsonrpc ? _self.jsonrpc : jsonrpc // ignore: cast_nullable_to_non_nullable
as String,id: freezed == id ? _self.id : id ,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AscpProtocolError,
  ));
}

/// Create a copy of AscpMethodErrorResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpProtocolErrorCopyWith<$Res> get error {
  
  return $AscpProtocolErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
