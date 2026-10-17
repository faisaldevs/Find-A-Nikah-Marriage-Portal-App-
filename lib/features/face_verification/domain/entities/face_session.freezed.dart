// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'face_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FaceSession {

 String? get sessionId; LivenessStepPlan get plan;/// When the server stops accepting uploads for this session. Null when
/// the response didn't say — then the session never expires client-side.
 DateTime? get expiresAt; Map<String, dynamic> get raw;
/// Create a copy of FaceSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FaceSessionCopyWith<FaceSession> get copyWith => _$FaceSessionCopyWithImpl<FaceSession>(this as FaceSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FaceSession&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other.raw, raw));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,plan,expiresAt,const DeepCollectionEquality().hash(raw));

@override
String toString() {
  return 'FaceSession(sessionId: $sessionId, plan: $plan, expiresAt: $expiresAt, raw: $raw)';
}


}

/// @nodoc
abstract mixin class $FaceSessionCopyWith<$Res>  {
  factory $FaceSessionCopyWith(FaceSession value, $Res Function(FaceSession) _then) = _$FaceSessionCopyWithImpl;
@useResult
$Res call({
 String? sessionId, LivenessStepPlan plan, DateTime? expiresAt, Map<String, dynamic> raw
});


$LivenessStepPlanCopyWith<$Res> get plan;

}
/// @nodoc
class _$FaceSessionCopyWithImpl<$Res>
    implements $FaceSessionCopyWith<$Res> {
  _$FaceSessionCopyWithImpl(this._self, this._then);

  final FaceSession _self;
  final $Res Function(FaceSession) _then;

/// Create a copy of FaceSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = freezed,Object? plan = null,Object? expiresAt = freezed,Object? raw = null,}) {
  return _then(_self.copyWith(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as LivenessStepPlan,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,raw: null == raw ? _self.raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of FaceSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LivenessStepPlanCopyWith<$Res> get plan {
  
  return $LivenessStepPlanCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}


/// Adds pattern-matching-related methods to [FaceSession].
extension FaceSessionPatterns on FaceSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FaceSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FaceSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FaceSession value)  $default,){
final _that = this;
switch (_that) {
case _FaceSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FaceSession value)?  $default,){
final _that = this;
switch (_that) {
case _FaceSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sessionId,  LivenessStepPlan plan,  DateTime? expiresAt,  Map<String, dynamic> raw)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FaceSession() when $default != null:
return $default(_that.sessionId,_that.plan,_that.expiresAt,_that.raw);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sessionId,  LivenessStepPlan plan,  DateTime? expiresAt,  Map<String, dynamic> raw)  $default,) {final _that = this;
switch (_that) {
case _FaceSession():
return $default(_that.sessionId,_that.plan,_that.expiresAt,_that.raw);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sessionId,  LivenessStepPlan plan,  DateTime? expiresAt,  Map<String, dynamic> raw)?  $default,) {final _that = this;
switch (_that) {
case _FaceSession() when $default != null:
return $default(_that.sessionId,_that.plan,_that.expiresAt,_that.raw);case _:
  return null;

}
}

}

/// @nodoc


class _FaceSession extends FaceSession {
  const _FaceSession({this.sessionId, this.plan = LivenessStepPlan.defaultPlan, this.expiresAt, final  Map<String, dynamic> raw = const <String, dynamic>{}}): _raw = raw,super._();
  

@override final  String? sessionId;
@override@JsonKey() final  LivenessStepPlan plan;
/// When the server stops accepting uploads for this session. Null when
/// the response didn't say — then the session never expires client-side.
@override final  DateTime? expiresAt;
 final  Map<String, dynamic> _raw;
@override@JsonKey() Map<String, dynamic> get raw {
  if (_raw is EqualUnmodifiableMapView) return _raw;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_raw);
}


/// Create a copy of FaceSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FaceSessionCopyWith<_FaceSession> get copyWith => __$FaceSessionCopyWithImpl<_FaceSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FaceSession&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other._raw, _raw));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,plan,expiresAt,const DeepCollectionEquality().hash(_raw));

@override
String toString() {
  return 'FaceSession(sessionId: $sessionId, plan: $plan, expiresAt: $expiresAt, raw: $raw)';
}


}

/// @nodoc
abstract mixin class _$FaceSessionCopyWith<$Res> implements $FaceSessionCopyWith<$Res> {
  factory _$FaceSessionCopyWith(_FaceSession value, $Res Function(_FaceSession) _then) = __$FaceSessionCopyWithImpl;
@override @useResult
$Res call({
 String? sessionId, LivenessStepPlan plan, DateTime? expiresAt, Map<String, dynamic> raw
});


@override $LivenessStepPlanCopyWith<$Res> get plan;

}
/// @nodoc
class __$FaceSessionCopyWithImpl<$Res>
    implements _$FaceSessionCopyWith<$Res> {
  __$FaceSessionCopyWithImpl(this._self, this._then);

  final _FaceSession _self;
  final $Res Function(_FaceSession) _then;

/// Create a copy of FaceSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = freezed,Object? plan = null,Object? expiresAt = freezed,Object? raw = null,}) {
  return _then(_FaceSession(
sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as LivenessStepPlan,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,raw: null == raw ? _self._raw : raw // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of FaceSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LivenessStepPlanCopyWith<$Res> get plan {
  
  return $LivenessStepPlanCopyWith<$Res>(_self.plan, (value) {
    return _then(_self.copyWith(plan: value));
  });
}
}

// dart format on
