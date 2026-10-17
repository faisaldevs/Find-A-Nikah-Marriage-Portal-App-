// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileState {

 EditProfileStatus get status; EditProfileTab get tab; MyProfile? get profile; AppSettings get settings; Failure? get failure;
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileStateCopyWith<EditProfileState> get copyWith => _$EditProfileStateCopyWithImpl<EditProfileState>(this as EditProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,tab,profile,settings,failure);

@override
String toString() {
  return 'EditProfileState(status: $status, tab: $tab, profile: $profile, settings: $settings, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $EditProfileStateCopyWith<$Res>  {
  factory $EditProfileStateCopyWith(EditProfileState value, $Res Function(EditProfileState) _then) = _$EditProfileStateCopyWithImpl;
@useResult
$Res call({
 EditProfileStatus status, EditProfileTab tab, MyProfile? profile, AppSettings settings, Failure? failure
});


$MyProfileCopyWith<$Res>? get profile;$AppSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$EditProfileStateCopyWithImpl<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  _$EditProfileStateCopyWithImpl(this._self, this._then);

  final EditProfileState _self;
  final $Res Function(EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? tab = null,Object? profile = freezed,Object? settings = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EditProfileStatus,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as EditProfileTab,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MyProfile?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of EditProfileState
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
}/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditProfileState value)  $default,){
final _that = this;
switch (_that) {
case _EditProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EditProfileStatus status,  EditProfileTab tab,  MyProfile? profile,  AppSettings settings,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.status,_that.tab,_that.profile,_that.settings,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EditProfileStatus status,  EditProfileTab tab,  MyProfile? profile,  AppSettings settings,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _EditProfileState():
return $default(_that.status,_that.tab,_that.profile,_that.settings,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EditProfileStatus status,  EditProfileTab tab,  MyProfile? profile,  AppSettings settings,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.status,_that.tab,_that.profile,_that.settings,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _EditProfileState implements EditProfileState {
  const _EditProfileState({this.status = EditProfileStatus.loading, this.tab = EditProfileTab.edit, this.profile, this.settings = const AppSettings(), this.failure});
  

@override@JsonKey() final  EditProfileStatus status;
@override@JsonKey() final  EditProfileTab tab;
@override final  MyProfile? profile;
@override@JsonKey() final  AppSettings settings;
@override final  Failure? failure;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileStateCopyWith<_EditProfileState> get copyWith => __$EditProfileStateCopyWithImpl<_EditProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileState&&(identical(other.status, status) || other.status == status)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,status,tab,profile,settings,failure);

@override
String toString() {
  return 'EditProfileState(status: $status, tab: $tab, profile: $profile, settings: $settings, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$EditProfileStateCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileStateCopyWith(_EditProfileState value, $Res Function(_EditProfileState) _then) = __$EditProfileStateCopyWithImpl;
@override @useResult
$Res call({
 EditProfileStatus status, EditProfileTab tab, MyProfile? profile, AppSettings settings, Failure? failure
});


@override $MyProfileCopyWith<$Res>? get profile;@override $AppSettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$EditProfileStateCopyWithImpl<$Res>
    implements _$EditProfileStateCopyWith<$Res> {
  __$EditProfileStateCopyWithImpl(this._self, this._then);

  final _EditProfileState _self;
  final $Res Function(_EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? tab = null,Object? profile = freezed,Object? settings = null,Object? failure = freezed,}) {
  return _then(_EditProfileState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EditProfileStatus,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as EditProfileTab,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MyProfile?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AppSettings,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of EditProfileState
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
}/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<$Res> get settings {
  
  return $AppSettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
