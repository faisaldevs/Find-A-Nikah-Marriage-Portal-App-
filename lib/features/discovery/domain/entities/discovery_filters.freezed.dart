// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoveryFilters {

 int get minAge; int get maxAge;/// Null = no location filter applied.
 LocationFilterMode? get locationMode;/// Distance-mode fields. Kept even when [locationMode] is `country` so
/// switching back restores the last slider position.
 double get distanceMiles; bool get limitToHomeCountry;/// Country-mode field: ISO code from `package:core` `allCountries`.
 String? get countryCode;/// Ethnicity codes; empty = "No preference".
 List<String> get ethnicities;
/// Create a copy of DiscoveryFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryFiltersCopyWith<DiscoveryFilters> get copyWith => _$DiscoveryFiltersCopyWithImpl<DiscoveryFilters>(this as DiscoveryFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryFilters&&(identical(other.minAge, minAge) || other.minAge == minAge)&&(identical(other.maxAge, maxAge) || other.maxAge == maxAge)&&(identical(other.locationMode, locationMode) || other.locationMode == locationMode)&&(identical(other.distanceMiles, distanceMiles) || other.distanceMiles == distanceMiles)&&(identical(other.limitToHomeCountry, limitToHomeCountry) || other.limitToHomeCountry == limitToHomeCountry)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&const DeepCollectionEquality().equals(other.ethnicities, ethnicities));
}


@override
int get hashCode => Object.hash(runtimeType,minAge,maxAge,locationMode,distanceMiles,limitToHomeCountry,countryCode,const DeepCollectionEquality().hash(ethnicities));

@override
String toString() {
  return 'DiscoveryFilters(minAge: $minAge, maxAge: $maxAge, locationMode: $locationMode, distanceMiles: $distanceMiles, limitToHomeCountry: $limitToHomeCountry, countryCode: $countryCode, ethnicities: $ethnicities)';
}


}

/// @nodoc
abstract mixin class $DiscoveryFiltersCopyWith<$Res>  {
  factory $DiscoveryFiltersCopyWith(DiscoveryFilters value, $Res Function(DiscoveryFilters) _then) = _$DiscoveryFiltersCopyWithImpl;
@useResult
$Res call({
 int minAge, int maxAge, LocationFilterMode? locationMode, double distanceMiles, bool limitToHomeCountry, String? countryCode, List<String> ethnicities
});




}
/// @nodoc
class _$DiscoveryFiltersCopyWithImpl<$Res>
    implements $DiscoveryFiltersCopyWith<$Res> {
  _$DiscoveryFiltersCopyWithImpl(this._self, this._then);

  final DiscoveryFilters _self;
  final $Res Function(DiscoveryFilters) _then;

/// Create a copy of DiscoveryFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minAge = null,Object? maxAge = null,Object? locationMode = freezed,Object? distanceMiles = null,Object? limitToHomeCountry = null,Object? countryCode = freezed,Object? ethnicities = null,}) {
  return _then(_self.copyWith(
minAge: null == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int,maxAge: null == maxAge ? _self.maxAge : maxAge // ignore: cast_nullable_to_non_nullable
as int,locationMode: freezed == locationMode ? _self.locationMode : locationMode // ignore: cast_nullable_to_non_nullable
as LocationFilterMode?,distanceMiles: null == distanceMiles ? _self.distanceMiles : distanceMiles // ignore: cast_nullable_to_non_nullable
as double,limitToHomeCountry: null == limitToHomeCountry ? _self.limitToHomeCountry : limitToHomeCountry // ignore: cast_nullable_to_non_nullable
as bool,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,ethnicities: null == ethnicities ? _self.ethnicities : ethnicities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoveryFilters].
extension DiscoveryFiltersPatterns on DiscoveryFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoveryFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoveryFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoveryFilters value)  $default,){
final _that = this;
switch (_that) {
case _DiscoveryFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoveryFilters value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoveryFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int minAge,  int maxAge,  LocationFilterMode? locationMode,  double distanceMiles,  bool limitToHomeCountry,  String? countryCode,  List<String> ethnicities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoveryFilters() when $default != null:
return $default(_that.minAge,_that.maxAge,_that.locationMode,_that.distanceMiles,_that.limitToHomeCountry,_that.countryCode,_that.ethnicities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int minAge,  int maxAge,  LocationFilterMode? locationMode,  double distanceMiles,  bool limitToHomeCountry,  String? countryCode,  List<String> ethnicities)  $default,) {final _that = this;
switch (_that) {
case _DiscoveryFilters():
return $default(_that.minAge,_that.maxAge,_that.locationMode,_that.distanceMiles,_that.limitToHomeCountry,_that.countryCode,_that.ethnicities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int minAge,  int maxAge,  LocationFilterMode? locationMode,  double distanceMiles,  bool limitToHomeCountry,  String? countryCode,  List<String> ethnicities)?  $default,) {final _that = this;
switch (_that) {
case _DiscoveryFilters() when $default != null:
return $default(_that.minAge,_that.maxAge,_that.locationMode,_that.distanceMiles,_that.limitToHomeCountry,_that.countryCode,_that.ethnicities);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoveryFilters extends DiscoveryFilters {
  const _DiscoveryFilters({this.minAge = kMinAge, this.maxAge = kMaxAge, this.locationMode, this.distanceMiles = kMaxDistanceMiles, this.limitToHomeCountry = false, this.countryCode, final  List<String> ethnicities = const <String>[]}): _ethnicities = ethnicities,super._();
  

@override@JsonKey() final  int minAge;
@override@JsonKey() final  int maxAge;
/// Null = no location filter applied.
@override final  LocationFilterMode? locationMode;
/// Distance-mode fields. Kept even when [locationMode] is `country` so
/// switching back restores the last slider position.
@override@JsonKey() final  double distanceMiles;
@override@JsonKey() final  bool limitToHomeCountry;
/// Country-mode field: ISO code from `package:core` `allCountries`.
@override final  String? countryCode;
/// Ethnicity codes; empty = "No preference".
 final  List<String> _ethnicities;
/// Ethnicity codes; empty = "No preference".
@override@JsonKey() List<String> get ethnicities {
  if (_ethnicities is EqualUnmodifiableListView) return _ethnicities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ethnicities);
}


/// Create a copy of DiscoveryFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveryFiltersCopyWith<_DiscoveryFilters> get copyWith => __$DiscoveryFiltersCopyWithImpl<_DiscoveryFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveryFilters&&(identical(other.minAge, minAge) || other.minAge == minAge)&&(identical(other.maxAge, maxAge) || other.maxAge == maxAge)&&(identical(other.locationMode, locationMode) || other.locationMode == locationMode)&&(identical(other.distanceMiles, distanceMiles) || other.distanceMiles == distanceMiles)&&(identical(other.limitToHomeCountry, limitToHomeCountry) || other.limitToHomeCountry == limitToHomeCountry)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&const DeepCollectionEquality().equals(other._ethnicities, _ethnicities));
}


@override
int get hashCode => Object.hash(runtimeType,minAge,maxAge,locationMode,distanceMiles,limitToHomeCountry,countryCode,const DeepCollectionEquality().hash(_ethnicities));

@override
String toString() {
  return 'DiscoveryFilters(minAge: $minAge, maxAge: $maxAge, locationMode: $locationMode, distanceMiles: $distanceMiles, limitToHomeCountry: $limitToHomeCountry, countryCode: $countryCode, ethnicities: $ethnicities)';
}


}

/// @nodoc
abstract mixin class _$DiscoveryFiltersCopyWith<$Res> implements $DiscoveryFiltersCopyWith<$Res> {
  factory _$DiscoveryFiltersCopyWith(_DiscoveryFilters value, $Res Function(_DiscoveryFilters) _then) = __$DiscoveryFiltersCopyWithImpl;
@override @useResult
$Res call({
 int minAge, int maxAge, LocationFilterMode? locationMode, double distanceMiles, bool limitToHomeCountry, String? countryCode, List<String> ethnicities
});




}
/// @nodoc
class __$DiscoveryFiltersCopyWithImpl<$Res>
    implements _$DiscoveryFiltersCopyWith<$Res> {
  __$DiscoveryFiltersCopyWithImpl(this._self, this._then);

  final _DiscoveryFilters _self;
  final $Res Function(_DiscoveryFilters) _then;

/// Create a copy of DiscoveryFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minAge = null,Object? maxAge = null,Object? locationMode = freezed,Object? distanceMiles = null,Object? limitToHomeCountry = null,Object? countryCode = freezed,Object? ethnicities = null,}) {
  return _then(_DiscoveryFilters(
minAge: null == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int,maxAge: null == maxAge ? _self.maxAge : maxAge // ignore: cast_nullable_to_non_nullable
as int,locationMode: freezed == locationMode ? _self.locationMode : locationMode // ignore: cast_nullable_to_non_nullable
as LocationFilterMode?,distanceMiles: null == distanceMiles ? _self.distanceMiles : distanceMiles // ignore: cast_nullable_to_non_nullable
as double,limitToHomeCountry: null == limitToHomeCountry ? _self.limitToHomeCountry : limitToHomeCountry // ignore: cast_nullable_to_non_nullable
as bool,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,ethnicities: null == ethnicities ? _self._ethnicities : ethnicities // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$GeoPoint {

 double get latitude; double get longitude;
/// Create a copy of GeoPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoPointCopyWith<GeoPoint> get copyWith => _$GeoPointCopyWithImpl<GeoPoint>(this as GeoPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoPoint&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'GeoPoint(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class $GeoPointCopyWith<$Res>  {
  factory $GeoPointCopyWith(GeoPoint value, $Res Function(GeoPoint) _then) = _$GeoPointCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class _$GeoPointCopyWithImpl<$Res>
    implements $GeoPointCopyWith<$Res> {
  _$GeoPointCopyWithImpl(this._self, this._then);

  final GeoPoint _self;
  final $Res Function(GeoPoint) _then;

/// Create a copy of GeoPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_self.copyWith(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoPoint].
extension GeoPointPatterns on GeoPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoPoint value)  $default,){
final _that = this;
switch (_that) {
case _GeoPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoPoint value)?  $default,){
final _that = this;
switch (_that) {
case _GeoPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoPoint() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _GeoPoint():
return $default(_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _GeoPoint() when $default != null:
return $default(_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc


class _GeoPoint implements GeoPoint {
  const _GeoPoint(this.latitude, this.longitude);
  

@override final  double latitude;
@override final  double longitude;

/// Create a copy of GeoPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoPointCopyWith<_GeoPoint> get copyWith => __$GeoPointCopyWithImpl<_GeoPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoPoint&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode => Object.hash(runtimeType,latitude,longitude);

@override
String toString() {
  return 'GeoPoint(latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$GeoPointCopyWith<$Res> implements $GeoPointCopyWith<$Res> {
  factory _$GeoPointCopyWith(_GeoPoint value, $Res Function(_GeoPoint) _then) = __$GeoPointCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude
});




}
/// @nodoc
class __$GeoPointCopyWithImpl<$Res>
    implements _$GeoPointCopyWith<$Res> {
  __$GeoPointCopyWithImpl(this._self, this._then);

  final _GeoPoint _self;
  final $Res Function(_GeoPoint) _then;

/// Create a copy of GeoPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,}) {
  return _then(_GeoPoint(
null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
