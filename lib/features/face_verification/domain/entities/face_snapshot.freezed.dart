// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaceSnapshot {

 int get faceCount;/// `headEulerAngleY` — left/right turn. Null when ML Kit couldn't tell.
 double? get yaw;/// `headEulerAngleX` — up/down tilt.
 double? get pitch;/// `headEulerAngleZ` — in-plane tilt (unused by pose checks today, kept
/// for the debug overlay).
 double? get roll; double? get leftEyeOpenProbability; double? get rightEyeOpenProbability;/// Face bounding-box width ÷ frame width — stands in for distance.
 double? get boxWidthRatio;/// Face box center offset from the frame center ÷ frame width —
/// 0 is perfectly centered.
 double? get boxCenterOffsetRatio;
/// Create a copy of FaceSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceSnapshotCopyWith<FaceSnapshot> get copyWith => _$FaceSnapshotCopyWithImpl<FaceSnapshot>(this as FaceSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceSnapshot&&(identical(other.faceCount, faceCount) || other.faceCount == faceCount)&&(identical(other.yaw, yaw) || other.yaw == yaw)&&(identical(other.pitch, pitch) || other.pitch == pitch)&&(identical(other.roll, roll) || other.roll == roll)&&(identical(other.leftEyeOpenProbability, leftEyeOpenProbability) || other.leftEyeOpenProbability == leftEyeOpenProbability)&&(identical(other.rightEyeOpenProbability, rightEyeOpenProbability) || other.rightEyeOpenProbability == rightEyeOpenProbability)&&(identical(other.boxWidthRatio, boxWidthRatio) || other.boxWidthRatio == boxWidthRatio)&&(identical(other.boxCenterOffsetRatio, boxCenterOffsetRatio) || other.boxCenterOffsetRatio == boxCenterOffsetRatio));
}


@override
int get hashCode => Object.hash(runtimeType,faceCount,yaw,pitch,roll,leftEyeOpenProbability,rightEyeOpenProbability,boxWidthRatio,boxCenterOffsetRatio);

@override
String toString() {
  return 'FaceSnapshot(faceCount: $faceCount, yaw: $yaw, pitch: $pitch, roll: $roll, leftEyeOpenProbability: $leftEyeOpenProbability, rightEyeOpenProbability: $rightEyeOpenProbability, boxWidthRatio: $boxWidthRatio, boxCenterOffsetRatio: $boxCenterOffsetRatio)';
}


}

/// @nodoc
abstract mixin class $FaceSnapshotCopyWith<$Res>  {
  factory $FaceSnapshotCopyWith(FaceSnapshot value, $Res Function(FaceSnapshot) _then) = _$FaceSnapshotCopyWithImpl;
@useResult
$Res call({
 int faceCount, double? yaw, double? pitch, double? roll, double? leftEyeOpenProbability, double? rightEyeOpenProbability, double? boxWidthRatio, double? boxCenterOffsetRatio
});




}
/// @nodoc
class _$FaceSnapshotCopyWithImpl<$Res>
    implements $FaceSnapshotCopyWith<$Res> {
  _$FaceSnapshotCopyWithImpl(this._self, this._then);

  final FaceSnapshot _self;
  final $Res Function(FaceSnapshot) _then;

/// Create a copy of FaceSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? faceCount = null,Object? yaw = freezed,Object? pitch = freezed,Object? roll = freezed,Object? leftEyeOpenProbability = freezed,Object? rightEyeOpenProbability = freezed,Object? boxWidthRatio = freezed,Object? boxCenterOffsetRatio = freezed,}) {
  return _then(_self.copyWith(
faceCount: null == faceCount ? _self.faceCount : faceCount // ignore: cast_nullable_to_non_nullable
as int,yaw: freezed == yaw ? _self.yaw : yaw // ignore: cast_nullable_to_non_nullable
as double?,pitch: freezed == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as double?,roll: freezed == roll ? _self.roll : roll // ignore: cast_nullable_to_non_nullable
as double?,leftEyeOpenProbability: freezed == leftEyeOpenProbability ? _self.leftEyeOpenProbability : leftEyeOpenProbability // ignore: cast_nullable_to_non_nullable
as double?,rightEyeOpenProbability: freezed == rightEyeOpenProbability ? _self.rightEyeOpenProbability : rightEyeOpenProbability // ignore: cast_nullable_to_non_nullable
as double?,boxWidthRatio: freezed == boxWidthRatio ? _self.boxWidthRatio : boxWidthRatio // ignore: cast_nullable_to_non_nullable
as double?,boxCenterOffsetRatio: freezed == boxCenterOffsetRatio ? _self.boxCenterOffsetRatio : boxCenterOffsetRatio // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [FaceSnapshot].
extension FaceSnapshotPatterns on FaceSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaceSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaceSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaceSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _FaceSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaceSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _FaceSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int faceCount,  double? yaw,  double? pitch,  double? roll,  double? leftEyeOpenProbability,  double? rightEyeOpenProbability,  double? boxWidthRatio,  double? boxCenterOffsetRatio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaceSnapshot() when $default != null:
return $default(_that.faceCount,_that.yaw,_that.pitch,_that.roll,_that.leftEyeOpenProbability,_that.rightEyeOpenProbability,_that.boxWidthRatio,_that.boxCenterOffsetRatio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int faceCount,  double? yaw,  double? pitch,  double? roll,  double? leftEyeOpenProbability,  double? rightEyeOpenProbability,  double? boxWidthRatio,  double? boxCenterOffsetRatio)  $default,) {final _that = this;
switch (_that) {
case _FaceSnapshot():
return $default(_that.faceCount,_that.yaw,_that.pitch,_that.roll,_that.leftEyeOpenProbability,_that.rightEyeOpenProbability,_that.boxWidthRatio,_that.boxCenterOffsetRatio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int faceCount,  double? yaw,  double? pitch,  double? roll,  double? leftEyeOpenProbability,  double? rightEyeOpenProbability,  double? boxWidthRatio,  double? boxCenterOffsetRatio)?  $default,) {final _that = this;
switch (_that) {
case _FaceSnapshot() when $default != null:
return $default(_that.faceCount,_that.yaw,_that.pitch,_that.roll,_that.leftEyeOpenProbability,_that.rightEyeOpenProbability,_that.boxWidthRatio,_that.boxCenterOffsetRatio);case _:
  return null;

}
}

}

/// @nodoc


class _FaceSnapshot implements FaceSnapshot {
  const _FaceSnapshot({required this.faceCount, this.yaw, this.pitch, this.roll, this.leftEyeOpenProbability, this.rightEyeOpenProbability, this.boxWidthRatio, this.boxCenterOffsetRatio});
  

@override final  int faceCount;
/// `headEulerAngleY` — left/right turn. Null when ML Kit couldn't tell.
@override final  double? yaw;
/// `headEulerAngleX` — up/down tilt.
@override final  double? pitch;
/// `headEulerAngleZ` — in-plane tilt (unused by pose checks today, kept
/// for the debug overlay).
@override final  double? roll;
@override final  double? leftEyeOpenProbability;
@override final  double? rightEyeOpenProbability;
/// Face bounding-box width ÷ frame width — stands in for distance.
@override final  double? boxWidthRatio;
/// Face box center offset from the frame center ÷ frame width —
/// 0 is perfectly centered.
@override final  double? boxCenterOffsetRatio;

/// Create a copy of FaceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaceSnapshotCopyWith<_FaceSnapshot> get copyWith => __$FaceSnapshotCopyWithImpl<_FaceSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaceSnapshot&&(identical(other.faceCount, faceCount) || other.faceCount == faceCount)&&(identical(other.yaw, yaw) || other.yaw == yaw)&&(identical(other.pitch, pitch) || other.pitch == pitch)&&(identical(other.roll, roll) || other.roll == roll)&&(identical(other.leftEyeOpenProbability, leftEyeOpenProbability) || other.leftEyeOpenProbability == leftEyeOpenProbability)&&(identical(other.rightEyeOpenProbability, rightEyeOpenProbability) || other.rightEyeOpenProbability == rightEyeOpenProbability)&&(identical(other.boxWidthRatio, boxWidthRatio) || other.boxWidthRatio == boxWidthRatio)&&(identical(other.boxCenterOffsetRatio, boxCenterOffsetRatio) || other.boxCenterOffsetRatio == boxCenterOffsetRatio));
}


@override
int get hashCode => Object.hash(runtimeType,faceCount,yaw,pitch,roll,leftEyeOpenProbability,rightEyeOpenProbability,boxWidthRatio,boxCenterOffsetRatio);

@override
String toString() {
  return 'FaceSnapshot(faceCount: $faceCount, yaw: $yaw, pitch: $pitch, roll: $roll, leftEyeOpenProbability: $leftEyeOpenProbability, rightEyeOpenProbability: $rightEyeOpenProbability, boxWidthRatio: $boxWidthRatio, boxCenterOffsetRatio: $boxCenterOffsetRatio)';
}


}

/// @nodoc
abstract mixin class _$FaceSnapshotCopyWith<$Res> implements $FaceSnapshotCopyWith<$Res> {
  factory _$FaceSnapshotCopyWith(_FaceSnapshot value, $Res Function(_FaceSnapshot) _then) = __$FaceSnapshotCopyWithImpl;
@override @useResult
$Res call({
 int faceCount, double? yaw, double? pitch, double? roll, double? leftEyeOpenProbability, double? rightEyeOpenProbability, double? boxWidthRatio, double? boxCenterOffsetRatio
});




}
/// @nodoc
class __$FaceSnapshotCopyWithImpl<$Res>
    implements _$FaceSnapshotCopyWith<$Res> {
  __$FaceSnapshotCopyWithImpl(this._self, this._then);

  final _FaceSnapshot _self;
  final $Res Function(_FaceSnapshot) _then;

/// Create a copy of FaceSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? faceCount = null,Object? yaw = freezed,Object? pitch = freezed,Object? roll = freezed,Object? leftEyeOpenProbability = freezed,Object? rightEyeOpenProbability = freezed,Object? boxWidthRatio = freezed,Object? boxCenterOffsetRatio = freezed,}) {
  return _then(_FaceSnapshot(
faceCount: null == faceCount ? _self.faceCount : faceCount // ignore: cast_nullable_to_non_nullable
as int,yaw: freezed == yaw ? _self.yaw : yaw // ignore: cast_nullable_to_non_nullable
as double?,pitch: freezed == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as double?,roll: freezed == roll ? _self.roll : roll // ignore: cast_nullable_to_non_nullable
as double?,leftEyeOpenProbability: freezed == leftEyeOpenProbability ? _self.leftEyeOpenProbability : leftEyeOpenProbability // ignore: cast_nullable_to_non_nullable
as double?,rightEyeOpenProbability: freezed == rightEyeOpenProbability ? _self.rightEyeOpenProbability : rightEyeOpenProbability // ignore: cast_nullable_to_non_nullable
as double?,boxWidthRatio: freezed == boxWidthRatio ? _self.boxWidthRatio : boxWidthRatio // ignore: cast_nullable_to_non_nullable
as double?,boxCenterOffsetRatio: freezed == boxCenterOffsetRatio ? _self.boxCenterOffsetRatio : boxCenterOffsetRatio // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
