// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MenuState {

 MenuStatus get status; MenuTab get tab; MyProfile? get profile; Membership? get membership; Failure? get failure;
/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MenuStateCopyWith<MenuState> get copyWith => _$MenuStateCopyWithImpl<MenuState>(this as MenuState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MenuState&&(identical(other.status, status) || other.status == status)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,tab,profile,membership,failure);

@override
String toString() {
  return 'MenuState(status: $status, tab: $tab, profile: $profile, membership: $membership, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $MenuStateCopyWith<$Res>  {
  factory $MenuStateCopyWith(MenuState value, $Res Function(MenuState) _then) = _$MenuStateCopyWithImpl;
@useResult
$Res call({
 MenuStatus status, MenuTab tab, MyProfile? profile, Membership? membership, Failure? failure
});


$MyProfileCopyWith<$Res>? get profile;$MembershipCopyWith<$Res>? get membership;

}
/// @nodoc
class _$MenuStateCopyWithImpl<$Res>
    implements $MenuStateCopyWith<$Res> {
  _$MenuStateCopyWithImpl(this._self, this._then);

  final MenuState _self;
  final $Res Function(MenuState) _then;

/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? tab = null,Object? profile = freezed,Object? membership = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MenuStatus,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as MenuTab,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MyProfile?,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $MyProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res>? get membership {
    if (_self.membership == null) {
    return null;
  }

  return $MembershipCopyWith<$Res>(_self.membership!, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}


/// Adds pattern-matching-related methods to [MenuState].
extension MenuStatePatterns on MenuState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MenuState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MenuState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MenuState value)  $default,){
final _that = this;
switch (_that) {
case _MenuState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MenuState value)?  $default,){
final _that = this;
switch (_that) {
case _MenuState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MenuStatus status,  MenuTab tab,  MyProfile? profile,  Membership? membership,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MenuState() when $default != null:
return $default(_that.status,_that.tab,_that.profile,_that.membership,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MenuStatus status,  MenuTab tab,  MyProfile? profile,  Membership? membership,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _MenuState():
return $default(_that.status,_that.tab,_that.profile,_that.membership,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MenuStatus status,  MenuTab tab,  MyProfile? profile,  Membership? membership,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _MenuState() when $default != null:
return $default(_that.status,_that.tab,_that.profile,_that.membership,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _MenuState implements MenuState {
  const _MenuState({this.status = MenuStatus.loading, this.tab = MenuTab.membership, this.profile, this.membership, this.failure});
  

@override@JsonKey() final  MenuStatus status;
@override@JsonKey() final  MenuTab tab;
@override final  MyProfile? profile;
@override final  Membership? membership;
@override final  Failure? failure;

/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MenuStateCopyWith<_MenuState> get copyWith => __$MenuStateCopyWithImpl<_MenuState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MenuState&&(identical(other.status, status) || other.status == status)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,tab,profile,membership,failure);

@override
String toString() {
  return 'MenuState(status: $status, tab: $tab, profile: $profile, membership: $membership, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$MenuStateCopyWith<$Res> implements $MenuStateCopyWith<$Res> {
  factory _$MenuStateCopyWith(_MenuState value, $Res Function(_MenuState) _then) = __$MenuStateCopyWithImpl;
@override @useResult
$Res call({
 MenuStatus status, MenuTab tab, MyProfile? profile, Membership? membership, Failure? failure
});


@override $MyProfileCopyWith<$Res>? get profile;@override $MembershipCopyWith<$Res>? get membership;

}
/// @nodoc
class __$MenuStateCopyWithImpl<$Res>
    implements _$MenuStateCopyWith<$Res> {
  __$MenuStateCopyWithImpl(this._self, this._then);

  final _MenuState _self;
  final $Res Function(_MenuState) _then;

/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? tab = null,Object? profile = freezed,Object? membership = freezed,Object? failure = freezed,}) {
  return _then(_MenuState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MenuStatus,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as MenuTab,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MyProfile?,membership: freezed == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $MyProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of MenuState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res>? get membership {
    if (_self.membership == null) {
    return null;
  }

  return $MembershipCopyWith<$Res>(_self.membership!, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}

// dart format on
