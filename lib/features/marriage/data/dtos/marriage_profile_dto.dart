import 'package:find_a_nikah/features/marriage/domain/entities/marriage_profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'marriage_profile_dto.g.dart';

/// Wire format of one discovery profile. Kept separate from
/// [MarriageProfile] (decisions register #4) so a backend rename only
/// touches this file and its mapper.
@JsonSerializable()
class MarriageProfileDto {
  const MarriageProfileDto({
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

  factory MarriageProfileDto.fromJson(Map<String, dynamic> json) =>
      _$MarriageProfileDtoFromJson(json);

  final String id;
  final String name;
  final int age;
  final double distanceKm;
  final String area;
  final String country;
  final String countryFlag;
  final String profession;
  final String practice;
  final String ethnicity;
  final String ethnicityFlag;
  final List<String> photoUrls;
  final bool isVerified;
  final bool isActiveToday;
  final bool isPremium;
  final List<String> similarities;
  final int heightCm;
  final String maritalStatus;
  final String children;
  final String involveFamily;
  final String chatFor;
  final String marryWithin;
  final List<String> faith;
  final List<String> futurePlans;
  final List<String> interests;
  final List<String> personality;
  final String education;
  final List<String> languages;
  final String grewUpIn;
  final String grewUpFlag;
  final String bio;
  final bool isPhotoVerified;
  final bool isAgeVerified;
  final bool isIdVerified;

  Map<String, dynamic> toJson() => _$MarriageProfileDtoToJson(this);
}

/// One page of the discovery feed. [nextCursor] is null on the last page.
@JsonSerializable()
class MarriageFeedPageDto {
  const MarriageFeedPageDto({required this.items, this.nextCursor});

  factory MarriageFeedPageDto.fromJson(Map<String, dynamic> json) =>
      _$MarriageFeedPageDtoFromJson(json);

  final List<MarriageProfileDto> items;
  final String? nextCursor;

  Map<String, dynamic> toJson() => _$MarriageFeedPageDtoToJson(this);
}

extension MarriageProfileDtoMapper on MarriageProfileDto {
  MarriageProfile toEntity() => MarriageProfile(
    id: id,
    name: name,
    age: age,
    distanceKm: distanceKm,
    area: area,
    country: country,
    countryFlag: countryFlag,
    profession: profession,
    practice: practice,
    ethnicity: ethnicity,
    ethnicityFlag: ethnicityFlag,
    photoUrls: List.unmodifiable(photoUrls),
    isVerified: isVerified,
    isActiveToday: isActiveToday,
    isPremium: isPremium,
    similarities: List.unmodifiable(similarities),
    heightCm: heightCm,
    maritalStatus: maritalStatus,
    children: children,
    involveFamily: involveFamily,
    chatFor: chatFor,
    marryWithin: marryWithin,
    faith: List.unmodifiable(faith),
    futurePlans: List.unmodifiable(futurePlans),
    interests: List.unmodifiable(interests),
    personality: List.unmodifiable(personality),
    education: education,
    languages: List.unmodifiable(languages),
    grewUpIn: grewUpIn,
    grewUpFlag: grewUpFlag,
    bio: bio,
    isPhotoVerified: isPhotoVerified,
    isAgeVerified: isAgeVerified,
    isIdVerified: isIdVerified,
  );
}
