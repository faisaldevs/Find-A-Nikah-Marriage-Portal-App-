import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/entities/my_profile.dart';

/// One edit to the member's own profile, sent as `PATCH /v1/profiles/me`.
/// Only non-null fields are sent. Nested groups ([aboutYou], [lifestyle],
/// [marriageIntentions], [interests]) always carry every value of the
/// group, because the API replaces some of them whole (ISS-010).
class ProfilePatch extends Equatable {
  const ProfilePatch({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.languages,
    this.grewUpIn,
    this.heightCm,
    this.maritalStatus,
    this.bio,
    this.aboutYou,
    this.marriageIntentions,
    this.religiousPractices,
    this.faith,
    this.lifestyle,
    this.interests,
    this.personalityTraits,
    this.educationLevel,
    this.profession,
    this.ethnicity,
    this.nationality,
    this.photoOrder,
  });

  final String? fullName;

  /// Date only; the time part is ignored.
  final DateTime? dateOfBirth;
  final String? gender;
  final String? religion;
  final List<String>? languages;

  /// Country names (the API stores names, not codes).
  final List<String>? grewUpIn;
  final int? heightCm;
  final String? maritalStatus;
  final String? bio;
  final AboutYouAnswers? aboutYou;
  final MarriageIntentionAnswers? marriageIntentions;
  final List<String>? religiousPractices;

  /// Backend tokens (`charity_work`, …).
  final List<String>? faith;
  final LifestyleAnswers? lifestyle;

  /// Every category, including the ones the edit didn't touch.
  final Map<InterestCategory, List<String>>? interests;
  final List<String>? personalityTraits;
  final String? educationLevel;
  final String? profession;
  final List<String>? ethnicity;
  final List<String>? nationality;

  /// Photo URLs in the new order, first = main photo.
  final List<String>? photoOrder;

  /// [p] with this edit applied, to show before the server answers.
  /// Completeness is left alone: only the server can recalculate it.
  MyProfile applyTo(MyProfile p) => p.copyWith(
    fullName: fullName,
    photos: photoOrder,
    dateOfBirth: dateOfBirth ?? unchanged,
    gender: gender ?? unchanged,
    religion: religion ?? unchanged,
    languages: languages,
    grewUpIn: grewUpIn == null
        ? unchanged
        : (grewUpIn!.isEmpty ? null : grewUpIn!.first),
    heightCm: heightCm ?? unchanged,
    maritalStatus: maritalStatus ?? unchanged,
    bio: bio ?? unchanged,
    bornMuslim: aboutYou == null ? unchanged : aboutYou!.bornMuslim,
    hasChildren: aboutYou == null ? unchanged : aboutYou!.haveChildren,
    relocateAbroad: aboutYou == null ? unchanged : aboutYou!.relocateAbroad,
    gettingToKnow: marriageIntentions?.getToKnow ?? unchanged,
    marriageTimeline: marriageIntentions?.marriageTimeline ?? unchanged,
    religiousPractice: religiousPractices == null
        ? unchanged
        : (religiousPractices!.isEmpty ? null : religiousPractices!.first),
    faith: faith,
    halalFood: lifestyle == null ? unchanged : lifestyle!.halalFood,
    smoking: lifestyle == null ? unchanged : lifestyle!.smoking,
    alcohol: lifestyle == null ? unchanged : lifestyle!.alcohol,
    interestGroups: interests,
    personality: personalityTraits,
    education: educationLevel ?? unchanged,
    profession: profession ?? unchanged,
    ethnicity: ethnicity,
    nationality: nationality,
  );

  @override
  List<Object?> get props => [
    fullName,
    dateOfBirth,
    gender,
    religion,
    languages,
    grewUpIn,
    heightCm,
    maritalStatus,
    bio,
    aboutYou,
    marriageIntentions,
    religiousPractices,
    faith,
    lifestyle,
    interests,
    personalityTraits,
    educationLevel,
    profession,
    ethnicity,
    nationality,
    photoOrder,
  ];
}

/// `profile.aboutYou`: sent whole.
class AboutYouAnswers extends Equatable {
  const AboutYouAnswers({
    this.bornMuslim,
    this.haveChildren,
    this.relocateAbroad,
  });

  /// The member's current answers, to change one and send all three.
  factory AboutYouAnswers.of(MyProfile p) => AboutYouAnswers(
    bornMuslim: p.bornMuslim,
    haveChildren: p.hasChildren,
    relocateAbroad: p.relocateAbroad,
  );

  final bool? bornMuslim;
  final bool? haveChildren;
  final bool? relocateAbroad;

  AboutYouAnswers copyWith({
    bool? bornMuslim,
    bool? haveChildren,
    bool? relocateAbroad,
  }) => AboutYouAnswers(
    bornMuslim: bornMuslim ?? this.bornMuslim,
    haveChildren: haveChildren ?? this.haveChildren,
    relocateAbroad: relocateAbroad ?? this.relocateAbroad,
  );

  @override
  List<Object?> get props => [bornMuslim, haveChildren, relocateAbroad];
}

/// `profile.lifestyle`: sent whole.
class LifestyleAnswers extends Equatable {
  const LifestyleAnswers({this.halalFood, this.smoking, this.alcohol});

  factory LifestyleAnswers.of(MyProfile p) => LifestyleAnswers(
    halalFood: p.halalFood,
    smoking: p.smoking,
    alcohol: p.alcohol,
  );

  final bool? halalFood;
  final bool? smoking;
  final bool? alcohol;

  LifestyleAnswers copyWith({bool? halalFood, bool? smoking, bool? alcohol}) =>
      LifestyleAnswers(
        halalFood: halalFood ?? this.halalFood,
        smoking: smoking ?? this.smoking,
        alcohol: alcohol ?? this.alcohol,
      );

  @override
  List<Object?> get props => [halalFood, smoking, alcohol];
}

/// `profile.marriageIntentions`: both answers, always sent together.
class MarriageIntentionAnswers extends Equatable {
  const MarriageIntentionAnswers({
    required this.getToKnow,
    required this.marriageTimeline,
  });

  /// Backend token, e.g. `3-4_months`.
  final String getToKnow;

  /// Backend token, e.g. `1-2_years`, `agree_together`.
  final String marriageTimeline;

  @override
  List<Object?> get props => [getToKnow, marriageTimeline];
}
