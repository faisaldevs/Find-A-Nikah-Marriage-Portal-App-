// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileCardsResponseDto {

 ProfileCardsDataDto get data;
/// Create a copy of ProfileCardsResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCardsResponseDtoCopyWith<ProfileCardsResponseDto> get copyWith => _$ProfileCardsResponseDtoCopyWithImpl<ProfileCardsResponseDto>(this as ProfileCardsResponseDto, _$identity);

  /// Serializes this ProfileCardsResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileCardsResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ProfileCardsResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $ProfileCardsResponseDtoCopyWith<$Res>  {
  factory $ProfileCardsResponseDtoCopyWith(ProfileCardsResponseDto value, $Res Function(ProfileCardsResponseDto) _then) = _$ProfileCardsResponseDtoCopyWithImpl;
@useResult
$Res call({
 ProfileCardsDataDto data
});


$ProfileCardsDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$ProfileCardsResponseDtoCopyWithImpl<$Res>
    implements $ProfileCardsResponseDtoCopyWith<$Res> {
  _$ProfileCardsResponseDtoCopyWithImpl(this._self, this._then);

  final ProfileCardsResponseDto _self;
  final $Res Function(ProfileCardsResponseDto) _then;

/// Create a copy of ProfileCardsResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ProfileCardsDataDto,
  ));
}
/// Create a copy of ProfileCardsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCardsDataDtoCopyWith<$Res> get data {
  
  return $ProfileCardsDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileCardsResponseDto].
extension ProfileCardsResponseDtoPatterns on ProfileCardsResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileCardsResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileCardsResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileCardsResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileCardsResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileCardsResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileCardsResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileCardsDataDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileCardsResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileCardsDataDto data)  $default,) {final _that = this;
switch (_that) {
case _ProfileCardsResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileCardsDataDto data)?  $default,) {final _that = this;
switch (_that) {
case _ProfileCardsResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileCardsResponseDto implements ProfileCardsResponseDto {
  const _ProfileCardsResponseDto({required this.data});
  factory _ProfileCardsResponseDto.fromJson(Map<String, dynamic> json) => _$ProfileCardsResponseDtoFromJson(json);

@override final  ProfileCardsDataDto data;

/// Create a copy of ProfileCardsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCardsResponseDtoCopyWith<_ProfileCardsResponseDto> get copyWith => __$ProfileCardsResponseDtoCopyWithImpl<_ProfileCardsResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileCardsResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileCardsResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ProfileCardsResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ProfileCardsResponseDtoCopyWith<$Res> implements $ProfileCardsResponseDtoCopyWith<$Res> {
  factory _$ProfileCardsResponseDtoCopyWith(_ProfileCardsResponseDto value, $Res Function(_ProfileCardsResponseDto) _then) = __$ProfileCardsResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 ProfileCardsDataDto data
});


@override $ProfileCardsDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$ProfileCardsResponseDtoCopyWithImpl<$Res>
    implements _$ProfileCardsResponseDtoCopyWith<$Res> {
  __$ProfileCardsResponseDtoCopyWithImpl(this._self, this._then);

  final _ProfileCardsResponseDto _self;
  final $Res Function(_ProfileCardsResponseDto) _then;

/// Create a copy of ProfileCardsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ProfileCardsResponseDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ProfileCardsDataDto,
  ));
}

/// Create a copy of ProfileCardsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCardsDataDtoCopyWith<$Res> get data {
  
  return $ProfileCardsDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ProfileCardsDataDto {

 List<ProfileCardDto> get cards; bool get hasMore;
/// Create a copy of ProfileCardsDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCardsDataDtoCopyWith<ProfileCardsDataDto> get copyWith => _$ProfileCardsDataDtoCopyWithImpl<ProfileCardsDataDto>(this as ProfileCardsDataDto, _$identity);

  /// Serializes this ProfileCardsDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileCardsDataDto&&const DeepCollectionEquality().equals(other.cards, cards)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cards),hasMore);

@override
String toString() {
  return 'ProfileCardsDataDto(cards: $cards, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $ProfileCardsDataDtoCopyWith<$Res>  {
  factory $ProfileCardsDataDtoCopyWith(ProfileCardsDataDto value, $Res Function(ProfileCardsDataDto) _then) = _$ProfileCardsDataDtoCopyWithImpl;
@useResult
$Res call({
 List<ProfileCardDto> cards, bool hasMore
});




}
/// @nodoc
class _$ProfileCardsDataDtoCopyWithImpl<$Res>
    implements $ProfileCardsDataDtoCopyWith<$Res> {
  _$ProfileCardsDataDtoCopyWithImpl(this._self, this._then);

  final ProfileCardsDataDto _self;
  final $Res Function(ProfileCardsDataDto) _then;

/// Create a copy of ProfileCardsDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cards = null,Object? hasMore = null,}) {
  return _then(_self.copyWith(
cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<ProfileCardDto>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileCardsDataDto].
extension ProfileCardsDataDtoPatterns on ProfileCardsDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileCardsDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileCardsDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileCardsDataDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileCardsDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileCardsDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileCardsDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ProfileCardDto> cards,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileCardsDataDto() when $default != null:
return $default(_that.cards,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ProfileCardDto> cards,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _ProfileCardsDataDto():
return $default(_that.cards,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ProfileCardDto> cards,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _ProfileCardsDataDto() when $default != null:
return $default(_that.cards,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileCardsDataDto implements ProfileCardsDataDto {
  const _ProfileCardsDataDto({final  List<ProfileCardDto> cards = const <ProfileCardDto>[], this.hasMore = false}): _cards = cards;
  factory _ProfileCardsDataDto.fromJson(Map<String, dynamic> json) => _$ProfileCardsDataDtoFromJson(json);

 final  List<ProfileCardDto> _cards;
@override@JsonKey() List<ProfileCardDto> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

@override@JsonKey() final  bool hasMore;

/// Create a copy of ProfileCardsDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCardsDataDtoCopyWith<_ProfileCardsDataDto> get copyWith => __$ProfileCardsDataDtoCopyWithImpl<_ProfileCardsDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileCardsDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileCardsDataDto&&const DeepCollectionEquality().equals(other._cards, _cards)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cards),hasMore);

@override
String toString() {
  return 'ProfileCardsDataDto(cards: $cards, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$ProfileCardsDataDtoCopyWith<$Res> implements $ProfileCardsDataDtoCopyWith<$Res> {
  factory _$ProfileCardsDataDtoCopyWith(_ProfileCardsDataDto value, $Res Function(_ProfileCardsDataDto) _then) = __$ProfileCardsDataDtoCopyWithImpl;
@override @useResult
$Res call({
 List<ProfileCardDto> cards, bool hasMore
});




}
/// @nodoc
class __$ProfileCardsDataDtoCopyWithImpl<$Res>
    implements _$ProfileCardsDataDtoCopyWith<$Res> {
  __$ProfileCardsDataDtoCopyWithImpl(this._self, this._then);

  final _ProfileCardsDataDto _self;
  final $Res Function(_ProfileCardsDataDto) _then;

/// Create a copy of ProfileCardsDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cards = null,Object? hasMore = null,}) {
  return _then(_ProfileCardsDataDto(
cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<ProfileCardDto>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProfileCardDto {

 String get userId; String get fullName; bool get isVerified; String? get lastActiveAt; int? get age; List<String> get faith; List<String> get ethnicity; String? get country; double? get distanceKm; String? get aboutMe; String? get educationLevel; String? get professionTitle; String? get maritalStatus; int? get heightCm;/// Server-relative (`/public/upload/x.jpg`).
 List<String> get images; String? get primaryPhoto; List<String> get allInterests; List<String> get sharedInterests;
/// Create a copy of ProfileCardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCardDtoCopyWith<ProfileCardDto> get copyWith => _$ProfileCardDtoCopyWithImpl<ProfileCardDto>(this as ProfileCardDto, _$identity);

  /// Serializes this ProfileCardDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileCardDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other.faith, faith)&&const DeepCollectionEquality().equals(other.ethnicity, ethnicity)&&(identical(other.country, country) || other.country == country)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.aboutMe, aboutMe) || other.aboutMe == aboutMe)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.professionTitle, professionTitle) || other.professionTitle == professionTitle)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.primaryPhoto, primaryPhoto) || other.primaryPhoto == primaryPhoto)&&const DeepCollectionEquality().equals(other.allInterests, allInterests)&&const DeepCollectionEquality().equals(other.sharedInterests, sharedInterests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,isVerified,lastActiveAt,age,const DeepCollectionEquality().hash(faith),const DeepCollectionEquality().hash(ethnicity),country,distanceKm,aboutMe,educationLevel,professionTitle,maritalStatus,heightCm,const DeepCollectionEquality().hash(images),primaryPhoto,const DeepCollectionEquality().hash(allInterests),const DeepCollectionEquality().hash(sharedInterests));

@override
String toString() {
  return 'ProfileCardDto(userId: $userId, fullName: $fullName, isVerified: $isVerified, lastActiveAt: $lastActiveAt, age: $age, faith: $faith, ethnicity: $ethnicity, country: $country, distanceKm: $distanceKm, aboutMe: $aboutMe, educationLevel: $educationLevel, professionTitle: $professionTitle, maritalStatus: $maritalStatus, heightCm: $heightCm, images: $images, primaryPhoto: $primaryPhoto, allInterests: $allInterests, sharedInterests: $sharedInterests)';
}


}

/// @nodoc
abstract mixin class $ProfileCardDtoCopyWith<$Res>  {
  factory $ProfileCardDtoCopyWith(ProfileCardDto value, $Res Function(ProfileCardDto) _then) = _$ProfileCardDtoCopyWithImpl;
@useResult
$Res call({
 String userId, String fullName, bool isVerified, String? lastActiveAt, int? age, List<String> faith, List<String> ethnicity, String? country, double? distanceKm, String? aboutMe, String? educationLevel, String? professionTitle, String? maritalStatus, int? heightCm, List<String> images, String? primaryPhoto, List<String> allInterests, List<String> sharedInterests
});




}
/// @nodoc
class _$ProfileCardDtoCopyWithImpl<$Res>
    implements $ProfileCardDtoCopyWith<$Res> {
  _$ProfileCardDtoCopyWithImpl(this._self, this._then);

  final ProfileCardDto _self;
  final $Res Function(ProfileCardDto) _then;

/// Create a copy of ProfileCardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? fullName = null,Object? isVerified = null,Object? lastActiveAt = freezed,Object? age = freezed,Object? faith = null,Object? ethnicity = null,Object? country = freezed,Object? distanceKm = freezed,Object? aboutMe = freezed,Object? educationLevel = freezed,Object? professionTitle = freezed,Object? maritalStatus = freezed,Object? heightCm = freezed,Object? images = null,Object? primaryPhoto = freezed,Object? allInterests = null,Object? sharedInterests = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,faith: null == faith ? _self.faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,ethnicity: null == ethnicity ? _self.ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as List<String>,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,aboutMe: freezed == aboutMe ? _self.aboutMe : aboutMe // ignore: cast_nullable_to_non_nullable
as String?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,professionTitle: freezed == professionTitle ? _self.professionTitle : professionTitle // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>,primaryPhoto: freezed == primaryPhoto ? _self.primaryPhoto : primaryPhoto // ignore: cast_nullable_to_non_nullable
as String?,allInterests: null == allInterests ? _self.allInterests : allInterests // ignore: cast_nullable_to_non_nullable
as List<String>,sharedInterests: null == sharedInterests ? _self.sharedInterests : sharedInterests // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileCardDto].
extension ProfileCardDtoPatterns on ProfileCardDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileCardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileCardDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileCardDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileCardDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileCardDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileCardDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String fullName,  bool isVerified,  String? lastActiveAt,  int? age,  List<String> faith,  List<String> ethnicity,  String? country,  double? distanceKm,  String? aboutMe,  String? educationLevel,  String? professionTitle,  String? maritalStatus,  int? heightCm,  List<String> images,  String? primaryPhoto,  List<String> allInterests,  List<String> sharedInterests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileCardDto() when $default != null:
return $default(_that.userId,_that.fullName,_that.isVerified,_that.lastActiveAt,_that.age,_that.faith,_that.ethnicity,_that.country,_that.distanceKm,_that.aboutMe,_that.educationLevel,_that.professionTitle,_that.maritalStatus,_that.heightCm,_that.images,_that.primaryPhoto,_that.allInterests,_that.sharedInterests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String fullName,  bool isVerified,  String? lastActiveAt,  int? age,  List<String> faith,  List<String> ethnicity,  String? country,  double? distanceKm,  String? aboutMe,  String? educationLevel,  String? professionTitle,  String? maritalStatus,  int? heightCm,  List<String> images,  String? primaryPhoto,  List<String> allInterests,  List<String> sharedInterests)  $default,) {final _that = this;
switch (_that) {
case _ProfileCardDto():
return $default(_that.userId,_that.fullName,_that.isVerified,_that.lastActiveAt,_that.age,_that.faith,_that.ethnicity,_that.country,_that.distanceKm,_that.aboutMe,_that.educationLevel,_that.professionTitle,_that.maritalStatus,_that.heightCm,_that.images,_that.primaryPhoto,_that.allInterests,_that.sharedInterests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String fullName,  bool isVerified,  String? lastActiveAt,  int? age,  List<String> faith,  List<String> ethnicity,  String? country,  double? distanceKm,  String? aboutMe,  String? educationLevel,  String? professionTitle,  String? maritalStatus,  int? heightCm,  List<String> images,  String? primaryPhoto,  List<String> allInterests,  List<String> sharedInterests)?  $default,) {final _that = this;
switch (_that) {
case _ProfileCardDto() when $default != null:
return $default(_that.userId,_that.fullName,_that.isVerified,_that.lastActiveAt,_that.age,_that.faith,_that.ethnicity,_that.country,_that.distanceKm,_that.aboutMe,_that.educationLevel,_that.professionTitle,_that.maritalStatus,_that.heightCm,_that.images,_that.primaryPhoto,_that.allInterests,_that.sharedInterests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileCardDto implements ProfileCardDto {
  const _ProfileCardDto({required this.userId, this.fullName = '', this.isVerified = false, this.lastActiveAt, this.age, final  List<String> faith = const <String>[], final  List<String> ethnicity = const <String>[], this.country, this.distanceKm, this.aboutMe, this.educationLevel, this.professionTitle, this.maritalStatus, this.heightCm, final  List<String> images = const <String>[], this.primaryPhoto, final  List<String> allInterests = const <String>[], final  List<String> sharedInterests = const <String>[]}): _faith = faith,_ethnicity = ethnicity,_images = images,_allInterests = allInterests,_sharedInterests = sharedInterests;
  factory _ProfileCardDto.fromJson(Map<String, dynamic> json) => _$ProfileCardDtoFromJson(json);

@override final  String userId;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  bool isVerified;
@override final  String? lastActiveAt;
@override final  int? age;
 final  List<String> _faith;
@override@JsonKey() List<String> get faith {
  if (_faith is EqualUnmodifiableListView) return _faith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faith);
}

 final  List<String> _ethnicity;
@override@JsonKey() List<String> get ethnicity {
  if (_ethnicity is EqualUnmodifiableListView) return _ethnicity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ethnicity);
}

@override final  String? country;
@override final  double? distanceKm;
@override final  String? aboutMe;
@override final  String? educationLevel;
@override final  String? professionTitle;
@override final  String? maritalStatus;
@override final  int? heightCm;
/// Server-relative (`/public/upload/x.jpg`).
 final  List<String> _images;
/// Server-relative (`/public/upload/x.jpg`).
@override@JsonKey() List<String> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override final  String? primaryPhoto;
 final  List<String> _allInterests;
@override@JsonKey() List<String> get allInterests {
  if (_allInterests is EqualUnmodifiableListView) return _allInterests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allInterests);
}

 final  List<String> _sharedInterests;
@override@JsonKey() List<String> get sharedInterests {
  if (_sharedInterests is EqualUnmodifiableListView) return _sharedInterests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedInterests);
}


/// Create a copy of ProfileCardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCardDtoCopyWith<_ProfileCardDto> get copyWith => __$ProfileCardDtoCopyWithImpl<_ProfileCardDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileCardDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileCardDto&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other._faith, _faith)&&const DeepCollectionEquality().equals(other._ethnicity, _ethnicity)&&(identical(other.country, country) || other.country == country)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.aboutMe, aboutMe) || other.aboutMe == aboutMe)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.professionTitle, professionTitle) || other.professionTitle == professionTitle)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.primaryPhoto, primaryPhoto) || other.primaryPhoto == primaryPhoto)&&const DeepCollectionEquality().equals(other._allInterests, _allInterests)&&const DeepCollectionEquality().equals(other._sharedInterests, _sharedInterests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,fullName,isVerified,lastActiveAt,age,const DeepCollectionEquality().hash(_faith),const DeepCollectionEquality().hash(_ethnicity),country,distanceKm,aboutMe,educationLevel,professionTitle,maritalStatus,heightCm,const DeepCollectionEquality().hash(_images),primaryPhoto,const DeepCollectionEquality().hash(_allInterests),const DeepCollectionEquality().hash(_sharedInterests));

@override
String toString() {
  return 'ProfileCardDto(userId: $userId, fullName: $fullName, isVerified: $isVerified, lastActiveAt: $lastActiveAt, age: $age, faith: $faith, ethnicity: $ethnicity, country: $country, distanceKm: $distanceKm, aboutMe: $aboutMe, educationLevel: $educationLevel, professionTitle: $professionTitle, maritalStatus: $maritalStatus, heightCm: $heightCm, images: $images, primaryPhoto: $primaryPhoto, allInterests: $allInterests, sharedInterests: $sharedInterests)';
}


}

/// @nodoc
abstract mixin class _$ProfileCardDtoCopyWith<$Res> implements $ProfileCardDtoCopyWith<$Res> {
  factory _$ProfileCardDtoCopyWith(_ProfileCardDto value, $Res Function(_ProfileCardDto) _then) = __$ProfileCardDtoCopyWithImpl;
@override @useResult
$Res call({
 String userId, String fullName, bool isVerified, String? lastActiveAt, int? age, List<String> faith, List<String> ethnicity, String? country, double? distanceKm, String? aboutMe, String? educationLevel, String? professionTitle, String? maritalStatus, int? heightCm, List<String> images, String? primaryPhoto, List<String> allInterests, List<String> sharedInterests
});




}
/// @nodoc
class __$ProfileCardDtoCopyWithImpl<$Res>
    implements _$ProfileCardDtoCopyWith<$Res> {
  __$ProfileCardDtoCopyWithImpl(this._self, this._then);

  final _ProfileCardDto _self;
  final $Res Function(_ProfileCardDto) _then;

/// Create a copy of ProfileCardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? fullName = null,Object? isVerified = null,Object? lastActiveAt = freezed,Object? age = freezed,Object? faith = null,Object? ethnicity = null,Object? country = freezed,Object? distanceKm = freezed,Object? aboutMe = freezed,Object? educationLevel = freezed,Object? professionTitle = freezed,Object? maritalStatus = freezed,Object? heightCm = freezed,Object? images = null,Object? primaryPhoto = freezed,Object? allInterests = null,Object? sharedInterests = null,}) {
  return _then(_ProfileCardDto(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,faith: null == faith ? _self._faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,ethnicity: null == ethnicity ? _self._ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as List<String>,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,distanceKm: freezed == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double?,aboutMe: freezed == aboutMe ? _self.aboutMe : aboutMe // ignore: cast_nullable_to_non_nullable
as String?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,professionTitle: freezed == professionTitle ? _self.professionTitle : professionTitle // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>,primaryPhoto: freezed == primaryPhoto ? _self.primaryPhoto : primaryPhoto // ignore: cast_nullable_to_non_nullable
as String?,allInterests: null == allInterests ? _self._allInterests : allInterests // ignore: cast_nullable_to_non_nullable
as List<String>,sharedInterests: null == sharedInterests ? _self._sharedInterests : sharedInterests // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ProfileDetailResponseDto {

 ProfileDetailDataDto get data;
/// Create a copy of ProfileDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDetailResponseDtoCopyWith<ProfileDetailResponseDto> get copyWith => _$ProfileDetailResponseDtoCopyWithImpl<ProfileDetailResponseDto>(this as ProfileDetailResponseDto, _$identity);

  /// Serializes this ProfileDetailResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDetailResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ProfileDetailResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $ProfileDetailResponseDtoCopyWith<$Res>  {
  factory $ProfileDetailResponseDtoCopyWith(ProfileDetailResponseDto value, $Res Function(ProfileDetailResponseDto) _then) = _$ProfileDetailResponseDtoCopyWithImpl;
@useResult
$Res call({
 ProfileDetailDataDto data
});


$ProfileDetailDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class _$ProfileDetailResponseDtoCopyWithImpl<$Res>
    implements $ProfileDetailResponseDtoCopyWith<$Res> {
  _$ProfileDetailResponseDtoCopyWithImpl(this._self, this._then);

  final ProfileDetailResponseDto _self;
  final $Res Function(ProfileDetailResponseDto) _then;

/// Create a copy of ProfileDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ProfileDetailDataDto,
  ));
}
/// Create a copy of ProfileDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDetailDataDtoCopyWith<$Res> get data {
  
  return $ProfileDetailDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileDetailResponseDto].
extension ProfileDetailResponseDtoPatterns on ProfileDetailResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileDetailResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileDetailResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileDetailResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileDetailResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileDetailResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileDetailResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileDetailDataDto data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileDetailResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileDetailDataDto data)  $default,) {final _that = this;
switch (_that) {
case _ProfileDetailResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileDetailDataDto data)?  $default,) {final _that = this;
switch (_that) {
case _ProfileDetailResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileDetailResponseDto implements ProfileDetailResponseDto {
  const _ProfileDetailResponseDto({required this.data});
  factory _ProfileDetailResponseDto.fromJson(Map<String, dynamic> json) => _$ProfileDetailResponseDtoFromJson(json);

@override final  ProfileDetailDataDto data;

/// Create a copy of ProfileDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDetailResponseDtoCopyWith<_ProfileDetailResponseDto> get copyWith => __$ProfileDetailResponseDtoCopyWithImpl<_ProfileDetailResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileDetailResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileDetailResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ProfileDetailResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ProfileDetailResponseDtoCopyWith<$Res> implements $ProfileDetailResponseDtoCopyWith<$Res> {
  factory _$ProfileDetailResponseDtoCopyWith(_ProfileDetailResponseDto value, $Res Function(_ProfileDetailResponseDto) _then) = __$ProfileDetailResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 ProfileDetailDataDto data
});


@override $ProfileDetailDataDtoCopyWith<$Res> get data;

}
/// @nodoc
class __$ProfileDetailResponseDtoCopyWithImpl<$Res>
    implements _$ProfileDetailResponseDtoCopyWith<$Res> {
  __$ProfileDetailResponseDtoCopyWithImpl(this._self, this._then);

  final _ProfileDetailResponseDto _self;
  final $Res Function(_ProfileDetailResponseDto) _then;

/// Create a copy of ProfileDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ProfileDetailResponseDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ProfileDetailDataDto,
  ));
}

/// Create a copy of ProfileDetailResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDetailDataDtoCopyWith<$Res> get data {
  
  return $ProfileDetailDataDtoCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$ProfileDetailDataDto {

 ProfileDetailDto? get profile;
/// Create a copy of ProfileDetailDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDetailDataDtoCopyWith<ProfileDetailDataDto> get copyWith => _$ProfileDetailDataDtoCopyWithImpl<ProfileDetailDataDto>(this as ProfileDetailDataDto, _$identity);

  /// Serializes this ProfileDetailDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDetailDataDto&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'ProfileDetailDataDto(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $ProfileDetailDataDtoCopyWith<$Res>  {
  factory $ProfileDetailDataDtoCopyWith(ProfileDetailDataDto value, $Res Function(ProfileDetailDataDto) _then) = _$ProfileDetailDataDtoCopyWithImpl;
@useResult
$Res call({
 ProfileDetailDto? profile
});


$ProfileDetailDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class _$ProfileDetailDataDtoCopyWithImpl<$Res>
    implements $ProfileDetailDataDtoCopyWith<$Res> {
  _$ProfileDetailDataDtoCopyWithImpl(this._self, this._then);

  final ProfileDetailDataDto _self;
  final $Res Function(ProfileDetailDataDto) _then;

/// Create a copy of ProfileDetailDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,}) {
  return _then(_self.copyWith(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProfileDetailDto?,
  ));
}
/// Create a copy of ProfileDetailDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDetailDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileDetailDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileDetailDataDto].
extension ProfileDetailDataDtoPatterns on ProfileDetailDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileDetailDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileDetailDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileDetailDataDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileDetailDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileDetailDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileDetailDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileDetailDto? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileDetailDataDto() when $default != null:
return $default(_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileDetailDto? profile)  $default,) {final _that = this;
switch (_that) {
case _ProfileDetailDataDto():
return $default(_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileDetailDto? profile)?  $default,) {final _that = this;
switch (_that) {
case _ProfileDetailDataDto() when $default != null:
return $default(_that.profile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileDetailDataDto implements ProfileDetailDataDto {
  const _ProfileDetailDataDto({this.profile});
  factory _ProfileDetailDataDto.fromJson(Map<String, dynamic> json) => _$ProfileDetailDataDtoFromJson(json);

@override final  ProfileDetailDto? profile;

/// Create a copy of ProfileDetailDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDetailDataDtoCopyWith<_ProfileDetailDataDto> get copyWith => __$ProfileDetailDataDtoCopyWithImpl<_ProfileDetailDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileDetailDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileDetailDataDto&&(identical(other.profile, profile) || other.profile == profile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'ProfileDetailDataDto(profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$ProfileDetailDataDtoCopyWith<$Res> implements $ProfileDetailDataDtoCopyWith<$Res> {
  factory _$ProfileDetailDataDtoCopyWith(_ProfileDetailDataDto value, $Res Function(_ProfileDetailDataDto) _then) = __$ProfileDetailDataDtoCopyWithImpl;
@override @useResult
$Res call({
 ProfileDetailDto? profile
});


@override $ProfileDetailDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class __$ProfileDetailDataDtoCopyWithImpl<$Res>
    implements _$ProfileDetailDataDtoCopyWith<$Res> {
  __$ProfileDetailDataDtoCopyWithImpl(this._self, this._then);

  final _ProfileDetailDataDto _self;
  final $Res Function(_ProfileDetailDataDto) _then;

/// Create a copy of ProfileDetailDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,}) {
  return _then(_ProfileDetailDataDto(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProfileDetailDto?,
  ));
}

/// Create a copy of ProfileDetailDataDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDetailDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileDetailDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// @nodoc
mixin _$ProfileDetailDto {

 ProfileMarriageIntentionsDto? get marriageIntentions; ProfileAboutYouDto? get aboutYou; ProfileFaceVerificationDto? get faceVerification; List<String> get languages; List<String> get personalityTraits; List<String> get religiousPractices; List<String> get grewUpIn;
/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDetailDtoCopyWith<ProfileDetailDto> get copyWith => _$ProfileDetailDtoCopyWithImpl<ProfileDetailDto>(this as ProfileDetailDto, _$identity);

  /// Serializes this ProfileDetailDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDetailDto&&(identical(other.marriageIntentions, marriageIntentions) || other.marriageIntentions == marriageIntentions)&&(identical(other.aboutYou, aboutYou) || other.aboutYou == aboutYou)&&(identical(other.faceVerification, faceVerification) || other.faceVerification == faceVerification)&&const DeepCollectionEquality().equals(other.languages, languages)&&const DeepCollectionEquality().equals(other.personalityTraits, personalityTraits)&&const DeepCollectionEquality().equals(other.religiousPractices, religiousPractices)&&const DeepCollectionEquality().equals(other.grewUpIn, grewUpIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,marriageIntentions,aboutYou,faceVerification,const DeepCollectionEquality().hash(languages),const DeepCollectionEquality().hash(personalityTraits),const DeepCollectionEquality().hash(religiousPractices),const DeepCollectionEquality().hash(grewUpIn));

@override
String toString() {
  return 'ProfileDetailDto(marriageIntentions: $marriageIntentions, aboutYou: $aboutYou, faceVerification: $faceVerification, languages: $languages, personalityTraits: $personalityTraits, religiousPractices: $religiousPractices, grewUpIn: $grewUpIn)';
}


}

/// @nodoc
abstract mixin class $ProfileDetailDtoCopyWith<$Res>  {
  factory $ProfileDetailDtoCopyWith(ProfileDetailDto value, $Res Function(ProfileDetailDto) _then) = _$ProfileDetailDtoCopyWithImpl;
@useResult
$Res call({
 ProfileMarriageIntentionsDto? marriageIntentions, ProfileAboutYouDto? aboutYou, ProfileFaceVerificationDto? faceVerification, List<String> languages, List<String> personalityTraits, List<String> religiousPractices, List<String> grewUpIn
});


$ProfileMarriageIntentionsDtoCopyWith<$Res>? get marriageIntentions;$ProfileAboutYouDtoCopyWith<$Res>? get aboutYou;$ProfileFaceVerificationDtoCopyWith<$Res>? get faceVerification;

}
/// @nodoc
class _$ProfileDetailDtoCopyWithImpl<$Res>
    implements $ProfileDetailDtoCopyWith<$Res> {
  _$ProfileDetailDtoCopyWithImpl(this._self, this._then);

  final ProfileDetailDto _self;
  final $Res Function(ProfileDetailDto) _then;

/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? marriageIntentions = freezed,Object? aboutYou = freezed,Object? faceVerification = freezed,Object? languages = null,Object? personalityTraits = null,Object? religiousPractices = null,Object? grewUpIn = null,}) {
  return _then(_self.copyWith(
marriageIntentions: freezed == marriageIntentions ? _self.marriageIntentions : marriageIntentions // ignore: cast_nullable_to_non_nullable
as ProfileMarriageIntentionsDto?,aboutYou: freezed == aboutYou ? _self.aboutYou : aboutYou // ignore: cast_nullable_to_non_nullable
as ProfileAboutYouDto?,faceVerification: freezed == faceVerification ? _self.faceVerification : faceVerification // ignore: cast_nullable_to_non_nullable
as ProfileFaceVerificationDto?,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,personalityTraits: null == personalityTraits ? _self.personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,religiousPractices: null == religiousPractices ? _self.religiousPractices : religiousPractices // ignore: cast_nullable_to_non_nullable
as List<String>,grewUpIn: null == grewUpIn ? _self.grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileMarriageIntentionsDtoCopyWith<$Res>? get marriageIntentions {
    if (_self.marriageIntentions == null) {
    return null;
  }

  return $ProfileMarriageIntentionsDtoCopyWith<$Res>(_self.marriageIntentions!, (value) {
    return _then(_self.copyWith(marriageIntentions: value));
  });
}/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileAboutYouDtoCopyWith<$Res>? get aboutYou {
    if (_self.aboutYou == null) {
    return null;
  }

  return $ProfileAboutYouDtoCopyWith<$Res>(_self.aboutYou!, (value) {
    return _then(_self.copyWith(aboutYou: value));
  });
}/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileFaceVerificationDtoCopyWith<$Res>? get faceVerification {
    if (_self.faceVerification == null) {
    return null;
  }

  return $ProfileFaceVerificationDtoCopyWith<$Res>(_self.faceVerification!, (value) {
    return _then(_self.copyWith(faceVerification: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileDetailDto].
extension ProfileDetailDtoPatterns on ProfileDetailDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileDetailDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileDetailDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileDetailDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileDetailDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileDetailDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileDetailDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileMarriageIntentionsDto? marriageIntentions,  ProfileAboutYouDto? aboutYou,  ProfileFaceVerificationDto? faceVerification,  List<String> languages,  List<String> personalityTraits,  List<String> religiousPractices,  List<String> grewUpIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileDetailDto() when $default != null:
return $default(_that.marriageIntentions,_that.aboutYou,_that.faceVerification,_that.languages,_that.personalityTraits,_that.religiousPractices,_that.grewUpIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileMarriageIntentionsDto? marriageIntentions,  ProfileAboutYouDto? aboutYou,  ProfileFaceVerificationDto? faceVerification,  List<String> languages,  List<String> personalityTraits,  List<String> religiousPractices,  List<String> grewUpIn)  $default,) {final _that = this;
switch (_that) {
case _ProfileDetailDto():
return $default(_that.marriageIntentions,_that.aboutYou,_that.faceVerification,_that.languages,_that.personalityTraits,_that.religiousPractices,_that.grewUpIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileMarriageIntentionsDto? marriageIntentions,  ProfileAboutYouDto? aboutYou,  ProfileFaceVerificationDto? faceVerification,  List<String> languages,  List<String> personalityTraits,  List<String> religiousPractices,  List<String> grewUpIn)?  $default,) {final _that = this;
switch (_that) {
case _ProfileDetailDto() when $default != null:
return $default(_that.marriageIntentions,_that.aboutYou,_that.faceVerification,_that.languages,_that.personalityTraits,_that.religiousPractices,_that.grewUpIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileDetailDto implements ProfileDetailDto {
  const _ProfileDetailDto({this.marriageIntentions, this.aboutYou, this.faceVerification, final  List<String> languages = const <String>[], final  List<String> personalityTraits = const <String>[], final  List<String> religiousPractices = const <String>[], final  List<String> grewUpIn = const <String>[]}): _languages = languages,_personalityTraits = personalityTraits,_religiousPractices = religiousPractices,_grewUpIn = grewUpIn;
  factory _ProfileDetailDto.fromJson(Map<String, dynamic> json) => _$ProfileDetailDtoFromJson(json);

@override final  ProfileMarriageIntentionsDto? marriageIntentions;
@override final  ProfileAboutYouDto? aboutYou;
@override final  ProfileFaceVerificationDto? faceVerification;
 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

 final  List<String> _personalityTraits;
@override@JsonKey() List<String> get personalityTraits {
  if (_personalityTraits is EqualUnmodifiableListView) return _personalityTraits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_personalityTraits);
}

 final  List<String> _religiousPractices;
@override@JsonKey() List<String> get religiousPractices {
  if (_religiousPractices is EqualUnmodifiableListView) return _religiousPractices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_religiousPractices);
}

 final  List<String> _grewUpIn;
@override@JsonKey() List<String> get grewUpIn {
  if (_grewUpIn is EqualUnmodifiableListView) return _grewUpIn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_grewUpIn);
}


/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDetailDtoCopyWith<_ProfileDetailDto> get copyWith => __$ProfileDetailDtoCopyWithImpl<_ProfileDetailDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileDetailDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileDetailDto&&(identical(other.marriageIntentions, marriageIntentions) || other.marriageIntentions == marriageIntentions)&&(identical(other.aboutYou, aboutYou) || other.aboutYou == aboutYou)&&(identical(other.faceVerification, faceVerification) || other.faceVerification == faceVerification)&&const DeepCollectionEquality().equals(other._languages, _languages)&&const DeepCollectionEquality().equals(other._personalityTraits, _personalityTraits)&&const DeepCollectionEquality().equals(other._religiousPractices, _religiousPractices)&&const DeepCollectionEquality().equals(other._grewUpIn, _grewUpIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,marriageIntentions,aboutYou,faceVerification,const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_personalityTraits),const DeepCollectionEquality().hash(_religiousPractices),const DeepCollectionEquality().hash(_grewUpIn));

@override
String toString() {
  return 'ProfileDetailDto(marriageIntentions: $marriageIntentions, aboutYou: $aboutYou, faceVerification: $faceVerification, languages: $languages, personalityTraits: $personalityTraits, religiousPractices: $religiousPractices, grewUpIn: $grewUpIn)';
}


}

/// @nodoc
abstract mixin class _$ProfileDetailDtoCopyWith<$Res> implements $ProfileDetailDtoCopyWith<$Res> {
  factory _$ProfileDetailDtoCopyWith(_ProfileDetailDto value, $Res Function(_ProfileDetailDto) _then) = __$ProfileDetailDtoCopyWithImpl;
@override @useResult
$Res call({
 ProfileMarriageIntentionsDto? marriageIntentions, ProfileAboutYouDto? aboutYou, ProfileFaceVerificationDto? faceVerification, List<String> languages, List<String> personalityTraits, List<String> religiousPractices, List<String> grewUpIn
});


@override $ProfileMarriageIntentionsDtoCopyWith<$Res>? get marriageIntentions;@override $ProfileAboutYouDtoCopyWith<$Res>? get aboutYou;@override $ProfileFaceVerificationDtoCopyWith<$Res>? get faceVerification;

}
/// @nodoc
class __$ProfileDetailDtoCopyWithImpl<$Res>
    implements _$ProfileDetailDtoCopyWith<$Res> {
  __$ProfileDetailDtoCopyWithImpl(this._self, this._then);

  final _ProfileDetailDto _self;
  final $Res Function(_ProfileDetailDto) _then;

/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? marriageIntentions = freezed,Object? aboutYou = freezed,Object? faceVerification = freezed,Object? languages = null,Object? personalityTraits = null,Object? religiousPractices = null,Object? grewUpIn = null,}) {
  return _then(_ProfileDetailDto(
marriageIntentions: freezed == marriageIntentions ? _self.marriageIntentions : marriageIntentions // ignore: cast_nullable_to_non_nullable
as ProfileMarriageIntentionsDto?,aboutYou: freezed == aboutYou ? _self.aboutYou : aboutYou // ignore: cast_nullable_to_non_nullable
as ProfileAboutYouDto?,faceVerification: freezed == faceVerification ? _self.faceVerification : faceVerification // ignore: cast_nullable_to_non_nullable
as ProfileFaceVerificationDto?,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,personalityTraits: null == personalityTraits ? _self._personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,religiousPractices: null == religiousPractices ? _self._religiousPractices : religiousPractices // ignore: cast_nullable_to_non_nullable
as List<String>,grewUpIn: null == grewUpIn ? _self._grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileMarriageIntentionsDtoCopyWith<$Res>? get marriageIntentions {
    if (_self.marriageIntentions == null) {
    return null;
  }

  return $ProfileMarriageIntentionsDtoCopyWith<$Res>(_self.marriageIntentions!, (value) {
    return _then(_self.copyWith(marriageIntentions: value));
  });
}/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileAboutYouDtoCopyWith<$Res>? get aboutYou {
    if (_self.aboutYou == null) {
    return null;
  }

  return $ProfileAboutYouDtoCopyWith<$Res>(_self.aboutYou!, (value) {
    return _then(_self.copyWith(aboutYou: value));
  });
}/// Create a copy of ProfileDetailDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileFaceVerificationDtoCopyWith<$Res>? get faceVerification {
    if (_self.faceVerification == null) {
    return null;
  }

  return $ProfileFaceVerificationDtoCopyWith<$Res>(_self.faceVerification!, (value) {
    return _then(_self.copyWith(faceVerification: value));
  });
}
}


/// @nodoc
mixin _$ProfileMarriageIntentionsDto {

/// `3-4_months` — how long they'd chat ("Chatting").
 String? get getToknowDuration;/// `4-12_months` — how soon they'd marry ("Marriage").
 String? get marriageTimeline;
/// Create a copy of ProfileMarriageIntentionsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileMarriageIntentionsDtoCopyWith<ProfileMarriageIntentionsDto> get copyWith => _$ProfileMarriageIntentionsDtoCopyWithImpl<ProfileMarriageIntentionsDto>(this as ProfileMarriageIntentionsDto, _$identity);

  /// Serializes this ProfileMarriageIntentionsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileMarriageIntentionsDto&&(identical(other.getToknowDuration, getToknowDuration) || other.getToknowDuration == getToknowDuration)&&(identical(other.marriageTimeline, marriageTimeline) || other.marriageTimeline == marriageTimeline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,getToknowDuration,marriageTimeline);

@override
String toString() {
  return 'ProfileMarriageIntentionsDto(getToknowDuration: $getToknowDuration, marriageTimeline: $marriageTimeline)';
}


}

/// @nodoc
abstract mixin class $ProfileMarriageIntentionsDtoCopyWith<$Res>  {
  factory $ProfileMarriageIntentionsDtoCopyWith(ProfileMarriageIntentionsDto value, $Res Function(ProfileMarriageIntentionsDto) _then) = _$ProfileMarriageIntentionsDtoCopyWithImpl;
@useResult
$Res call({
 String? getToknowDuration, String? marriageTimeline
});




}
/// @nodoc
class _$ProfileMarriageIntentionsDtoCopyWithImpl<$Res>
    implements $ProfileMarriageIntentionsDtoCopyWith<$Res> {
  _$ProfileMarriageIntentionsDtoCopyWithImpl(this._self, this._then);

  final ProfileMarriageIntentionsDto _self;
  final $Res Function(ProfileMarriageIntentionsDto) _then;

/// Create a copy of ProfileMarriageIntentionsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? getToknowDuration = freezed,Object? marriageTimeline = freezed,}) {
  return _then(_self.copyWith(
getToknowDuration: freezed == getToknowDuration ? _self.getToknowDuration : getToknowDuration // ignore: cast_nullable_to_non_nullable
as String?,marriageTimeline: freezed == marriageTimeline ? _self.marriageTimeline : marriageTimeline // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileMarriageIntentionsDto].
extension ProfileMarriageIntentionsDtoPatterns on ProfileMarriageIntentionsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileMarriageIntentionsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileMarriageIntentionsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileMarriageIntentionsDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileMarriageIntentionsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileMarriageIntentionsDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileMarriageIntentionsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? getToknowDuration,  String? marriageTimeline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileMarriageIntentionsDto() when $default != null:
return $default(_that.getToknowDuration,_that.marriageTimeline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? getToknowDuration,  String? marriageTimeline)  $default,) {final _that = this;
switch (_that) {
case _ProfileMarriageIntentionsDto():
return $default(_that.getToknowDuration,_that.marriageTimeline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? getToknowDuration,  String? marriageTimeline)?  $default,) {final _that = this;
switch (_that) {
case _ProfileMarriageIntentionsDto() when $default != null:
return $default(_that.getToknowDuration,_that.marriageTimeline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileMarriageIntentionsDto implements ProfileMarriageIntentionsDto {
  const _ProfileMarriageIntentionsDto({this.getToknowDuration, this.marriageTimeline});
  factory _ProfileMarriageIntentionsDto.fromJson(Map<String, dynamic> json) => _$ProfileMarriageIntentionsDtoFromJson(json);

/// `3-4_months` — how long they'd chat ("Chatting").
@override final  String? getToknowDuration;
/// `4-12_months` — how soon they'd marry ("Marriage").
@override final  String? marriageTimeline;

/// Create a copy of ProfileMarriageIntentionsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileMarriageIntentionsDtoCopyWith<_ProfileMarriageIntentionsDto> get copyWith => __$ProfileMarriageIntentionsDtoCopyWithImpl<_ProfileMarriageIntentionsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileMarriageIntentionsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileMarriageIntentionsDto&&(identical(other.getToknowDuration, getToknowDuration) || other.getToknowDuration == getToknowDuration)&&(identical(other.marriageTimeline, marriageTimeline) || other.marriageTimeline == marriageTimeline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,getToknowDuration,marriageTimeline);

@override
String toString() {
  return 'ProfileMarriageIntentionsDto(getToknowDuration: $getToknowDuration, marriageTimeline: $marriageTimeline)';
}


}

/// @nodoc
abstract mixin class _$ProfileMarriageIntentionsDtoCopyWith<$Res> implements $ProfileMarriageIntentionsDtoCopyWith<$Res> {
  factory _$ProfileMarriageIntentionsDtoCopyWith(_ProfileMarriageIntentionsDto value, $Res Function(_ProfileMarriageIntentionsDto) _then) = __$ProfileMarriageIntentionsDtoCopyWithImpl;
@override @useResult
$Res call({
 String? getToknowDuration, String? marriageTimeline
});




}
/// @nodoc
class __$ProfileMarriageIntentionsDtoCopyWithImpl<$Res>
    implements _$ProfileMarriageIntentionsDtoCopyWith<$Res> {
  __$ProfileMarriageIntentionsDtoCopyWithImpl(this._self, this._then);

  final _ProfileMarriageIntentionsDto _self;
  final $Res Function(_ProfileMarriageIntentionsDto) _then;

/// Create a copy of ProfileMarriageIntentionsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? getToknowDuration = freezed,Object? marriageTimeline = freezed,}) {
  return _then(_ProfileMarriageIntentionsDto(
getToknowDuration: freezed == getToknowDuration ? _self.getToknowDuration : getToknowDuration // ignore: cast_nullable_to_non_nullable
as String?,marriageTimeline: freezed == marriageTimeline ? _self.marriageTimeline : marriageTimeline // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ProfileAboutYouDto {

 bool? get haveChildren; bool? get relocateAbroad;
/// Create a copy of ProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileAboutYouDtoCopyWith<ProfileAboutYouDto> get copyWith => _$ProfileAboutYouDtoCopyWithImpl<ProfileAboutYouDto>(this as ProfileAboutYouDto, _$identity);

  /// Serializes this ProfileAboutYouDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileAboutYouDto&&(identical(other.haveChildren, haveChildren) || other.haveChildren == haveChildren)&&(identical(other.relocateAbroad, relocateAbroad) || other.relocateAbroad == relocateAbroad));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,haveChildren,relocateAbroad);

@override
String toString() {
  return 'ProfileAboutYouDto(haveChildren: $haveChildren, relocateAbroad: $relocateAbroad)';
}


}

/// @nodoc
abstract mixin class $ProfileAboutYouDtoCopyWith<$Res>  {
  factory $ProfileAboutYouDtoCopyWith(ProfileAboutYouDto value, $Res Function(ProfileAboutYouDto) _then) = _$ProfileAboutYouDtoCopyWithImpl;
@useResult
$Res call({
 bool? haveChildren, bool? relocateAbroad
});




}
/// @nodoc
class _$ProfileAboutYouDtoCopyWithImpl<$Res>
    implements $ProfileAboutYouDtoCopyWith<$Res> {
  _$ProfileAboutYouDtoCopyWithImpl(this._self, this._then);

  final ProfileAboutYouDto _self;
  final $Res Function(ProfileAboutYouDto) _then;

/// Create a copy of ProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? haveChildren = freezed,Object? relocateAbroad = freezed,}) {
  return _then(_self.copyWith(
haveChildren: freezed == haveChildren ? _self.haveChildren : haveChildren // ignore: cast_nullable_to_non_nullable
as bool?,relocateAbroad: freezed == relocateAbroad ? _self.relocateAbroad : relocateAbroad // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileAboutYouDto].
extension ProfileAboutYouDtoPatterns on ProfileAboutYouDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileAboutYouDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileAboutYouDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileAboutYouDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileAboutYouDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileAboutYouDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileAboutYouDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? haveChildren,  bool? relocateAbroad)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileAboutYouDto() when $default != null:
return $default(_that.haveChildren,_that.relocateAbroad);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? haveChildren,  bool? relocateAbroad)  $default,) {final _that = this;
switch (_that) {
case _ProfileAboutYouDto():
return $default(_that.haveChildren,_that.relocateAbroad);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? haveChildren,  bool? relocateAbroad)?  $default,) {final _that = this;
switch (_that) {
case _ProfileAboutYouDto() when $default != null:
return $default(_that.haveChildren,_that.relocateAbroad);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileAboutYouDto implements ProfileAboutYouDto {
  const _ProfileAboutYouDto({this.haveChildren, this.relocateAbroad});
  factory _ProfileAboutYouDto.fromJson(Map<String, dynamic> json) => _$ProfileAboutYouDtoFromJson(json);

@override final  bool? haveChildren;
@override final  bool? relocateAbroad;

/// Create a copy of ProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileAboutYouDtoCopyWith<_ProfileAboutYouDto> get copyWith => __$ProfileAboutYouDtoCopyWithImpl<_ProfileAboutYouDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileAboutYouDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileAboutYouDto&&(identical(other.haveChildren, haveChildren) || other.haveChildren == haveChildren)&&(identical(other.relocateAbroad, relocateAbroad) || other.relocateAbroad == relocateAbroad));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,haveChildren,relocateAbroad);

@override
String toString() {
  return 'ProfileAboutYouDto(haveChildren: $haveChildren, relocateAbroad: $relocateAbroad)';
}


}

/// @nodoc
abstract mixin class _$ProfileAboutYouDtoCopyWith<$Res> implements $ProfileAboutYouDtoCopyWith<$Res> {
  factory _$ProfileAboutYouDtoCopyWith(_ProfileAboutYouDto value, $Res Function(_ProfileAboutYouDto) _then) = __$ProfileAboutYouDtoCopyWithImpl;
@override @useResult
$Res call({
 bool? haveChildren, bool? relocateAbroad
});




}
/// @nodoc
class __$ProfileAboutYouDtoCopyWithImpl<$Res>
    implements _$ProfileAboutYouDtoCopyWith<$Res> {
  __$ProfileAboutYouDtoCopyWithImpl(this._self, this._then);

  final _ProfileAboutYouDto _self;
  final $Res Function(_ProfileAboutYouDto) _then;

/// Create a copy of ProfileAboutYouDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? haveChildren = freezed,Object? relocateAbroad = freezed,}) {
  return _then(_ProfileAboutYouDto(
haveChildren: freezed == haveChildren ? _self.haveChildren : haveChildren // ignore: cast_nullable_to_non_nullable
as bool?,relocateAbroad: freezed == relocateAbroad ? _self.relocateAbroad : relocateAbroad // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$ProfileFaceVerificationDto {

 bool get isFaceVerified;
/// Create a copy of ProfileFaceVerificationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileFaceVerificationDtoCopyWith<ProfileFaceVerificationDto> get copyWith => _$ProfileFaceVerificationDtoCopyWithImpl<ProfileFaceVerificationDto>(this as ProfileFaceVerificationDto, _$identity);

  /// Serializes this ProfileFaceVerificationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileFaceVerificationDto&&(identical(other.isFaceVerified, isFaceVerified) || other.isFaceVerified == isFaceVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFaceVerified);

@override
String toString() {
  return 'ProfileFaceVerificationDto(isFaceVerified: $isFaceVerified)';
}


}

/// @nodoc
abstract mixin class $ProfileFaceVerificationDtoCopyWith<$Res>  {
  factory $ProfileFaceVerificationDtoCopyWith(ProfileFaceVerificationDto value, $Res Function(ProfileFaceVerificationDto) _then) = _$ProfileFaceVerificationDtoCopyWithImpl;
@useResult
$Res call({
 bool isFaceVerified
});




}
/// @nodoc
class _$ProfileFaceVerificationDtoCopyWithImpl<$Res>
    implements $ProfileFaceVerificationDtoCopyWith<$Res> {
  _$ProfileFaceVerificationDtoCopyWithImpl(this._self, this._then);

  final ProfileFaceVerificationDto _self;
  final $Res Function(ProfileFaceVerificationDto) _then;

/// Create a copy of ProfileFaceVerificationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isFaceVerified = null,}) {
  return _then(_self.copyWith(
isFaceVerified: null == isFaceVerified ? _self.isFaceVerified : isFaceVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileFaceVerificationDto].
extension ProfileFaceVerificationDtoPatterns on ProfileFaceVerificationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileFaceVerificationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileFaceVerificationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileFaceVerificationDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileFaceVerificationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileFaceVerificationDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileFaceVerificationDto() when $default != null:
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
case _ProfileFaceVerificationDto() when $default != null:
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
case _ProfileFaceVerificationDto():
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
case _ProfileFaceVerificationDto() when $default != null:
return $default(_that.isFaceVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileFaceVerificationDto implements ProfileFaceVerificationDto {
  const _ProfileFaceVerificationDto({this.isFaceVerified = false});
  factory _ProfileFaceVerificationDto.fromJson(Map<String, dynamic> json) => _$ProfileFaceVerificationDtoFromJson(json);

@override@JsonKey() final  bool isFaceVerified;

/// Create a copy of ProfileFaceVerificationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileFaceVerificationDtoCopyWith<_ProfileFaceVerificationDto> get copyWith => __$ProfileFaceVerificationDtoCopyWithImpl<_ProfileFaceVerificationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileFaceVerificationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileFaceVerificationDto&&(identical(other.isFaceVerified, isFaceVerified) || other.isFaceVerified == isFaceVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isFaceVerified);

@override
String toString() {
  return 'ProfileFaceVerificationDto(isFaceVerified: $isFaceVerified)';
}


}

/// @nodoc
abstract mixin class _$ProfileFaceVerificationDtoCopyWith<$Res> implements $ProfileFaceVerificationDtoCopyWith<$Res> {
  factory _$ProfileFaceVerificationDtoCopyWith(_ProfileFaceVerificationDto value, $Res Function(_ProfileFaceVerificationDto) _then) = __$ProfileFaceVerificationDtoCopyWithImpl;
@override @useResult
$Res call({
 bool isFaceVerified
});




}
/// @nodoc
class __$ProfileFaceVerificationDtoCopyWithImpl<$Res>
    implements _$ProfileFaceVerificationDtoCopyWith<$Res> {
  __$ProfileFaceVerificationDtoCopyWithImpl(this._self, this._then);

  final _ProfileFaceVerificationDto _self;
  final $Res Function(_ProfileFaceVerificationDto) _then;

/// Create a copy of ProfileFaceVerificationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isFaceVerified = null,}) {
  return _then(_ProfileFaceVerificationDto(
isFaceVerified: null == isFaceVerified ? _self.isFaceVerified : isFaceVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SwipeRequestDto {

 String get action;@JsonKey(includeIfNull: false) String? get targetUserId;
/// Create a copy of SwipeRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwipeRequestDtoCopyWith<SwipeRequestDto> get copyWith => _$SwipeRequestDtoCopyWithImpl<SwipeRequestDto>(this as SwipeRequestDto, _$identity);

  /// Serializes this SwipeRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwipeRequestDto&&(identical(other.action, action) || other.action == action)&&(identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,targetUserId);

@override
String toString() {
  return 'SwipeRequestDto(action: $action, targetUserId: $targetUserId)';
}


}

/// @nodoc
abstract mixin class $SwipeRequestDtoCopyWith<$Res>  {
  factory $SwipeRequestDtoCopyWith(SwipeRequestDto value, $Res Function(SwipeRequestDto) _then) = _$SwipeRequestDtoCopyWithImpl;
@useResult
$Res call({
 String action,@JsonKey(includeIfNull: false) String? targetUserId
});




}
/// @nodoc
class _$SwipeRequestDtoCopyWithImpl<$Res>
    implements $SwipeRequestDtoCopyWith<$Res> {
  _$SwipeRequestDtoCopyWithImpl(this._self, this._then);

  final SwipeRequestDto _self;
  final $Res Function(SwipeRequestDto) _then;

/// Create a copy of SwipeRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? targetUserId = freezed,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,targetUserId: freezed == targetUserId ? _self.targetUserId : targetUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SwipeRequestDto].
extension SwipeRequestDtoPatterns on SwipeRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwipeRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwipeRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwipeRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _SwipeRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwipeRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _SwipeRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String action, @JsonKey(includeIfNull: false)  String? targetUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwipeRequestDto() when $default != null:
return $default(_that.action,_that.targetUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String action, @JsonKey(includeIfNull: false)  String? targetUserId)  $default,) {final _that = this;
switch (_that) {
case _SwipeRequestDto():
return $default(_that.action,_that.targetUserId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String action, @JsonKey(includeIfNull: false)  String? targetUserId)?  $default,) {final _that = this;
switch (_that) {
case _SwipeRequestDto() when $default != null:
return $default(_that.action,_that.targetUserId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createFactory: false)

class _SwipeRequestDto implements SwipeRequestDto {
  const _SwipeRequestDto({required this.action, @JsonKey(includeIfNull: false) this.targetUserId});
  

@override final  String action;
@override@JsonKey(includeIfNull: false) final  String? targetUserId;

/// Create a copy of SwipeRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwipeRequestDtoCopyWith<_SwipeRequestDto> get copyWith => __$SwipeRequestDtoCopyWithImpl<_SwipeRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwipeRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwipeRequestDto&&(identical(other.action, action) || other.action == action)&&(identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,targetUserId);

@override
String toString() {
  return 'SwipeRequestDto(action: $action, targetUserId: $targetUserId)';
}


}

/// @nodoc
abstract mixin class _$SwipeRequestDtoCopyWith<$Res> implements $SwipeRequestDtoCopyWith<$Res> {
  factory _$SwipeRequestDtoCopyWith(_SwipeRequestDto value, $Res Function(_SwipeRequestDto) _then) = __$SwipeRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String action,@JsonKey(includeIfNull: false) String? targetUserId
});




}
/// @nodoc
class __$SwipeRequestDtoCopyWithImpl<$Res>
    implements _$SwipeRequestDtoCopyWith<$Res> {
  __$SwipeRequestDtoCopyWithImpl(this._self, this._then);

  final _SwipeRequestDto _self;
  final $Res Function(_SwipeRequestDto) _then;

/// Create a copy of SwipeRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? targetUserId = freezed,}) {
  return _then(_SwipeRequestDto(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,targetUserId: freezed == targetUserId ? _self.targetUserId : targetUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SwipeResponseDto {

 SwipeResponseDataDto? get data;
/// Create a copy of SwipeResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwipeResponseDtoCopyWith<SwipeResponseDto> get copyWith => _$SwipeResponseDtoCopyWithImpl<SwipeResponseDto>(this as SwipeResponseDto, _$identity);

  /// Serializes this SwipeResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwipeResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'SwipeResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class $SwipeResponseDtoCopyWith<$Res>  {
  factory $SwipeResponseDtoCopyWith(SwipeResponseDto value, $Res Function(SwipeResponseDto) _then) = _$SwipeResponseDtoCopyWithImpl;
@useResult
$Res call({
 SwipeResponseDataDto? data
});


$SwipeResponseDataDtoCopyWith<$Res>? get data;

}
/// @nodoc
class _$SwipeResponseDtoCopyWithImpl<$Res>
    implements $SwipeResponseDtoCopyWith<$Res> {
  _$SwipeResponseDtoCopyWithImpl(this._self, this._then);

  final SwipeResponseDto _self;
  final $Res Function(SwipeResponseDto) _then;

/// Create a copy of SwipeResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = freezed,}) {
  return _then(_self.copyWith(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SwipeResponseDataDto?,
  ));
}
/// Create a copy of SwipeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SwipeResponseDataDtoCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $SwipeResponseDataDtoCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [SwipeResponseDto].
extension SwipeResponseDtoPatterns on SwipeResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwipeResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwipeResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwipeResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SwipeResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwipeResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SwipeResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SwipeResponseDataDto? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwipeResponseDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SwipeResponseDataDto? data)  $default,) {final _that = this;
switch (_that) {
case _SwipeResponseDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SwipeResponseDataDto? data)?  $default,) {final _that = this;
switch (_that) {
case _SwipeResponseDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwipeResponseDto implements SwipeResponseDto {
  const _SwipeResponseDto({this.data});
  factory _SwipeResponseDto.fromJson(Map<String, dynamic> json) => _$SwipeResponseDtoFromJson(json);

@override final  SwipeResponseDataDto? data;

/// Create a copy of SwipeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwipeResponseDtoCopyWith<_SwipeResponseDto> get copyWith => __$SwipeResponseDtoCopyWithImpl<_SwipeResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwipeResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwipeResponseDto&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'SwipeResponseDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$SwipeResponseDtoCopyWith<$Res> implements $SwipeResponseDtoCopyWith<$Res> {
  factory _$SwipeResponseDtoCopyWith(_SwipeResponseDto value, $Res Function(_SwipeResponseDto) _then) = __$SwipeResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 SwipeResponseDataDto? data
});


@override $SwipeResponseDataDtoCopyWith<$Res>? get data;

}
/// @nodoc
class __$SwipeResponseDtoCopyWithImpl<$Res>
    implements _$SwipeResponseDtoCopyWith<$Res> {
  __$SwipeResponseDtoCopyWithImpl(this._self, this._then);

  final _SwipeResponseDto _self;
  final $Res Function(_SwipeResponseDto) _then;

/// Create a copy of SwipeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(_SwipeResponseDto(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as SwipeResponseDataDto?,
  ));
}

/// Create a copy of SwipeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SwipeResponseDataDtoCopyWith<$Res>? get data {
    if (_self.data == null) {
    return null;
  }

  return $SwipeResponseDataDtoCopyWith<$Res>(_self.data!, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$SwipeResponseDataDto {

 bool get isMatch;
/// Create a copy of SwipeResponseDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwipeResponseDataDtoCopyWith<SwipeResponseDataDto> get copyWith => _$SwipeResponseDataDtoCopyWithImpl<SwipeResponseDataDto>(this as SwipeResponseDataDto, _$identity);

  /// Serializes this SwipeResponseDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwipeResponseDataDto&&(identical(other.isMatch, isMatch) || other.isMatch == isMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isMatch);

@override
String toString() {
  return 'SwipeResponseDataDto(isMatch: $isMatch)';
}


}

/// @nodoc
abstract mixin class $SwipeResponseDataDtoCopyWith<$Res>  {
  factory $SwipeResponseDataDtoCopyWith(SwipeResponseDataDto value, $Res Function(SwipeResponseDataDto) _then) = _$SwipeResponseDataDtoCopyWithImpl;
@useResult
$Res call({
 bool isMatch
});




}
/// @nodoc
class _$SwipeResponseDataDtoCopyWithImpl<$Res>
    implements $SwipeResponseDataDtoCopyWith<$Res> {
  _$SwipeResponseDataDtoCopyWithImpl(this._self, this._then);

  final SwipeResponseDataDto _self;
  final $Res Function(SwipeResponseDataDto) _then;

/// Create a copy of SwipeResponseDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isMatch = null,}) {
  return _then(_self.copyWith(
isMatch: null == isMatch ? _self.isMatch : isMatch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SwipeResponseDataDto].
extension SwipeResponseDataDtoPatterns on SwipeResponseDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwipeResponseDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwipeResponseDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwipeResponseDataDto value)  $default,){
final _that = this;
switch (_that) {
case _SwipeResponseDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwipeResponseDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _SwipeResponseDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isMatch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwipeResponseDataDto() when $default != null:
return $default(_that.isMatch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isMatch)  $default,) {final _that = this;
switch (_that) {
case _SwipeResponseDataDto():
return $default(_that.isMatch);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isMatch)?  $default,) {final _that = this;
switch (_that) {
case _SwipeResponseDataDto() when $default != null:
return $default(_that.isMatch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwipeResponseDataDto implements SwipeResponseDataDto {
  const _SwipeResponseDataDto({this.isMatch = false});
  factory _SwipeResponseDataDto.fromJson(Map<String, dynamic> json) => _$SwipeResponseDataDtoFromJson(json);

@override@JsonKey() final  bool isMatch;

/// Create a copy of SwipeResponseDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwipeResponseDataDtoCopyWith<_SwipeResponseDataDto> get copyWith => __$SwipeResponseDataDtoCopyWithImpl<_SwipeResponseDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwipeResponseDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwipeResponseDataDto&&(identical(other.isMatch, isMatch) || other.isMatch == isMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isMatch);

@override
String toString() {
  return 'SwipeResponseDataDto(isMatch: $isMatch)';
}


}

/// @nodoc
abstract mixin class _$SwipeResponseDataDtoCopyWith<$Res> implements $SwipeResponseDataDtoCopyWith<$Res> {
  factory _$SwipeResponseDataDtoCopyWith(_SwipeResponseDataDto value, $Res Function(_SwipeResponseDataDto) _then) = __$SwipeResponseDataDtoCopyWithImpl;
@override @useResult
$Res call({
 bool isMatch
});




}
/// @nodoc
class __$SwipeResponseDataDtoCopyWithImpl<$Res>
    implements _$SwipeResponseDataDtoCopyWith<$Res> {
  __$SwipeResponseDataDtoCopyWithImpl(this._self, this._then);

  final _SwipeResponseDataDto _self;
  final $Res Function(_SwipeResponseDataDto) _then;

/// Create a copy of SwipeResponseDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isMatch = null,}) {
  return _then(_SwipeResponseDataDto(
isMatch: null == isMatch ? _self.isMatch : isMatch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
