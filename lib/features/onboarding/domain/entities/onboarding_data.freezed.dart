// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingData {

 String? get accountType;/// Set only on the family flow: `son`/`daughter`/`brother`/`sister`/
/// `other_family_member` — who the profile is being created for.
 String? get relationship; String? get fullName; DateTime? get dateOfBirth; String? get gender; String? get religion; List<String> get languages; String? get lookingForIntent; String? get howHeard; List<String> get nationalities; String? get grewUpCountry; List<String> get ethnicities; int? get heightCm; String? get educationLevel; String? get profession; String? get maritalStatus; String? get knowSomeoneDuration; String? get marriedWithinDuration; List<String> get faithTags; String? get religionPracticeLevel; bool? get eatsHalalOnly; bool? get smokes; bool? get drinksAlcohol; bool? get bornMuslim; bool? get hasChildren; bool? get wouldRelocate; List<String> get personalityTraits; List<String> get interests; String? get bio;/// Local file paths; the first is the main photo used by face
/// verification.
 List<String> get photoPaths;
/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDataCopyWith<OnboardingData> get copyWith => _$OnboardingDataCopyWithImpl<OnboardingData>(this as OnboardingData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingData&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.religion, religion) || other.religion == religion)&&const DeepCollectionEquality().equals(other.languages, languages)&&(identical(other.lookingForIntent, lookingForIntent) || other.lookingForIntent == lookingForIntent)&&(identical(other.howHeard, howHeard) || other.howHeard == howHeard)&&const DeepCollectionEquality().equals(other.nationalities, nationalities)&&(identical(other.grewUpCountry, grewUpCountry) || other.grewUpCountry == grewUpCountry)&&const DeepCollectionEquality().equals(other.ethnicities, ethnicities)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.knowSomeoneDuration, knowSomeoneDuration) || other.knowSomeoneDuration == knowSomeoneDuration)&&(identical(other.marriedWithinDuration, marriedWithinDuration) || other.marriedWithinDuration == marriedWithinDuration)&&const DeepCollectionEquality().equals(other.faithTags, faithTags)&&(identical(other.religionPracticeLevel, religionPracticeLevel) || other.religionPracticeLevel == religionPracticeLevel)&&(identical(other.eatsHalalOnly, eatsHalalOnly) || other.eatsHalalOnly == eatsHalalOnly)&&(identical(other.smokes, smokes) || other.smokes == smokes)&&(identical(other.drinksAlcohol, drinksAlcohol) || other.drinksAlcohol == drinksAlcohol)&&(identical(other.bornMuslim, bornMuslim) || other.bornMuslim == bornMuslim)&&(identical(other.hasChildren, hasChildren) || other.hasChildren == hasChildren)&&(identical(other.wouldRelocate, wouldRelocate) || other.wouldRelocate == wouldRelocate)&&const DeepCollectionEquality().equals(other.personalityTraits, personalityTraits)&&const DeepCollectionEquality().equals(other.interests, interests)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other.photoPaths, photoPaths));
}


@override
int get hashCode => Object.hashAll([runtimeType,accountType,relationship,fullName,dateOfBirth,gender,religion,const DeepCollectionEquality().hash(languages),lookingForIntent,howHeard,const DeepCollectionEquality().hash(nationalities),grewUpCountry,const DeepCollectionEquality().hash(ethnicities),heightCm,educationLevel,profession,maritalStatus,knowSomeoneDuration,marriedWithinDuration,const DeepCollectionEquality().hash(faithTags),religionPracticeLevel,eatsHalalOnly,smokes,drinksAlcohol,bornMuslim,hasChildren,wouldRelocate,const DeepCollectionEquality().hash(personalityTraits),const DeepCollectionEquality().hash(interests),bio,const DeepCollectionEquality().hash(photoPaths)]);

@override
String toString() {
  return 'OnboardingData(accountType: $accountType, relationship: $relationship, fullName: $fullName, dateOfBirth: $dateOfBirth, gender: $gender, religion: $religion, languages: $languages, lookingForIntent: $lookingForIntent, howHeard: $howHeard, nationalities: $nationalities, grewUpCountry: $grewUpCountry, ethnicities: $ethnicities, heightCm: $heightCm, educationLevel: $educationLevel, profession: $profession, maritalStatus: $maritalStatus, knowSomeoneDuration: $knowSomeoneDuration, marriedWithinDuration: $marriedWithinDuration, faithTags: $faithTags, religionPracticeLevel: $religionPracticeLevel, eatsHalalOnly: $eatsHalalOnly, smokes: $smokes, drinksAlcohol: $drinksAlcohol, bornMuslim: $bornMuslim, hasChildren: $hasChildren, wouldRelocate: $wouldRelocate, personalityTraits: $personalityTraits, interests: $interests, bio: $bio, photoPaths: $photoPaths)';
}


}

/// @nodoc
abstract mixin class $OnboardingDataCopyWith<$Res>  {
  factory $OnboardingDataCopyWith(OnboardingData value, $Res Function(OnboardingData) _then) = _$OnboardingDataCopyWithImpl;
@useResult
$Res call({
 String? accountType, String? relationship, String? fullName, DateTime? dateOfBirth, String? gender, String? religion, List<String> languages, String? lookingForIntent, String? howHeard, List<String> nationalities, String? grewUpCountry, List<String> ethnicities, int? heightCm, String? educationLevel, String? profession, String? maritalStatus, String? knowSomeoneDuration, String? marriedWithinDuration, List<String> faithTags, String? religionPracticeLevel, bool? eatsHalalOnly, bool? smokes, bool? drinksAlcohol, bool? bornMuslim, bool? hasChildren, bool? wouldRelocate, List<String> personalityTraits, List<String> interests, String? bio, List<String> photoPaths
});




}
/// @nodoc
class _$OnboardingDataCopyWithImpl<$Res>
    implements $OnboardingDataCopyWith<$Res> {
  _$OnboardingDataCopyWithImpl(this._self, this._then);

  final OnboardingData _self;
  final $Res Function(OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountType = freezed,Object? relationship = freezed,Object? fullName = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? religion = freezed,Object? languages = null,Object? lookingForIntent = freezed,Object? howHeard = freezed,Object? nationalities = null,Object? grewUpCountry = freezed,Object? ethnicities = null,Object? heightCm = freezed,Object? educationLevel = freezed,Object? profession = freezed,Object? maritalStatus = freezed,Object? knowSomeoneDuration = freezed,Object? marriedWithinDuration = freezed,Object? faithTags = null,Object? religionPracticeLevel = freezed,Object? eatsHalalOnly = freezed,Object? smokes = freezed,Object? drinksAlcohol = freezed,Object? bornMuslim = freezed,Object? hasChildren = freezed,Object? wouldRelocate = freezed,Object? personalityTraits = null,Object? interests = null,Object? bio = freezed,Object? photoPaths = null,}) {
  return _then(_self.copyWith(
accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String?,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,religion: freezed == religion ? _self.religion : religion // ignore: cast_nullable_to_non_nullable
as String?,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,lookingForIntent: freezed == lookingForIntent ? _self.lookingForIntent : lookingForIntent // ignore: cast_nullable_to_non_nullable
as String?,howHeard: freezed == howHeard ? _self.howHeard : howHeard // ignore: cast_nullable_to_non_nullable
as String?,nationalities: null == nationalities ? _self.nationalities : nationalities // ignore: cast_nullable_to_non_nullable
as List<String>,grewUpCountry: freezed == grewUpCountry ? _self.grewUpCountry : grewUpCountry // ignore: cast_nullable_to_non_nullable
as String?,ethnicities: null == ethnicities ? _self.ethnicities : ethnicities // ignore: cast_nullable_to_non_nullable
as List<String>,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,knowSomeoneDuration: freezed == knowSomeoneDuration ? _self.knowSomeoneDuration : knowSomeoneDuration // ignore: cast_nullable_to_non_nullable
as String?,marriedWithinDuration: freezed == marriedWithinDuration ? _self.marriedWithinDuration : marriedWithinDuration // ignore: cast_nullable_to_non_nullable
as String?,faithTags: null == faithTags ? _self.faithTags : faithTags // ignore: cast_nullable_to_non_nullable
as List<String>,religionPracticeLevel: freezed == religionPracticeLevel ? _self.religionPracticeLevel : religionPracticeLevel // ignore: cast_nullable_to_non_nullable
as String?,eatsHalalOnly: freezed == eatsHalalOnly ? _self.eatsHalalOnly : eatsHalalOnly // ignore: cast_nullable_to_non_nullable
as bool?,smokes: freezed == smokes ? _self.smokes : smokes // ignore: cast_nullable_to_non_nullable
as bool?,drinksAlcohol: freezed == drinksAlcohol ? _self.drinksAlcohol : drinksAlcohol // ignore: cast_nullable_to_non_nullable
as bool?,bornMuslim: freezed == bornMuslim ? _self.bornMuslim : bornMuslim // ignore: cast_nullable_to_non_nullable
as bool?,hasChildren: freezed == hasChildren ? _self.hasChildren : hasChildren // ignore: cast_nullable_to_non_nullable
as bool?,wouldRelocate: freezed == wouldRelocate ? _self.wouldRelocate : wouldRelocate // ignore: cast_nullable_to_non_nullable
as bool?,personalityTraits: null == personalityTraits ? _self.personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingData].
extension OnboardingDataPatterns on OnboardingData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingData value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingData value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? accountType,  String? relationship,  String? fullName,  DateTime? dateOfBirth,  String? gender,  String? religion,  List<String> languages,  String? lookingForIntent,  String? howHeard,  List<String> nationalities,  String? grewUpCountry,  List<String> ethnicities,  int? heightCm,  String? educationLevel,  String? profession,  String? maritalStatus,  String? knowSomeoneDuration,  String? marriedWithinDuration,  List<String> faithTags,  String? religionPracticeLevel,  bool? eatsHalalOnly,  bool? smokes,  bool? drinksAlcohol,  bool? bornMuslim,  bool? hasChildren,  bool? wouldRelocate,  List<String> personalityTraits,  List<String> interests,  String? bio,  List<String> photoPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.accountType,_that.relationship,_that.fullName,_that.dateOfBirth,_that.gender,_that.religion,_that.languages,_that.lookingForIntent,_that.howHeard,_that.nationalities,_that.grewUpCountry,_that.ethnicities,_that.heightCm,_that.educationLevel,_that.profession,_that.maritalStatus,_that.knowSomeoneDuration,_that.marriedWithinDuration,_that.faithTags,_that.religionPracticeLevel,_that.eatsHalalOnly,_that.smokes,_that.drinksAlcohol,_that.bornMuslim,_that.hasChildren,_that.wouldRelocate,_that.personalityTraits,_that.interests,_that.bio,_that.photoPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? accountType,  String? relationship,  String? fullName,  DateTime? dateOfBirth,  String? gender,  String? religion,  List<String> languages,  String? lookingForIntent,  String? howHeard,  List<String> nationalities,  String? grewUpCountry,  List<String> ethnicities,  int? heightCm,  String? educationLevel,  String? profession,  String? maritalStatus,  String? knowSomeoneDuration,  String? marriedWithinDuration,  List<String> faithTags,  String? religionPracticeLevel,  bool? eatsHalalOnly,  bool? smokes,  bool? drinksAlcohol,  bool? bornMuslim,  bool? hasChildren,  bool? wouldRelocate,  List<String> personalityTraits,  List<String> interests,  String? bio,  List<String> photoPaths)  $default,) {final _that = this;
switch (_that) {
case _OnboardingData():
return $default(_that.accountType,_that.relationship,_that.fullName,_that.dateOfBirth,_that.gender,_that.religion,_that.languages,_that.lookingForIntent,_that.howHeard,_that.nationalities,_that.grewUpCountry,_that.ethnicities,_that.heightCm,_that.educationLevel,_that.profession,_that.maritalStatus,_that.knowSomeoneDuration,_that.marriedWithinDuration,_that.faithTags,_that.religionPracticeLevel,_that.eatsHalalOnly,_that.smokes,_that.drinksAlcohol,_that.bornMuslim,_that.hasChildren,_that.wouldRelocate,_that.personalityTraits,_that.interests,_that.bio,_that.photoPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? accountType,  String? relationship,  String? fullName,  DateTime? dateOfBirth,  String? gender,  String? religion,  List<String> languages,  String? lookingForIntent,  String? howHeard,  List<String> nationalities,  String? grewUpCountry,  List<String> ethnicities,  int? heightCm,  String? educationLevel,  String? profession,  String? maritalStatus,  String? knowSomeoneDuration,  String? marriedWithinDuration,  List<String> faithTags,  String? religionPracticeLevel,  bool? eatsHalalOnly,  bool? smokes,  bool? drinksAlcohol,  bool? bornMuslim,  bool? hasChildren,  bool? wouldRelocate,  List<String> personalityTraits,  List<String> interests,  String? bio,  List<String> photoPaths)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingData() when $default != null:
return $default(_that.accountType,_that.relationship,_that.fullName,_that.dateOfBirth,_that.gender,_that.religion,_that.languages,_that.lookingForIntent,_that.howHeard,_that.nationalities,_that.grewUpCountry,_that.ethnicities,_that.heightCm,_that.educationLevel,_that.profession,_that.maritalStatus,_that.knowSomeoneDuration,_that.marriedWithinDuration,_that.faithTags,_that.religionPracticeLevel,_that.eatsHalalOnly,_that.smokes,_that.drinksAlcohol,_that.bornMuslim,_that.hasChildren,_that.wouldRelocate,_that.personalityTraits,_that.interests,_that.bio,_that.photoPaths);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingData extends OnboardingData {
  const _OnboardingData({this.accountType, this.relationship, this.fullName, this.dateOfBirth, this.gender, this.religion, final  List<String> languages = const <String>[], this.lookingForIntent, this.howHeard, final  List<String> nationalities = const <String>[], this.grewUpCountry, final  List<String> ethnicities = const <String>[], this.heightCm, this.educationLevel, this.profession, this.maritalStatus, this.knowSomeoneDuration, this.marriedWithinDuration, final  List<String> faithTags = const <String>[], this.religionPracticeLevel, this.eatsHalalOnly, this.smokes, this.drinksAlcohol, this.bornMuslim, this.hasChildren, this.wouldRelocate, final  List<String> personalityTraits = const <String>[], final  List<String> interests = const <String>[], this.bio, final  List<String> photoPaths = const <String>[]}): _languages = languages,_nationalities = nationalities,_ethnicities = ethnicities,_faithTags = faithTags,_personalityTraits = personalityTraits,_interests = interests,_photoPaths = photoPaths,super._();
  

@override final  String? accountType;
/// Set only on the family flow: `son`/`daughter`/`brother`/`sister`/
/// `other_family_member` — who the profile is being created for.
@override final  String? relationship;
@override final  String? fullName;
@override final  DateTime? dateOfBirth;
@override final  String? gender;
@override final  String? religion;
 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

@override final  String? lookingForIntent;
@override final  String? howHeard;
 final  List<String> _nationalities;
@override@JsonKey() List<String> get nationalities {
  if (_nationalities is EqualUnmodifiableListView) return _nationalities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nationalities);
}

@override final  String? grewUpCountry;
 final  List<String> _ethnicities;
@override@JsonKey() List<String> get ethnicities {
  if (_ethnicities is EqualUnmodifiableListView) return _ethnicities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ethnicities);
}

@override final  int? heightCm;
@override final  String? educationLevel;
@override final  String? profession;
@override final  String? maritalStatus;
@override final  String? knowSomeoneDuration;
@override final  String? marriedWithinDuration;
 final  List<String> _faithTags;
@override@JsonKey() List<String> get faithTags {
  if (_faithTags is EqualUnmodifiableListView) return _faithTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_faithTags);
}

@override final  String? religionPracticeLevel;
@override final  bool? eatsHalalOnly;
@override final  bool? smokes;
@override final  bool? drinksAlcohol;
@override final  bool? bornMuslim;
@override final  bool? hasChildren;
@override final  bool? wouldRelocate;
 final  List<String> _personalityTraits;
@override@JsonKey() List<String> get personalityTraits {
  if (_personalityTraits is EqualUnmodifiableListView) return _personalityTraits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_personalityTraits);
}

 final  List<String> _interests;
@override@JsonKey() List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

@override final  String? bio;
/// Local file paths; the first is the main photo used by face
/// verification.
 final  List<String> _photoPaths;
/// Local file paths; the first is the main photo used by face
/// verification.
@override@JsonKey() List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}


/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDataCopyWith<_OnboardingData> get copyWith => __$OnboardingDataCopyWithImpl<_OnboardingData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingData&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.religion, religion) || other.religion == religion)&&const DeepCollectionEquality().equals(other._languages, _languages)&&(identical(other.lookingForIntent, lookingForIntent) || other.lookingForIntent == lookingForIntent)&&(identical(other.howHeard, howHeard) || other.howHeard == howHeard)&&const DeepCollectionEquality().equals(other._nationalities, _nationalities)&&(identical(other.grewUpCountry, grewUpCountry) || other.grewUpCountry == grewUpCountry)&&const DeepCollectionEquality().equals(other._ethnicities, _ethnicities)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.maritalStatus, maritalStatus) || other.maritalStatus == maritalStatus)&&(identical(other.knowSomeoneDuration, knowSomeoneDuration) || other.knowSomeoneDuration == knowSomeoneDuration)&&(identical(other.marriedWithinDuration, marriedWithinDuration) || other.marriedWithinDuration == marriedWithinDuration)&&const DeepCollectionEquality().equals(other._faithTags, _faithTags)&&(identical(other.religionPracticeLevel, religionPracticeLevel) || other.religionPracticeLevel == religionPracticeLevel)&&(identical(other.eatsHalalOnly, eatsHalalOnly) || other.eatsHalalOnly == eatsHalalOnly)&&(identical(other.smokes, smokes) || other.smokes == smokes)&&(identical(other.drinksAlcohol, drinksAlcohol) || other.drinksAlcohol == drinksAlcohol)&&(identical(other.bornMuslim, bornMuslim) || other.bornMuslim == bornMuslim)&&(identical(other.hasChildren, hasChildren) || other.hasChildren == hasChildren)&&(identical(other.wouldRelocate, wouldRelocate) || other.wouldRelocate == wouldRelocate)&&const DeepCollectionEquality().equals(other._personalityTraits, _personalityTraits)&&const DeepCollectionEquality().equals(other._interests, _interests)&&(identical(other.bio, bio) || other.bio == bio)&&const DeepCollectionEquality().equals(other._photoPaths, _photoPaths));
}


@override
int get hashCode => Object.hashAll([runtimeType,accountType,relationship,fullName,dateOfBirth,gender,religion,const DeepCollectionEquality().hash(_languages),lookingForIntent,howHeard,const DeepCollectionEquality().hash(_nationalities),grewUpCountry,const DeepCollectionEquality().hash(_ethnicities),heightCm,educationLevel,profession,maritalStatus,knowSomeoneDuration,marriedWithinDuration,const DeepCollectionEquality().hash(_faithTags),religionPracticeLevel,eatsHalalOnly,smokes,drinksAlcohol,bornMuslim,hasChildren,wouldRelocate,const DeepCollectionEquality().hash(_personalityTraits),const DeepCollectionEquality().hash(_interests),bio,const DeepCollectionEquality().hash(_photoPaths)]);

@override
String toString() {
  return 'OnboardingData(accountType: $accountType, relationship: $relationship, fullName: $fullName, dateOfBirth: $dateOfBirth, gender: $gender, religion: $religion, languages: $languages, lookingForIntent: $lookingForIntent, howHeard: $howHeard, nationalities: $nationalities, grewUpCountry: $grewUpCountry, ethnicities: $ethnicities, heightCm: $heightCm, educationLevel: $educationLevel, profession: $profession, maritalStatus: $maritalStatus, knowSomeoneDuration: $knowSomeoneDuration, marriedWithinDuration: $marriedWithinDuration, faithTags: $faithTags, religionPracticeLevel: $religionPracticeLevel, eatsHalalOnly: $eatsHalalOnly, smokes: $smokes, drinksAlcohol: $drinksAlcohol, bornMuslim: $bornMuslim, hasChildren: $hasChildren, wouldRelocate: $wouldRelocate, personalityTraits: $personalityTraits, interests: $interests, bio: $bio, photoPaths: $photoPaths)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDataCopyWith<$Res> implements $OnboardingDataCopyWith<$Res> {
  factory _$OnboardingDataCopyWith(_OnboardingData value, $Res Function(_OnboardingData) _then) = __$OnboardingDataCopyWithImpl;
@override @useResult
$Res call({
 String? accountType, String? relationship, String? fullName, DateTime? dateOfBirth, String? gender, String? religion, List<String> languages, String? lookingForIntent, String? howHeard, List<String> nationalities, String? grewUpCountry, List<String> ethnicities, int? heightCm, String? educationLevel, String? profession, String? maritalStatus, String? knowSomeoneDuration, String? marriedWithinDuration, List<String> faithTags, String? religionPracticeLevel, bool? eatsHalalOnly, bool? smokes, bool? drinksAlcohol, bool? bornMuslim, bool? hasChildren, bool? wouldRelocate, List<String> personalityTraits, List<String> interests, String? bio, List<String> photoPaths
});




}
/// @nodoc
class __$OnboardingDataCopyWithImpl<$Res>
    implements _$OnboardingDataCopyWith<$Res> {
  __$OnboardingDataCopyWithImpl(this._self, this._then);

  final _OnboardingData _self;
  final $Res Function(_OnboardingData) _then;

/// Create a copy of OnboardingData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountType = freezed,Object? relationship = freezed,Object? fullName = freezed,Object? dateOfBirth = freezed,Object? gender = freezed,Object? religion = freezed,Object? languages = null,Object? lookingForIntent = freezed,Object? howHeard = freezed,Object? nationalities = null,Object? grewUpCountry = freezed,Object? ethnicities = null,Object? heightCm = freezed,Object? educationLevel = freezed,Object? profession = freezed,Object? maritalStatus = freezed,Object? knowSomeoneDuration = freezed,Object? marriedWithinDuration = freezed,Object? faithTags = null,Object? religionPracticeLevel = freezed,Object? eatsHalalOnly = freezed,Object? smokes = freezed,Object? drinksAlcohol = freezed,Object? bornMuslim = freezed,Object? hasChildren = freezed,Object? wouldRelocate = freezed,Object? personalityTraits = null,Object? interests = null,Object? bio = freezed,Object? photoPaths = null,}) {
  return _then(_OnboardingData(
accountType: freezed == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String?,relationship: freezed == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String?,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,religion: freezed == religion ? _self.religion : religion // ignore: cast_nullable_to_non_nullable
as String?,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,lookingForIntent: freezed == lookingForIntent ? _self.lookingForIntent : lookingForIntent // ignore: cast_nullable_to_non_nullable
as String?,howHeard: freezed == howHeard ? _self.howHeard : howHeard // ignore: cast_nullable_to_non_nullable
as String?,nationalities: null == nationalities ? _self._nationalities : nationalities // ignore: cast_nullable_to_non_nullable
as List<String>,grewUpCountry: freezed == grewUpCountry ? _self.grewUpCountry : grewUpCountry // ignore: cast_nullable_to_non_nullable
as String?,ethnicities: null == ethnicities ? _self._ethnicities : ethnicities // ignore: cast_nullable_to_non_nullable
as List<String>,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as int?,educationLevel: freezed == educationLevel ? _self.educationLevel : educationLevel // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,maritalStatus: freezed == maritalStatus ? _self.maritalStatus : maritalStatus // ignore: cast_nullable_to_non_nullable
as String?,knowSomeoneDuration: freezed == knowSomeoneDuration ? _self.knowSomeoneDuration : knowSomeoneDuration // ignore: cast_nullable_to_non_nullable
as String?,marriedWithinDuration: freezed == marriedWithinDuration ? _self.marriedWithinDuration : marriedWithinDuration // ignore: cast_nullable_to_non_nullable
as String?,faithTags: null == faithTags ? _self._faithTags : faithTags // ignore: cast_nullable_to_non_nullable
as List<String>,religionPracticeLevel: freezed == religionPracticeLevel ? _self.religionPracticeLevel : religionPracticeLevel // ignore: cast_nullable_to_non_nullable
as String?,eatsHalalOnly: freezed == eatsHalalOnly ? _self.eatsHalalOnly : eatsHalalOnly // ignore: cast_nullable_to_non_nullable
as bool?,smokes: freezed == smokes ? _self.smokes : smokes // ignore: cast_nullable_to_non_nullable
as bool?,drinksAlcohol: freezed == drinksAlcohol ? _self.drinksAlcohol : drinksAlcohol // ignore: cast_nullable_to_non_nullable
as bool?,bornMuslim: freezed == bornMuslim ? _self.bornMuslim : bornMuslim // ignore: cast_nullable_to_non_nullable
as bool?,hasChildren: freezed == hasChildren ? _self.hasChildren : hasChildren // ignore: cast_nullable_to_non_nullable
as bool?,wouldRelocate: freezed == wouldRelocate ? _self.wouldRelocate : wouldRelocate // ignore: cast_nullable_to_non_nullable
as bool?,personalityTraits: null == personalityTraits ? _self._personalityTraits : personalityTraits // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
