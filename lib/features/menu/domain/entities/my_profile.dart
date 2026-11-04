import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// The groups `profile.interests` comes in. Kept apart so an edit can send
/// every group back whole (the API replaces the object, ISS-010).
enum InterestCategory { cultural, foodDrinks, sports, fashion, activities }

/// The signed-in member's own profile, as shown on the Menu tab, Settings
/// and Edit profile. Raw values (backend tokens, booleans); formatting for
/// display happens in the presentation layer.
class MyProfile extends Equatable {
  const MyProfile({
    this.fullName = '',
    this.photos = const <String>[],
    this.isVerified = false,
    this.completeness = 0,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.currentLocation,
    this.grewUpIn,
    this.heightCm,
    this.maritalStatus,
    this.hasChildren,
    this.bio,
    this.gettingToKnow,
    this.marriageTimeline,
    this.relocateAbroad,
    this.bornMuslim,
    this.religiousPractice,
    this.faith = const <String>[],
    this.halalFood,
    this.alcohol,
    this.smoking,
    // this.interests = const <String>[],
    this.interestGroups = const <InterestCategory, List<String>>{},
    this.personality = const <String>[],
    this.education,
    this.profession,
    this.ethnicity = const <String>[],
    this.nationality = const <String>[],
    this.languages = const <String>[],
  });

  final String fullName;

  /// Full image URLs, first = main photo.
  final List<String> photos;

  final bool isVerified;

  /// 0–100.
  final int completeness;

  final String? email;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? religion;
  final String? currentLocation;
  final String? grewUpIn;
  final int? heightCm;
  final String? maritalStatus;
  final bool? hasChildren;
  final String? bio;
  final String? gettingToKnow;
  final String? marriageTimeline;
  final bool? relocateAbroad;
  final bool? bornMuslim;
  final String? religiousPractice;
  final List<String> faith;
  final bool? halalFood;
  final bool? alcohol;
  final bool? smoking;
  // final List<String> interests;
  /// Interests per category, as the API stores them.
  final Map<InterestCategory, List<String>> interestGroups;
  final List<String> personality;
  final String? education;
  final String? profession;
  final List<String> ethnicity;
  final List<String> nationality;
  final List<String> languages;

  String? get mainPhoto => photos.isEmpty ? null : photos.first;

  /// Every interest once, in category order (a tag like "Dancing" can sit
  /// in two categories).
  List<String> get interests => {
    for (final c in InterestCategory.values) ...?interestGroups[c],
  }.toList();

  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;

  MyProfile copyWith({
    String? fullName,
    List<String>? photos,
    bool? isVerified,
    int? completeness,
    Object? email = unchanged,
    Object? phone = unchanged,
    Object? dateOfBirth = unchanged,
    Object? gender = unchanged,
    Object? religion = unchanged,
    Object? currentLocation = unchanged,
    Object? grewUpIn = unchanged,
    Object? heightCm = unchanged,
    Object? maritalStatus = unchanged,
    Object? hasChildren = unchanged,
    Object? bio = unchanged,
    Object? gettingToKnow = unchanged,
    Object? marriageTimeline = unchanged,
    Object? relocateAbroad = unchanged,
    Object? bornMuslim = unchanged,
    Object? religiousPractice = unchanged,
    List<String>? faith,
    Object? halalFood = unchanged,
    Object? alcohol = unchanged,
    Object? smoking = unchanged,
    // List<String>? interests,
    Map<InterestCategory, List<String>>? interestGroups,
    List<String>? personality,
    Object? education = unchanged,
    Object? profession = unchanged,
    List<String>? ethnicity,
    List<String>? nationality,
    List<String>? languages,
  }) {
    return MyProfile(
      fullName: fullName ?? this.fullName,
      photos: photos ?? this.photos,
      isVerified: isVerified ?? this.isVerified,
      completeness: completeness ?? this.completeness,
      email: identical(email, unchanged) ? this.email : email as String?,
      phone: identical(phone, unchanged) ? this.phone : phone as String?,
      dateOfBirth: identical(dateOfBirth, unchanged)
          ? this.dateOfBirth
          : dateOfBirth as DateTime?,
      gender: identical(gender, unchanged) ? this.gender : gender as String?,
      religion: identical(religion, unchanged)
          ? this.religion
          : religion as String?,
      currentLocation: identical(currentLocation, unchanged)
          ? this.currentLocation
          : currentLocation as String?,
      grewUpIn: identical(grewUpIn, unchanged)
          ? this.grewUpIn
          : grewUpIn as String?,
      heightCm: identical(heightCm, unchanged)
          ? this.heightCm
          : heightCm as int?,
      maritalStatus: identical(maritalStatus, unchanged)
          ? this.maritalStatus
          : maritalStatus as String?,
      hasChildren: identical(hasChildren, unchanged)
          ? this.hasChildren
          : hasChildren as bool?,
      bio: identical(bio, unchanged) ? this.bio : bio as String?,
      gettingToKnow: identical(gettingToKnow, unchanged)
          ? this.gettingToKnow
          : gettingToKnow as String?,
      marriageTimeline: identical(marriageTimeline, unchanged)
          ? this.marriageTimeline
          : marriageTimeline as String?,
      relocateAbroad: identical(relocateAbroad, unchanged)
          ? this.relocateAbroad
          : relocateAbroad as bool?,
      bornMuslim: identical(bornMuslim, unchanged)
          ? this.bornMuslim
          : bornMuslim as bool?,
      religiousPractice: identical(religiousPractice, unchanged)
          ? this.religiousPractice
          : religiousPractice as String?,
      faith: faith ?? this.faith,
      halalFood: identical(halalFood, unchanged)
          ? this.halalFood
          : halalFood as bool?,
      alcohol: identical(alcohol, unchanged) ? this.alcohol : alcohol as bool?,
      smoking: identical(smoking, unchanged) ? this.smoking : smoking as bool?,
      // interests: interests ?? this.interests,
      interestGroups: interestGroups ?? this.interestGroups,
      personality: personality ?? this.personality,
      education: identical(education, unchanged)
          ? this.education
          : education as String?,
      profession: identical(profession, unchanged)
          ? this.profession
          : profession as String?,
      ethnicity: ethnicity ?? this.ethnicity,
      nationality: nationality ?? this.nationality,
      languages: languages ?? this.languages,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    photos,
    isVerified,
    completeness,
    email,
    phone,
    dateOfBirth,
    gender,
    religion,
    currentLocation,
    grewUpIn,
    heightCm,
    maritalStatus,
    hasChildren,
    bio,
    gettingToKnow,
    marriageTimeline,
    relocateAbroad,
    bornMuslim,
    religiousPractice,
    faith,
    halalFood,
    alcohol,
    smoking,
    // interests,
    interestGroups,
    personality,
    education,
    profession,
    ethnicity,
    nationality,
    languages,
  ];
}
