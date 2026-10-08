// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_location_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserLocationState {

 LocationAccess get access;/// Where the map centres. [GeoPoint.fallback] until a fix arrives.
 GeoPoint get position;/// True once [position] is a real fix.
 bool get hasFix;
/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLocationStateCopyWith<UserLocationState> get copyWith => _$UserLocationStateCopyWithImpl<UserLocationState>(this as UserLocationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLocationState&&(identical(other.access, access) || other.access == access)&&(identical(other.position, position) || other.position == position)&&(identical(other.hasFix, hasFix) || other.hasFix == hasFix));
}


@override
int get hashCode => Object.hash(runtimeType,access,position,hasFix);

@override
String toString() {
  return 'UserLocationState(access: $access, position: $position, hasFix: $hasFix)';
}


}

/// @nodoc
abstract mixin class $UserLocationStateCopyWith<$Res>  {
  factory $UserLocationStateCopyWith(UserLocationState value, $Res Function(UserLocationState) _then) = _$UserLocationStateCopyWithImpl;
@useResult
$Res call({
 LocationAccess access, GeoPoint position, bool hasFix
});


$GeoPointCopyWith<$Res> get position;

}
/// @nodoc
class _$UserLocationStateCopyWithImpl<$Res>
    implements $UserLocationStateCopyWith<$Res> {
  _$UserLocationStateCopyWithImpl(this._self, this._then);

  final UserLocationState _self;
  final $Res Function(UserLocationState) _then;

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? access = null,Object? position = null,Object? hasFix = null,}) {
  return _then(_self.copyWith(
access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as LocationAccess,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as GeoPoint,hasFix: null == hasFix ? _self.hasFix : hasFix // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get position {
  
  return $GeoPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserLocationState].
extension UserLocationStatePatterns on UserLocationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLocationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLocationState value)  $default,){
final _that = this;
switch (_that) {
case _UserLocationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLocationState value)?  $default,){
final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocationAccess access,  GeoPoint position,  bool hasFix)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
return $default(_that.access,_that.position,_that.hasFix);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocationAccess access,  GeoPoint position,  bool hasFix)  $default,) {final _that = this;
switch (_that) {
case _UserLocationState():
return $default(_that.access,_that.position,_that.hasFix);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocationAccess access,  GeoPoint position,  bool hasFix)?  $default,) {final _that = this;
switch (_that) {
case _UserLocationState() when $default != null:
return $default(_that.access,_that.position,_that.hasFix);case _:
  return null;

}
}

}

/// @nodoc


class _UserLocationState implements UserLocationState {
  const _UserLocationState({this.access = LocationAccess.checking, this.position = GeoPoint.fallback, this.hasFix = false});
  

@override@JsonKey() final  LocationAccess access;
/// Where the map centres. [GeoPoint.fallback] until a fix arrives.
@override@JsonKey() final  GeoPoint position;
/// True once [position] is a real fix.
@override@JsonKey() final  bool hasFix;

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLocationStateCopyWith<_UserLocationState> get copyWith => __$UserLocationStateCopyWithImpl<_UserLocationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLocationState&&(identical(other.access, access) || other.access == access)&&(identical(other.position, position) || other.position == position)&&(identical(other.hasFix, hasFix) || other.hasFix == hasFix));
}


@override
int get hashCode => Object.hash(runtimeType,access,position,hasFix);

@override
String toString() {
  return 'UserLocationState(access: $access, position: $position, hasFix: $hasFix)';
}


}

/// @nodoc
abstract mixin class _$UserLocationStateCopyWith<$Res> implements $UserLocationStateCopyWith<$Res> {
  factory _$UserLocationStateCopyWith(_UserLocationState value, $Res Function(_UserLocationState) _then) = __$UserLocationStateCopyWithImpl;
@override @useResult
$Res call({
 LocationAccess access, GeoPoint position, bool hasFix
});


@override $GeoPointCopyWith<$Res> get position;

}
/// @nodoc
class __$UserLocationStateCopyWithImpl<$Res>
    implements _$UserLocationStateCopyWith<$Res> {
  __$UserLocationStateCopyWithImpl(this._self, this._then);

  final _UserLocationState _self;
  final $Res Function(_UserLocationState) _then;

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? access = null,Object? position = null,Object? hasFix = null,}) {
  return _then(_UserLocationState(
access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as LocationAccess,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as GeoPoint,hasFix: null == hasFix ? _self.hasFix : hasFix // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of UserLocationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoPointCopyWith<$Res> get position {
  
  return $GeoPointCopyWith<$Res>(_self.position, (value) {
    return _then(_self.copyWith(position: value));
  });
}
}

// dart format on
