import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

/// What the app knows about a match's profile (from `my-matches`): enough
/// for the "View profile" page. Every field is optional.
class PeerProfile extends Equatable {
  const PeerProfile({
    this.images = const [],
    this.age,
    this.city,
    this.country,
    this.education,
    this.profession,
    this.faith,
    this.religion,
    this.sect,
    this.maritalStatus,
    this.isVerified = false,
  });

  /// Absolute URLs, first one is the main photo.
  final List<String> images;
  final int? age;
  final String? city;
  final String? country;
  final String? education;
  final String? profession;
  final String? faith;
  final String? religion;
  final String? sect;
  final String? maritalStatus;
  final bool isVerified;

  @override
  List<Object?> get props => [
    images,
    age,
    city,
    country,
    education,
    profession,
    faith,
    religion,
    sect,
    maritalStatus,
    isVerified,
  ];
}

/// The other person in a conversation (or a match not chatted with yet) —
/// enough to draw the avatar row and the chat header.
class ChatPeer extends Equatable {
  const ChatPeer({
    required this.id,
    required this.name,
    required this.photoUrl,
    this.isOnline = false,
    this.lastSeenAt,
    this.matchId,
    this.profile,
  });

  final String id;
  final String name;
  final String photoUrl;
  final bool isOnline;

  /// When they were last active; null while [isOnline] or unknown.
  final DateTime? lastSeenAt;

  /// The match this chat belongs to — what Unmatch acts on. Null when the
  /// source didn't say.
  final String? matchId;

  /// Null when the source had no profile (e.g. a chat opened before a match).
  final PeerProfile? profile;

  ChatPeer copyWith({
    String? id,
    String? name,
    String? photoUrl,
    bool? isOnline,
    Object? lastSeenAt = unchanged,
    Object? matchId = unchanged,
    Object? profile = unchanged,
  }) {
    return ChatPeer(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: identical(lastSeenAt, unchanged)
          ? this.lastSeenAt
          : lastSeenAt as DateTime?,
      matchId: identical(matchId, unchanged)
          ? this.matchId
          : matchId as String?,
      profile: identical(profile, unchanged)
          ? this.profile
          : profile as PeerProfile?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    photoUrl,
    isOnline,
    lastSeenAt,
    matchId,
    profile,
  ];
}

/// Someone the signed-in user blocked (Settings → Profiles I've blocked).
class BlockedUser extends Equatable {
  const BlockedUser({required this.id, required this.name, this.photoUrl});

  final String id;
  final String name;

  /// Absolute URL, or '' when unknown.
  final String? photoUrl;

  @override
  List<Object?> get props => [id, name, photoUrl];
}
