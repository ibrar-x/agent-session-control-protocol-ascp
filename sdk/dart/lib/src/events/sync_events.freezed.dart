// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AscpSyncSnapshotPayload {

 AscpSession get session;@JsonKey(name: 'active_run') AscpRun? get activeRun;@JsonKey(name: 'pending_approvals') List<AscpApprovalRequest> get pendingApprovals; Map<String, Object?>? get summary;
/// Create a copy of AscpSyncSnapshotPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSyncSnapshotPayloadCopyWith<AscpSyncSnapshotPayload> get copyWith => _$AscpSyncSnapshotPayloadCopyWithImpl<AscpSyncSnapshotPayload>(this as AscpSyncSnapshotPayload, _$identity);

  /// Serializes this AscpSyncSnapshotPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSyncSnapshotPayload&&(identical(other.session, session) || other.session == session)&&(identical(other.activeRun, activeRun) || other.activeRun == activeRun)&&const DeepCollectionEquality().equals(other.pendingApprovals, pendingApprovals)&&const DeepCollectionEquality().equals(other.summary, summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,activeRun,const DeepCollectionEquality().hash(pendingApprovals),const DeepCollectionEquality().hash(summary));

@override
String toString() {
  return 'AscpSyncSnapshotPayload(session: $session, activeRun: $activeRun, pendingApprovals: $pendingApprovals, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $AscpSyncSnapshotPayloadCopyWith<$Res>  {
  factory $AscpSyncSnapshotPayloadCopyWith(AscpSyncSnapshotPayload value, $Res Function(AscpSyncSnapshotPayload) _then) = _$AscpSyncSnapshotPayloadCopyWithImpl;
@useResult
$Res call({
 AscpSession session,@JsonKey(name: 'active_run') AscpRun? activeRun,@JsonKey(name: 'pending_approvals') List<AscpApprovalRequest> pendingApprovals, Map<String, Object?>? summary
});


$AscpSessionCopyWith<$Res> get session;$AscpRunCopyWith<$Res>? get activeRun;

}
/// @nodoc
class _$AscpSyncSnapshotPayloadCopyWithImpl<$Res>
    implements $AscpSyncSnapshotPayloadCopyWith<$Res> {
  _$AscpSyncSnapshotPayloadCopyWithImpl(this._self, this._then);

  final AscpSyncSnapshotPayload _self;
  final $Res Function(AscpSyncSnapshotPayload) _then;

/// Create a copy of AscpSyncSnapshotPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? activeRun = freezed,Object? pendingApprovals = null,Object? summary = freezed,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AscpSession,activeRun: freezed == activeRun ? _self.activeRun : activeRun // ignore: cast_nullable_to_non_nullable
as AscpRun?,pendingApprovals: null == pendingApprovals ? _self.pendingApprovals : pendingApprovals // ignore: cast_nullable_to_non_nullable
as List<AscpApprovalRequest>,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}
/// Create a copy of AscpSyncSnapshotPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSessionCopyWith<$Res> get session {
  
  return $AscpSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AscpSyncSnapshotPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpRunCopyWith<$Res>? get activeRun {
    if (_self.activeRun == null) {
    return null;
  }

  return $AscpRunCopyWith<$Res>(_self.activeRun!, (value) {
    return _then(_self.copyWith(activeRun: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpSyncSnapshotPayload].
extension AscpSyncSnapshotPayloadPatterns on AscpSyncSnapshotPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSyncSnapshotPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSyncSnapshotPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSyncSnapshotPayload value)  $default,){
final _that = this;
switch (_that) {
case _AscpSyncSnapshotPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSyncSnapshotPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSyncSnapshotPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AscpSession session, @JsonKey(name: 'active_run')  AscpRun? activeRun, @JsonKey(name: 'pending_approvals')  List<AscpApprovalRequest> pendingApprovals,  Map<String, Object?>? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSyncSnapshotPayload() when $default != null:
return $default(_that.session,_that.activeRun,_that.pendingApprovals,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AscpSession session, @JsonKey(name: 'active_run')  AscpRun? activeRun, @JsonKey(name: 'pending_approvals')  List<AscpApprovalRequest> pendingApprovals,  Map<String, Object?>? summary)  $default,) {final _that = this;
switch (_that) {
case _AscpSyncSnapshotPayload():
return $default(_that.session,_that.activeRun,_that.pendingApprovals,_that.summary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AscpSession session, @JsonKey(name: 'active_run')  AscpRun? activeRun, @JsonKey(name: 'pending_approvals')  List<AscpApprovalRequest> pendingApprovals,  Map<String, Object?>? summary)?  $default,) {final _that = this;
switch (_that) {
case _AscpSyncSnapshotPayload() when $default != null:
return $default(_that.session,_that.activeRun,_that.pendingApprovals,_that.summary);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSyncSnapshotPayload implements AscpSyncSnapshotPayload {
  const _AscpSyncSnapshotPayload({required this.session, @JsonKey(name: 'active_run') this.activeRun, @JsonKey(name: 'pending_approvals') final  List<AscpApprovalRequest> pendingApprovals = const <AscpApprovalRequest>[], final  Map<String, Object?>? summary}): _pendingApprovals = pendingApprovals,_summary = summary;
  factory _AscpSyncSnapshotPayload.fromJson(Map<String, dynamic> json) => _$AscpSyncSnapshotPayloadFromJson(json);

@override final  AscpSession session;
@override@JsonKey(name: 'active_run') final  AscpRun? activeRun;
 final  List<AscpApprovalRequest> _pendingApprovals;
@override@JsonKey(name: 'pending_approvals') List<AscpApprovalRequest> get pendingApprovals {
  if (_pendingApprovals is EqualUnmodifiableListView) return _pendingApprovals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingApprovals);
}

 final  Map<String, Object?>? _summary;
@override Map<String, Object?>? get summary {
  final value = _summary;
  if (value == null) return null;
  if (_summary is EqualUnmodifiableMapView) return _summary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AscpSyncSnapshotPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSyncSnapshotPayloadCopyWith<_AscpSyncSnapshotPayload> get copyWith => __$AscpSyncSnapshotPayloadCopyWithImpl<_AscpSyncSnapshotPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSyncSnapshotPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSyncSnapshotPayload&&(identical(other.session, session) || other.session == session)&&(identical(other.activeRun, activeRun) || other.activeRun == activeRun)&&const DeepCollectionEquality().equals(other._pendingApprovals, _pendingApprovals)&&const DeepCollectionEquality().equals(other._summary, _summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,session,activeRun,const DeepCollectionEquality().hash(_pendingApprovals),const DeepCollectionEquality().hash(_summary));

@override
String toString() {
  return 'AscpSyncSnapshotPayload(session: $session, activeRun: $activeRun, pendingApprovals: $pendingApprovals, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$AscpSyncSnapshotPayloadCopyWith<$Res> implements $AscpSyncSnapshotPayloadCopyWith<$Res> {
  factory _$AscpSyncSnapshotPayloadCopyWith(_AscpSyncSnapshotPayload value, $Res Function(_AscpSyncSnapshotPayload) _then) = __$AscpSyncSnapshotPayloadCopyWithImpl;
@override @useResult
$Res call({
 AscpSession session,@JsonKey(name: 'active_run') AscpRun? activeRun,@JsonKey(name: 'pending_approvals') List<AscpApprovalRequest> pendingApprovals, Map<String, Object?>? summary
});


@override $AscpSessionCopyWith<$Res> get session;@override $AscpRunCopyWith<$Res>? get activeRun;

}
/// @nodoc
class __$AscpSyncSnapshotPayloadCopyWithImpl<$Res>
    implements _$AscpSyncSnapshotPayloadCopyWith<$Res> {
  __$AscpSyncSnapshotPayloadCopyWithImpl(this._self, this._then);

  final _AscpSyncSnapshotPayload _self;
  final $Res Function(_AscpSyncSnapshotPayload) _then;

/// Create a copy of AscpSyncSnapshotPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? activeRun = freezed,Object? pendingApprovals = null,Object? summary = freezed,}) {
  return _then(_AscpSyncSnapshotPayload(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AscpSession,activeRun: freezed == activeRun ? _self.activeRun : activeRun // ignore: cast_nullable_to_non_nullable
as AscpRun?,pendingApprovals: null == pendingApprovals ? _self._pendingApprovals : pendingApprovals // ignore: cast_nullable_to_non_nullable
as List<AscpApprovalRequest>,summary: freezed == summary ? _self._summary : summary // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

/// Create a copy of AscpSyncSnapshotPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSessionCopyWith<$Res> get session {
  
  return $AscpSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AscpSyncSnapshotPayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpRunCopyWith<$Res>? get activeRun {
    if (_self.activeRun == null) {
    return null;
  }

  return $AscpRunCopyWith<$Res>(_self.activeRun!, (value) {
    return _then(_self.copyWith(activeRun: value));
  });
}
}


/// @nodoc
mixin _$AscpSyncSnapshotEvent {

 String get id; String get type; String get ts;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'run_id') String? get runId; int? get seq; AscpSyncSnapshotPayload get payload;
/// Create a copy of AscpSyncSnapshotEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSyncSnapshotEventCopyWith<AscpSyncSnapshotEvent> get copyWith => _$AscpSyncSnapshotEventCopyWithImpl<AscpSyncSnapshotEvent>(this as AscpSyncSnapshotEvent, _$identity);

  /// Serializes this AscpSyncSnapshotEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSyncSnapshotEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,ts,sessionId,runId,seq,payload);

@override
String toString() {
  return 'AscpSyncSnapshotEvent(id: $id, type: $type, ts: $ts, sessionId: $sessionId, runId: $runId, seq: $seq, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $AscpSyncSnapshotEventCopyWith<$Res>  {
  factory $AscpSyncSnapshotEventCopyWith(AscpSyncSnapshotEvent value, $Res Function(AscpSyncSnapshotEvent) _then) = _$AscpSyncSnapshotEventCopyWithImpl;
@useResult
$Res call({
 String id, String type, String ts,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, int? seq, AscpSyncSnapshotPayload payload
});


$AscpSyncSnapshotPayloadCopyWith<$Res> get payload;

}
/// @nodoc
class _$AscpSyncSnapshotEventCopyWithImpl<$Res>
    implements $AscpSyncSnapshotEventCopyWith<$Res> {
  _$AscpSyncSnapshotEventCopyWithImpl(this._self, this._then);

  final AscpSyncSnapshotEvent _self;
  final $Res Function(AscpSyncSnapshotEvent) _then;

/// Create a copy of AscpSyncSnapshotEvent
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
as AscpSyncSnapshotPayload,
  ));
}
/// Create a copy of AscpSyncSnapshotEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSyncSnapshotPayloadCopyWith<$Res> get payload {
  
  return $AscpSyncSnapshotPayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpSyncSnapshotEvent].
extension AscpSyncSnapshotEventPatterns on AscpSyncSnapshotEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSyncSnapshotEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSyncSnapshotEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSyncSnapshotEvent value)  $default,){
final _that = this;
switch (_that) {
case _AscpSyncSnapshotEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSyncSnapshotEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSyncSnapshotEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  AscpSyncSnapshotPayload payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSyncSnapshotEvent() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  AscpSyncSnapshotPayload payload)  $default,) {final _that = this;
switch (_that) {
case _AscpSyncSnapshotEvent():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  AscpSyncSnapshotPayload payload)?  $default,) {final _that = this;
switch (_that) {
case _AscpSyncSnapshotEvent() when $default != null:
return $default(_that.id,_that.type,_that.ts,_that.sessionId,_that.runId,_that.seq,_that.payload);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSyncSnapshotEvent implements AscpSyncSnapshotEvent {
  const _AscpSyncSnapshotEvent({required this.id, required this.type, required this.ts, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'run_id') this.runId, this.seq, required this.payload});
  factory _AscpSyncSnapshotEvent.fromJson(Map<String, dynamic> json) => _$AscpSyncSnapshotEventFromJson(json);

@override final  String id;
@override final  String type;
@override final  String ts;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'run_id') final  String? runId;
@override final  int? seq;
@override final  AscpSyncSnapshotPayload payload;

/// Create a copy of AscpSyncSnapshotEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSyncSnapshotEventCopyWith<_AscpSyncSnapshotEvent> get copyWith => __$AscpSyncSnapshotEventCopyWithImpl<_AscpSyncSnapshotEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSyncSnapshotEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSyncSnapshotEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,ts,sessionId,runId,seq,payload);

@override
String toString() {
  return 'AscpSyncSnapshotEvent(id: $id, type: $type, ts: $ts, sessionId: $sessionId, runId: $runId, seq: $seq, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$AscpSyncSnapshotEventCopyWith<$Res> implements $AscpSyncSnapshotEventCopyWith<$Res> {
  factory _$AscpSyncSnapshotEventCopyWith(_AscpSyncSnapshotEvent value, $Res Function(_AscpSyncSnapshotEvent) _then) = __$AscpSyncSnapshotEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String ts,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, int? seq, AscpSyncSnapshotPayload payload
});


@override $AscpSyncSnapshotPayloadCopyWith<$Res> get payload;

}
/// @nodoc
class __$AscpSyncSnapshotEventCopyWithImpl<$Res>
    implements _$AscpSyncSnapshotEventCopyWith<$Res> {
  __$AscpSyncSnapshotEventCopyWithImpl(this._self, this._then);

  final _AscpSyncSnapshotEvent _self;
  final $Res Function(_AscpSyncSnapshotEvent) _then;

/// Create a copy of AscpSyncSnapshotEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? ts = null,Object? sessionId = null,Object? runId = freezed,Object? seq = freezed,Object? payload = null,}) {
  return _then(_AscpSyncSnapshotEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,seq: freezed == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as AscpSyncSnapshotPayload,
  ));
}

/// Create a copy of AscpSyncSnapshotEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSyncSnapshotPayloadCopyWith<$Res> get payload {
  
  return $AscpSyncSnapshotPayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}


/// @nodoc
mixin _$AscpSyncReplayedPayload {

@JsonKey(name: 'from_seq') int get fromSeq;@JsonKey(name: 'to_seq') int get toSeq;@JsonKey(name: 'event_count') int get eventCount;
/// Create a copy of AscpSyncReplayedPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSyncReplayedPayloadCopyWith<AscpSyncReplayedPayload> get copyWith => _$AscpSyncReplayedPayloadCopyWithImpl<AscpSyncReplayedPayload>(this as AscpSyncReplayedPayload, _$identity);

  /// Serializes this AscpSyncReplayedPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSyncReplayedPayload&&(identical(other.fromSeq, fromSeq) || other.fromSeq == fromSeq)&&(identical(other.toSeq, toSeq) || other.toSeq == toSeq)&&(identical(other.eventCount, eventCount) || other.eventCount == eventCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromSeq,toSeq,eventCount);

@override
String toString() {
  return 'AscpSyncReplayedPayload(fromSeq: $fromSeq, toSeq: $toSeq, eventCount: $eventCount)';
}


}

/// @nodoc
abstract mixin class $AscpSyncReplayedPayloadCopyWith<$Res>  {
  factory $AscpSyncReplayedPayloadCopyWith(AscpSyncReplayedPayload value, $Res Function(AscpSyncReplayedPayload) _then) = _$AscpSyncReplayedPayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'from_seq') int fromSeq,@JsonKey(name: 'to_seq') int toSeq,@JsonKey(name: 'event_count') int eventCount
});




}
/// @nodoc
class _$AscpSyncReplayedPayloadCopyWithImpl<$Res>
    implements $AscpSyncReplayedPayloadCopyWith<$Res> {
  _$AscpSyncReplayedPayloadCopyWithImpl(this._self, this._then);

  final AscpSyncReplayedPayload _self;
  final $Res Function(AscpSyncReplayedPayload) _then;

/// Create a copy of AscpSyncReplayedPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromSeq = null,Object? toSeq = null,Object? eventCount = null,}) {
  return _then(_self.copyWith(
fromSeq: null == fromSeq ? _self.fromSeq : fromSeq // ignore: cast_nullable_to_non_nullable
as int,toSeq: null == toSeq ? _self.toSeq : toSeq // ignore: cast_nullable_to_non_nullable
as int,eventCount: null == eventCount ? _self.eventCount : eventCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSyncReplayedPayload].
extension AscpSyncReplayedPayloadPatterns on AscpSyncReplayedPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSyncReplayedPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSyncReplayedPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSyncReplayedPayload value)  $default,){
final _that = this;
switch (_that) {
case _AscpSyncReplayedPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSyncReplayedPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSyncReplayedPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'from_seq')  int fromSeq, @JsonKey(name: 'to_seq')  int toSeq, @JsonKey(name: 'event_count')  int eventCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSyncReplayedPayload() when $default != null:
return $default(_that.fromSeq,_that.toSeq,_that.eventCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'from_seq')  int fromSeq, @JsonKey(name: 'to_seq')  int toSeq, @JsonKey(name: 'event_count')  int eventCount)  $default,) {final _that = this;
switch (_that) {
case _AscpSyncReplayedPayload():
return $default(_that.fromSeq,_that.toSeq,_that.eventCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'from_seq')  int fromSeq, @JsonKey(name: 'to_seq')  int toSeq, @JsonKey(name: 'event_count')  int eventCount)?  $default,) {final _that = this;
switch (_that) {
case _AscpSyncReplayedPayload() when $default != null:
return $default(_that.fromSeq,_that.toSeq,_that.eventCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSyncReplayedPayload implements AscpSyncReplayedPayload {
  const _AscpSyncReplayedPayload({@JsonKey(name: 'from_seq') required this.fromSeq, @JsonKey(name: 'to_seq') required this.toSeq, @JsonKey(name: 'event_count') required this.eventCount});
  factory _AscpSyncReplayedPayload.fromJson(Map<String, dynamic> json) => _$AscpSyncReplayedPayloadFromJson(json);

@override@JsonKey(name: 'from_seq') final  int fromSeq;
@override@JsonKey(name: 'to_seq') final  int toSeq;
@override@JsonKey(name: 'event_count') final  int eventCount;

/// Create a copy of AscpSyncReplayedPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSyncReplayedPayloadCopyWith<_AscpSyncReplayedPayload> get copyWith => __$AscpSyncReplayedPayloadCopyWithImpl<_AscpSyncReplayedPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSyncReplayedPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSyncReplayedPayload&&(identical(other.fromSeq, fromSeq) || other.fromSeq == fromSeq)&&(identical(other.toSeq, toSeq) || other.toSeq == toSeq)&&(identical(other.eventCount, eventCount) || other.eventCount == eventCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromSeq,toSeq,eventCount);

@override
String toString() {
  return 'AscpSyncReplayedPayload(fromSeq: $fromSeq, toSeq: $toSeq, eventCount: $eventCount)';
}


}

/// @nodoc
abstract mixin class _$AscpSyncReplayedPayloadCopyWith<$Res> implements $AscpSyncReplayedPayloadCopyWith<$Res> {
  factory _$AscpSyncReplayedPayloadCopyWith(_AscpSyncReplayedPayload value, $Res Function(_AscpSyncReplayedPayload) _then) = __$AscpSyncReplayedPayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'from_seq') int fromSeq,@JsonKey(name: 'to_seq') int toSeq,@JsonKey(name: 'event_count') int eventCount
});




}
/// @nodoc
class __$AscpSyncReplayedPayloadCopyWithImpl<$Res>
    implements _$AscpSyncReplayedPayloadCopyWith<$Res> {
  __$AscpSyncReplayedPayloadCopyWithImpl(this._self, this._then);

  final _AscpSyncReplayedPayload _self;
  final $Res Function(_AscpSyncReplayedPayload) _then;

/// Create a copy of AscpSyncReplayedPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromSeq = null,Object? toSeq = null,Object? eventCount = null,}) {
  return _then(_AscpSyncReplayedPayload(
fromSeq: null == fromSeq ? _self.fromSeq : fromSeq // ignore: cast_nullable_to_non_nullable
as int,toSeq: null == toSeq ? _self.toSeq : toSeq // ignore: cast_nullable_to_non_nullable
as int,eventCount: null == eventCount ? _self.eventCount : eventCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AscpSyncReplayedEvent {

 String get id; String get type; String get ts;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'run_id') String? get runId; int? get seq; AscpSyncReplayedPayload get payload;
/// Create a copy of AscpSyncReplayedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSyncReplayedEventCopyWith<AscpSyncReplayedEvent> get copyWith => _$AscpSyncReplayedEventCopyWithImpl<AscpSyncReplayedEvent>(this as AscpSyncReplayedEvent, _$identity);

  /// Serializes this AscpSyncReplayedEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSyncReplayedEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,ts,sessionId,runId,seq,payload);

@override
String toString() {
  return 'AscpSyncReplayedEvent(id: $id, type: $type, ts: $ts, sessionId: $sessionId, runId: $runId, seq: $seq, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $AscpSyncReplayedEventCopyWith<$Res>  {
  factory $AscpSyncReplayedEventCopyWith(AscpSyncReplayedEvent value, $Res Function(AscpSyncReplayedEvent) _then) = _$AscpSyncReplayedEventCopyWithImpl;
@useResult
$Res call({
 String id, String type, String ts,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, int? seq, AscpSyncReplayedPayload payload
});


$AscpSyncReplayedPayloadCopyWith<$Res> get payload;

}
/// @nodoc
class _$AscpSyncReplayedEventCopyWithImpl<$Res>
    implements $AscpSyncReplayedEventCopyWith<$Res> {
  _$AscpSyncReplayedEventCopyWithImpl(this._self, this._then);

  final AscpSyncReplayedEvent _self;
  final $Res Function(AscpSyncReplayedEvent) _then;

/// Create a copy of AscpSyncReplayedEvent
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
as AscpSyncReplayedPayload,
  ));
}
/// Create a copy of AscpSyncReplayedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSyncReplayedPayloadCopyWith<$Res> get payload {
  
  return $AscpSyncReplayedPayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpSyncReplayedEvent].
extension AscpSyncReplayedEventPatterns on AscpSyncReplayedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSyncReplayedEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSyncReplayedEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSyncReplayedEvent value)  $default,){
final _that = this;
switch (_that) {
case _AscpSyncReplayedEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSyncReplayedEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSyncReplayedEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  AscpSyncReplayedPayload payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSyncReplayedEvent() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  AscpSyncReplayedPayload payload)  $default,) {final _that = this;
switch (_that) {
case _AscpSyncReplayedEvent():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  AscpSyncReplayedPayload payload)?  $default,) {final _that = this;
switch (_that) {
case _AscpSyncReplayedEvent() when $default != null:
return $default(_that.id,_that.type,_that.ts,_that.sessionId,_that.runId,_that.seq,_that.payload);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSyncReplayedEvent implements AscpSyncReplayedEvent {
  const _AscpSyncReplayedEvent({required this.id, required this.type, required this.ts, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'run_id') this.runId, this.seq, required this.payload});
  factory _AscpSyncReplayedEvent.fromJson(Map<String, dynamic> json) => _$AscpSyncReplayedEventFromJson(json);

@override final  String id;
@override final  String type;
@override final  String ts;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'run_id') final  String? runId;
@override final  int? seq;
@override final  AscpSyncReplayedPayload payload;

/// Create a copy of AscpSyncReplayedEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSyncReplayedEventCopyWith<_AscpSyncReplayedEvent> get copyWith => __$AscpSyncReplayedEventCopyWithImpl<_AscpSyncReplayedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSyncReplayedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSyncReplayedEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,ts,sessionId,runId,seq,payload);

@override
String toString() {
  return 'AscpSyncReplayedEvent(id: $id, type: $type, ts: $ts, sessionId: $sessionId, runId: $runId, seq: $seq, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$AscpSyncReplayedEventCopyWith<$Res> implements $AscpSyncReplayedEventCopyWith<$Res> {
  factory _$AscpSyncReplayedEventCopyWith(_AscpSyncReplayedEvent value, $Res Function(_AscpSyncReplayedEvent) _then) = __$AscpSyncReplayedEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String ts,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, int? seq, AscpSyncReplayedPayload payload
});


@override $AscpSyncReplayedPayloadCopyWith<$Res> get payload;

}
/// @nodoc
class __$AscpSyncReplayedEventCopyWithImpl<$Res>
    implements _$AscpSyncReplayedEventCopyWith<$Res> {
  __$AscpSyncReplayedEventCopyWithImpl(this._self, this._then);

  final _AscpSyncReplayedEvent _self;
  final $Res Function(_AscpSyncReplayedEvent) _then;

/// Create a copy of AscpSyncReplayedEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? ts = null,Object? sessionId = null,Object? runId = freezed,Object? seq = freezed,Object? payload = null,}) {
  return _then(_AscpSyncReplayedEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,seq: freezed == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as AscpSyncReplayedPayload,
  ));
}

/// Create a copy of AscpSyncReplayedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSyncReplayedPayloadCopyWith<$Res> get payload {
  
  return $AscpSyncReplayedPayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}


/// @nodoc
mixin _$AscpSyncCursorAdvancedPayload {

 String get cursor;
/// Create a copy of AscpSyncCursorAdvancedPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSyncCursorAdvancedPayloadCopyWith<AscpSyncCursorAdvancedPayload> get copyWith => _$AscpSyncCursorAdvancedPayloadCopyWithImpl<AscpSyncCursorAdvancedPayload>(this as AscpSyncCursorAdvancedPayload, _$identity);

  /// Serializes this AscpSyncCursorAdvancedPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSyncCursorAdvancedPayload&&(identical(other.cursor, cursor) || other.cursor == cursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cursor);

@override
String toString() {
  return 'AscpSyncCursorAdvancedPayload(cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class $AscpSyncCursorAdvancedPayloadCopyWith<$Res>  {
  factory $AscpSyncCursorAdvancedPayloadCopyWith(AscpSyncCursorAdvancedPayload value, $Res Function(AscpSyncCursorAdvancedPayload) _then) = _$AscpSyncCursorAdvancedPayloadCopyWithImpl;
@useResult
$Res call({
 String cursor
});




}
/// @nodoc
class _$AscpSyncCursorAdvancedPayloadCopyWithImpl<$Res>
    implements $AscpSyncCursorAdvancedPayloadCopyWith<$Res> {
  _$AscpSyncCursorAdvancedPayloadCopyWithImpl(this._self, this._then);

  final AscpSyncCursorAdvancedPayload _self;
  final $Res Function(AscpSyncCursorAdvancedPayload) _then;

/// Create a copy of AscpSyncCursorAdvancedPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cursor = null,}) {
  return _then(_self.copyWith(
cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSyncCursorAdvancedPayload].
extension AscpSyncCursorAdvancedPayloadPatterns on AscpSyncCursorAdvancedPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSyncCursorAdvancedPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSyncCursorAdvancedPayload value)  $default,){
final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSyncCursorAdvancedPayload value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String cursor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedPayload() when $default != null:
return $default(_that.cursor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String cursor)  $default,) {final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedPayload():
return $default(_that.cursor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String cursor)?  $default,) {final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedPayload() when $default != null:
return $default(_that.cursor);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSyncCursorAdvancedPayload implements AscpSyncCursorAdvancedPayload {
  const _AscpSyncCursorAdvancedPayload({required this.cursor});
  factory _AscpSyncCursorAdvancedPayload.fromJson(Map<String, dynamic> json) => _$AscpSyncCursorAdvancedPayloadFromJson(json);

@override final  String cursor;

/// Create a copy of AscpSyncCursorAdvancedPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSyncCursorAdvancedPayloadCopyWith<_AscpSyncCursorAdvancedPayload> get copyWith => __$AscpSyncCursorAdvancedPayloadCopyWithImpl<_AscpSyncCursorAdvancedPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSyncCursorAdvancedPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSyncCursorAdvancedPayload&&(identical(other.cursor, cursor) || other.cursor == cursor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cursor);

@override
String toString() {
  return 'AscpSyncCursorAdvancedPayload(cursor: $cursor)';
}


}

/// @nodoc
abstract mixin class _$AscpSyncCursorAdvancedPayloadCopyWith<$Res> implements $AscpSyncCursorAdvancedPayloadCopyWith<$Res> {
  factory _$AscpSyncCursorAdvancedPayloadCopyWith(_AscpSyncCursorAdvancedPayload value, $Res Function(_AscpSyncCursorAdvancedPayload) _then) = __$AscpSyncCursorAdvancedPayloadCopyWithImpl;
@override @useResult
$Res call({
 String cursor
});




}
/// @nodoc
class __$AscpSyncCursorAdvancedPayloadCopyWithImpl<$Res>
    implements _$AscpSyncCursorAdvancedPayloadCopyWith<$Res> {
  __$AscpSyncCursorAdvancedPayloadCopyWithImpl(this._self, this._then);

  final _AscpSyncCursorAdvancedPayload _self;
  final $Res Function(_AscpSyncCursorAdvancedPayload) _then;

/// Create a copy of AscpSyncCursorAdvancedPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cursor = null,}) {
  return _then(_AscpSyncCursorAdvancedPayload(
cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AscpSyncCursorAdvancedEvent {

 String get id; String get type; String get ts;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'run_id') String? get runId; int? get seq; AscpSyncCursorAdvancedPayload get payload;
/// Create a copy of AscpSyncCursorAdvancedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSyncCursorAdvancedEventCopyWith<AscpSyncCursorAdvancedEvent> get copyWith => _$AscpSyncCursorAdvancedEventCopyWithImpl<AscpSyncCursorAdvancedEvent>(this as AscpSyncCursorAdvancedEvent, _$identity);

  /// Serializes this AscpSyncCursorAdvancedEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSyncCursorAdvancedEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,ts,sessionId,runId,seq,payload);

@override
String toString() {
  return 'AscpSyncCursorAdvancedEvent(id: $id, type: $type, ts: $ts, sessionId: $sessionId, runId: $runId, seq: $seq, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $AscpSyncCursorAdvancedEventCopyWith<$Res>  {
  factory $AscpSyncCursorAdvancedEventCopyWith(AscpSyncCursorAdvancedEvent value, $Res Function(AscpSyncCursorAdvancedEvent) _then) = _$AscpSyncCursorAdvancedEventCopyWithImpl;
@useResult
$Res call({
 String id, String type, String ts,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, int? seq, AscpSyncCursorAdvancedPayload payload
});


$AscpSyncCursorAdvancedPayloadCopyWith<$Res> get payload;

}
/// @nodoc
class _$AscpSyncCursorAdvancedEventCopyWithImpl<$Res>
    implements $AscpSyncCursorAdvancedEventCopyWith<$Res> {
  _$AscpSyncCursorAdvancedEventCopyWithImpl(this._self, this._then);

  final AscpSyncCursorAdvancedEvent _self;
  final $Res Function(AscpSyncCursorAdvancedEvent) _then;

/// Create a copy of AscpSyncCursorAdvancedEvent
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
as AscpSyncCursorAdvancedPayload,
  ));
}
/// Create a copy of AscpSyncCursorAdvancedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSyncCursorAdvancedPayloadCopyWith<$Res> get payload {
  
  return $AscpSyncCursorAdvancedPayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpSyncCursorAdvancedEvent].
extension AscpSyncCursorAdvancedEventPatterns on AscpSyncCursorAdvancedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSyncCursorAdvancedEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSyncCursorAdvancedEvent value)  $default,){
final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSyncCursorAdvancedEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  AscpSyncCursorAdvancedPayload payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedEvent() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  AscpSyncCursorAdvancedPayload payload)  $default,) {final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedEvent():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String ts, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  int? seq,  AscpSyncCursorAdvancedPayload payload)?  $default,) {final _that = this;
switch (_that) {
case _AscpSyncCursorAdvancedEvent() when $default != null:
return $default(_that.id,_that.type,_that.ts,_that.sessionId,_that.runId,_that.seq,_that.payload);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSyncCursorAdvancedEvent implements AscpSyncCursorAdvancedEvent {
  const _AscpSyncCursorAdvancedEvent({required this.id, required this.type, required this.ts, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'run_id') this.runId, this.seq, required this.payload});
  factory _AscpSyncCursorAdvancedEvent.fromJson(Map<String, dynamic> json) => _$AscpSyncCursorAdvancedEventFromJson(json);

@override final  String id;
@override final  String type;
@override final  String ts;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'run_id') final  String? runId;
@override final  int? seq;
@override final  AscpSyncCursorAdvancedPayload payload;

/// Create a copy of AscpSyncCursorAdvancedEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSyncCursorAdvancedEventCopyWith<_AscpSyncCursorAdvancedEvent> get copyWith => __$AscpSyncCursorAdvancedEventCopyWithImpl<_AscpSyncCursorAdvancedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSyncCursorAdvancedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSyncCursorAdvancedEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.payload, payload) || other.payload == payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,ts,sessionId,runId,seq,payload);

@override
String toString() {
  return 'AscpSyncCursorAdvancedEvent(id: $id, type: $type, ts: $ts, sessionId: $sessionId, runId: $runId, seq: $seq, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$AscpSyncCursorAdvancedEventCopyWith<$Res> implements $AscpSyncCursorAdvancedEventCopyWith<$Res> {
  factory _$AscpSyncCursorAdvancedEventCopyWith(_AscpSyncCursorAdvancedEvent value, $Res Function(_AscpSyncCursorAdvancedEvent) _then) = __$AscpSyncCursorAdvancedEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String ts,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, int? seq, AscpSyncCursorAdvancedPayload payload
});


@override $AscpSyncCursorAdvancedPayloadCopyWith<$Res> get payload;

}
/// @nodoc
class __$AscpSyncCursorAdvancedEventCopyWithImpl<$Res>
    implements _$AscpSyncCursorAdvancedEventCopyWith<$Res> {
  __$AscpSyncCursorAdvancedEventCopyWithImpl(this._self, this._then);

  final _AscpSyncCursorAdvancedEvent _self;
  final $Res Function(_AscpSyncCursorAdvancedEvent) _then;

/// Create a copy of AscpSyncCursorAdvancedEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? ts = null,Object? sessionId = null,Object? runId = freezed,Object? seq = freezed,Object? payload = null,}) {
  return _then(_AscpSyncCursorAdvancedEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,seq: freezed == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int?,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as AscpSyncCursorAdvancedPayload,
  ));
}

/// Create a copy of AscpSyncCursorAdvancedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpSyncCursorAdvancedPayloadCopyWith<$Res> get payload {
  
  return $AscpSyncCursorAdvancedPayloadCopyWith<$Res>(_self.payload, (value) {
    return _then(_self.copyWith(payload: value));
  });
}
}

// dart format on
