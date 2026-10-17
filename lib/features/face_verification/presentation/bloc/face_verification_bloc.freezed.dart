// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_verification_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaceVerificationState {

/// The photo the user confirms is theirs.
 String? get profilePhotoPath;/// Private selfie; never shown on the public profile.
 String? get selfiePath; FaceVerificationStatus get status;/// Why the on-device gate rejected the last selfie or liveness still.
 SelfieCheckResult? get check; Failure? get failure;// ── Guided liveness ──────────────────────────────────────────────
 FaceSession? get session; int get currentStepIndex; PoseFeedback? get poseFeedback; double get holdProgress; Map<String, String> get capturedStepPaths; bool get stepTimedOut; String? get rejectReason; bool get canRetry;/// The backend approved instantly ([Verified]) rather than queueing for
/// review — the result page words it differently (audit #40).
 bool get verified;
/// Create a copy of FaceVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceVerificationStateCopyWith<FaceVerificationState> get copyWith => _$FaceVerificationStateCopyWithImpl<FaceVerificationState>(this as FaceVerificationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceVerificationState&&(identical(other.profilePhotoPath, profilePhotoPath) || other.profilePhotoPath == profilePhotoPath)&&(identical(other.selfiePath, selfiePath) || other.selfiePath == selfiePath)&&(identical(other.status, status) || other.status == status)&&(identical(other.check, check) || other.check == check)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.session, session) || other.session == session)&&(identical(other.currentStepIndex, currentStepIndex) || other.currentStepIndex == currentStepIndex)&&(identical(other.poseFeedback, poseFeedback) || other.poseFeedback == poseFeedback)&&(identical(other.holdProgress, holdProgress) || other.holdProgress == holdProgress)&&const DeepCollectionEquality().equals(other.capturedStepPaths, capturedStepPaths)&&(identical(other.stepTimedOut, stepTimedOut) || other.stepTimedOut == stepTimedOut)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.verified, verified) || other.verified == verified));
}


@override
int get hashCode => Object.hash(runtimeType,profilePhotoPath,selfiePath,status,check,failure,session,currentStepIndex,poseFeedback,holdProgress,const DeepCollectionEquality().hash(capturedStepPaths),stepTimedOut,rejectReason,canRetry,verified);

@override
String toString() {
  return 'FaceVerificationState(profilePhotoPath: $profilePhotoPath, selfiePath: $selfiePath, status: $status, check: $check, failure: $failure, session: $session, currentStepIndex: $currentStepIndex, poseFeedback: $poseFeedback, holdProgress: $holdProgress, capturedStepPaths: $capturedStepPaths, stepTimedOut: $stepTimedOut, rejectReason: $rejectReason, canRetry: $canRetry, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $FaceVerificationStateCopyWith<$Res>  {
  factory $FaceVerificationStateCopyWith(FaceVerificationState value, $Res Function(FaceVerificationState) _then) = _$FaceVerificationStateCopyWithImpl;
@useResult
$Res call({
 String? profilePhotoPath, String? selfiePath, FaceVerificationStatus status, SelfieCheckResult? check, Failure? failure, FaceSession? session, int currentStepIndex, PoseFeedback? poseFeedback, double holdProgress, Map<String, String> capturedStepPaths, bool stepTimedOut, String? rejectReason, bool canRetry, bool verified
});


$FaceSessionCopyWith<$Res>? get session;

}
/// @nodoc
class _$FaceVerificationStateCopyWithImpl<$Res>
    implements $FaceVerificationStateCopyWith<$Res> {
  _$FaceVerificationStateCopyWithImpl(this._self, this._then);

  final FaceVerificationState _self;
  final $Res Function(FaceVerificationState) _then;

/// Create a copy of FaceVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profilePhotoPath = freezed,Object? selfiePath = freezed,Object? status = null,Object? check = freezed,Object? failure = freezed,Object? session = freezed,Object? currentStepIndex = null,Object? poseFeedback = freezed,Object? holdProgress = null,Object? capturedStepPaths = null,Object? stepTimedOut = null,Object? rejectReason = freezed,Object? canRetry = null,Object? verified = null,}) {
  return _then(_self.copyWith(
profilePhotoPath: freezed == profilePhotoPath ? _self.profilePhotoPath : profilePhotoPath // ignore: cast_nullable_to_non_nullable
as String?,selfiePath: freezed == selfiePath ? _self.selfiePath : selfiePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FaceVerificationStatus,check: freezed == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as SelfieCheckResult?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as FaceSession?,currentStepIndex: null == currentStepIndex ? _self.currentStepIndex : currentStepIndex // ignore: cast_nullable_to_non_nullable
as int,poseFeedback: freezed == poseFeedback ? _self.poseFeedback : poseFeedback // ignore: cast_nullable_to_non_nullable
as PoseFeedback?,holdProgress: null == holdProgress ? _self.holdProgress : holdProgress // ignore: cast_nullable_to_non_nullable
as double,capturedStepPaths: null == capturedStepPaths ? _self.capturedStepPaths : capturedStepPaths // ignore: cast_nullable_to_non_nullable
as Map<String, String>,stepTimedOut: null == stepTimedOut ? _self.stepTimedOut : stepTimedOut // ignore: cast_nullable_to_non_nullable
as bool,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FaceVerificationState
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


/// Adds pattern-matching-related methods to [FaceVerificationState].
extension FaceVerificationStatePatterns on FaceVerificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaceVerificationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaceVerificationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaceVerificationState value)  $default,){
final _that = this;
switch (_that) {
case _FaceVerificationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaceVerificationState value)?  $default,){
final _that = this;
switch (_that) {
case _FaceVerificationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? profilePhotoPath,  String? selfiePath,  FaceVerificationStatus status,  SelfieCheckResult? check,  Failure? failure,  FaceSession? session,  int currentStepIndex,  PoseFeedback? poseFeedback,  double holdProgress,  Map<String, String> capturedStepPaths,  bool stepTimedOut,  String? rejectReason,  bool canRetry,  bool verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaceVerificationState() when $default != null:
return $default(_that.profilePhotoPath,_that.selfiePath,_that.status,_that.check,_that.failure,_that.session,_that.currentStepIndex,_that.poseFeedback,_that.holdProgress,_that.capturedStepPaths,_that.stepTimedOut,_that.rejectReason,_that.canRetry,_that.verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? profilePhotoPath,  String? selfiePath,  FaceVerificationStatus status,  SelfieCheckResult? check,  Failure? failure,  FaceSession? session,  int currentStepIndex,  PoseFeedback? poseFeedback,  double holdProgress,  Map<String, String> capturedStepPaths,  bool stepTimedOut,  String? rejectReason,  bool canRetry,  bool verified)  $default,) {final _that = this;
switch (_that) {
case _FaceVerificationState():
return $default(_that.profilePhotoPath,_that.selfiePath,_that.status,_that.check,_that.failure,_that.session,_that.currentStepIndex,_that.poseFeedback,_that.holdProgress,_that.capturedStepPaths,_that.stepTimedOut,_that.rejectReason,_that.canRetry,_that.verified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? profilePhotoPath,  String? selfiePath,  FaceVerificationStatus status,  SelfieCheckResult? check,  Failure? failure,  FaceSession? session,  int currentStepIndex,  PoseFeedback? poseFeedback,  double holdProgress,  Map<String, String> capturedStepPaths,  bool stepTimedOut,  String? rejectReason,  bool canRetry,  bool verified)?  $default,) {final _that = this;
switch (_that) {
case _FaceVerificationState() when $default != null:
return $default(_that.profilePhotoPath,_that.selfiePath,_that.status,_that.check,_that.failure,_that.session,_that.currentStepIndex,_that.poseFeedback,_that.holdProgress,_that.capturedStepPaths,_that.stepTimedOut,_that.rejectReason,_that.canRetry,_that.verified);case _:
  return null;

}
}

}

/// @nodoc


class _FaceVerificationState extends FaceVerificationState {
  const _FaceVerificationState({this.profilePhotoPath, this.selfiePath, this.status = FaceVerificationStatus.idle, this.check, this.failure, this.session, this.currentStepIndex = 0, this.poseFeedback, this.holdProgress = 0.0, final  Map<String, String> capturedStepPaths = const <String, String>{}, this.stepTimedOut = false, this.rejectReason, this.canRetry = true, this.verified = false}): _capturedStepPaths = capturedStepPaths,super._();
  

/// The photo the user confirms is theirs.
@override final  String? profilePhotoPath;
/// Private selfie; never shown on the public profile.
@override final  String? selfiePath;
@override@JsonKey() final  FaceVerificationStatus status;
/// Why the on-device gate rejected the last selfie or liveness still.
@override final  SelfieCheckResult? check;
@override final  Failure? failure;
// ── Guided liveness ──────────────────────────────────────────────
@override final  FaceSession? session;
@override@JsonKey() final  int currentStepIndex;
@override final  PoseFeedback? poseFeedback;
@override@JsonKey() final  double holdProgress;
 final  Map<String, String> _capturedStepPaths;
@override@JsonKey() Map<String, String> get capturedStepPaths {
  if (_capturedStepPaths is EqualUnmodifiableMapView) return _capturedStepPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_capturedStepPaths);
}

@override@JsonKey() final  bool stepTimedOut;
@override final  String? rejectReason;
@override@JsonKey() final  bool canRetry;
/// The backend approved instantly ([Verified]) rather than queueing for
/// review — the result page words it differently (audit #40).
@override@JsonKey() final  bool verified;

/// Create a copy of FaceVerificationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaceVerificationStateCopyWith<_FaceVerificationState> get copyWith => __$FaceVerificationStateCopyWithImpl<_FaceVerificationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaceVerificationState&&(identical(other.profilePhotoPath, profilePhotoPath) || other.profilePhotoPath == profilePhotoPath)&&(identical(other.selfiePath, selfiePath) || other.selfiePath == selfiePath)&&(identical(other.status, status) || other.status == status)&&(identical(other.check, check) || other.check == check)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.session, session) || other.session == session)&&(identical(other.currentStepIndex, currentStepIndex) || other.currentStepIndex == currentStepIndex)&&(identical(other.poseFeedback, poseFeedback) || other.poseFeedback == poseFeedback)&&(identical(other.holdProgress, holdProgress) || other.holdProgress == holdProgress)&&const DeepCollectionEquality().equals(other._capturedStepPaths, _capturedStepPaths)&&(identical(other.stepTimedOut, stepTimedOut) || other.stepTimedOut == stepTimedOut)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry)&&(identical(other.verified, verified) || other.verified == verified));
}


@override
int get hashCode => Object.hash(runtimeType,profilePhotoPath,selfiePath,status,check,failure,session,currentStepIndex,poseFeedback,holdProgress,const DeepCollectionEquality().hash(_capturedStepPaths),stepTimedOut,rejectReason,canRetry,verified);

@override
String toString() {
  return 'FaceVerificationState(profilePhotoPath: $profilePhotoPath, selfiePath: $selfiePath, status: $status, check: $check, failure: $failure, session: $session, currentStepIndex: $currentStepIndex, poseFeedback: $poseFeedback, holdProgress: $holdProgress, capturedStepPaths: $capturedStepPaths, stepTimedOut: $stepTimedOut, rejectReason: $rejectReason, canRetry: $canRetry, verified: $verified)';
}


}

/// @nodoc
abstract mixin class _$FaceVerificationStateCopyWith<$Res> implements $FaceVerificationStateCopyWith<$Res> {
  factory _$FaceVerificationStateCopyWith(_FaceVerificationState value, $Res Function(_FaceVerificationState) _then) = __$FaceVerificationStateCopyWithImpl;
@override @useResult
$Res call({
 String? profilePhotoPath, String? selfiePath, FaceVerificationStatus status, SelfieCheckResult? check, Failure? failure, FaceSession? session, int currentStepIndex, PoseFeedback? poseFeedback, double holdProgress, Map<String, String> capturedStepPaths, bool stepTimedOut, String? rejectReason, bool canRetry, bool verified
});


@override $FaceSessionCopyWith<$Res>? get session;

}
/// @nodoc
class __$FaceVerificationStateCopyWithImpl<$Res>
    implements _$FaceVerificationStateCopyWith<$Res> {
  __$FaceVerificationStateCopyWithImpl(this._self, this._then);

  final _FaceVerificationState _self;
  final $Res Function(_FaceVerificationState) _then;

/// Create a copy of FaceVerificationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profilePhotoPath = freezed,Object? selfiePath = freezed,Object? status = null,Object? check = freezed,Object? failure = freezed,Object? session = freezed,Object? currentStepIndex = null,Object? poseFeedback = freezed,Object? holdProgress = null,Object? capturedStepPaths = null,Object? stepTimedOut = null,Object? rejectReason = freezed,Object? canRetry = null,Object? verified = null,}) {
  return _then(_FaceVerificationState(
profilePhotoPath: freezed == profilePhotoPath ? _self.profilePhotoPath : profilePhotoPath // ignore: cast_nullable_to_non_nullable
as String?,selfiePath: freezed == selfiePath ? _self.selfiePath : selfiePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FaceVerificationStatus,check: freezed == check ? _self.check : check // ignore: cast_nullable_to_non_nullable
as SelfieCheckResult?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as FaceSession?,currentStepIndex: null == currentStepIndex ? _self.currentStepIndex : currentStepIndex // ignore: cast_nullable_to_non_nullable
as int,poseFeedback: freezed == poseFeedback ? _self.poseFeedback : poseFeedback // ignore: cast_nullable_to_non_nullable
as PoseFeedback?,holdProgress: null == holdProgress ? _self.holdProgress : holdProgress // ignore: cast_nullable_to_non_nullable
as double,capturedStepPaths: null == capturedStepPaths ? _self._capturedStepPaths : capturedStepPaths // ignore: cast_nullable_to_non_nullable
as Map<String, String>,stepTimedOut: null == stepTimedOut ? _self.stepTimedOut : stepTimedOut // ignore: cast_nullable_to_non_nullable
as bool,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FaceVerificationState
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
