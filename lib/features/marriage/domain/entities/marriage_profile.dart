import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// One profile shown on the Marriage tab. The wire format is
/// `MarriageProfileDto` (data layer); this entity never sees JSON.
class MarriageProfile extends Equatable {
  const MarriageProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.distanceKm,
    required this.area,
    required this.country,
    required this.countryFlag,
    required this.profession,
    required this.practice,
    required this.ethnicity,
    required this.ethnicityFlag,
    required this.photoUrls,
    required this.heightCm,
    required this.maritalStatus,
    required this.children,
    required this.involveFamily,
    required this.chatFor,
    required this.marryWithin,
    required this.education,
    required this.grewUpIn,
    required this.grewUpFlag,
    required this.bio,
    this.isVerified = false,
    this.isActiveToday = false,
    this.isPremium = false,
    this.similarities = const [],
    this.faith = const [],
    this.futurePlans = const [],
    this.interests = const [],
    this.personality = const [],
    this.languages = const [],
    this.isPhotoVerified = false,
    this.isAgeVerified = false,
    this.isIdVerified = false,
  });

  final String id;
  final String name;
  final int age;

  /// Null when the API has no location for them (hidden in the hero).
  final double? distanceKm;

  /// Neighbourhood/city; '' when unknown. String fields below are '' when
  /// not filled in, and the UI hides empty chips/sections.
  final String area;

  final String country;
  final String countryFlag;
  final String profession;
  final String practice;
  final String ethnicity;
  final String ethnicityFlag;

  /// First is the main (hero) photo; the next four sit between the detail
  /// sections (after About me, My faith, Future plans and Personality).
  final List<String> photoUrls;

  // About me
  final int? heightCm;

  final String maritalStatus;
  final String children;

  // Marriage intentions timeline: when they want to involve family, how
  // long they'd chat, and how soon they'd marry.
  final String involveFamily;

  final String chatFor;
  final String marryWithin;
  final String education;
  final String grewUpIn;
  final String grewUpFlag;

  /// Free text. Blank lines separate paragraphs; lines starting with "• "
  /// render as a bulleted list.
  final String bio;

  final bool isVerified;
  final bool isActiveToday;

  /// Crown badge on the photo + the "Curious about X's filters?" teaser.
  final bool isPremium;

  /// Background details shared with the signed-in user ("Similarities").
  final List<String> similarities;

  final List<String> faith;
  final List<String> futurePlans;
  final List<String> interests;
  final List<String> personality;
  final List<String> languages;

  // "Verified profile" card.
  final bool isPhotoVerified;

  final bool isAgeVerified;
  final bool isIdVerified;

  MarriageProfile copyWith({
    String? id,
    String? name,
    int? age,
    Object? distanceKm = unchanged,
    String? area,
    String? country,
    String? countryFlag,
    String? profession,
    String? practice,
    String? ethnicity,
    String? ethnicityFlag,
    List<String>? photoUrls,
    Object? heightCm = unchanged,
    String? maritalStatus,
    String? children,
    String? involveFamily,
    String? chatFor,
    String? marryWithin,
    String? education,
    String? grewUpIn,
    String? grewUpFlag,
    String? bio,
    bool? isVerified,
    bool? isActiveToday,
    bool? isPremium,
    List<String>? similarities,
    List<String>? faith,
    List<String>? futurePlans,
    List<String>? interests,
    List<String>? personality,
    List<String>? languages,
    bool? isPhotoVerified,
    bool? isAgeVerified,
    bool? isIdVerified,
  }) {
    return MarriageProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      distanceKm: identical(distanceKm, unchanged)
          ? this.distanceKm
          : (distanceKm as num?)?.toDouble(),
      area: area ?? this.area,
      country: country ?? this.country,
      countryFlag: countryFlag ?? this.countryFlag,
      profession: profession ?? this.profession,
      practice: practice ?? this.practice,
      ethnicity: ethnicity ?? this.ethnicity,
      ethnicityFlag: ethnicityFlag ?? this.ethnicityFlag,
      photoUrls: photoUrls ?? this.photoUrls,
      heightCm: identical(heightCm, unchanged)
          ? this.heightCm
          : heightCm as int?,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      children: children ?? this.children,
      involveFamily: involveFamily ?? this.involveFamily,
      chatFor: chatFor ?? this.chatFor,
      marryWithin: marryWithin ?? this.marryWithin,
      education: education ?? this.education,
      grewUpIn: grewUpIn ?? this.grewUpIn,
      grewUpFlag: grewUpFlag ?? this.grewUpFlag,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
      isActiveToday: isActiveToday ?? this.isActiveToday,
      isPremium: isPremium ?? this.isPremium,
      similarities: similarities ?? this.similarities,
      faith: faith ?? this.faith,
      futurePlans: futurePlans ?? this.futurePlans,
      interests: interests ?? this.interests,
      personality: personality ?? this.personality,
      languages: languages ?? this.languages,
      isPhotoVerified: isPhotoVerified ?? this.isPhotoVerified,
      isAgeVerified: isAgeVerified ?? this.isAgeVerified,
      isIdVerified: isIdVerified ?? this.isIdVerified,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    age,
    distanceKm,
    area,
    country,
    countryFlag,
    profession,
    practice,
    ethnicity,
    ethnicityFlag,
    photoUrls,
    heightCm,
    maritalStatus,
    children,
    involveFamily,
    chatFor,
    marryWithin,
    education,
    grewUpIn,
    grewUpFlag,
    bio,
    isVerified,
    isActiveToday,
    isPremium,
    similarities,
    faith,
    futurePlans,
    interests,
    personality,
    languages,
    isPhotoVerified,
    isAgeVerified,
    isIdVerified,
  ];
}
