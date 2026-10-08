// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marriage_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MarriageProfile {

 String get id; String get name; int get age; double get distanceKm; String get area; String get country; String get countryFlag; String get profession; String get practice; String get ethnicity; String get ethnicityFlag;/// First is the main (hero) photo; the next four sit between the detail
/// sections (after About me, My faith, Future plans and Personality).
 List<String> get photoUrls;// About me
 int get heightCm; String get maritalStatus; String get children;// Marriage intentions timeline: when they want to involve family, how
// long they'd chat, and how soon they'd marry.
 String get involveFamily; String get chatFor; String get marryWithin; String get education; String get grewUpIn; String get grewUpFlag;/// Free text. Blank lines separate paragraphs; lines starting with "• "
/// render as a bulleted list.
 String get bio; bool get isVerified; bool get isActiveToday;/// Crown badge on the photo + the "Curious about X's filters?" teaser.
 bool get isPremium;/// Background details shared with the signed-in user ("Similarities").
 List<String> get similarities; List<String> get faith; List<String> get futurePlans; List<String> get interests; List<String> get personality; List<String> get languages;// "Verified profile" card.
 bool get isPhotoVerified; bool get isAgeVerified; bool get isIdVerified;
/// Create a copy of MarriageProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MarriageProfileCopyWith<MarriageProfile> get copyWith => _$MarriageProfileCopyWithImpl<MarriageProfile>(this as MarriageProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MarriageProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.area, area) || other.area == area)&&(identical(other.country, country) || other.country == country)&&(identical(other.countryFlag, countryFlag) || other.countryFlag == countryFlag)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.practice, practice) || other.practice == practice)&&(identical(other.ethnicity, ethnicity) || other.ethnicity == ethnicity)&&(identical(other.ethnicityFlag, ethnicityFlag) || other.ethnicityFlag == ethnicityFlag)&&const DeepCollectionEquality().equals(other.photoUrls, photoUrls)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.children, children) || other.children == children)&&(identical(other.involveFamily, involveFamily) || other.involveFamily == involveFamily)&&(identical(other.chatFor, chatFor) || other.chatFor == chatFor)&&(identical(other.marryWithin, marryWithin) || other.marryWithin == marryWithin)&&(identical(other.education, education) || other.education == education)&&(identical(other.grewUpIn, grewUpIn) || other.grewUpIn == grewUpIn)&&(identical(other.grewUpFlag, grewUpFlag) || other.grewUpFlag == grewUpFlag)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isActiveToday, isActiveToday) || other.isActiveToday == isActiveToday)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&const DeepCollectionEquality().equals(other.similarities, similarities)&&const DeepCollectionEquality().equals(other.faith, faith)&&const DeepCollectionEquality().equals(other.futurePlans, futurePlans)&&const DeepCollectionEquality().equals(other.interests, interests)&&const DeepCollectionEquality().equals(other.personality, personality)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.isPhotoVerified, isPhotoVerified) || other.isPhotoVerified == isPhotoVerified)&&(identical(other.isAgeVerified, isAgeVerified) || other.isAgeVerified == isAgeVerified)&&(identical(other.isIdVerified, isIdVerified) || other.isIdVerified == isIdVerified));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,age,distanceKm,area,country,countryFlag,profession,practice,ethnicity,ethnicityFlag,const DeepCollectionEquality().hash(photoUrls),heightCm,maritalStatus,children,involveFamily,chatFor,marryWithin,education,grewUpIn,grewUpFlag,bio,isVerified,isActiveToday,isPremium,const DeepCollectionEquality().hash(similarities),const DeepCollectionEquality().hash(faith),const DeepCollectionEquality().hash(futurePlans),const DeepCollectionEquality().hash(interests),const DeepCollectionEquality().hash(personality),const DeepCollectionEquality().hash(languages),isPhotoVerified,isAgeVerified,isIdVerified]);

@override
String toString() {
  return 'MarriageProfile(id: $id, name: $name, age: $age, distanceKm: $distanceKm, area: $area, country: $country, countryFlag: $countryFlag, profession: $profession, practice: $practice, ethnicity: $ethnicity, ethnicityFlag: $ethnicityFlag, photoUrls: $photoUrls, heightCm: $heightCm, maritalStatus: $maritalStatus, children: $children, involveFamily: $involveFamily, chatFor: $chatFor, marryWithin: $marryWithin, education: $education, grewUpIn: $grewUpIn, grewUpFlag: $grewUpFlag, bio: $bio, isVerified: $isVerified, isActiveToday: $isActiveToday, isPremium: $isPremium, similarities: $similarities, faith: $faith, futurePlans: $futurePlans, interests: $interests, personality: $personality, languages: $languages, isPhotoVerified: $isPhotoVerified, isAgeVerified: $isAgeVerified, isIdVerified: $isIdVerified)';
}


}

/// @nodoc
abstract mixin class $MarriageProfileCopyWith<$Res>  {
  factory $MarriageProfileCopyWith(MarriageProfile value, $Res Function(MarriageProfile) _then) = _$MarriageProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, int age, double distanceKm, String area, String country, String countryFlag, String profession, String practice, String ethnicity, String ethnicityFlag, List<String> photoUrls, int heightCm, String maritalStatus, String children, String involveFamily, String chatFor, String marryWithin, String education, String grewUpIn, String grewUpFlag, String bio, bool isVerified, bool isActiveToday, bool isPremium, List<String> similarities, List<String> faith, List<String> futurePlans, List<String> interests, List<String> personality, List<String> languages, bool isPhotoVerified, bool isAgeVerified, bool isIdVerified
});




}
/// @nodoc
class _$MarriageProfileCopyWithImpl<$Res>
    implements $MarriageProfileCopyWith<$Res> {
  _$MarriageProfileCopyWithImpl(this._self, this._then);

  final MarriageProfile _self;
  final $Res Function(MarriageProfile) _then;

/// Create a copy of MarriageProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? age = null,Object? distanceKm = null,Object? area = null,Object? country = null,Object? countryFlag = null,Object? profession = null,Object? practice = null,Object? ethnicity = null,Object? ethnicityFlag = null,Object? photoUrls = null,Object? heightCm = null,Object? maritalStatus = null,Object? children = null,Object? involveFamily = null,Object? chatFor = null,Object? marryWithin = null,Object? education = null,Object? grewUpIn = null,Object? grewUpFlag = null,Object? bio = null,Object? isVerified = null,Object? isActiveToday = null,Object? isPremium = null,Object? similarities = null,Object? faith = null,Object? futurePlans = null,Object? interests = null,Object? personality = null,Object? languages = null,Object? isPhotoVerified = null,Object? isAgeVerified = null,Object? isIdVerified = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,countryFlag: null == countryFlag ? _self.countryFlag : countryFlag // ignore: cast_nullable_to_non_nullable
as String,profession: null == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String,practice: null == practice ? _self.practice : practice // ignore: cast_nullable_to_non_nullable
as String,ethnicity: null == ethnicity ? _self.ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as String,ethnicityFlag: null == ethnicityFlag ? _self.ethnicityFlag : ethnicityFlag // ignore: cast_nullable_to_non_nullable
as String,photoUrls: null == photoUrls ? _self.photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int,maritalStatus: null == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as String,involveFamily: null == involveFamily ? _self.involveFamily : involveFamily // ignore: cast_nullable_to_non_nullable
as String,chatFor: null == chatFor ? _self.chatFor : chatFor // ignore: cast_nullable_to_non_nullable
as String,marryWithin: null == marryWithin ? _self.marryWithin : marryWithin // ignore: cast_nullable_to_non_nullable
as String,education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String,grewUpIn: null == grewUpIn ? _self.grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as String,grewUpFlag: null == grewUpFlag ? _self.grewUpFlag : grewUpFlag // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isActiveToday: null == isActiveToday ? _self.isActiveToday : isActiveToday // ignore: cast_nullable_to_non_nullable
as bool,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,similarities: null == similarities ? _self.similarities : similarities // ignore: cast_nullable_to_non_nullable
as List<String>,faith: null == faith ? _self.faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,futurePlans: null == futurePlans ? _self.futurePlans : futurePlans // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as List<String>,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,isPhotoVerified: null == isPhotoVerified ? _self.isPhotoVerified : isPhotoVerified // ignore: cast_nullable_to_non_nullable
as bool,isAgeVerified: null == isAgeVerified ? _self.isAgeVerified : isAgeVerified // ignore: cast_nullable_to_non_nullable
as bool,isIdVerified: null == isIdVerified ? _self.isIdVerified : isIdVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MarriageProfile].
extension MarriageProfilePatterns on MarriageProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MarriageProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MarriageProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MarriageProfile value)  $default,){
final _that = this;
switch (_that) {
case _MarriageProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MarriageProfile value)?  $default,){
final _that = this;
switch (_that) {
case _MarriageProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int age,  double distanceKm,  String area,  String country,  String countryFlag,  String profession,  String practice,  String ethnicity,  String ethnicityFlag,  List<String> photoUrls,  int heightCm,  String maritalStatus,  String children,  String involveFamily,  String chatFor,  String marryWithin,  String education,  String grewUpIn,  String grewUpFlag,  String bio,  bool isVerified,  bool isActiveToday,  bool isPremium,  List<String> similarities,  List<String> faith,  List<String> futurePlans,  List<String> interests,  List<String> personality,  List<String> languages,  bool isPhotoVerified,  bool isAgeVerified,  bool isIdVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MarriageProfile() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.distanceKm,_that.area,_that.country,_that.countryFlag,_that.profession,_that.practice,_that.ethnicity,_that.ethnicityFlag,_that.photoUrls,_that.heightCm,_that.maritalStatus,_that.children,_that.involveFamily,_that.chatFor,_that.marryWithin,_that.education,_that.grewUpIn,_that.grewUpFlag,_that.bio,_that.isVerified,_that.isActiveToday,_that.isPremium,_that.similarities,_that.faith,_that.futurePlans,_that.interests,_that.personality,_that.languages,_that.isPhotoVerified,_that.isAgeVerified,_that.isIdVerified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int age,  double distanceKm,  String area,  String country,  String countryFlag,  String profession,  String practice,  String ethnicity,  String ethnicityFlag,  List<String> photoUrls,  int heightCm,  String maritalStatus,  String children,  String involveFamily,  String chatFor,  String marryWithin,  String education,  String grewUpIn,  String grewUpFlag,  String bio,  bool isVerified,  bool isActiveToday,  bool isPremium,  List<String> similarities,  List<String> faith,  List<String> futurePlans,  List<String> interests,  List<String> personality,  List<String> languages,  bool isPhotoVerified,  bool isAgeVerified,  bool isIdVerified)  $default,) {final _that = this;
switch (_that) {
case _MarriageProfile():
return $default(_that.id,_that.name,_that.age,_that.distanceKm,_that.area,_that.country,_that.countryFlag,_that.profession,_that.practice,_that.ethnicity,_that.ethnicityFlag,_that.photoUrls,_that.heightCm,_that.maritalStatus,_that.children,_that.involveFamily,_that.chatFor,_that.marryWithin,_that.education,_that.grewUpIn,_that.grewUpFlag,_that.bio,_that.isVerified,_that.isActiveToday,_that.isPremium,_that.similarities,_that.faith,_that.futurePlans,_that.interests,_that.personality,_that.languages,_that.isPhotoVerified,_that.isAgeVerified,_that.isIdVerified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int age,  double distanceKm,  String area,  String country,  String countryFlag,  String profession,  String practice,  String ethnicity,  String ethnicityFlag,  List<String> photoUrls,  int heightCm,  String maritalStatus,  String children,  String involveFamily,  String chatFor,  String marryWithin,  String education,  String grewUpIn,  String grewUpFlag,  String bio,  bool isVerified,  bool isActiveToday,  bool isPremium,  List<String> similarities,  List<String> faith,  List<String> futurePlans,  List<String> interests,  List<String> personality,  List<String> languages,  bool isPhotoVerified,  bool isAgeVerified,  bool isIdVerified)?  $default,) {final _that = this;
switch (_that) {
case _MarriageProfile() when $default != null:
return $default(_that.id,_that.name,_that.age,_that.distanceKm,_that.area,_that.country,_that.countryFlag,_that.profession,_that.practice,_that.ethnicity,_that.ethnicityFlag,_that.photoUrls,_that.heightCm,_that.maritalStatus,_that.children,_that.involveFamily,_that.chatFor,_that.marryWithin,_that.education,_that.grewUpIn,_that.grewUpFlag,_that.bio,_that.isVerified,_that.isActiveToday,_that.isPremium,_that.similarities,_that.faith,_that.futurePlans,_that.interests,_that.personality,_that.languages,_that.isPhotoVerified,_that.isAgeVerified,_that.isIdVerified);case _:
  return null;

}
}

}

/// @nodoc


class _MarriageProfile implements MarriageProfile {
  const _MarriageProfile({required this.id, required this.name, required this.age, required this.distanceKm, required this.area, required this.country, required this.countryFlag, required this.profession, required this.practice, required this.ethnicity, required this.ethnicityFlag, required final  List<String> photoUrls, required this.heightCm, required this.maritalStatus, required this.children, required this.involveFamily, required this.chatFor, required this.marryWithin, required this.education, required this.grewUpIn, required this.grewUpFlag, required this.bio, this.isVerified = false, this.isActiveToday = false, this.isPremium = false, final  List<String> similarities = const [], final  List<String> faith = const [], final  List<String> futurePlans = const [], final  List<String> interests = const [], final  List<String> personality = const [], final  List<String> languages = const [], this.isPhotoVerified = false, this.isAgeVerified = false, this.isIdVerified = false}): _photoUrls = photoUrls,_similarities = similarities,_faith = faith,_futurePlans = futurePlans,_interests = interests,_personality = personality,_languages = languages;
  

@override final  String id;
@override final  String name;
@override final  int age;
@override final  double distanceKm;
@override final  String area;
@override final  String country;
@override final  String countryFlag;
@override final  String profession;
@override final  String practice;
@override final  String ethnicity;
@override final  String ethnicityFlag;
/// First is the main (hero) photo; the next four sit between the detail
/// sections (after About me, My faith, Future plans and Personality).
 final  List<String> _photoUrls;
/// First is the main (hero) photo; the next four sit between the detail
/// sections (after About me, My faith, Future plans and Personality).
@override List<String> get photoUrls {
  if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoUrls);
}

// About me
@override final  int heightCm;
@override final  String maritalStatus;
@override final  String children;
// Marriage intentions timeline: when they want to involve family, how
// long they'd chat, and how soon they'd marry.
@override final  String involveFamily;
@override final  String chatFor;
@override final  String marryWithin;
@override final  String education;
@override final  String grewUpIn;
@override final  String grewUpFlag;
/// Free text. Blank lines separate paragraphs; lines starting with "• "
/// render as a bulleted list.
@override final  String bio;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  bool isActiveToday;
/// Crown badge on the photo + the "Curious about X's filters?" teaser.
@override@JsonKey() final  bool isPremium;
/// Background details shared with the signed-in user ("Similarities").
 final  List<String> _similarities;
/// Background details shared with the signed-in user ("Similarities").
@override@JsonKey() List<String> get similarities {
  if (_similarities is EqualUnmodifiableListView) return _similarities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_similarities);
}

 final  List<String> _faith;
@override@JsonKey() List<String> get faith {
  if (_faith is EqualUnmodifiableListView) return _faith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faith);
}

 final  List<String> _futurePlans;
@override@JsonKey() List<String> get futurePlans {
  if (_futurePlans is EqualUnmodifiableListView) return _futurePlans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_futurePlans);
}

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

 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

// "Verified profile" card.
@override@JsonKey() final  bool isPhotoVerified;
@override@JsonKey() final  bool isAgeVerified;
@override@JsonKey() final  bool isIdVerified;

/// Create a copy of MarriageProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarriageProfileCopyWith<_MarriageProfile> get copyWith => __$MarriageProfileCopyWithImpl<_MarriageProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarriageProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.age, age) || other.age == age)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.area, area) || other.area == area)&&(identical(other.country, country) || other.country == country)&&(identical(other.countryFlag, countryFlag) || other.countryFlag == countryFlag)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.practice, practice) || other.practice == practice)&&(identical(other.ethnicity, ethnicity) || other.ethnicity == ethnicity)&&(identical(other.ethnicityFlag, ethnicityFlag) || other.ethnicityFlag == ethnicityFlag)&&const DeepCollectionEquality().equals(other._photoUrls, _photoUrls)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.children, children) || other.children == children)&&(identical(other.involveFamily, involveFamily) || other.involveFamily == involveFamily)&&(identical(other.chatFor, chatFor) || other.chatFor == chatFor)&&(identical(other.marryWithin, marryWithin) || other.marryWithin == marryWithin)&&(identical(other.education, education) || other.education == education)&&(identical(other.grewUpIn, grewUpIn) || other.grewUpIn == grewUpIn)&&(identical(other.grewUpFlag, grewUpFlag) || other.grewUpFlag == grewUpFlag)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isActiveToday, isActiveToday) || other.isActiveToday == isActiveToday)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&const DeepCollectionEquality().equals(other._similarities, _similarities)&&const DeepCollectionEquality().equals(other._faith, _faith)&&const DeepCollectionEquality().equals(other._futurePlans, _futurePlans)&&const DeepCollectionEquality().equals(other._interests, _interests)&&const DeepCollectionEquality().equals(other._personality, _personality)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.isPhotoVerified, isPhotoVerified) || other.isPhotoVerified == isPhotoVerified)&&(identical(other.isAgeVerified, isAgeVerified) || other.isAgeVerified == isAgeVerified)&&(identical(other.isIdVerified, isIdVerified) || other.isIdVerified == isIdVerified));
}


@override
int get hashCode => Object.hashAll([runtimeType,id,name,age,distanceKm,area,country,countryFlag,profession,practice,ethnicity,ethnicityFlag,const DeepCollectionEquality().hash(_photoUrls),heightCm,maritalStatus,children,involveFamily,chatFor,marryWithin,education,grewUpIn,grewUpFlag,bio,isVerified,isActiveToday,isPremium,const DeepCollectionEquality().hash(_similarities),const DeepCollectionEquality().hash(_faith),const DeepCollectionEquality().hash(_futurePlans),const DeepCollectionEquality().hash(_interests),const DeepCollectionEquality().hash(_personality),const DeepCollectionEquality().hash(_languages),isPhotoVerified,isAgeVerified,isIdVerified]);

@override
String toString() {
  return 'MarriageProfile(id: $id, name: $name, age: $age, distanceKm: $distanceKm, area: $area, country: $country, countryFlag: $countryFlag, profession: $profession, practice: $practice, ethnicity: $ethnicity, ethnicityFlag: $ethnicityFlag, photoUrls: $photoUrls, heightCm: $heightCm, maritalStatus: $maritalStatus, children: $children, involveFamily: $involveFamily, chatFor: $chatFor, marryWithin: $marryWithin, education: $education, grewUpIn: $grewUpIn, grewUpFlag: $grewUpFlag, bio: $bio, isVerified: $isVerified, isActiveToday: $isActiveToday, isPremium: $isPremium, similarities: $similarities, faith: $faith, futurePlans: $futurePlans, interests: $interests, personality: $personality, languages: $languages, isPhotoVerified: $isPhotoVerified, isAgeVerified: $isAgeVerified, isIdVerified: $isIdVerified)';
}


}

/// @nodoc
abstract mixin class _$MarriageProfileCopyWith<$Res> implements $MarriageProfileCopyWith<$Res> {
  factory _$MarriageProfileCopyWith(_MarriageProfile value, $Res Function(_MarriageProfile) _then) = __$MarriageProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int age, double distanceKm, String area, String country, String countryFlag, String profession, String practice, String ethnicity, String ethnicityFlag, List<String> photoUrls, int heightCm, String maritalStatus, String children, String involveFamily, String chatFor, String marryWithin, String education, String grewUpIn, String grewUpFlag, String bio, bool isVerified, bool isActiveToday, bool isPremium, List<String> similarities, List<String> faith, List<String> futurePlans, List<String> interests, List<String> personality, List<String> languages, bool isPhotoVerified, bool isAgeVerified, bool isIdVerified
});




}
/// @nodoc
class __$MarriageProfileCopyWithImpl<$Res>
    implements _$MarriageProfileCopyWith<$Res> {
  __$MarriageProfileCopyWithImpl(this._self, this._then);

  final _MarriageProfile _self;
  final $Res Function(_MarriageProfile) _then;

/// Create a copy of MarriageProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? age = null,Object? distanceKm = null,Object? area = null,Object? country = null,Object? countryFlag = null,Object? profession = null,Object? practice = null,Object? ethnicity = null,Object? ethnicityFlag = null,Object? photoUrls = null,Object? heightCm = null,Object? maritalStatus = null,Object? children = null,Object? involveFamily = null,Object? chatFor = null,Object? marryWithin = null,Object? education = null,Object? grewUpIn = null,Object? grewUpFlag = null,Object? bio = null,Object? isVerified = null,Object? isActiveToday = null,Object? isPremium = null,Object? similarities = null,Object? faith = null,Object? futurePlans = null,Object? interests = null,Object? personality = null,Object? languages = null,Object? isPhotoVerified = null,Object? isAgeVerified = null,Object? isIdVerified = null,}) {
  return _then(_MarriageProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,countryFlag: null == countryFlag ? _self.countryFlag : countryFlag // ignore: cast_nullable_to_non_nullable
as String,profession: null == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String,practice: null == practice ? _self.practice : practice // ignore: cast_nullable_to_non_nullable
as String,ethnicity: null == ethnicity ? _self.ethnicity : ethnicity // ignore: cast_nullable_to_non_nullable
as String,ethnicityFlag: null == ethnicityFlag ? _self.ethnicityFlag : ethnicityFlag // ignore: cast_nullable_to_non_nullable
as String,photoUrls: null == photoUrls ? _self._photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,heightCm: null == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int,maritalStatus: null == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as String,involveFamily: null == involveFamily ? _self.involveFamily : involveFamily // ignore: cast_nullable_to_non_nullable
as String,chatFor: null == chatFor ? _self.chatFor : chatFor // ignore: cast_nullable_to_non_nullable
as String,marryWithin: null == marryWithin ? _self.marryWithin : marryWithin // ignore: cast_nullable_to_non_nullable
as String,education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String,grewUpIn: null == grewUpIn ? _self.grewUpIn : grewUpIn // ignore: cast_nullable_to_non_nullable
as String,grewUpFlag: null == grewUpFlag ? _self.grewUpFlag : grewUpFlag // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isActiveToday: null == isActiveToday ? _self.isActiveToday : isActiveToday // ignore: cast_nullable_to_non_nullable
as bool,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,similarities: null == similarities ? _self._similarities : similarities // ignore: cast_nullable_to_non_nullable
as List<String>,faith: null == faith ? _self._faith : faith // ignore: cast_nullable_to_non_nullable
as List<String>,futurePlans: null == futurePlans ? _self._futurePlans : futurePlans // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,personality: null == personality ? _self._personality : personality // ignore: cast_nullable_to_non_nullable
as List<String>,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,isPhotoVerified: null == isPhotoVerified ? _self.isPhotoVerified : isPhotoVerified // ignore: cast_nullable_to_non_nullable
as bool,isAgeVerified: null == isAgeVerified ? _self.isAgeVerified : isAgeVerified // ignore: cast_nullable_to_non_nullable
as bool,isIdVerified: null == isIdVerified ? _self.isIdVerified : isIdVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
