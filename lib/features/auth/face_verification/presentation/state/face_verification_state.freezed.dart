// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_verification_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaceVerificationState {

/// Profile photo the user is confirming is theirs (from onboarding, or
/// re-picked via "Change photo").
 String? get profilePhotoPath;/// Front-camera selfie captured on the "Start verification" screen.
/// Never shown on the public profile.
 String? get selfiePath; FaceVerificationStatus get status; String? get errorMessage;
/// Create a copy of FaceVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceVerificationStateCopyWith<FaceVerificationState> get copyWith => _$FaceVerificationStateCopyWithImpl<FaceVerificationState>(this as FaceVerificationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceVerificationState&&(identical(other.profilePhotoPath, profilePhotoPath) || other.profilePhotoPath == profilePhotoPath)&&(identical(other.selfiePath, selfiePath) || other.selfiePath == selfiePath)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,profilePhotoPath,selfiePath,status,errorMessage);

@override
String toString() {
  return 'FaceVerificationState(profilePhotoPath: $profilePhotoPath, selfiePath: $selfiePath, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $FaceVerificationStateCopyWith<$Res>  {
  factory $FaceVerificationStateCopyWith(FaceVerificationState value, $Res Function(FaceVerificationState) _then) = _$FaceVerificationStateCopyWithImpl;
@useResult
$Res call({
 String? profilePhotoPath, String? selfiePath, FaceVerificationStatus status, String? errorMessage
});




}
/// @nodoc
class _$FaceVerificationStateCopyWithImpl<$Res>
    implements $FaceVerificationStateCopyWith<$Res> {
  _$FaceVerificationStateCopyWithImpl(this._self, this._then);

  final FaceVerificationState _self;
  final $Res Function(FaceVerificationState) _then;

/// Create a copy of FaceVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profilePhotoPath = freezed,Object? selfiePath = freezed,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
profilePhotoPath: freezed == profilePhotoPath ? _self.profilePhotoPath : profilePhotoPath // ignore: cast_nullable_to_non_nullable
as String?,selfiePath: freezed == selfiePath ? _self.selfiePath : selfiePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FaceVerificationStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? profilePhotoPath,  String? selfiePath,  FaceVerificationStatus status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaceVerificationState() when $default != null:
return $default(_that.profilePhotoPath,_that.selfiePath,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? profilePhotoPath,  String? selfiePath,  FaceVerificationStatus status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _FaceVerificationState():
return $default(_that.profilePhotoPath,_that.selfiePath,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? profilePhotoPath,  String? selfiePath,  FaceVerificationStatus status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _FaceVerificationState() when $default != null:
return $default(_that.profilePhotoPath,_that.selfiePath,_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _FaceVerificationState implements FaceVerificationState {
  const _FaceVerificationState({this.profilePhotoPath, this.selfiePath, this.status = FaceVerificationStatus.idle, this.errorMessage});
  

/// Profile photo the user is confirming is theirs (from onboarding, or
/// re-picked via "Change photo").
@override final  String? profilePhotoPath;
/// Front-camera selfie captured on the "Start verification" screen.
/// Never shown on the public profile.
@override final  String? selfiePath;
@override@JsonKey() final  FaceVerificationStatus status;
@override final  String? errorMessage;

/// Create a copy of FaceVerificationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaceVerificationStateCopyWith<_FaceVerificationState> get copyWith => __$FaceVerificationStateCopyWithImpl<_FaceVerificationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaceVerificationState&&(identical(other.profilePhotoPath, profilePhotoPath) || other.profilePhotoPath == profilePhotoPath)&&(identical(other.selfiePath, selfiePath) || other.selfiePath == selfiePath)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,profilePhotoPath,selfiePath,status,errorMessage);

@override
String toString() {
  return 'FaceVerificationState(profilePhotoPath: $profilePhotoPath, selfiePath: $selfiePath, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$FaceVerificationStateCopyWith<$Res> implements $FaceVerificationStateCopyWith<$Res> {
  factory _$FaceVerificationStateCopyWith(_FaceVerificationState value, $Res Function(_FaceVerificationState) _then) = __$FaceVerificationStateCopyWithImpl;
@override @useResult
$Res call({
 String? profilePhotoPath, String? selfiePath, FaceVerificationStatus status, String? errorMessage
});




}
/// @nodoc
class __$FaceVerificationStateCopyWithImpl<$Res>
    implements _$FaceVerificationStateCopyWith<$Res> {
  __$FaceVerificationStateCopyWithImpl(this._self, this._then);

  final _FaceVerificationState _self;
  final $Res Function(_FaceVerificationState) _then;

/// Create a copy of FaceVerificationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profilePhotoPath = freezed,Object? selfiePath = freezed,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_FaceVerificationState(
profilePhotoPath: freezed == profilePhotoPath ? _self.profilePhotoPath : profilePhotoPath // ignore: cast_nullable_to_non_nullable
as String?,selfiePath: freezed == selfiePath ? _self.selfiePath : selfiePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FaceVerificationStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
