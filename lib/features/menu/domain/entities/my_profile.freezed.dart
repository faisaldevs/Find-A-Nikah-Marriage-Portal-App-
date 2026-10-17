// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MyProfile {

 String get fullName;/// Full image URLs, first = main photo.
 List<String> get photos; bool get isVerified;/// 0–100.
 int get completeness; String? get email; String? get phone; DateTime? get dateOfBirth; String? get gender; String? get currentLocation; String? get grewUpIn; int? get heightCm; String? get maritalStatus; bool? get hasChildren; String? get bio; String? get gettingToKnow; String? get marriageTimeline; bool? get relocateAbroad; bool? get bornMuslim; String? get religiousPractice; List<String> get faith; bool? get halalFood; bool? get alcohol; bool? get smoking; List<String> get interests; List<String> get personality; String? get education; String? get profession; List<String> get ethnicity; List<String> get nationality; List<String> get languages;
/// Create a copy of MyProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyProfileCopyWith<MyProfile> get copyWith => _$MyProfileCopyWithImpl<MyProfile>(this as MyProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyProfile&&(identical(other.fullName, fullName) || other.fullName == fullName)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.completeness, completeness) || other.completeness == completeness)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.currentLocation, currentLocation) || other.currentLocation == currentLocation)&&(identical(other.grewUpIn, grewUpIn) || other.grewUpIn == grewUpIn)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.hasChildren, hasChildren) || other.hasChildren == hasChildren)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.gettingToKnow, gettingToKnow) || other.gettingToKnow == gettingToKnow)&&(identical(other.marriageTimeline, marriageTimeline) || other.marriageTimeline == marriageTimeline)&&(identical(other.relocateAbroad, relocateAbroad) || other.relocateAbroad == relocateAbroad)&&(identical(other.bornMuslim, bornMuslim) || other.bornMuslim == bornMuslim)&&(identical(other.religiousPractice, religiousPractice) || other.religiousPractice == religiousPractice)&&const DeepCollectionEquality().equals(other.faith, faith)&&(identical(other.halalFood, halalFood) || other.halalFood == halalFood)&&(identical(other.alcohol, alcohol) || other.alcohol == alcohol)&&(identical(other.smoking, smoking) || other.smoking == smoking)&&const DeepCollectionEquality().equals(other.interests, interests)&&const DeepCollectionEquality().equals(other.personality, personality)&&(identical(other.education, education) || other.education == education)&&(identical(other.profession, profession) || other.profession == profession)&&const DeepCollectionEquality().equals(other.ethnicity, ethnicity)&&const DeepCollectionEquality().equals(other.nationality, nationality)&&const DeepCollectionEquality().equals(other.languages, languages));
}


@override
int get hashCode => Object.hashAll([runtimeType,fullName,const DeepCollectionEquality().hash(photos),isVerified,completeness,email,phone,dateOfBirth,gender,currentLocation,grewUpIn,heightCm,maritalStatus,hasChildren,bio,gettingToKnow,marriageTimeline,relocateAbroad,bornMuslim,religiousPractice,const DeepCollectionEquality().hash(faith),halalFood,alcohol,smoking,const DeepCollectionEquality().hash(interests),const DeepCollectionEquality().hash(personality),education,profession,const DeepCollectionEquality().hash(ethnicity),const DeepCollectionEquality().hash(nationality),const DeepCollectionEquality().hash(languages)]);

@override
String toString() {
  return 'MyProfile(fullName: $fullName, photos: $photos, isVerified: $isVerified, completeness: $completeness, email: $email, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, currentLocation: $currentLocation, grewUpIn: $grewUpIn, heightCm: $heightCm, maritalStatus: $maritalStatus, hasChildren: $hasChildren, bio: $bio, gettingToKnow: $gettingToKnow, marriageTimeline: $marriageTimeline, relocateAbroad: $relocateAbroad, bornMuslim: $bornMuslim, religiousPractice: $religiousPractice, faith: $faith, halalFood: $halalFood, alcohol: $alcohol, smoking: $smoking, interests: $interests, personality: $personality, education: $education, profession: $profession, ethnicity: $ethnicity, nationality: $nationality, languages: $languages)';
}


}

/// @nodoc
abstract mixin class $MyProfileCopyWith<$Res>  {
  factory $MyProfileCopyWith(MyProfile value, $Res Function(MyProfile) _then) = _$MyProfileCopyWithImpl;
@useResult
$Res call({
 String fullName, List<String> photos, bool isVerified, int completeness, String? email, String? phone, DateTime? dateOfBirth, String? gender, String? currentLocation, String? grewUpIn, int? heightCm, String? maritalStatus, bool? hasChildren, String? bio, String? gettingToKnow, String? marriageTimeline, bool? relocateAbroad, bool? bornMuslim, String? religiousPractice, List<String> faith, bool? halalFood, bool? alcohol, bool? smoking, List<String> interests, List<String> personality, String? education, String? profession, List<String> ethnicity, List<String> nationality, List<String> languages
});




}
/// @nodoc
class _$MyProfileCopyWithImpl<$Res>
    implements $MyProfileCopyWith<$Res> {
  _$MyProfileCopyWithImpl(this._self, this._then);

  final MyProfile _self;
  final $Res Function(MyProfile) _then;

/// Create a copy of MyProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? photos = null,Object? isVerified = null,Object? completeness = null,Object? email = freezed,Object? phone = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? currentLocation = freezed,Object? grewUpIn = freezed,Object? heightCm = freezed,Object? maritalStatus = freezed,Object? hasChildren = freezed,Object? bio = freezed,Object? gettingToKnow = freezed,Object? marriageTimeline = freezed,Object? relocateAbroad = freezed,Object? bornMuslim = freezed,Object? religiousPractice = freezed,Object? faith = null,Object? halalFood = freezed,Object? alcohol = freezed,Object? smoking = freezed,Object? interests = null,Object? personality = null,Object? education = freezed,Object? profession = freezed,Object? ethnicity = null,Object? nationality = null,Object? languages = null,}) {
  return _then(_self.copyWith(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,completeness: null == completeness ? _self.completeness : completeness // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,currentLocation: freezed == currentLocation ? _self.currentLocation : currentLocation // ignore: cast_nullable_to_non_nullable
as String?,grewUpIn: freezed == grewUpIn ? _self.grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,hasChildren: freezed == hasChildren ? _self.hasChildren : hasChildren // ignore: cast_nullable_to_non_nullable
as bool?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,gettingToKnow: freezed == gettingToKnow ? _self.gettingToKnow : gettingToKnow // ignore: cast_nullable_to_non_nullable
as String?,marriageTimeline: freezed == marriageTimeline ? _self.marriageTimeline : marriageTimeline // ignore: cast_nullable_to_non_nullable
as String?,relocateAbroad: freezed == relocateAbroad ? _self.relocateAbroad : relocateAbroad // ignore: cast_nullable_to_non_nullable
as bool?,bornMuslim: freezed == bornMuslim ? _self.bornMuslim : bornMuslim // ignore: cast_nullable_to_non_nullable
as bool?,religiousPractice: freezed == religiousPractice ? _self.religiousPractice : religiousPractice // ignore: cast_nullable_to_non_nullable
as String?,faith: null == faith ? _self.faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,halalFood: freezed == halalFood ? _self.halalFood : halalFood // ignore: cast_nullable_to_non_nullable
as bool?,alcohol: freezed == alcohol ? _self.alcohol : alcohol // ignore: cast_nullable_to_non_nullable
as bool?,smoking: freezed == smoking ? _self.smoking : smoking // ignore: cast_nullable_to_non_nullable
as bool?,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as List<String>,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,ethnicity: null == ethnicity ? _self.ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as List<String>,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as List<String>,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [MyProfile].
extension MyProfilePatterns on MyProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyProfile value)  $default,){
final _that = this;
switch (_that) {
case _MyProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyProfile value)?  $default,){
final _that = this;
switch (_that) {
case _MyProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName,  List<String> photos,  bool isVerified,  int completeness,  String? email,  String? phone,  DateTime? dateOfBirth,  String? gender,  String? currentLocation,  String? grewUpIn,  int? heightCm,  String? maritalStatus,  bool? hasChildren,  String? bio,  String? gettingToKnow,  String? marriageTimeline,  bool? relocateAbroad,  bool? bornMuslim,  String? religiousPractice,  List<String> faith,  bool? halalFood,  bool? alcohol,  bool? smoking,  List<String> interests,  List<String> personality,  String? education,  String? profession,  List<String> ethnicity,  List<String> nationality,  List<String> languages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyProfile() when $default != null:
return $default(_that.fullName,_that.photos,_that.isVerified,_that.completeness,_that.email,_that.phone,_that.dateOfBirth,_that.gender,_that.currentLocation,_that.grewUpIn,_that.heightCm,_that.maritalStatus,_that.hasChildren,_that.bio,_that.gettingToKnow,_that.marriageTimeline,_that.relocateAbroad,_that.bornMuslim,_that.religiousPractice,_that.faith,_that.halalFood,_that.alcohol,_that.smoking,_that.interests,_that.personality,_that.education,_that.profession,_that.ethnicity,_that.nationality,_that.languages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName,  List<String> photos,  bool isVerified,  int completeness,  String? email,  String? phone,  DateTime? dateOfBirth,  String? gender,  String? currentLocation,  String? grewUpIn,  int? heightCm,  String? maritalStatus,  bool? hasChildren,  String? bio,  String? gettingToKnow,  String? marriageTimeline,  bool? relocateAbroad,  bool? bornMuslim,  String? religiousPractice,  List<String> faith,  bool? halalFood,  bool? alcohol,  bool? smoking,  List<String> interests,  List<String> personality,  String? education,  String? profession,  List<String> ethnicity,  List<String> nationality,  List<String> languages)  $default,) {final _that = this;
switch (_that) {
case _MyProfile():
return $default(_that.fullName,_that.photos,_that.isVerified,_that.completeness,_that.email,_that.phone,_that.dateOfBirth,_that.gender,_that.currentLocation,_that.grewUpIn,_that.heightCm,_that.maritalStatus,_that.hasChildren,_that.bio,_that.gettingToKnow,_that.marriageTimeline,_that.relocateAbroad,_that.bornMuslim,_that.religiousPractice,_that.faith,_that.halalFood,_that.alcohol,_that.smoking,_that.interests,_that.personality,_that.education,_that.profession,_that.ethnicity,_that.nationality,_that.languages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName,  List<String> photos,  bool isVerified,  int completeness,  String? email,  String? phone,  DateTime? dateOfBirth,  String? gender,  String? currentLocation,  String? grewUpIn,  int? heightCm,  String? maritalStatus,  bool? hasChildren,  String? bio,  String? gettingToKnow,  String? marriageTimeline,  bool? relocateAbroad,  bool? bornMuslim,  String? religiousPractice,  List<String> faith,  bool? halalFood,  bool? alcohol,  bool? smoking,  List<String> interests,  List<String> personality,  String? education,  String? profession,  List<String> ethnicity,  List<String> nationality,  List<String> languages)?  $default,) {final _that = this;
switch (_that) {
case _MyProfile() when $default != null:
return $default(_that.fullName,_that.photos,_that.isVerified,_that.completeness,_that.email,_that.phone,_that.dateOfBirth,_that.gender,_that.currentLocation,_that.grewUpIn,_that.heightCm,_that.maritalStatus,_that.hasChildren,_that.bio,_that.gettingToKnow,_that.marriageTimeline,_that.relocateAbroad,_that.bornMuslim,_that.religiousPractice,_that.faith,_that.halalFood,_that.alcohol,_that.smoking,_that.interests,_that.personality,_that.education,_that.profession,_that.ethnicity,_that.nationality,_that.languages);case _:
  return null;

}
}

}

/// @nodoc


class _MyProfile extends MyProfile {
  const _MyProfile({this.fullName = '', final  List<String> photos = const <String>[], this.isVerified = false, this.completeness = 0, this.email, this.phone, this.dateOfBirth, this.gender, this.currentLocation, this.grewUpIn, this.heightCm, this.maritalStatus, this.hasChildren, this.bio, this.gettingToKnow, this.marriageTimeline, this.relocateAbroad, this.bornMuslim, this.religiousPractice, final  List<String> faith = const <String>[], this.halalFood, this.alcohol, this.smoking, final  List<String> interests = const <String>[], final  List<String> personality = const <String>[], this.education, this.profession, final  List<String> ethnicity = const <String>[], final  List<String> nationality = const <String>[], final  List<String> languages = const <String>[]}): _photos = photos,_faith = faith,_interests = interests,_personality = personality,_ethnicity = ethnicity,_nationality = nationality,_languages = languages,super._();
  

@override@JsonKey() final  String fullName;
/// Full image URLs, first = main photo.
 final  List<String> _photos;
/// Full image URLs, first = main photo.
@override@JsonKey() List<String> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override@JsonKey() final  bool isVerified;
/// 0–100.
@override@JsonKey() final  int completeness;
@override final  String? email;
@override final  String? phone;
@override final  DateTime? dateOfBirth;
@override final  String? gender;
@override final  String? currentLocation;
@override final  String? grewUpIn;
@override final  int? heightCm;
@override final  String? maritalStatus;
@override final  bool? hasChildren;
@override final  String? bio;
@override final  String? gettingToKnow;
@override final  String? marriageTimeline;
@override final  bool? relocateAbroad;
@override final  bool? bornMuslim;
@override final  String? religiousPractice;
 final  List<String> _faith;
@override@JsonKey() List<String> get faith {
  if (_faith is EqualUnmodifiableListView) return _faith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faith);
}

@override final  bool? halalFood;
@override final  bool? alcohol;
@override final  bool? smoking;
 final  List<String> _interests;
@override@JsonKey() List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

 final  List<String> _personality;
@override@JsonKey() List<String> get personality {
  if (_personality is EqualUnmodifiableListView) return _personality;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_personality);
}

@override final  String? education;
@override final  String? profession;
 final  List<String> _ethnicity;
@override@JsonKey() List<String> get ethnicity {
  if (_ethnicity is EqualUnmodifiableListView) return _ethnicity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ethnicity);
}

 final  List<String> _nationality;
@override@JsonKey() List<String> get nationality {
  if (_nationality is EqualUnmodifiableListView) return _nationality;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nationality);
}

 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}


/// Create a copy of MyProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyProfileCopyWith<_MyProfile> get copyWith => __$MyProfileCopyWithImpl<_MyProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyProfile&&(identical(other.fullName, fullName) || other.fullName == fullName)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.completeness, completeness) || other.completeness == completeness)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.currentLocation, currentLocation) || other.currentLocation == currentLocation)&&(identical(other.grewUpIn, grewUpIn) || other.grewUpIn == grewUpIn)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.hasChildren, hasChildren) || other.hasChildren == hasChildren)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.gettingToKnow, gettingToKnow) || other.gettingToKnow == gettingToKnow)&&(identical(other.marriageTimeline, marriageTimeline) || other.marriageTimeline == marriageTimeline)&&(identical(other.relocateAbroad, relocateAbroad) || other.relocateAbroad == relocateAbroad)&&(identical(other.bornMuslim, bornMuslim) || other.bornMuslim == bornMuslim)&&(identical(other.religiousPractice, religiousPractice) || other.religiousPractice == religiousPractice)&&const DeepCollectionEquality().equals(other._faith, _faith)&&(identical(other.halalFood, halalFood) || other.halalFood == halalFood)&&(identical(other.alcohol, alcohol) || other.alcohol == alcohol)&&(identical(other.smoking, smoking) || other.smoking == smoking)&&const DeepCollectionEquality().equals(other._interests, _interests)&&const DeepCollectionEquality().equals(other._personality, _personality)&&(identical(other.education, education) || other.education == education)&&(identical(other.profession, profession) || other.profession == profession)&&const DeepCollectionEquality().equals(other._ethnicity, _ethnicity)&&const DeepCollectionEquality().equals(other._nationality, _nationality)&&const DeepCollectionEquality().equals(other._languages, _languages));
}


@override
int get hashCode => Object.hashAll([runtimeType,fullName,const DeepCollectionEquality().hash(_photos),isVerified,completeness,email,phone,dateOfBirth,gender,currentLocation,grewUpIn,heightCm,maritalStatus,hasChildren,bio,gettingToKnow,marriageTimeline,relocateAbroad,bornMuslim,religiousPractice,const DeepCollectionEquality().hash(_faith),halalFood,alcohol,smoking,const DeepCollectionEquality().hash(_interests),const DeepCollectionEquality().hash(_personality),education,profession,const DeepCollectionEquality().hash(_ethnicity),const DeepCollectionEquality().hash(_nationality),const DeepCollectionEquality().hash(_languages)]);

@override
String toString() {
  return 'MyProfile(fullName: $fullName, photos: $photos, isVerified: $isVerified, completeness: $completeness, email: $email, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender, currentLocation: $currentLocation, grewUpIn: $grewUpIn, heightCm: $heightCm, maritalStatus: $maritalStatus, hasChildren: $hasChildren, bio: $bio, gettingToKnow: $gettingToKnow, marriageTimeline: $marriageTimeline, relocateAbroad: $relocateAbroad, bornMuslim: $bornMuslim, religiousPractice: $religiousPractice, faith: $faith, halalFood: $halalFood, alcohol: $alcohol, smoking: $smoking, interests: $interests, personality: $personality, education: $education, profession: $profession, ethnicity: $ethnicity, nationality: $nationality, languages: $languages)';
}


}

/// @nodoc
abstract mixin class _$MyProfileCopyWith<$Res> implements $MyProfileCopyWith<$Res> {
  factory _$MyProfileCopyWith(_MyProfile value, $Res Function(_MyProfile) _then) = __$MyProfileCopyWithImpl;
@override @useResult
$Res call({
 String fullName, List<String> photos, bool isVerified, int completeness, String? email, String? phone, DateTime? dateOfBirth, String? gender, String? currentLocation, String? grewUpIn, int? heightCm, String? maritalStatus, bool? hasChildren, String? bio, String? gettingToKnow, String? marriageTimeline, bool? relocateAbroad, bool? bornMuslim, String? religiousPractice, List<String> faith, bool? halalFood, bool? alcohol, bool? smoking, List<String> interests, List<String> personality, String? education, String? profession, List<String> ethnicity, List<String> nationality, List<String> languages
});




}
/// @nodoc
class __$MyProfileCopyWithImpl<$Res>
    implements _$MyProfileCopyWith<$Res> {
  __$MyProfileCopyWithImpl(this._self, this._then);

  final _MyProfile _self;
  final $Res Function(_MyProfile) _then;

/// Create a copy of MyProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? photos = null,Object? isVerified = null,Object? completeness = null,Object? email = freezed,Object? phone = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? currentLocation = freezed,Object? grewUpIn = freezed,Object? heightCm = freezed,Object? maritalStatus = freezed,Object? hasChildren = freezed,Object? bio = freezed,Object? gettingToKnow = freezed,Object? marriageTimeline = freezed,Object? relocateAbroad = freezed,Object? bornMuslim = freezed,Object? religiousPractice = freezed,Object? faith = null,Object? halalFood = freezed,Object? alcohol = freezed,Object? smoking = freezed,Object? interests = null,Object? personality = null,Object? education = freezed,Object? profession = freezed,Object? ethnicity = null,Object? nationality = null,Object? languages = null,}) {
  return _then(_MyProfile(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<String>,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,completeness: null == completeness ? _self.completeness : completeness // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,currentLocation: freezed == currentLocation ? _self.currentLocation : currentLocation // ignore: cast_nullable_to_non_nullable
as String?,grewUpIn: freezed == grewUpIn ? _self.grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as String?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,hasChildren: freezed == hasChildren ? _self.hasChildren : hasChildren // ignore: cast_nullable_to_non_nullable
as bool?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,gettingToKnow: freezed == gettingToKnow ? _self.gettingToKnow : gettingToKnow // ignore: cast_nullable_to_non_nullable
as String?,marriageTimeline: freezed == marriageTimeline ? _self.marriageTimeline : marriageTimeline // ignore: cast_nullable_to_non_nullable
as String?,relocateAbroad: freezed == relocateAbroad ? _self.relocateAbroad : relocateAbroad // ignore: cast_nullable_to_non_nullable
as bool?,bornMuslim: freezed == bornMuslim ? _self.bornMuslim : bornMuslim // ignore: cast_nullable_to_non_nullable
as bool?,religiousPractice: freezed == religiousPractice ? _self.religiousPractice : religiousPractice // ignore: cast_nullable_to_non_nullable
as String?,faith: null == faith ? _self._faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,halalFood: freezed == halalFood ? _self.halalFood : halalFood // ignore: cast_nullable_to_non_nullable
as bool?,alcohol: freezed == alcohol ? _self.alcohol : alcohol // ignore: cast_nullable_to_non_nullable
as bool?,smoking: freezed == smoking ? _self.smoking : smoking // ignore: cast_nullable_to_non_nullable
as bool?,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,personality: null == personality ? _self._personality : personality // ignore: cast_nullable_to_non_nullable
as List<String>,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,ethnicity: null == ethnicity ? _self._ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as List<String>,nationality: null == nationality ? _self._nationality : nationality // ignore: cast_nullable_to_non_nullable
as List<String>,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
