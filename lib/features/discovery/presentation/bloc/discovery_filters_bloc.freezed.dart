// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_filters_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoveryFiltersState {

 DiscoveryFilters get filters; DiscoveryFiltersStatus get status; Failure? get failure;
/// Create a copy of DiscoveryFiltersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryFiltersStateCopyWith<DiscoveryFiltersState> get copyWith => _$DiscoveryFiltersStateCopyWithImpl<DiscoveryFiltersState>(this as DiscoveryFiltersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryFiltersState&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,filters,status,failure);

@override
String toString() {
  return 'DiscoveryFiltersState(filters: $filters, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DiscoveryFiltersStateCopyWith<$Res>  {
  factory $DiscoveryFiltersStateCopyWith(DiscoveryFiltersState value, $Res Function(DiscoveryFiltersState) _then) = _$DiscoveryFiltersStateCopyWithImpl;
@useResult
$Res call({
 DiscoveryFilters filters, DiscoveryFiltersStatus status, Failure? failure
});


$DiscoveryFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class _$DiscoveryFiltersStateCopyWithImpl<$Res>
    implements $DiscoveryFiltersStateCopyWith<$Res> {
  _$DiscoveryFiltersStateCopyWithImpl(this._self, this._then);

  final DiscoveryFiltersState _self;
  final $Res Function(DiscoveryFiltersState) _then;

/// Create a copy of DiscoveryFiltersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filters = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DiscoveryFilters,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoveryFiltersStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of DiscoveryFiltersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryFiltersCopyWith<$Res> get filters {
  
  return $DiscoveryFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiscoveryFiltersState].
extension DiscoveryFiltersStatePatterns on DiscoveryFiltersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoveryFiltersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoveryFiltersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoveryFiltersState value)  $default,){
final _that = this;
switch (_that) {
case _DiscoveryFiltersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoveryFiltersState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoveryFiltersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiscoveryFilters filters,  DiscoveryFiltersStatus status,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoveryFiltersState() when $default != null:
return $default(_that.filters,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiscoveryFilters filters,  DiscoveryFiltersStatus status,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DiscoveryFiltersState():
return $default(_that.filters,_that.status,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiscoveryFilters filters,  DiscoveryFiltersStatus status,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DiscoveryFiltersState() when $default != null:
return $default(_that.filters,_that.status,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoveryFiltersState implements DiscoveryFiltersState {
  const _DiscoveryFiltersState({this.filters = const DiscoveryFilters(), this.status = DiscoveryFiltersStatus.idle, this.failure});
  

@override@JsonKey() final  DiscoveryFilters filters;
@override@JsonKey() final  DiscoveryFiltersStatus status;
@override final  Failure? failure;

/// Create a copy of DiscoveryFiltersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveryFiltersStateCopyWith<_DiscoveryFiltersState> get copyWith => __$DiscoveryFiltersStateCopyWithImpl<_DiscoveryFiltersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveryFiltersState&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.status, status) || other.status == status)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,filters,status,failure);

@override
String toString() {
  return 'DiscoveryFiltersState(filters: $filters, status: $status, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DiscoveryFiltersStateCopyWith<$Res> implements $DiscoveryFiltersStateCopyWith<$Res> {
  factory _$DiscoveryFiltersStateCopyWith(_DiscoveryFiltersState value, $Res Function(_DiscoveryFiltersState) _then) = __$DiscoveryFiltersStateCopyWithImpl;
@override @useResult
$Res call({
 DiscoveryFilters filters, DiscoveryFiltersStatus status, Failure? failure
});


@override $DiscoveryFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class __$DiscoveryFiltersStateCopyWithImpl<$Res>
    implements _$DiscoveryFiltersStateCopyWith<$Res> {
  __$DiscoveryFiltersStateCopyWithImpl(this._self, this._then);

  final _DiscoveryFiltersState _self;
  final $Res Function(_DiscoveryFiltersState) _then;

/// Create a copy of DiscoveryFiltersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filters = null,Object? status = null,Object? failure = freezed,}) {
  return _then(_DiscoveryFiltersState(
filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DiscoveryFilters,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoveryFiltersStatus,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of DiscoveryFiltersState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryFiltersCopyWith<$Res> get filters {
  
  return $DiscoveryFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}

// dart format on
