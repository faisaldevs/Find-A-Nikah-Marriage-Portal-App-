// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Membership {

 String get planName; String get planDescription; int get likes; int get compliments; int get likesInFilters; String get monthlyPrice;
/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipCopyWith<Membership> get copyWith => _$MembershipCopyWithImpl<Membership>(this as Membership, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Membership&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.planDescription, planDescription) || other.planDescription == planDescription)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.compliments, compliments) || other.compliments == compliments)&&(identical(other.likesInFilters, likesInFilters) || other.likesInFilters == likesInFilters)&&(identical(other.monthlyPrice, monthlyPrice) || other.monthlyPrice == monthlyPrice));
}


@override
int get hashCode => Object.hash(runtimeType,planName,planDescription,likes,compliments,likesInFilters,monthlyPrice);

@override
String toString() {
  return 'Membership(planName: $planName, planDescription: $planDescription, likes: $likes, compliments: $compliments, likesInFilters: $likesInFilters, monthlyPrice: $monthlyPrice)';
}


}

/// @nodoc
abstract mixin class $MembershipCopyWith<$Res>  {
  factory $MembershipCopyWith(Membership value, $Res Function(Membership) _then) = _$MembershipCopyWithImpl;
@useResult
$Res call({
 String planName, String planDescription, int likes, int compliments, int likesInFilters, String monthlyPrice
});




}
/// @nodoc
class _$MembershipCopyWithImpl<$Res>
    implements $MembershipCopyWith<$Res> {
  _$MembershipCopyWithImpl(this._self, this._then);

  final Membership _self;
  final $Res Function(Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planName = null,Object? planDescription = null,Object? likes = null,Object? compliments = null,Object? likesInFilters = null,Object? monthlyPrice = null,}) {
  return _then(_self.copyWith(
planName: null == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String,planDescription: null == planDescription ? _self.planDescription : planDescription // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,compliments: null == compliments ? _self.compliments : compliments // ignore: cast_nullable_to_non_nullable
as int,likesInFilters: null == likesInFilters ? _self.likesInFilters : likesInFilters // ignore: cast_nullable_to_non_nullable
as int,monthlyPrice: null == monthlyPrice ? _self.monthlyPrice : monthlyPrice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Membership].
extension MembershipPatterns on Membership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Membership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Membership value)  $default,){
final _that = this;
switch (_that) {
case _Membership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Membership value)?  $default,){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String planName,  String planDescription,  int likes,  int compliments,  int likesInFilters,  String monthlyPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.planName,_that.planDescription,_that.likes,_that.compliments,_that.likesInFilters,_that.monthlyPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String planName,  String planDescription,  int likes,  int compliments,  int likesInFilters,  String monthlyPrice)  $default,) {final _that = this;
switch (_that) {
case _Membership():
return $default(_that.planName,_that.planDescription,_that.likes,_that.compliments,_that.likesInFilters,_that.monthlyPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String planName,  String planDescription,  int likes,  int compliments,  int likesInFilters,  String monthlyPrice)?  $default,) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.planName,_that.planDescription,_that.likes,_that.compliments,_that.likesInFilters,_that.monthlyPrice);case _:
  return null;

}
}

}

/// @nodoc


class _Membership implements Membership {
  const _Membership({required this.planName, required this.planDescription, required this.likes, required this.compliments, required this.likesInFilters, required this.monthlyPrice});
  

@override final  String planName;
@override final  String planDescription;
@override final  int likes;
@override final  int compliments;
@override final  int likesInFilters;
@override final  String monthlyPrice;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipCopyWith<_Membership> get copyWith => __$MembershipCopyWithImpl<_Membership>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Membership&&(identical(other.planName, planName) || other.planName == planName)&&(identical(other.planDescription, planDescription) || other.planDescription == planDescription)&&(identical(other.likes, likes) || other.likes == likes)&&(identical(other.compliments, compliments) || other.compliments == compliments)&&(identical(other.likesInFilters, likesInFilters) || other.likesInFilters == likesInFilters)&&(identical(other.monthlyPrice, monthlyPrice) || other.monthlyPrice == monthlyPrice));
}


@override
int get hashCode => Object.hash(runtimeType,planName,planDescription,likes,compliments,likesInFilters,monthlyPrice);

@override
String toString() {
  return 'Membership(planName: $planName, planDescription: $planDescription, likes: $likes, compliments: $compliments, likesInFilters: $likesInFilters, monthlyPrice: $monthlyPrice)';
}


}

/// @nodoc
abstract mixin class _$MembershipCopyWith<$Res> implements $MembershipCopyWith<$Res> {
  factory _$MembershipCopyWith(_Membership value, $Res Function(_Membership) _then) = __$MembershipCopyWithImpl;
@override @useResult
$Res call({
 String planName, String planDescription, int likes, int compliments, int likesInFilters, String monthlyPrice
});




}
/// @nodoc
class __$MembershipCopyWithImpl<$Res>
    implements _$MembershipCopyWith<$Res> {
  __$MembershipCopyWithImpl(this._self, this._then);

  final _Membership _self;
  final $Res Function(_Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planName = null,Object? planDescription = null,Object? likes = null,Object? compliments = null,Object? likesInFilters = null,Object? monthlyPrice = null,}) {
  return _then(_Membership(
planName: null == planName ? _self.planName : planName // ignore: cast_nullable_to_non_nullable
as String,planDescription: null == planDescription ? _self.planDescription : planDescription // ignore: cast_nullable_to_non_nullable
as String,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,compliments: null == compliments ? _self.compliments : compliments // ignore: cast_nullable_to_non_nullable
as int,likesInFilters: null == likesInFilters ? _self.likesInFilters : likesInFilters // ignore: cast_nullable_to_non_nullable
as int,monthlyPrice: null == monthlyPrice ? _self.monthlyPrice : monthlyPrice // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
