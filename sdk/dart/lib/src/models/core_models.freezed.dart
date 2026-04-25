// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'core_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AscpCapabilities {

@JsonKey(name: 'session_list') bool? get sessionList;@JsonKey(name: 'session_resume') bool? get sessionResume;@JsonKey(name: 'session_start') bool? get sessionStart;@JsonKey(name: 'session_stop') bool? get sessionStop;@JsonKey(name: 'stream_events') bool? get streamEvents;@JsonKey(name: 'transcript_read') bool? get transcriptRead;@JsonKey(name: 'message_send') bool? get messageSend;@JsonKey(name: 'approval_requests') bool? get approvalRequests;@JsonKey(name: 'approval_respond') bool? get approvalRespond; bool? get artifacts; bool? get diffs;@JsonKey(name: 'terminal_passthrough') bool? get terminalPassthrough; bool? get notifications; bool? get checkpoints; bool? get replay;@JsonKey(name: 'multi_workspace') bool? get multiWorkspace;
/// Create a copy of AscpCapabilities
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpCapabilitiesCopyWith<AscpCapabilities> get copyWith => _$AscpCapabilitiesCopyWithImpl<AscpCapabilities>(this as AscpCapabilities, _$identity);

  /// Serializes this AscpCapabilities to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpCapabilities&&(identical(other.sessionList, sessionList) || other.sessionList == sessionList)&&(identical(other.sessionResume, sessionResume) || other.sessionResume == sessionResume)&&(identical(other.sessionStart, sessionStart) || other.sessionStart == sessionStart)&&(identical(other.sessionStop, sessionStop) || other.sessionStop == sessionStop)&&(identical(other.streamEvents, streamEvents) || other.streamEvents == streamEvents)&&(identical(other.transcriptRead, transcriptRead) || other.transcriptRead == transcriptRead)&&(identical(other.messageSend, messageSend) || other.messageSend == messageSend)&&(identical(other.approvalRequests, approvalRequests) || other.approvalRequests == approvalRequests)&&(identical(other.approvalRespond, approvalRespond) || other.approvalRespond == approvalRespond)&&(identical(other.artifacts, artifacts) || other.artifacts == artifacts)&&(identical(other.diffs, diffs) || other.diffs == diffs)&&(identical(other.terminalPassthrough, terminalPassthrough) || other.terminalPassthrough == terminalPassthrough)&&(identical(other.notifications, notifications) || other.notifications == notifications)&&(identical(other.checkpoints, checkpoints) || other.checkpoints == checkpoints)&&(identical(other.replay, replay) || other.replay == replay)&&(identical(other.multiWorkspace, multiWorkspace) || other.multiWorkspace == multiWorkspace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionList,sessionResume,sessionStart,sessionStop,streamEvents,transcriptRead,messageSend,approvalRequests,approvalRespond,artifacts,diffs,terminalPassthrough,notifications,checkpoints,replay,multiWorkspace);

@override
String toString() {
  return 'AscpCapabilities(sessionList: $sessionList, sessionResume: $sessionResume, sessionStart: $sessionStart, sessionStop: $sessionStop, streamEvents: $streamEvents, transcriptRead: $transcriptRead, messageSend: $messageSend, approvalRequests: $approvalRequests, approvalRespond: $approvalRespond, artifacts: $artifacts, diffs: $diffs, terminalPassthrough: $terminalPassthrough, notifications: $notifications, checkpoints: $checkpoints, replay: $replay, multiWorkspace: $multiWorkspace)';
}


}

/// @nodoc
abstract mixin class $AscpCapabilitiesCopyWith<$Res>  {
  factory $AscpCapabilitiesCopyWith(AscpCapabilities value, $Res Function(AscpCapabilities) _then) = _$AscpCapabilitiesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_list') bool? sessionList,@JsonKey(name: 'session_resume') bool? sessionResume,@JsonKey(name: 'session_start') bool? sessionStart,@JsonKey(name: 'session_stop') bool? sessionStop,@JsonKey(name: 'stream_events') bool? streamEvents,@JsonKey(name: 'transcript_read') bool? transcriptRead,@JsonKey(name: 'message_send') bool? messageSend,@JsonKey(name: 'approval_requests') bool? approvalRequests,@JsonKey(name: 'approval_respond') bool? approvalRespond, bool? artifacts, bool? diffs,@JsonKey(name: 'terminal_passthrough') bool? terminalPassthrough, bool? notifications, bool? checkpoints, bool? replay,@JsonKey(name: 'multi_workspace') bool? multiWorkspace
});




}
/// @nodoc
class _$AscpCapabilitiesCopyWithImpl<$Res>
    implements $AscpCapabilitiesCopyWith<$Res> {
  _$AscpCapabilitiesCopyWithImpl(this._self, this._then);

  final AscpCapabilities _self;
  final $Res Function(AscpCapabilities) _then;

/// Create a copy of AscpCapabilities
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionList = freezed,Object? sessionResume = freezed,Object? sessionStart = freezed,Object? sessionStop = freezed,Object? streamEvents = freezed,Object? transcriptRead = freezed,Object? messageSend = freezed,Object? approvalRequests = freezed,Object? approvalRespond = freezed,Object? artifacts = freezed,Object? diffs = freezed,Object? terminalPassthrough = freezed,Object? notifications = freezed,Object? checkpoints = freezed,Object? replay = freezed,Object? multiWorkspace = freezed,}) {
  return _then(_self.copyWith(
sessionList: freezed == sessionList ? _self.sessionList : sessionList // ignore: cast_nullable_to_non_nullable
as bool?,sessionResume: freezed == sessionResume ? _self.sessionResume : sessionResume // ignore: cast_nullable_to_non_nullable
as bool?,sessionStart: freezed == sessionStart ? _self.sessionStart : sessionStart // ignore: cast_nullable_to_non_nullable
as bool?,sessionStop: freezed == sessionStop ? _self.sessionStop : sessionStop // ignore: cast_nullable_to_non_nullable
as bool?,streamEvents: freezed == streamEvents ? _self.streamEvents : streamEvents // ignore: cast_nullable_to_non_nullable
as bool?,transcriptRead: freezed == transcriptRead ? _self.transcriptRead : transcriptRead // ignore: cast_nullable_to_non_nullable
as bool?,messageSend: freezed == messageSend ? _self.messageSend : messageSend // ignore: cast_nullable_to_non_nullable
as bool?,approvalRequests: freezed == approvalRequests ? _self.approvalRequests : approvalRequests // ignore: cast_nullable_to_non_nullable
as bool?,approvalRespond: freezed == approvalRespond ? _self.approvalRespond : approvalRespond // ignore: cast_nullable_to_non_nullable
as bool?,artifacts: freezed == artifacts ? _self.artifacts : artifacts // ignore: cast_nullable_to_non_nullable
as bool?,diffs: freezed == diffs ? _self.diffs : diffs // ignore: cast_nullable_to_non_nullable
as bool?,terminalPassthrough: freezed == terminalPassthrough ? _self.terminalPassthrough : terminalPassthrough // ignore: cast_nullable_to_non_nullable
as bool?,notifications: freezed == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as bool?,checkpoints: freezed == checkpoints ? _self.checkpoints : checkpoints // ignore: cast_nullable_to_non_nullable
as bool?,replay: freezed == replay ? _self.replay : replay // ignore: cast_nullable_to_non_nullable
as bool?,multiWorkspace: freezed == multiWorkspace ? _self.multiWorkspace : multiWorkspace // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpCapabilities].
extension AscpCapabilitiesPatterns on AscpCapabilities {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpCapabilities value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpCapabilities() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpCapabilities value)  $default,){
final _that = this;
switch (_that) {
case _AscpCapabilities():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpCapabilities value)?  $default,){
final _that = this;
switch (_that) {
case _AscpCapabilities() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_list')  bool? sessionList, @JsonKey(name: 'session_resume')  bool? sessionResume, @JsonKey(name: 'session_start')  bool? sessionStart, @JsonKey(name: 'session_stop')  bool? sessionStop, @JsonKey(name: 'stream_events')  bool? streamEvents, @JsonKey(name: 'transcript_read')  bool? transcriptRead, @JsonKey(name: 'message_send')  bool? messageSend, @JsonKey(name: 'approval_requests')  bool? approvalRequests, @JsonKey(name: 'approval_respond')  bool? approvalRespond,  bool? artifacts,  bool? diffs, @JsonKey(name: 'terminal_passthrough')  bool? terminalPassthrough,  bool? notifications,  bool? checkpoints,  bool? replay, @JsonKey(name: 'multi_workspace')  bool? multiWorkspace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpCapabilities() when $default != null:
return $default(_that.sessionList,_that.sessionResume,_that.sessionStart,_that.sessionStop,_that.streamEvents,_that.transcriptRead,_that.messageSend,_that.approvalRequests,_that.approvalRespond,_that.artifacts,_that.diffs,_that.terminalPassthrough,_that.notifications,_that.checkpoints,_that.replay,_that.multiWorkspace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_list')  bool? sessionList, @JsonKey(name: 'session_resume')  bool? sessionResume, @JsonKey(name: 'session_start')  bool? sessionStart, @JsonKey(name: 'session_stop')  bool? sessionStop, @JsonKey(name: 'stream_events')  bool? streamEvents, @JsonKey(name: 'transcript_read')  bool? transcriptRead, @JsonKey(name: 'message_send')  bool? messageSend, @JsonKey(name: 'approval_requests')  bool? approvalRequests, @JsonKey(name: 'approval_respond')  bool? approvalRespond,  bool? artifacts,  bool? diffs, @JsonKey(name: 'terminal_passthrough')  bool? terminalPassthrough,  bool? notifications,  bool? checkpoints,  bool? replay, @JsonKey(name: 'multi_workspace')  bool? multiWorkspace)  $default,) {final _that = this;
switch (_that) {
case _AscpCapabilities():
return $default(_that.sessionList,_that.sessionResume,_that.sessionStart,_that.sessionStop,_that.streamEvents,_that.transcriptRead,_that.messageSend,_that.approvalRequests,_that.approvalRespond,_that.artifacts,_that.diffs,_that.terminalPassthrough,_that.notifications,_that.checkpoints,_that.replay,_that.multiWorkspace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_list')  bool? sessionList, @JsonKey(name: 'session_resume')  bool? sessionResume, @JsonKey(name: 'session_start')  bool? sessionStart, @JsonKey(name: 'session_stop')  bool? sessionStop, @JsonKey(name: 'stream_events')  bool? streamEvents, @JsonKey(name: 'transcript_read')  bool? transcriptRead, @JsonKey(name: 'message_send')  bool? messageSend, @JsonKey(name: 'approval_requests')  bool? approvalRequests, @JsonKey(name: 'approval_respond')  bool? approvalRespond,  bool? artifacts,  bool? diffs, @JsonKey(name: 'terminal_passthrough')  bool? terminalPassthrough,  bool? notifications,  bool? checkpoints,  bool? replay, @JsonKey(name: 'multi_workspace')  bool? multiWorkspace)?  $default,) {final _that = this;
switch (_that) {
case _AscpCapabilities() when $default != null:
return $default(_that.sessionList,_that.sessionResume,_that.sessionStart,_that.sessionStop,_that.streamEvents,_that.transcriptRead,_that.messageSend,_that.approvalRequests,_that.approvalRespond,_that.artifacts,_that.diffs,_that.terminalPassthrough,_that.notifications,_that.checkpoints,_that.replay,_that.multiWorkspace);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpCapabilities implements AscpCapabilities {
  const _AscpCapabilities({@JsonKey(name: 'session_list') this.sessionList, @JsonKey(name: 'session_resume') this.sessionResume, @JsonKey(name: 'session_start') this.sessionStart, @JsonKey(name: 'session_stop') this.sessionStop, @JsonKey(name: 'stream_events') this.streamEvents, @JsonKey(name: 'transcript_read') this.transcriptRead, @JsonKey(name: 'message_send') this.messageSend, @JsonKey(name: 'approval_requests') this.approvalRequests, @JsonKey(name: 'approval_respond') this.approvalRespond, this.artifacts, this.diffs, @JsonKey(name: 'terminal_passthrough') this.terminalPassthrough, this.notifications, this.checkpoints, this.replay, @JsonKey(name: 'multi_workspace') this.multiWorkspace});
  factory _AscpCapabilities.fromJson(Map<String, dynamic> json) => _$AscpCapabilitiesFromJson(json);

@override@JsonKey(name: 'session_list') final  bool? sessionList;
@override@JsonKey(name: 'session_resume') final  bool? sessionResume;
@override@JsonKey(name: 'session_start') final  bool? sessionStart;
@override@JsonKey(name: 'session_stop') final  bool? sessionStop;
@override@JsonKey(name: 'stream_events') final  bool? streamEvents;
@override@JsonKey(name: 'transcript_read') final  bool? transcriptRead;
@override@JsonKey(name: 'message_send') final  bool? messageSend;
@override@JsonKey(name: 'approval_requests') final  bool? approvalRequests;
@override@JsonKey(name: 'approval_respond') final  bool? approvalRespond;
@override final  bool? artifacts;
@override final  bool? diffs;
@override@JsonKey(name: 'terminal_passthrough') final  bool? terminalPassthrough;
@override final  bool? notifications;
@override final  bool? checkpoints;
@override final  bool? replay;
@override@JsonKey(name: 'multi_workspace') final  bool? multiWorkspace;

/// Create a copy of AscpCapabilities
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpCapabilitiesCopyWith<_AscpCapabilities> get copyWith => __$AscpCapabilitiesCopyWithImpl<_AscpCapabilities>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpCapabilitiesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpCapabilities&&(identical(other.sessionList, sessionList) || other.sessionList == sessionList)&&(identical(other.sessionResume, sessionResume) || other.sessionResume == sessionResume)&&(identical(other.sessionStart, sessionStart) || other.sessionStart == sessionStart)&&(identical(other.sessionStop, sessionStop) || other.sessionStop == sessionStop)&&(identical(other.streamEvents, streamEvents) || other.streamEvents == streamEvents)&&(identical(other.transcriptRead, transcriptRead) || other.transcriptRead == transcriptRead)&&(identical(other.messageSend, messageSend) || other.messageSend == messageSend)&&(identical(other.approvalRequests, approvalRequests) || other.approvalRequests == approvalRequests)&&(identical(other.approvalRespond, approvalRespond) || other.approvalRespond == approvalRespond)&&(identical(other.artifacts, artifacts) || other.artifacts == artifacts)&&(identical(other.diffs, diffs) || other.diffs == diffs)&&(identical(other.terminalPassthrough, terminalPassthrough) || other.terminalPassthrough == terminalPassthrough)&&(identical(other.notifications, notifications) || other.notifications == notifications)&&(identical(other.checkpoints, checkpoints) || other.checkpoints == checkpoints)&&(identical(other.replay, replay) || other.replay == replay)&&(identical(other.multiWorkspace, multiWorkspace) || other.multiWorkspace == multiWorkspace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionList,sessionResume,sessionStart,sessionStop,streamEvents,transcriptRead,messageSend,approvalRequests,approvalRespond,artifacts,diffs,terminalPassthrough,notifications,checkpoints,replay,multiWorkspace);

@override
String toString() {
  return 'AscpCapabilities(sessionList: $sessionList, sessionResume: $sessionResume, sessionStart: $sessionStart, sessionStop: $sessionStop, streamEvents: $streamEvents, transcriptRead: $transcriptRead, messageSend: $messageSend, approvalRequests: $approvalRequests, approvalRespond: $approvalRespond, artifacts: $artifacts, diffs: $diffs, terminalPassthrough: $terminalPassthrough, notifications: $notifications, checkpoints: $checkpoints, replay: $replay, multiWorkspace: $multiWorkspace)';
}


}

/// @nodoc
abstract mixin class _$AscpCapabilitiesCopyWith<$Res> implements $AscpCapabilitiesCopyWith<$Res> {
  factory _$AscpCapabilitiesCopyWith(_AscpCapabilities value, $Res Function(_AscpCapabilities) _then) = __$AscpCapabilitiesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_list') bool? sessionList,@JsonKey(name: 'session_resume') bool? sessionResume,@JsonKey(name: 'session_start') bool? sessionStart,@JsonKey(name: 'session_stop') bool? sessionStop,@JsonKey(name: 'stream_events') bool? streamEvents,@JsonKey(name: 'transcript_read') bool? transcriptRead,@JsonKey(name: 'message_send') bool? messageSend,@JsonKey(name: 'approval_requests') bool? approvalRequests,@JsonKey(name: 'approval_respond') bool? approvalRespond, bool? artifacts, bool? diffs,@JsonKey(name: 'terminal_passthrough') bool? terminalPassthrough, bool? notifications, bool? checkpoints, bool? replay,@JsonKey(name: 'multi_workspace') bool? multiWorkspace
});




}
/// @nodoc
class __$AscpCapabilitiesCopyWithImpl<$Res>
    implements _$AscpCapabilitiesCopyWith<$Res> {
  __$AscpCapabilitiesCopyWithImpl(this._self, this._then);

  final _AscpCapabilities _self;
  final $Res Function(_AscpCapabilities) _then;

/// Create a copy of AscpCapabilities
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionList = freezed,Object? sessionResume = freezed,Object? sessionStart = freezed,Object? sessionStop = freezed,Object? streamEvents = freezed,Object? transcriptRead = freezed,Object? messageSend = freezed,Object? approvalRequests = freezed,Object? approvalRespond = freezed,Object? artifacts = freezed,Object? diffs = freezed,Object? terminalPassthrough = freezed,Object? notifications = freezed,Object? checkpoints = freezed,Object? replay = freezed,Object? multiWorkspace = freezed,}) {
  return _then(_AscpCapabilities(
sessionList: freezed == sessionList ? _self.sessionList : sessionList // ignore: cast_nullable_to_non_nullable
as bool?,sessionResume: freezed == sessionResume ? _self.sessionResume : sessionResume // ignore: cast_nullable_to_non_nullable
as bool?,sessionStart: freezed == sessionStart ? _self.sessionStart : sessionStart // ignore: cast_nullable_to_non_nullable
as bool?,sessionStop: freezed == sessionStop ? _self.sessionStop : sessionStop // ignore: cast_nullable_to_non_nullable
as bool?,streamEvents: freezed == streamEvents ? _self.streamEvents : streamEvents // ignore: cast_nullable_to_non_nullable
as bool?,transcriptRead: freezed == transcriptRead ? _self.transcriptRead : transcriptRead // ignore: cast_nullable_to_non_nullable
as bool?,messageSend: freezed == messageSend ? _self.messageSend : messageSend // ignore: cast_nullable_to_non_nullable
as bool?,approvalRequests: freezed == approvalRequests ? _self.approvalRequests : approvalRequests // ignore: cast_nullable_to_non_nullable
as bool?,approvalRespond: freezed == approvalRespond ? _self.approvalRespond : approvalRespond // ignore: cast_nullable_to_non_nullable
as bool?,artifacts: freezed == artifacts ? _self.artifacts : artifacts // ignore: cast_nullable_to_non_nullable
as bool?,diffs: freezed == diffs ? _self.diffs : diffs // ignore: cast_nullable_to_non_nullable
as bool?,terminalPassthrough: freezed == terminalPassthrough ? _self.terminalPassthrough : terminalPassthrough // ignore: cast_nullable_to_non_nullable
as bool?,notifications: freezed == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as bool?,checkpoints: freezed == checkpoints ? _self.checkpoints : checkpoints // ignore: cast_nullable_to_non_nullable
as bool?,replay: freezed == replay ? _self.replay : replay // ignore: cast_nullable_to_non_nullable
as bool?,multiWorkspace: freezed == multiWorkspace ? _self.multiWorkspace : multiWorkspace // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$AscpHost {

 String get id; String get name; String? get platform; String? get arch; Map<String, Object?>? get labels; String? get status; List<String>? get transports;
/// Create a copy of AscpHost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpHostCopyWith<AscpHost> get copyWith => _$AscpHostCopyWithImpl<AscpHost>(this as AscpHost, _$identity);

  /// Serializes this AscpHost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpHost&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.arch, arch) || other.arch == arch)&&const DeepCollectionEquality().equals(other.labels, labels)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.transports, transports));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,platform,arch,const DeepCollectionEquality().hash(labels),status,const DeepCollectionEquality().hash(transports));

@override
String toString() {
  return 'AscpHost(id: $id, name: $name, platform: $platform, arch: $arch, labels: $labels, status: $status, transports: $transports)';
}


}

/// @nodoc
abstract mixin class $AscpHostCopyWith<$Res>  {
  factory $AscpHostCopyWith(AscpHost value, $Res Function(AscpHost) _then) = _$AscpHostCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? platform, String? arch, Map<String, Object?>? labels, String? status, List<String>? transports
});




}
/// @nodoc
class _$AscpHostCopyWithImpl<$Res>
    implements $AscpHostCopyWith<$Res> {
  _$AscpHostCopyWithImpl(this._self, this._then);

  final AscpHost _self;
  final $Res Function(AscpHost) _then;

/// Create a copy of AscpHost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? platform = freezed,Object? arch = freezed,Object? labels = freezed,Object? status = freezed,Object? transports = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,arch: freezed == arch ? _self.arch : arch // ignore: cast_nullable_to_non_nullable
as String?,labels: freezed == labels ? _self.labels : labels // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,transports: freezed == transports ? _self.transports : transports // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpHost].
extension AscpHostPatterns on AscpHost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpHost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpHost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpHost value)  $default,){
final _that = this;
switch (_that) {
case _AscpHost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpHost value)?  $default,){
final _that = this;
switch (_that) {
case _AscpHost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? platform,  String? arch,  Map<String, Object?>? labels,  String? status,  List<String>? transports)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpHost() when $default != null:
return $default(_that.id,_that.name,_that.platform,_that.arch,_that.labels,_that.status,_that.transports);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? platform,  String? arch,  Map<String, Object?>? labels,  String? status,  List<String>? transports)  $default,) {final _that = this;
switch (_that) {
case _AscpHost():
return $default(_that.id,_that.name,_that.platform,_that.arch,_that.labels,_that.status,_that.transports);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? platform,  String? arch,  Map<String, Object?>? labels,  String? status,  List<String>? transports)?  $default,) {final _that = this;
switch (_that) {
case _AscpHost() when $default != null:
return $default(_that.id,_that.name,_that.platform,_that.arch,_that.labels,_that.status,_that.transports);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpHost implements AscpHost {
  const _AscpHost({required this.id, required this.name, this.platform, this.arch, final  Map<String, Object?>? labels, this.status, final  List<String>? transports}): _labels = labels,_transports = transports;
  factory _AscpHost.fromJson(Map<String, dynamic> json) => _$AscpHostFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? platform;
@override final  String? arch;
 final  Map<String, Object?>? _labels;
@override Map<String, Object?>? get labels {
  final value = _labels;
  if (value == null) return null;
  if (_labels is EqualUnmodifiableMapView) return _labels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? status;
 final  List<String>? _transports;
@override List<String>? get transports {
  final value = _transports;
  if (value == null) return null;
  if (_transports is EqualUnmodifiableListView) return _transports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AscpHost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpHostCopyWith<_AscpHost> get copyWith => __$AscpHostCopyWithImpl<_AscpHost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpHostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpHost&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.arch, arch) || other.arch == arch)&&const DeepCollectionEquality().equals(other._labels, _labels)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._transports, _transports));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,platform,arch,const DeepCollectionEquality().hash(_labels),status,const DeepCollectionEquality().hash(_transports));

@override
String toString() {
  return 'AscpHost(id: $id, name: $name, platform: $platform, arch: $arch, labels: $labels, status: $status, transports: $transports)';
}


}

/// @nodoc
abstract mixin class _$AscpHostCopyWith<$Res> implements $AscpHostCopyWith<$Res> {
  factory _$AscpHostCopyWith(_AscpHost value, $Res Function(_AscpHost) _then) = __$AscpHostCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? platform, String? arch, Map<String, Object?>? labels, String? status, List<String>? transports
});




}
/// @nodoc
class __$AscpHostCopyWithImpl<$Res>
    implements _$AscpHostCopyWith<$Res> {
  __$AscpHostCopyWithImpl(this._self, this._then);

  final _AscpHost _self;
  final $Res Function(_AscpHost) _then;

/// Create a copy of AscpHost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? platform = freezed,Object? arch = freezed,Object? labels = freezed,Object? status = freezed,Object? transports = freezed,}) {
  return _then(_AscpHost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,arch: freezed == arch ? _self.arch : arch // ignore: cast_nullable_to_non_nullable
as String?,labels: freezed == labels ? _self._labels : labels // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,transports: freezed == transports ? _self._transports : transports // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$AscpRuntime {

 String get id; String get kind;@JsonKey(name: 'display_name') String get displayName; String get version;@JsonKey(name: 'adapter_kind') String? get adapterKind; AscpCapabilities? get capabilities;
/// Create a copy of AscpRuntime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpRuntimeCopyWith<AscpRuntime> get copyWith => _$AscpRuntimeCopyWithImpl<AscpRuntime>(this as AscpRuntime, _$identity);

  /// Serializes this AscpRuntime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpRuntime&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.version, version) || other.version == version)&&(identical(other.adapterKind, adapterKind) || other.adapterKind == adapterKind)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,displayName,version,adapterKind,capabilities);

@override
String toString() {
  return 'AscpRuntime(id: $id, kind: $kind, displayName: $displayName, version: $version, adapterKind: $adapterKind, capabilities: $capabilities)';
}


}

/// @nodoc
abstract mixin class $AscpRuntimeCopyWith<$Res>  {
  factory $AscpRuntimeCopyWith(AscpRuntime value, $Res Function(AscpRuntime) _then) = _$AscpRuntimeCopyWithImpl;
@useResult
$Res call({
 String id, String kind,@JsonKey(name: 'display_name') String displayName, String version,@JsonKey(name: 'adapter_kind') String? adapterKind, AscpCapabilities? capabilities
});


$AscpCapabilitiesCopyWith<$Res>? get capabilities;

}
/// @nodoc
class _$AscpRuntimeCopyWithImpl<$Res>
    implements $AscpRuntimeCopyWith<$Res> {
  _$AscpRuntimeCopyWithImpl(this._self, this._then);

  final AscpRuntime _self;
  final $Res Function(AscpRuntime) _then;

/// Create a copy of AscpRuntime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? displayName = null,Object? version = null,Object? adapterKind = freezed,Object? capabilities = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,adapterKind: freezed == adapterKind ? _self.adapterKind : adapterKind // ignore: cast_nullable_to_non_nullable
as String?,capabilities: freezed == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as AscpCapabilities?,
  ));
}
/// Create a copy of AscpRuntime
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpCapabilitiesCopyWith<$Res>? get capabilities {
    if (_self.capabilities == null) {
    return null;
  }

  return $AscpCapabilitiesCopyWith<$Res>(_self.capabilities!, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}
}


/// Adds pattern-matching-related methods to [AscpRuntime].
extension AscpRuntimePatterns on AscpRuntime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpRuntime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpRuntime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpRuntime value)  $default,){
final _that = this;
switch (_that) {
case _AscpRuntime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpRuntime value)?  $default,){
final _that = this;
switch (_that) {
case _AscpRuntime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String kind, @JsonKey(name: 'display_name')  String displayName,  String version, @JsonKey(name: 'adapter_kind')  String? adapterKind,  AscpCapabilities? capabilities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpRuntime() when $default != null:
return $default(_that.id,_that.kind,_that.displayName,_that.version,_that.adapterKind,_that.capabilities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String kind, @JsonKey(name: 'display_name')  String displayName,  String version, @JsonKey(name: 'adapter_kind')  String? adapterKind,  AscpCapabilities? capabilities)  $default,) {final _that = this;
switch (_that) {
case _AscpRuntime():
return $default(_that.id,_that.kind,_that.displayName,_that.version,_that.adapterKind,_that.capabilities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String kind, @JsonKey(name: 'display_name')  String displayName,  String version, @JsonKey(name: 'adapter_kind')  String? adapterKind,  AscpCapabilities? capabilities)?  $default,) {final _that = this;
switch (_that) {
case _AscpRuntime() when $default != null:
return $default(_that.id,_that.kind,_that.displayName,_that.version,_that.adapterKind,_that.capabilities);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpRuntime implements AscpRuntime {
  const _AscpRuntime({required this.id, required this.kind, @JsonKey(name: 'display_name') required this.displayName, required this.version, @JsonKey(name: 'adapter_kind') this.adapterKind, this.capabilities});
  factory _AscpRuntime.fromJson(Map<String, dynamic> json) => _$AscpRuntimeFromJson(json);

@override final  String id;
@override final  String kind;
@override@JsonKey(name: 'display_name') final  String displayName;
@override final  String version;
@override@JsonKey(name: 'adapter_kind') final  String? adapterKind;
@override final  AscpCapabilities? capabilities;

/// Create a copy of AscpRuntime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpRuntimeCopyWith<_AscpRuntime> get copyWith => __$AscpRuntimeCopyWithImpl<_AscpRuntime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpRuntimeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpRuntime&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.version, version) || other.version == version)&&(identical(other.adapterKind, adapterKind) || other.adapterKind == adapterKind)&&(identical(other.capabilities, capabilities) || other.capabilities == capabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,kind,displayName,version,adapterKind,capabilities);

@override
String toString() {
  return 'AscpRuntime(id: $id, kind: $kind, displayName: $displayName, version: $version, adapterKind: $adapterKind, capabilities: $capabilities)';
}


}

/// @nodoc
abstract mixin class _$AscpRuntimeCopyWith<$Res> implements $AscpRuntimeCopyWith<$Res> {
  factory _$AscpRuntimeCopyWith(_AscpRuntime value, $Res Function(_AscpRuntime) _then) = __$AscpRuntimeCopyWithImpl;
@override @useResult
$Res call({
 String id, String kind,@JsonKey(name: 'display_name') String displayName, String version,@JsonKey(name: 'adapter_kind') String? adapterKind, AscpCapabilities? capabilities
});


@override $AscpCapabilitiesCopyWith<$Res>? get capabilities;

}
/// @nodoc
class __$AscpRuntimeCopyWithImpl<$Res>
    implements _$AscpRuntimeCopyWith<$Res> {
  __$AscpRuntimeCopyWithImpl(this._self, this._then);

  final _AscpRuntime _self;
  final $Res Function(_AscpRuntime) _then;

/// Create a copy of AscpRuntime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? displayName = null,Object? version = null,Object? adapterKind = freezed,Object? capabilities = freezed,}) {
  return _then(_AscpRuntime(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,adapterKind: freezed == adapterKind ? _self.adapterKind : adapterKind // ignore: cast_nullable_to_non_nullable
as String?,capabilities: freezed == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as AscpCapabilities?,
  ));
}

/// Create a copy of AscpRuntime
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AscpCapabilitiesCopyWith<$Res>? get capabilities {
    if (_self.capabilities == null) {
    return null;
  }

  return $AscpCapabilitiesCopyWith<$Res>(_self.capabilities!, (value) {
    return _then(_self.copyWith(capabilities: value));
  });
}
}


/// @nodoc
mixin _$AscpSession {

 String get id;@JsonKey(name: 'runtime_id') String get runtimeId; String? get title; String? get workspace; String get status;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;@JsonKey(name: 'last_activity_at') String? get lastActivityAt; String? get summary;@JsonKey(name: 'active_run_id') String? get activeRunId; Map<String, Object?>? get metadata;
/// Create a copy of AscpSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpSessionCopyWith<AscpSession> get copyWith => _$AscpSessionCopyWithImpl<AscpSession>(this as AscpSession, _$identity);

  /// Serializes this AscpSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpSession&&(identical(other.id, id) || other.id == id)&&(identical(other.runtimeId, runtimeId) || other.runtimeId == runtimeId)&&(identical(other.title, title) || other.title == title)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.activeRunId, activeRunId) || other.activeRunId == activeRunId)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,runtimeId,title,workspace,status,createdAt,updatedAt,lastActivityAt,summary,activeRunId,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'AscpSession(id: $id, runtimeId: $runtimeId, title: $title, workspace: $workspace, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, lastActivityAt: $lastActivityAt, summary: $summary, activeRunId: $activeRunId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AscpSessionCopyWith<$Res>  {
  factory $AscpSessionCopyWith(AscpSession value, $Res Function(AscpSession) _then) = _$AscpSessionCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'runtime_id') String runtimeId, String? title, String? workspace, String status,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'last_activity_at') String? lastActivityAt, String? summary,@JsonKey(name: 'active_run_id') String? activeRunId, Map<String, Object?>? metadata
});




}
/// @nodoc
class _$AscpSessionCopyWithImpl<$Res>
    implements $AscpSessionCopyWith<$Res> {
  _$AscpSessionCopyWithImpl(this._self, this._then);

  final AscpSession _self;
  final $Res Function(AscpSession) _then;

/// Create a copy of AscpSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? runtimeId = null,Object? title = freezed,Object? workspace = freezed,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? lastActivityAt = freezed,Object? summary = freezed,Object? activeRunId = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,runtimeId: null == runtimeId ? _self.runtimeId : runtimeId // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,activeRunId: freezed == activeRunId ? _self.activeRunId : activeRunId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpSession].
extension AscpSessionPatterns on AscpSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpSession value)  $default,){
final _that = this;
switch (_that) {
case _AscpSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpSession value)?  $default,){
final _that = this;
switch (_that) {
case _AscpSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'runtime_id')  String runtimeId,  String? title,  String? workspace,  String status, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'last_activity_at')  String? lastActivityAt,  String? summary, @JsonKey(name: 'active_run_id')  String? activeRunId,  Map<String, Object?>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpSession() when $default != null:
return $default(_that.id,_that.runtimeId,_that.title,_that.workspace,_that.status,_that.createdAt,_that.updatedAt,_that.lastActivityAt,_that.summary,_that.activeRunId,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'runtime_id')  String runtimeId,  String? title,  String? workspace,  String status, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'last_activity_at')  String? lastActivityAt,  String? summary, @JsonKey(name: 'active_run_id')  String? activeRunId,  Map<String, Object?>? metadata)  $default,) {final _that = this;
switch (_that) {
case _AscpSession():
return $default(_that.id,_that.runtimeId,_that.title,_that.workspace,_that.status,_that.createdAt,_that.updatedAt,_that.lastActivityAt,_that.summary,_that.activeRunId,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'runtime_id')  String runtimeId,  String? title,  String? workspace,  String status, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'last_activity_at')  String? lastActivityAt,  String? summary, @JsonKey(name: 'active_run_id')  String? activeRunId,  Map<String, Object?>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _AscpSession() when $default != null:
return $default(_that.id,_that.runtimeId,_that.title,_that.workspace,_that.status,_that.createdAt,_that.updatedAt,_that.lastActivityAt,_that.summary,_that.activeRunId,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpSession implements AscpSession {
  const _AscpSession({required this.id, @JsonKey(name: 'runtime_id') required this.runtimeId, this.title, this.workspace, required this.status, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'last_activity_at') this.lastActivityAt, this.summary, @JsonKey(name: 'active_run_id') this.activeRunId, final  Map<String, Object?>? metadata}): _metadata = metadata;
  factory _AscpSession.fromJson(Map<String, dynamic> json) => _$AscpSessionFromJson(json);

@override final  String id;
@override@JsonKey(name: 'runtime_id') final  String runtimeId;
@override final  String? title;
@override final  String? workspace;
@override final  String status;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override@JsonKey(name: 'last_activity_at') final  String? lastActivityAt;
@override final  String? summary;
@override@JsonKey(name: 'active_run_id') final  String? activeRunId;
 final  Map<String, Object?>? _metadata;
@override Map<String, Object?>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AscpSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpSessionCopyWith<_AscpSession> get copyWith => __$AscpSessionCopyWithImpl<_AscpSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpSession&&(identical(other.id, id) || other.id == id)&&(identical(other.runtimeId, runtimeId) || other.runtimeId == runtimeId)&&(identical(other.title, title) || other.title == title)&&(identical(other.workspace, workspace) || other.workspace == workspace)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.activeRunId, activeRunId) || other.activeRunId == activeRunId)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,runtimeId,title,workspace,status,createdAt,updatedAt,lastActivityAt,summary,activeRunId,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'AscpSession(id: $id, runtimeId: $runtimeId, title: $title, workspace: $workspace, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, lastActivityAt: $lastActivityAt, summary: $summary, activeRunId: $activeRunId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AscpSessionCopyWith<$Res> implements $AscpSessionCopyWith<$Res> {
  factory _$AscpSessionCopyWith(_AscpSession value, $Res Function(_AscpSession) _then) = __$AscpSessionCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'runtime_id') String runtimeId, String? title, String? workspace, String status,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'last_activity_at') String? lastActivityAt, String? summary,@JsonKey(name: 'active_run_id') String? activeRunId, Map<String, Object?>? metadata
});




}
/// @nodoc
class __$AscpSessionCopyWithImpl<$Res>
    implements _$AscpSessionCopyWith<$Res> {
  __$AscpSessionCopyWithImpl(this._self, this._then);

  final _AscpSession _self;
  final $Res Function(_AscpSession) _then;

/// Create a copy of AscpSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? runtimeId = null,Object? title = freezed,Object? workspace = freezed,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? lastActivityAt = freezed,Object? summary = freezed,Object? activeRunId = freezed,Object? metadata = freezed,}) {
  return _then(_AscpSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,runtimeId: null == runtimeId ? _self.runtimeId : runtimeId // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,workspace: freezed == workspace ? _self.workspace : workspace // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,lastActivityAt: freezed == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as String?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,activeRunId: freezed == activeRunId ? _self.activeRunId : activeRunId // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}


}


/// @nodoc
mixin _$AscpRun {

 String get id;@JsonKey(name: 'session_id') String get sessionId; String get status;@JsonKey(name: 'started_at') String get startedAt;@JsonKey(name: 'ended_at') String? get endedAt;@JsonKey(name: 'exit_code') int? get exitCode;
/// Create a copy of AscpRun
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpRunCopyWith<AscpRun> get copyWith => _$AscpRunCopyWithImpl<AscpRun>(this as AscpRun, _$identity);

  /// Serializes this AscpRun to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpRun&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,status,startedAt,endedAt,exitCode);

@override
String toString() {
  return 'AscpRun(id: $id, sessionId: $sessionId, status: $status, startedAt: $startedAt, endedAt: $endedAt, exitCode: $exitCode)';
}


}

/// @nodoc
abstract mixin class $AscpRunCopyWith<$Res>  {
  factory $AscpRunCopyWith(AscpRun value, $Res Function(AscpRun) _then) = _$AscpRunCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'session_id') String sessionId, String status,@JsonKey(name: 'started_at') String startedAt,@JsonKey(name: 'ended_at') String? endedAt,@JsonKey(name: 'exit_code') int? exitCode
});




}
/// @nodoc
class _$AscpRunCopyWithImpl<$Res>
    implements $AscpRunCopyWith<$Res> {
  _$AscpRunCopyWithImpl(this._self, this._then);

  final AscpRun _self;
  final $Res Function(AscpRun) _then;

/// Create a copy of AscpRun
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? exitCode = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as String?,exitCode: freezed == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpRun].
extension AscpRunPatterns on AscpRun {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpRun value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpRun() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpRun value)  $default,){
final _that = this;
switch (_that) {
case _AscpRun():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpRun value)?  $default,){
final _that = this;
switch (_that) {
case _AscpRun() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'session_id')  String sessionId,  String status, @JsonKey(name: 'started_at')  String startedAt, @JsonKey(name: 'ended_at')  String? endedAt, @JsonKey(name: 'exit_code')  int? exitCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpRun() when $default != null:
return $default(_that.id,_that.sessionId,_that.status,_that.startedAt,_that.endedAt,_that.exitCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'session_id')  String sessionId,  String status, @JsonKey(name: 'started_at')  String startedAt, @JsonKey(name: 'ended_at')  String? endedAt, @JsonKey(name: 'exit_code')  int? exitCode)  $default,) {final _that = this;
switch (_that) {
case _AscpRun():
return $default(_that.id,_that.sessionId,_that.status,_that.startedAt,_that.endedAt,_that.exitCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'session_id')  String sessionId,  String status, @JsonKey(name: 'started_at')  String startedAt, @JsonKey(name: 'ended_at')  String? endedAt, @JsonKey(name: 'exit_code')  int? exitCode)?  $default,) {final _that = this;
switch (_that) {
case _AscpRun() when $default != null:
return $default(_that.id,_that.sessionId,_that.status,_that.startedAt,_that.endedAt,_that.exitCode);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpRun implements AscpRun {
  const _AscpRun({required this.id, @JsonKey(name: 'session_id') required this.sessionId, required this.status, @JsonKey(name: 'started_at') required this.startedAt, @JsonKey(name: 'ended_at') this.endedAt, @JsonKey(name: 'exit_code') this.exitCode});
  factory _AscpRun.fromJson(Map<String, dynamic> json) => _$AscpRunFromJson(json);

@override final  String id;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override final  String status;
@override@JsonKey(name: 'started_at') final  String startedAt;
@override@JsonKey(name: 'ended_at') final  String? endedAt;
@override@JsonKey(name: 'exit_code') final  int? exitCode;

/// Create a copy of AscpRun
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpRunCopyWith<_AscpRun> get copyWith => __$AscpRunCopyWithImpl<_AscpRun>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpRunToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpRun&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.exitCode, exitCode) || other.exitCode == exitCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,status,startedAt,endedAt,exitCode);

@override
String toString() {
  return 'AscpRun(id: $id, sessionId: $sessionId, status: $status, startedAt: $startedAt, endedAt: $endedAt, exitCode: $exitCode)';
}


}

/// @nodoc
abstract mixin class _$AscpRunCopyWith<$Res> implements $AscpRunCopyWith<$Res> {
  factory _$AscpRunCopyWith(_AscpRun value, $Res Function(_AscpRun) _then) = __$AscpRunCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'session_id') String sessionId, String status,@JsonKey(name: 'started_at') String startedAt,@JsonKey(name: 'ended_at') String? endedAt,@JsonKey(name: 'exit_code') int? exitCode
});




}
/// @nodoc
class __$AscpRunCopyWithImpl<$Res>
    implements _$AscpRunCopyWith<$Res> {
  __$AscpRunCopyWithImpl(this._self, this._then);

  final _AscpRun _self;
  final $Res Function(_AscpRun) _then;

/// Create a copy of AscpRun
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? exitCode = freezed,}) {
  return _then(_AscpRun(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as String?,exitCode: freezed == exitCode ? _self.exitCode : exitCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AscpApprovalRequest {

 String get id;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'run_id') String? get runId; String get kind; String get status; String? get title; String? get description;@JsonKey(name: 'risk_level') String? get riskLevel; Map<String, Object?>? get payload;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'resolved_at') String? get resolvedAt;
/// Create a copy of AscpApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpApprovalRequestCopyWith<AscpApprovalRequest> get copyWith => _$AscpApprovalRequestCopyWithImpl<AscpApprovalRequest>(this as AscpApprovalRequest, _$identity);

  /// Serializes this AscpApprovalRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpApprovalRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.riskLevel, riskLevel) || other.riskLevel == riskLevel)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,runId,kind,status,title,description,riskLevel,const DeepCollectionEquality().hash(payload),createdAt,resolvedAt);

@override
String toString() {
  return 'AscpApprovalRequest(id: $id, sessionId: $sessionId, runId: $runId, kind: $kind, status: $status, title: $title, description: $description, riskLevel: $riskLevel, payload: $payload, createdAt: $createdAt, resolvedAt: $resolvedAt)';
}


}

/// @nodoc
abstract mixin class $AscpApprovalRequestCopyWith<$Res>  {
  factory $AscpApprovalRequestCopyWith(AscpApprovalRequest value, $Res Function(AscpApprovalRequest) _then) = _$AscpApprovalRequestCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, String kind, String status, String? title, String? description,@JsonKey(name: 'risk_level') String? riskLevel, Map<String, Object?>? payload,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'resolved_at') String? resolvedAt
});




}
/// @nodoc
class _$AscpApprovalRequestCopyWithImpl<$Res>
    implements $AscpApprovalRequestCopyWith<$Res> {
  _$AscpApprovalRequestCopyWithImpl(this._self, this._then);

  final AscpApprovalRequest _self;
  final $Res Function(AscpApprovalRequest) _then;

/// Create a copy of AscpApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? runId = freezed,Object? kind = null,Object? status = null,Object? title = freezed,Object? description = freezed,Object? riskLevel = freezed,Object? payload = freezed,Object? createdAt = null,Object? resolvedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,riskLevel: freezed == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpApprovalRequest].
extension AscpApprovalRequestPatterns on AscpApprovalRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpApprovalRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpApprovalRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpApprovalRequest value)  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpApprovalRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AscpApprovalRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  String kind,  String status,  String? title,  String? description, @JsonKey(name: 'risk_level')  String? riskLevel,  Map<String, Object?>? payload, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'resolved_at')  String? resolvedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpApprovalRequest() when $default != null:
return $default(_that.id,_that.sessionId,_that.runId,_that.kind,_that.status,_that.title,_that.description,_that.riskLevel,_that.payload,_that.createdAt,_that.resolvedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  String kind,  String status,  String? title,  String? description, @JsonKey(name: 'risk_level')  String? riskLevel,  Map<String, Object?>? payload, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'resolved_at')  String? resolvedAt)  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalRequest():
return $default(_that.id,_that.sessionId,_that.runId,_that.kind,_that.status,_that.title,_that.description,_that.riskLevel,_that.payload,_that.createdAt,_that.resolvedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  String kind,  String status,  String? title,  String? description, @JsonKey(name: 'risk_level')  String? riskLevel,  Map<String, Object?>? payload, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'resolved_at')  String? resolvedAt)?  $default,) {final _that = this;
switch (_that) {
case _AscpApprovalRequest() when $default != null:
return $default(_that.id,_that.sessionId,_that.runId,_that.kind,_that.status,_that.title,_that.description,_that.riskLevel,_that.payload,_that.createdAt,_that.resolvedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpApprovalRequest implements AscpApprovalRequest {
  const _AscpApprovalRequest({required this.id, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'run_id') this.runId, required this.kind, required this.status, this.title, this.description, @JsonKey(name: 'risk_level') this.riskLevel, final  Map<String, Object?>? payload, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'resolved_at') this.resolvedAt}): _payload = payload;
  factory _AscpApprovalRequest.fromJson(Map<String, dynamic> json) => _$AscpApprovalRequestFromJson(json);

@override final  String id;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'run_id') final  String? runId;
@override final  String kind;
@override final  String status;
@override final  String? title;
@override final  String? description;
@override@JsonKey(name: 'risk_level') final  String? riskLevel;
 final  Map<String, Object?>? _payload;
@override Map<String, Object?>? get payload {
  final value = _payload;
  if (value == null) return null;
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'resolved_at') final  String? resolvedAt;

/// Create a copy of AscpApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpApprovalRequestCopyWith<_AscpApprovalRequest> get copyWith => __$AscpApprovalRequestCopyWithImpl<_AscpApprovalRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpApprovalRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpApprovalRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.riskLevel, riskLevel) || other.riskLevel == riskLevel)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,runId,kind,status,title,description,riskLevel,const DeepCollectionEquality().hash(_payload),createdAt,resolvedAt);

@override
String toString() {
  return 'AscpApprovalRequest(id: $id, sessionId: $sessionId, runId: $runId, kind: $kind, status: $status, title: $title, description: $description, riskLevel: $riskLevel, payload: $payload, createdAt: $createdAt, resolvedAt: $resolvedAt)';
}


}

/// @nodoc
abstract mixin class _$AscpApprovalRequestCopyWith<$Res> implements $AscpApprovalRequestCopyWith<$Res> {
  factory _$AscpApprovalRequestCopyWith(_AscpApprovalRequest value, $Res Function(_AscpApprovalRequest) _then) = __$AscpApprovalRequestCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, String kind, String status, String? title, String? description,@JsonKey(name: 'risk_level') String? riskLevel, Map<String, Object?>? payload,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'resolved_at') String? resolvedAt
});




}
/// @nodoc
class __$AscpApprovalRequestCopyWithImpl<$Res>
    implements _$AscpApprovalRequestCopyWith<$Res> {
  __$AscpApprovalRequestCopyWithImpl(this._self, this._then);

  final _AscpApprovalRequest _self;
  final $Res Function(_AscpApprovalRequest) _then;

/// Create a copy of AscpApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? runId = freezed,Object? kind = null,Object? status = null,Object? title = freezed,Object? description = freezed,Object? riskLevel = freezed,Object? payload = freezed,Object? createdAt = null,Object? resolvedAt = freezed,}) {
  return _then(_AscpApprovalRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,riskLevel: freezed == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AscpArtifact {

 String get id;@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'run_id') String? get runId; String get kind; String? get name; String? get uri;@JsonKey(name: 'mime_type') String? get mimeType;@JsonKey(name: 'size_bytes') int? get sizeBytes;@JsonKey(name: 'created_at') String get createdAt; Map<String, Object?>? get metadata;
/// Create a copy of AscpArtifact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpArtifactCopyWith<AscpArtifact> get copyWith => _$AscpArtifactCopyWithImpl<AscpArtifact>(this as AscpArtifact, _$identity);

  /// Serializes this AscpArtifact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpArtifact&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,runId,kind,name,uri,mimeType,sizeBytes,createdAt,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'AscpArtifact(id: $id, sessionId: $sessionId, runId: $runId, kind: $kind, name: $name, uri: $uri, mimeType: $mimeType, sizeBytes: $sizeBytes, createdAt: $createdAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AscpArtifactCopyWith<$Res>  {
  factory $AscpArtifactCopyWith(AscpArtifact value, $Res Function(AscpArtifact) _then) = _$AscpArtifactCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, String kind, String? name, String? uri,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'size_bytes') int? sizeBytes,@JsonKey(name: 'created_at') String createdAt, Map<String, Object?>? metadata
});




}
/// @nodoc
class _$AscpArtifactCopyWithImpl<$Res>
    implements $AscpArtifactCopyWith<$Res> {
  _$AscpArtifactCopyWithImpl(this._self, this._then);

  final AscpArtifact _self;
  final $Res Function(AscpArtifact) _then;

/// Create a copy of AscpArtifact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? runId = freezed,Object? kind = null,Object? name = freezed,Object? uri = freezed,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? createdAt = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpArtifact].
extension AscpArtifactPatterns on AscpArtifact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpArtifact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpArtifact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpArtifact value)  $default,){
final _that = this;
switch (_that) {
case _AscpArtifact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpArtifact value)?  $default,){
final _that = this;
switch (_that) {
case _AscpArtifact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  String kind,  String? name,  String? uri, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'size_bytes')  int? sizeBytes, @JsonKey(name: 'created_at')  String createdAt,  Map<String, Object?>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpArtifact() when $default != null:
return $default(_that.id,_that.sessionId,_that.runId,_that.kind,_that.name,_that.uri,_that.mimeType,_that.sizeBytes,_that.createdAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  String kind,  String? name,  String? uri, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'size_bytes')  int? sizeBytes, @JsonKey(name: 'created_at')  String createdAt,  Map<String, Object?>? metadata)  $default,) {final _that = this;
switch (_that) {
case _AscpArtifact():
return $default(_that.id,_that.sessionId,_that.runId,_that.kind,_that.name,_that.uri,_that.mimeType,_that.sizeBytes,_that.createdAt,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId,  String kind,  String? name,  String? uri, @JsonKey(name: 'mime_type')  String? mimeType, @JsonKey(name: 'size_bytes')  int? sizeBytes, @JsonKey(name: 'created_at')  String createdAt,  Map<String, Object?>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _AscpArtifact() when $default != null:
return $default(_that.id,_that.sessionId,_that.runId,_that.kind,_that.name,_that.uri,_that.mimeType,_that.sizeBytes,_that.createdAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpArtifact implements AscpArtifact {
  const _AscpArtifact({required this.id, @JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'run_id') this.runId, required this.kind, this.name, this.uri, @JsonKey(name: 'mime_type') this.mimeType, @JsonKey(name: 'size_bytes') this.sizeBytes, @JsonKey(name: 'created_at') required this.createdAt, final  Map<String, Object?>? metadata}): _metadata = metadata;
  factory _AscpArtifact.fromJson(Map<String, dynamic> json) => _$AscpArtifactFromJson(json);

@override final  String id;
@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'run_id') final  String? runId;
@override final  String kind;
@override final  String? name;
@override final  String? uri;
@override@JsonKey(name: 'mime_type') final  String? mimeType;
@override@JsonKey(name: 'size_bytes') final  int? sizeBytes;
@override@JsonKey(name: 'created_at') final  String createdAt;
 final  Map<String, Object?>? _metadata;
@override Map<String, Object?>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AscpArtifact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpArtifactCopyWith<_AscpArtifact> get copyWith => __$AscpArtifactCopyWithImpl<_AscpArtifact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpArtifactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpArtifact&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.name, name) || other.name == name)&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,runId,kind,name,uri,mimeType,sizeBytes,createdAt,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'AscpArtifact(id: $id, sessionId: $sessionId, runId: $runId, kind: $kind, name: $name, uri: $uri, mimeType: $mimeType, sizeBytes: $sizeBytes, createdAt: $createdAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AscpArtifactCopyWith<$Res> implements $AscpArtifactCopyWith<$Res> {
  factory _$AscpArtifactCopyWith(_AscpArtifact value, $Res Function(_AscpArtifact) _then) = __$AscpArtifactCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId, String kind, String? name, String? uri,@JsonKey(name: 'mime_type') String? mimeType,@JsonKey(name: 'size_bytes') int? sizeBytes,@JsonKey(name: 'created_at') String createdAt, Map<String, Object?>? metadata
});




}
/// @nodoc
class __$AscpArtifactCopyWithImpl<$Res>
    implements _$AscpArtifactCopyWith<$Res> {
  __$AscpArtifactCopyWithImpl(this._self, this._then);

  final _AscpArtifact _self;
  final $Res Function(_AscpArtifact) _then;

/// Create a copy of AscpArtifact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? runId = freezed,Object? kind = null,Object? name = freezed,Object? uri = freezed,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? createdAt = null,Object? metadata = freezed,}) {
  return _then(_AscpArtifact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,uri: freezed == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>?,
  ));
}


}


/// @nodoc
mixin _$AscpDiffFile {

 String get path;@JsonKey(name: 'change_type') String get changeType; int? get insertions; int? get deletions;
/// Create a copy of AscpDiffFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpDiffFileCopyWith<AscpDiffFile> get copyWith => _$AscpDiffFileCopyWithImpl<AscpDiffFile>(this as AscpDiffFile, _$identity);

  /// Serializes this AscpDiffFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpDiffFile&&(identical(other.path, path) || other.path == path)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.insertions, insertions) || other.insertions == insertions)&&(identical(other.deletions, deletions) || other.deletions == deletions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,changeType,insertions,deletions);

@override
String toString() {
  return 'AscpDiffFile(path: $path, changeType: $changeType, insertions: $insertions, deletions: $deletions)';
}


}

/// @nodoc
abstract mixin class $AscpDiffFileCopyWith<$Res>  {
  factory $AscpDiffFileCopyWith(AscpDiffFile value, $Res Function(AscpDiffFile) _then) = _$AscpDiffFileCopyWithImpl;
@useResult
$Res call({
 String path,@JsonKey(name: 'change_type') String changeType, int? insertions, int? deletions
});




}
/// @nodoc
class _$AscpDiffFileCopyWithImpl<$Res>
    implements $AscpDiffFileCopyWith<$Res> {
  _$AscpDiffFileCopyWithImpl(this._self, this._then);

  final AscpDiffFile _self;
  final $Res Function(AscpDiffFile) _then;

/// Create a copy of AscpDiffFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? changeType = null,Object? insertions = freezed,Object? deletions = freezed,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String,insertions: freezed == insertions ? _self.insertions : insertions // ignore: cast_nullable_to_non_nullable
as int?,deletions: freezed == deletions ? _self.deletions : deletions // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpDiffFile].
extension AscpDiffFilePatterns on AscpDiffFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpDiffFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpDiffFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpDiffFile value)  $default,){
final _that = this;
switch (_that) {
case _AscpDiffFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpDiffFile value)?  $default,){
final _that = this;
switch (_that) {
case _AscpDiffFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path, @JsonKey(name: 'change_type')  String changeType,  int? insertions,  int? deletions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpDiffFile() when $default != null:
return $default(_that.path,_that.changeType,_that.insertions,_that.deletions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path, @JsonKey(name: 'change_type')  String changeType,  int? insertions,  int? deletions)  $default,) {final _that = this;
switch (_that) {
case _AscpDiffFile():
return $default(_that.path,_that.changeType,_that.insertions,_that.deletions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path, @JsonKey(name: 'change_type')  String changeType,  int? insertions,  int? deletions)?  $default,) {final _that = this;
switch (_that) {
case _AscpDiffFile() when $default != null:
return $default(_that.path,_that.changeType,_that.insertions,_that.deletions);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpDiffFile implements AscpDiffFile {
  const _AscpDiffFile({required this.path, @JsonKey(name: 'change_type') required this.changeType, this.insertions, this.deletions});
  factory _AscpDiffFile.fromJson(Map<String, dynamic> json) => _$AscpDiffFileFromJson(json);

@override final  String path;
@override@JsonKey(name: 'change_type') final  String changeType;
@override final  int? insertions;
@override final  int? deletions;

/// Create a copy of AscpDiffFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpDiffFileCopyWith<_AscpDiffFile> get copyWith => __$AscpDiffFileCopyWithImpl<_AscpDiffFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpDiffFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpDiffFile&&(identical(other.path, path) || other.path == path)&&(identical(other.changeType, changeType) || other.changeType == changeType)&&(identical(other.insertions, insertions) || other.insertions == insertions)&&(identical(other.deletions, deletions) || other.deletions == deletions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,changeType,insertions,deletions);

@override
String toString() {
  return 'AscpDiffFile(path: $path, changeType: $changeType, insertions: $insertions, deletions: $deletions)';
}


}

/// @nodoc
abstract mixin class _$AscpDiffFileCopyWith<$Res> implements $AscpDiffFileCopyWith<$Res> {
  factory _$AscpDiffFileCopyWith(_AscpDiffFile value, $Res Function(_AscpDiffFile) _then) = __$AscpDiffFileCopyWithImpl;
@override @useResult
$Res call({
 String path,@JsonKey(name: 'change_type') String changeType, int? insertions, int? deletions
});




}
/// @nodoc
class __$AscpDiffFileCopyWithImpl<$Res>
    implements _$AscpDiffFileCopyWith<$Res> {
  __$AscpDiffFileCopyWithImpl(this._self, this._then);

  final _AscpDiffFile _self;
  final $Res Function(_AscpDiffFile) _then;

/// Create a copy of AscpDiffFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? changeType = null,Object? insertions = freezed,Object? deletions = freezed,}) {
  return _then(_AscpDiffFile(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,changeType: null == changeType ? _self.changeType : changeType // ignore: cast_nullable_to_non_nullable
as String,insertions: freezed == insertions ? _self.insertions : insertions // ignore: cast_nullable_to_non_nullable
as int?,deletions: freezed == deletions ? _self.deletions : deletions // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$AscpDiffSummary {

@JsonKey(name: 'session_id') String get sessionId;@JsonKey(name: 'run_id') String? get runId;@JsonKey(name: 'files_changed') int get filesChanged; int? get insertions; int? get deletions; List<AscpDiffFile>? get files;
/// Create a copy of AscpDiffSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AscpDiffSummaryCopyWith<AscpDiffSummary> get copyWith => _$AscpDiffSummaryCopyWithImpl<AscpDiffSummary>(this as AscpDiffSummary, _$identity);

  /// Serializes this AscpDiffSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AscpDiffSummary&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.filesChanged, filesChanged) || other.filesChanged == filesChanged)&&(identical(other.insertions, insertions) || other.insertions == insertions)&&(identical(other.deletions, deletions) || other.deletions == deletions)&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,runId,filesChanged,insertions,deletions,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'AscpDiffSummary(sessionId: $sessionId, runId: $runId, filesChanged: $filesChanged, insertions: $insertions, deletions: $deletions, files: $files)';
}


}

/// @nodoc
abstract mixin class $AscpDiffSummaryCopyWith<$Res>  {
  factory $AscpDiffSummaryCopyWith(AscpDiffSummary value, $Res Function(AscpDiffSummary) _then) = _$AscpDiffSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId,@JsonKey(name: 'files_changed') int filesChanged, int? insertions, int? deletions, List<AscpDiffFile>? files
});




}
/// @nodoc
class _$AscpDiffSummaryCopyWithImpl<$Res>
    implements $AscpDiffSummaryCopyWith<$Res> {
  _$AscpDiffSummaryCopyWithImpl(this._self, this._then);

  final AscpDiffSummary _self;
  final $Res Function(AscpDiffSummary) _then;

/// Create a copy of AscpDiffSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? runId = freezed,Object? filesChanged = null,Object? insertions = freezed,Object? deletions = freezed,Object? files = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,filesChanged: null == filesChanged ? _self.filesChanged : filesChanged // ignore: cast_nullable_to_non_nullable
as int,insertions: freezed == insertions ? _self.insertions : insertions // ignore: cast_nullable_to_non_nullable
as int?,deletions: freezed == deletions ? _self.deletions : deletions // ignore: cast_nullable_to_non_nullable
as int?,files: freezed == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<AscpDiffFile>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AscpDiffSummary].
extension AscpDiffSummaryPatterns on AscpDiffSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AscpDiffSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AscpDiffSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AscpDiffSummary value)  $default,){
final _that = this;
switch (_that) {
case _AscpDiffSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AscpDiffSummary value)?  $default,){
final _that = this;
switch (_that) {
case _AscpDiffSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId, @JsonKey(name: 'files_changed')  int filesChanged,  int? insertions,  int? deletions,  List<AscpDiffFile>? files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AscpDiffSummary() when $default != null:
return $default(_that.sessionId,_that.runId,_that.filesChanged,_that.insertions,_that.deletions,_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId, @JsonKey(name: 'files_changed')  int filesChanged,  int? insertions,  int? deletions,  List<AscpDiffFile>? files)  $default,) {final _that = this;
switch (_that) {
case _AscpDiffSummary():
return $default(_that.sessionId,_that.runId,_that.filesChanged,_that.insertions,_that.deletions,_that.files);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'session_id')  String sessionId, @JsonKey(name: 'run_id')  String? runId, @JsonKey(name: 'files_changed')  int filesChanged,  int? insertions,  int? deletions,  List<AscpDiffFile>? files)?  $default,) {final _that = this;
switch (_that) {
case _AscpDiffSummary() when $default != null:
return $default(_that.sessionId,_that.runId,_that.filesChanged,_that.insertions,_that.deletions,_that.files);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AscpDiffSummary implements AscpDiffSummary {
  const _AscpDiffSummary({@JsonKey(name: 'session_id') required this.sessionId, @JsonKey(name: 'run_id') this.runId, @JsonKey(name: 'files_changed') required this.filesChanged, this.insertions, this.deletions, final  List<AscpDiffFile>? files}): _files = files;
  factory _AscpDiffSummary.fromJson(Map<String, dynamic> json) => _$AscpDiffSummaryFromJson(json);

@override@JsonKey(name: 'session_id') final  String sessionId;
@override@JsonKey(name: 'run_id') final  String? runId;
@override@JsonKey(name: 'files_changed') final  int filesChanged;
@override final  int? insertions;
@override final  int? deletions;
 final  List<AscpDiffFile>? _files;
@override List<AscpDiffFile>? get files {
  final value = _files;
  if (value == null) return null;
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AscpDiffSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AscpDiffSummaryCopyWith<_AscpDiffSummary> get copyWith => __$AscpDiffSummaryCopyWithImpl<_AscpDiffSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AscpDiffSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AscpDiffSummary&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.filesChanged, filesChanged) || other.filesChanged == filesChanged)&&(identical(other.insertions, insertions) || other.insertions == insertions)&&(identical(other.deletions, deletions) || other.deletions == deletions)&&const DeepCollectionEquality().equals(other._files, _files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,runId,filesChanged,insertions,deletions,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'AscpDiffSummary(sessionId: $sessionId, runId: $runId, filesChanged: $filesChanged, insertions: $insertions, deletions: $deletions, files: $files)';
}


}

/// @nodoc
abstract mixin class _$AscpDiffSummaryCopyWith<$Res> implements $AscpDiffSummaryCopyWith<$Res> {
  factory _$AscpDiffSummaryCopyWith(_AscpDiffSummary value, $Res Function(_AscpDiffSummary) _then) = __$AscpDiffSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'session_id') String sessionId,@JsonKey(name: 'run_id') String? runId,@JsonKey(name: 'files_changed') int filesChanged, int? insertions, int? deletions, List<AscpDiffFile>? files
});




}
/// @nodoc
class __$AscpDiffSummaryCopyWithImpl<$Res>
    implements _$AscpDiffSummaryCopyWith<$Res> {
  __$AscpDiffSummaryCopyWithImpl(this._self, this._then);

  final _AscpDiffSummary _self;
  final $Res Function(_AscpDiffSummary) _then;

/// Create a copy of AscpDiffSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? runId = freezed,Object? filesChanged = null,Object? insertions = freezed,Object? deletions = freezed,Object? files = freezed,}) {
  return _then(_AscpDiffSummary(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,runId: freezed == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String?,filesChanged: null == filesChanged ? _self.filesChanged : filesChanged // ignore: cast_nullable_to_non_nullable
as int,insertions: freezed == insertions ? _self.insertions : insertions // ignore: cast_nullable_to_non_nullable
as int?,deletions: freezed == deletions ? _self.deletions : deletions // ignore: cast_nullable_to_non_nullable
as int?,files: freezed == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<AscpDiffFile>?,
  ));
}


}

// dart format on
