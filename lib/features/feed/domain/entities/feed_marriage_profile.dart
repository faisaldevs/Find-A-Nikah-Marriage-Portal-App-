import 'package:equatable/equatable.dart';

/// How much of a member's Marriage profile the viewer may see. Decided by
/// the server, which **withholds** locked data — the app never receives it
/// and only draws the lock.
enum FeedMarriageAccessLevel { full, partial, locked }

class FeedMarriageAccess extends Equatable {
  const FeedMarriageAccess({
    this.level = FeedMarriageAccessLevel.full,
    this.reason,
    this.unlockable = false,
    this.lockedSections = const [],
  });

  final FeedMarriageAccessLevel level;

  /// `BLOCKED`, `NOT_IN_FILTERS`, `NOT_ELIGIBLE`, `HIDDEN`,
  /// `PREMIUM_REQUIRED`, … (the server may add more).
  final String? reason;

  /// Could a paid upgrade open it? (Not built yet.)
  final bool unlockable;

  /// Server names of the sections that were withheld
  /// (`marriageIntentions`, `partnerPreference`, …).
  final List<String> lockedSections;

  bool get isFull => level == FeedMarriageAccessLevel.full;

  @override
  List<Object?> get props => [level, reason, unlockable, lockedSections];
}

/// A member's Marriage profile as the Feed shows it: display-ready text
/// (the same look as Menu → Edit profile → Preview), plus the viewer's
/// [access]. Fields the server withheld are empty / null.
class FeedMarriageProfile extends Equatable {
  const FeedMarriageProfile({
    required this.userId,
    required this.fullName,
    this.access = const FeedMarriageAccess(),
    this.photos = const [],
    this.age,
    this.location,
    this.isVerified = false,
    this.height,
    this.maritalStatus,
    this.children,
    this.practice,
    this.diet,
    this.smoking,
    this.alcohol,
    this.faith = const [],
    this.relocation,
    this.interests = const [],
    this.personality = const [],
    this.education,
    this.profession,
    this.grewUpIn,
    this.ethnicity = const [],
    this.languages = const [],
    this.nationality = const [],
    this.bio,
    this.gettingToKnow,
    this.marriageTimeline,
    this.isMatch = false,
    this.matchId,
  });

  final String userId;
  final String fullName;
  final FeedMarriageAccess access;

  /// Absolute URLs. Locked photos arrive pre-blurred or not at all.
  final List<String> photos;
  final int? age;
  final String? location;
  final bool isVerified;
  final String? height;
  final String? maritalStatus;
  final String? children;
  final String? practice;
  final String? diet;
  final String? smoking;
  final String? alcohol;
  final List<String> faith;
  final String? relocation;
  final List<String> interests;
  final List<String> personality;
  final String? education;
  final String? profession;
  final String? grewUpIn;
  final List<String> ethnicity;
  final List<String> languages;
  final List<String> nationality;
  final String? bio;
  final String? gettingToKnow;
  final String? marriageTimeline;

  /// Matched with the viewer (a chat exists).
  final bool isMatch;
  final String? matchId;

  String? get mainPhoto => photos.isEmpty ? null : photos.first;

  String get firstName => fullName.trim().split(' ').first;

  @override
  List<Object?> get props => [
    userId,
    fullName,
    access,
    photos,
    age,
    location,
    isVerified,
    height,
    maritalStatus,
    children,
    practice,
    diet,
    smoking,
    alcohol,
    faith,
    relocation,
    interests,
    personality,
    education,
    profession,
    grewUpIn,
    ethnicity,
    languages,
    nationality,
    bio,
    gettingToKnow,
    marriageTimeline,
    isMatch,
    matchId,
  ];
}
