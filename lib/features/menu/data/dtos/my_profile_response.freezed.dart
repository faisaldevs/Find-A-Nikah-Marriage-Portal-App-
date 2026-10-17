// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_profile_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyProfileResponseDto {

 MyProfileDataDto get data;
/// Create a copy of MyProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileResponseDtoCopyWith<MyProfileResponseDto> get copyWith => _$MyProfileResponseDtoCopyWithImpl<MyProfileResponseDto>(this as MyProfileResponseDto, _$identity);

  /// Serializes this MyProfileResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'MyProfileResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $MyProfileResponseDtoCopyWith<$Res>  {
  factory $MyProfileResponseDtoCopyWith(MyProfileResponseDto value, $Res Function(MyProfileResponseDto) _then) = _$MyProfileResponseDtoCopyWithImpl;
@useResult
$Res call({
 MyProfileDataDto data
});


$MyProfileDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$MyProfileResponseDtoCopyWithImpl<$Res>
    implements $MyProfileResponseDtoCopyWith<$Res> {
  _$MyProfileResponseDtoCopyWithImpl(this._self, this._then);

  final MyProfileResponseDto _self;
  final $Res Function(MyProfileResponseDto) _then;

/// Create a copy of MyProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MyProfileDataDto,
  ));
}
/// Create a copy of MyProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileDataDtoCopyWith<$Res> get data {
  
  return $MyProfileDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [MyProfileResponseDto].
extension MyProfileResponseDtoPatterns on MyProfileResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfileResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfileResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfileResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _MyProfileResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfileResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfileResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MyProfileDataDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyProfileResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MyProfileDataDto data)  $default,) {final _that = this;
switch (_that) {
case _MyProfileResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MyProfileDataDto data)?  $default,) {final _that = this;
switch (_that) {
case _MyProfileResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyProfileResponseDto implements MyProfileResponseDto {
  const _MyProfileResponseDto({required this.data});
  factory _MyProfileResponseDto.fromJson(Map<String, dynamic> json) => _$MyProfileResponseDtoFromJson(json);

@override final  MyProfileDataDto data;

/// Create a copy of MyProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileResponseDtoCopyWith<_MyProfileResponseDto> get copyWith => __$MyProfileResponseDtoCopyWithImpl<_MyProfileResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyProfileResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfileResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'MyProfileResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$MyProfileResponseDtoCopyWith<$Res> implements $MyProfileResponseDtoCopyWith<$Res> {
  factory _$MyProfileResponseDtoCopyWith(_MyProfileResponseDto value, $Res Function(_MyProfileResponseDto) _then) = __$MyProfileResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 MyProfileDataDto data
});


@override $MyProfileDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$MyProfileResponseDtoCopyWithImpl<$Res>
    implements _$MyProfileResponseDtoCopyWith<$Res> {
  __$MyProfileResponseDtoCopyWithImpl(this._self, this._then);

  final _MyProfileResponseDto _self;
  final $Res Function(_MyProfileResponseDto) _then;

/// Create a copy of MyProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_MyProfileResponseDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MyProfileDataDto,
  ));
}

/// Create a copy of MyProfileResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileDataDtoCopyWith<$Res> get data {
  
  return $MyProfileDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$MyProfileDataDto {

 MyProfileUserDto? get user; MyProfileDto? get profile;
/// Create a copy of MyProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileDataDtoCopyWith<MyProfileDataDto> get copyWith => _$MyProfileDataDtoCopyWithImpl<MyProfileDataDto>(this as MyProfileDataDto, _$identity);

  /// Serializes this MyProfileDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileDataDto&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,profile);

@override
String toString() {
  return 'MyProfileDataDto(user: $user, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $MyProfileDataDtoCopyWith<$Res>  {
  factory $MyProfileDataDtoCopyWith(MyProfileDataDto value, $Res Function(MyProfileDataDto) _then) = _$MyProfileDataDtoCopyWithImpl;
@useResult
$Res call({
 MyProfileUserDto? user, MyProfileDto? profile
});


$MyProfileUserDtoCopyWith<$Res>? get user;$MyProfileDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class _$MyProfileDataDtoCopyWithImpl<$Res>
    implements $MyProfileDataDtoCopyWith<$Res> {
  _$MyProfileDataDtoCopyWithImpl(this._self, this._then);

  final MyProfileDataDto _self;
  final $Res Function(MyProfileDataDto) _then;

/// Create a copy of MyProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? profile = freezed,}) {
  return _then(_self.copyWith(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MyProfileUserDto?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MyProfileDto?,
  ));
}
/// Create a copy of MyProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileUserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $MyProfileUserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of MyProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $MyProfileDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [MyProfileDataDto].
extension MyProfileDataDtoPatterns on MyProfileDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfileDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfileDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfileDataDto value)  $default,){
final _that = this;
switch (_that) {
case _MyProfileDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfileDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfileDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MyProfileUserDto? user,  MyProfileDto? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyProfileDataDto() when $default != null:
return $default(_that.user,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MyProfileUserDto? user,  MyProfileDto? profile)  $default,) {final _that = this;
switch (_that) {
case _MyProfileDataDto():
return $default(_that.user,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MyProfileUserDto? user,  MyProfileDto? profile)?  $default,) {final _that = this;
switch (_that) {
case _MyProfileDataDto() when $default != null:
return $default(_that.user,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyProfileDataDto implements MyProfileDataDto {
  const _MyProfileDataDto({this.user, this.profile});
  factory _MyProfileDataDto.fromJson(Map<String, dynamic> json) => _$MyProfileDataDtoFromJson(json);

@override final  MyProfileUserDto? user;
@override final  MyProfileDto? profile;

/// Create a copy of MyProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileDataDtoCopyWith<_MyProfileDataDto> get copyWith => __$MyProfileDataDtoCopyWithImpl<_MyProfileDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyProfileDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfileDataDto&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,profile);

@override
String toString() {
  return 'MyProfileDataDto(user: $user, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$MyProfileDataDtoCopyWith<$Res> implements $MyProfileDataDtoCopyWith<$Res> {
  factory _$MyProfileDataDtoCopyWith(_MyProfileDataDto value, $Res Function(_MyProfileDataDto) _then) = __$MyProfileDataDtoCopyWithImpl;
@override @useResult
$Res call({
 MyProfileUserDto? user, MyProfileDto? profile
});


@override $MyProfileUserDtoCopyWith<$Res>? get user;@override $MyProfileDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class __$MyProfileDataDtoCopyWithImpl<$Res>
    implements _$MyProfileDataDtoCopyWith<$Res> {
  __$MyProfileDataDtoCopyWithImpl(this._self, this._then);

  final _MyProfileDataDto _self;
  final $Res Function(_MyProfileDataDto) _then;

/// Create a copy of MyProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? profile = freezed,}) {
  return _then(_MyProfileDataDto(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MyProfileUserDto?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MyProfileDto?,
  ));
}

/// Create a copy of MyProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileUserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $MyProfileUserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of MyProfileDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $MyProfileDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$MyProfileUserDto {

 String? get fullName; String? get email; String? get phone;
/// Create a copy of MyProfileUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileUserDtoCopyWith<MyProfileUserDto> get copyWith => _$MyProfileUserDtoCopyWithImpl<MyProfileUserDto>(this as MyProfileUserDto, _$identity);

  /// Serializes this MyProfileUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileUserDto&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,email,phone);

@override
String toString() {
  return 'MyProfileUserDto(fullName: $fullName, email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $MyProfileUserDtoCopyWith<$Res>  {
  factory $MyProfileUserDtoCopyWith(MyProfileUserDto value, $Res Function(MyProfileUserDto) _then) = _$MyProfileUserDtoCopyWithImpl;
@useResult
$Res call({
 String? fullName, String? email, String? phone
});




}
/// @nodoc
class _$MyProfileUserDtoCopyWithImpl<$Res>
    implements $MyProfileUserDtoCopyWith<$Res> {
  _$MyProfileUserDtoCopyWithImpl(this._self, this._then);

  final MyProfileUserDto _self;
  final $Res Function(MyProfileUserDto) _then;

/// Create a copy of MyProfileUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = freezed,Object? email = freezed,Object? phone = freezed,}) {
  return _then(_self.copyWith(
fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyProfileUserDto].
extension MyProfileUserDtoPatterns on MyProfileUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfileUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfileUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfileUserDto value)  $default,){
final _that = this;
switch (_that) {
case _MyProfileUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfileUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfileUserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fullName,  String? email,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyProfileUserDto() when $default != null:
return $default(_that.fullName,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fullName,  String? email,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _MyProfileUserDto():
return $default(_that.fullName,_that.email,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fullName,  String? email,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _MyProfileUserDto() when $default != null:
return $default(_that.fullName,_that.email,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyProfileUserDto implements MyProfileUserDto {
  const _MyProfileUserDto({this.fullName, this.email, this.phone});
  factory _MyProfileUserDto.fromJson(Map<String, dynamic> json) => _$MyProfileUserDtoFromJson(json);

@override final  String? fullName;
@override final  String? email;
@override final  String? phone;

/// Create a copy of MyProfileUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileUserDtoCopyWith<_MyProfileUserDto> get copyWith => __$MyProfileUserDtoCopyWithImpl<_MyProfileUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyProfileUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfileUserDto&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fullName,email,phone);

@override
String toString() {
  return 'MyProfileUserDto(fullName: $fullName, email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$MyProfileUserDtoCopyWith<$Res> implements $MyProfileUserDtoCopyWith<$Res> {
  factory _$MyProfileUserDtoCopyWith(_MyProfileUserDto value, $Res Function(_MyProfileUserDto) _then) = __$MyProfileUserDtoCopyWithImpl;
@override @useResult
$Res call({
 String? fullName, String? email, String? phone
});




}
/// @nodoc
class __$MyProfileUserDtoCopyWithImpl<$Res>
    implements _$MyProfileUserDtoCopyWith<$Res> {
  __$MyProfileUserDtoCopyWithImpl(this._self, this._then);

  final _MyProfileUserDto _self;
  final $Res Function(_MyProfileUserDto) _then;

/// Create a copy of MyProfileUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = freezed,Object? email = freezed,Object? phone = freezed,}) {
  return _then(_MyProfileUserDto(
fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MyProfileDto {

 String? get gender; String? get dateOfBirth; String? get country; List<String> get grewUpIn; num? get heightCm; num? get completeness; String? get maritalStatus; String? get aboutMe; String? get getToknowDuration; String? get marriageTimeline; String? get educationLevel; String? get professionTitle; List<String> get faith; List<String> get religiousPractices; List<String> get personalityTraits; List<String> get ethnicity; List<String> get nationality; List<String> get languages; List<String> get images; MyProfileFaceVerificationDto? get faceVerification; MyProfileAboutYouDto? get aboutYou; MyProfileLifestyleDto? get lifestyle; MyProfileInterestsDto? get interests;
/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileDtoCopyWith<MyProfileDto> get copyWith => _$MyProfileDtoCopyWithImpl<MyProfileDto>(this as MyProfileDto, _$identity);

  /// Serializes this MyProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileDto&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.country, country) || other.country == country)&&const DeepCollectionEquality().equals(other.grewUpIn, grewUpIn)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.completeness, completeness) || other.completeness == completeness)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.aboutMe, aboutMe) || other.aboutMe == aboutMe)&&(identical(other.getToknowDuration, getToknowDuration) || other.getToknowDuration == getToknowDuration)&&(identical(other.marriageTimeline, marriageTimeline) || other.marriageTimeline == marriageTimeline)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.professionTitle, professionTitle) || other.professionTitle == professionTitle)&&const DeepCollectionEquality().equals(other.faith, faith)&&const DeepCollectionEquality().equals(other.religiousPractices, religiousPractices)&&const DeepCollectionEquality().equals(other.personalityTraits, personalityTraits)&&const DeepCollectionEquality().equals(other.ethnicity, ethnicity)&&const DeepCollectionEquality().equals(other.nationality, nationality)&&const DeepCollectionEquality().equals(other.languages, languages)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.faceVerification, faceVerification) || other.faceVerification == faceVerification)&&(identical(other.aboutYou, aboutYou) || other.aboutYou == aboutYou)&&(identical(other.lifestyle, lifestyle) || other.lifestyle == lifestyle)&&(identical(other.interests, interests) || other.interests == interests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gender,dateOfBirth,country,const DeepCollectionEquality().hash(grewUpIn),heightCm,completeness,maritalStatus,aboutMe,getToknowDuration,marriageTimeline,educationLevel,professionTitle,const DeepCollectionEquality().hash(faith),const DeepCollectionEquality().hash(religiousPractices),const DeepCollectionEquality().hash(personalityTraits),const DeepCollectionEquality().hash(ethnicity),const DeepCollectionEquality().hash(nationality),const DeepCollectionEquality().hash(languages),const DeepCollectionEquality().hash(images),faceVerification,aboutYou,lifestyle,interests]);

@override
String toString() {
  return 'MyProfileDto(gender: $gender, dateOfBirth: $dateOfBirth, country: $country, grewUpIn: $grewUpIn, heightCm: $heightCm, completeness: $completeness, maritalStatus: $maritalStatus, aboutMe: $aboutMe, getToknowDuration: $getToknowDuration, marriageTimeline: $marriageTimeline, educationLevel: $educationLevel, professionTitle: $professionTitle, faith: $faith, religiousPractices: $religiousPractices, personalityTraits: $personalityTraits, ethnicity: $ethnicity, nationality: $nationality, languages: $languages, images: $images, faceVerification: $faceVerification, aboutYou: $aboutYou, lifestyle: $lifestyle, interests: $interests)';
}


}

/// @nodoc
abstract mixin class $MyProfileDtoCopyWith<$Res>  {
  factory $MyProfileDtoCopyWith(MyProfileDto value, $Res Function(MyProfileDto) _then) = _$MyProfileDtoCopyWithImpl;
@useResult
$Res call({
 String? gender, String? dateOfBirth, String? country, List<String> grewUpIn, num? heightCm, num? completeness, String? maritalStatus, String? aboutMe, String? getToknowDuration, String? marriageTimeline, String? educationLevel, String? professionTitle, List<String> faith, List<String> religiousPractices, List<String> personalityTraits, List<String> ethnicity, List<String> nationality, List<String> languages, List<String> images, MyProfileFaceVerificationDto? faceVerification, MyProfileAboutYouDto? aboutYou, MyProfileLifestyleDto? lifestyle, MyProfileInterestsDto? interests
});


$MyProfileFaceVerificationDtoCopyWith<$Res>? get faceVerification;$MyProfileAboutYouDtoCopyWith<$Res>? get aboutYou;$MyProfileLifestyleDtoCopyWith<$Res>? get lifestyle;$MyProfileInterestsDtoCopyWith<$Res>? get interests;

}
/// @nodoc
class _$MyProfileDtoCopyWithImpl<$Res>
    implements $MyProfileDtoCopyWith<$Res> {
  _$MyProfileDtoCopyWithImpl(this._self, this._then);

  final MyProfileDto _self;
  final $Res Function(MyProfileDto) _then;

/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gender = freezed,Object? dateOfBirth = freezed,Object? country = freezed,Object? grewUpIn = null,Object? heightCm = freezed,Object? completeness = freezed,Object? maritalStatus = freezed,Object? aboutMe = freezed,Object? getToknowDuration = freezed,Object? marriageTimeline = freezed,Object? educationLevel = freezed,Object? professionTitle = freezed,Object? faith = null,Object? religiousPractices = null,Object? personalityTraits = null,Object? ethnicity = null,Object? nationality = null,Object? languages = null,Object? images = null,Object? faceVerification = freezed,Object? aboutYou = freezed,Object? lifestyle = freezed,Object? interests = freezed,}) {
  return _then(_self.copyWith(
gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,grewUpIn: null == grewUpIn ? _self.grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as List<String>,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as num?,completeness: freezed == completeness ? _self.completeness : completeness // ignore: cast_nullable_to_non_nullable
as num?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,aboutMe: freezed == aboutMe ? _self.aboutMe : aboutMe // ignore: cast_nullable_to_non_nullable
as String?,getToknowDuration: freezed == getToknowDuration ? _self.getToknowDuration : getToknowDuration // ignore: cast_nullable_to_non_nullable
as String?,marriageTimeline: freezed == marriageTimeline ? _self.marriageTimeline : marriageTimeline // ignore: cast_nullable_to_non_nullable
as String?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,professionTitle: freezed == professionTitle ? _self.professionTitle : professionTitle // ignore: cast_nullable_to_non_nullable
as String?,faith: null == faith ? _self.faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,religiousPractices: null == religiousPractices ? _self.religiousPractices : religiousPractices // ignore: cast_nullable_to_non_nullable
as List<String>,personalityTraits: null == personalityTraits ? _self.personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,ethnicity: null == ethnicity ? _self.ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as List<String>,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as List<String>,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,faceVerification: freezed == faceVerification ? _self.faceVerification : faceVerification // ignore: cast_nullable_to_non_nullable
as MyProfileFaceVerificationDto?,aboutYou: freezed == aboutYou ? _self.aboutYou : aboutYou // ignore: cast_nullable_to_non_nullable
as MyProfileAboutYouDto?,lifestyle: freezed == lifestyle ? _self.lifestyle : lifestyle // ignore: cast_nullable_to_non_nullable
as MyProfileLifestyleDto?,interests: freezed == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as MyProfileInterestsDto?,
  ));
}
/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileFaceVerificationDtoCopyWith<$Res>? get faceVerification {
    if (_self.faceVerification == null) {
    return null;
  }

  return $MyProfileFaceVerificationDtoCopyWith<$Res>(_self.faceVerification!, (value) {
    return _then(_self.copyWith(faceVerification: value));
  });
}/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileAboutYouDtoCopyWith<$Res>? get aboutYou {
    if (_self.aboutYou == null) {
    return null;
  }

  return $MyProfileAboutYouDtoCopyWith<$Res>(_self.aboutYou!, (value) {
    return _then(_self.copyWith(aboutYou: value));
  });
}/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileLifestyleDtoCopyWith<$Res>? get lifestyle {
    if (_self.lifestyle == null) {
    return null;
  }

  return $MyProfileLifestyleDtoCopyWith<$Res>(_self.lifestyle!, (value) {
    return _then(_self.copyWith(lifestyle: value));
  });
}/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileInterestsDtoCopyWith<$Res>? get interests {
    if (_self.interests == null) {
    return null;
  }

  return $MyProfileInterestsDtoCopyWith<$Res>(_self.interests!, (value) {
    return _then(_self.copyWith(interests: value));
  });
}
}


/// Adds pattern-matching-related methods to [MyProfileDto].
extension MyProfileDtoPatterns on MyProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _MyProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? gender,  String? dateOfBirth,  String? country,  List<String> grewUpIn,  num? heightCm,  num? completeness,  String? maritalStatus,  String? aboutMe,  String? getToknowDuration,  String? marriageTimeline,  String? educationLevel,  String? professionTitle,  List<String> faith,  List<String> religiousPractices,  List<String> personalityTraits,  List<String> ethnicity,  List<String> nationality,  List<String> languages,  List<String> images,  MyProfileFaceVerificationDto? faceVerification,  MyProfileAboutYouDto? aboutYou,  MyProfileLifestyleDto? lifestyle,  MyProfileInterestsDto? interests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyProfileDto() when $default != null:
return $default(_that.gender,_that.dateOfBirth,_that.country,_that.grewUpIn,_that.heightCm,_that.completeness,_that.maritalStatus,_that.aboutMe,_that.getToknowDuration,_that.marriageTimeline,_that.educationLevel,_that.professionTitle,_that.faith,_that.religiousPractices,_that.personalityTraits,_that.ethnicity,_that.nationality,_that.languages,_that.images,_that.faceVerification,_that.aboutYou,_that.lifestyle,_that.interests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? gender,  String? dateOfBirth,  String? country,  List<String> grewUpIn,  num? heightCm,  num? completeness,  String? maritalStatus,  String? aboutMe,  String? getToknowDuration,  String? marriageTimeline,  String? educationLevel,  String? professionTitle,  List<String> faith,  List<String> religiousPractices,  List<String> personalityTraits,  List<String> ethnicity,  List<String> nationality,  List<String> languages,  List<String> images,  MyProfileFaceVerificationDto? faceVerification,  MyProfileAboutYouDto? aboutYou,  MyProfileLifestyleDto? lifestyle,  MyProfileInterestsDto? interests)  $default,) {final _that = this;
switch (_that) {
case _MyProfileDto():
return $default(_that.gender,_that.dateOfBirth,_that.country,_that.grewUpIn,_that.heightCm,_that.completeness,_that.maritalStatus,_that.aboutMe,_that.getToknowDuration,_that.marriageTimeline,_that.educationLevel,_that.professionTitle,_that.faith,_that.religiousPractices,_that.personalityTraits,_that.ethnicity,_that.nationality,_that.languages,_that.images,_that.faceVerification,_that.aboutYou,_that.lifestyle,_that.interests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? gender,  String? dateOfBirth,  String? country,  List<String> grewUpIn,  num? heightCm,  num? completeness,  String? maritalStatus,  String? aboutMe,  String? getToknowDuration,  String? marriageTimeline,  String? educationLevel,  String? professionTitle,  List<String> faith,  List<String> religiousPractices,  List<String> personalityTraits,  List<String> ethnicity,  List<String> nationality,  List<String> languages,  List<String> images,  MyProfileFaceVerificationDto? faceVerification,  MyProfileAboutYouDto? aboutYou,  MyProfileLifestyleDto? lifestyle,  MyProfileInterestsDto? interests)?  $default,) {final _that = this;
switch (_that) {
case _MyProfileDto() when $default != null:
return $default(_that.gender,_that.dateOfBirth,_that.country,_that.grewUpIn,_that.heightCm,_that.completeness,_that.maritalStatus,_that.aboutMe,_that.getToknowDuration,_that.marriageTimeline,_that.educationLevel,_that.professionTitle,_that.faith,_that.religiousPractices,_that.personalityTraits,_that.ethnicity,_that.nationality,_that.languages,_that.images,_that.faceVerification,_that.aboutYou,_that.lifestyle,_that.interests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyProfileDto implements MyProfileDto {
  const _MyProfileDto({this.gender, this.dateOfBirth, this.country, final  List<String> grewUpIn = const <String>[], this.heightCm, this.completeness, this.maritalStatus, this.aboutMe, this.getToknowDuration, this.marriageTimeline, this.educationLevel, this.professionTitle, final  List<String> faith = const <String>[], final  List<String> religiousPractices = const <String>[], final  List<String> personalityTraits = const <String>[], final  List<String> ethnicity = const <String>[], final  List<String> nationality = const <String>[], final  List<String> languages = const <String>[], final  List<String> images = const <String>[], this.faceVerification, this.aboutYou, this.lifestyle, this.interests}): _grewUpIn = grewUpIn,_faith = faith,_religiousPractices = religiousPractices,_personalityTraits = personalityTraits,_ethnicity = ethnicity,_nationality = nationality,_languages = languages,_images = images;
  factory _MyProfileDto.fromJson(Map<String, dynamic> json) => _$MyProfileDtoFromJson(json);

@override final  String? gender;
@override final  String? dateOfBirth;
@override final  String? country;
 final  List<String> _grewUpIn;
@override@JsonKey() List<String> get grewUpIn {
  if (_grewUpIn is EqualUnmodifiableListView) return _grewUpIn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grewUpIn);
}

@override final  num? heightCm;
@override final  num? completeness;
@override final  String? maritalStatus;
@override final  String? aboutMe;
@override final  String? getToknowDuration;
@override final  String? marriageTimeline;
@override final  String? educationLevel;
@override final  String? professionTitle;
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

 final  List<String> _ethnicity;
@override@JsonKey() List<String> get ethnicity {
  if (_ethnicity is EqualUnmodifiableListView) return _ethnicity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ethnicity);
}

 final  List<String> _nationality;
@override@JsonKey() List<String> get nationality {
  if (_nationality is EqualUnmodifiableListView) return _nationality;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nationality);
}

 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

 final  List<String> _images;
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  MyProfileFaceVerificationDto? faceVerification;
@override final  MyProfileAboutYouDto? aboutYou;
@override final  MyProfileLifestyleDto? lifestyle;
@override final  MyProfileInterestsDto? interests;

/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileDtoCopyWith<_MyProfileDto> get copyWith => __$MyProfileDtoCopyWithImpl<_MyProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfileDto&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.country, country) || other.country == country)&&const DeepCollectionEquality().equals(other._grewUpIn, _grewUpIn)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.completeness, completeness) || other.completeness == completeness)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.aboutMe, aboutMe) || other.aboutMe == aboutMe)&&(identical(other.getToknowDuration, getToknowDuration) || other.getToknowDuration == getToknowDuration)&&(identical(other.marriageTimeline, marriageTimeline) || other.marriageTimeline == marriageTimeline)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.professionTitle, professionTitle) || other.professionTitle == professionTitle)&&const DeepCollectionEquality().equals(other._faith, _faith)&&const DeepCollectionEquality().equals(other._religiousPractices, _religiousPractices)&&const DeepCollectionEquality().equals(other._personalityTraits, _personalityTraits)&&const DeepCollectionEquality().equals(other._ethnicity, _ethnicity)&&const DeepCollectionEquality().equals(other._nationality, _nationality)&&const DeepCollectionEquality().equals(other._languages, _languages)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.faceVerification, faceVerification) || other.faceVerification == faceVerification)&&(identical(other.aboutYou, aboutYou) || other.aboutYou == aboutYou)&&(identical(other.lifestyle, lifestyle) || other.lifestyle == lifestyle)&&(identical(other.interests, interests) || other.interests == interests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,gender,dateOfBirth,country,const DeepCollectionEquality().hash(_grewUpIn),heightCm,completeness,maritalStatus,aboutMe,getToknowDuration,marriageTimeline,educationLevel,professionTitle,const DeepCollectionEquality().hash(_faith),const DeepCollectionEquality().hash(_religiousPractices),const DeepCollectionEquality().hash(_personalityTraits),const DeepCollectionEquality().hash(_ethnicity),const DeepCollectionEquality().hash(_nationality),const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_images),faceVerification,aboutYou,lifestyle,interests]);

@override
String toString() {
  return 'MyProfileDto(gender: $gender, dateOfBirth: $dateOfBirth, country: $country, grewUpIn: $grewUpIn, heightCm: $heightCm, completeness: $completeness, maritalStatus: $maritalStatus, aboutMe: $aboutMe, getToknowDuration: $getToknowDuration, marriageTimeline: $marriageTimeline, educationLevel: $educationLevel, professionTitle: $professionTitle, faith: $faith, religiousPractices: $religiousPractices, personalityTraits: $personalityTraits, ethnicity: $ethnicity, nationality: $nationality, languages: $languages, images: $images, faceVerification: $faceVerification, aboutYou: $aboutYou, lifestyle: $lifestyle, interests: $interests)';
}


}

/// @nodoc
abstract mixin class _$MyProfileDtoCopyWith<$Res> implements $MyProfileDtoCopyWith<$Res> {
  factory _$MyProfileDtoCopyWith(_MyProfileDto value, $Res Function(_MyProfileDto) _then) = __$MyProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 String? gender, String? dateOfBirth, String? country, List<String> grewUpIn, num? heightCm, num? completeness, String? maritalStatus, String? aboutMe, String? getToknowDuration, String? marriageTimeline, String? educationLevel, String? professionTitle, List<String> faith, List<String> religiousPractices, List<String> personalityTraits, List<String> ethnicity, List<String> nationality, List<String> languages, List<String> images, MyProfileFaceVerificationDto? faceVerification, MyProfileAboutYouDto? aboutYou, MyProfileLifestyleDto? lifestyle, MyProfileInterestsDto? interests
});


@override $MyProfileFaceVerificationDtoCopyWith<$Res>? get faceVerification;@override $MyProfileAboutYouDtoCopyWith<$Res>? get aboutYou;@override $MyProfileLifestyleDtoCopyWith<$Res>? get lifestyle;@override $MyProfileInterestsDtoCopyWith<$Res>? get interests;

}
/// @nodoc
class __$MyProfileDtoCopyWithImpl<$Res>
    implements _$MyProfileDtoCopyWith<$Res> {
  __$MyProfileDtoCopyWithImpl(this._self, this._then);

  final _MyProfileDto _self;
  final $Res Function(_MyProfileDto) _then;

/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gender = freezed,Object? dateOfBirth = freezed,Object? country = freezed,Object? grewUpIn = null,Object? heightCm = freezed,Object? completeness = freezed,Object? maritalStatus = freezed,Object? aboutMe = freezed,Object? getToknowDuration = freezed,Object? marriageTimeline = freezed,Object? educationLevel = freezed,Object? professionTitle = freezed,Object? faith = null,Object? religiousPractices = null,Object? personalityTraits = null,Object? ethnicity = null,Object? nationality = null,Object? languages = null,Object? images = null,Object? faceVerification = freezed,Object? aboutYou = freezed,Object? lifestyle = freezed,Object? interests = freezed,}) {
  return _then(_MyProfileDto(
gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,grewUpIn: null == grewUpIn ? _self._grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as List<String>,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as num?,completeness: freezed == completeness ? _self.completeness : completeness // ignore: cast_nullable_to_non_nullable
as num?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,aboutMe: freezed == aboutMe ? _self.aboutMe : aboutMe // ignore: cast_nullable_to_non_nullable
as String?,getToknowDuration: freezed == getToknowDuration ? _self.getToknowDuration : getToknowDuration // ignore: cast_nullable_to_non_nullable
as String?,marriageTimeline: freezed == marriageTimeline ? _self.marriageTimeline : marriageTimeline // ignore: cast_nullable_to_non_nullable
as String?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,professionTitle: freezed == professionTitle ? _self.professionTitle : professionTitle // ignore: cast_nullable_to_non_nullable
as String?,faith: null == faith ? _self._faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,religiousPractices: null == religiousPractices ? _self._religiousPractices : religiousPractices // ignore: cast_nullable_to_non_nullable
as List<String>,personalityTraits: null == personalityTraits ? _self._personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,ethnicity: null == ethnicity ? _self._ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as List<String>,nationality: null == nationality ? _self._nationality : nationality // ignore: cast_nullable_to_non_nullable
as List<String>,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,faceVerification: freezed == faceVerification ? _self.faceVerification : faceVerification // ignore: cast_nullable_to_non_nullable
as MyProfileFaceVerificationDto?,aboutYou: freezed == aboutYou ? _self.aboutYou : aboutYou // ignore: cast_nullable_to_non_nullable
as MyProfileAboutYouDto?,lifestyle: freezed == lifestyle ? _self.lifestyle : lifestyle // ignore: cast_nullable_to_non_nullable
as MyProfileLifestyleDto?,interests: freezed == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as MyProfileInterestsDto?,
  ));
}

/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileFaceVerificationDtoCopyWith<$Res>? get faceVerification {
    if (_self.faceVerification == null) {
    return null;
  }

  return $MyProfileFaceVerificationDtoCopyWith<$Res>(_self.faceVerification!, (value) {
    return _then(_self.copyWith(faceVerification: value));
  });
}/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileAboutYouDtoCopyWith<$Res>? get aboutYou {
    if (_self.aboutYou == null) {
    return null;
  }

  return $MyProfileAboutYouDtoCopyWith<$Res>(_self.aboutYou!, (value) {
    return _then(_self.copyWith(aboutYou: value));
  });
}/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileLifestyleDtoCopyWith<$Res>? get lifestyle {
    if (_self.lifestyle == null) {
    return null;
  }

  return $MyProfileLifestyleDtoCopyWith<$Res>(_self.lifestyle!, (value) {
    return _then(_self.copyWith(lifestyle: value));
  });
}/// Create a copy of MyProfileDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyProfileInterestsDtoCopyWith<$Res>? get interests {
    if (_self.interests == null) {
    return null;
  }

  return $MyProfileInterestsDtoCopyWith<$Res>(_self.interests!, (value) {
    return _then(_self.copyWith(interests: value));
  });
}
}


/// @nodoc
mixin _$MyProfileFaceVerificationDto {

 bool get isFaceVerified;
/// Create a copy of MyProfileFaceVerificationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileFaceVerificationDtoCopyWith<MyProfileFaceVerificationDto> get copyWith => _$MyProfileFaceVerificationDtoCopyWithImpl<MyProfileFaceVerificationDto>(this as MyProfileFaceVerificationDto, _$identity);

  /// Serializes this MyProfileFaceVerificationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileFaceVerificationDto&&(identical(other.isFaceVerified, isFaceVerified) || other.isFaceVerified == isFaceVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFaceVerified);

@override
String toString() {
  return 'MyProfileFaceVerificationDto(isFaceVerified: $isFaceVerified)';
}


}

/// @nodoc
abstract mixin class $MyProfileFaceVerificationDtoCopyWith<$Res>  {
  factory $MyProfileFaceVerificationDtoCopyWith(MyProfileFaceVerificationDto value, $Res Function(MyProfileFaceVerificationDto) _then) = _$MyProfileFaceVerificationDtoCopyWithImpl;
@useResult
$Res call({
 bool isFaceVerified
});




}
/// @nodoc
class _$MyProfileFaceVerificationDtoCopyWithImpl<$Res>
    implements $MyProfileFaceVerificationDtoCopyWith<$Res> {
  _$MyProfileFaceVerificationDtoCopyWithImpl(this._self, this._then);

  final MyProfileFaceVerificationDto _self;
  final $Res Function(MyProfileFaceVerificationDto) _then;

/// Create a copy of MyProfileFaceVerificationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isFaceVerified = null,}) {
  return _then(_self.copyWith(
isFaceVerified: null == isFaceVerified ? _self.isFaceVerified : isFaceVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MyProfileFaceVerificationDto].
extension MyProfileFaceVerificationDtoPatterns on MyProfileFaceVerificationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfileFaceVerificationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfileFaceVerificationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfileFaceVerificationDto value)  $default,){
final _that = this;
switch (_that) {
case _MyProfileFaceVerificationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfileFaceVerificationDto value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfileFaceVerificationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isFaceVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyProfileFaceVerificationDto() when $default != null:
return $default(_that.isFaceVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isFaceVerified)  $default,) {final _that = this;
switch (_that) {
case _MyProfileFaceVerificationDto():
return $default(_that.isFaceVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isFaceVerified)?  $default,) {final _that = this;
switch (_that) {
case _MyProfileFaceVerificationDto() when $default != null:
return $default(_that.isFaceVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyProfileFaceVerificationDto implements MyProfileFaceVerificationDto {
  const _MyProfileFaceVerificationDto({this.isFaceVerified = false});
  factory _MyProfileFaceVerificationDto.fromJson(Map<String, dynamic> json) => _$MyProfileFaceVerificationDtoFromJson(json);

@override@JsonKey() final  bool isFaceVerified;

/// Create a copy of MyProfileFaceVerificationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileFaceVerificationDtoCopyWith<_MyProfileFaceVerificationDto> get copyWith => __$MyProfileFaceVerificationDtoCopyWithImpl<_MyProfileFaceVerificationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyProfileFaceVerificationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfileFaceVerificationDto&&(identical(other.isFaceVerified, isFaceVerified) || other.isFaceVerified == isFaceVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFaceVerified);

@override
String toString() {
  return 'MyProfileFaceVerificationDto(isFaceVerified: $isFaceVerified)';
}


}

/// @nodoc
abstract mixin class _$MyProfileFaceVerificationDtoCopyWith<$Res> implements $MyProfileFaceVerificationDtoCopyWith<$Res> {
  factory _$MyProfileFaceVerificationDtoCopyWith(_MyProfileFaceVerificationDto value, $Res Function(_MyProfileFaceVerificationDto) _then) = __$MyProfileFaceVerificationDtoCopyWithImpl;
@override @useResult
$Res call({
 bool isFaceVerified
});




}
/// @nodoc
class __$MyProfileFaceVerificationDtoCopyWithImpl<$Res>
    implements _$MyProfileFaceVerificationDtoCopyWith<$Res> {
  __$MyProfileFaceVerificationDtoCopyWithImpl(this._self, this._then);

  final _MyProfileFaceVerificationDto _self;
  final $Res Function(_MyProfileFaceVerificationDto) _then;

/// Create a copy of MyProfileFaceVerificationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isFaceVerified = null,}) {
  return _then(_MyProfileFaceVerificationDto(
isFaceVerified: null == isFaceVerified ? _self.isFaceVerified : isFaceVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MyProfileAboutYouDto {

 bool? get bornMuslim; bool? get haveChildren; bool? get relocateAbroad;
/// Create a copy of MyProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileAboutYouDtoCopyWith<MyProfileAboutYouDto> get copyWith => _$MyProfileAboutYouDtoCopyWithImpl<MyProfileAboutYouDto>(this as MyProfileAboutYouDto, _$identity);

  /// Serializes this MyProfileAboutYouDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileAboutYouDto&&(identical(other.bornMuslim, bornMuslim) || other.bornMuslim == bornMuslim)&&(identical(other.haveChildren, haveChildren) || other.haveChildren == haveChildren)&&(identical(other.relocateAbroad, relocateAbroad) || other.relocateAbroad == relocateAbroad));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bornMuslim,haveChildren,relocateAbroad);

@override
String toString() {
  return 'MyProfileAboutYouDto(bornMuslim: $bornMuslim, haveChildren: $haveChildren, relocateAbroad: $relocateAbroad)';
}


}

/// @nodoc
abstract mixin class $MyProfileAboutYouDtoCopyWith<$Res>  {
  factory $MyProfileAboutYouDtoCopyWith(MyProfileAboutYouDto value, $Res Function(MyProfileAboutYouDto) _then) = _$MyProfileAboutYouDtoCopyWithImpl;
@useResult
$Res call({
 bool? bornMuslim, bool? haveChildren, bool? relocateAbroad
});




}
/// @nodoc
class _$MyProfileAboutYouDtoCopyWithImpl<$Res>
    implements $MyProfileAboutYouDtoCopyWith<$Res> {
  _$MyProfileAboutYouDtoCopyWithImpl(this._self, this._then);

  final MyProfileAboutYouDto _self;
  final $Res Function(MyProfileAboutYouDto) _then;

/// Create a copy of MyProfileAboutYouDto
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


/// Adds pattern-matching-related methods to [MyProfileAboutYouDto].
extension MyProfileAboutYouDtoPatterns on MyProfileAboutYouDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfileAboutYouDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfileAboutYouDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfileAboutYouDto value)  $default,){
final _that = this;
switch (_that) {
case _MyProfileAboutYouDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfileAboutYouDto value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfileAboutYouDto() when $default != null:
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
case _MyProfileAboutYouDto() when $default != null:
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
case _MyProfileAboutYouDto():
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
case _MyProfileAboutYouDto() when $default != null:
return $default(_that.bornMuslim,_that.haveChildren,_that.relocateAbroad);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyProfileAboutYouDto implements MyProfileAboutYouDto {
  const _MyProfileAboutYouDto({this.bornMuslim, this.haveChildren, this.relocateAbroad});
  factory _MyProfileAboutYouDto.fromJson(Map<String, dynamic> json) => _$MyProfileAboutYouDtoFromJson(json);

@override final  bool? bornMuslim;
@override final  bool? haveChildren;
@override final  bool? relocateAbroad;

/// Create a copy of MyProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileAboutYouDtoCopyWith<_MyProfileAboutYouDto> get copyWith => __$MyProfileAboutYouDtoCopyWithImpl<_MyProfileAboutYouDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyProfileAboutYouDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfileAboutYouDto&&(identical(other.bornMuslim, bornMuslim) || other.bornMuslim == bornMuslim)&&(identical(other.haveChildren, haveChildren) || other.haveChildren == haveChildren)&&(identical(other.relocateAbroad, relocateAbroad) || other.relocateAbroad == relocateAbroad));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bornMuslim,haveChildren,relocateAbroad);

@override
String toString() {
  return 'MyProfileAboutYouDto(bornMuslim: $bornMuslim, haveChildren: $haveChildren, relocateAbroad: $relocateAbroad)';
}


}

/// @nodoc
abstract mixin class _$MyProfileAboutYouDtoCopyWith<$Res> implements $MyProfileAboutYouDtoCopyWith<$Res> {
  factory _$MyProfileAboutYouDtoCopyWith(_MyProfileAboutYouDto value, $Res Function(_MyProfileAboutYouDto) _then) = __$MyProfileAboutYouDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? bornMuslim, bool? haveChildren, bool? relocateAbroad
});




}
/// @nodoc
class __$MyProfileAboutYouDtoCopyWithImpl<$Res>
    implements _$MyProfileAboutYouDtoCopyWith<$Res> {
  __$MyProfileAboutYouDtoCopyWithImpl(this._self, this._then);

  final _MyProfileAboutYouDto _self;
  final $Res Function(_MyProfileAboutYouDto) _then;

/// Create a copy of MyProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bornMuslim = freezed,Object? haveChildren = freezed,Object? relocateAbroad = freezed,}) {
  return _then(_MyProfileAboutYouDto(
bornMuslim: freezed == bornMuslim ? _self.bornMuslim : bornMuslim // ignore: cast_nullable_to_non_nullable
as bool?,haveChildren: freezed == haveChildren ? _self.haveChildren : haveChildren // ignore: cast_nullable_to_non_nullable
as bool?,relocateAbroad: freezed == relocateAbroad ? _self.relocateAbroad : relocateAbroad // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$MyProfileLifestyleDto {

 bool? get halalFood; bool? get smoking; bool? get alcohol;
/// Create a copy of MyProfileLifestyleDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileLifestyleDtoCopyWith<MyProfileLifestyleDto> get copyWith => _$MyProfileLifestyleDtoCopyWithImpl<MyProfileLifestyleDto>(this as MyProfileLifestyleDto, _$identity);

  /// Serializes this MyProfileLifestyleDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileLifestyleDto&&(identical(other.halalFood, halalFood) || other.halalFood == halalFood)&&(identical(other.smoking, smoking) || other.smoking == smoking)&&(identical(other.alcohol, alcohol) || other.alcohol == alcohol));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,halalFood,smoking,alcohol);

@override
String toString() {
  return 'MyProfileLifestyleDto(halalFood: $halalFood, smoking: $smoking, alcohol: $alcohol)';
}


}

/// @nodoc
abstract mixin class $MyProfileLifestyleDtoCopyWith<$Res>  {
  factory $MyProfileLifestyleDtoCopyWith(MyProfileLifestyleDto value, $Res Function(MyProfileLifestyleDto) _then) = _$MyProfileLifestyleDtoCopyWithImpl;
@useResult
$Res call({
 bool? halalFood, bool? smoking, bool? alcohol
});




}
/// @nodoc
class _$MyProfileLifestyleDtoCopyWithImpl<$Res>
    implements $MyProfileLifestyleDtoCopyWith<$Res> {
  _$MyProfileLifestyleDtoCopyWithImpl(this._self, this._then);

  final MyProfileLifestyleDto _self;
  final $Res Function(MyProfileLifestyleDto) _then;

/// Create a copy of MyProfileLifestyleDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? halalFood = freezed,Object? smoking = freezed,Object? alcohol = freezed,}) {
  return _then(_self.copyWith(
halalFood: freezed == halalFood ? _self.halalFood : halalFood // ignore: cast_nullable_to_non_nullable
as bool?,smoking: freezed == smoking ? _self.smoking : smoking // ignore: cast_nullable_to_non_nullable
as bool?,alcohol: freezed == alcohol ? _self.alcohol : alcohol // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyProfileLifestyleDto].
extension MyProfileLifestyleDtoPatterns on MyProfileLifestyleDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfileLifestyleDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfileLifestyleDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfileLifestyleDto value)  $default,){
final _that = this;
switch (_that) {
case _MyProfileLifestyleDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfileLifestyleDto value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfileLifestyleDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? halalFood,  bool? smoking,  bool? alcohol)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyProfileLifestyleDto() when $default != null:
return $default(_that.halalFood,_that.smoking,_that.alcohol);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? halalFood,  bool? smoking,  bool? alcohol)  $default,) {final _that = this;
switch (_that) {
case _MyProfileLifestyleDto():
return $default(_that.halalFood,_that.smoking,_that.alcohol);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? halalFood,  bool? smoking,  bool? alcohol)?  $default,) {final _that = this;
switch (_that) {
case _MyProfileLifestyleDto() when $default != null:
return $default(_that.halalFood,_that.smoking,_that.alcohol);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyProfileLifestyleDto implements MyProfileLifestyleDto {
  const _MyProfileLifestyleDto({this.halalFood, this.smoking, this.alcohol});
  factory _MyProfileLifestyleDto.fromJson(Map<String, dynamic> json) => _$MyProfileLifestyleDtoFromJson(json);

@override final  bool? halalFood;
@override final  bool? smoking;
@override final  bool? alcohol;

/// Create a copy of MyProfileLifestyleDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileLifestyleDtoCopyWith<_MyProfileLifestyleDto> get copyWith => __$MyProfileLifestyleDtoCopyWithImpl<_MyProfileLifestyleDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyProfileLifestyleDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfileLifestyleDto&&(identical(other.halalFood, halalFood) || other.halalFood == halalFood)&&(identical(other.smoking, smoking) || other.smoking == smoking)&&(identical(other.alcohol, alcohol) || other.alcohol == alcohol));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,halalFood,smoking,alcohol);

@override
String toString() {
  return 'MyProfileLifestyleDto(halalFood: $halalFood, smoking: $smoking, alcohol: $alcohol)';
}


}

/// @nodoc
abstract mixin class _$MyProfileLifestyleDtoCopyWith<$Res> implements $MyProfileLifestyleDtoCopyWith<$Res> {
  factory _$MyProfileLifestyleDtoCopyWith(_MyProfileLifestyleDto value, $Res Function(_MyProfileLifestyleDto) _then) = __$MyProfileLifestyleDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? halalFood, bool? smoking, bool? alcohol
});




}
/// @nodoc
class __$MyProfileLifestyleDtoCopyWithImpl<$Res>
    implements _$MyProfileLifestyleDtoCopyWith<$Res> {
  __$MyProfileLifestyleDtoCopyWithImpl(this._self, this._then);

  final _MyProfileLifestyleDto _self;
  final $Res Function(_MyProfileLifestyleDto) _then;

/// Create a copy of MyProfileLifestyleDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? halalFood = freezed,Object? smoking = freezed,Object? alcohol = freezed,}) {
  return _then(_MyProfileLifestyleDto(
halalFood: freezed == halalFood ? _self.halalFood : halalFood // ignore: cast_nullable_to_non_nullable
as bool?,smoking: freezed == smoking ? _self.smoking : smoking // ignore: cast_nullable_to_non_nullable
as bool?,alcohol: freezed == alcohol ? _self.alcohol : alcohol // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$MyProfileInterestsDto {

 List<String> get cultural; List<String> get foodDrinks; List<String> get sports; List<String> get fashion; List<String> get activities;
/// Create a copy of MyProfileInterestsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileInterestsDtoCopyWith<MyProfileInterestsDto> get copyWith => _$MyProfileInterestsDtoCopyWithImpl<MyProfileInterestsDto>(this as MyProfileInterestsDto, _$identity);

  /// Serializes this MyProfileInterestsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfileInterestsDto&&const DeepCollectionEquality().equals(other.cultural, cultural)&&const DeepCollectionEquality().equals(other.foodDrinks, foodDrinks)&&const DeepCollectionEquality().equals(other.sports, sports)&&const DeepCollectionEquality().equals(other.fashion, fashion)&&const DeepCollectionEquality().equals(other.activities, activities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cultural),const DeepCollectionEquality().hash(foodDrinks),const DeepCollectionEquality().hash(sports),const DeepCollectionEquality().hash(fashion),const DeepCollectionEquality().hash(activities));

@override
String toString() {
  return 'MyProfileInterestsDto(cultural: $cultural, foodDrinks: $foodDrinks, sports: $sports, fashion: $fashion, activities: $activities)';
}


}

/// @nodoc
abstract mixin class $MyProfileInterestsDtoCopyWith<$Res>  {
  factory $MyProfileInterestsDtoCopyWith(MyProfileInterestsDto value, $Res Function(MyProfileInterestsDto) _then) = _$MyProfileInterestsDtoCopyWithImpl;
@useResult
$Res call({
 List<String> cultural, List<String> foodDrinks, List<String> sports, List<String> fashion, List<String> activities
});




}
/// @nodoc
class _$MyProfileInterestsDtoCopyWithImpl<$Res>
    implements $MyProfileInterestsDtoCopyWith<$Res> {
  _$MyProfileInterestsDtoCopyWithImpl(this._self, this._then);

  final MyProfileInterestsDto _self;
  final $Res Function(MyProfileInterestsDto) _then;

/// Create a copy of MyProfileInterestsDto
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


/// Adds pattern-matching-related methods to [MyProfileInterestsDto].
extension MyProfileInterestsDtoPatterns on MyProfileInterestsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfileInterestsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfileInterestsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfileInterestsDto value)  $default,){
final _that = this;
switch (_that) {
case _MyProfileInterestsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfileInterestsDto value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfileInterestsDto() when $default != null:
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
case _MyProfileInterestsDto() when $default != null:
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
case _MyProfileInterestsDto():
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
case _MyProfileInterestsDto() when $default != null:
return $default(_that.cultural,_that.foodDrinks,_that.sports,_that.fashion,_that.activities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyProfileInterestsDto implements MyProfileInterestsDto {
  const _MyProfileInterestsDto({final  List<String> cultural = const <String>[], final  List<String> foodDrinks = const <String>[], final  List<String> sports = const <String>[], final  List<String> fashion = const <String>[], final  List<String> activities = const <String>[]}): _cultural = cultural,_foodDrinks = foodDrinks,_sports = sports,_fashion = fashion,_activities = activities;
  factory _MyProfileInterestsDto.fromJson(Map<String, dynamic> json) => _$MyProfileInterestsDtoFromJson(json);

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


/// Create a copy of MyProfileInterestsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileInterestsDtoCopyWith<_MyProfileInterestsDto> get copyWith => __$MyProfileInterestsDtoCopyWithImpl<_MyProfileInterestsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyProfileInterestsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfileInterestsDto&&const DeepCollectionEquality().equals(other._cultural, _cultural)&&const DeepCollectionEquality().equals(other._foodDrinks, _foodDrinks)&&const DeepCollectionEquality().equals(other._sports, _sports)&&const DeepCollectionEquality().equals(other._fashion, _fashion)&&const DeepCollectionEquality().equals(other._activities, _activities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cultural),const DeepCollectionEquality().hash(_foodDrinks),const DeepCollectionEquality().hash(_sports),const DeepCollectionEquality().hash(_fashion),const DeepCollectionEquality().hash(_activities));

@override
String toString() {
  return 'MyProfileInterestsDto(cultural: $cultural, foodDrinks: $foodDrinks, sports: $sports, fashion: $fashion, activities: $activities)';
}


}

/// @nodoc
abstract mixin class _$MyProfileInterestsDtoCopyWith<$Res> implements $MyProfileInterestsDtoCopyWith<$Res> {
  factory _$MyProfileInterestsDtoCopyWith(_MyProfileInterestsDto value, $Res Function(_MyProfileInterestsDto) _then) = __$MyProfileInterestsDtoCopyWithImpl;
@override @useResult
$Res call({
 List<String> cultural, List<String> foodDrinks, List<String> sports, List<String> fashion, List<String> activities
});




}
/// @nodoc
class __$MyProfileInterestsDtoCopyWithImpl<$Res>
    implements _$MyProfileInterestsDtoCopyWith<$Res> {
  __$MyProfileInterestsDtoCopyWithImpl(this._self, this._then);

  final _MyProfileInterestsDto _self;
  final $Res Function(_MyProfileInterestsDto) _then;

/// Create a copy of MyProfileInterestsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cultural = null,Object? foodDrinks = null,Object? sports = null,Object? fashion = null,Object? activities = null,}) {
  return _then(_MyProfileInterestsDto(
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
