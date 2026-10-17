// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'phone_verification_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PhoneVerificationState {

 String get phoneNumber; PhoneVerificationStatus get status;/// The code the backend echoed back in demo mode (`devCode`), if any —
/// the code page autofills it in debug builds only.
 String? get demoCode; Failure? get failure;
/// Create a copy of PhoneVerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhoneVerificationStateCopyWith<PhoneVerificationState> get copyWith => _$PhoneVerificationStateCopyWithImpl<PhoneVerificationState>(this as PhoneVerificationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhoneVerificationState&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.demoCode, demoCode) || other.demoCode == demoCode)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,status,demoCode,failure);

@override
String toString() {
  return 'PhoneVerificationState(phoneNumber: $phoneNumber, status: $status, demoCode: $demoCode, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PhoneVerificationStateCopyWith<$Res>  {
  factory $PhoneVerificationStateCopyWith(PhoneVerificationState value, $Res Function(PhoneVerificationState) _then) = _$PhoneVerificationStateCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, PhoneVerificationStatus status, String? demoCode, Failure? failure
});




}
/// @nodoc
class _$PhoneVerificationStateCopyWithImpl<$Res>
    implements $PhoneVerificationStateCopyWith<$Res> {
  _$PhoneVerificationStateCopyWithImpl(this._self, this._then);

  final PhoneVerificationState _self;
  final $Res Function(PhoneVerificationState) _then;

/// Create a copy of PhoneVerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneNumber = null,Object? status = null,Object? demoCode = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PhoneVerificationStatus,demoCode: freezed == demoCode ? _self.demoCode : demoCode // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhoneVerificationState].
extension PhoneVerificationStatePatterns on PhoneVerificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhoneVerificationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhoneVerificationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhoneVerificationState value)  $default,){
final _that = this;
switch (_that) {
case _PhoneVerificationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhoneVerificationState value)?  $default,){
final _that = this;
switch (_that) {
case _PhoneVerificationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneNumber,  PhoneVerificationStatus status,  String? demoCode,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhoneVerificationState() when $default != null:
return $default(_that.phoneNumber,_that.status,_that.demoCode,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneNumber,  PhoneVerificationStatus status,  String? demoCode,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _PhoneVerificationState():
return $default(_that.phoneNumber,_that.status,_that.demoCode,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneNumber,  PhoneVerificationStatus status,  String? demoCode,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _PhoneVerificationState() when $default != null:
return $default(_that.phoneNumber,_that.status,_that.demoCode,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _PhoneVerificationState implements PhoneVerificationState {
  const _PhoneVerificationState({this.phoneNumber = '', this.status = PhoneVerificationStatus.idle, this.demoCode, this.failure});
  

@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  PhoneVerificationStatus status;
/// The code the backend echoed back in demo mode (`devCode`), if any —
/// the code page autofills it in debug builds only.
@override final  String? demoCode;
@override final  Failure? failure;

/// Create a copy of PhoneVerificationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneVerificationStateCopyWith<_PhoneVerificationState> get copyWith => __$PhoneVerificationStateCopyWithImpl<_PhoneVerificationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneVerificationState&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.demoCode, demoCode) || other.demoCode == demoCode)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,status,demoCode,failure);

@override
String toString() {
  return 'PhoneVerificationState(phoneNumber: $phoneNumber, status: $status, demoCode: $demoCode, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$PhoneVerificationStateCopyWith<$Res> implements $PhoneVerificationStateCopyWith<$Res> {
  factory _$PhoneVerificationStateCopyWith(_PhoneVerificationState value, $Res Function(_PhoneVerificationState) _then) = __$PhoneVerificationStateCopyWithImpl;
@override @useResult
$Res call({
 String phoneNumber, PhoneVerificationStatus status, String? demoCode, Failure? failure
});




}
/// @nodoc
class __$PhoneVerificationStateCopyWithImpl<$Res>
    implements _$PhoneVerificationStateCopyWith<$Res> {
  __$PhoneVerificationStateCopyWithImpl(this._self, this._then);

  final _PhoneVerificationState _self;
  final $Res Function(_PhoneVerificationState) _then;

/// Create a copy of PhoneVerificationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? status = null,Object? demoCode = freezed,Object? failure = freezed,}) {
  return _then(_PhoneVerificationState(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PhoneVerificationStatus,demoCode: freezed == demoCode ? _self.demoCode : demoCode // ignore: cast_nullable_to_non_nullable
as String?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}


}

// dart format on
