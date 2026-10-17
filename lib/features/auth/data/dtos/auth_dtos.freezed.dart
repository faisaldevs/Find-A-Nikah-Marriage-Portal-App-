// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthApiSessionResponseDto {

 AuthApiSessionDataDto get data;
/// Create a copy of AuthApiSessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthApiSessionResponseDtoCopyWith<AuthApiSessionResponseDto> get copyWith => _$AuthApiSessionResponseDtoCopyWithImpl<AuthApiSessionResponseDto>(this as AuthApiSessionResponseDto, _$identity);

  /// Serializes this AuthApiSessionResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthApiSessionResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'AuthApiSessionResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $AuthApiSessionResponseDtoCopyWith<$Res>  {
  factory $AuthApiSessionResponseDtoCopyWith(AuthApiSessionResponseDto value, $Res Function(AuthApiSessionResponseDto) _then) = _$AuthApiSessionResponseDtoCopyWithImpl;
@useResult
$Res call({
 AuthApiSessionDataDto data
});


$AuthApiSessionDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$AuthApiSessionResponseDtoCopyWithImpl<$Res>
    implements $AuthApiSessionResponseDtoCopyWith<$Res> {
  _$AuthApiSessionResponseDtoCopyWithImpl(this._self, this._then);

  final AuthApiSessionResponseDto _self;
  final $Res Function(AuthApiSessionResponseDto) _then;

/// Create a copy of AuthApiSessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthApiSessionDataDto,
  ));
}
/// Create a copy of AuthApiSessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthApiSessionDataDtoCopyWith<$Res> get data {
  
  return $AuthApiSessionDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthApiSessionResponseDto].
extension AuthApiSessionResponseDtoPatterns on AuthApiSessionResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthApiSessionResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthApiSessionResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthApiSessionResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthApiSessionResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthApiSessionResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthApiSessionResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthApiSessionDataDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthApiSessionResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthApiSessionDataDto data)  $default,) {final _that = this;
switch (_that) {
case _AuthApiSessionResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthApiSessionDataDto data)?  $default,) {final _that = this;
switch (_that) {
case _AuthApiSessionResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthApiSessionResponseDto implements AuthApiSessionResponseDto {
  const _AuthApiSessionResponseDto({required this.data});
  factory _AuthApiSessionResponseDto.fromJson(Map<String, dynamic> json) => _$AuthApiSessionResponseDtoFromJson(json);

@override final  AuthApiSessionDataDto data;

/// Create a copy of AuthApiSessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthApiSessionResponseDtoCopyWith<_AuthApiSessionResponseDto> get copyWith => __$AuthApiSessionResponseDtoCopyWithImpl<_AuthApiSessionResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthApiSessionResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthApiSessionResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'AuthApiSessionResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$AuthApiSessionResponseDtoCopyWith<$Res> implements $AuthApiSessionResponseDtoCopyWith<$Res> {
  factory _$AuthApiSessionResponseDtoCopyWith(_AuthApiSessionResponseDto value, $Res Function(_AuthApiSessionResponseDto) _then) = __$AuthApiSessionResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 AuthApiSessionDataDto data
});


@override $AuthApiSessionDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$AuthApiSessionResponseDtoCopyWithImpl<$Res>
    implements _$AuthApiSessionResponseDtoCopyWith<$Res> {
  __$AuthApiSessionResponseDtoCopyWithImpl(this._self, this._then);

  final _AuthApiSessionResponseDto _self;
  final $Res Function(_AuthApiSessionResponseDto) _then;

/// Create a copy of AuthApiSessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_AuthApiSessionResponseDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AuthApiSessionDataDto,
  ));
}

/// Create a copy of AuthApiSessionResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthApiSessionDataDtoCopyWith<$Res> get data {
  
  return $AuthApiSessionDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$AuthApiSessionDataDto {

 String get accessToken; String get refreshToken; AuthApiSessionUserDto get user;
/// Create a copy of AuthApiSessionDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthApiSessionDataDtoCopyWith<AuthApiSessionDataDto> get copyWith => _$AuthApiSessionDataDtoCopyWithImpl<AuthApiSessionDataDto>(this as AuthApiSessionDataDto, _$identity);

  /// Serializes this AuthApiSessionDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthApiSessionDataDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,user);

@override
String toString() {
  return 'AuthApiSessionDataDto(accessToken: $accessToken, refreshToken: $refreshToken, user: $user)';
}


}

/// @nodoc
abstract mixin class $AuthApiSessionDataDtoCopyWith<$Res>  {
  factory $AuthApiSessionDataDtoCopyWith(AuthApiSessionDataDto value, $Res Function(AuthApiSessionDataDto) _then) = _$AuthApiSessionDataDtoCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, AuthApiSessionUserDto user
});


$AuthApiSessionUserDtoCopyWith<$Res> get user;

}
/// @nodoc
class _$AuthApiSessionDataDtoCopyWithImpl<$Res>
    implements $AuthApiSessionDataDtoCopyWith<$Res> {
  _$AuthApiSessionDataDtoCopyWithImpl(this._self, this._then);

  final AuthApiSessionDataDto _self;
  final $Res Function(AuthApiSessionDataDto) _then;

/// Create a copy of AuthApiSessionDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? user = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthApiSessionUserDto,
  ));
}
/// Create a copy of AuthApiSessionDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthApiSessionUserDtoCopyWith<$Res> get user {
  
  return $AuthApiSessionUserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthApiSessionDataDto].
extension AuthApiSessionDataDtoPatterns on AuthApiSessionDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthApiSessionDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthApiSessionDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthApiSessionDataDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthApiSessionDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthApiSessionDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthApiSessionDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  AuthApiSessionUserDto user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthApiSessionDataDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  AuthApiSessionUserDto user)  $default,) {final _that = this;
switch (_that) {
case _AuthApiSessionDataDto():
return $default(_that.accessToken,_that.refreshToken,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  AuthApiSessionUserDto user)?  $default,) {final _that = this;
switch (_that) {
case _AuthApiSessionDataDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthApiSessionDataDto implements AuthApiSessionDataDto {
  const _AuthApiSessionDataDto({required this.accessToken, required this.refreshToken, required this.user});
  factory _AuthApiSessionDataDto.fromJson(Map<String, dynamic> json) => _$AuthApiSessionDataDtoFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
@override final  AuthApiSessionUserDto user;

/// Create a copy of AuthApiSessionDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthApiSessionDataDtoCopyWith<_AuthApiSessionDataDto> get copyWith => __$AuthApiSessionDataDtoCopyWithImpl<_AuthApiSessionDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthApiSessionDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthApiSessionDataDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,user);

@override
String toString() {
  return 'AuthApiSessionDataDto(accessToken: $accessToken, refreshToken: $refreshToken, user: $user)';
}


}

/// @nodoc
abstract mixin class _$AuthApiSessionDataDtoCopyWith<$Res> implements $AuthApiSessionDataDtoCopyWith<$Res> {
  factory _$AuthApiSessionDataDtoCopyWith(_AuthApiSessionDataDto value, $Res Function(_AuthApiSessionDataDto) _then) = __$AuthApiSessionDataDtoCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, AuthApiSessionUserDto user
});


@override $AuthApiSessionUserDtoCopyWith<$Res> get user;

}
/// @nodoc
class __$AuthApiSessionDataDtoCopyWithImpl<$Res>
    implements _$AuthApiSessionDataDtoCopyWith<$Res> {
  __$AuthApiSessionDataDtoCopyWithImpl(this._self, this._then);

  final _AuthApiSessionDataDto _self;
  final $Res Function(_AuthApiSessionDataDto) _then;

/// Create a copy of AuthApiSessionDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? user = null,}) {
  return _then(_AuthApiSessionDataDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as AuthApiSessionUserDto,
  ));
}

/// Create a copy of AuthApiSessionDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthApiSessionUserDtoCopyWith<$Res> get user {
  
  return $AuthApiSessionUserDtoCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$AuthApiSessionUserDto {

@JsonKey(name: '_id') String get userId;@JsonKey(name: 'isOnboardingComplete') bool get onboardingComplete;
/// Create a copy of AuthApiSessionUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthApiSessionUserDtoCopyWith<AuthApiSessionUserDto> get copyWith => _$AuthApiSessionUserDtoCopyWithImpl<AuthApiSessionUserDto>(this as AuthApiSessionUserDto, _$identity);

  /// Serializes this AuthApiSessionUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthApiSessionUserDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,onboardingComplete);

@override
String toString() {
  return 'AuthApiSessionUserDto(userId: $userId, onboardingComplete: $onboardingComplete)';
}


}

/// @nodoc
abstract mixin class $AuthApiSessionUserDtoCopyWith<$Res>  {
  factory $AuthApiSessionUserDtoCopyWith(AuthApiSessionUserDto value, $Res Function(AuthApiSessionUserDto) _then) = _$AuthApiSessionUserDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_id') String userId,@JsonKey(name: 'isOnboardingComplete') bool onboardingComplete
});




}
/// @nodoc
class _$AuthApiSessionUserDtoCopyWithImpl<$Res>
    implements $AuthApiSessionUserDtoCopyWith<$Res> {
  _$AuthApiSessionUserDtoCopyWithImpl(this._self, this._then);

  final AuthApiSessionUserDto _self;
  final $Res Function(AuthApiSessionUserDto) _then;

/// Create a copy of AuthApiSessionUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? onboardingComplete = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthApiSessionUserDto].
extension AuthApiSessionUserDtoPatterns on AuthApiSessionUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthApiSessionUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthApiSessionUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthApiSessionUserDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthApiSessionUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthApiSessionUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthApiSessionUserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String userId, @JsonKey(name: 'isOnboardingComplete')  bool onboardingComplete)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthApiSessionUserDto() when $default != null:
return $default(_that.userId,_that.onboardingComplete);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_id')  String userId, @JsonKey(name: 'isOnboardingComplete')  bool onboardingComplete)  $default,) {final _that = this;
switch (_that) {
case _AuthApiSessionUserDto():
return $default(_that.userId,_that.onboardingComplete);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_id')  String userId, @JsonKey(name: 'isOnboardingComplete')  bool onboardingComplete)?  $default,) {final _that = this;
switch (_that) {
case _AuthApiSessionUserDto() when $default != null:
return $default(_that.userId,_that.onboardingComplete);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthApiSessionUserDto implements AuthApiSessionUserDto {
  const _AuthApiSessionUserDto({@JsonKey(name: '_id') required this.userId, @JsonKey(name: 'isOnboardingComplete') required this.onboardingComplete});
  factory _AuthApiSessionUserDto.fromJson(Map<String, dynamic> json) => _$AuthApiSessionUserDtoFromJson(json);

@override@JsonKey(name: '_id') final  String userId;
@override@JsonKey(name: 'isOnboardingComplete') final  bool onboardingComplete;

/// Create a copy of AuthApiSessionUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthApiSessionUserDtoCopyWith<_AuthApiSessionUserDto> get copyWith => __$AuthApiSessionUserDtoCopyWithImpl<_AuthApiSessionUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthApiSessionUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthApiSessionUserDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,onboardingComplete);

@override
String toString() {
  return 'AuthApiSessionUserDto(userId: $userId, onboardingComplete: $onboardingComplete)';
}


}

/// @nodoc
abstract mixin class _$AuthApiSessionUserDtoCopyWith<$Res> implements $AuthApiSessionUserDtoCopyWith<$Res> {
  factory _$AuthApiSessionUserDtoCopyWith(_AuthApiSessionUserDto value, $Res Function(_AuthApiSessionUserDto) _then) = __$AuthApiSessionUserDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_id') String userId,@JsonKey(name: 'isOnboardingComplete') bool onboardingComplete
});




}
/// @nodoc
class __$AuthApiSessionUserDtoCopyWithImpl<$Res>
    implements _$AuthApiSessionUserDtoCopyWith<$Res> {
  __$AuthApiSessionUserDtoCopyWithImpl(this._self, this._then);

  final _AuthApiSessionUserDto _self;
  final $Res Function(_AuthApiSessionUserDto) _then;

/// Create a copy of AuthApiSessionUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? onboardingComplete = null,}) {
  return _then(_AuthApiSessionUserDto(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$OnboardingStatusResponseDto {

 OnboardingStatusDataDto get data;
/// Create a copy of OnboardingStatusResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStatusResponseDtoCopyWith<OnboardingStatusResponseDto> get copyWith => _$OnboardingStatusResponseDtoCopyWithImpl<OnboardingStatusResponseDto>(this as OnboardingStatusResponseDto, _$identity);

  /// Serializes this OnboardingStatusResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStatusResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'OnboardingStatusResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $OnboardingStatusResponseDtoCopyWith<$Res>  {
  factory $OnboardingStatusResponseDtoCopyWith(OnboardingStatusResponseDto value, $Res Function(OnboardingStatusResponseDto) _then) = _$OnboardingStatusResponseDtoCopyWithImpl;
@useResult
$Res call({
 OnboardingStatusDataDto data
});


$OnboardingStatusDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$OnboardingStatusResponseDtoCopyWithImpl<$Res>
    implements $OnboardingStatusResponseDtoCopyWith<$Res> {
  _$OnboardingStatusResponseDtoCopyWithImpl(this._self, this._then);

  final OnboardingStatusResponseDto _self;
  final $Res Function(OnboardingStatusResponseDto) _then;

/// Create a copy of OnboardingStatusResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OnboardingStatusDataDto,
  ));
}
/// Create a copy of OnboardingStatusResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStatusDataDtoCopyWith<$Res> get data {
  
  return $OnboardingStatusDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingStatusResponseDto].
extension OnboardingStatusResponseDtoPatterns on OnboardingStatusResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingStatusResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingStatusResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingStatusResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatusResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingStatusResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatusResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OnboardingStatusDataDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStatusResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OnboardingStatusDataDto data)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OnboardingStatusDataDto data)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingStatusResponseDto implements OnboardingStatusResponseDto {
  const _OnboardingStatusResponseDto({required this.data});
  factory _OnboardingStatusResponseDto.fromJson(Map<String, dynamic> json) => _$OnboardingStatusResponseDtoFromJson(json);

@override final  OnboardingStatusDataDto data;

/// Create a copy of OnboardingStatusResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStatusResponseDtoCopyWith<_OnboardingStatusResponseDto> get copyWith => __$OnboardingStatusResponseDtoCopyWithImpl<_OnboardingStatusResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingStatusResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStatusResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'OnboardingStatusResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStatusResponseDtoCopyWith<$Res> implements $OnboardingStatusResponseDtoCopyWith<$Res> {
  factory _$OnboardingStatusResponseDtoCopyWith(_OnboardingStatusResponseDto value, $Res Function(_OnboardingStatusResponseDto) _then) = __$OnboardingStatusResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 OnboardingStatusDataDto data
});


@override $OnboardingStatusDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$OnboardingStatusResponseDtoCopyWithImpl<$Res>
    implements _$OnboardingStatusResponseDtoCopyWith<$Res> {
  __$OnboardingStatusResponseDtoCopyWithImpl(this._self, this._then);

  final _OnboardingStatusResponseDto _self;
  final $Res Function(_OnboardingStatusResponseDto) _then;

/// Create a copy of OnboardingStatusResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_OnboardingStatusResponseDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OnboardingStatusDataDto,
  ));
}

/// Create a copy of OnboardingStatusResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStatusDataDtoCopyWith<$Res> get data {
  
  return $OnboardingStatusDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$OnboardingStatusDataDto {

@JsonKey(name: 'isCompleted') bool get isCompleted;/// Which wizard section the user has yet to finish (4 Basics, 5
/// Background & faith, 6 Lifestyle & personality, 7 Bio — matching
/// `OnboardingSubmissionRepository`'s step literals). Defaults to 4
/// (the first section) if the backend omits it.
@JsonKey(name: 'currentStep') int get currentStep; OnboardingStatusUserDto? get user;/// Only what resume needs (photo count, face check).
 OnboardingStatusProfileDto? get profile;
/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStatusDataDtoCopyWith<OnboardingStatusDataDto> get copyWith => _$OnboardingStatusDataDtoCopyWithImpl<OnboardingStatusDataDto>(this as OnboardingStatusDataDto, _$identity);

  /// Serializes this OnboardingStatusDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStatusDataDto&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isCompleted,currentStep,user,profile);

@override
String toString() {
  return 'OnboardingStatusDataDto(isCompleted: $isCompleted, currentStep: $currentStep, user: $user, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $OnboardingStatusDataDtoCopyWith<$Res>  {
  factory $OnboardingStatusDataDtoCopyWith(OnboardingStatusDataDto value, $Res Function(OnboardingStatusDataDto) _then) = _$OnboardingStatusDataDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'isCompleted') bool isCompleted,@JsonKey(name: 'currentStep') int currentStep, OnboardingStatusUserDto? user, OnboardingStatusProfileDto? profile
});


$OnboardingStatusUserDtoCopyWith<$Res>? get user;$OnboardingStatusProfileDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class _$OnboardingStatusDataDtoCopyWithImpl<$Res>
    implements $OnboardingStatusDataDtoCopyWith<$Res> {
  _$OnboardingStatusDataDtoCopyWithImpl(this._self, this._then);

  final OnboardingStatusDataDto _self;
  final $Res Function(OnboardingStatusDataDto) _then;

/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isCompleted = null,Object? currentStep = null,Object? user = freezed,Object? profile = freezed,}) {
  return _then(_self.copyWith(
isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as OnboardingStatusUserDto?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as OnboardingStatusProfileDto?,
  ));
}
/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStatusUserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $OnboardingStatusUserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStatusProfileDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $OnboardingStatusProfileDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingStatusDataDto].
extension OnboardingStatusDataDtoPatterns on OnboardingStatusDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingStatusDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingStatusDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingStatusDataDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatusDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingStatusDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatusDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'isCompleted')  bool isCompleted, @JsonKey(name: 'currentStep')  int currentStep,  OnboardingStatusUserDto? user,  OnboardingStatusProfileDto? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStatusDataDto() when $default != null:
return $default(_that.isCompleted,_that.currentStep,_that.user,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'isCompleted')  bool isCompleted, @JsonKey(name: 'currentStep')  int currentStep,  OnboardingStatusUserDto? user,  OnboardingStatusProfileDto? profile)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusDataDto():
return $default(_that.isCompleted,_that.currentStep,_that.user,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'isCompleted')  bool isCompleted, @JsonKey(name: 'currentStep')  int currentStep,  OnboardingStatusUserDto? user,  OnboardingStatusProfileDto? profile)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusDataDto() when $default != null:
return $default(_that.isCompleted,_that.currentStep,_that.user,_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingStatusDataDto implements OnboardingStatusDataDto {
  const _OnboardingStatusDataDto({@JsonKey(name: 'isCompleted') required this.isCompleted, @JsonKey(name: 'currentStep') this.currentStep = 4, this.user, this.profile});
  factory _OnboardingStatusDataDto.fromJson(Map<String, dynamic> json) => _$OnboardingStatusDataDtoFromJson(json);

@override@JsonKey(name: 'isCompleted') final  bool isCompleted;
/// Which wizard section the user has yet to finish (4 Basics, 5
/// Background & faith, 6 Lifestyle & personality, 7 Bio — matching
/// `OnboardingSubmissionRepository`'s step literals). Defaults to 4
/// (the first section) if the backend omits it.
@override@JsonKey(name: 'currentStep') final  int currentStep;
@override final  OnboardingStatusUserDto? user;
/// Only what resume needs (photo count, face check).
@override final  OnboardingStatusProfileDto? profile;

/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStatusDataDtoCopyWith<_OnboardingStatusDataDto> get copyWith => __$OnboardingStatusDataDtoCopyWithImpl<_OnboardingStatusDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingStatusDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStatusDataDto&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.user, user) || other.user == user)&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isCompleted,currentStep,user,profile);

@override
String toString() {
  return 'OnboardingStatusDataDto(isCompleted: $isCompleted, currentStep: $currentStep, user: $user, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStatusDataDtoCopyWith<$Res> implements $OnboardingStatusDataDtoCopyWith<$Res> {
  factory _$OnboardingStatusDataDtoCopyWith(_OnboardingStatusDataDto value, $Res Function(_OnboardingStatusDataDto) _then) = __$OnboardingStatusDataDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'isCompleted') bool isCompleted,@JsonKey(name: 'currentStep') int currentStep, OnboardingStatusUserDto? user, OnboardingStatusProfileDto? profile
});


@override $OnboardingStatusUserDtoCopyWith<$Res>? get user;@override $OnboardingStatusProfileDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class __$OnboardingStatusDataDtoCopyWithImpl<$Res>
    implements _$OnboardingStatusDataDtoCopyWith<$Res> {
  __$OnboardingStatusDataDtoCopyWithImpl(this._self, this._then);

  final _OnboardingStatusDataDto _self;
  final $Res Function(_OnboardingStatusDataDto) _then;

/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isCompleted = null,Object? currentStep = null,Object? user = freezed,Object? profile = freezed,}) {
  return _then(_OnboardingStatusDataDto(
isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as OnboardingStatusUserDto?,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as OnboardingStatusProfileDto?,
  ));
}

/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStatusUserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $OnboardingStatusUserDtoCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStatusProfileDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $OnboardingStatusProfileDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$OnboardingStatusProfileDto {

 List<Object?> get images; Map<String, dynamic>? get faceVerification;
/// Create a copy of OnboardingStatusProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStatusProfileDtoCopyWith<OnboardingStatusProfileDto> get copyWith => _$OnboardingStatusProfileDtoCopyWithImpl<OnboardingStatusProfileDto>(this as OnboardingStatusProfileDto, _$identity);

  /// Serializes this OnboardingStatusProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStatusProfileDto&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.faceVerification, faceVerification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(faceVerification));

@override
String toString() {
  return 'OnboardingStatusProfileDto(images: $images, faceVerification: $faceVerification)';
}


}

/// @nodoc
abstract mixin class $OnboardingStatusProfileDtoCopyWith<$Res>  {
  factory $OnboardingStatusProfileDtoCopyWith(OnboardingStatusProfileDto value, $Res Function(OnboardingStatusProfileDto) _then) = _$OnboardingStatusProfileDtoCopyWithImpl;
@useResult
$Res call({
 List<Object?> images, Map<String, dynamic>? faceVerification
});




}
/// @nodoc
class _$OnboardingStatusProfileDtoCopyWithImpl<$Res>
    implements $OnboardingStatusProfileDtoCopyWith<$Res> {
  _$OnboardingStatusProfileDtoCopyWithImpl(this._self, this._then);

  final OnboardingStatusProfileDto _self;
  final $Res Function(OnboardingStatusProfileDto) _then;

/// Create a copy of OnboardingStatusProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? images = null,Object? faceVerification = freezed,}) {
  return _then(_self.copyWith(
images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<Object?>,faceVerification: freezed == faceVerification ? _self.faceVerification : faceVerification // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingStatusProfileDto].
extension OnboardingStatusProfileDtoPatterns on OnboardingStatusProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingStatusProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingStatusProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingStatusProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatusProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingStatusProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatusProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Object?> images,  Map<String, dynamic>? faceVerification)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStatusProfileDto() when $default != null:
return $default(_that.images,_that.faceVerification);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Object?> images,  Map<String, dynamic>? faceVerification)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusProfileDto():
return $default(_that.images,_that.faceVerification);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Object?> images,  Map<String, dynamic>? faceVerification)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusProfileDto() when $default != null:
return $default(_that.images,_that.faceVerification);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingStatusProfileDto implements OnboardingStatusProfileDto {
  const _OnboardingStatusProfileDto({final  List<Object?> images = const <Object?>[], final  Map<String, dynamic>? faceVerification}): _images = images,_faceVerification = faceVerification;
  factory _OnboardingStatusProfileDto.fromJson(Map<String, dynamic> json) => _$OnboardingStatusProfileDtoFromJson(json);

 final  List<Object?> _images;
@override@JsonKey() List<Object?> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  Map<String, dynamic>? _faceVerification;
@override Map<String, dynamic>? get faceVerification {
  final value = _faceVerification;
  if (value == null) return null;
  if (_faceVerification is EqualUnmodifiableMapView) return _faceVerification;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of OnboardingStatusProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStatusProfileDtoCopyWith<_OnboardingStatusProfileDto> get copyWith => __$OnboardingStatusProfileDtoCopyWithImpl<_OnboardingStatusProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingStatusProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStatusProfileDto&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._faceVerification, _faceVerification));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_faceVerification));

@override
String toString() {
  return 'OnboardingStatusProfileDto(images: $images, faceVerification: $faceVerification)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStatusProfileDtoCopyWith<$Res> implements $OnboardingStatusProfileDtoCopyWith<$Res> {
  factory _$OnboardingStatusProfileDtoCopyWith(_OnboardingStatusProfileDto value, $Res Function(_OnboardingStatusProfileDto) _then) = __$OnboardingStatusProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 List<Object?> images, Map<String, dynamic>? faceVerification
});




}
/// @nodoc
class __$OnboardingStatusProfileDtoCopyWithImpl<$Res>
    implements _$OnboardingStatusProfileDtoCopyWith<$Res> {
  __$OnboardingStatusProfileDtoCopyWithImpl(this._self, this._then);

  final _OnboardingStatusProfileDto _self;
  final $Res Function(_OnboardingStatusProfileDto) _then;

/// Create a copy of OnboardingStatusProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? images = null,Object? faceVerification = freezed,}) {
  return _then(_OnboardingStatusProfileDto(
images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<Object?>,faceVerification: freezed == faceVerification ? _self._faceVerification : faceVerification // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$OnboardingStatusUserDto {

 bool get isPhoneVerified; int get onboardingStep;
/// Create a copy of OnboardingStatusUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStatusUserDtoCopyWith<OnboardingStatusUserDto> get copyWith => _$OnboardingStatusUserDtoCopyWithImpl<OnboardingStatusUserDto>(this as OnboardingStatusUserDto, _$identity);

  /// Serializes this OnboardingStatusUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStatusUserDto&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified)&&(identical(other.onboardingStep, onboardingStep) || other.onboardingStep == onboardingStep));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPhoneVerified,onboardingStep);

@override
String toString() {
  return 'OnboardingStatusUserDto(isPhoneVerified: $isPhoneVerified, onboardingStep: $onboardingStep)';
}


}

/// @nodoc
abstract mixin class $OnboardingStatusUserDtoCopyWith<$Res>  {
  factory $OnboardingStatusUserDtoCopyWith(OnboardingStatusUserDto value, $Res Function(OnboardingStatusUserDto) _then) = _$OnboardingStatusUserDtoCopyWithImpl;
@useResult
$Res call({
 bool isPhoneVerified, int onboardingStep
});




}
/// @nodoc
class _$OnboardingStatusUserDtoCopyWithImpl<$Res>
    implements $OnboardingStatusUserDtoCopyWith<$Res> {
  _$OnboardingStatusUserDtoCopyWithImpl(this._self, this._then);

  final OnboardingStatusUserDto _self;
  final $Res Function(OnboardingStatusUserDto) _then;

/// Create a copy of OnboardingStatusUserDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPhoneVerified = null,Object? onboardingStep = null,}) {
  return _then(_self.copyWith(
isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,onboardingStep: null == onboardingStep ? _self.onboardingStep : onboardingStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingStatusUserDto].
extension OnboardingStatusUserDtoPatterns on OnboardingStatusUserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingStatusUserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingStatusUserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingStatusUserDto value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatusUserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingStatusUserDto value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatusUserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPhoneVerified,  int onboardingStep)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStatusUserDto() when $default != null:
return $default(_that.isPhoneVerified,_that.onboardingStep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPhoneVerified,  int onboardingStep)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusUserDto():
return $default(_that.isPhoneVerified,_that.onboardingStep);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPhoneVerified,  int onboardingStep)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusUserDto() when $default != null:
return $default(_that.isPhoneVerified,_that.onboardingStep);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingStatusUserDto implements OnboardingStatusUserDto {
  const _OnboardingStatusUserDto({this.isPhoneVerified = false, this.onboardingStep = 4});
  factory _OnboardingStatusUserDto.fromJson(Map<String, dynamic> json) => _$OnboardingStatusUserDtoFromJson(json);

@override@JsonKey() final  bool isPhoneVerified;
@override@JsonKey() final  int onboardingStep;

/// Create a copy of OnboardingStatusUserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStatusUserDtoCopyWith<_OnboardingStatusUserDto> get copyWith => __$OnboardingStatusUserDtoCopyWithImpl<_OnboardingStatusUserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingStatusUserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStatusUserDto&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified)&&(identical(other.onboardingStep, onboardingStep) || other.onboardingStep == onboardingStep));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPhoneVerified,onboardingStep);

@override
String toString() {
  return 'OnboardingStatusUserDto(isPhoneVerified: $isPhoneVerified, onboardingStep: $onboardingStep)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStatusUserDtoCopyWith<$Res> implements $OnboardingStatusUserDtoCopyWith<$Res> {
  factory _$OnboardingStatusUserDtoCopyWith(_OnboardingStatusUserDto value, $Res Function(_OnboardingStatusUserDto) _then) = __$OnboardingStatusUserDtoCopyWithImpl;
@override @useResult
$Res call({
 bool isPhoneVerified, int onboardingStep
});




}
/// @nodoc
class __$OnboardingStatusUserDtoCopyWithImpl<$Res>
    implements _$OnboardingStatusUserDtoCopyWith<$Res> {
  __$OnboardingStatusUserDtoCopyWithImpl(this._self, this._then);

  final _OnboardingStatusUserDto _self;
  final $Res Function(_OnboardingStatusUserDto) _then;

/// Create a copy of OnboardingStatusUserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPhoneVerified = null,Object? onboardingStep = null,}) {
  return _then(_OnboardingStatusUserDto(
isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,onboardingStep: null == onboardingStep ? _self.onboardingStep : onboardingStep // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PhoneCodeSentResponseDto {

 PhoneCodeSentDataDto? get data;
/// Create a copy of PhoneCodeSentResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneCodeSentResponseDtoCopyWith<PhoneCodeSentResponseDto> get copyWith => _$PhoneCodeSentResponseDtoCopyWithImpl<PhoneCodeSentResponseDto>(this as PhoneCodeSentResponseDto, _$identity);

  /// Serializes this PhoneCodeSentResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneCodeSentResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'PhoneCodeSentResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $PhoneCodeSentResponseDtoCopyWith<$Res>  {
  factory $PhoneCodeSentResponseDtoCopyWith(PhoneCodeSentResponseDto value, $Res Function(PhoneCodeSentResponseDto) _then) = _$PhoneCodeSentResponseDtoCopyWithImpl;
@useResult
$Res call({
 PhoneCodeSentDataDto? data
});


$PhoneCodeSentDataDtoCopyWith<$Res>? get data;

}
/// @nodoc
class _$PhoneCodeSentResponseDtoCopyWithImpl<$Res>
    implements $PhoneCodeSentResponseDtoCopyWith<$Res> {
  _$PhoneCodeSentResponseDtoCopyWithImpl(this._self, this._then);

  final PhoneCodeSentResponseDto _self;
  final $Res Function(PhoneCodeSentResponseDto) _then;

/// Create a copy of PhoneCodeSentResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PhoneCodeSentDataDto?,
  ));
}
/// Create a copy of PhoneCodeSentResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhoneCodeSentDataDtoCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PhoneCodeSentDataDtoCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [PhoneCodeSentResponseDto].
extension PhoneCodeSentResponseDtoPatterns on PhoneCodeSentResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneCodeSentResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneCodeSentResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneCodeSentResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _PhoneCodeSentResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneCodeSentResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneCodeSentResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PhoneCodeSentDataDto? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneCodeSentResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PhoneCodeSentDataDto? data)  $default,) {final _that = this;
switch (_that) {
case _PhoneCodeSentResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PhoneCodeSentDataDto? data)?  $default,) {final _that = this;
switch (_that) {
case _PhoneCodeSentResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhoneCodeSentResponseDto implements PhoneCodeSentResponseDto {
  const _PhoneCodeSentResponseDto({this.data});
  factory _PhoneCodeSentResponseDto.fromJson(Map<String, dynamic> json) => _$PhoneCodeSentResponseDtoFromJson(json);

@override final  PhoneCodeSentDataDto? data;

/// Create a copy of PhoneCodeSentResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneCodeSentResponseDtoCopyWith<_PhoneCodeSentResponseDto> get copyWith => __$PhoneCodeSentResponseDtoCopyWithImpl<_PhoneCodeSentResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhoneCodeSentResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneCodeSentResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'PhoneCodeSentResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$PhoneCodeSentResponseDtoCopyWith<$Res> implements $PhoneCodeSentResponseDtoCopyWith<$Res> {
  factory _$PhoneCodeSentResponseDtoCopyWith(_PhoneCodeSentResponseDto value, $Res Function(_PhoneCodeSentResponseDto) _then) = __$PhoneCodeSentResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 PhoneCodeSentDataDto? data
});


@override $PhoneCodeSentDataDtoCopyWith<$Res>? get data;

}
/// @nodoc
class __$PhoneCodeSentResponseDtoCopyWithImpl<$Res>
    implements _$PhoneCodeSentResponseDtoCopyWith<$Res> {
  __$PhoneCodeSentResponseDtoCopyWithImpl(this._self, this._then);

  final _PhoneCodeSentResponseDto _self;
  final $Res Function(_PhoneCodeSentResponseDto) _then;

/// Create a copy of PhoneCodeSentResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_PhoneCodeSentResponseDto(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PhoneCodeSentDataDto?,
  ));
}

/// Create a copy of PhoneCodeSentResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhoneCodeSentDataDtoCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PhoneCodeSentDataDtoCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$PhoneCodeSentDataDto {

 String? get devCode; String? get code;
/// Create a copy of PhoneCodeSentDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneCodeSentDataDtoCopyWith<PhoneCodeSentDataDto> get copyWith => _$PhoneCodeSentDataDtoCopyWithImpl<PhoneCodeSentDataDto>(this as PhoneCodeSentDataDto, _$identity);

  /// Serializes this PhoneCodeSentDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneCodeSentDataDto&&(identical(other.devCode, devCode) || other.devCode == devCode)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,devCode,code);

@override
String toString() {
  return 'PhoneCodeSentDataDto(devCode: $devCode, code: $code)';
}


}

/// @nodoc
abstract mixin class $PhoneCodeSentDataDtoCopyWith<$Res>  {
  factory $PhoneCodeSentDataDtoCopyWith(PhoneCodeSentDataDto value, $Res Function(PhoneCodeSentDataDto) _then) = _$PhoneCodeSentDataDtoCopyWithImpl;
@useResult
$Res call({
 String? devCode, String? code
});




}
/// @nodoc
class _$PhoneCodeSentDataDtoCopyWithImpl<$Res>
    implements $PhoneCodeSentDataDtoCopyWith<$Res> {
  _$PhoneCodeSentDataDtoCopyWithImpl(this._self, this._then);

  final PhoneCodeSentDataDto _self;
  final $Res Function(PhoneCodeSentDataDto) _then;

/// Create a copy of PhoneCodeSentDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? devCode = freezed,Object? code = freezed,}) {
  return _then(_self.copyWith(
devCode: freezed == devCode ? _self.devCode : devCode // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoneCodeSentDataDto].
extension PhoneCodeSentDataDtoPatterns on PhoneCodeSentDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneCodeSentDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneCodeSentDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneCodeSentDataDto value)  $default,){
final _that = this;
switch (_that) {
case _PhoneCodeSentDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneCodeSentDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneCodeSentDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? devCode,  String? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneCodeSentDataDto() when $default != null:
return $default(_that.devCode,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? devCode,  String? code)  $default,) {final _that = this;
switch (_that) {
case _PhoneCodeSentDataDto():
return $default(_that.devCode,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? devCode,  String? code)?  $default,) {final _that = this;
switch (_that) {
case _PhoneCodeSentDataDto() when $default != null:
return $default(_that.devCode,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhoneCodeSentDataDto implements PhoneCodeSentDataDto {
  const _PhoneCodeSentDataDto({this.devCode, this.code});
  factory _PhoneCodeSentDataDto.fromJson(Map<String, dynamic> json) => _$PhoneCodeSentDataDtoFromJson(json);

@override final  String? devCode;
@override final  String? code;

/// Create a copy of PhoneCodeSentDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneCodeSentDataDtoCopyWith<_PhoneCodeSentDataDto> get copyWith => __$PhoneCodeSentDataDtoCopyWithImpl<_PhoneCodeSentDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhoneCodeSentDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneCodeSentDataDto&&(identical(other.devCode, devCode) || other.devCode == devCode)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,devCode,code);

@override
String toString() {
  return 'PhoneCodeSentDataDto(devCode: $devCode, code: $code)';
}


}

/// @nodoc
abstract mixin class _$PhoneCodeSentDataDtoCopyWith<$Res> implements $PhoneCodeSentDataDtoCopyWith<$Res> {
  factory _$PhoneCodeSentDataDtoCopyWith(_PhoneCodeSentDataDto value, $Res Function(_PhoneCodeSentDataDto) _then) = __$PhoneCodeSentDataDtoCopyWithImpl;
@override @useResult
$Res call({
 String? devCode, String? code
});




}
/// @nodoc
class __$PhoneCodeSentDataDtoCopyWithImpl<$Res>
    implements _$PhoneCodeSentDataDtoCopyWith<$Res> {
  __$PhoneCodeSentDataDtoCopyWithImpl(this._self, this._then);

  final _PhoneCodeSentDataDto _self;
  final $Res Function(_PhoneCodeSentDataDto) _then;

/// Create a copy of PhoneCodeSentDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? devCode = freezed,Object? code = freezed,}) {
  return _then(_PhoneCodeSentDataDto(
devCode: freezed == devCode ? _self.devCode : devCode // ignore: cast_nullable_to_non_nullable
as String?,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PhoneVerifiedResponseDto {

 PhoneVerifiedDataDto? get data;
/// Create a copy of PhoneVerifiedResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneVerifiedResponseDtoCopyWith<PhoneVerifiedResponseDto> get copyWith => _$PhoneVerifiedResponseDtoCopyWithImpl<PhoneVerifiedResponseDto>(this as PhoneVerifiedResponseDto, _$identity);

  /// Serializes this PhoneVerifiedResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerifiedResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'PhoneVerifiedResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $PhoneVerifiedResponseDtoCopyWith<$Res>  {
  factory $PhoneVerifiedResponseDtoCopyWith(PhoneVerifiedResponseDto value, $Res Function(PhoneVerifiedResponseDto) _then) = _$PhoneVerifiedResponseDtoCopyWithImpl;
@useResult
$Res call({
 PhoneVerifiedDataDto? data
});


$PhoneVerifiedDataDtoCopyWith<$Res>? get data;

}
/// @nodoc
class _$PhoneVerifiedResponseDtoCopyWithImpl<$Res>
    implements $PhoneVerifiedResponseDtoCopyWith<$Res> {
  _$PhoneVerifiedResponseDtoCopyWithImpl(this._self, this._then);

  final PhoneVerifiedResponseDto _self;
  final $Res Function(PhoneVerifiedResponseDto) _then;

/// Create a copy of PhoneVerifiedResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PhoneVerifiedDataDto?,
  ));
}
/// Create a copy of PhoneVerifiedResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhoneVerifiedDataDtoCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PhoneVerifiedDataDtoCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [PhoneVerifiedResponseDto].
extension PhoneVerifiedResponseDtoPatterns on PhoneVerifiedResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneVerifiedResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneVerifiedResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneVerifiedResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _PhoneVerifiedResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneVerifiedResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneVerifiedResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PhoneVerifiedDataDto? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneVerifiedResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PhoneVerifiedDataDto? data)  $default,) {final _that = this;
switch (_that) {
case _PhoneVerifiedResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PhoneVerifiedDataDto? data)?  $default,) {final _that = this;
switch (_that) {
case _PhoneVerifiedResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhoneVerifiedResponseDto implements PhoneVerifiedResponseDto {
  const _PhoneVerifiedResponseDto({this.data});
  factory _PhoneVerifiedResponseDto.fromJson(Map<String, dynamic> json) => _$PhoneVerifiedResponseDtoFromJson(json);

@override final  PhoneVerifiedDataDto? data;

/// Create a copy of PhoneVerifiedResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneVerifiedResponseDtoCopyWith<_PhoneVerifiedResponseDto> get copyWith => __$PhoneVerifiedResponseDtoCopyWithImpl<_PhoneVerifiedResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhoneVerifiedResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneVerifiedResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'PhoneVerifiedResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$PhoneVerifiedResponseDtoCopyWith<$Res> implements $PhoneVerifiedResponseDtoCopyWith<$Res> {
  factory _$PhoneVerifiedResponseDtoCopyWith(_PhoneVerifiedResponseDto value, $Res Function(_PhoneVerifiedResponseDto) _then) = __$PhoneVerifiedResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 PhoneVerifiedDataDto? data
});


@override $PhoneVerifiedDataDtoCopyWith<$Res>? get data;

}
/// @nodoc
class __$PhoneVerifiedResponseDtoCopyWithImpl<$Res>
    implements _$PhoneVerifiedResponseDtoCopyWith<$Res> {
  __$PhoneVerifiedResponseDtoCopyWithImpl(this._self, this._then);

  final _PhoneVerifiedResponseDto _self;
  final $Res Function(_PhoneVerifiedResponseDto) _then;

/// Create a copy of PhoneVerifiedResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_PhoneVerifiedResponseDto(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PhoneVerifiedDataDto?,
  ));
}

/// Create a copy of PhoneVerifiedResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PhoneVerifiedDataDtoCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $PhoneVerifiedDataDtoCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$PhoneVerifiedDataDto {

 bool get isPhoneVerified; bool get verified;
/// Create a copy of PhoneVerifiedDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneVerifiedDataDtoCopyWith<PhoneVerifiedDataDto> get copyWith => _$PhoneVerifiedDataDtoCopyWithImpl<PhoneVerifiedDataDto>(this as PhoneVerifiedDataDto, _$identity);

  /// Serializes this PhoneVerifiedDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerifiedDataDto&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPhoneVerified,verified);

@override
String toString() {
  return 'PhoneVerifiedDataDto(isPhoneVerified: $isPhoneVerified, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $PhoneVerifiedDataDtoCopyWith<$Res>  {
  factory $PhoneVerifiedDataDtoCopyWith(PhoneVerifiedDataDto value, $Res Function(PhoneVerifiedDataDto) _then) = _$PhoneVerifiedDataDtoCopyWithImpl;
@useResult
$Res call({
 bool isPhoneVerified, bool verified
});




}
/// @nodoc
class _$PhoneVerifiedDataDtoCopyWithImpl<$Res>
    implements $PhoneVerifiedDataDtoCopyWith<$Res> {
  _$PhoneVerifiedDataDtoCopyWithImpl(this._self, this._then);

  final PhoneVerifiedDataDto _self;
  final $Res Function(PhoneVerifiedDataDto) _then;

/// Create a copy of PhoneVerifiedDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPhoneVerified = null,Object? verified = null,}) {
  return _then(_self.copyWith(
isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoneVerifiedDataDto].
extension PhoneVerifiedDataDtoPatterns on PhoneVerifiedDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneVerifiedDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneVerifiedDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneVerifiedDataDto value)  $default,){
final _that = this;
switch (_that) {
case _PhoneVerifiedDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneVerifiedDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneVerifiedDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPhoneVerified,  bool verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneVerifiedDataDto() when $default != null:
return $default(_that.isPhoneVerified,_that.verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPhoneVerified,  bool verified)  $default,) {final _that = this;
switch (_that) {
case _PhoneVerifiedDataDto():
return $default(_that.isPhoneVerified,_that.verified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPhoneVerified,  bool verified)?  $default,) {final _that = this;
switch (_that) {
case _PhoneVerifiedDataDto() when $default != null:
return $default(_that.isPhoneVerified,_that.verified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhoneVerifiedDataDto implements PhoneVerifiedDataDto {
  const _PhoneVerifiedDataDto({this.isPhoneVerified = false, this.verified = false});
  factory _PhoneVerifiedDataDto.fromJson(Map<String, dynamic> json) => _$PhoneVerifiedDataDtoFromJson(json);

@override@JsonKey() final  bool isPhoneVerified;
@override@JsonKey() final  bool verified;

/// Create a copy of PhoneVerifiedDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneVerifiedDataDtoCopyWith<_PhoneVerifiedDataDto> get copyWith => __$PhoneVerifiedDataDtoCopyWithImpl<_PhoneVerifiedDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhoneVerifiedDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneVerifiedDataDto&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPhoneVerified,verified);

@override
String toString() {
  return 'PhoneVerifiedDataDto(isPhoneVerified: $isPhoneVerified, verified: $verified)';
}


}

/// @nodoc
abstract mixin class _$PhoneVerifiedDataDtoCopyWith<$Res> implements $PhoneVerifiedDataDtoCopyWith<$Res> {
  factory _$PhoneVerifiedDataDtoCopyWith(_PhoneVerifiedDataDto value, $Res Function(_PhoneVerifiedDataDto) _then) = __$PhoneVerifiedDataDtoCopyWithImpl;
@override @useResult
$Res call({
 bool isPhoneVerified, bool verified
});




}
/// @nodoc
class __$PhoneVerifiedDataDtoCopyWithImpl<$Res>
    implements _$PhoneVerifiedDataDtoCopyWith<$Res> {
  __$PhoneVerifiedDataDtoCopyWithImpl(this._self, this._then);

  final _PhoneVerifiedDataDto _self;
  final $Res Function(_PhoneVerifiedDataDto) _then;

/// Create a copy of PhoneVerifiedDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPhoneVerified = null,Object? verified = null,}) {
  return _then(_PhoneVerifiedDataDto(
isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
