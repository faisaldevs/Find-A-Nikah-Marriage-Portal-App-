import 'package:flutter/foundation.dart';

/// Everything collected across the profile-info wizard (account type through
/// interests). Plain data holder — no codegen (matches the rest of the
/// app's non-codegen Riverpod setup).
@immutable
class OnboardingData {
  const OnboardingData({
    this.accountType,
    this.lookingForIntent,
    this.howHeard,
    this.nationalities = const [],
    this.grewUpCountry,
    this.ethnicities = const [],
    this.heightCm,
    this.educationLevel,
    this.profession,
    this.maritalStatus,
    this.knowSomeoneDuration,
    this.marriedWithinDuration,
    this.faithTags = const [],
    this.religionPracticeLevel,
    this.eatsHalalOnly,
    this.smokes,
    this.drinksAlcohol,
    this.bornMuslim,
    this.hasChildren,
    this.wouldRelocate,
    this.personalityTraits = const [],
    this.interests = const [],
    this.bio,
    this.photoPaths = const [],
    this.phoneNumber,
  });

  final String? accountType;
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
  final List<String> photoPaths;
  final String? phoneNumber;

  OnboardingData copyWith({
    String? accountType,
    String? lookingForIntent,
    String? howHeard,
    List<String>? nationalities,
    String? grewUpCountry,
    List<String>? ethnicities,
    int? heightCm,
    String? educationLevel,
    String? profession,
    String? maritalStatus,
    String? knowSomeoneDuration,
    String? marriedWithinDuration,
    List<String>? faithTags,
    String? religionPracticeLevel,
    bool? eatsHalalOnly,
    bool? smokes,
    bool? drinksAlcohol,
    bool? bornMuslim,
    bool? hasChildren,
    bool? wouldRelocate,
    List<String>? personalityTraits,
    List<String>? interests,
    String? bio,
    List<String>? photoPaths,
    String? phoneNumber,
  }) {
    return OnboardingData(
      accountType: accountType ?? this.accountType,
      lookingForIntent: lookingForIntent ?? this.lookingForIntent,
      howHeard: howHeard ?? this.howHeard,
      nationalities: nationalities ?? this.nationalities,
      grewUpCountry: grewUpCountry ?? this.grewUpCountry,
      ethnicities: ethnicities ?? this.ethnicities,
      heightCm: heightCm ?? this.heightCm,
      educationLevel: educationLevel ?? this.educationLevel,
      profession: profession ?? this.profession,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      knowSomeoneDuration: knowSomeoneDuration ?? this.knowSomeoneDuration,
      marriedWithinDuration:
          marriedWithinDuration ?? this.marriedWithinDuration,
      faithTags: faithTags ?? this.faithTags,
      religionPracticeLevel:
          religionPracticeLevel ?? this.religionPracticeLevel,
      eatsHalalOnly: eatsHalalOnly ?? this.eatsHalalOnly,
      smokes: smokes ?? this.smokes,
      drinksAlcohol: drinksAlcohol ?? this.drinksAlcohol,
      bornMuslim: bornMuslim ?? this.bornMuslim,
      hasChildren: hasChildren ?? this.hasChildren,
      wouldRelocate: wouldRelocate ?? this.wouldRelocate,
      personalityTraits: personalityTraits ?? this.personalityTraits,
      interests: interests ?? this.interests,
      bio: bio ?? this.bio,
      photoPaths: photoPaths ?? this.photoPaths,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
