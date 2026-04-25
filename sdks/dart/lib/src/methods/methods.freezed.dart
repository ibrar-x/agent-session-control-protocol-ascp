// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'methods.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AscpCapabilitiesDocument {

@JsonKey(name: 'protocol_version') String get protocolVersion; AscpHost get host; List<String> get transports; AscpCapabilities get capabilities; List<AscpRuntime> get runtimes;
/// Create a copy of AscpCapabilitiesDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpCapabilitiesDocumentCopyWith<AscpCapabilitiesDocument> get copyWith => _$AscpCapabilitiesDocumentCopyWithImpl<AscpCapabilitiesDocument>(this as AscpCapabilitiesDocument, _$identity);

  /// Serializes this AscpCapabilitiesDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpCapabilitiesDocument&&(identical(other.protocolVersion, protocolVersion) || other.protocolVersion == protocolVersion)&&(identical(other.host, host) || other.host == host)&&const DeepCollectionEquality().equals(other.transports, transports)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities)&&const DeepCollectionEquality().equals(other.runtimes, runtimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,protocolVersion,host,const DeepCollectionEquality().hash(transports),capabilities,const DeepCollectionEquality().hash(runtimes));

@override
String toString() {
  return 'AscpCapabilitiesDocument(protocolVersion: $protocolVersion, host: $host, transports: $transports, capabilities: $capabilities, runtimes: $runtimes)';
}


}

/// @nodoc
abstract mixin class $AscpCapabilitiesDocumentCopyWith<$Res>  {
  factory $AscpCapabilitiesDocumentCopyWith(AscpCapabilitiesDocument value, $Res Function(AscpCapabilitiesDocument) _then) = _$AscpCapabilitiesDocumentCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'protocol_version') String protocolVersion, AscpHost host, List<String> transports, AscpCapabilities capabilities, List<AscpRuntime> runtimes
});


$AscpHostCopyWith<$Res> get host;$AscpCapabilitiesCopyWith<$Res> get capabilities;

}
/// @nodoc
class _$AscpCapabilitiesDocumentCopyWithImpl<$Res>
    implements $AscpCapabilitiesDocumentCopyWith<$Res> {
  _$AscpCapabilitiesDocumentCopyWithImpl(this._self, this._then);

  final AscpCapabilitiesDocument _self;
  final $Res Function(AscpCapabilitiesDocument) _then;

/// Create a copy of AscpCapabilitiesDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? protocolVersion = null,Object? host = null,Object? transports = null,Object? capabilities = null,Object? runtimes = null,}) {
  return _then(_self.copyWith(
protocolVersion: null == protocolVersion ? _self.protocolVersion : protocolVersion // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as AscpHost,transports: null == transports ? _self.transports : transports // ignore: cast_nullable_to_non_nullable
as List<String>,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as AscpCapabilities,runtimes: null == runtimes ? _self.runtimes : runtimes // ignore: cast_nullable_to_non_nullable
as List<AscpRuntime>,
  ));
}
/// Create a copy of AscpCapabilitiesDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpHostCopyWith<$Res> get host {
  
  return $AscpHostCopyWith<$Res>(_self.host, (value) {
    return _then(_self.copyWith(host: value));
  });
}/// Create a copy of AscpCapabilitiesDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpCapabilitiesCopyWith<$Res> get capabilities {
  
  return $AscpCapabilitiesCopyWith<$Res>(_self.capabilities, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpCapabilitiesDocument].
extension AscpCapabilitiesDocumentPatterns on AscpCapabilitiesDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpCapabilitiesDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpCapabilitiesDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpCapabilitiesDocument value)  $default,){
final _that = this;
switch (_that) {
case _AscpCapabilitiesDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpCapabilitiesDocument value)?  $default,){
final _that = this;
switch (_that) {
case _AscpCapabilitiesDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'protocol_version')  String protocolVersion,  AscpHost host,  List<String> transports,  AscpCapabilities capabilities,  List<AscpRuntime> runtimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpCapabilitiesDocument() when $default != null:
return $default(_that.protocolVersion,_that.host,_that.transports,_that.capabilities,_that.runtimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'protocol_version')  String protocolVersion,  AscpHost host,  List<String> transports,  AscpCapabilities capabilities,  List<AscpRuntime> runtimes)  $default,) {final _that = this;
switch (_that) {
case _AscpCapabilitiesDocument():
return $default(_that.protocolVersion,_that.host,_that.transports,_that.capabilities,_that.runtimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'protocol_version')  String protocolVersion,  AscpHost host,  List<String> transports,  AscpCapabilities capabilities,  List<AscpRuntime> runtimes)?  $default,) {final _that = this;
switch (_that) {
case _AscpCapabilitiesDocument() when $default != null:
return $default(_that.protocolVersion,_that.host,_that.transports,_that.capabilities,_that.runtimes);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpCapabilitiesDocument implements AscpCapabilitiesDocument {
  const _AscpCapabilitiesDocument({@JsonKey(name: 'protocol_version') required this.protocolVersion, required this.host, required final  List<String> transports, required this.capabilities, required final  List<AscpRuntime> runtimes}): _transports = transports,_runtimes = runtimes;
  factory _AscpCapabilitiesDocument.fromJson(Map<String, dynamic> json) => _$AscpCapabilitiesDocumentFromJson(json);

@override@JsonKey(name: 'protocol_version') final  String protocolVersion;
@override final  AscpHost host;
 final  List<String> _transports;
@override List<String> get transports {
  if (_transports is EqualUnmodifiableListView) return _transports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transports);
}

@override final  AscpCapabilities capabilities;
 final  List<AscpRuntime> _runtimes;
@override List<AscpRuntime> get runtimes {
  if (_runtimes is EqualUnmodifiableListView) return _runtimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_runtimes);
}


/// Create a copy of AscpCapabilitiesDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpCapabilitiesDocumentCopyWith<_AscpCapabilitiesDocument> get copyWith => __$AscpCapabilitiesDocumentCopyWithImpl<_AscpCapabilitiesDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpCapabilitiesDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpCapabilitiesDocument&&(identical(other.protocolVersion, protocolVersion) || other.protocolVersion == protocolVersion)&&(identical(other.host, host) || other.host == host)&&const DeepCollectionEquality().equals(other._transports, _transports)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities)&&const DeepCollectionEquality().equals(other._runtimes, _runtimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,protocolVersion,host,const DeepCollectionEquality().hash(_transports),capabilities,const DeepCollectionEquality().hash(_runtimes));

@override
String toString() {
  return 'AscpCapabilitiesDocument(protocolVersion: $protocolVersion, host: $host, transports: $transports, capabilities: $capabilities, runtimes: $runtimes)';
}


}

/// @nodoc
abstract mixin class _$AscpCapabilitiesDocumentCopyWith<$Res> implements $AscpCapabilitiesDocumentCopyWith<$Res> {
  factory _$AscpCapabilitiesDocumentCopyWith(_AscpCapabilitiesDocument value, $Res Function(_AscpCapabilitiesDocument) _then) = __$AscpCapabilitiesDocumentCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'protocol_version') String protocolVersion, AscpHost host, List<String> transports, AscpCapabilities capabilities, List<AscpRuntime> runtimes
});


@override $AscpHostCopyWith<$Res> get host;@override $AscpCapabilitiesCopyWith<$Res> get capabilities;

}
/// @nodoc
class __$AscpCapabilitiesDocumentCopyWithImpl<$Res>
    implements _$AscpCapabilitiesDocumentCopyWith<$Res> {
  __$AscpCapabilitiesDocumentCopyWithImpl(this._self, this._then);

  final _AscpCapabilitiesDocument _self;
  final $Res Function(_AscpCapabilitiesDocument) _then;

/// Create a copy of AscpCapabilitiesDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? protocolVersion = null,Object? host = null,Object? transports = null,Object? capabilities = null,Object? runtimes = null,}) {
  return _then(_AscpCapabilitiesDocument(
protocolVersion: null == protocolVersion ? _self.protocolVersion : protocolVersion // ignore: cast_nullable_to_non_nullable
as String,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as AscpHost,transports: null == transports ? _self._transports : transports // ignore: cast_nullable_to_non_nullable
as List<String>,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as AscpCapabilities,runtimes: null == runtimes ? _self._runtimes : runtimes // ignore: cast_nullable_to_non_nullable
as List<AscpRuntime>,
  ));
}

/// Create a copy of AscpCapabilitiesDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpHostCopyWith<$Res> get host {
  
  return $AscpHostCopyWith<$Res>(_self.host, (value) {
    return _then(_self.copyWith(host: value));
  });
}/// Create a copy of AscpCapabilitiesDocument
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpCapabilitiesCopyWith<$Res> get capabilities {
  
  return $AscpCapabilitiesCopyWith<$Res>(_self.capabilities, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}
}


/// @nodoc
mixin _$AscpHostsGetResult {

 AscpHost get host;
/// Create a copy of AscpHostsGetResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpHostsGetResultCopyWith<AscpHostsGetResult> get copyWith => _$AscpHostsGetResultCopyWithImpl<AscpHostsGetResult>(this as AscpHostsGetResult, _$identity);

  /// Serializes this AscpHostsGetResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpHostsGetResult&&(identical(other.host, host) || other.host == host));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,host);

@override
String toString() {
  return 'AscpHostsGetResult(host: $host)';
}


}

/// @nodoc
abstract mixin class $AscpHostsGetResultCopyWith<$Res>  {
  factory $AscpHostsGetResultCopyWith(AscpHostsGetResult value, $Res Function(AscpHostsGetResult) _then) = _$AscpHostsGetResultCopyWithImpl;
@useResult
$Res call({
 AscpHost host
});


$AscpHostCopyWith<$Res> get host;

}
/// @nodoc
class _$AscpHostsGetResultCopyWithImpl<$Res>
    implements $AscpHostsGetResultCopyWith<$Res> {
  _$AscpHostsGetResultCopyWithImpl(this._self, this._then);

  final AscpHostsGetResult _self;
  final $Res Function(AscpHostsGetResult) _then;

/// Create a copy of AscpHostsGetResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = null,}) {
  return _then(_self.copyWith(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as AscpHost,
  ));
}
/// Create a copy of AscpHostsGetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpHostCopyWith<$Res> get host {
  
  return $AscpHostCopyWith<$Res>(_self.host, (value) {
    return _then(_self.copyWith(host: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpHostsGetResult].
extension AscpHostsGetResultPatterns on AscpHostsGetResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpHostsGetResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpHostsGetResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpHostsGetResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpHostsGetResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpHostsGetResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpHostsGetResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AscpHost host)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpHostsGetResult() when $default != null:
return $default(_that.host);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AscpHost host)  $default,) {final _that = this;
switch (_that) {
case _AscpHostsGetResult():
return $default(_that.host);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AscpHost host)?  $default,) {final _that = this;
switch (_that) {
case _AscpHostsGetResult() when $default != null:
return $default(_that.host);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpHostsGetResult implements AscpHostsGetResult {
  const _AscpHostsGetResult({required this.host});
  factory _AscpHostsGetResult.fromJson(Map<String, dynamic> json) => _$AscpHostsGetResultFromJson(json);

@override final  AscpHost host;

/// Create a copy of AscpHostsGetResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpHostsGetResultCopyWith<_AscpHostsGetResult> get copyWith => __$AscpHostsGetResultCopyWithImpl<_AscpHostsGetResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpHostsGetResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpHostsGetResult&&(identical(other.host, host) || other.host == host));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,host);

@override
String toString() {
  return 'AscpHostsGetResult(host: $host)';
}


}

/// @nodoc
abstract mixin class _$AscpHostsGetResultCopyWith<$Res> implements $AscpHostsGetResultCopyWith<$Res> {
  factory _$AscpHostsGetResultCopyWith(_AscpHostsGetResult value, $Res Function(_AscpHostsGetResult) _then) = __$AscpHostsGetResultCopyWithImpl;
@override @useResult
$Res call({
 AscpHost host
});


@override $AscpHostCopyWith<$Res> get host;

}
/// @nodoc
class __$AscpHostsGetResultCopyWithImpl<$Res>
    implements _$AscpHostsGetResultCopyWith<$Res> {
  __$AscpHostsGetResultCopyWithImpl(this._self, this._then);

  final _AscpHostsGetResult _self;
  final $Res Function(_AscpHostsGetResult) _then;

/// Create a copy of AscpHostsGetResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = null,}) {
  return _then(_AscpHostsGetResult(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as AscpHost,
  ));
}

/// Create a copy of AscpHostsGetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpHostCopyWith<$Res> get host {
  
  return $AscpHostCopyWith<$Res>(_self.host, (value) {
    return _then(_self.copyWith(host: value));
  });
}
}


/// @nodoc
mixin _$AscpRuntimesListParams {

 String? get kind;@JsonKey(name: 'adapter_kind') String? get adapterKind;
/// Create a copy of AscpRuntimesListParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpRuntimesListParamsCopyWith<AscpRuntimesListParams> get copyWith => _$AscpRuntimesListParamsCopyWithImpl<AscpRuntimesListParams>(this as AscpRuntimesListParams, _$identity);

  /// Serializes this AscpRuntimesListParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpRuntimesListParams&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.adapterKind, adapterKind) || other.adapterKind == adapterKind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,adapterKind);

@override
String toString() {
  return 'AscpRuntimesListParams(kind: $kind, adapterKind: $adapterKind)';
}


}

/// @nodoc
abstract mixin class $AscpRuntimesListParamsCopyWith<$Res>  {
  factory $AscpRuntimesListParamsCopyWith(AscpRuntimesListParams value, $Res Function(AscpRuntimesListParams) _then) = _$AscpRuntimesListParamsCopyWithImpl;
@useResult
$Res call({
 String? kind,@JsonKey(name: 'adapter_kind') String? adapterKind
});




}
/// @nodoc
class _$AscpRuntimesListParamsCopyWithImpl<$Res>
    implements $AscpRuntimesListParamsCopyWith<$Res> {
  _$AscpRuntimesListParamsCopyWithImpl(this._self, this._then);

  final AscpRuntimesListParams _self;
  final $Res Function(AscpRuntimesListParams) _then;

/// Create a copy of AscpRuntimesListParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = freezed,Object? adapterKind = freezed,}) {
  return _then(_self.copyWith(
kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,adapterKind: freezed == adapterKind ? _self.adapterKind : adapterKind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpRuntimesListParams].
extension AscpRuntimesListParamsPatterns on AscpRuntimesListParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpRuntimesListParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpRuntimesListParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpRuntimesListParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpRuntimesListParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpRuntimesListParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpRuntimesListParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? kind, @JsonKey(name: 'adapter_kind')  String? adapterKind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpRuntimesListParams() when $default != null:
return $default(_that.kind,_that.adapterKind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? kind, @JsonKey(name: 'adapter_kind')  String? adapterKind)  $default,) {final _that = this;
switch (_that) {
case _AscpRuntimesListParams():
return $default(_that.kind,_that.adapterKind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? kind, @JsonKey(name: 'adapter_kind')  String? adapterKind)?  $default,) {final _that = this;
switch (_that) {
case _AscpRuntimesListParams() when $default != null:
return $default(_that.kind,_that.adapterKind);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpRuntimesListParams implements AscpRuntimesListParams {
  const _AscpRuntimesListParams({this.kind, @JsonKey(name: 'adapter_kind') this.adapterKind});
  factory _AscpRuntimesListParams.fromJson(Map<String, dynamic> json) => _$AscpRuntimesListParamsFromJson(json);

@override final  String? kind;
@override@JsonKey(name: 'adapter_kind') final  String? adapterKind;

/// Create a copy of AscpRuntimesListParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpRuntimesListParamsCopyWith<_AscpRuntimesListParams> get copyWith => __$AscpRuntimesListParamsCopyWithImpl<_AscpRuntimesListParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpRuntimesListParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpRuntimesListParams&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.adapterKind, adapterKind) || other.adapterKind == adapterKind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,adapterKind);

@override
String toString() {
  return 'AscpRuntimesListParams(kind: $kind, adapterKind: $adapterKind)';
}


}

/// @nodoc
abstract mixin class _$AscpRuntimesListParamsCopyWith<$Res> implements $AscpRuntimesListParamsCopyWith<$Res> {
  factory _$AscpRuntimesListParamsCopyWith(_AscpRuntimesListParams value, $Res Function(_AscpRuntimesListParams) _then) = __$AscpRuntimesListParamsCopyWithImpl;
@override @useResult
$Res call({
 String? kind,@JsonKey(name: 'adapter_kind') String? adapterKind
});




}
/// @nodoc
class __$AscpRuntimesListParamsCopyWithImpl<$Res>
    implements _$AscpRuntimesListParamsCopyWith<$Res> {
  __$AscpRuntimesListParamsCopyWithImpl(this._self, this._then);

  final _AscpRuntimesListParams _self;
  final $Res Function(_AscpRuntimesListParams) _then;

/// Create a copy of AscpRuntimesListParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = freezed,Object? adapterKind = freezed,}) {
  return _then(_AscpRuntimesListParams(
kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,adapterKind: freezed == adapterKind ? _self.adapterKind : adapterKind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpRuntimesListResult {

 List<AscpRuntime> get runtimes;
/// Create a copy of AscpRuntimesListResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpRuntimesListResultCopyWith<AscpRuntimesListResult> get copyWith => _$AscpRuntimesListResultCopyWithImpl<AscpRuntimesListResult>(this as AscpRuntimesListResult, _$identity);

  /// Serializes this AscpRuntimesListResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpRuntimesListResult&&const DeepCollectionEquality().equals(other.runtimes, runtimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(runtimes));

@override
String toString() {
  return 'AscpRuntimesListResult(runtimes: $runtimes)';
}


}

/// @nodoc
abstract mixin class $AscpRuntimesListResultCopyWith<$Res>  {
  factory $AscpRuntimesListResultCopyWith(AscpRuntimesListResult value, $Res Function(AscpRuntimesListResult) _then) = _$AscpRuntimesListResultCopyWithImpl;
@useResult
$Res call({
 List<AscpRuntime> runtimes
});




}
/// @nodoc
class _$AscpRuntimesListResultCopyWithImpl<$Res>
    implements $AscpRuntimesListResultCopyWith<$Res> {
  _$AscpRuntimesListResultCopyWithImpl(this._self, this._then);

  final AscpRuntimesListResult _self;
  final $Res Function(AscpRuntimesListResult) _then;

/// Create a copy of AscpRuntimesListResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runtimes = null,}) {
  return _then(_self.copyWith(
runtimes: null == runtimes ? _self.runtimes : runtimes // ignore: cast_nullable_to_non_nullable
as List<AscpRuntime>,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpRuntimesListResult].
extension AscpRuntimesListResultPatterns on AscpRuntimesListResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpRuntimesListResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpRuntimesListResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpRuntimesListResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpRuntimesListResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpRuntimesListResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpRuntimesListResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AscpRuntime> runtimes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpRuntimesListResult() when $default != null:
return $default(_that.runtimes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AscpRuntime> runtimes)  $default,) {final _that = this;
switch (_that) {
case _AscpRuntimesListResult():
return $default(_that.runtimes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AscpRuntime> runtimes)?  $default,) {final _that = this;
switch (_that) {
case _AscpRuntimesListResult() when $default != null:
return $default(_that.runtimes);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpRuntimesListResult implements AscpRuntimesListResult {
  const _AscpRuntimesListResult({required final  List<AscpRuntime> runtimes}): _runtimes = runtimes;
  factory _AscpRuntimesListResult.fromJson(Map<String, dynamic> json) => _$AscpRuntimesListResultFromJson(json);

 final  List<AscpRuntime> _runtimes;
@override List<AscpRuntime> get runtimes {
  if (_runtimes is EqualUnmodifiableListView) return _runtimes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_runtimes);
}


/// Create a copy of AscpRuntimesListResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpRuntimesListResultCopyWith<_AscpRuntimesListResult> get copyWith => __$AscpRuntimesListResultCopyWithImpl<_AscpRuntimesListResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpRuntimesListResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpRuntimesListResult&&const DeepCollectionEquality().equals(other._runtimes, _runtimes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_runtimes));

@override
String toString() {
  return 'AscpRuntimesListResult(runtimes: $runtimes)';
}


}

/// @nodoc
abstract mixin class _$AscpRuntimesListResultCopyWith<$Res> implements $AscpRuntimesListResultCopyWith<$Res> {
  factory _$AscpRuntimesListResultCopyWith(_AscpRuntimesListResult value, $Res Function(_AscpRuntimesListResult) _then) = __$AscpRuntimesListResultCopyWithImpl;
@override @useResult
$Res call({
 List<AscpRuntime> runtimes
});




}
/// @nodoc
class __$AscpRuntimesListResultCopyWithImpl<$Res>
    implements _$AscpRuntimesListResultCopyWith<$Res> {
  __$AscpRuntimesListResultCopyWithImpl(this._self, this._then);

  final _AscpRuntimesListResult _self;
  final $Res Function(_AscpRuntimesListResult) _then;

/// Create a copy of AscpRuntimesListResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runtimes = null,}) {
  return _then(_AscpRuntimesListResult(
runtimes: null == runtimes ? _self._runtimes : runtimes // ignore: cast_nullable_to_non_nullable
as List<AscpRuntime>,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsListParams {

@JsonKey(name: 'runtime_id') String? get runtimeId; String? get status; String? get workspace;@JsonKey(name: 'updated_after') String? get updatedAfter;@JsonKey(name: 'search_text') String? get searchText; int? get limit; String? get cursor;
/// Create a copy of AscpSessionsListParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsListParamsCopyWith<AscpSessionsListParams> get copyWith => _$AscpSessionsListParamsCopyWithImpl<AscpSessionsListParams>(this as AscpSessionsListParams, _$identity);

  /// Serializes this AscpSessionsListParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsListParams&&(identical(other.runtimeId, runtimeId) || other.runtimeId == runtimeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.updatedAfter, updatedAfter) || other.updatedAfter == updatedAfter)&&(identical(other.searchText, searchText) || other.searchText == searchText)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.cursor, cursor) || other.cursor == cursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runtimeId,status,workspace,updatedAfter,searchText,limit,cursor);

@override
String toString() {
  return 'AscpSessionsListParams(runtimeId: $runtimeId, status: $status, workspace: $workspace, updatedAfter: $updatedAfter, searchText: $searchText, limit: $limit, cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsListParamsCopyWith<$Res>  {
  factory $AscpSessionsListParamsCopyWith(AscpSessionsListParams value, $Res Function(AscpSessionsListParams) _then) = _$AscpSessionsListParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'runtime_id') String? runtimeId, String? status, String? workspace,@JsonKey(name: 'updated_after') String? updatedAfter,@JsonKey(name: 'search_text') String? searchText, int? limit, String? cursor
});




}
/// @nodoc
class _$AscpSessionsListParamsCopyWithImpl<$Res>
    implements $AscpSessionsListParamsCopyWith<$Res> {
  _$AscpSessionsListParamsCopyWithImpl(this._self, this._then);

  final AscpSessionsListParams _self;
  final $Res Function(AscpSessionsListParams) _then;

/// Create a copy of AscpSessionsListParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runtimeId = freezed,Object? status = freezed,Object? workspace = freezed,Object? updatedAfter = freezed,Object? searchText = freezed,Object? limit = freezed,Object? cursor = freezed,}) {
  return _then(_self.copyWith(
runtimeId: freezed == runtimeId ? _self.runtimeId : runtimeId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as String?,updatedAfter: freezed == updatedAfter ? _self.updatedAfter : updatedAfter // ignore: cast_nullable_to_non_nullable
as String?,searchText: freezed == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsListParams].
extension AscpSessionsListParamsPatterns on AscpSessionsListParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsListParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsListParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsListParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsListParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsListParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsListParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'runtime_id')  String? runtimeId,  String? status,  String? workspace, @JsonKey(name: 'updated_after')  String? updatedAfter, @JsonKey(name: 'search_text')  String? searchText,  int? limit,  String? cursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsListParams() when $default != null:
return $default(_that.runtimeId,_that.status,_that.workspace,_that.updatedAfter,_that.searchText,_that.limit,_that.cursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'runtime_id')  String? runtimeId,  String? status,  String? workspace, @JsonKey(name: 'updated_after')  String? updatedAfter, @JsonKey(name: 'search_text')  String? searchText,  int? limit,  String? cursor)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsListParams():
return $default(_that.runtimeId,_that.status,_that.workspace,_that.updatedAfter,_that.searchText,_that.limit,_that.cursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'runtime_id')  String? runtimeId,  String? status,  String? workspace, @JsonKey(name: 'updated_after')  String? updatedAfter, @JsonKey(name: 'search_text')  String? searchText,  int? limit,  String? cursor)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsListParams() when $default != null:
return $default(_that.runtimeId,_that.status,_that.workspace,_that.updatedAfter,_that.searchText,_that.limit,_that.cursor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpSessionsListParams implements AscpSessionsListParams {
  const _AscpSessionsListParams({@JsonKey(name: 'runtime_id') this.runtimeId, this.status, this.workspace, @JsonKey(name: 'updated_after') this.updatedAfter, @JsonKey(name: 'search_text') this.searchText, this.limit, this.cursor});
  factory _AscpSessionsListParams.fromJson(Map<String, dynamic> json) => _$AscpSessionsListParamsFromJson(json);

@override@JsonKey(name: 'runtime_id') final  String? runtimeId;
@override final  String? status;
@override final  String? workspace;
@override@JsonKey(name: 'updated_after') final  String? updatedAfter;
@override@JsonKey(name: 'search_text') final  String? searchText;
@override final  int? limit;
@override final  String? cursor;

/// Create a copy of AscpSessionsListParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsListParamsCopyWith<_AscpSessionsListParams> get copyWith => __$AscpSessionsListParamsCopyWithImpl<_AscpSessionsListParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsListParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsListParams&&(identical(other.runtimeId, runtimeId) || other.runtimeId == runtimeId)&&(identical(other.status, status) || other.status == status)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.updatedAfter, updatedAfter) || other.updatedAfter == updatedAfter)&&(identical(other.searchText, searchText) || other.searchText == searchText)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.cursor, cursor) || other.cursor == cursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runtimeId,status,workspace,updatedAfter,searchText,limit,cursor);

@override
String toString() {
  return 'AscpSessionsListParams(runtimeId: $runtimeId, status: $status, workspace: $workspace, updatedAfter: $updatedAfter, searchText: $searchText, limit: $limit, cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsListParamsCopyWith<$Res> implements $AscpSessionsListParamsCopyWith<$Res> {
  factory _$AscpSessionsListParamsCopyWith(_AscpSessionsListParams value, $Res Function(_AscpSessionsListParams) _then) = __$AscpSessionsListParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'runtime_id') String? runtimeId, String? status, String? workspace,@JsonKey(name: 'updated_after') String? updatedAfter,@JsonKey(name: 'search_text') String? searchText, int? limit, String? cursor
});




}
/// @nodoc
class __$AscpSessionsListParamsCopyWithImpl<$Res>
    implements _$AscpSessionsListParamsCopyWith<$Res> {
  __$AscpSessionsListParamsCopyWithImpl(this._self, this._then);

  final _AscpSessionsListParams _self;
  final $Res Function(_AscpSessionsListParams) _then;

/// Create a copy of AscpSessionsListParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runtimeId = freezed,Object? status = freezed,Object? workspace = freezed,Object? updatedAfter = freezed,Object? searchText = freezed,Object? limit = freezed,Object? cursor = freezed,}) {
  return _then(_AscpSessionsListParams(
runtimeId: freezed == runtimeId ? _self.runtimeId : runtimeId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as String?,updatedAfter: freezed == updatedAfter ? _self.updatedAfter : updatedAfter // ignore: cast_nullable_to_non_nullable
as String?,searchText: freezed == searchText ? _self.searchText : searchText // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsListResult {

 List<AscpSession> get sessions;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of AscpSessionsListResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsListResultCopyWith<AscpSessionsListResult> get copyWith => _$AscpSessionsListResultCopyWithImpl<AscpSessionsListResult>(this as AscpSessionsListResult, _$identity);

  /// Serializes this AscpSessionsListResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsListResult&&const DeepCollectionEquality().equals(other.sessions, sessions)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(sessions),nextCursor);

@override
String toString() {
  return 'AscpSessionsListResult(sessions: $sessions, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsListResultCopyWith<$Res>  {
  factory $AscpSessionsListResultCopyWith(AscpSessionsListResult value, $Res Function(AscpSessionsListResult) _then) = _$AscpSessionsListResultCopyWithImpl;
@useResult
$Res call({
 List<AscpSession> sessions,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$AscpSessionsListResultCopyWithImpl<$Res>
    implements $AscpSessionsListResultCopyWith<$Res> {
  _$AscpSessionsListResultCopyWithImpl(this._self, this._then);

  final AscpSessionsListResult _self;
  final $Res Function(AscpSessionsListResult) _then;

/// Create a copy of AscpSessionsListResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessions = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AscpSession>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsListResult].
extension AscpSessionsListResultPatterns on AscpSessionsListResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsListResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsListResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsListResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsListResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsListResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsListResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AscpSession> sessions, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsListResult() when $default != null:
return $default(_that.sessions,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AscpSession> sessions, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsListResult():
return $default(_that.sessions,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AscpSession> sessions, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsListResult() when $default != null:
return $default(_that.sessions,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSessionsListResult implements AscpSessionsListResult {
  const _AscpSessionsListResult({required final  List<AscpSession> sessions, @JsonKey(name: 'next_cursor') this.nextCursor}): _sessions = sessions;
  factory _AscpSessionsListResult.fromJson(Map<String, dynamic> json) => _$AscpSessionsListResultFromJson(json);

 final  List<AscpSession> _sessions;
@override List<AscpSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of AscpSessionsListResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsListResultCopyWith<_AscpSessionsListResult> get copyWith => __$AscpSessionsListResultCopyWithImpl<_AscpSessionsListResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsListResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsListResult&&const DeepCollectionEquality().equals(other._sessions, _sessions)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sessions),nextCursor);

@override
String toString() {
  return 'AscpSessionsListResult(sessions: $sessions, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsListResultCopyWith<$Res> implements $AscpSessionsListResultCopyWith<$Res> {
  factory _$AscpSessionsListResultCopyWith(_AscpSessionsListResult value, $Res Function(_AscpSessionsListResult) _then) = __$AscpSessionsListResultCopyWithImpl;
@override @useResult
$Res call({
 List<AscpSession> sessions,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$AscpSessionsListResultCopyWithImpl<$Res>
    implements _$AscpSessionsListResultCopyWith<$Res> {
  __$AscpSessionsListResultCopyWithImpl(this._self, this._then);

  final _AscpSessionsListResult _self;
  final $Res Function(_AscpSessionsListResult) _then;

/// Create a copy of AscpSessionsListResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessions = null,Object? nextCursor = freezed,}) {
  return _then(_AscpSessionsListResult(
sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AscpSession>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsGetParams {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'include_runs') bool? get includeRuns;@JsonKey(name: 'include_pending_approvals') bool? get includePendingApprovals;
/// Create a copy of AscpSessionsGetParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsGetParamsCopyWith<AscpSessionsGetParams> get copyWith => _$AscpSessionsGetParamsCopyWithImpl<AscpSessionsGetParams>(this as AscpSessionsGetParams, _$identity);

  /// Serializes this AscpSessionsGetParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsGetParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.includeRuns, includeRuns) || other.includeRuns == includeRuns)&&(identical(other.includePendingApprovals, includePendingApprovals) || other.includePendingApprovals == includePendingApprovals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,includeRuns,includePendingApprovals);

@override
String toString() {
  return 'AscpSessionsGetParams(sessionId: $sessionId, includeRuns: $includeRuns, includePendingApprovals: $includePendingApprovals)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsGetParamsCopyWith<$Res>  {
  factory $AscpSessionsGetParamsCopyWith(AscpSessionsGetParams value, $Res Function(AscpSessionsGetParams) _then) = _$AscpSessionsGetParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'include_runs') bool? includeRuns,@JsonKey(name: 'include_pending_approvals') bool? includePendingApprovals
});




}
/// @nodoc
class _$AscpSessionsGetParamsCopyWithImpl<$Res>
    implements $AscpSessionsGetParamsCopyWith<$Res> {
  _$AscpSessionsGetParamsCopyWithImpl(this._self, this._then);

  final AscpSessionsGetParams _self;
  final $Res Function(AscpSessionsGetParams) _then;

/// Create a copy of AscpSessionsGetParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? includeRuns = freezed,Object? includePendingApprovals = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,includeRuns: freezed == includeRuns ? _self.includeRuns : includeRuns // ignore: cast_nullable_to_non_nullable
as bool?,includePendingApprovals: freezed == includePendingApprovals ? _self.includePendingApprovals : includePendingApprovals // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsGetParams].
extension AscpSessionsGetParamsPatterns on AscpSessionsGetParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsGetParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsGetParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsGetParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsGetParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsGetParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsGetParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'include_runs')  bool? includeRuns, @JsonKey(name: 'include_pending_approvals')  bool? includePendingApprovals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsGetParams() when $default != null:
return $default(_that.sessionId,_that.includeRuns,_that.includePendingApprovals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'include_runs')  bool? includeRuns, @JsonKey(name: 'include_pending_approvals')  bool? includePendingApprovals)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsGetParams():
return $default(_that.sessionId,_that.includeRuns,_that.includePendingApprovals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'include_runs')  bool? includeRuns, @JsonKey(name: 'include_pending_approvals')  bool? includePendingApprovals)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsGetParams() when $default != null:
return $default(_that.sessionId,_that.includeRuns,_that.includePendingApprovals);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpSessionsGetParams implements AscpSessionsGetParams {
  const _AscpSessionsGetParams({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'include_runs') this.includeRuns, @JsonKey(name: 'include_pending_approvals') this.includePendingApprovals});
  factory _AscpSessionsGetParams.fromJson(Map<String, dynamic> json) => _$AscpSessionsGetParamsFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'include_runs') final  bool? includeRuns;
@override@JsonKey(name: 'include_pending_approvals') final  bool? includePendingApprovals;

/// Create a copy of AscpSessionsGetParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsGetParamsCopyWith<_AscpSessionsGetParams> get copyWith => __$AscpSessionsGetParamsCopyWithImpl<_AscpSessionsGetParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsGetParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsGetParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.includeRuns, includeRuns) || other.includeRuns == includeRuns)&&(identical(other.includePendingApprovals, includePendingApprovals) || other.includePendingApprovals == includePendingApprovals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,includeRuns,includePendingApprovals);

@override
String toString() {
  return 'AscpSessionsGetParams(sessionId: $sessionId, includeRuns: $includeRuns, includePendingApprovals: $includePendingApprovals)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsGetParamsCopyWith<$Res> implements $AscpSessionsGetParamsCopyWith<$Res> {
  factory _$AscpSessionsGetParamsCopyWith(_AscpSessionsGetParams value, $Res Function(_AscpSessionsGetParams) _then) = __$AscpSessionsGetParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'include_runs') bool? includeRuns,@JsonKey(name: 'include_pending_approvals') bool? includePendingApprovals
});




}
/// @nodoc
class __$AscpSessionsGetParamsCopyWithImpl<$Res>
    implements _$AscpSessionsGetParamsCopyWith<$Res> {
  __$AscpSessionsGetParamsCopyWithImpl(this._self, this._then);

  final _AscpSessionsGetParams _self;
  final $Res Function(_AscpSessionsGetParams) _then;

/// Create a copy of AscpSessionsGetParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? includeRuns = freezed,Object? includePendingApprovals = freezed,}) {
  return _then(_AscpSessionsGetParams(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,includeRuns: freezed == includeRuns ? _self.includeRuns : includeRuns // ignore: cast_nullable_to_non_nullable
as bool?,includePendingApprovals: freezed == includePendingApprovals ? _self.includePendingApprovals : includePendingApprovals // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsGetResult {

 AscpSession get session; List<AscpRun> get runs;@JsonKey(name: 'pending_approvals') List<AscpApprovalRequest> get pendingApprovals;
/// Create a copy of AscpSessionsGetResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsGetResultCopyWith<AscpSessionsGetResult> get copyWith => _$AscpSessionsGetResultCopyWithImpl<AscpSessionsGetResult>(this as AscpSessionsGetResult, _$identity);

  /// Serializes this AscpSessionsGetResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsGetResult&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other.runs, runs)&&const DeepCollectionEquality().equals(other.pendingApprovals, pendingApprovals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(runs),const DeepCollectionEquality().hash(pendingApprovals));

@override
String toString() {
  return 'AscpSessionsGetResult(session: $session, runs: $runs, pendingApprovals: $pendingApprovals)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsGetResultCopyWith<$Res>  {
  factory $AscpSessionsGetResultCopyWith(AscpSessionsGetResult value, $Res Function(AscpSessionsGetResult) _then) = _$AscpSessionsGetResultCopyWithImpl;
@useResult
$Res call({
 AscpSession session, List<AscpRun> runs,@JsonKey(name: 'pending_approvals') List<AscpApprovalRequest> pendingApprovals
});


$AscpSessionCopyWith<$Res> get session;

}
/// @nodoc
class _$AscpSessionsGetResultCopyWithImpl<$Res>
    implements $AscpSessionsGetResultCopyWith<$Res> {
  _$AscpSessionsGetResultCopyWithImpl(this._self, this._then);

  final AscpSessionsGetResult _self;
  final $Res Function(AscpSessionsGetResult) _then;

/// Create a copy of AscpSessionsGetResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? runs = null,Object? pendingApprovals = null,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AscpSession,runs: null == runs ? _self.runs : runs // ignore: cast_nullable_to_non_nullable
as List<AscpRun>,pendingApprovals: null == pendingApprovals ? _self.pendingApprovals : pendingApprovals // ignore: cast_nullable_to_non_nullable
as List<AscpApprovalRequest>,
  ));
}
/// Create a copy of AscpSessionsGetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSessionCopyWith<$Res> get session {
  
  return $AscpSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpSessionsGetResult].
extension AscpSessionsGetResultPatterns on AscpSessionsGetResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsGetResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsGetResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsGetResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsGetResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsGetResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsGetResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AscpSession session,  List<AscpRun> runs, @JsonKey(name: 'pending_approvals')  List<AscpApprovalRequest> pendingApprovals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsGetResult() when $default != null:
return $default(_that.session,_that.runs,_that.pendingApprovals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AscpSession session,  List<AscpRun> runs, @JsonKey(name: 'pending_approvals')  List<AscpApprovalRequest> pendingApprovals)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsGetResult():
return $default(_that.session,_that.runs,_that.pendingApprovals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AscpSession session,  List<AscpRun> runs, @JsonKey(name: 'pending_approvals')  List<AscpApprovalRequest> pendingApprovals)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsGetResult() when $default != null:
return $default(_that.session,_that.runs,_that.pendingApprovals);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSessionsGetResult implements AscpSessionsGetResult {
  const _AscpSessionsGetResult({required this.session, final  List<AscpRun> runs = const <AscpRun>[], @JsonKey(name: 'pending_approvals') final  List<AscpApprovalRequest> pendingApprovals = const <AscpApprovalRequest>[]}): _runs = runs,_pendingApprovals = pendingApprovals;
  factory _AscpSessionsGetResult.fromJson(Map<String, dynamic> json) => _$AscpSessionsGetResultFromJson(json);

@override final  AscpSession session;
 final  List<AscpRun> _runs;
@override@JsonKey() List<AscpRun> get runs {
  if (_runs is EqualUnmodifiableListView) return _runs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_runs);
}

 final  List<AscpApprovalRequest> _pendingApprovals;
@override@JsonKey(name: 'pending_approvals') List<AscpApprovalRequest> get pendingApprovals {
  if (_pendingApprovals is EqualUnmodifiableListView) return _pendingApprovals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingApprovals);
}


/// Create a copy of AscpSessionsGetResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsGetResultCopyWith<_AscpSessionsGetResult> get copyWith => __$AscpSessionsGetResultCopyWithImpl<_AscpSessionsGetResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsGetResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsGetResult&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other._runs, _runs)&&const DeepCollectionEquality().equals(other._pendingApprovals, _pendingApprovals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(_runs),const DeepCollectionEquality().hash(_pendingApprovals));

@override
String toString() {
  return 'AscpSessionsGetResult(session: $session, runs: $runs, pendingApprovals: $pendingApprovals)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsGetResultCopyWith<$Res> implements $AscpSessionsGetResultCopyWith<$Res> {
  factory _$AscpSessionsGetResultCopyWith(_AscpSessionsGetResult value, $Res Function(_AscpSessionsGetResult) _then) = __$AscpSessionsGetResultCopyWithImpl;
@override @useResult
$Res call({
 AscpSession session, List<AscpRun> runs,@JsonKey(name: 'pending_approvals') List<AscpApprovalRequest> pendingApprovals
});


@override $AscpSessionCopyWith<$Res> get session;

}
/// @nodoc
class __$AscpSessionsGetResultCopyWithImpl<$Res>
    implements _$AscpSessionsGetResultCopyWith<$Res> {
  __$AscpSessionsGetResultCopyWithImpl(this._self, this._then);

  final _AscpSessionsGetResult _self;
  final $Res Function(_AscpSessionsGetResult) _then;

/// Create a copy of AscpSessionsGetResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? runs = null,Object? pendingApprovals = null,}) {
  return _then(_AscpSessionsGetResult(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AscpSession,runs: null == runs ? _self._runs : runs // ignore: cast_nullable_to_non_nullable
as List<AscpRun>,pendingApprovals: null == pendingApprovals ? _self._pendingApprovals : pendingApprovals // ignore: cast_nullable_to_non_nullable
as List<AscpApprovalRequest>,
  ));
}

/// Create a copy of AscpSessionsGetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSessionCopyWith<$Res> get session {
  
  return $AscpSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// @nodoc
mixin _$AscpSessionsStartParams {

@JsonKey(name: 'runtime_id') String get runtimeId; String? get workspace; String? get title;@JsonKey(name: 'initial_prompt') String? get initialPrompt; Map<String, Object?>? get metadata;
/// Create a copy of AscpSessionsStartParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsStartParamsCopyWith<AscpSessionsStartParams> get copyWith => _$AscpSessionsStartParamsCopyWithImpl<AscpSessionsStartParams>(this as AscpSessionsStartParams, _$identity);

  /// Serializes this AscpSessionsStartParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsStartParams&&(identical(other.runtimeId, runtimeId) || other.runtimeId == runtimeId)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.title, title) || other.title == title)&&(identical(other.initialPrompt, initialPrompt) || other.initialPrompt == initialPrompt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runtimeId,workspace,title,initialPrompt,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'AscpSessionsStartParams(runtimeId: $runtimeId, workspace: $workspace, title: $title, initialPrompt: $initialPrompt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsStartParamsCopyWith<$Res>  {
  factory $AscpSessionsStartParamsCopyWith(AscpSessionsStartParams value, $Res Function(AscpSessionsStartParams) _then) = _$AscpSessionsStartParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'runtime_id') String runtimeId, String? workspace, String? title,@JsonKey(name: 'initial_prompt') String? initialPrompt, Map<String, Object?>? metadata
});




}
/// @nodoc
class _$AscpSessionsStartParamsCopyWithImpl<$Res>
    implements $AscpSessionsStartParamsCopyWith<$Res> {
  _$AscpSessionsStartParamsCopyWithImpl(this._self, this._then);

  final AscpSessionsStartParams _self;
  final $Res Function(AscpSessionsStartParams) _then;

/// Create a copy of AscpSessionsStartParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runtimeId = null,Object? workspace = freezed,Object? title = freezed,Object? initialPrompt = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
runtimeId: null == runtimeId ? _self.runtimeId : runtimeId // ignore: cast_nullable_to_non_nullable
as String,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,initialPrompt: freezed == initialPrompt ? _self.initialPrompt : initialPrompt // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsStartParams].
extension AscpSessionsStartParamsPatterns on AscpSessionsStartParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsStartParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsStartParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsStartParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsStartParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsStartParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsStartParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'runtime_id')  String runtimeId,  String? workspace,  String? title, @JsonKey(name: 'initial_prompt')  String? initialPrompt,  Map<String, Object?>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsStartParams() when $default != null:
return $default(_that.runtimeId,_that.workspace,_that.title,_that.initialPrompt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'runtime_id')  String runtimeId,  String? workspace,  String? title, @JsonKey(name: 'initial_prompt')  String? initialPrompt,  Map<String, Object?>? metadata)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsStartParams():
return $default(_that.runtimeId,_that.workspace,_that.title,_that.initialPrompt,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'runtime_id')  String runtimeId,  String? workspace,  String? title, @JsonKey(name: 'initial_prompt')  String? initialPrompt,  Map<String, Object?>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsStartParams() when $default != null:
return $default(_that.runtimeId,_that.workspace,_that.title,_that.initialPrompt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpSessionsStartParams implements AscpSessionsStartParams {
  const _AscpSessionsStartParams({@JsonKey(name: 'runtime_id') required this.runtimeId, this.workspace, this.title, @JsonKey(name: 'initial_prompt') this.initialPrompt, final  Map<String, Object?>? metadata}): _metadata = metadata;
  factory _AscpSessionsStartParams.fromJson(Map<String, dynamic> json) => _$AscpSessionsStartParamsFromJson(json);

@override@JsonKey(name: 'runtime_id') final  String runtimeId;
@override final  String? workspace;
@override final  String? title;
@override@JsonKey(name: 'initial_prompt') final  String? initialPrompt;
 final  Map<String, Object?>? _metadata;
@override Map<String, Object?>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AscpSessionsStartParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsStartParamsCopyWith<_AscpSessionsStartParams> get copyWith => __$AscpSessionsStartParamsCopyWithImpl<_AscpSessionsStartParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsStartParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsStartParams&&(identical(other.runtimeId, runtimeId) || other.runtimeId == runtimeId)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.title, title) || other.title == title)&&(identical(other.initialPrompt, initialPrompt) || other.initialPrompt == initialPrompt)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runtimeId,workspace,title,initialPrompt,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'AscpSessionsStartParams(runtimeId: $runtimeId, workspace: $workspace, title: $title, initialPrompt: $initialPrompt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsStartParamsCopyWith<$Res> implements $AscpSessionsStartParamsCopyWith<$Res> {
  factory _$AscpSessionsStartParamsCopyWith(_AscpSessionsStartParams value, $Res Function(_AscpSessionsStartParams) _then) = __$AscpSessionsStartParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'runtime_id') String runtimeId, String? workspace, String? title,@JsonKey(name: 'initial_prompt') String? initialPrompt, Map<String, Object?>? metadata
});




}
/// @nodoc
class __$AscpSessionsStartParamsCopyWithImpl<$Res>
    implements _$AscpSessionsStartParamsCopyWith<$Res> {
  __$AscpSessionsStartParamsCopyWithImpl(this._self, this._then);

  final _AscpSessionsStartParams _self;
  final $Res Function(_AscpSessionsStartParams) _then;

/// Create a copy of AscpSessionsStartParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runtimeId = null,Object? workspace = freezed,Object? title = freezed,Object? initialPrompt = freezed,Object? metadata = freezed,}) {
  return _then(_AscpSessionsStartParams(
runtimeId: null == runtimeId ? _self.runtimeId : runtimeId // ignore: cast_nullable_to_non_nullable
as String,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,initialPrompt: freezed == initialPrompt ? _self.initialPrompt : initialPrompt // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsStartResult {

 AscpSession get session;
/// Create a copy of AscpSessionsStartResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsStartResultCopyWith<AscpSessionsStartResult> get copyWith => _$AscpSessionsStartResultCopyWithImpl<AscpSessionsStartResult>(this as AscpSessionsStartResult, _$identity);

  /// Serializes this AscpSessionsStartResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsStartResult&&(identical(other.session, session) || other.session == session));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session);

@override
String toString() {
  return 'AscpSessionsStartResult(session: $session)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsStartResultCopyWith<$Res>  {
  factory $AscpSessionsStartResultCopyWith(AscpSessionsStartResult value, $Res Function(AscpSessionsStartResult) _then) = _$AscpSessionsStartResultCopyWithImpl;
@useResult
$Res call({
 AscpSession session
});


$AscpSessionCopyWith<$Res> get session;

}
/// @nodoc
class _$AscpSessionsStartResultCopyWithImpl<$Res>
    implements $AscpSessionsStartResultCopyWith<$Res> {
  _$AscpSessionsStartResultCopyWithImpl(this._self, this._then);

  final AscpSessionsStartResult _self;
  final $Res Function(AscpSessionsStartResult) _then;

/// Create a copy of AscpSessionsStartResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AscpSession,
  ));
}
/// Create a copy of AscpSessionsStartResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSessionCopyWith<$Res> get session {
  
  return $AscpSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpSessionsStartResult].
extension AscpSessionsStartResultPatterns on AscpSessionsStartResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsStartResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsStartResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsStartResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsStartResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsStartResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsStartResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AscpSession session)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsStartResult() when $default != null:
return $default(_that.session);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AscpSession session)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsStartResult():
return $default(_that.session);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AscpSession session)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsStartResult() when $default != null:
return $default(_that.session);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSessionsStartResult implements AscpSessionsStartResult {
  const _AscpSessionsStartResult({required this.session});
  factory _AscpSessionsStartResult.fromJson(Map<String, dynamic> json) => _$AscpSessionsStartResultFromJson(json);

@override final  AscpSession session;

/// Create a copy of AscpSessionsStartResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsStartResultCopyWith<_AscpSessionsStartResult> get copyWith => __$AscpSessionsStartResultCopyWithImpl<_AscpSessionsStartResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsStartResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsStartResult&&(identical(other.session, session) || other.session == session));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session);

@override
String toString() {
  return 'AscpSessionsStartResult(session: $session)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsStartResultCopyWith<$Res> implements $AscpSessionsStartResultCopyWith<$Res> {
  factory _$AscpSessionsStartResultCopyWith(_AscpSessionsStartResult value, $Res Function(_AscpSessionsStartResult) _then) = __$AscpSessionsStartResultCopyWithImpl;
@override @useResult
$Res call({
 AscpSession session
});


@override $AscpSessionCopyWith<$Res> get session;

}
/// @nodoc
class __$AscpSessionsStartResultCopyWithImpl<$Res>
    implements _$AscpSessionsStartResultCopyWith<$Res> {
  __$AscpSessionsStartResultCopyWithImpl(this._self, this._then);

  final _AscpSessionsStartResult _self;
  final $Res Function(_AscpSessionsStartResult) _then;

/// Create a copy of AscpSessionsStartResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(_AscpSessionsStartResult(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AscpSession,
  ));
}

/// Create a copy of AscpSessionsStartResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSessionCopyWith<$Res> get session {
  
  return $AscpSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// @nodoc
mixin _$AscpSessionsResumeParams {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'runtime_id') String? get runtimeId;
/// Create a copy of AscpSessionsResumeParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsResumeParamsCopyWith<AscpSessionsResumeParams> get copyWith => _$AscpSessionsResumeParamsCopyWithImpl<AscpSessionsResumeParams>(this as AscpSessionsResumeParams, _$identity);

  /// Serializes this AscpSessionsResumeParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsResumeParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runtimeId, runtimeId) || other.runtimeId == runtimeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,runtimeId);

@override
String toString() {
  return 'AscpSessionsResumeParams(sessionId: $sessionId, runtimeId: $runtimeId)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsResumeParamsCopyWith<$Res>  {
  factory $AscpSessionsResumeParamsCopyWith(AscpSessionsResumeParams value, $Res Function(AscpSessionsResumeParams) _then) = _$AscpSessionsResumeParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'runtime_id') String? runtimeId
});




}
/// @nodoc
class _$AscpSessionsResumeParamsCopyWithImpl<$Res>
    implements $AscpSessionsResumeParamsCopyWith<$Res> {
  _$AscpSessionsResumeParamsCopyWithImpl(this._self, this._then);

  final AscpSessionsResumeParams _self;
  final $Res Function(AscpSessionsResumeParams) _then;

/// Create a copy of AscpSessionsResumeParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? runtimeId = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runtimeId: freezed == runtimeId ? _self.runtimeId : runtimeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsResumeParams].
extension AscpSessionsResumeParamsPatterns on AscpSessionsResumeParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsResumeParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsResumeParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsResumeParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsResumeParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsResumeParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsResumeParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'runtime_id')  String? runtimeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsResumeParams() when $default != null:
return $default(_that.sessionId,_that.runtimeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'runtime_id')  String? runtimeId)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsResumeParams():
return $default(_that.sessionId,_that.runtimeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'runtime_id')  String? runtimeId)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsResumeParams() when $default != null:
return $default(_that.sessionId,_that.runtimeId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpSessionsResumeParams implements AscpSessionsResumeParams {
  const _AscpSessionsResumeParams({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'runtime_id') this.runtimeId});
  factory _AscpSessionsResumeParams.fromJson(Map<String, dynamic> json) => _$AscpSessionsResumeParamsFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'runtime_id') final  String? runtimeId;

/// Create a copy of AscpSessionsResumeParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsResumeParamsCopyWith<_AscpSessionsResumeParams> get copyWith => __$AscpSessionsResumeParamsCopyWithImpl<_AscpSessionsResumeParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsResumeParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsResumeParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runtimeId, runtimeId) || other.runtimeId == runtimeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,runtimeId);

@override
String toString() {
  return 'AscpSessionsResumeParams(sessionId: $sessionId, runtimeId: $runtimeId)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsResumeParamsCopyWith<$Res> implements $AscpSessionsResumeParamsCopyWith<$Res> {
  factory _$AscpSessionsResumeParamsCopyWith(_AscpSessionsResumeParams value, $Res Function(_AscpSessionsResumeParams) _then) = __$AscpSessionsResumeParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'runtime_id') String? runtimeId
});




}
/// @nodoc
class __$AscpSessionsResumeParamsCopyWithImpl<$Res>
    implements _$AscpSessionsResumeParamsCopyWith<$Res> {
  __$AscpSessionsResumeParamsCopyWithImpl(this._self, this._then);

  final _AscpSessionsResumeParams _self;
  final $Res Function(_AscpSessionsResumeParams) _then;

/// Create a copy of AscpSessionsResumeParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? runtimeId = freezed,}) {
  return _then(_AscpSessionsResumeParams(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runtimeId: freezed == runtimeId ? _self.runtimeId : runtimeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsResumeResult {

 AscpSession get session;@JsonKey(name: 'snapshot_emitted') bool? get snapshotEmitted;@JsonKey(name: 'replay_supported') bool? get replaySupported;
/// Create a copy of AscpSessionsResumeResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsResumeResultCopyWith<AscpSessionsResumeResult> get copyWith => _$AscpSessionsResumeResultCopyWithImpl<AscpSessionsResumeResult>(this as AscpSessionsResumeResult, _$identity);

  /// Serializes this AscpSessionsResumeResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsResumeResult&&(identical(other.session, session) || other.session == session)&&(identical(other.snapshotEmitted, snapshotEmitted) || other.snapshotEmitted == snapshotEmitted)&&(identical(other.replaySupported, replaySupported) || other.replaySupported == replaySupported));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,snapshotEmitted,replaySupported);

@override
String toString() {
  return 'AscpSessionsResumeResult(session: $session, snapshotEmitted: $snapshotEmitted, replaySupported: $replaySupported)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsResumeResultCopyWith<$Res>  {
  factory $AscpSessionsResumeResultCopyWith(AscpSessionsResumeResult value, $Res Function(AscpSessionsResumeResult) _then) = _$AscpSessionsResumeResultCopyWithImpl;
@useResult
$Res call({
 AscpSession session,@JsonKey(name: 'snapshot_emitted') bool? snapshotEmitted,@JsonKey(name: 'replay_supported') bool? replaySupported
});


$AscpSessionCopyWith<$Res> get session;

}
/// @nodoc
class _$AscpSessionsResumeResultCopyWithImpl<$Res>
    implements $AscpSessionsResumeResultCopyWith<$Res> {
  _$AscpSessionsResumeResultCopyWithImpl(this._self, this._then);

  final AscpSessionsResumeResult _self;
  final $Res Function(AscpSessionsResumeResult) _then;

/// Create a copy of AscpSessionsResumeResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? snapshotEmitted = freezed,Object? replaySupported = freezed,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AscpSession,snapshotEmitted: freezed == snapshotEmitted ? _self.snapshotEmitted : snapshotEmitted // ignore: cast_nullable_to_non_nullable
as bool?,replaySupported: freezed == replaySupported ? _self.replaySupported : replaySupported // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of AscpSessionsResumeResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSessionCopyWith<$Res> get session {
  
  return $AscpSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpSessionsResumeResult].
extension AscpSessionsResumeResultPatterns on AscpSessionsResumeResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsResumeResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsResumeResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsResumeResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsResumeResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsResumeResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsResumeResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AscpSession session, @JsonKey(name: 'snapshot_emitted')  bool? snapshotEmitted, @JsonKey(name: 'replay_supported')  bool? replaySupported)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsResumeResult() when $default != null:
return $default(_that.session,_that.snapshotEmitted,_that.replaySupported);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AscpSession session, @JsonKey(name: 'snapshot_emitted')  bool? snapshotEmitted, @JsonKey(name: 'replay_supported')  bool? replaySupported)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsResumeResult():
return $default(_that.session,_that.snapshotEmitted,_that.replaySupported);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AscpSession session, @JsonKey(name: 'snapshot_emitted')  bool? snapshotEmitted, @JsonKey(name: 'replay_supported')  bool? replaySupported)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsResumeResult() when $default != null:
return $default(_that.session,_that.snapshotEmitted,_that.replaySupported);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSessionsResumeResult implements AscpSessionsResumeResult {
  const _AscpSessionsResumeResult({required this.session, @JsonKey(name: 'snapshot_emitted') this.snapshotEmitted, @JsonKey(name: 'replay_supported') this.replaySupported});
  factory _AscpSessionsResumeResult.fromJson(Map<String, dynamic> json) => _$AscpSessionsResumeResultFromJson(json);

@override final  AscpSession session;
@override@JsonKey(name: 'snapshot_emitted') final  bool? snapshotEmitted;
@override@JsonKey(name: 'replay_supported') final  bool? replaySupported;

/// Create a copy of AscpSessionsResumeResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsResumeResultCopyWith<_AscpSessionsResumeResult> get copyWith => __$AscpSessionsResumeResultCopyWithImpl<_AscpSessionsResumeResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsResumeResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsResumeResult&&(identical(other.session, session) || other.session == session)&&(identical(other.snapshotEmitted, snapshotEmitted) || other.snapshotEmitted == snapshotEmitted)&&(identical(other.replaySupported, replaySupported) || other.replaySupported == replaySupported));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,snapshotEmitted,replaySupported);

@override
String toString() {
  return 'AscpSessionsResumeResult(session: $session, snapshotEmitted: $snapshotEmitted, replaySupported: $replaySupported)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsResumeResultCopyWith<$Res> implements $AscpSessionsResumeResultCopyWith<$Res> {
  factory _$AscpSessionsResumeResultCopyWith(_AscpSessionsResumeResult value, $Res Function(_AscpSessionsResumeResult) _then) = __$AscpSessionsResumeResultCopyWithImpl;
@override @useResult
$Res call({
 AscpSession session,@JsonKey(name: 'snapshot_emitted') bool? snapshotEmitted,@JsonKey(name: 'replay_supported') bool? replaySupported
});


@override $AscpSessionCopyWith<$Res> get session;

}
/// @nodoc
class __$AscpSessionsResumeResultCopyWithImpl<$Res>
    implements _$AscpSessionsResumeResultCopyWith<$Res> {
  __$AscpSessionsResumeResultCopyWithImpl(this._self, this._then);

  final _AscpSessionsResumeResult _self;
  final $Res Function(_AscpSessionsResumeResult) _then;

/// Create a copy of AscpSessionsResumeResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? snapshotEmitted = freezed,Object? replaySupported = freezed,}) {
  return _then(_AscpSessionsResumeResult(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AscpSession,snapshotEmitted: freezed == snapshotEmitted ? _self.snapshotEmitted : snapshotEmitted // ignore: cast_nullable_to_non_nullable
as bool?,replaySupported: freezed == replaySupported ? _self.replaySupported : replaySupported // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of AscpSessionsResumeResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSessionCopyWith<$Res> get session {
  
  return $AscpSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// @nodoc
mixin _$AscpSessionsStopParams {

@JsonKey(name: 'session_id') String get sessionId; String? get mode; String? get reason;
/// Create a copy of AscpSessionsStopParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsStopParamsCopyWith<AscpSessionsStopParams> get copyWith => _$AscpSessionsStopParamsCopyWithImpl<AscpSessionsStopParams>(this as AscpSessionsStopParams, _$identity);

  /// Serializes this AscpSessionsStopParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsStopParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,mode,reason);

@override
String toString() {
  return 'AscpSessionsStopParams(sessionId: $sessionId, mode: $mode, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsStopParamsCopyWith<$Res>  {
  factory $AscpSessionsStopParamsCopyWith(AscpSessionsStopParams value, $Res Function(AscpSessionsStopParams) _then) = _$AscpSessionsStopParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String? mode, String? reason
});




}
/// @nodoc
class _$AscpSessionsStopParamsCopyWithImpl<$Res>
    implements $AscpSessionsStopParamsCopyWith<$Res> {
  _$AscpSessionsStopParamsCopyWithImpl(this._self, this._then);

  final AscpSessionsStopParams _self;
  final $Res Function(AscpSessionsStopParams) _then;

/// Create a copy of AscpSessionsStopParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? mode = freezed,Object? reason = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsStopParams].
extension AscpSessionsStopParamsPatterns on AscpSessionsStopParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsStopParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsStopParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsStopParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsStopParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsStopParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsStopParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String? mode,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsStopParams() when $default != null:
return $default(_that.sessionId,_that.mode,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String? mode,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsStopParams():
return $default(_that.sessionId,_that.mode,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId,  String? mode,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsStopParams() when $default != null:
return $default(_that.sessionId,_that.mode,_that.reason);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpSessionsStopParams implements AscpSessionsStopParams {
  const _AscpSessionsStopParams({@JsonKey(name: 'session_id') required this.sessionId, this.mode, this.reason});
  factory _AscpSessionsStopParams.fromJson(Map<String, dynamic> json) => _$AscpSessionsStopParamsFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override final  String? mode;
@override final  String? reason;

/// Create a copy of AscpSessionsStopParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsStopParamsCopyWith<_AscpSessionsStopParams> get copyWith => __$AscpSessionsStopParamsCopyWithImpl<_AscpSessionsStopParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsStopParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsStopParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,mode,reason);

@override
String toString() {
  return 'AscpSessionsStopParams(sessionId: $sessionId, mode: $mode, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsStopParamsCopyWith<$Res> implements $AscpSessionsStopParamsCopyWith<$Res> {
  factory _$AscpSessionsStopParamsCopyWith(_AscpSessionsStopParams value, $Res Function(_AscpSessionsStopParams) _then) = __$AscpSessionsStopParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String? mode, String? reason
});




}
/// @nodoc
class __$AscpSessionsStopParamsCopyWithImpl<$Res>
    implements _$AscpSessionsStopParamsCopyWith<$Res> {
  __$AscpSessionsStopParamsCopyWithImpl(this._self, this._then);

  final _AscpSessionsStopParams _self;
  final $Res Function(_AscpSessionsStopParams) _then;

/// Create a copy of AscpSessionsStopParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? mode = freezed,Object? reason = freezed,}) {
  return _then(_AscpSessionsStopParams(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String?,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsStopResult {

@JsonKey(name: 'session_id') String get sessionId; String get status;
/// Create a copy of AscpSessionsStopResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsStopResultCopyWith<AscpSessionsStopResult> get copyWith => _$AscpSessionsStopResultCopyWithImpl<AscpSessionsStopResult>(this as AscpSessionsStopResult, _$identity);

  /// Serializes this AscpSessionsStopResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsStopResult&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,status);

@override
String toString() {
  return 'AscpSessionsStopResult(sessionId: $sessionId, status: $status)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsStopResultCopyWith<$Res>  {
  factory $AscpSessionsStopResultCopyWith(AscpSessionsStopResult value, $Res Function(AscpSessionsStopResult) _then) = _$AscpSessionsStopResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String status
});




}
/// @nodoc
class _$AscpSessionsStopResultCopyWithImpl<$Res>
    implements $AscpSessionsStopResultCopyWith<$Res> {
  _$AscpSessionsStopResultCopyWithImpl(this._self, this._then);

  final AscpSessionsStopResult _self;
  final $Res Function(AscpSessionsStopResult) _then;

/// Create a copy of AscpSessionsStopResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? status = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsStopResult].
extension AscpSessionsStopResultPatterns on AscpSessionsStopResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsStopResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsStopResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsStopResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsStopResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsStopResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsStopResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsStopResult() when $default != null:
return $default(_that.sessionId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String status)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsStopResult():
return $default(_that.sessionId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId,  String status)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsStopResult() when $default != null:
return $default(_that.sessionId,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSessionsStopResult implements AscpSessionsStopResult {
  const _AscpSessionsStopResult({@JsonKey(name: 'session_id') required this.sessionId, required this.status});
  factory _AscpSessionsStopResult.fromJson(Map<String, dynamic> json) => _$AscpSessionsStopResultFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override final  String status;

/// Create a copy of AscpSessionsStopResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsStopResultCopyWith<_AscpSessionsStopResult> get copyWith => __$AscpSessionsStopResultCopyWithImpl<_AscpSessionsStopResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsStopResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsStopResult&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,status);

@override
String toString() {
  return 'AscpSessionsStopResult(sessionId: $sessionId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsStopResultCopyWith<$Res> implements $AscpSessionsStopResultCopyWith<$Res> {
  factory _$AscpSessionsStopResultCopyWith(_AscpSessionsStopResult value, $Res Function(_AscpSessionsStopResult) _then) = __$AscpSessionsStopResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String status
});




}
/// @nodoc
class __$AscpSessionsStopResultCopyWithImpl<$Res>
    implements _$AscpSessionsStopResultCopyWith<$Res> {
  __$AscpSessionsStopResultCopyWithImpl(this._self, this._then);

  final _AscpSessionsStopResult _self;
  final $Res Function(_AscpSessionsStopResult) _then;

/// Create a copy of AscpSessionsStopResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? status = null,}) {
  return _then(_AscpSessionsStopResult(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsSendInputParams {

@JsonKey(name: 'session_id') String get sessionId; String get input;@JsonKey(name: 'input_kind') String? get inputKind; Map<String, Object?>? get metadata;
/// Create a copy of AscpSessionsSendInputParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsSendInputParamsCopyWith<AscpSessionsSendInputParams> get copyWith => _$AscpSessionsSendInputParamsCopyWithImpl<AscpSessionsSendInputParams>(this as AscpSessionsSendInputParams, _$identity);

  /// Serializes this AscpSessionsSendInputParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsSendInputParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.input, input) || other.input == input)&&(identical(other.inputKind, inputKind) || other.inputKind == inputKind)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,input,inputKind,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'AscpSessionsSendInputParams(sessionId: $sessionId, input: $input, inputKind: $inputKind, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsSendInputParamsCopyWith<$Res>  {
  factory $AscpSessionsSendInputParamsCopyWith(AscpSessionsSendInputParams value, $Res Function(AscpSessionsSendInputParams) _then) = _$AscpSessionsSendInputParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String input,@JsonKey(name: 'input_kind') String? inputKind, Map<String, Object?>? metadata
});




}
/// @nodoc
class _$AscpSessionsSendInputParamsCopyWithImpl<$Res>
    implements $AscpSessionsSendInputParamsCopyWith<$Res> {
  _$AscpSessionsSendInputParamsCopyWithImpl(this._self, this._then);

  final AscpSessionsSendInputParams _self;
  final $Res Function(AscpSessionsSendInputParams) _then;

/// Create a copy of AscpSessionsSendInputParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? input = null,Object? inputKind = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,inputKind: freezed == inputKind ? _self.inputKind : inputKind // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsSendInputParams].
extension AscpSessionsSendInputParamsPatterns on AscpSessionsSendInputParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsSendInputParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsSendInputParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsSendInputParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsSendInputParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsSendInputParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsSendInputParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String input, @JsonKey(name: 'input_kind')  String? inputKind,  Map<String, Object?>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsSendInputParams() when $default != null:
return $default(_that.sessionId,_that.input,_that.inputKind,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  String input, @JsonKey(name: 'input_kind')  String? inputKind,  Map<String, Object?>? metadata)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsSendInputParams():
return $default(_that.sessionId,_that.input,_that.inputKind,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId,  String input, @JsonKey(name: 'input_kind')  String? inputKind,  Map<String, Object?>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsSendInputParams() when $default != null:
return $default(_that.sessionId,_that.input,_that.inputKind,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpSessionsSendInputParams implements AscpSessionsSendInputParams {
  const _AscpSessionsSendInputParams({@JsonKey(name: 'session_id') required this.sessionId, required this.input, @JsonKey(name: 'input_kind') this.inputKind, final  Map<String, Object?>? metadata}): _metadata = metadata;
  factory _AscpSessionsSendInputParams.fromJson(Map<String, dynamic> json) => _$AscpSessionsSendInputParamsFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override final  String input;
@override@JsonKey(name: 'input_kind') final  String? inputKind;
 final  Map<String, Object?>? _metadata;
@override Map<String, Object?>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AscpSessionsSendInputParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsSendInputParamsCopyWith<_AscpSessionsSendInputParams> get copyWith => __$AscpSessionsSendInputParamsCopyWithImpl<_AscpSessionsSendInputParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsSendInputParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsSendInputParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.input, input) || other.input == input)&&(identical(other.inputKind, inputKind) || other.inputKind == inputKind)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,input,inputKind,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'AscpSessionsSendInputParams(sessionId: $sessionId, input: $input, inputKind: $inputKind, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsSendInputParamsCopyWith<$Res> implements $AscpSessionsSendInputParamsCopyWith<$Res> {
  factory _$AscpSessionsSendInputParamsCopyWith(_AscpSessionsSendInputParams value, $Res Function(_AscpSessionsSendInputParams) _then) = __$AscpSessionsSendInputParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, String input,@JsonKey(name: 'input_kind') String? inputKind, Map<String, Object?>? metadata
});




}
/// @nodoc
class __$AscpSessionsSendInputParamsCopyWithImpl<$Res>
    implements _$AscpSessionsSendInputParamsCopyWith<$Res> {
  __$AscpSessionsSendInputParamsCopyWithImpl(this._self, this._then);

  final _AscpSessionsSendInputParams _self;
  final $Res Function(_AscpSessionsSendInputParams) _then;

/// Create a copy of AscpSessionsSendInputParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? input = null,Object? inputKind = freezed,Object? metadata = freezed,}) {
  return _then(_AscpSessionsSendInputParams(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,inputKind: freezed == inputKind ? _self.inputKind : inputKind // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsSendInputResult {

@JsonKey(name: 'session_id') String get sessionId; bool get accepted;
/// Create a copy of AscpSessionsSendInputResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsSendInputResultCopyWith<AscpSessionsSendInputResult> get copyWith => _$AscpSessionsSendInputResultCopyWithImpl<AscpSessionsSendInputResult>(this as AscpSessionsSendInputResult, _$identity);

  /// Serializes this AscpSessionsSendInputResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsSendInputResult&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.accepted, accepted) || other.accepted == accepted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,accepted);

@override
String toString() {
  return 'AscpSessionsSendInputResult(sessionId: $sessionId, accepted: $accepted)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsSendInputResultCopyWith<$Res>  {
  factory $AscpSessionsSendInputResultCopyWith(AscpSessionsSendInputResult value, $Res Function(AscpSessionsSendInputResult) _then) = _$AscpSessionsSendInputResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, bool accepted
});




}
/// @nodoc
class _$AscpSessionsSendInputResultCopyWithImpl<$Res>
    implements $AscpSessionsSendInputResultCopyWith<$Res> {
  _$AscpSessionsSendInputResultCopyWithImpl(this._self, this._then);

  final AscpSessionsSendInputResult _self;
  final $Res Function(AscpSessionsSendInputResult) _then;

/// Create a copy of AscpSessionsSendInputResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? accepted = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsSendInputResult].
extension AscpSessionsSendInputResultPatterns on AscpSessionsSendInputResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsSendInputResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsSendInputResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsSendInputResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsSendInputResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsSendInputResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsSendInputResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  bool accepted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsSendInputResult() when $default != null:
return $default(_that.sessionId,_that.accepted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId,  bool accepted)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsSendInputResult():
return $default(_that.sessionId,_that.accepted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId,  bool accepted)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsSendInputResult() when $default != null:
return $default(_that.sessionId,_that.accepted);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSessionsSendInputResult implements AscpSessionsSendInputResult {
  const _AscpSessionsSendInputResult({@JsonKey(name: 'session_id') required this.sessionId, required this.accepted});
  factory _AscpSessionsSendInputResult.fromJson(Map<String, dynamic> json) => _$AscpSessionsSendInputResultFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override final  bool accepted;

/// Create a copy of AscpSessionsSendInputResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsSendInputResultCopyWith<_AscpSessionsSendInputResult> get copyWith => __$AscpSessionsSendInputResultCopyWithImpl<_AscpSessionsSendInputResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsSendInputResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsSendInputResult&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.accepted, accepted) || other.accepted == accepted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,accepted);

@override
String toString() {
  return 'AscpSessionsSendInputResult(sessionId: $sessionId, accepted: $accepted)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsSendInputResultCopyWith<$Res> implements $AscpSessionsSendInputResultCopyWith<$Res> {
  factory _$AscpSessionsSendInputResultCopyWith(_AscpSessionsSendInputResult value, $Res Function(_AscpSessionsSendInputResult) _then) = __$AscpSessionsSendInputResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId, bool accepted
});




}
/// @nodoc
class __$AscpSessionsSendInputResultCopyWithImpl<$Res>
    implements _$AscpSessionsSendInputResultCopyWith<$Res> {
  __$AscpSessionsSendInputResultCopyWithImpl(this._self, this._then);

  final _AscpSessionsSendInputResult _self;
  final $Res Function(_AscpSessionsSendInputResult) _then;

/// Create a copy of AscpSessionsSendInputResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? accepted = null,}) {
  return _then(_AscpSessionsSendInputResult(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsSubscribeParams {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'from_seq') int? get fromSeq;@JsonKey(name: 'from_event_id') String? get fromEventId;@JsonKey(name: 'include_snapshot') bool? get includeSnapshot;@JsonKey(includeFromJson: false, includeToJson: false) Map<String, Object?> get extensionFields;
/// Create a copy of AscpSessionsSubscribeParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsSubscribeParamsCopyWith<AscpSessionsSubscribeParams> get copyWith => _$AscpSessionsSubscribeParamsCopyWithImpl<AscpSessionsSubscribeParams>(this as AscpSessionsSubscribeParams, _$identity);

  /// Serializes this AscpSessionsSubscribeParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsSubscribeParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.fromSeq, fromSeq) || other.fromSeq == fromSeq)&&(identical(other.fromEventId, fromEventId) || other.fromEventId == fromEventId)&&(identical(other.includeSnapshot, includeSnapshot) || other.includeSnapshot == includeSnapshot)&&const DeepCollectionEquality().equals(other.extensionFields, extensionFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,fromSeq,fromEventId,includeSnapshot,const DeepCollectionEquality().hash(extensionFields));

@override
String toString() {
  return 'AscpSessionsSubscribeParams(sessionId: $sessionId, fromSeq: $fromSeq, fromEventId: $fromEventId, includeSnapshot: $includeSnapshot, extensionFields: $extensionFields)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsSubscribeParamsCopyWith<$Res>  {
  factory $AscpSessionsSubscribeParamsCopyWith(AscpSessionsSubscribeParams value, $Res Function(AscpSessionsSubscribeParams) _then) = _$AscpSessionsSubscribeParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'from_seq') int? fromSeq,@JsonKey(name: 'from_event_id') String? fromEventId,@JsonKey(name: 'include_snapshot') bool? includeSnapshot,@JsonKey(includeFromJson: false, includeToJson: false) Map<String, Object?> extensionFields
});




}
/// @nodoc
class _$AscpSessionsSubscribeParamsCopyWithImpl<$Res>
    implements $AscpSessionsSubscribeParamsCopyWith<$Res> {
  _$AscpSessionsSubscribeParamsCopyWithImpl(this._self, this._then);

  final AscpSessionsSubscribeParams _self;
  final $Res Function(AscpSessionsSubscribeParams) _then;

/// Create a copy of AscpSessionsSubscribeParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? fromSeq = freezed,Object? fromEventId = freezed,Object? includeSnapshot = freezed,Object? extensionFields = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,fromSeq: freezed == fromSeq ? _self.fromSeq : fromSeq // ignore: cast_nullable_to_non_nullable
as int?,fromEventId: freezed == fromEventId ? _self.fromEventId : fromEventId // ignore: cast_nullable_to_non_nullable
as String?,includeSnapshot: freezed == includeSnapshot ? _self.includeSnapshot : includeSnapshot // ignore: cast_nullable_to_non_nullable
as bool?,extensionFields: null == extensionFields ? _self.extensionFields : extensionFields // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsSubscribeParams].
extension AscpSessionsSubscribeParamsPatterns on AscpSessionsSubscribeParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsSubscribeParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsSubscribeParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsSubscribeParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsSubscribeParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsSubscribeParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsSubscribeParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'from_seq')  int? fromSeq, @JsonKey(name: 'from_event_id')  String? fromEventId, @JsonKey(name: 'include_snapshot')  bool? includeSnapshot, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, Object?> extensionFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsSubscribeParams() when $default != null:
return $default(_that.sessionId,_that.fromSeq,_that.fromEventId,_that.includeSnapshot,_that.extensionFields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'from_seq')  int? fromSeq, @JsonKey(name: 'from_event_id')  String? fromEventId, @JsonKey(name: 'include_snapshot')  bool? includeSnapshot, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, Object?> extensionFields)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsSubscribeParams():
return $default(_that.sessionId,_that.fromSeq,_that.fromEventId,_that.includeSnapshot,_that.extensionFields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'from_seq')  int? fromSeq, @JsonKey(name: 'from_event_id')  String? fromEventId, @JsonKey(name: 'include_snapshot')  bool? includeSnapshot, @JsonKey(includeFromJson: false, includeToJson: false)  Map<String, Object?> extensionFields)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsSubscribeParams() when $default != null:
return $default(_that.sessionId,_that.fromSeq,_that.fromEventId,_that.includeSnapshot,_that.extensionFields);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpSessionsSubscribeParams extends AscpSessionsSubscribeParams {
  const _AscpSessionsSubscribeParams({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'from_seq') this.fromSeq, @JsonKey(name: 'from_event_id') this.fromEventId, @JsonKey(name: 'include_snapshot') this.includeSnapshot, @JsonKey(includeFromJson: false, includeToJson: false) final  Map<String, Object?> extensionFields = const <String, Object?>{}}): _extensionFields = extensionFields,super._();
  factory _AscpSessionsSubscribeParams.fromJson(Map<String, dynamic> json) => _$AscpSessionsSubscribeParamsFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'from_seq') final  int? fromSeq;
@override@JsonKey(name: 'from_event_id') final  String? fromEventId;
@override@JsonKey(name: 'include_snapshot') final  bool? includeSnapshot;
 final  Map<String, Object?> _extensionFields;
@override@JsonKey(includeFromJson: false, includeToJson: false) Map<String, Object?> get extensionFields {
  if (_extensionFields is EqualUnmodifiableMapView) return _extensionFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extensionFields);
}


/// Create a copy of AscpSessionsSubscribeParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsSubscribeParamsCopyWith<_AscpSessionsSubscribeParams> get copyWith => __$AscpSessionsSubscribeParamsCopyWithImpl<_AscpSessionsSubscribeParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsSubscribeParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsSubscribeParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.fromSeq, fromSeq) || other.fromSeq == fromSeq)&&(identical(other.fromEventId, fromEventId) || other.fromEventId == fromEventId)&&(identical(other.includeSnapshot, includeSnapshot) || other.includeSnapshot == includeSnapshot)&&const DeepCollectionEquality().equals(other._extensionFields, _extensionFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,fromSeq,fromEventId,includeSnapshot,const DeepCollectionEquality().hash(_extensionFields));

@override
String toString() {
  return 'AscpSessionsSubscribeParams(sessionId: $sessionId, fromSeq: $fromSeq, fromEventId: $fromEventId, includeSnapshot: $includeSnapshot, extensionFields: $extensionFields)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsSubscribeParamsCopyWith<$Res> implements $AscpSessionsSubscribeParamsCopyWith<$Res> {
  factory _$AscpSessionsSubscribeParamsCopyWith(_AscpSessionsSubscribeParams value, $Res Function(_AscpSessionsSubscribeParams) _then) = __$AscpSessionsSubscribeParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'from_seq') int? fromSeq,@JsonKey(name: 'from_event_id') String? fromEventId,@JsonKey(name: 'include_snapshot') bool? includeSnapshot,@JsonKey(includeFromJson: false, includeToJson: false) Map<String, Object?> extensionFields
});




}
/// @nodoc
class __$AscpSessionsSubscribeParamsCopyWithImpl<$Res>
    implements _$AscpSessionsSubscribeParamsCopyWith<$Res> {
  __$AscpSessionsSubscribeParamsCopyWithImpl(this._self, this._then);

  final _AscpSessionsSubscribeParams _self;
  final $Res Function(_AscpSessionsSubscribeParams) _then;

/// Create a copy of AscpSessionsSubscribeParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? fromSeq = freezed,Object? fromEventId = freezed,Object? includeSnapshot = freezed,Object? extensionFields = null,}) {
  return _then(_AscpSessionsSubscribeParams(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,fromSeq: freezed == fromSeq ? _self.fromSeq : fromSeq // ignore: cast_nullable_to_non_nullable
as int?,fromEventId: freezed == fromEventId ? _self.fromEventId : fromEventId // ignore: cast_nullable_to_non_nullable
as String?,includeSnapshot: freezed == includeSnapshot ? _self.includeSnapshot : includeSnapshot // ignore: cast_nullable_to_non_nullable
as bool?,extensionFields: null == extensionFields ? _self._extensionFields : extensionFields // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsSubscribeResult {

@JsonKey(name: 'subscription_id') String get subscriptionId;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'snapshot_emitted') bool? get snapshotEmitted;
/// Create a copy of AscpSessionsSubscribeResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsSubscribeResultCopyWith<AscpSessionsSubscribeResult> get copyWith => _$AscpSessionsSubscribeResultCopyWithImpl<AscpSessionsSubscribeResult>(this as AscpSessionsSubscribeResult, _$identity);

  /// Serializes this AscpSessionsSubscribeResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsSubscribeResult&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.snapshotEmitted, snapshotEmitted) || other.snapshotEmitted == snapshotEmitted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscriptionId,sessionId,snapshotEmitted);

@override
String toString() {
  return 'AscpSessionsSubscribeResult(subscriptionId: $subscriptionId, sessionId: $sessionId, snapshotEmitted: $snapshotEmitted)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsSubscribeResultCopyWith<$Res>  {
  factory $AscpSessionsSubscribeResultCopyWith(AscpSessionsSubscribeResult value, $Res Function(AscpSessionsSubscribeResult) _then) = _$AscpSessionsSubscribeResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'subscription_id') String subscriptionId,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'snapshot_emitted') bool? snapshotEmitted
});




}
/// @nodoc
class _$AscpSessionsSubscribeResultCopyWithImpl<$Res>
    implements $AscpSessionsSubscribeResultCopyWith<$Res> {
  _$AscpSessionsSubscribeResultCopyWithImpl(this._self, this._then);

  final AscpSessionsSubscribeResult _self;
  final $Res Function(AscpSessionsSubscribeResult) _then;

/// Create a copy of AscpSessionsSubscribeResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subscriptionId = null,Object? sessionId = null,Object? snapshotEmitted = freezed,}) {
  return _then(_self.copyWith(
subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,snapshotEmitted: freezed == snapshotEmitted ? _self.snapshotEmitted : snapshotEmitted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsSubscribeResult].
extension AscpSessionsSubscribeResultPatterns on AscpSessionsSubscribeResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsSubscribeResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsSubscribeResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsSubscribeResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsSubscribeResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsSubscribeResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsSubscribeResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'subscription_id')  String subscriptionId, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'snapshot_emitted')  bool? snapshotEmitted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsSubscribeResult() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'subscription_id')  String subscriptionId, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'snapshot_emitted')  bool? snapshotEmitted)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsSubscribeResult():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'subscription_id')  String subscriptionId, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'snapshot_emitted')  bool? snapshotEmitted)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsSubscribeResult() when $default != null:
return $default(_that.subscriptionId,_that.sessionId,_that.snapshotEmitted);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSessionsSubscribeResult implements AscpSessionsSubscribeResult {
  const _AscpSessionsSubscribeResult({@JsonKey(name: 'subscription_id') required this.subscriptionId, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'snapshot_emitted') this.snapshotEmitted});
  factory _AscpSessionsSubscribeResult.fromJson(Map<String, dynamic> json) => _$AscpSessionsSubscribeResultFromJson(json);

@override@JsonKey(name: 'subscription_id') final  String subscriptionId;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'snapshot_emitted') final  bool? snapshotEmitted;

/// Create a copy of AscpSessionsSubscribeResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsSubscribeResultCopyWith<_AscpSessionsSubscribeResult> get copyWith => __$AscpSessionsSubscribeResultCopyWithImpl<_AscpSessionsSubscribeResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsSubscribeResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsSubscribeResult&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.snapshotEmitted, snapshotEmitted) || other.snapshotEmitted == snapshotEmitted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscriptionId,sessionId,snapshotEmitted);

@override
String toString() {
  return 'AscpSessionsSubscribeResult(subscriptionId: $subscriptionId, sessionId: $sessionId, snapshotEmitted: $snapshotEmitted)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsSubscribeResultCopyWith<$Res> implements $AscpSessionsSubscribeResultCopyWith<$Res> {
  factory _$AscpSessionsSubscribeResultCopyWith(_AscpSessionsSubscribeResult value, $Res Function(_AscpSessionsSubscribeResult) _then) = __$AscpSessionsSubscribeResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'subscription_id') String subscriptionId,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'snapshot_emitted') bool? snapshotEmitted
});




}
/// @nodoc
class __$AscpSessionsSubscribeResultCopyWithImpl<$Res>
    implements _$AscpSessionsSubscribeResultCopyWith<$Res> {
  __$AscpSessionsSubscribeResultCopyWithImpl(this._self, this._then);

  final _AscpSessionsSubscribeResult _self;
  final $Res Function(_AscpSessionsSubscribeResult) _then;

/// Create a copy of AscpSessionsSubscribeResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subscriptionId = null,Object? sessionId = null,Object? snapshotEmitted = freezed,}) {
  return _then(_AscpSessionsSubscribeResult(
subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,snapshotEmitted: freezed == snapshotEmitted ? _self.snapshotEmitted : snapshotEmitted // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsUnsubscribeParams {

@JsonKey(name: 'subscription_id') String get subscriptionId;
/// Create a copy of AscpSessionsUnsubscribeParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsUnsubscribeParamsCopyWith<AscpSessionsUnsubscribeParams> get copyWith => _$AscpSessionsUnsubscribeParamsCopyWithImpl<AscpSessionsUnsubscribeParams>(this as AscpSessionsUnsubscribeParams, _$identity);

  /// Serializes this AscpSessionsUnsubscribeParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsUnsubscribeParams&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscriptionId);

@override
String toString() {
  return 'AscpSessionsUnsubscribeParams(subscriptionId: $subscriptionId)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsUnsubscribeParamsCopyWith<$Res>  {
  factory $AscpSessionsUnsubscribeParamsCopyWith(AscpSessionsUnsubscribeParams value, $Res Function(AscpSessionsUnsubscribeParams) _then) = _$AscpSessionsUnsubscribeParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'subscription_id') String subscriptionId
});




}
/// @nodoc
class _$AscpSessionsUnsubscribeParamsCopyWithImpl<$Res>
    implements $AscpSessionsUnsubscribeParamsCopyWith<$Res> {
  _$AscpSessionsUnsubscribeParamsCopyWithImpl(this._self, this._then);

  final AscpSessionsUnsubscribeParams _self;
  final $Res Function(AscpSessionsUnsubscribeParams) _then;

/// Create a copy of AscpSessionsUnsubscribeParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subscriptionId = null,}) {
  return _then(_self.copyWith(
subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsUnsubscribeParams].
extension AscpSessionsUnsubscribeParamsPatterns on AscpSessionsUnsubscribeParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsUnsubscribeParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsUnsubscribeParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsUnsubscribeParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'subscription_id')  String subscriptionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeParams() when $default != null:
return $default(_that.subscriptionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'subscription_id')  String subscriptionId)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeParams():
return $default(_that.subscriptionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'subscription_id')  String subscriptionId)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeParams() when $default != null:
return $default(_that.subscriptionId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpSessionsUnsubscribeParams implements AscpSessionsUnsubscribeParams {
  const _AscpSessionsUnsubscribeParams({@JsonKey(name: 'subscription_id') required this.subscriptionId});
  factory _AscpSessionsUnsubscribeParams.fromJson(Map<String, dynamic> json) => _$AscpSessionsUnsubscribeParamsFromJson(json);

@override@JsonKey(name: 'subscription_id') final  String subscriptionId;

/// Create a copy of AscpSessionsUnsubscribeParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsUnsubscribeParamsCopyWith<_AscpSessionsUnsubscribeParams> get copyWith => __$AscpSessionsUnsubscribeParamsCopyWithImpl<_AscpSessionsUnsubscribeParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsUnsubscribeParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsUnsubscribeParams&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscriptionId);

@override
String toString() {
  return 'AscpSessionsUnsubscribeParams(subscriptionId: $subscriptionId)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsUnsubscribeParamsCopyWith<$Res> implements $AscpSessionsUnsubscribeParamsCopyWith<$Res> {
  factory _$AscpSessionsUnsubscribeParamsCopyWith(_AscpSessionsUnsubscribeParams value, $Res Function(_AscpSessionsUnsubscribeParams) _then) = __$AscpSessionsUnsubscribeParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'subscription_id') String subscriptionId
});




}
/// @nodoc
class __$AscpSessionsUnsubscribeParamsCopyWithImpl<$Res>
    implements _$AscpSessionsUnsubscribeParamsCopyWith<$Res> {
  __$AscpSessionsUnsubscribeParamsCopyWithImpl(this._self, this._then);

  final _AscpSessionsUnsubscribeParams _self;
  final $Res Function(_AscpSessionsUnsubscribeParams) _then;

/// Create a copy of AscpSessionsUnsubscribeParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subscriptionId = null,}) {
  return _then(_AscpSessionsUnsubscribeParams(
subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AscpSessionsUnsubscribeResult {

@JsonKey(name: 'subscription_id') String get subscriptionId; bool get unsubscribed;
/// Create a copy of AscpSessionsUnsubscribeResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionsUnsubscribeResultCopyWith<AscpSessionsUnsubscribeResult> get copyWith => _$AscpSessionsUnsubscribeResultCopyWithImpl<AscpSessionsUnsubscribeResult>(this as AscpSessionsUnsubscribeResult, _$identity);

  /// Serializes this AscpSessionsUnsubscribeResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSessionsUnsubscribeResult&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.unsubscribed, unsubscribed) || other.unsubscribed == unsubscribed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscriptionId,unsubscribed);

@override
String toString() {
  return 'AscpSessionsUnsubscribeResult(subscriptionId: $subscriptionId, unsubscribed: $unsubscribed)';
}


}

/// @nodoc
abstract mixin class $AscpSessionsUnsubscribeResultCopyWith<$Res>  {
  factory $AscpSessionsUnsubscribeResultCopyWith(AscpSessionsUnsubscribeResult value, $Res Function(AscpSessionsUnsubscribeResult) _then) = _$AscpSessionsUnsubscribeResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'subscription_id') String subscriptionId, bool unsubscribed
});




}
/// @nodoc
class _$AscpSessionsUnsubscribeResultCopyWithImpl<$Res>
    implements $AscpSessionsUnsubscribeResultCopyWith<$Res> {
  _$AscpSessionsUnsubscribeResultCopyWithImpl(this._self, this._then);

  final AscpSessionsUnsubscribeResult _self;
  final $Res Function(AscpSessionsUnsubscribeResult) _then;

/// Create a copy of AscpSessionsUnsubscribeResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subscriptionId = null,Object? unsubscribed = null,}) {
  return _then(_self.copyWith(
subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,unsubscribed: null == unsubscribed ? _self.unsubscribed : unsubscribed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSessionsUnsubscribeResult].
extension AscpSessionsUnsubscribeResultPatterns on AscpSessionsUnsubscribeResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSessionsUnsubscribeResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSessionsUnsubscribeResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSessionsUnsubscribeResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'subscription_id')  String subscriptionId,  bool unsubscribed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeResult() when $default != null:
return $default(_that.subscriptionId,_that.unsubscribed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'subscription_id')  String subscriptionId,  bool unsubscribed)  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeResult():
return $default(_that.subscriptionId,_that.unsubscribed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'subscription_id')  String subscriptionId,  bool unsubscribed)?  $default,) {final _that = this;
switch (_that) {
case _AscpSessionsUnsubscribeResult() when $default != null:
return $default(_that.subscriptionId,_that.unsubscribed);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSessionsUnsubscribeResult implements AscpSessionsUnsubscribeResult {
  const _AscpSessionsUnsubscribeResult({@JsonKey(name: 'subscription_id') required this.subscriptionId, required this.unsubscribed});
  factory _AscpSessionsUnsubscribeResult.fromJson(Map<String, dynamic> json) => _$AscpSessionsUnsubscribeResultFromJson(json);

@override@JsonKey(name: 'subscription_id') final  String subscriptionId;
@override final  bool unsubscribed;

/// Create a copy of AscpSessionsUnsubscribeResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionsUnsubscribeResultCopyWith<_AscpSessionsUnsubscribeResult> get copyWith => __$AscpSessionsUnsubscribeResultCopyWithImpl<_AscpSessionsUnsubscribeResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionsUnsubscribeResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSessionsUnsubscribeResult&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.unsubscribed, unsubscribed) || other.unsubscribed == unsubscribed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subscriptionId,unsubscribed);

@override
String toString() {
  return 'AscpSessionsUnsubscribeResult(subscriptionId: $subscriptionId, unsubscribed: $unsubscribed)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionsUnsubscribeResultCopyWith<$Res> implements $AscpSessionsUnsubscribeResultCopyWith<$Res> {
  factory _$AscpSessionsUnsubscribeResultCopyWith(_AscpSessionsUnsubscribeResult value, $Res Function(_AscpSessionsUnsubscribeResult) _then) = __$AscpSessionsUnsubscribeResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'subscription_id') String subscriptionId, bool unsubscribed
});




}
/// @nodoc
class __$AscpSessionsUnsubscribeResultCopyWithImpl<$Res>
    implements _$AscpSessionsUnsubscribeResultCopyWith<$Res> {
  __$AscpSessionsUnsubscribeResultCopyWithImpl(this._self, this._then);

  final _AscpSessionsUnsubscribeResult _self;
  final $Res Function(_AscpSessionsUnsubscribeResult) _then;

/// Create a copy of AscpSessionsUnsubscribeResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subscriptionId = null,Object? unsubscribed = null,}) {
  return _then(_AscpSessionsUnsubscribeResult(
subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,unsubscribed: null == unsubscribed ? _self.unsubscribed : unsubscribed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AscpApprovalsListParams {

@JsonKey(name: 'session_id') String? get sessionId; String? get status; int? get limit; String? get cursor;
/// Create a copy of AscpApprovalsListParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpApprovalsListParamsCopyWith<AscpApprovalsListParams> get copyWith => _$AscpApprovalsListParamsCopyWithImpl<AscpApprovalsListParams>(this as AscpApprovalsListParams, _$identity);

  /// Serializes this AscpApprovalsListParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpApprovalsListParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.cursor, cursor) || other.cursor == cursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,status,limit,cursor);

@override
String toString() {
  return 'AscpApprovalsListParams(sessionId: $sessionId, status: $status, limit: $limit, cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class $AscpApprovalsListParamsCopyWith<$Res>  {
  factory $AscpApprovalsListParamsCopyWith(AscpApprovalsListParams value, $Res Function(AscpApprovalsListParams) _then) = _$AscpApprovalsListParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String? sessionId, String? status, int? limit, String? cursor
});




}
/// @nodoc
class _$AscpApprovalsListParamsCopyWithImpl<$Res>
    implements $AscpApprovalsListParamsCopyWith<$Res> {
  _$AscpApprovalsListParamsCopyWithImpl(this._self, this._then);

  final AscpApprovalsListParams _self;
  final $Res Function(AscpApprovalsListParams) _then;

/// Create a copy of AscpApprovalsListParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = freezed,Object? status = freezed,Object? limit = freezed,Object? cursor = freezed,}) {
  return _then(_self.copyWith(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpApprovalsListParams].
extension AscpApprovalsListParamsPatterns on AscpApprovalsListParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpApprovalsListParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpApprovalsListParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpApprovalsListParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalsListParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpApprovalsListParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalsListParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String? sessionId,  String? status,  int? limit,  String? cursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpApprovalsListParams() when $default != null:
return $default(_that.sessionId,_that.status,_that.limit,_that.cursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String? sessionId,  String? status,  int? limit,  String? cursor)  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalsListParams():
return $default(_that.sessionId,_that.status,_that.limit,_that.cursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String? sessionId,  String? status,  int? limit,  String? cursor)?  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalsListParams() when $default != null:
return $default(_that.sessionId,_that.status,_that.limit,_that.cursor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpApprovalsListParams implements AscpApprovalsListParams {
  const _AscpApprovalsListParams({@JsonKey(name: 'session_id') this.sessionId, this.status, this.limit, this.cursor});
  factory _AscpApprovalsListParams.fromJson(Map<String, dynamic> json) => _$AscpApprovalsListParamsFromJson(json);

@override@JsonKey(name: 'session_id') final  String? sessionId;
@override final  String? status;
@override final  int? limit;
@override final  String? cursor;

/// Create a copy of AscpApprovalsListParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpApprovalsListParamsCopyWith<_AscpApprovalsListParams> get copyWith => __$AscpApprovalsListParamsCopyWithImpl<_AscpApprovalsListParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpApprovalsListParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpApprovalsListParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.cursor, cursor) || other.cursor == cursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,status,limit,cursor);

@override
String toString() {
  return 'AscpApprovalsListParams(sessionId: $sessionId, status: $status, limit: $limit, cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class _$AscpApprovalsListParamsCopyWith<$Res> implements $AscpApprovalsListParamsCopyWith<$Res> {
  factory _$AscpApprovalsListParamsCopyWith(_AscpApprovalsListParams value, $Res Function(_AscpApprovalsListParams) _then) = __$AscpApprovalsListParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String? sessionId, String? status, int? limit, String? cursor
});




}
/// @nodoc
class __$AscpApprovalsListParamsCopyWithImpl<$Res>
    implements _$AscpApprovalsListParamsCopyWith<$Res> {
  __$AscpApprovalsListParamsCopyWithImpl(this._self, this._then);

  final _AscpApprovalsListParams _self;
  final $Res Function(_AscpApprovalsListParams) _then;

/// Create a copy of AscpApprovalsListParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = freezed,Object? status = freezed,Object? limit = freezed,Object? cursor = freezed,}) {
  return _then(_AscpApprovalsListParams(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpApprovalsListResult {

 List<AscpApprovalRequest> get approvals;@JsonKey(name: 'next_cursor') String? get nextCursor;
/// Create a copy of AscpApprovalsListResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpApprovalsListResultCopyWith<AscpApprovalsListResult> get copyWith => _$AscpApprovalsListResultCopyWithImpl<AscpApprovalsListResult>(this as AscpApprovalsListResult, _$identity);

  /// Serializes this AscpApprovalsListResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpApprovalsListResult&&const DeepCollectionEquality().equals(other.approvals, approvals)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(approvals),nextCursor);

@override
String toString() {
  return 'AscpApprovalsListResult(approvals: $approvals, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class $AscpApprovalsListResultCopyWith<$Res>  {
  factory $AscpApprovalsListResultCopyWith(AscpApprovalsListResult value, $Res Function(AscpApprovalsListResult) _then) = _$AscpApprovalsListResultCopyWithImpl;
@useResult
$Res call({
 List<AscpApprovalRequest> approvals,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class _$AscpApprovalsListResultCopyWithImpl<$Res>
    implements $AscpApprovalsListResultCopyWith<$Res> {
  _$AscpApprovalsListResultCopyWithImpl(this._self, this._then);

  final AscpApprovalsListResult _self;
  final $Res Function(AscpApprovalsListResult) _then;

/// Create a copy of AscpApprovalsListResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? approvals = null,Object? nextCursor = freezed,}) {
  return _then(_self.copyWith(
approvals: null == approvals ? _self.approvals : approvals // ignore: cast_nullable_to_non_nullable
as List<AscpApprovalRequest>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpApprovalsListResult].
extension AscpApprovalsListResultPatterns on AscpApprovalsListResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpApprovalsListResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpApprovalsListResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpApprovalsListResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalsListResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpApprovalsListResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalsListResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AscpApprovalRequest> approvals, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpApprovalsListResult() when $default != null:
return $default(_that.approvals,_that.nextCursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AscpApprovalRequest> approvals, @JsonKey(name: 'next_cursor')  String? nextCursor)  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalsListResult():
return $default(_that.approvals,_that.nextCursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AscpApprovalRequest> approvals, @JsonKey(name: 'next_cursor')  String? nextCursor)?  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalsListResult() when $default != null:
return $default(_that.approvals,_that.nextCursor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpApprovalsListResult implements AscpApprovalsListResult {
  const _AscpApprovalsListResult({required final  List<AscpApprovalRequest> approvals, @JsonKey(name: 'next_cursor') this.nextCursor}): _approvals = approvals;
  factory _AscpApprovalsListResult.fromJson(Map<String, dynamic> json) => _$AscpApprovalsListResultFromJson(json);

 final  List<AscpApprovalRequest> _approvals;
@override List<AscpApprovalRequest> get approvals {
  if (_approvals is EqualUnmodifiableListView) return _approvals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_approvals);
}

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;

/// Create a copy of AscpApprovalsListResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpApprovalsListResultCopyWith<_AscpApprovalsListResult> get copyWith => __$AscpApprovalsListResultCopyWithImpl<_AscpApprovalsListResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpApprovalsListResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpApprovalsListResult&&const DeepCollectionEquality().equals(other._approvals, _approvals)&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_approvals),nextCursor);

@override
String toString() {
  return 'AscpApprovalsListResult(approvals: $approvals, nextCursor: $nextCursor)';
}


}

/// @nodoc
abstract mixin class _$AscpApprovalsListResultCopyWith<$Res> implements $AscpApprovalsListResultCopyWith<$Res> {
  factory _$AscpApprovalsListResultCopyWith(_AscpApprovalsListResult value, $Res Function(_AscpApprovalsListResult) _then) = __$AscpApprovalsListResultCopyWithImpl;
@override @useResult
$Res call({
 List<AscpApprovalRequest> approvals,@JsonKey(name: 'next_cursor') String? nextCursor
});




}
/// @nodoc
class __$AscpApprovalsListResultCopyWithImpl<$Res>
    implements _$AscpApprovalsListResultCopyWith<$Res> {
  __$AscpApprovalsListResultCopyWithImpl(this._self, this._then);

  final _AscpApprovalsListResult _self;
  final $Res Function(_AscpApprovalsListResult) _then;

/// Create a copy of AscpApprovalsListResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? approvals = null,Object? nextCursor = freezed,}) {
  return _then(_AscpApprovalsListResult(
approvals: null == approvals ? _self._approvals : approvals // ignore: cast_nullable_to_non_nullable
as List<AscpApprovalRequest>,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpApprovalsRespondParams {

@JsonKey(name: 'approval_id') String get approvalId; String get decision; String? get note;
/// Create a copy of AscpApprovalsRespondParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpApprovalsRespondParamsCopyWith<AscpApprovalsRespondParams> get copyWith => _$AscpApprovalsRespondParamsCopyWithImpl<AscpApprovalsRespondParams>(this as AscpApprovalsRespondParams, _$identity);

  /// Serializes this AscpApprovalsRespondParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpApprovalsRespondParams&&(identical(other.approvalId, approvalId) || other.approvalId == approvalId)&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,approvalId,decision,note);

@override
String toString() {
  return 'AscpApprovalsRespondParams(approvalId: $approvalId, decision: $decision, note: $note)';
}


}

/// @nodoc
abstract mixin class $AscpApprovalsRespondParamsCopyWith<$Res>  {
  factory $AscpApprovalsRespondParamsCopyWith(AscpApprovalsRespondParams value, $Res Function(AscpApprovalsRespondParams) _then) = _$AscpApprovalsRespondParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'approval_id') String approvalId, String decision, String? note
});




}
/// @nodoc
class _$AscpApprovalsRespondParamsCopyWithImpl<$Res>
    implements $AscpApprovalsRespondParamsCopyWith<$Res> {
  _$AscpApprovalsRespondParamsCopyWithImpl(this._self, this._then);

  final AscpApprovalsRespondParams _self;
  final $Res Function(AscpApprovalsRespondParams) _then;

/// Create a copy of AscpApprovalsRespondParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? approvalId = null,Object? decision = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
approvalId: null == approvalId ? _self.approvalId : approvalId // ignore: cast_nullable_to_non_nullable
as String,decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpApprovalsRespondParams].
extension AscpApprovalsRespondParamsPatterns on AscpApprovalsRespondParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpApprovalsRespondParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpApprovalsRespondParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpApprovalsRespondParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalsRespondParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpApprovalsRespondParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalsRespondParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'approval_id')  String approvalId,  String decision,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpApprovalsRespondParams() when $default != null:
return $default(_that.approvalId,_that.decision,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'approval_id')  String approvalId,  String decision,  String? note)  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalsRespondParams():
return $default(_that.approvalId,_that.decision,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'approval_id')  String approvalId,  String decision,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalsRespondParams() when $default != null:
return $default(_that.approvalId,_that.decision,_that.note);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpApprovalsRespondParams implements AscpApprovalsRespondParams {
  const _AscpApprovalsRespondParams({@JsonKey(name: 'approval_id') required this.approvalId, required this.decision, this.note});
  factory _AscpApprovalsRespondParams.fromJson(Map<String, dynamic> json) => _$AscpApprovalsRespondParamsFromJson(json);

@override@JsonKey(name: 'approval_id') final  String approvalId;
@override final  String decision;
@override final  String? note;

/// Create a copy of AscpApprovalsRespondParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpApprovalsRespondParamsCopyWith<_AscpApprovalsRespondParams> get copyWith => __$AscpApprovalsRespondParamsCopyWithImpl<_AscpApprovalsRespondParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpApprovalsRespondParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpApprovalsRespondParams&&(identical(other.approvalId, approvalId) || other.approvalId == approvalId)&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,approvalId,decision,note);

@override
String toString() {
  return 'AscpApprovalsRespondParams(approvalId: $approvalId, decision: $decision, note: $note)';
}


}

/// @nodoc
abstract mixin class _$AscpApprovalsRespondParamsCopyWith<$Res> implements $AscpApprovalsRespondParamsCopyWith<$Res> {
  factory _$AscpApprovalsRespondParamsCopyWith(_AscpApprovalsRespondParams value, $Res Function(_AscpApprovalsRespondParams) _then) = __$AscpApprovalsRespondParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'approval_id') String approvalId, String decision, String? note
});




}
/// @nodoc
class __$AscpApprovalsRespondParamsCopyWithImpl<$Res>
    implements _$AscpApprovalsRespondParamsCopyWith<$Res> {
  __$AscpApprovalsRespondParamsCopyWithImpl(this._self, this._then);

  final _AscpApprovalsRespondParams _self;
  final $Res Function(_AscpApprovalsRespondParams) _then;

/// Create a copy of AscpApprovalsRespondParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? approvalId = null,Object? decision = null,Object? note = freezed,}) {
  return _then(_AscpApprovalsRespondParams(
approvalId: null == approvalId ? _self.approvalId : approvalId // ignore: cast_nullable_to_non_nullable
as String,decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpApprovalsRespondResult {

@JsonKey(name: 'approval_id') String get approvalId; String get status;
/// Create a copy of AscpApprovalsRespondResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpApprovalsRespondResultCopyWith<AscpApprovalsRespondResult> get copyWith => _$AscpApprovalsRespondResultCopyWithImpl<AscpApprovalsRespondResult>(this as AscpApprovalsRespondResult, _$identity);

  /// Serializes this AscpApprovalsRespondResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpApprovalsRespondResult&&(identical(other.approvalId, approvalId) || other.approvalId == approvalId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,approvalId,status);

@override
String toString() {
  return 'AscpApprovalsRespondResult(approvalId: $approvalId, status: $status)';
}


}

/// @nodoc
abstract mixin class $AscpApprovalsRespondResultCopyWith<$Res>  {
  factory $AscpApprovalsRespondResultCopyWith(AscpApprovalsRespondResult value, $Res Function(AscpApprovalsRespondResult) _then) = _$AscpApprovalsRespondResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'approval_id') String approvalId, String status
});




}
/// @nodoc
class _$AscpApprovalsRespondResultCopyWithImpl<$Res>
    implements $AscpApprovalsRespondResultCopyWith<$Res> {
  _$AscpApprovalsRespondResultCopyWithImpl(this._self, this._then);

  final AscpApprovalsRespondResult _self;
  final $Res Function(AscpApprovalsRespondResult) _then;

/// Create a copy of AscpApprovalsRespondResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? approvalId = null,Object? status = null,}) {
  return _then(_self.copyWith(
approvalId: null == approvalId ? _self.approvalId : approvalId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpApprovalsRespondResult].
extension AscpApprovalsRespondResultPatterns on AscpApprovalsRespondResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpApprovalsRespondResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpApprovalsRespondResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpApprovalsRespondResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalsRespondResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpApprovalsRespondResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalsRespondResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'approval_id')  String approvalId,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpApprovalsRespondResult() when $default != null:
return $default(_that.approvalId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'approval_id')  String approvalId,  String status)  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalsRespondResult():
return $default(_that.approvalId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'approval_id')  String approvalId,  String status)?  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalsRespondResult() when $default != null:
return $default(_that.approvalId,_that.status);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpApprovalsRespondResult implements AscpApprovalsRespondResult {
  const _AscpApprovalsRespondResult({@JsonKey(name: 'approval_id') required this.approvalId, required this.status});
  factory _AscpApprovalsRespondResult.fromJson(Map<String, dynamic> json) => _$AscpApprovalsRespondResultFromJson(json);

@override@JsonKey(name: 'approval_id') final  String approvalId;
@override final  String status;

/// Create a copy of AscpApprovalsRespondResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpApprovalsRespondResultCopyWith<_AscpApprovalsRespondResult> get copyWith => __$AscpApprovalsRespondResultCopyWithImpl<_AscpApprovalsRespondResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpApprovalsRespondResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpApprovalsRespondResult&&(identical(other.approvalId, approvalId) || other.approvalId == approvalId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,approvalId,status);

@override
String toString() {
  return 'AscpApprovalsRespondResult(approvalId: $approvalId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AscpApprovalsRespondResultCopyWith<$Res> implements $AscpApprovalsRespondResultCopyWith<$Res> {
  factory _$AscpApprovalsRespondResultCopyWith(_AscpApprovalsRespondResult value, $Res Function(_AscpApprovalsRespondResult) _then) = __$AscpApprovalsRespondResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'approval_id') String approvalId, String status
});




}
/// @nodoc
class __$AscpApprovalsRespondResultCopyWithImpl<$Res>
    implements _$AscpApprovalsRespondResultCopyWith<$Res> {
  __$AscpApprovalsRespondResultCopyWithImpl(this._self, this._then);

  final _AscpApprovalsRespondResult _self;
  final $Res Function(_AscpApprovalsRespondResult) _then;

/// Create a copy of AscpApprovalsRespondResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? approvalId = null,Object? status = null,}) {
  return _then(_AscpApprovalsRespondResult(
approvalId: null == approvalId ? _self.approvalId : approvalId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AscpArtifactsListParams {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'run_id') String? get runId; String? get kind;
/// Create a copy of AscpArtifactsListParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpArtifactsListParamsCopyWith<AscpArtifactsListParams> get copyWith => _$AscpArtifactsListParamsCopyWithImpl<AscpArtifactsListParams>(this as AscpArtifactsListParams, _$identity);

  /// Serializes this AscpArtifactsListParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpArtifactsListParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,runId,kind);

@override
String toString() {
  return 'AscpArtifactsListParams(sessionId: $sessionId, runId: $runId, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $AscpArtifactsListParamsCopyWith<$Res>  {
  factory $AscpArtifactsListParamsCopyWith(AscpArtifactsListParams value, $Res Function(AscpArtifactsListParams) _then) = _$AscpArtifactsListParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, String? kind
});




}
/// @nodoc
class _$AscpArtifactsListParamsCopyWithImpl<$Res>
    implements $AscpArtifactsListParamsCopyWith<$Res> {
  _$AscpArtifactsListParamsCopyWithImpl(this._self, this._then);

  final AscpArtifactsListParams _self;
  final $Res Function(AscpArtifactsListParams) _then;

/// Create a copy of AscpArtifactsListParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? runId = freezed,Object? kind = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpArtifactsListParams].
extension AscpArtifactsListParamsPatterns on AscpArtifactsListParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpArtifactsListParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpArtifactsListParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpArtifactsListParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpArtifactsListParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpArtifactsListParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpArtifactsListParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  String? kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpArtifactsListParams() when $default != null:
return $default(_that.sessionId,_that.runId,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  String? kind)  $default,) {final _that = this;
switch (_that) {
case _AscpArtifactsListParams():
return $default(_that.sessionId,_that.runId,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  String? kind)?  $default,) {final _that = this;
switch (_that) {
case _AscpArtifactsListParams() when $default != null:
return $default(_that.sessionId,_that.runId,_that.kind);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpArtifactsListParams implements AscpArtifactsListParams {
  const _AscpArtifactsListParams({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'run_id') this.runId, this.kind});
  factory _AscpArtifactsListParams.fromJson(Map<String, dynamic> json) => _$AscpArtifactsListParamsFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'run_id') final  String? runId;
@override final  String? kind;

/// Create a copy of AscpArtifactsListParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpArtifactsListParamsCopyWith<_AscpArtifactsListParams> get copyWith => __$AscpArtifactsListParamsCopyWithImpl<_AscpArtifactsListParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpArtifactsListParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpArtifactsListParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,runId,kind);

@override
String toString() {
  return 'AscpArtifactsListParams(sessionId: $sessionId, runId: $runId, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$AscpArtifactsListParamsCopyWith<$Res> implements $AscpArtifactsListParamsCopyWith<$Res> {
  factory _$AscpArtifactsListParamsCopyWith(_AscpArtifactsListParams value, $Res Function(_AscpArtifactsListParams) _then) = __$AscpArtifactsListParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, String? kind
});




}
/// @nodoc
class __$AscpArtifactsListParamsCopyWithImpl<$Res>
    implements _$AscpArtifactsListParamsCopyWith<$Res> {
  __$AscpArtifactsListParamsCopyWithImpl(this._self, this._then);

  final _AscpArtifactsListParams _self;
  final $Res Function(_AscpArtifactsListParams) _then;

/// Create a copy of AscpArtifactsListParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? runId = freezed,Object? kind = freezed,}) {
  return _then(_AscpArtifactsListParams(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpArtifactsListResult {

 List<AscpArtifact> get artifacts;
/// Create a copy of AscpArtifactsListResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpArtifactsListResultCopyWith<AscpArtifactsListResult> get copyWith => _$AscpArtifactsListResultCopyWithImpl<AscpArtifactsListResult>(this as AscpArtifactsListResult, _$identity);

  /// Serializes this AscpArtifactsListResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpArtifactsListResult&&const DeepCollectionEquality().equals(other.artifacts, artifacts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(artifacts));

@override
String toString() {
  return 'AscpArtifactsListResult(artifacts: $artifacts)';
}


}

/// @nodoc
abstract mixin class $AscpArtifactsListResultCopyWith<$Res>  {
  factory $AscpArtifactsListResultCopyWith(AscpArtifactsListResult value, $Res Function(AscpArtifactsListResult) _then) = _$AscpArtifactsListResultCopyWithImpl;
@useResult
$Res call({
 List<AscpArtifact> artifacts
});




}
/// @nodoc
class _$AscpArtifactsListResultCopyWithImpl<$Res>
    implements $AscpArtifactsListResultCopyWith<$Res> {
  _$AscpArtifactsListResultCopyWithImpl(this._self, this._then);

  final AscpArtifactsListResult _self;
  final $Res Function(AscpArtifactsListResult) _then;

/// Create a copy of AscpArtifactsListResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? artifacts = null,}) {
  return _then(_self.copyWith(
artifacts: null == artifacts ? _self.artifacts : artifacts // ignore: cast_nullable_to_non_nullable
as List<AscpArtifact>,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpArtifactsListResult].
extension AscpArtifactsListResultPatterns on AscpArtifactsListResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpArtifactsListResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpArtifactsListResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpArtifactsListResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpArtifactsListResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpArtifactsListResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpArtifactsListResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AscpArtifact> artifacts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpArtifactsListResult() when $default != null:
return $default(_that.artifacts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AscpArtifact> artifacts)  $default,) {final _that = this;
switch (_that) {
case _AscpArtifactsListResult():
return $default(_that.artifacts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AscpArtifact> artifacts)?  $default,) {final _that = this;
switch (_that) {
case _AscpArtifactsListResult() when $default != null:
return $default(_that.artifacts);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpArtifactsListResult implements AscpArtifactsListResult {
  const _AscpArtifactsListResult({required final  List<AscpArtifact> artifacts}): _artifacts = artifacts;
  factory _AscpArtifactsListResult.fromJson(Map<String, dynamic> json) => _$AscpArtifactsListResultFromJson(json);

 final  List<AscpArtifact> _artifacts;
@override List<AscpArtifact> get artifacts {
  if (_artifacts is EqualUnmodifiableListView) return _artifacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_artifacts);
}


/// Create a copy of AscpArtifactsListResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpArtifactsListResultCopyWith<_AscpArtifactsListResult> get copyWith => __$AscpArtifactsListResultCopyWithImpl<_AscpArtifactsListResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpArtifactsListResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpArtifactsListResult&&const DeepCollectionEquality().equals(other._artifacts, _artifacts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_artifacts));

@override
String toString() {
  return 'AscpArtifactsListResult(artifacts: $artifacts)';
}


}

/// @nodoc
abstract mixin class _$AscpArtifactsListResultCopyWith<$Res> implements $AscpArtifactsListResultCopyWith<$Res> {
  factory _$AscpArtifactsListResultCopyWith(_AscpArtifactsListResult value, $Res Function(_AscpArtifactsListResult) _then) = __$AscpArtifactsListResultCopyWithImpl;
@override @useResult
$Res call({
 List<AscpArtifact> artifacts
});




}
/// @nodoc
class __$AscpArtifactsListResultCopyWithImpl<$Res>
    implements _$AscpArtifactsListResultCopyWith<$Res> {
  __$AscpArtifactsListResultCopyWithImpl(this._self, this._then);

  final _AscpArtifactsListResult _self;
  final $Res Function(_AscpArtifactsListResult) _then;

/// Create a copy of AscpArtifactsListResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? artifacts = null,}) {
  return _then(_AscpArtifactsListResult(
artifacts: null == artifacts ? _self._artifacts : artifacts // ignore: cast_nullable_to_non_nullable
as List<AscpArtifact>,
  ));
}


}


/// @nodoc
mixin _$AscpArtifactsGetParams {

@JsonKey(name: 'artifact_id') String get artifactId;
/// Create a copy of AscpArtifactsGetParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpArtifactsGetParamsCopyWith<AscpArtifactsGetParams> get copyWith => _$AscpArtifactsGetParamsCopyWithImpl<AscpArtifactsGetParams>(this as AscpArtifactsGetParams, _$identity);

  /// Serializes this AscpArtifactsGetParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpArtifactsGetParams&&(identical(other.artifactId, artifactId) || other.artifactId == artifactId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,artifactId);

@override
String toString() {
  return 'AscpArtifactsGetParams(artifactId: $artifactId)';
}


}

/// @nodoc
abstract mixin class $AscpArtifactsGetParamsCopyWith<$Res>  {
  factory $AscpArtifactsGetParamsCopyWith(AscpArtifactsGetParams value, $Res Function(AscpArtifactsGetParams) _then) = _$AscpArtifactsGetParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'artifact_id') String artifactId
});




}
/// @nodoc
class _$AscpArtifactsGetParamsCopyWithImpl<$Res>
    implements $AscpArtifactsGetParamsCopyWith<$Res> {
  _$AscpArtifactsGetParamsCopyWithImpl(this._self, this._then);

  final AscpArtifactsGetParams _self;
  final $Res Function(AscpArtifactsGetParams) _then;

/// Create a copy of AscpArtifactsGetParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? artifactId = null,}) {
  return _then(_self.copyWith(
artifactId: null == artifactId ? _self.artifactId : artifactId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpArtifactsGetParams].
extension AscpArtifactsGetParamsPatterns on AscpArtifactsGetParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpArtifactsGetParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpArtifactsGetParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpArtifactsGetParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpArtifactsGetParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpArtifactsGetParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpArtifactsGetParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'artifact_id')  String artifactId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpArtifactsGetParams() when $default != null:
return $default(_that.artifactId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'artifact_id')  String artifactId)  $default,) {final _that = this;
switch (_that) {
case _AscpArtifactsGetParams():
return $default(_that.artifactId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'artifact_id')  String artifactId)?  $default,) {final _that = this;
switch (_that) {
case _AscpArtifactsGetParams() when $default != null:
return $default(_that.artifactId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpArtifactsGetParams implements AscpArtifactsGetParams {
  const _AscpArtifactsGetParams({@JsonKey(name: 'artifact_id') required this.artifactId});
  factory _AscpArtifactsGetParams.fromJson(Map<String, dynamic> json) => _$AscpArtifactsGetParamsFromJson(json);

@override@JsonKey(name: 'artifact_id') final  String artifactId;

/// Create a copy of AscpArtifactsGetParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpArtifactsGetParamsCopyWith<_AscpArtifactsGetParams> get copyWith => __$AscpArtifactsGetParamsCopyWithImpl<_AscpArtifactsGetParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpArtifactsGetParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpArtifactsGetParams&&(identical(other.artifactId, artifactId) || other.artifactId == artifactId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,artifactId);

@override
String toString() {
  return 'AscpArtifactsGetParams(artifactId: $artifactId)';
}


}

/// @nodoc
abstract mixin class _$AscpArtifactsGetParamsCopyWith<$Res> implements $AscpArtifactsGetParamsCopyWith<$Res> {
  factory _$AscpArtifactsGetParamsCopyWith(_AscpArtifactsGetParams value, $Res Function(_AscpArtifactsGetParams) _then) = __$AscpArtifactsGetParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'artifact_id') String artifactId
});




}
/// @nodoc
class __$AscpArtifactsGetParamsCopyWithImpl<$Res>
    implements _$AscpArtifactsGetParamsCopyWith<$Res> {
  __$AscpArtifactsGetParamsCopyWithImpl(this._self, this._then);

  final _AscpArtifactsGetParams _self;
  final $Res Function(_AscpArtifactsGetParams) _then;

/// Create a copy of AscpArtifactsGetParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? artifactId = null,}) {
  return _then(_AscpArtifactsGetParams(
artifactId: null == artifactId ? _self.artifactId : artifactId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AscpArtifactsGetResult {

 AscpArtifact get artifact;
/// Create a copy of AscpArtifactsGetResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpArtifactsGetResultCopyWith<AscpArtifactsGetResult> get copyWith => _$AscpArtifactsGetResultCopyWithImpl<AscpArtifactsGetResult>(this as AscpArtifactsGetResult, _$identity);

  /// Serializes this AscpArtifactsGetResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpArtifactsGetResult&&(identical(other.artifact, artifact) || other.artifact == artifact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,artifact);

@override
String toString() {
  return 'AscpArtifactsGetResult(artifact: $artifact)';
}


}

/// @nodoc
abstract mixin class $AscpArtifactsGetResultCopyWith<$Res>  {
  factory $AscpArtifactsGetResultCopyWith(AscpArtifactsGetResult value, $Res Function(AscpArtifactsGetResult) _then) = _$AscpArtifactsGetResultCopyWithImpl;
@useResult
$Res call({
 AscpArtifact artifact
});


$AscpArtifactCopyWith<$Res> get artifact;

}
/// @nodoc
class _$AscpArtifactsGetResultCopyWithImpl<$Res>
    implements $AscpArtifactsGetResultCopyWith<$Res> {
  _$AscpArtifactsGetResultCopyWithImpl(this._self, this._then);

  final AscpArtifactsGetResult _self;
  final $Res Function(AscpArtifactsGetResult) _then;

/// Create a copy of AscpArtifactsGetResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? artifact = null,}) {
  return _then(_self.copyWith(
artifact: null == artifact ? _self.artifact : artifact // ignore: cast_nullable_to_non_nullable
as AscpArtifact,
  ));
}
/// Create a copy of AscpArtifactsGetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpArtifactCopyWith<$Res> get artifact {
  
  return $AscpArtifactCopyWith<$Res>(_self.artifact, (value) {
    return _then(_self.copyWith(artifact: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpArtifactsGetResult].
extension AscpArtifactsGetResultPatterns on AscpArtifactsGetResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpArtifactsGetResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpArtifactsGetResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpArtifactsGetResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpArtifactsGetResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpArtifactsGetResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpArtifactsGetResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AscpArtifact artifact)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpArtifactsGetResult() when $default != null:
return $default(_that.artifact);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AscpArtifact artifact)  $default,) {final _that = this;
switch (_that) {
case _AscpArtifactsGetResult():
return $default(_that.artifact);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AscpArtifact artifact)?  $default,) {final _that = this;
switch (_that) {
case _AscpArtifactsGetResult() when $default != null:
return $default(_that.artifact);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpArtifactsGetResult implements AscpArtifactsGetResult {
  const _AscpArtifactsGetResult({required this.artifact});
  factory _AscpArtifactsGetResult.fromJson(Map<String, dynamic> json) => _$AscpArtifactsGetResultFromJson(json);

@override final  AscpArtifact artifact;

/// Create a copy of AscpArtifactsGetResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpArtifactsGetResultCopyWith<_AscpArtifactsGetResult> get copyWith => __$AscpArtifactsGetResultCopyWithImpl<_AscpArtifactsGetResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpArtifactsGetResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpArtifactsGetResult&&(identical(other.artifact, artifact) || other.artifact == artifact));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,artifact);

@override
String toString() {
  return 'AscpArtifactsGetResult(artifact: $artifact)';
}


}

/// @nodoc
abstract mixin class _$AscpArtifactsGetResultCopyWith<$Res> implements $AscpArtifactsGetResultCopyWith<$Res> {
  factory _$AscpArtifactsGetResultCopyWith(_AscpArtifactsGetResult value, $Res Function(_AscpArtifactsGetResult) _then) = __$AscpArtifactsGetResultCopyWithImpl;
@override @useResult
$Res call({
 AscpArtifact artifact
});


@override $AscpArtifactCopyWith<$Res> get artifact;

}
/// @nodoc
class __$AscpArtifactsGetResultCopyWithImpl<$Res>
    implements _$AscpArtifactsGetResultCopyWith<$Res> {
  __$AscpArtifactsGetResultCopyWithImpl(this._self, this._then);

  final _AscpArtifactsGetResult _self;
  final $Res Function(_AscpArtifactsGetResult) _then;

/// Create a copy of AscpArtifactsGetResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? artifact = null,}) {
  return _then(_AscpArtifactsGetResult(
artifact: null == artifact ? _self.artifact : artifact // ignore: cast_nullable_to_non_nullable
as AscpArtifact,
  ));
}

/// Create a copy of AscpArtifactsGetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpArtifactCopyWith<$Res> get artifact {
  
  return $AscpArtifactCopyWith<$Res>(_self.artifact, (value) {
    return _then(_self.copyWith(artifact: value));
  });
}
}


/// @nodoc
mixin _$AscpDiffsGetParams {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'run_id') String get runId;
/// Create a copy of AscpDiffsGetParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpDiffsGetParamsCopyWith<AscpDiffsGetParams> get copyWith => _$AscpDiffsGetParamsCopyWithImpl<AscpDiffsGetParams>(this as AscpDiffsGetParams, _$identity);

  /// Serializes this AscpDiffsGetParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpDiffsGetParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,runId);

@override
String toString() {
  return 'AscpDiffsGetParams(sessionId: $sessionId, runId: $runId)';
}


}

/// @nodoc
abstract mixin class $AscpDiffsGetParamsCopyWith<$Res>  {
  factory $AscpDiffsGetParamsCopyWith(AscpDiffsGetParams value, $Res Function(AscpDiffsGetParams) _then) = _$AscpDiffsGetParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String runId
});




}
/// @nodoc
class _$AscpDiffsGetParamsCopyWithImpl<$Res>
    implements $AscpDiffsGetParamsCopyWith<$Res> {
  _$AscpDiffsGetParamsCopyWithImpl(this._self, this._then);

  final AscpDiffsGetParams _self;
  final $Res Function(AscpDiffsGetParams) _then;

/// Create a copy of AscpDiffsGetParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? runId = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpDiffsGetParams].
extension AscpDiffsGetParamsPatterns on AscpDiffsGetParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpDiffsGetParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpDiffsGetParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpDiffsGetParams value)  $default,){
final _that = this;
switch (_that) {
case _AscpDiffsGetParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpDiffsGetParams value)?  $default,){
final _that = this;
switch (_that) {
case _AscpDiffsGetParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String runId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpDiffsGetParams() when $default != null:
return $default(_that.sessionId,_that.runId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String runId)  $default,) {final _that = this;
switch (_that) {
case _AscpDiffsGetParams():
return $default(_that.sessionId,_that.runId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String runId)?  $default,) {final _that = this;
switch (_that) {
case _AscpDiffsGetParams() when $default != null:
return $default(_that.sessionId,_that.runId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _AscpDiffsGetParams implements AscpDiffsGetParams {
  const _AscpDiffsGetParams({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'run_id') required this.runId});
  factory _AscpDiffsGetParams.fromJson(Map<String, dynamic> json) => _$AscpDiffsGetParamsFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'run_id') final  String runId;

/// Create a copy of AscpDiffsGetParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpDiffsGetParamsCopyWith<_AscpDiffsGetParams> get copyWith => __$AscpDiffsGetParamsCopyWithImpl<_AscpDiffsGetParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpDiffsGetParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpDiffsGetParams&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,runId);

@override
String toString() {
  return 'AscpDiffsGetParams(sessionId: $sessionId, runId: $runId)';
}


}

/// @nodoc
abstract mixin class _$AscpDiffsGetParamsCopyWith<$Res> implements $AscpDiffsGetParamsCopyWith<$Res> {
  factory _$AscpDiffsGetParamsCopyWith(_AscpDiffsGetParams value, $Res Function(_AscpDiffsGetParams) _then) = __$AscpDiffsGetParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String runId
});




}
/// @nodoc
class __$AscpDiffsGetParamsCopyWithImpl<$Res>
    implements _$AscpDiffsGetParamsCopyWith<$Res> {
  __$AscpDiffsGetParamsCopyWithImpl(this._self, this._then);

  final _AscpDiffsGetParams _self;
  final $Res Function(_AscpDiffsGetParams) _then;

/// Create a copy of AscpDiffsGetParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? runId = null,}) {
  return _then(_AscpDiffsGetParams(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AscpDiffsGetResult {

 AscpDiffSummary get diff;
/// Create a copy of AscpDiffsGetResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpDiffsGetResultCopyWith<AscpDiffsGetResult> get copyWith => _$AscpDiffsGetResultCopyWithImpl<AscpDiffsGetResult>(this as AscpDiffsGetResult, _$identity);

  /// Serializes this AscpDiffsGetResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpDiffsGetResult&&(identical(other.diff, diff) || other.diff == diff));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,diff);

@override
String toString() {
  return 'AscpDiffsGetResult(diff: $diff)';
}


}

/// @nodoc
abstract mixin class $AscpDiffsGetResultCopyWith<$Res>  {
  factory $AscpDiffsGetResultCopyWith(AscpDiffsGetResult value, $Res Function(AscpDiffsGetResult) _then) = _$AscpDiffsGetResultCopyWithImpl;
@useResult
$Res call({
 AscpDiffSummary diff
});


$AscpDiffSummaryCopyWith<$Res> get diff;

}
/// @nodoc
class _$AscpDiffsGetResultCopyWithImpl<$Res>
    implements $AscpDiffsGetResultCopyWith<$Res> {
  _$AscpDiffsGetResultCopyWithImpl(this._self, this._then);

  final AscpDiffsGetResult _self;
  final $Res Function(AscpDiffsGetResult) _then;

/// Create a copy of AscpDiffsGetResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diff = null,}) {
  return _then(_self.copyWith(
diff: null == diff ? _self.diff : diff // ignore: cast_nullable_to_non_nullable
as AscpDiffSummary,
  ));
}
/// Create a copy of AscpDiffsGetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpDiffSummaryCopyWith<$Res> get diff {
  
  return $AscpDiffSummaryCopyWith<$Res>(_self.diff, (value) {
    return _then(_self.copyWith(diff: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpDiffsGetResult].
extension AscpDiffsGetResultPatterns on AscpDiffsGetResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpDiffsGetResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpDiffsGetResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpDiffsGetResult value)  $default,){
final _that = this;
switch (_that) {
case _AscpDiffsGetResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpDiffsGetResult value)?  $default,){
final _that = this;
switch (_that) {
case _AscpDiffsGetResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AscpDiffSummary diff)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpDiffsGetResult() when $default != null:
return $default(_that.diff);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AscpDiffSummary diff)  $default,) {final _that = this;
switch (_that) {
case _AscpDiffsGetResult():
return $default(_that.diff);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AscpDiffSummary diff)?  $default,) {final _that = this;
switch (_that) {
case _AscpDiffsGetResult() when $default != null:
return $default(_that.diff);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpDiffsGetResult implements AscpDiffsGetResult {
  const _AscpDiffsGetResult({required this.diff});
  factory _AscpDiffsGetResult.fromJson(Map<String, dynamic> json) => _$AscpDiffsGetResultFromJson(json);

@override final  AscpDiffSummary diff;

/// Create a copy of AscpDiffsGetResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpDiffsGetResultCopyWith<_AscpDiffsGetResult> get copyWith => __$AscpDiffsGetResultCopyWithImpl<_AscpDiffsGetResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpDiffsGetResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpDiffsGetResult&&(identical(other.diff, diff) || other.diff == diff));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,diff);

@override
String toString() {
  return 'AscpDiffsGetResult(diff: $diff)';
}


}

/// @nodoc
abstract mixin class _$AscpDiffsGetResultCopyWith<$Res> implements $AscpDiffsGetResultCopyWith<$Res> {
  factory _$AscpDiffsGetResultCopyWith(_AscpDiffsGetResult value, $Res Function(_AscpDiffsGetResult) _then) = __$AscpDiffsGetResultCopyWithImpl;
@override @useResult
$Res call({
 AscpDiffSummary diff
});


@override $AscpDiffSummaryCopyWith<$Res> get diff;

}
/// @nodoc
class __$AscpDiffsGetResultCopyWithImpl<$Res>
    implements _$AscpDiffsGetResultCopyWith<$Res> {
  __$AscpDiffsGetResultCopyWithImpl(this._self, this._then);

  final _AscpDiffsGetResult _self;
  final $Res Function(_AscpDiffsGetResult) _then;

/// Create a copy of AscpDiffsGetResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diff = null,}) {
  return _then(_AscpDiffsGetResult(
diff: null == diff ? _self.diff : diff // ignore: cast_nullable_to_non_nullable
as AscpDiffSummary,
  ));
}

/// Create a copy of AscpDiffsGetResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpDiffSummaryCopyWith<$Res> get diff {
  
  return $AscpDiffSummaryCopyWith<$Res>(_self.diff, (value) {
    return _then(_self.copyWith(diff: value));
  });
}
}

// dart format on
