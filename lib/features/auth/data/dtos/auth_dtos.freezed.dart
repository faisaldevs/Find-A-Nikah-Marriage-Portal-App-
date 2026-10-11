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
@JsonKey(name: 'currentStep') int get currentStep; OnboardingStatusUserDto? get user;
/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStatusDataDtoCopyWith<OnboardingStatusDataDto> get copyWith => _$OnboardingStatusDataDtoCopyWithImpl<OnboardingStatusDataDto>(this as OnboardingStatusDataDto, _$identity);

  /// Serializes this OnboardingStatusDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStatusDataDto&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isCompleted,currentStep,user);

@override
String toString() {
  return 'OnboardingStatusDataDto(isCompleted: $isCompleted, currentStep: $currentStep, user: $user)';
}


}

/// @nodoc
abstract mixin class $OnboardingStatusDataDtoCopyWith<$Res>  {
  factory $OnboardingStatusDataDtoCopyWith(OnboardingStatusDataDto value, $Res Function(OnboardingStatusDataDto) _then) = _$OnboardingStatusDataDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'isCompleted') bool isCompleted,@JsonKey(name: 'currentStep') int currentStep, OnboardingStatusUserDto? user
});


$OnboardingStatusUserDtoCopyWith<$Res>? get user;

}
/// @nodoc
class _$OnboardingStatusDataDtoCopyWithImpl<$Res>
    implements $OnboardingStatusDataDtoCopyWith<$Res> {
  _$OnboardingStatusDataDtoCopyWithImpl(this._self, this._then);

  final OnboardingStatusDataDto _self;
  final $Res Function(OnboardingStatusDataDto) _then;

/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isCompleted = null,Object? currentStep = null,Object? user = freezed,}) {
  return _then(_self.copyWith(
isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as OnboardingStatusUserDto?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'isCompleted')  bool isCompleted, @JsonKey(name: 'currentStep')  int currentStep,  OnboardingStatusUserDto? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStatusDataDto() when $default != null:
return $default(_that.isCompleted,_that.currentStep,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'isCompleted')  bool isCompleted, @JsonKey(name: 'currentStep')  int currentStep,  OnboardingStatusUserDto? user)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusDataDto():
return $default(_that.isCompleted,_that.currentStep,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'isCompleted')  bool isCompleted, @JsonKey(name: 'currentStep')  int currentStep,  OnboardingStatusUserDto? user)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusDataDto() when $default != null:
return $default(_that.isCompleted,_that.currentStep,_that.user);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingStatusDataDto implements OnboardingStatusDataDto {
  const _OnboardingStatusDataDto({@JsonKey(name: 'isCompleted') required this.isCompleted, @JsonKey(name: 'currentStep') this.currentStep = 4, this.user});
  factory _OnboardingStatusDataDto.fromJson(Map<String, dynamic> json) => _$OnboardingStatusDataDtoFromJson(json);

@override@JsonKey(name: 'isCompleted') final  bool isCompleted;
/// Which wizard section the user has yet to finish (4 Basics, 5
/// Background & faith, 6 Lifestyle & personality, 7 Bio — matching
/// `OnboardingSubmissionRepository`'s step literals). Defaults to 4
/// (the first section) if the backend omits it.
@override@JsonKey(name: 'currentStep') final  int currentStep;
@override final  OnboardingStatusUserDto? user;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStatusDataDto&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.user, user) || other.user == user));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isCompleted,currentStep,user);

@override
String toString() {
  return 'OnboardingStatusDataDto(isCompleted: $isCompleted, currentStep: $currentStep, user: $user)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStatusDataDtoCopyWith<$Res> implements $OnboardingStatusDataDtoCopyWith<$Res> {
  factory _$OnboardingStatusDataDtoCopyWith(_OnboardingStatusDataDto value, $Res Function(_OnboardingStatusDataDto) _then) = __$OnboardingStatusDataDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'isCompleted') bool isCompleted,@JsonKey(name: 'currentStep') int currentStep, OnboardingStatusUserDto? user
});


@override $OnboardingStatusUserDtoCopyWith<$Res>? get user;

}
/// @nodoc
class __$OnboardingStatusDataDtoCopyWithImpl<$Res>
    implements _$OnboardingStatusDataDtoCopyWith<$Res> {
  __$OnboardingStatusDataDtoCopyWithImpl(this._self, this._then);

  final _OnboardingStatusDataDto _self;
  final $Res Function(_OnboardingStatusDataDto) _then;

/// Create a copy of OnboardingStatusDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isCompleted = null,Object? currentStep = null,Object? user = freezed,}) {
  return _then(_OnboardingStatusDataDto(
isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as OnboardingStatusUserDto?,
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
}
}


/// @nodoc
mixin _$OnboardingStatusUserDto {

 bool get isPhoneVerified;
/// Create a copy of OnboardingStatusUserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStatusUserDtoCopyWith<OnboardingStatusUserDto> get copyWith => _$OnboardingStatusUserDtoCopyWithImpl<OnboardingStatusUserDto>(this as OnboardingStatusUserDto, _$identity);

  /// Serializes this OnboardingStatusUserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStatusUserDto&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPhoneVerified);

@override
String toString() {
  return 'OnboardingStatusUserDto(isPhoneVerified: $isPhoneVerified)';
}


}

/// @nodoc
abstract mixin class $OnboardingStatusUserDtoCopyWith<$Res>  {
  factory $OnboardingStatusUserDtoCopyWith(OnboardingStatusUserDto value, $Res Function(OnboardingStatusUserDto) _then) = _$OnboardingStatusUserDtoCopyWithImpl;
@useResult
$Res call({
 bool isPhoneVerified
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
@pragma('vm:prefer-inline') @override $Res call({Object? isPhoneVerified = null,}) {
  return _then(_self.copyWith(
isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPhoneVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStatusUserDto() when $default != null:
return $default(_that.isPhoneVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPhoneVerified)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusUserDto():
return $default(_that.isPhoneVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPhoneVerified)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatusUserDto() when $default != null:
return $default(_that.isPhoneVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingStatusUserDto implements OnboardingStatusUserDto {
  const _OnboardingStatusUserDto({this.isPhoneVerified = false});
  factory _OnboardingStatusUserDto.fromJson(Map<String, dynamic> json) => _$OnboardingStatusUserDtoFromJson(json);

@override@JsonKey() final  bool isPhoneVerified;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStatusUserDto&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isPhoneVerified);

@override
String toString() {
  return 'OnboardingStatusUserDto(isPhoneVerified: $isPhoneVerified)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStatusUserDtoCopyWith<$Res> implements $OnboardingStatusUserDtoCopyWith<$Res> {
  factory _$OnboardingStatusUserDtoCopyWith(_OnboardingStatusUserDto value, $Res Function(_OnboardingStatusUserDto) _then) = __$OnboardingStatusUserDtoCopyWithImpl;
@override @useResult
$Res call({
 bool isPhoneVerified
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
@override @pragma('vm:prefer-inline') $Res call({Object? isPhoneVerified = null,}) {
  return _then(_OnboardingStatusUserDto(
isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
