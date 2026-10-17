// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'liveness_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LivenessConfig {

 double get minFaceRatio; double get maxFaceRatio; double get maxCenterOffset; double get frontYawMax; double get frontPitchMax; double get turnYawMin; double get eyeOpenMin; Duration get holdDuration; Duration get stepTimeout;/// +1 or -1. Flips which physical turn direction `headEulerAngleY`'s
/// sign maps to `LivenessPose.left`/`LivenessPose.right`.
 int get yawSign;
/// Create a copy of LivenessConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LivenessConfigCopyWith<LivenessConfig> get copyWith => _$LivenessConfigCopyWithImpl<LivenessConfig>(this as LivenessConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LivenessConfig&&(identical(other.minFaceRatio, minFaceRatio) || other.minFaceRatio == minFaceRatio)&&(identical(other.maxFaceRatio, maxFaceRatio) || other.maxFaceRatio == maxFaceRatio)&&(identical(other.maxCenterOffset, maxCenterOffset) || other.maxCenterOffset == maxCenterOffset)&&(identical(other.frontYawMax, frontYawMax) || other.frontYawMax == frontYawMax)&&(identical(other.frontPitchMax, frontPitchMax) || other.frontPitchMax == frontPitchMax)&&(identical(other.turnYawMin, turnYawMin) || other.turnYawMin == turnYawMin)&&(identical(other.eyeOpenMin, eyeOpenMin) || other.eyeOpenMin == eyeOpenMin)&&(identical(other.holdDuration, holdDuration) || other.holdDuration == holdDuration)&&(identical(other.stepTimeout, stepTimeout) || other.stepTimeout == stepTimeout)&&(identical(other.yawSign, yawSign) || other.yawSign == yawSign));
}


@override
int get hashCode => Object.hash(runtimeType,minFaceRatio,maxFaceRatio,maxCenterOffset,frontYawMax,frontPitchMax,turnYawMin,eyeOpenMin,holdDuration,stepTimeout,yawSign);

@override
String toString() {
  return 'LivenessConfig(minFaceRatio: $minFaceRatio, maxFaceRatio: $maxFaceRatio, maxCenterOffset: $maxCenterOffset, frontYawMax: $frontYawMax, frontPitchMax: $frontPitchMax, turnYawMin: $turnYawMin, eyeOpenMin: $eyeOpenMin, holdDuration: $holdDuration, stepTimeout: $stepTimeout, yawSign: $yawSign)';
}


}

/// @nodoc
abstract mixin class $LivenessConfigCopyWith<$Res>  {
  factory $LivenessConfigCopyWith(LivenessConfig value, $Res Function(LivenessConfig) _then) = _$LivenessConfigCopyWithImpl;
@useResult
$Res call({
 double minFaceRatio, double maxFaceRatio, double maxCenterOffset, double frontYawMax, double frontPitchMax, double turnYawMin, double eyeOpenMin, Duration holdDuration, Duration stepTimeout, int yawSign
});




}
/// @nodoc
class _$LivenessConfigCopyWithImpl<$Res>
    implements $LivenessConfigCopyWith<$Res> {
  _$LivenessConfigCopyWithImpl(this._self, this._then);

  final LivenessConfig _self;
  final $Res Function(LivenessConfig) _then;

/// Create a copy of LivenessConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minFaceRatio = null,Object? maxFaceRatio = null,Object? maxCenterOffset = null,Object? frontYawMax = null,Object? frontPitchMax = null,Object? turnYawMin = null,Object? eyeOpenMin = null,Object? holdDuration = null,Object? stepTimeout = null,Object? yawSign = null,}) {
  return _then(_self.copyWith(
minFaceRatio: null == minFaceRatio ? _self.minFaceRatio : minFaceRatio // ignore: cast_nullable_to_non_nullable
as double,maxFaceRatio: null == maxFaceRatio ? _self.maxFaceRatio : maxFaceRatio // ignore: cast_nullable_to_non_nullable
as double,maxCenterOffset: null == maxCenterOffset ? _self.maxCenterOffset : maxCenterOffset // ignore: cast_nullable_to_non_nullable
as double,frontYawMax: null == frontYawMax ? _self.frontYawMax : frontYawMax // ignore: cast_nullable_to_non_nullable
as double,frontPitchMax: null == frontPitchMax ? _self.frontPitchMax : frontPitchMax // ignore: cast_nullable_to_non_nullable
as double,turnYawMin: null == turnYawMin ? _self.turnYawMin : turnYawMin // ignore: cast_nullable_to_non_nullable
as double,eyeOpenMin: null == eyeOpenMin ? _self.eyeOpenMin : eyeOpenMin // ignore: cast_nullable_to_non_nullable
as double,holdDuration: null == holdDuration ? _self.holdDuration : holdDuration // ignore: cast_nullable_to_non_nullable
as Duration,stepTimeout: null == stepTimeout ? _self.stepTimeout : stepTimeout // ignore: cast_nullable_to_non_nullable
as Duration,yawSign: null == yawSign ? _self.yawSign : yawSign // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LivenessConfig].
extension LivenessConfigPatterns on LivenessConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LivenessConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LivenessConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LivenessConfig value)  $default,){
final _that = this;
switch (_that) {
case _LivenessConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LivenessConfig value)?  $default,){
final _that = this;
switch (_that) {
case _LivenessConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double minFaceRatio,  double maxFaceRatio,  double maxCenterOffset,  double frontYawMax,  double frontPitchMax,  double turnYawMin,  double eyeOpenMin,  Duration holdDuration,  Duration stepTimeout,  int yawSign)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LivenessConfig() when $default != null:
return $default(_that.minFaceRatio,_that.maxFaceRatio,_that.maxCenterOffset,_that.frontYawMax,_that.frontPitchMax,_that.turnYawMin,_that.eyeOpenMin,_that.holdDuration,_that.stepTimeout,_that.yawSign);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double minFaceRatio,  double maxFaceRatio,  double maxCenterOffset,  double frontYawMax,  double frontPitchMax,  double turnYawMin,  double eyeOpenMin,  Duration holdDuration,  Duration stepTimeout,  int yawSign)  $default,) {final _that = this;
switch (_that) {
case _LivenessConfig():
return $default(_that.minFaceRatio,_that.maxFaceRatio,_that.maxCenterOffset,_that.frontYawMax,_that.frontPitchMax,_that.turnYawMin,_that.eyeOpenMin,_that.holdDuration,_that.stepTimeout,_that.yawSign);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double minFaceRatio,  double maxFaceRatio,  double maxCenterOffset,  double frontYawMax,  double frontPitchMax,  double turnYawMin,  double eyeOpenMin,  Duration holdDuration,  Duration stepTimeout,  int yawSign)?  $default,) {final _that = this;
switch (_that) {
case _LivenessConfig() when $default != null:
return $default(_that.minFaceRatio,_that.maxFaceRatio,_that.maxCenterOffset,_that.frontYawMax,_that.frontPitchMax,_that.turnYawMin,_that.eyeOpenMin,_that.holdDuration,_that.stepTimeout,_that.yawSign);case _:
  return null;

}
}

}

/// @nodoc


class _LivenessConfig extends LivenessConfig {
  const _LivenessConfig({this.minFaceRatio = 0.35, this.maxFaceRatio = 0.70, this.maxCenterOffset = 0.15, this.frontYawMax = 10.0, this.frontPitchMax = 12.0, this.turnYawMin = 25.0, this.eyeOpenMin = 0.5, this.holdDuration = const Duration(milliseconds: 600), this.stepTimeout = const Duration(seconds: 15), this.yawSign = 1}): super._();
  

@override@JsonKey() final  double minFaceRatio;
@override@JsonKey() final  double maxFaceRatio;
@override@JsonKey() final  double maxCenterOffset;
@override@JsonKey() final  double frontYawMax;
@override@JsonKey() final  double frontPitchMax;
@override@JsonKey() final  double turnYawMin;
@override@JsonKey() final  double eyeOpenMin;
@override@JsonKey() final  Duration holdDuration;
@override@JsonKey() final  Duration stepTimeout;
/// +1 or -1. Flips which physical turn direction `headEulerAngleY`'s
/// sign maps to `LivenessPose.left`/`LivenessPose.right`.
@override@JsonKey() final  int yawSign;

/// Create a copy of LivenessConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LivenessConfigCopyWith<_LivenessConfig> get copyWith => __$LivenessConfigCopyWithImpl<_LivenessConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LivenessConfig&&(identical(other.minFaceRatio, minFaceRatio) || other.minFaceRatio == minFaceRatio)&&(identical(other.maxFaceRatio, maxFaceRatio) || other.maxFaceRatio == maxFaceRatio)&&(identical(other.maxCenterOffset, maxCenterOffset) || other.maxCenterOffset == maxCenterOffset)&&(identical(other.frontYawMax, frontYawMax) || other.frontYawMax == frontYawMax)&&(identical(other.frontPitchMax, frontPitchMax) || other.frontPitchMax == frontPitchMax)&&(identical(other.turnYawMin, turnYawMin) || other.turnYawMin == turnYawMin)&&(identical(other.eyeOpenMin, eyeOpenMin) || other.eyeOpenMin == eyeOpenMin)&&(identical(other.holdDuration, holdDuration) || other.holdDuration == holdDuration)&&(identical(other.stepTimeout, stepTimeout) || other.stepTimeout == stepTimeout)&&(identical(other.yawSign, yawSign) || other.yawSign == yawSign));
}


@override
int get hashCode => Object.hash(runtimeType,minFaceRatio,maxFaceRatio,maxCenterOffset,frontYawMax,frontPitchMax,turnYawMin,eyeOpenMin,holdDuration,stepTimeout,yawSign);

@override
String toString() {
  return 'LivenessConfig(minFaceRatio: $minFaceRatio, maxFaceRatio: $maxFaceRatio, maxCenterOffset: $maxCenterOffset, frontYawMax: $frontYawMax, frontPitchMax: $frontPitchMax, turnYawMin: $turnYawMin, eyeOpenMin: $eyeOpenMin, holdDuration: $holdDuration, stepTimeout: $stepTimeout, yawSign: $yawSign)';
}


}

/// @nodoc
abstract mixin class _$LivenessConfigCopyWith<$Res> implements $LivenessConfigCopyWith<$Res> {
  factory _$LivenessConfigCopyWith(_LivenessConfig value, $Res Function(_LivenessConfig) _then) = __$LivenessConfigCopyWithImpl;
@override @useResult
$Res call({
 double minFaceRatio, double maxFaceRatio, double maxCenterOffset, double frontYawMax, double frontPitchMax, double turnYawMin, double eyeOpenMin, Duration holdDuration, Duration stepTimeout, int yawSign
});




}
/// @nodoc
class __$LivenessConfigCopyWithImpl<$Res>
    implements _$LivenessConfigCopyWith<$Res> {
  __$LivenessConfigCopyWithImpl(this._self, this._then);

  final _LivenessConfig _self;
  final $Res Function(_LivenessConfig) _then;

/// Create a copy of LivenessConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minFaceRatio = null,Object? maxFaceRatio = null,Object? maxCenterOffset = null,Object? frontYawMax = null,Object? frontPitchMax = null,Object? turnYawMin = null,Object? eyeOpenMin = null,Object? holdDuration = null,Object? stepTimeout = null,Object? yawSign = null,}) {
  return _then(_LivenessConfig(
minFaceRatio: null == minFaceRatio ? _self.minFaceRatio : minFaceRatio // ignore: cast_nullable_to_non_nullable
as double,maxFaceRatio: null == maxFaceRatio ? _self.maxFaceRatio : maxFaceRatio // ignore: cast_nullable_to_non_nullable
as double,maxCenterOffset: null == maxCenterOffset ? _self.maxCenterOffset : maxCenterOffset // ignore: cast_nullable_to_non_nullable
as double,frontYawMax: null == frontYawMax ? _self.frontYawMax : frontYawMax // ignore: cast_nullable_to_non_nullable
as double,frontPitchMax: null == frontPitchMax ? _self.frontPitchMax : frontPitchMax // ignore: cast_nullable_to_non_nullable
as double,turnYawMin: null == turnYawMin ? _self.turnYawMin : turnYawMin // ignore: cast_nullable_to_non_nullable
as double,eyeOpenMin: null == eyeOpenMin ? _self.eyeOpenMin : eyeOpenMin // ignore: cast_nullable_to_non_nullable
as double,holdDuration: null == holdDuration ? _self.holdDuration : holdDuration // ignore: cast_nullable_to_non_nullable
as Duration,stepTimeout: null == stepTimeout ? _self.stepTimeout : stepTimeout // ignore: cast_nullable_to_non_nullable
as Duration,yawSign: null == yawSign ? _self.yawSign : yawSign // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
