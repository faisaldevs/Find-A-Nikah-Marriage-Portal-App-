// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteConfigState {

 String get appVersion; RemoteConfig get config;
/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteConfigStateCopyWith<RemoteConfigState> get copyWith => _$RemoteConfigStateCopyWithImpl<RemoteConfigState>(this as RemoteConfigState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteConfigState&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,appVersion,config);

@override
String toString() {
  return 'RemoteConfigState(appVersion: $appVersion, config: $config)';
}


}

/// @nodoc
abstract mixin class $RemoteConfigStateCopyWith<$Res>  {
  factory $RemoteConfigStateCopyWith(RemoteConfigState value, $Res Function(RemoteConfigState) _then) = _$RemoteConfigStateCopyWithImpl;
@useResult
$Res call({
 String appVersion, RemoteConfig config
});


$RemoteConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$RemoteConfigStateCopyWithImpl<$Res>
    implements $RemoteConfigStateCopyWith<$Res> {
  _$RemoteConfigStateCopyWithImpl(this._self, this._then);

  final RemoteConfigState _self;
  final $Res Function(RemoteConfigState) _then;

/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appVersion = null,Object? config = null,}) {
  return _then(_self.copyWith(
appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as RemoteConfig,
  ));
}
/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RemoteConfigCopyWith<$Res> get config {
  
  return $RemoteConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [RemoteConfigState].
extension RemoteConfigStatePatterns on RemoteConfigState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteConfigState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteConfigState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteConfigState value)  $default,){
final _that = this;
switch (_that) {
case _RemoteConfigState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteConfigState value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteConfigState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String appVersion,  RemoteConfig config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteConfigState() when $default != null:
return $default(_that.appVersion,_that.config);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String appVersion,  RemoteConfig config)  $default,) {final _that = this;
switch (_that) {
case _RemoteConfigState():
return $default(_that.appVersion,_that.config);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String appVersion,  RemoteConfig config)?  $default,) {final _that = this;
switch (_that) {
case _RemoteConfigState() when $default != null:
return $default(_that.appVersion,_that.config);case _:
  return null;

}
}

}

/// @nodoc


class _RemoteConfigState extends RemoteConfigState {
  const _RemoteConfigState({required this.appVersion, this.config = const RemoteConfig()}): super._();
  

@override final  String appVersion;
@override@JsonKey() final  RemoteConfig config;

/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteConfigStateCopyWith<_RemoteConfigState> get copyWith => __$RemoteConfigStateCopyWithImpl<_RemoteConfigState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteConfigState&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,appVersion,config);

@override
String toString() {
  return 'RemoteConfigState(appVersion: $appVersion, config: $config)';
}


}

/// @nodoc
abstract mixin class _$RemoteConfigStateCopyWith<$Res> implements $RemoteConfigStateCopyWith<$Res> {
  factory _$RemoteConfigStateCopyWith(_RemoteConfigState value, $Res Function(_RemoteConfigState) _then) = __$RemoteConfigStateCopyWithImpl;
@override @useResult
$Res call({
 String appVersion, RemoteConfig config
});


@override $RemoteConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$RemoteConfigStateCopyWithImpl<$Res>
    implements _$RemoteConfigStateCopyWith<$Res> {
  __$RemoteConfigStateCopyWithImpl(this._self, this._then);

  final _RemoteConfigState _self;
  final $Res Function(_RemoteConfigState) _then;

/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appVersion = null,Object? config = null,}) {
  return _then(_RemoteConfigState(
appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as RemoteConfig,
  ));
}

/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RemoteConfigCopyWith<$Res> get config {
  
  return $RemoteConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
