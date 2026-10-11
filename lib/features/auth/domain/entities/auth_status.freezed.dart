// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSession {

 String get userId;/// False right after registration: the profile wizard, verification and
/// discovery filters still have to be completed before the main app.
 bool get onboardingComplete;/// Mirrors the onboarding-status API's `currentStep` — which wizard
/// section to resume into. See `resumeRouteFor` in `app_router.dart`.
 int get resumeStep;/// Mirrors `user.isPhoneVerified` — once true, `resumeRouteFor` never
/// routes back to the phone step (it's locked; change it from
/// Settings instead).
 bool get isPhoneVerified;
/// Create a copy of UserSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSessionCopyWith<UserSession> get copyWith => _$UserSessionCopyWithImpl<UserSession>(this as UserSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSession&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete)&&(identical(other.resumeStep, resumeStep) || other.resumeStep == resumeStep)&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified));
}


@override
int get hashCode => Object.hash(runtimeType,userId,onboardingComplete,resumeStep,isPhoneVerified);

@override
String toString() {
  return 'UserSession(userId: $userId, onboardingComplete: $onboardingComplete, resumeStep: $resumeStep, isPhoneVerified: $isPhoneVerified)';
}


}

/// @nodoc
abstract mixin class $UserSessionCopyWith<$Res>  {
  factory $UserSessionCopyWith(UserSession value, $Res Function(UserSession) _then) = _$UserSessionCopyWithImpl;
@useResult
$Res call({
 String userId, bool onboardingComplete, int resumeStep, bool isPhoneVerified
});




}
/// @nodoc
class _$UserSessionCopyWithImpl<$Res>
    implements $UserSessionCopyWith<$Res> {
  _$UserSessionCopyWithImpl(this._self, this._then);

  final UserSession _self;
  final $Res Function(UserSession) _then;

/// Create a copy of UserSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? onboardingComplete = null,Object? resumeStep = null,Object? isPhoneVerified = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,resumeStep: null == resumeStep ? _self.resumeStep : resumeStep // ignore: cast_nullable_to_non_nullable
as int,isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSession].
extension UserSessionPatterns on UserSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSession value)  $default,){
final _that = this;
switch (_that) {
case _UserSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSession value)?  $default,){
final _that = this;
switch (_that) {
case _UserSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  bool onboardingComplete,  int resumeStep,  bool isPhoneVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSession() when $default != null:
return $default(_that.userId,_that.onboardingComplete,_that.resumeStep,_that.isPhoneVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  bool onboardingComplete,  int resumeStep,  bool isPhoneVerified)  $default,) {final _that = this;
switch (_that) {
case _UserSession():
return $default(_that.userId,_that.onboardingComplete,_that.resumeStep,_that.isPhoneVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  bool onboardingComplete,  int resumeStep,  bool isPhoneVerified)?  $default,) {final _that = this;
switch (_that) {
case _UserSession() when $default != null:
return $default(_that.userId,_that.onboardingComplete,_that.resumeStep,_that.isPhoneVerified);case _:
  return null;

}
}

}

/// @nodoc


class _UserSession implements UserSession {
  const _UserSession({required this.userId, required this.onboardingComplete, this.resumeStep = 4, this.isPhoneVerified = false});
  

@override final  String userId;
/// False right after registration: the profile wizard, verification and
/// discovery filters still have to be completed before the main app.
@override final  bool onboardingComplete;
/// Mirrors the onboarding-status API's `currentStep` — which wizard
/// section to resume into. See `resumeRouteFor` in `app_router.dart`.
@override@JsonKey() final  int resumeStep;
/// Mirrors `user.isPhoneVerified` — once true, `resumeRouteFor` never
/// routes back to the phone step (it's locked; change it from
/// Settings instead).
@override@JsonKey() final  bool isPhoneVerified;

/// Create a copy of UserSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSessionCopyWith<_UserSession> get copyWith => __$UserSessionCopyWithImpl<_UserSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSession&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.onboardingComplete, onboardingComplete) || other.onboardingComplete == onboardingComplete)&&(identical(other.resumeStep, resumeStep) || other.resumeStep == resumeStep)&&(identical(other.isPhoneVerified, isPhoneVerified) || other.isPhoneVerified == isPhoneVerified));
}


@override
int get hashCode => Object.hash(runtimeType,userId,onboardingComplete,resumeStep,isPhoneVerified);

@override
String toString() {
  return 'UserSession(userId: $userId, onboardingComplete: $onboardingComplete, resumeStep: $resumeStep, isPhoneVerified: $isPhoneVerified)';
}


}

/// @nodoc
abstract mixin class _$UserSessionCopyWith<$Res> implements $UserSessionCopyWith<$Res> {
  factory _$UserSessionCopyWith(_UserSession value, $Res Function(_UserSession) _then) = __$UserSessionCopyWithImpl;
@override @useResult
$Res call({
 String userId, bool onboardingComplete, int resumeStep, bool isPhoneVerified
});




}
/// @nodoc
class __$UserSessionCopyWithImpl<$Res>
    implements _$UserSessionCopyWith<$Res> {
  __$UserSessionCopyWithImpl(this._self, this._then);

  final _UserSession _self;
  final $Res Function(_UserSession) _then;

/// Create a copy of UserSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? onboardingComplete = null,Object? resumeStep = null,Object? isPhoneVerified = null,}) {
  return _then(_UserSession(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,onboardingComplete: null == onboardingComplete ? _self.onboardingComplete : onboardingComplete // ignore: cast_nullable_to_non_nullable
as bool,resumeStep: null == resumeStep ? _self.resumeStep : resumeStep // ignore: cast_nullable_to_non_nullable
as int,isPhoneVerified: null == isPhoneVerified ? _self.isPhoneVerified : isPhoneVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$AuthStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthStatus()';
}


}

/// @nodoc
class $AuthStatusCopyWith<$Res>  {
$AuthStatusCopyWith(AuthStatus _, $Res Function(AuthStatus) __);
}


/// Adds pattern-matching-related methods to [AuthStatus].
extension AuthStatusPatterns on AuthStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthUnknown value)?  unknown,TResult Function( Authenticated value)?  authenticated,TResult Function( Unauthenticated value)?  unauthenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthUnknown value)  unknown,required TResult Function( Authenticated value)  authenticated,required TResult Function( Unauthenticated value)  unauthenticated,}){
final _that = this;
switch (_that) {
case AuthUnknown():
return unknown(_that);case Authenticated():
return authenticated(_that);case Unauthenticated():
return unauthenticated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthUnknown value)?  unknown,TResult? Function( Authenticated value)?  authenticated,TResult? Function( Unauthenticated value)?  unauthenticated,}){
final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  unknown,TResult Function( UserSession session)?  authenticated,TResult Function( SignedOutReason reason)?  unauthenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown();case Authenticated() when authenticated != null:
return authenticated(_that.session);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  unknown,required TResult Function( UserSession session)  authenticated,required TResult Function( SignedOutReason reason)  unauthenticated,}) {final _that = this;
switch (_that) {
case AuthUnknown():
return unknown();case Authenticated():
return authenticated(_that.session);case Unauthenticated():
return unauthenticated(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  unknown,TResult? Function( UserSession session)?  authenticated,TResult? Function( SignedOutReason reason)?  unauthenticated,}) {final _that = this;
switch (_that) {
case AuthUnknown() when unknown != null:
return unknown();case Authenticated() when authenticated != null:
return authenticated(_that.session);case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class AuthUnknown implements AuthStatus {
  const AuthUnknown();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUnknown);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthStatus.unknown()';
}


}




/// @nodoc


class Authenticated implements AuthStatus {
  const Authenticated(this.session);
  

 final  UserSession session;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedCopyWith<Authenticated> get copyWith => _$AuthenticatedCopyWithImpl<Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Authenticated&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode => Object.hash(runtimeType,session);

@override
String toString() {
  return 'AuthStatus.authenticated(session: $session)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedCopyWith<$Res> implements $AuthStatusCopyWith<$Res> {
  factory $AuthenticatedCopyWith(Authenticated value, $Res Function(Authenticated) _then) = _$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 UserSession session
});


$UserSessionCopyWith<$Res> get session;

}
/// @nodoc
class _$AuthenticatedCopyWithImpl<$Res>
    implements $AuthenticatedCopyWith<$Res> {
  _$AuthenticatedCopyWithImpl(this._self, this._then);

  final Authenticated _self;
  final $Res Function(Authenticated) _then;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(Authenticated(
null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as UserSession,
  ));
}

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSessionCopyWith<$Res> get session {
  
  return $UserSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

/// @nodoc


class Unauthenticated implements AuthStatus {
  const Unauthenticated({this.reason = SignedOutReason.freshInstall});
  

@JsonKey() final  SignedOutReason reason;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthenticatedCopyWith<Unauthenticated> get copyWith => _$UnauthenticatedCopyWithImpl<Unauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unauthenticated&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'AuthStatus.unauthenticated(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $UnauthenticatedCopyWith<$Res> implements $AuthStatusCopyWith<$Res> {
  factory $UnauthenticatedCopyWith(Unauthenticated value, $Res Function(Unauthenticated) _then) = _$UnauthenticatedCopyWithImpl;
@useResult
$Res call({
 SignedOutReason reason
});




}
/// @nodoc
class _$UnauthenticatedCopyWithImpl<$Res>
    implements $UnauthenticatedCopyWith<$Res> {
  _$UnauthenticatedCopyWithImpl(this._self, this._then);

  final Unauthenticated _self;
  final $Res Function(Unauthenticated) _then;

/// Create a copy of AuthStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(Unauthenticated(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as SignedOutReason,
  ));
}


}

// dart format on
