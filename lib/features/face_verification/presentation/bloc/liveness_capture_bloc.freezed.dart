// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'liveness_capture_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LivenessCaptureState {

 LivenessCaptureStatus get status; FaceSession? get session; int get stepIndex;/// Best photo per challenge, keyed by the challenge name.
 Map<String, String> get captured;/// Live guidance for the current pose.
 PoseHint? get hint; String? get rejectReason; bool get canRetry; Failure? get failure;
/// Create a copy of LivenessCaptureState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LivenessCaptureStateCopyWith<LivenessCaptureState> get copyWith => _$LivenessCaptureStateCopyWithImpl<LivenessCaptureState>(this as LivenessCaptureState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LivenessCaptureState&&(identical(other.status, status) || other.status == status)&&(identical(other.session, session) || other.session == session)&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&const DeepCollectionEquality().equals(other.captured, captured)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,session,stepIndex,const DeepCollectionEquality().hash(captured),hint,rejectReason,canRetry,failure);

@override
String toString() {
  return 'LivenessCaptureState(status: $status, session: $session, stepIndex: $stepIndex, captured: $captured, hint: $hint, rejectReason: $rejectReason, canRetry: $canRetry, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $LivenessCaptureStateCopyWith<$Res>  {
  factory $LivenessCaptureStateCopyWith(LivenessCaptureState value, $Res Function(LivenessCaptureState) _then) = _$LivenessCaptureStateCopyWithImpl;
@useResult
$Res call({
 LivenessCaptureStatus status, FaceSession? session, int stepIndex, Map<String, String> captured, PoseHint? hint, String? rejectReason, bool canRetry, Failure? failure
});


$FaceSessionCopyWith<$Res>? get session;

}
/// @nodoc
class _$LivenessCaptureStateCopyWithImpl<$Res>
    implements $LivenessCaptureStateCopyWith<$Res> {
  _$LivenessCaptureStateCopyWithImpl(this._self, this._then);

  final LivenessCaptureState _self;
  final $Res Function(LivenessCaptureState) _then;

/// Create a copy of LivenessCaptureState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? session = freezed,Object? stepIndex = null,Object? captured = null,Object? hint = freezed,Object? rejectReason = freezed,Object? canRetry = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LivenessCaptureStatus,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as FaceSession?,stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,captured: null == captured ? _self.captured : captured // ignore: cast_nullable_to_non_nullable
as Map<String, String>,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as PoseHint?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of LivenessCaptureState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FaceSessionCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $FaceSessionCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [LivenessCaptureState].
extension LivenessCaptureStatePatterns on LivenessCaptureState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LivenessCaptureState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LivenessCaptureState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LivenessCaptureState value)  $default,){
final _that = this;
switch (_that) {
case _LivenessCaptureState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LivenessCaptureState value)?  $default,){
final _that = this;
switch (_that) {
case _LivenessCaptureState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LivenessCaptureStatus status,  FaceSession? session,  int stepIndex,  Map<String, String> captured,  PoseHint? hint,  String? rejectReason,  bool canRetry,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LivenessCaptureState() when $default != null:
return $default(_that.status,_that.session,_that.stepIndex,_that.captured,_that.hint,_that.rejectReason,_that.canRetry,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LivenessCaptureStatus status,  FaceSession? session,  int stepIndex,  Map<String, String> captured,  PoseHint? hint,  String? rejectReason,  bool canRetry,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _LivenessCaptureState():
return $default(_that.status,_that.session,_that.stepIndex,_that.captured,_that.hint,_that.rejectReason,_that.canRetry,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LivenessCaptureStatus status,  FaceSession? session,  int stepIndex,  Map<String, String> captured,  PoseHint? hint,  String? rejectReason,  bool canRetry,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _LivenessCaptureState() when $default != null:
return $default(_that.status,_that.session,_that.stepIndex,_that.captured,_that.hint,_that.rejectReason,_that.canRetry,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _LivenessCaptureState extends LivenessCaptureState {
  const _LivenessCaptureState({this.status = LivenessCaptureStatus.requestingPermission, this.session, this.stepIndex = 0, final  Map<String, String> captured = const <String, String>{}, this.hint, this.rejectReason, this.canRetry = true, this.failure}): _captured = captured,super._();
  

@override@JsonKey() final  LivenessCaptureStatus status;
@override final  FaceSession? session;
@override@JsonKey() final  int stepIndex;
/// Best photo per challenge, keyed by the challenge name.
 final  Map<String, String> _captured;
/// Best photo per challenge, keyed by the challenge name.
@override@JsonKey() Map<String, String> get captured {
  if (_captured is EqualUnmodifiableMapView) return _captured;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_captured);
}

/// Live guidance for the current pose.
@override final  PoseHint? hint;
@override final  String? rejectReason;
@override@JsonKey() final  bool canRetry;
@override final  Failure? failure;

/// Create a copy of LivenessCaptureState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LivenessCaptureStateCopyWith<_LivenessCaptureState> get copyWith => __$LivenessCaptureStateCopyWithImpl<_LivenessCaptureState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LivenessCaptureState&&(identical(other.status, status) || other.status == status)&&(identical(other.session, session) || other.session == session)&&(identical(other.stepIndex, stepIndex) || other.stepIndex == stepIndex)&&const DeepCollectionEquality().equals(other._captured, _captured)&&(identical(other.hint, hint) || other.hint == hint)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,session,stepIndex,const DeepCollectionEquality().hash(_captured),hint,rejectReason,canRetry,failure);

@override
String toString() {
  return 'LivenessCaptureState(status: $status, session: $session, stepIndex: $stepIndex, captured: $captured, hint: $hint, rejectReason: $rejectReason, canRetry: $canRetry, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$LivenessCaptureStateCopyWith<$Res> implements $LivenessCaptureStateCopyWith<$Res> {
  factory _$LivenessCaptureStateCopyWith(_LivenessCaptureState value, $Res Function(_LivenessCaptureState) _then) = __$LivenessCaptureStateCopyWithImpl;
@override @useResult
$Res call({
 LivenessCaptureStatus status, FaceSession? session, int stepIndex, Map<String, String> captured, PoseHint? hint, String? rejectReason, bool canRetry, Failure? failure
});


@override $FaceSessionCopyWith<$Res>? get session;

}
/// @nodoc
class __$LivenessCaptureStateCopyWithImpl<$Res>
    implements _$LivenessCaptureStateCopyWith<$Res> {
  __$LivenessCaptureStateCopyWithImpl(this._self, this._then);

  final _LivenessCaptureState _self;
  final $Res Function(_LivenessCaptureState) _then;

/// Create a copy of LivenessCaptureState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? session = freezed,Object? stepIndex = null,Object? captured = null,Object? hint = freezed,Object? rejectReason = freezed,Object? canRetry = null,Object? failure = freezed,}) {
  return _then(_LivenessCaptureState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LivenessCaptureStatus,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as FaceSession?,stepIndex: null == stepIndex ? _self.stepIndex : stepIndex // ignore: cast_nullable_to_non_nullable
as int,captured: null == captured ? _self._captured : captured // ignore: cast_nullable_to_non_nullable
as Map<String, String>,hint: freezed == hint ? _self.hint : hint // ignore: cast_nullable_to_non_nullable
as PoseHint?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of LivenessCaptureState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FaceSessionCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $FaceSessionCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

// dart format on
