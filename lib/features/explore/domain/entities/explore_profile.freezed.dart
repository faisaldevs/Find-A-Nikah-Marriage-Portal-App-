// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'explore_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExploreProfile {

 String get id; String get name; int get age; String get photoUrl; String get area;/// Emoji flag (e.g. 🇧🇩) — rendered by the platform emoji font, same as
/// `MarriageProfile.countryFlag`.
 String get countryFlag; bool get isVerified; bool get isActiveToday;/// "Student", "Doctor" — only the "Likes in your filters" card shows it.
 String? get profession;/// Display-ready relative time ("1 hour ago", "Last Month") — shown
/// instead of an active-today dot on sections that are about when
/// something happened rather than presence.
 String? get postedAt;/// Shown instead of [area] on "Active near you".
 double? get distanceKm;
/// Create a copy of ExploreProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExploreProfileCopyWith<ExploreProfile> get copyWith => _$ExploreProfileCopyWithImpl<ExploreProfile>(this as ExploreProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExploreProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.area, area) || other.area == area)&&(identical(other.countryFlag, countryFlag) || other.countryFlag == countryFlag)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isActiveToday, isActiveToday) || other.isActiveToday == isActiveToday)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,age,photoUrl,area,countryFlag,isVerified,isActiveToday,profession,postedAt,distanceKm);

@override
String toString() {
  return 'ExploreProfile(id: $id, name: $name, age: $age, photoUrl: $photoUrl, area: $area, countryFlag: $countryFlag, isVerified: $isVerified, isActiveToday: $isActiveToday, profession: $profession, postedAt: $postedAt, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class $ExploreProfileCopyWith<$Res>  {
  factory $ExploreProfileCopyWith(ExploreProfile value, $Res Function(ExploreProfile) _then) = _$ExploreProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, int age, String photoUrl, String area, String countryFlag, bool isVerified, bool isActiveToday, String? profession, String? postedAt, double? distanceKm
});




}
/// @nodoc
class _$ExploreProfileCopyWithImpl<$Res>
    implements $ExploreProfileCopyWith<$Res> {
  _$ExploreProfileCopyWithImpl(this._self, this._then);

  final ExploreProfile _self;
  final $Res Function(ExploreProfile) _then;

/// Create a copy of ExploreProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? age = null,Object? photoUrl = null,Object? area = null,Object? countryFlag = null,Object? isVerified = null,Object? isActiveToday = null,Object? profession = freezed,Object? postedAt = freezed,Object? distanceKm = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,countryFlag: null == countryFlag ? _self.countryFlag : countryFlag // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isActiveToday: null == isActiveToday ? _self.isActiveToday : isActiveToday // ignore: cast_nullable_to_non_nullable
as bool,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExploreProfile].
extension ExploreProfilePatterns on ExploreProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExploreProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExploreProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExploreProfile value)  $default,){
final _that = this;
switch (_that) {
case _ExploreProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExploreProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ExploreProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int age,  String photoUrl,  String area,  String countryFlag,  bool isVerified,  bool isActiveToday,  String? profession,  String? postedAt,  double? distanceKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExploreProfile() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.photoUrl,_that.area,_that.countryFlag,_that.isVerified,_that.isActiveToday,_that.profession,_that.postedAt,_that.distanceKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int age,  String photoUrl,  String area,  String countryFlag,  bool isVerified,  bool isActiveToday,  String? profession,  String? postedAt,  double? distanceKm)  $default,) {final _that = this;
switch (_that) {
case _ExploreProfile():
return $default(_that.id,_that.name,_that.age,_that.photoUrl,_that.area,_that.countryFlag,_that.isVerified,_that.isActiveToday,_that.profession,_that.postedAt,_that.distanceKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int age,  String photoUrl,  String area,  String countryFlag,  bool isVerified,  bool isActiveToday,  String? profession,  String? postedAt,  double? distanceKm)?  $default,) {final _that = this;
switch (_that) {
case _ExploreProfile() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.photoUrl,_that.area,_that.countryFlag,_that.isVerified,_that.isActiveToday,_that.profession,_that.postedAt,_that.distanceKm);case _:
  return null;

}
}

}

/// @nodoc


class _ExploreProfile implements ExploreProfile {
  const _ExploreProfile({required this.id, required this.name, required this.age, required this.photoUrl, required this.area, required this.countryFlag, this.isVerified = false, this.isActiveToday = false, this.profession, this.postedAt, this.distanceKm});
  

@override final  String id;
@override final  String name;
@override final  int age;
@override final  String photoUrl;
@override final  String area;
/// Emoji flag (e.g. 🇧🇩) — rendered by the platform emoji font, same as
/// `MarriageProfile.countryFlag`.
@override final  String countryFlag;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  bool isActiveToday;
/// "Student", "Doctor" — only the "Likes in your filters" card shows it.
@override final  String? profession;
/// Display-ready relative time ("1 hour ago", "Last Month") — shown
/// instead of an active-today dot on sections that are about when
/// something happened rather than presence.
@override final  String? postedAt;
/// Shown instead of [area] on "Active near you".
@override final  double? distanceKm;

/// Create a copy of ExploreProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExploreProfileCopyWith<_ExploreProfile> get copyWith => __$ExploreProfileCopyWithImpl<_ExploreProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExploreProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.area, area) || other.area == area)&&(identical(other.countryFlag, countryFlag) || other.countryFlag == countryFlag)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isActiveToday, isActiveToday) || other.isActiveToday == isActiveToday)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,age,photoUrl,area,countryFlag,isVerified,isActiveToday,profession,postedAt,distanceKm);

@override
String toString() {
  return 'ExploreProfile(id: $id, name: $name, age: $age, photoUrl: $photoUrl, area: $area, countryFlag: $countryFlag, isVerified: $isVerified, isActiveToday: $isActiveToday, profession: $profession, postedAt: $postedAt, distanceKm: $distanceKm)';
}


}

/// @nodoc
abstract mixin class _$ExploreProfileCopyWith<$Res> implements $ExploreProfileCopyWith<$Res> {
  factory _$ExploreProfileCopyWith(_ExploreProfile value, $Res Function(_ExploreProfile) _then) = __$ExploreProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int age, String photoUrl, String area, String countryFlag, bool isVerified, bool isActiveToday, String? profession, String? postedAt, double? distanceKm
});




}
/// @nodoc
class __$ExploreProfileCopyWithImpl<$Res>
    implements _$ExploreProfileCopyWith<$Res> {
  __$ExploreProfileCopyWithImpl(this._self, this._then);

  final _ExploreProfile _self;
  final $Res Function(_ExploreProfile) _then;

/// Create a copy of ExploreProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? age = null,Object? photoUrl = null,Object? area = null,Object? countryFlag = null,Object? isVerified = null,Object? isActiveToday = null,Object? profession = freezed,Object? postedAt = freezed,Object? distanceKm = freezed,}) {
  return _then(_ExploreProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,photoUrl: null == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,countryFlag: null == countryFlag ? _self.countryFlag : countryFlag // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isActiveToday: null == isActiveToday ? _self.isActiveToday : isActiveToday // ignore: cast_nullable_to_non_nullable
as bool,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
