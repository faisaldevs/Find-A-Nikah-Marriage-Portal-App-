import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// Everything the profile wizard collects (account type through bio) plus
/// the photos picked on "Add your photos". The phone number belongs to
/// account verification (`features/auth`), not to the profile draft.
class OnboardingData extends Equatable {
  const OnboardingData({
    this.accountType,
    this.relationship,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.languages = const <String>[],
    this.lookingForIntent,
    this.howHeard,
    this.nationalities = const <String>[],
    this.grewUpCountry,
    this.ethnicities = const <String>[],
    this.heightCm,
    this.educationLevel,
    this.profession,
    this.maritalStatus,
    this.knowSomeoneDuration,
    this.marriedWithinDuration,
    this.faithTags = const <String>[],
    this.religionPracticeLevel,
    this.eatsHalalOnly,
    this.smokes,
    this.drinksAlcohol,
    this.bornMuslim,
    this.hasChildren,
    this.wouldRelocate,
    this.personalityTraits = const <String>[],
    this.interests = const <String>[],
    this.bio,
    this.photoPaths = const <String>[],
  });

  final String? accountType;

  /// Set only on the family flow: `son`/`daughter`/`brother`/`sister`/
  /// `other_family_member` — who the profile is being created for.
  final String? relationship;

  final String? fullName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? religion;
  final List<String> languages;
  final String? lookingForIntent;
  final String? howHeard;
  final List<String> nationalities;
  final String? grewUpCountry;
  final List<String> ethnicities;
  final int? heightCm;
  final String? educationLevel;
  final String? profession;
  final String? maritalStatus;
  final String? knowSomeoneDuration;
  final String? marriedWithinDuration;
  final List<String> faithTags;
  final String? religionPracticeLevel;
  final bool? eatsHalalOnly;
  final bool? smokes;
  final bool? drinksAlcohol;
  final bool? bornMuslim;
  final bool? hasChildren;
  final bool? wouldRelocate;
  final List<String> personalityTraits;
  final List<String> interests;
  final String? bio;

  /// Local file paths; the first is the main photo used by face
  /// verification.
  final List<String> photoPaths;

  /// Profiles need at least this many photos to continue.
  static const minPhotos = 3;

  /// Photo slots on "Add your photos".
  static const maxPhotos = 5;

  int get remainingPhotoSlots => maxPhotos - photoPaths.length;

  bool get hasEnoughPhotos => photoPaths.length >= minPhotos;

  /// Appends [paths] up to [maxPhotos] (older Android galleries can ignore
  /// the picker's limit).
  OnboardingData withPhotosAdded(List<String> paths) => copyWith(
    photoPaths: [...photoPaths, ...paths.take(remainingPhotoSlots)],
  );

  /// Already on the server (prefilled as a URL), vs a just-picked local
  /// file.
  static bool isUploadedPhoto(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  OnboardingData withPhotoRemoved(int index) =>
      copyWith(photoPaths: [...photoPaths]..removeAt(index));

  /// The photo face verification compares the selfie against.
  String? get mainPhotoPath => photoPaths.isEmpty ? null : photoPaths.first;

  /// Whole years since [dateOfBirth], null until it's set.
  int? get age {
    final dob = dateOfBirth;
    if (dob == null) return null;
    final now = DateTime.now();
    var years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years;
  }

  static const minAge = 18;

  bool get isEligibleAge => (age ?? 0) >= minAge;

  OnboardingData copyWith({
    Object? accountType = unchanged,
    Object? relationship = unchanged,
    Object? fullName = unchanged,
    Object? dateOfBirth = unchanged,
    Object? gender = unchanged,
    Object? religion = unchanged,
    List<String>? languages,
    Object? lookingForIntent = unchanged,
    Object? howHeard = unchanged,
    List<String>? nationalities,
    Object? grewUpCountry = unchanged,
    List<String>? ethnicities,
    Object? heightCm = unchanged,
    Object? educationLevel = unchanged,
    Object? profession = unchanged,
    Object? maritalStatus = unchanged,
    Object? knowSomeoneDuration = unchanged,
    Object? marriedWithinDuration = unchanged,
    List<String>? faithTags,
    Object? religionPracticeLevel = unchanged,
    Object? eatsHalalOnly = unchanged,
    Object? smokes = unchanged,
    Object? drinksAlcohol = unchanged,
    Object? bornMuslim = unchanged,
    Object? hasChildren = unchanged,
    Object? wouldRelocate = unchanged,
    List<String>? personalityTraits,
    List<String>? interests,
    Object? bio = unchanged,
    List<String>? photoPaths,
  }) {
    return OnboardingData(
      accountType: identical(accountType, unchanged)
          ? this.accountType
          : accountType as String?,
      relationship: identical(relationship, unchanged)
          ? this.relationship
          : relationship as String?,
      fullName: identical(fullName, unchanged)
          ? this.fullName
          : fullName as String?,
      dateOfBirth: identical(dateOfBirth, unchanged)
          ? this.dateOfBirth
          : dateOfBirth as DateTime?,
      gender: identical(gender, unchanged) ? this.gender : gender as String?,
      religion: identical(religion, unchanged)
          ? this.religion
          : religion as String?,
      languages: languages ?? this.languages,
      lookingForIntent: identical(lookingForIntent, unchanged)
          ? this.lookingForIntent
          : lookingForIntent as String?,
      howHeard: identical(howHeard, unchanged)
          ? this.howHeard
          : howHeard as String?,
      nationalities: nationalities ?? this.nationalities,
      grewUpCountry: identical(grewUpCountry, unchanged)
          ? this.grewUpCountry
          : grewUpCountry as String?,
      ethnicities: ethnicities ?? this.ethnicities,
      heightCm: identical(heightCm, unchanged)
          ? this.heightCm
          : heightCm as int?,
      educationLevel: identical(educationLevel, unchanged)
          ? this.educationLevel
          : educationLevel as String?,
      profession: identical(profession, unchanged)
          ? this.profession
          : profession as String?,
      maritalStatus: identical(maritalStatus, unchanged)
          ? this.maritalStatus
          : maritalStatus as String?,
      knowSomeoneDuration: identical(knowSomeoneDuration, unchanged)
          ? this.knowSomeoneDuration
          : knowSomeoneDuration as String?,
      marriedWithinDuration: identical(marriedWithinDuration, unchanged)
          ? this.marriedWithinDuration
          : marriedWithinDuration as String?,
      faithTags: faithTags ?? this.faithTags,
      religionPracticeLevel: identical(religionPracticeLevel, unchanged)
          ? this.religionPracticeLevel
          : religionPracticeLevel as String?,
      eatsHalalOnly: identical(eatsHalalOnly, unchanged)
          ? this.eatsHalalOnly
          : eatsHalalOnly as bool?,
      smokes: identical(smokes, unchanged) ? this.smokes : smokes as bool?,
      drinksAlcohol: identical(drinksAlcohol, unchanged)
          ? this.drinksAlcohol
          : drinksAlcohol as bool?,
      bornMuslim: identical(bornMuslim, unchanged)
          ? this.bornMuslim
          : bornMuslim as bool?,
      hasChildren: identical(hasChildren, unchanged)
          ? this.hasChildren
          : hasChildren as bool?,
      wouldRelocate: identical(wouldRelocate, unchanged)
          ? this.wouldRelocate
          : wouldRelocate as bool?,
      personalityTraits: personalityTraits ?? this.personalityTraits,
      interests: interests ?? this.interests,
      bio: identical(bio, unchanged) ? this.bio : bio as String?,
      photoPaths: photoPaths ?? this.photoPaths,
    );
  }

  @override
  List<Object?> get props => [
    accountType,
    relationship,
    fullName,
    dateOfBirth,
    gender,
    religion,
    languages,
    lookingForIntent,
    howHeard,
    nationalities,
    grewUpCountry,
    ethnicities,
    heightCm,
    educationLevel,
    profession,
    maritalStatus,
    knowSomeoneDuration,
    marriedWithinDuration,
    faithTags,
    religionPracticeLevel,
    eatsHalalOnly,
    smokes,
    drinksAlcohol,
    bornMuslim,
    hasChildren,
    wouldRelocate,
    personalityTraits,
    interests,
    bio,
    photoPaths,
  ];
}
