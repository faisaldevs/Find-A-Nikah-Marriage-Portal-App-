// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_profile_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingProfileResponseDto {

 OnboardingProfileDataDto get data;
/// Create a copy of OnboardingProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingProfileResponseDtoCopyWith<OnboardingProfileResponseDto> get copyWith => _$OnboardingProfileResponseDtoCopyWithImpl<OnboardingProfileResponseDto>(this as OnboardingProfileResponseDto, _$identity);

  /// Serializes this OnboardingProfileResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingProfileResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'OnboardingProfileResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $OnboardingProfileResponseDtoCopyWith<$Res>  {
  factory $OnboardingProfileResponseDtoCopyWith(OnboardingProfileResponseDto value, $Res Function(OnboardingProfileResponseDto) _then) = _$OnboardingProfileResponseDtoCopyWithImpl;
@useResult
$Res call({
 OnboardingProfileDataDto data
});


$OnboardingProfileDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$OnboardingProfileResponseDtoCopyWithImpl<$Res>
    implements $OnboardingProfileResponseDtoCopyWith<$Res> {
  _$OnboardingProfileResponseDtoCopyWithImpl(this._self, this._then);

  final OnboardingProfileResponseDto _self;
  final $Res Function(OnboardingProfileResponseDto) _then;

/// Create a copy of OnboardingProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OnboardingProfileDataDto,
  ));
}
/// Create a copy of OnboardingProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileDataDtoCopyWith<$Res> get data {
  
  return $OnboardingProfileDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingProfileResponseDto].
extension OnboardingProfileResponseDtoPatterns on OnboardingProfileResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingProfileResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingProfileResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingProfileResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingProfileResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OnboardingProfileDataDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingProfileResponseDto() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OnboardingProfileDataDto data)  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileResponseDto():
return $default(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OnboardingProfileDataDto data)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingProfileResponseDto implements OnboardingProfileResponseDto {
  const _OnboardingProfileResponseDto({required this.data});
  factory _OnboardingProfileResponseDto.fromJson(Map<String, dynamic> json) => _$OnboardingProfileResponseDtoFromJson(json);

@override final  OnboardingProfileDataDto data;

/// Create a copy of OnboardingProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingProfileResponseDtoCopyWith<_OnboardingProfileResponseDto> get copyWith => __$OnboardingProfileResponseDtoCopyWithImpl<_OnboardingProfileResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingProfileResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingProfileResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'OnboardingProfileResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$OnboardingProfileResponseDtoCopyWith<$Res> implements $OnboardingProfileResponseDtoCopyWith<$Res> {
  factory _$OnboardingProfileResponseDtoCopyWith(_OnboardingProfileResponseDto value, $Res Function(_OnboardingProfileResponseDto) _then) = __$OnboardingProfileResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 OnboardingProfileDataDto data
});


@override $OnboardingProfileDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$OnboardingProfileResponseDtoCopyWithImpl<$Res>
    implements _$OnboardingProfileResponseDtoCopyWith<$Res> {
  __$OnboardingProfileResponseDtoCopyWithImpl(this._self, this._then);

  final _OnboardingProfileResponseDto _self;
  final $Res Function(_OnboardingProfileResponseDto) _then;

/// Create a copy of OnboardingProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_OnboardingProfileResponseDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OnboardingProfileDataDto,
  ));
}

/// Create a copy of OnboardingProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileDataDtoCopyWith<$Res> get data {
  
  return $OnboardingProfileDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$OnboardingProfileDataDto {

 int get currentStep; OnboardingProfileUserDto? get user; OnboardingProfileDto? get profile;
/// Create a copy of OnboardingProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingProfileDataDtoCopyWith<OnboardingProfileDataDto> get copyWith => _$OnboardingProfileDataDtoCopyWithImpl<OnboardingProfileDataDto>(this as OnboardingProfileDataDto, _$identity);

  /// Serializes this OnboardingProfileDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingProfileDataDto&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStep,user,profile);

@override
String toString() {
  return 'OnboardingProfileDataDto(currentStep: $currentStep, user: $user, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $OnboardingProfileDataDtoCopyWith<$Res>  {
  factory $OnboardingProfileDataDtoCopyWith(OnboardingProfileDataDto value, $Res Function(OnboardingProfileDataDto) _then) = _$OnboardingProfileDataDtoCopyWithImpl;
@useResult
$Res call({
 int currentStep, OnboardingProfileUserDto? user, OnboardingProfileDto? profile
});


$OnboardingProfileUserDtoCopyWith<$Res>? get user;$OnboardingProfileDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class _$OnboardingProfileDataDtoCopyWithImpl<$Res>
    implements $OnboardingProfileDataDtoCopyWith<$Res> {
  _$OnboardingProfileDataDtoCopyWithImpl(this._self, this._then);

  final OnboardingProfileDataDto _self;
  final $Res Function(OnboardingProfileDataDto) _then;

/// Create a copy of OnboardingProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStep = null,Object? user = freezed,Object? profile = freezed,}) {
  return _then(_self.copyWith(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as OnboardingProfileUserDto?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as OnboardingProfileDto?,
  ));
}
/// Create a copy of OnboardingProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileUserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $OnboardingProfileUserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of OnboardingProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $OnboardingProfileDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingProfileDataDto].
extension OnboardingProfileDataDtoPatterns on OnboardingProfileDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingProfileDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingProfileDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingProfileDataDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingProfileDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStep,  OnboardingProfileUserDto? user,  OnboardingProfileDto? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingProfileDataDto() when $default != null:
return $default(_that.currentStep,_that.user,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStep,  OnboardingProfileUserDto? user,  OnboardingProfileDto? profile)  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileDataDto():
return $default(_that.currentStep,_that.user,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStep,  OnboardingProfileUserDto? user,  OnboardingProfileDto? profile)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileDataDto() when $default != null:
return $default(_that.currentStep,_that.user,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingProfileDataDto implements OnboardingProfileDataDto {
  const _OnboardingProfileDataDto({this.currentStep = 4, this.user, this.profile});
  factory _OnboardingProfileDataDto.fromJson(Map<String, dynamic> json) => _$OnboardingProfileDataDtoFromJson(json);

@override@JsonKey() final  int currentStep;
@override final  OnboardingProfileUserDto? user;
@override final  OnboardingProfileDto? profile;

/// Create a copy of OnboardingProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingProfileDataDtoCopyWith<_OnboardingProfileDataDto> get copyWith => __$OnboardingProfileDataDtoCopyWithImpl<_OnboardingProfileDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingProfileDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingProfileDataDto&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentStep,user,profile);

@override
String toString() {
  return 'OnboardingProfileDataDto(currentStep: $currentStep, user: $user, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$OnboardingProfileDataDtoCopyWith<$Res> implements $OnboardingProfileDataDtoCopyWith<$Res> {
  factory _$OnboardingProfileDataDtoCopyWith(_OnboardingProfileDataDto value, $Res Function(_OnboardingProfileDataDto) _then) = __$OnboardingProfileDataDtoCopyWithImpl;
@override @useResult
$Res call({
 int currentStep, OnboardingProfileUserDto? user, OnboardingProfileDto? profile
});


@override $OnboardingProfileUserDtoCopyWith<$Res>? get user;@override $OnboardingProfileDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class __$OnboardingProfileDataDtoCopyWithImpl<$Res>
    implements _$OnboardingProfileDataDtoCopyWith<$Res> {
  __$OnboardingProfileDataDtoCopyWithImpl(this._self, this._then);

  final _OnboardingProfileDataDto _self;
  final $Res Function(_OnboardingProfileDataDto) _then;

/// Create a copy of OnboardingProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? user = freezed,Object? profile = freezed,}) {
  return _then(_OnboardingProfileDataDto(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as OnboardingProfileUserDto?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as OnboardingProfileDto?,
  ));
}

/// Create a copy of OnboardingProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileUserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $OnboardingProfileUserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of OnboardingProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $OnboardingProfileDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$OnboardingProfileUserDto {

 String? get fullName;
/// Create a copy of OnboardingProfileUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingProfileUserDtoCopyWith<OnboardingProfileUserDto> get copyWith => _$OnboardingProfileUserDtoCopyWithImpl<OnboardingProfileUserDto>(this as OnboardingProfileUserDto, _$identity);

  /// Serializes this OnboardingProfileUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingProfileUserDto&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName);

@override
String toString() {
  return 'OnboardingProfileUserDto(fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class $OnboardingProfileUserDtoCopyWith<$Res>  {
  factory $OnboardingProfileUserDtoCopyWith(OnboardingProfileUserDto value, $Res Function(OnboardingProfileUserDto) _then) = _$OnboardingProfileUserDtoCopyWithImpl;
@useResult
$Res call({
 String? fullName
});




}
/// @nodoc
class _$OnboardingProfileUserDtoCopyWithImpl<$Res>
    implements $OnboardingProfileUserDtoCopyWith<$Res> {
  _$OnboardingProfileUserDtoCopyWithImpl(this._self, this._then);

  final OnboardingProfileUserDto _self;
  final $Res Function(OnboardingProfileUserDto) _then;

/// Create a copy of OnboardingProfileUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = freezed,}) {
  return _then(_self.copyWith(
fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingProfileUserDto].
extension OnboardingProfileUserDtoPatterns on OnboardingProfileUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingProfileUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingProfileUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingProfileUserDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingProfileUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileUserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingProfileUserDto() when $default != null:
return $default(_that.fullName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fullName)  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileUserDto():
return $default(_that.fullName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fullName)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileUserDto() when $default != null:
return $default(_that.fullName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingProfileUserDto implements OnboardingProfileUserDto {
  const _OnboardingProfileUserDto({this.fullName});
  factory _OnboardingProfileUserDto.fromJson(Map<String, dynamic> json) => _$OnboardingProfileUserDtoFromJson(json);

@override final  String? fullName;

/// Create a copy of OnboardingProfileUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingProfileUserDtoCopyWith<_OnboardingProfileUserDto> get copyWith => __$OnboardingProfileUserDtoCopyWithImpl<_OnboardingProfileUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingProfileUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingProfileUserDto&&(identical(other.fullName, fullName) || other.fullName == fullName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName);

@override
String toString() {
  return 'OnboardingProfileUserDto(fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$OnboardingProfileUserDtoCopyWith<$Res> implements $OnboardingProfileUserDtoCopyWith<$Res> {
  factory _$OnboardingProfileUserDtoCopyWith(_OnboardingProfileUserDto value, $Res Function(_OnboardingProfileUserDto) _then) = __$OnboardingProfileUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String? fullName
});




}
/// @nodoc
class __$OnboardingProfileUserDtoCopyWithImpl<$Res>
    implements _$OnboardingProfileUserDtoCopyWith<$Res> {
  __$OnboardingProfileUserDtoCopyWithImpl(this._self, this._then);

  final _OnboardingProfileUserDto _self;
  final $Res Function(_OnboardingProfileUserDto) _then;

/// Create a copy of OnboardingProfileUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = freezed,}) {
  return _then(_OnboardingProfileUserDto(
fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OnboardingProfileDto {

 String? get accountType; String? get gender; String? get religion; String? get dateOfBirth; List<String> get languages; List<String> get nationality; List<String> get grewUpIn; List<String> get ethnicity; int? get heightCm; String? get educationLevel; String? get professionTitle; String? get maritalStatus; String? get getToknowDuration; String? get marriageTimeline; List<String> get faith; List<String> get religiousPractices; List<String> get personalityTraits; String? get aboutMe; OnboardingProfileAboutYouDto? get aboutYou; OnboardingProfileLifestyleDto? get lifestyle; OnboardingProfileInterestsDto? get interests;
/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingProfileDtoCopyWith<OnboardingProfileDto> get copyWith => _$OnboardingProfileDtoCopyWithImpl<OnboardingProfileDto>(this as OnboardingProfileDto, _$identity);

  /// Serializes this OnboardingProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingProfileDto&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.religion, religion) || other.religion == religion)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&const DeepCollectionEquality().equals(other.languages, languages)&&const DeepCollectionEquality().equals(other.nationality, nationality)&&const DeepCollectionEquality().equals(other.grewUpIn, grewUpIn)&&const DeepCollectionEquality().equals(other.ethnicity, ethnicity)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.professionTitle, professionTitle) || other.professionTitle == professionTitle)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.getToknowDuration, getToknowDuration) || other.getToknowDuration == getToknowDuration)&&(identical(other.marriageTimeline, marriageTimeline) || other.marriageTimeline == marriageTimeline)&&const DeepCollectionEquality().equals(other.faith, faith)&&const DeepCollectionEquality().equals(other.religiousPractices, religiousPractices)&&const DeepCollectionEquality().equals(other.personalityTraits, personalityTraits)&&(identical(other.aboutMe, aboutMe) || other.aboutMe == aboutMe)&&(identical(other.aboutYou, aboutYou) || other.aboutYou == aboutYou)&&(identical(other.lifestyle, lifestyle) || other.lifestyle == lifestyle)&&(identical(other.interests, interests) || other.interests == interests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,accountType,gender,religion,dateOfBirth,const DeepCollectionEquality().hash(languages),const DeepCollectionEquality().hash(nationality),const DeepCollectionEquality().hash(grewUpIn),const DeepCollectionEquality().hash(ethnicity),heightCm,educationLevel,professionTitle,maritalStatus,getToknowDuration,marriageTimeline,const DeepCollectionEquality().hash(faith),const DeepCollectionEquality().hash(religiousPractices),const DeepCollectionEquality().hash(personalityTraits),aboutMe,aboutYou,lifestyle,interests]);

@override
String toString() {
  return 'OnboardingProfileDto(accountType: $accountType, gender: $gender, religion: $religion, dateOfBirth: $dateOfBirth, languages: $languages, nationality: $nationality, grewUpIn: $grewUpIn, ethnicity: $ethnicity, heightCm: $heightCm, educationLevel: $educationLevel, professionTitle: $professionTitle, maritalStatus: $maritalStatus, getToknowDuration: $getToknowDuration, marriageTimeline: $marriageTimeline, faith: $faith, religiousPractices: $religiousPractices, personalityTraits: $personalityTraits, aboutMe: $aboutMe, aboutYou: $aboutYou, lifestyle: $lifestyle, interests: $interests)';
}


}

/// @nodoc
abstract mixin class $OnboardingProfileDtoCopyWith<$Res>  {
  factory $OnboardingProfileDtoCopyWith(OnboardingProfileDto value, $Res Function(OnboardingProfileDto) _then) = _$OnboardingProfileDtoCopyWithImpl;
@useResult
$Res call({
 String? accountType, String? gender, String? religion, String? dateOfBirth, List<String> languages, List<String> nationality, List<String> grewUpIn, List<String> ethnicity, int? heightCm, String? educationLevel, String? professionTitle, String? maritalStatus, String? getToknowDuration, String? marriageTimeline, List<String> faith, List<String> religiousPractices, List<String> personalityTraits, String? aboutMe, OnboardingProfileAboutYouDto? aboutYou, OnboardingProfileLifestyleDto? lifestyle, OnboardingProfileInterestsDto? interests
});


$OnboardingProfileAboutYouDtoCopyWith<$Res>? get aboutYou;$OnboardingProfileLifestyleDtoCopyWith<$Res>? get lifestyle;$OnboardingProfileInterestsDtoCopyWith<$Res>? get interests;

}
/// @nodoc
class _$OnboardingProfileDtoCopyWithImpl<$Res>
    implements $OnboardingProfileDtoCopyWith<$Res> {
  _$OnboardingProfileDtoCopyWithImpl(this._self, this._then);

  final OnboardingProfileDto _self;
  final $Res Function(OnboardingProfileDto) _then;

/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountType = freezed,Object? gender = freezed,Object? religion = freezed,Object? dateOfBirth = freezed,Object? languages = null,Object? nationality = null,Object? grewUpIn = null,Object? ethnicity = null,Object? heightCm = freezed,Object? educationLevel = freezed,Object? professionTitle = freezed,Object? maritalStatus = freezed,Object? getToknowDuration = freezed,Object? marriageTimeline = freezed,Object? faith = null,Object? religiousPractices = null,Object? personalityTraits = null,Object? aboutMe = freezed,Object? aboutYou = freezed,Object? lifestyle = freezed,Object? interests = freezed,}) {
  return _then(_self.copyWith(
accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,religion: freezed == religion ? _self.religion : religion // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as List<String>,grewUpIn: null == grewUpIn ? _self.grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as List<String>,ethnicity: null == ethnicity ? _self.ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as List<String>,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,professionTitle: freezed == professionTitle ? _self.professionTitle : professionTitle // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,getToknowDuration: freezed == getToknowDuration ? _self.getToknowDuration : getToknowDuration // ignore: cast_nullable_to_non_nullable
as String?,marriageTimeline: freezed == marriageTimeline ? _self.marriageTimeline : marriageTimeline // ignore: cast_nullable_to_non_nullable
as String?,faith: null == faith ? _self.faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,religiousPractices: null == religiousPractices ? _self.religiousPractices : religiousPractices // ignore: cast_nullable_to_non_nullable
as List<String>,personalityTraits: null == personalityTraits ? _self.personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,aboutMe: freezed == aboutMe ? _self.aboutMe : aboutMe // ignore: cast_nullable_to_non_nullable
as String?,aboutYou: freezed == aboutYou ? _self.aboutYou : aboutYou // ignore: cast_nullable_to_non_nullable
as OnboardingProfileAboutYouDto?,lifestyle: freezed == lifestyle ? _self.lifestyle : lifestyle // ignore: cast_nullable_to_non_nullable
as OnboardingProfileLifestyleDto?,interests: freezed == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as OnboardingProfileInterestsDto?,
  ));
}
/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileAboutYouDtoCopyWith<$Res>? get aboutYou {
    if (_self.aboutYou == null) {
    return null;
  }

  return $OnboardingProfileAboutYouDtoCopyWith<$Res>(_self.aboutYou!, (value) {
    return _then(_self.copyWith(aboutYou: value));
  });
}/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileLifestyleDtoCopyWith<$Res>? get lifestyle {
    if (_self.lifestyle == null) {
    return null;
  }

  return $OnboardingProfileLifestyleDtoCopyWith<$Res>(_self.lifestyle!, (value) {
    return _then(_self.copyWith(lifestyle: value));
  });
}/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileInterestsDtoCopyWith<$Res>? get interests {
    if (_self.interests == null) {
    return null;
  }

  return $OnboardingProfileInterestsDtoCopyWith<$Res>(_self.interests!, (value) {
    return _then(_self.copyWith(interests: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingProfileDto].
extension OnboardingProfileDtoPatterns on OnboardingProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? accountType,  String? gender,  String? religion,  String? dateOfBirth,  List<String> languages,  List<String> nationality,  List<String> grewUpIn,  List<String> ethnicity,  int? heightCm,  String? educationLevel,  String? professionTitle,  String? maritalStatus,  String? getToknowDuration,  String? marriageTimeline,  List<String> faith,  List<String> religiousPractices,  List<String> personalityTraits,  String? aboutMe,  OnboardingProfileAboutYouDto? aboutYou,  OnboardingProfileLifestyleDto? lifestyle,  OnboardingProfileInterestsDto? interests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingProfileDto() when $default != null:
return $default(_that.accountType,_that.gender,_that.religion,_that.dateOfBirth,_that.languages,_that.nationality,_that.grewUpIn,_that.ethnicity,_that.heightCm,_that.educationLevel,_that.professionTitle,_that.maritalStatus,_that.getToknowDuration,_that.marriageTimeline,_that.faith,_that.religiousPractices,_that.personalityTraits,_that.aboutMe,_that.aboutYou,_that.lifestyle,_that.interests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? accountType,  String? gender,  String? religion,  String? dateOfBirth,  List<String> languages,  List<String> nationality,  List<String> grewUpIn,  List<String> ethnicity,  int? heightCm,  String? educationLevel,  String? professionTitle,  String? maritalStatus,  String? getToknowDuration,  String? marriageTimeline,  List<String> faith,  List<String> religiousPractices,  List<String> personalityTraits,  String? aboutMe,  OnboardingProfileAboutYouDto? aboutYou,  OnboardingProfileLifestyleDto? lifestyle,  OnboardingProfileInterestsDto? interests)  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileDto():
return $default(_that.accountType,_that.gender,_that.religion,_that.dateOfBirth,_that.languages,_that.nationality,_that.grewUpIn,_that.ethnicity,_that.heightCm,_that.educationLevel,_that.professionTitle,_that.maritalStatus,_that.getToknowDuration,_that.marriageTimeline,_that.faith,_that.religiousPractices,_that.personalityTraits,_that.aboutMe,_that.aboutYou,_that.lifestyle,_that.interests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? accountType,  String? gender,  String? religion,  String? dateOfBirth,  List<String> languages,  List<String> nationality,  List<String> grewUpIn,  List<String> ethnicity,  int? heightCm,  String? educationLevel,  String? professionTitle,  String? maritalStatus,  String? getToknowDuration,  String? marriageTimeline,  List<String> faith,  List<String> religiousPractices,  List<String> personalityTraits,  String? aboutMe,  OnboardingProfileAboutYouDto? aboutYou,  OnboardingProfileLifestyleDto? lifestyle,  OnboardingProfileInterestsDto? interests)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileDto() when $default != null:
return $default(_that.accountType,_that.gender,_that.religion,_that.dateOfBirth,_that.languages,_that.nationality,_that.grewUpIn,_that.ethnicity,_that.heightCm,_that.educationLevel,_that.professionTitle,_that.maritalStatus,_that.getToknowDuration,_that.marriageTimeline,_that.faith,_that.religiousPractices,_that.personalityTraits,_that.aboutMe,_that.aboutYou,_that.lifestyle,_that.interests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingProfileDto implements OnboardingProfileDto {
  const _OnboardingProfileDto({this.accountType, this.gender, this.religion, this.dateOfBirth, final  List<String> languages = const <String>[], final  List<String> nationality = const <String>[], final  List<String> grewUpIn = const <String>[], final  List<String> ethnicity = const <String>[], this.heightCm, this.educationLevel, this.professionTitle, this.maritalStatus, this.getToknowDuration, this.marriageTimeline, final  List<String> faith = const <String>[], final  List<String> religiousPractices = const <String>[], final  List<String> personalityTraits = const <String>[], this.aboutMe, this.aboutYou, this.lifestyle, this.interests}): _languages = languages,_nationality = nationality,_grewUpIn = grewUpIn,_ethnicity = ethnicity,_faith = faith,_religiousPractices = religiousPractices,_personalityTraits = personalityTraits;
  factory _OnboardingProfileDto.fromJson(Map<String, dynamic> json) => _$OnboardingProfileDtoFromJson(json);

@override final  String? accountType;
@override final  String? gender;
@override final  String? religion;
@override final  String? dateOfBirth;
 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

 final  List<String> _nationality;
@override@JsonKey() List<String> get nationality {
  if (_nationality is EqualUnmodifiableListView) return _nationality;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nationality);
}

 final  List<String> _grewUpIn;
@override@JsonKey() List<String> get grewUpIn {
  if (_grewUpIn is EqualUnmodifiableListView) return _grewUpIn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grewUpIn);
}

 final  List<String> _ethnicity;
@override@JsonKey() List<String> get ethnicity {
  if (_ethnicity is EqualUnmodifiableListView) return _ethnicity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ethnicity);
}

@override final  int? heightCm;
@override final  String? educationLevel;
@override final  String? professionTitle;
@override final  String? maritalStatus;
@override final  String? getToknowDuration;
@override final  String? marriageTimeline;
 final  List<String> _faith;
@override@JsonKey() List<String> get faith {
  if (_faith is EqualUnmodifiableListView) return _faith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faith);
}

 final  List<String> _religiousPractices;
@override@JsonKey() List<String> get religiousPractices {
  if (_religiousPractices is EqualUnmodifiableListView) return _religiousPractices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_religiousPractices);
}

 final  List<String> _personalityTraits;
@override@JsonKey() List<String> get personalityTraits {
  if (_personalityTraits is EqualUnmodifiableListView) return _personalityTraits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_personalityTraits);
}

@override final  String? aboutMe;
@override final  OnboardingProfileAboutYouDto? aboutYou;
@override final  OnboardingProfileLifestyleDto? lifestyle;
@override final  OnboardingProfileInterestsDto? interests;

/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingProfileDtoCopyWith<_OnboardingProfileDto> get copyWith => __$OnboardingProfileDtoCopyWithImpl<_OnboardingProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingProfileDto&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.religion, religion) || other.religion == religion)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&const DeepCollectionEquality().equals(other._languages, _languages)&&const DeepCollectionEquality().equals(other._nationality, _nationality)&&const DeepCollectionEquality().equals(other._grewUpIn, _grewUpIn)&&const DeepCollectionEquality().equals(other._ethnicity, _ethnicity)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.professionTitle, professionTitle) || other.professionTitle == professionTitle)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.getToknowDuration, getToknowDuration) || other.getToknowDuration == getToknowDuration)&&(identical(other.marriageTimeline, marriageTimeline) || other.marriageTimeline == marriageTimeline)&&const DeepCollectionEquality().equals(other._faith, _faith)&&const DeepCollectionEquality().equals(other._religiousPractices, _religiousPractices)&&const DeepCollectionEquality().equals(other._personalityTraits, _personalityTraits)&&(identical(other.aboutMe, aboutMe) || other.aboutMe == aboutMe)&&(identical(other.aboutYou, aboutYou) || other.aboutYou == aboutYou)&&(identical(other.lifestyle, lifestyle) || other.lifestyle == lifestyle)&&(identical(other.interests, interests) || other.interests == interests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,accountType,gender,religion,dateOfBirth,const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_nationality),const DeepCollectionEquality().hash(_grewUpIn),const DeepCollectionEquality().hash(_ethnicity),heightCm,educationLevel,professionTitle,maritalStatus,getToknowDuration,marriageTimeline,const DeepCollectionEquality().hash(_faith),const DeepCollectionEquality().hash(_religiousPractices),const DeepCollectionEquality().hash(_personalityTraits),aboutMe,aboutYou,lifestyle,interests]);

@override
String toString() {
  return 'OnboardingProfileDto(accountType: $accountType, gender: $gender, religion: $religion, dateOfBirth: $dateOfBirth, languages: $languages, nationality: $nationality, grewUpIn: $grewUpIn, ethnicity: $ethnicity, heightCm: $heightCm, educationLevel: $educationLevel, professionTitle: $professionTitle, maritalStatus: $maritalStatus, getToknowDuration: $getToknowDuration, marriageTimeline: $marriageTimeline, faith: $faith, religiousPractices: $religiousPractices, personalityTraits: $personalityTraits, aboutMe: $aboutMe, aboutYou: $aboutYou, lifestyle: $lifestyle, interests: $interests)';
}


}

/// @nodoc
abstract mixin class _$OnboardingProfileDtoCopyWith<$Res> implements $OnboardingProfileDtoCopyWith<$Res> {
  factory _$OnboardingProfileDtoCopyWith(_OnboardingProfileDto value, $Res Function(_OnboardingProfileDto) _then) = __$OnboardingProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String? accountType, String? gender, String? religion, String? dateOfBirth, List<String> languages, List<String> nationality, List<String> grewUpIn, List<String> ethnicity, int? heightCm, String? educationLevel, String? professionTitle, String? maritalStatus, String? getToknowDuration, String? marriageTimeline, List<String> faith, List<String> religiousPractices, List<String> personalityTraits, String? aboutMe, OnboardingProfileAboutYouDto? aboutYou, OnboardingProfileLifestyleDto? lifestyle, OnboardingProfileInterestsDto? interests
});


@override $OnboardingProfileAboutYouDtoCopyWith<$Res>? get aboutYou;@override $OnboardingProfileLifestyleDtoCopyWith<$Res>? get lifestyle;@override $OnboardingProfileInterestsDtoCopyWith<$Res>? get interests;

}
/// @nodoc
class __$OnboardingProfileDtoCopyWithImpl<$Res>
    implements _$OnboardingProfileDtoCopyWith<$Res> {
  __$OnboardingProfileDtoCopyWithImpl(this._self, this._then);

  final _OnboardingProfileDto _self;
  final $Res Function(_OnboardingProfileDto) _then;

/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountType = freezed,Object? gender = freezed,Object? religion = freezed,Object? dateOfBirth = freezed,Object? languages = null,Object? nationality = null,Object? grewUpIn = null,Object? ethnicity = null,Object? heightCm = freezed,Object? educationLevel = freezed,Object? professionTitle = freezed,Object? maritalStatus = freezed,Object? getToknowDuration = freezed,Object? marriageTimeline = freezed,Object? faith = null,Object? religiousPractices = null,Object? personalityTraits = null,Object? aboutMe = freezed,Object? aboutYou = freezed,Object? lifestyle = freezed,Object? interests = freezed,}) {
  return _then(_OnboardingProfileDto(
accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,religion: freezed == religion ? _self.religion : religion // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,nationality: null == nationality ? _self._nationality : nationality // ignore: cast_nullable_to_non_nullable
as List<String>,grewUpIn: null == grewUpIn ? _self._grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as List<String>,ethnicity: null == ethnicity ? _self._ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as List<String>,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,professionTitle: freezed == professionTitle ? _self.professionTitle : professionTitle // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,getToknowDuration: freezed == getToknowDuration ? _self.getToknowDuration : getToknowDuration // ignore: cast_nullable_to_non_nullable
as String?,marriageTimeline: freezed == marriageTimeline ? _self.marriageTimeline : marriageTimeline // ignore: cast_nullable_to_non_nullable
as String?,faith: null == faith ? _self._faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,religiousPractices: null == religiousPractices ? _self._religiousPractices : religiousPractices // ignore: cast_nullable_to_non_nullable
as List<String>,personalityTraits: null == personalityTraits ? _self._personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,aboutMe: freezed == aboutMe ? _self.aboutMe : aboutMe // ignore: cast_nullable_to_non_nullable
as String?,aboutYou: freezed == aboutYou ? _self.aboutYou : aboutYou // ignore: cast_nullable_to_non_nullable
as OnboardingProfileAboutYouDto?,lifestyle: freezed == lifestyle ? _self.lifestyle : lifestyle // ignore: cast_nullable_to_non_nullable
as OnboardingProfileLifestyleDto?,interests: freezed == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as OnboardingProfileInterestsDto?,
  ));
}

/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileAboutYouDtoCopyWith<$Res>? get aboutYou {
    if (_self.aboutYou == null) {
    return null;
  }

  return $OnboardingProfileAboutYouDtoCopyWith<$Res>(_self.aboutYou!, (value) {
    return _then(_self.copyWith(aboutYou: value));
  });
}/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileLifestyleDtoCopyWith<$Res>? get lifestyle {
    if (_self.lifestyle == null) {
    return null;
  }

  return $OnboardingProfileLifestyleDtoCopyWith<$Res>(_self.lifestyle!, (value) {
    return _then(_self.copyWith(lifestyle: value));
  });
}/// Create a copy of OnboardingProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingProfileInterestsDtoCopyWith<$Res>? get interests {
    if (_self.interests == null) {
    return null;
  }

  return $OnboardingProfileInterestsDtoCopyWith<$Res>(_self.interests!, (value) {
    return _then(_self.copyWith(interests: value));
  });
}
}


/// @nodoc
mixin _$OnboardingProfileAboutYouDto {

 bool? get bornMuslim; bool? get haveChildren; bool? get relocateAbroad;
/// Create a copy of OnboardingProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingProfileAboutYouDtoCopyWith<OnboardingProfileAboutYouDto> get copyWith => _$OnboardingProfileAboutYouDtoCopyWithImpl<OnboardingProfileAboutYouDto>(this as OnboardingProfileAboutYouDto, _$identity);

  /// Serializes this OnboardingProfileAboutYouDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingProfileAboutYouDto&&(identical(other.bornMuslim, bornMuslim) || other.bornMuslim == bornMuslim)&&(identical(other.haveChildren, haveChildren) || other.haveChildren == haveChildren)&&(identical(other.relocateAbroad, relocateAbroad) || other.relocateAbroad == relocateAbroad));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bornMuslim,haveChildren,relocateAbroad);

@override
String toString() {
  return 'OnboardingProfileAboutYouDto(bornMuslim: $bornMuslim, haveChildren: $haveChildren, relocateAbroad: $relocateAbroad)';
}


}

/// @nodoc
abstract mixin class $OnboardingProfileAboutYouDtoCopyWith<$Res>  {
  factory $OnboardingProfileAboutYouDtoCopyWith(OnboardingProfileAboutYouDto value, $Res Function(OnboardingProfileAboutYouDto) _then) = _$OnboardingProfileAboutYouDtoCopyWithImpl;
@useResult
$Res call({
 bool? bornMuslim, bool? haveChildren, bool? relocateAbroad
});




}
/// @nodoc
class _$OnboardingProfileAboutYouDtoCopyWithImpl<$Res>
    implements $OnboardingProfileAboutYouDtoCopyWith<$Res> {
  _$OnboardingProfileAboutYouDtoCopyWithImpl(this._self, this._then);

  final OnboardingProfileAboutYouDto _self;
  final $Res Function(OnboardingProfileAboutYouDto) _then;

/// Create a copy of OnboardingProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bornMuslim = freezed,Object? haveChildren = freezed,Object? relocateAbroad = freezed,}) {
  return _then(_self.copyWith(
bornMuslim: freezed == bornMuslim ? _self.bornMuslim : bornMuslim // ignore: cast_nullable_to_non_nullable
as bool?,haveChildren: freezed == haveChildren ? _self.haveChildren : haveChildren // ignore: cast_nullable_to_non_nullable
as bool?,relocateAbroad: freezed == relocateAbroad ? _self.relocateAbroad : relocateAbroad // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingProfileAboutYouDto].
extension OnboardingProfileAboutYouDtoPatterns on OnboardingProfileAboutYouDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingProfileAboutYouDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingProfileAboutYouDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingProfileAboutYouDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileAboutYouDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingProfileAboutYouDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileAboutYouDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? bornMuslim,  bool? haveChildren,  bool? relocateAbroad)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingProfileAboutYouDto() when $default != null:
return $default(_that.bornMuslim,_that.haveChildren,_that.relocateAbroad);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? bornMuslim,  bool? haveChildren,  bool? relocateAbroad)  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileAboutYouDto():
return $default(_that.bornMuslim,_that.haveChildren,_that.relocateAbroad);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? bornMuslim,  bool? haveChildren,  bool? relocateAbroad)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileAboutYouDto() when $default != null:
return $default(_that.bornMuslim,_that.haveChildren,_that.relocateAbroad);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingProfileAboutYouDto implements OnboardingProfileAboutYouDto {
  const _OnboardingProfileAboutYouDto({this.bornMuslim, this.haveChildren, this.relocateAbroad});
  factory _OnboardingProfileAboutYouDto.fromJson(Map<String, dynamic> json) => _$OnboardingProfileAboutYouDtoFromJson(json);

@override final  bool? bornMuslim;
@override final  bool? haveChildren;
@override final  bool? relocateAbroad;

/// Create a copy of OnboardingProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingProfileAboutYouDtoCopyWith<_OnboardingProfileAboutYouDto> get copyWith => __$OnboardingProfileAboutYouDtoCopyWithImpl<_OnboardingProfileAboutYouDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingProfileAboutYouDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingProfileAboutYouDto&&(identical(other.bornMuslim, bornMuslim) || other.bornMuslim == bornMuslim)&&(identical(other.haveChildren, haveChildren) || other.haveChildren == haveChildren)&&(identical(other.relocateAbroad, relocateAbroad) || other.relocateAbroad == relocateAbroad));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bornMuslim,haveChildren,relocateAbroad);

@override
String toString() {
  return 'OnboardingProfileAboutYouDto(bornMuslim: $bornMuslim, haveChildren: $haveChildren, relocateAbroad: $relocateAbroad)';
}


}

/// @nodoc
abstract mixin class _$OnboardingProfileAboutYouDtoCopyWith<$Res> implements $OnboardingProfileAboutYouDtoCopyWith<$Res> {
  factory _$OnboardingProfileAboutYouDtoCopyWith(_OnboardingProfileAboutYouDto value, $Res Function(_OnboardingProfileAboutYouDto) _then) = __$OnboardingProfileAboutYouDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? bornMuslim, bool? haveChildren, bool? relocateAbroad
});




}
/// @nodoc
class __$OnboardingProfileAboutYouDtoCopyWithImpl<$Res>
    implements _$OnboardingProfileAboutYouDtoCopyWith<$Res> {
  __$OnboardingProfileAboutYouDtoCopyWithImpl(this._self, this._then);

  final _OnboardingProfileAboutYouDto _self;
  final $Res Function(_OnboardingProfileAboutYouDto) _then;

/// Create a copy of OnboardingProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bornMuslim = freezed,Object? haveChildren = freezed,Object? relocateAbroad = freezed,}) {
  return _then(_OnboardingProfileAboutYouDto(
bornMuslim: freezed == bornMuslim ? _self.bornMuslim : bornMuslim // ignore: cast_nullable_to_non_nullable
as bool?,haveChildren: freezed == haveChildren ? _self.haveChildren : haveChildren // ignore: cast_nullable_to_non_nullable
as bool?,relocateAbroad: freezed == relocateAbroad ? _self.relocateAbroad : relocateAbroad // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$OnboardingProfileLifestyleDto {

 bool? get alcohol; bool? get halalFood; bool? get smoking;
/// Create a copy of OnboardingProfileLifestyleDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingProfileLifestyleDtoCopyWith<OnboardingProfileLifestyleDto> get copyWith => _$OnboardingProfileLifestyleDtoCopyWithImpl<OnboardingProfileLifestyleDto>(this as OnboardingProfileLifestyleDto, _$identity);

  /// Serializes this OnboardingProfileLifestyleDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingProfileLifestyleDto&&(identical(other.alcohol, alcohol) || other.alcohol == alcohol)&&(identical(other.halalFood, halalFood) || other.halalFood == halalFood)&&(identical(other.smoking, smoking) || other.smoking == smoking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,alcohol,halalFood,smoking);

@override
String toString() {
  return 'OnboardingProfileLifestyleDto(alcohol: $alcohol, halalFood: $halalFood, smoking: $smoking)';
}


}

/// @nodoc
abstract mixin class $OnboardingProfileLifestyleDtoCopyWith<$Res>  {
  factory $OnboardingProfileLifestyleDtoCopyWith(OnboardingProfileLifestyleDto value, $Res Function(OnboardingProfileLifestyleDto) _then) = _$OnboardingProfileLifestyleDtoCopyWithImpl;
@useResult
$Res call({
 bool? alcohol, bool? halalFood, bool? smoking
});




}
/// @nodoc
class _$OnboardingProfileLifestyleDtoCopyWithImpl<$Res>
    implements $OnboardingProfileLifestyleDtoCopyWith<$Res> {
  _$OnboardingProfileLifestyleDtoCopyWithImpl(this._self, this._then);

  final OnboardingProfileLifestyleDto _self;
  final $Res Function(OnboardingProfileLifestyleDto) _then;

/// Create a copy of OnboardingProfileLifestyleDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? alcohol = freezed,Object? halalFood = freezed,Object? smoking = freezed,}) {
  return _then(_self.copyWith(
alcohol: freezed == alcohol ? _self.alcohol : alcohol // ignore: cast_nullable_to_non_nullable
as bool?,halalFood: freezed == halalFood ? _self.halalFood : halalFood // ignore: cast_nullable_to_non_nullable
as bool?,smoking: freezed == smoking ? _self.smoking : smoking // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingProfileLifestyleDto].
extension OnboardingProfileLifestyleDtoPatterns on OnboardingProfileLifestyleDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingProfileLifestyleDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingProfileLifestyleDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingProfileLifestyleDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileLifestyleDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingProfileLifestyleDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileLifestyleDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? alcohol,  bool? halalFood,  bool? smoking)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingProfileLifestyleDto() when $default != null:
return $default(_that.alcohol,_that.halalFood,_that.smoking);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? alcohol,  bool? halalFood,  bool? smoking)  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileLifestyleDto():
return $default(_that.alcohol,_that.halalFood,_that.smoking);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? alcohol,  bool? halalFood,  bool? smoking)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileLifestyleDto() when $default != null:
return $default(_that.alcohol,_that.halalFood,_that.smoking);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingProfileLifestyleDto implements OnboardingProfileLifestyleDto {
  const _OnboardingProfileLifestyleDto({this.alcohol, this.halalFood, this.smoking});
  factory _OnboardingProfileLifestyleDto.fromJson(Map<String, dynamic> json) => _$OnboardingProfileLifestyleDtoFromJson(json);

@override final  bool? alcohol;
@override final  bool? halalFood;
@override final  bool? smoking;

/// Create a copy of OnboardingProfileLifestyleDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingProfileLifestyleDtoCopyWith<_OnboardingProfileLifestyleDto> get copyWith => __$OnboardingProfileLifestyleDtoCopyWithImpl<_OnboardingProfileLifestyleDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingProfileLifestyleDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingProfileLifestyleDto&&(identical(other.alcohol, alcohol) || other.alcohol == alcohol)&&(identical(other.halalFood, halalFood) || other.halalFood == halalFood)&&(identical(other.smoking, smoking) || other.smoking == smoking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,alcohol,halalFood,smoking);

@override
String toString() {
  return 'OnboardingProfileLifestyleDto(alcohol: $alcohol, halalFood: $halalFood, smoking: $smoking)';
}


}

/// @nodoc
abstract mixin class _$OnboardingProfileLifestyleDtoCopyWith<$Res> implements $OnboardingProfileLifestyleDtoCopyWith<$Res> {
  factory _$OnboardingProfileLifestyleDtoCopyWith(_OnboardingProfileLifestyleDto value, $Res Function(_OnboardingProfileLifestyleDto) _then) = __$OnboardingProfileLifestyleDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? alcohol, bool? halalFood, bool? smoking
});




}
/// @nodoc
class __$OnboardingProfileLifestyleDtoCopyWithImpl<$Res>
    implements _$OnboardingProfileLifestyleDtoCopyWith<$Res> {
  __$OnboardingProfileLifestyleDtoCopyWithImpl(this._self, this._then);

  final _OnboardingProfileLifestyleDto _self;
  final $Res Function(_OnboardingProfileLifestyleDto) _then;

/// Create a copy of OnboardingProfileLifestyleDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? alcohol = freezed,Object? halalFood = freezed,Object? smoking = freezed,}) {
  return _then(_OnboardingProfileLifestyleDto(
alcohol: freezed == alcohol ? _self.alcohol : alcohol // ignore: cast_nullable_to_non_nullable
as bool?,halalFood: freezed == halalFood ? _self.halalFood : halalFood // ignore: cast_nullable_to_non_nullable
as bool?,smoking: freezed == smoking ? _self.smoking : smoking // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$OnboardingProfileInterestsDto {

 List<String> get cultural; List<String> get foodDrinks; List<String> get sports; List<String> get fashion; List<String> get activities;
/// Create a copy of OnboardingProfileInterestsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingProfileInterestsDtoCopyWith<OnboardingProfileInterestsDto> get copyWith => _$OnboardingProfileInterestsDtoCopyWithImpl<OnboardingProfileInterestsDto>(this as OnboardingProfileInterestsDto, _$identity);

  /// Serializes this OnboardingProfileInterestsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingProfileInterestsDto&&const DeepCollectionEquality().equals(other.cultural, cultural)&&const DeepCollectionEquality().equals(other.foodDrinks, foodDrinks)&&const DeepCollectionEquality().equals(other.sports, sports)&&const DeepCollectionEquality().equals(other.fashion, fashion)&&const DeepCollectionEquality().equals(other.activities, activities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cultural),const DeepCollectionEquality().hash(foodDrinks),const DeepCollectionEquality().hash(sports),const DeepCollectionEquality().hash(fashion),const DeepCollectionEquality().hash(activities));

@override
String toString() {
  return 'OnboardingProfileInterestsDto(cultural: $cultural, foodDrinks: $foodDrinks, sports: $sports, fashion: $fashion, activities: $activities)';
}


}

/// @nodoc
abstract mixin class $OnboardingProfileInterestsDtoCopyWith<$Res>  {
  factory $OnboardingProfileInterestsDtoCopyWith(OnboardingProfileInterestsDto value, $Res Function(OnboardingProfileInterestsDto) _then) = _$OnboardingProfileInterestsDtoCopyWithImpl;
@useResult
$Res call({
 List<String> cultural, List<String> foodDrinks, List<String> sports, List<String> fashion, List<String> activities
});




}
/// @nodoc
class _$OnboardingProfileInterestsDtoCopyWithImpl<$Res>
    implements $OnboardingProfileInterestsDtoCopyWith<$Res> {
  _$OnboardingProfileInterestsDtoCopyWithImpl(this._self, this._then);

  final OnboardingProfileInterestsDto _self;
  final $Res Function(OnboardingProfileInterestsDto) _then;

/// Create a copy of OnboardingProfileInterestsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cultural = null,Object? foodDrinks = null,Object? sports = null,Object? fashion = null,Object? activities = null,}) {
  return _then(_self.copyWith(
cultural: null == cultural ? _self.cultural : cultural // ignore: cast_nullable_to_non_nullable
as List<String>,foodDrinks: null == foodDrinks ? _self.foodDrinks : foodDrinks // ignore: cast_nullable_to_non_nullable
as List<String>,sports: null == sports ? _self.sports : sports // ignore: cast_nullable_to_non_nullable
as List<String>,fashion: null == fashion ? _self.fashion : fashion // ignore: cast_nullable_to_non_nullable
as List<String>,activities: null == activities ? _self.activities : activities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingProfileInterestsDto].
extension OnboardingProfileInterestsDtoPatterns on OnboardingProfileInterestsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingProfileInterestsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingProfileInterestsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingProfileInterestsDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileInterestsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingProfileInterestsDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingProfileInterestsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> cultural,  List<String> foodDrinks,  List<String> sports,  List<String> fashion,  List<String> activities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingProfileInterestsDto() when $default != null:
return $default(_that.cultural,_that.foodDrinks,_that.sports,_that.fashion,_that.activities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> cultural,  List<String> foodDrinks,  List<String> sports,  List<String> fashion,  List<String> activities)  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileInterestsDto():
return $default(_that.cultural,_that.foodDrinks,_that.sports,_that.fashion,_that.activities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> cultural,  List<String> foodDrinks,  List<String> sports,  List<String> fashion,  List<String> activities)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingProfileInterestsDto() when $default != null:
return $default(_that.cultural,_that.foodDrinks,_that.sports,_that.fashion,_that.activities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingProfileInterestsDto implements OnboardingProfileInterestsDto {
  const _OnboardingProfileInterestsDto({final  List<String> cultural = const <String>[], final  List<String> foodDrinks = const <String>[], final  List<String> sports = const <String>[], final  List<String> fashion = const <String>[], final  List<String> activities = const <String>[]}): _cultural = cultural,_foodDrinks = foodDrinks,_sports = sports,_fashion = fashion,_activities = activities;
  factory _OnboardingProfileInterestsDto.fromJson(Map<String, dynamic> json) => _$OnboardingProfileInterestsDtoFromJson(json);

 final  List<String> _cultural;
@override@JsonKey() List<String> get cultural {
  if (_cultural is EqualUnmodifiableListView) return _cultural;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cultural);
}

 final  List<String> _foodDrinks;
@override@JsonKey() List<String> get foodDrinks {
  if (_foodDrinks is EqualUnmodifiableListView) return _foodDrinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_foodDrinks);
}

 final  List<String> _sports;
@override@JsonKey() List<String> get sports {
  if (_sports is EqualUnmodifiableListView) return _sports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sports);
}

 final  List<String> _fashion;
@override@JsonKey() List<String> get fashion {
  if (_fashion is EqualUnmodifiableListView) return _fashion;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fashion);
}

 final  List<String> _activities;
@override@JsonKey() List<String> get activities {
  if (_activities is EqualUnmodifiableListView) return _activities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activities);
}


/// Create a copy of OnboardingProfileInterestsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingProfileInterestsDtoCopyWith<_OnboardingProfileInterestsDto> get copyWith => __$OnboardingProfileInterestsDtoCopyWithImpl<_OnboardingProfileInterestsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingProfileInterestsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingProfileInterestsDto&&const DeepCollectionEquality().equals(other._cultural, _cultural)&&const DeepCollectionEquality().equals(other._foodDrinks, _foodDrinks)&&const DeepCollectionEquality().equals(other._sports, _sports)&&const DeepCollectionEquality().equals(other._fashion, _fashion)&&const DeepCollectionEquality().equals(other._activities, _activities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cultural),const DeepCollectionEquality().hash(_foodDrinks),const DeepCollectionEquality().hash(_sports),const DeepCollectionEquality().hash(_fashion),const DeepCollectionEquality().hash(_activities));

@override
String toString() {
  return 'OnboardingProfileInterestsDto(cultural: $cultural, foodDrinks: $foodDrinks, sports: $sports, fashion: $fashion, activities: $activities)';
}


}

/// @nodoc
abstract mixin class _$OnboardingProfileInterestsDtoCopyWith<$Res> implements $OnboardingProfileInterestsDtoCopyWith<$Res> {
  factory _$OnboardingProfileInterestsDtoCopyWith(_OnboardingProfileInterestsDto value, $Res Function(_OnboardingProfileInterestsDto) _then) = __$OnboardingProfileInterestsDtoCopyWithImpl;
@override @useResult
$Res call({
 List<String> cultural, List<String> foodDrinks, List<String> sports, List<String> fashion, List<String> activities
});




}
/// @nodoc
class __$OnboardingProfileInterestsDtoCopyWithImpl<$Res>
    implements _$OnboardingProfileInterestsDtoCopyWith<$Res> {
  __$OnboardingProfileInterestsDtoCopyWithImpl(this._self, this._then);

  final _OnboardingProfileInterestsDto _self;
  final $Res Function(_OnboardingProfileInterestsDto) _then;

/// Create a copy of OnboardingProfileInterestsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cultural = null,Object? foodDrinks = null,Object? sports = null,Object? fashion = null,Object? activities = null,}) {
  return _then(_OnboardingProfileInterestsDto(
cultural: null == cultural ? _self._cultural : cultural // ignore: cast_nullable_to_non_nullable
as List<String>,foodDrinks: null == foodDrinks ? _self._foodDrinks : foodDrinks // ignore: cast_nullable_to_non_nullable
as List<String>,sports: null == sports ? _self._sports : sports // ignore: cast_nullable_to_non_nullable
as List<String>,fashion: null == fashion ? _self._fashion : fashion // ignore: cast_nullable_to_non_nullable
as List<String>,activities: null == activities ? _self._activities : activities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
