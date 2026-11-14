import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_time.dart';

/// What the Message button on a profile should do (server decides).
enum FeedMessageAction {
  /// Open the existing chat.
  chat,

  /// Write a compliment (a like with a first message).
  compliment,

  /// Needs a paid plan.
  upgrade,

  /// Hide the button (blocked, or yourself).
  none;

  static FeedMessageAction parse(String? v) => switch (v) {
    'chat' => chat,
    'upgrade' => upgrade,
    'none' => none,
    _ => compliment,
  };
}

/// A member's community profile.
class FeedProfile extends Equatable {
  const FeedProfile({
    required this.author,
    this.countryName = '',
    this.joinedAt,
    this.followers = 0,
    this.following = 0,
    this.postsCount = 0,
    this.commentsCount = 0,
    this.likesCount = 0,
    this.isFollowing = false,
    this.followsMe = false,
    this.isMuted = false,
    this.isBlocked = false,
    this.complimentSent = false,
    this.messageAction = FeedMessageAction.compliment,
    this.conversationId,
    this.matchId,
  });

  final FeedAuthor author;
  final String countryName;
  final DateTime? joinedAt;
  final int followers;
  final int following;
  final int postsCount;
  final int commentsCount;
  final int likesCount;
  final bool isFollowing;
  final bool followsMe;
  final bool isMuted;
  final bool isBlocked;

  /// The viewer already sent a like / compliment (server-side truth).
  final bool complimentSent;
  final FeedMessageAction messageAction;

  /// With [FeedMessageAction.chat]: the conversation to open.
  final String? conversationId;
  final String? matchId;

  /// Display-ready ("Oct 2026"), empty when unknown.
  String get joined => joinedAt == null ? '' : feedMonthYear(joinedAt!);

  FeedProfile copyWith({
    FeedAuthor? author,
    String? countryName,
    DateTime? joinedAt,
    int? followers,
    int? following,
    int? postsCount,
    int? commentsCount,
    int? likesCount,
    bool? isFollowing,
    bool? followsMe,
    bool? isMuted,
    bool? isBlocked,
    bool? complimentSent,
    FeedMessageAction? messageAction,
  }) {
    return FeedProfile(
      author: author ?? this.author,
      countryName: countryName ?? this.countryName,
      joinedAt: joinedAt ?? this.joinedAt,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      postsCount: postsCount ?? this.postsCount,
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount,
      isFollowing: isFollowing ?? this.isFollowing,
      followsMe: followsMe ?? this.followsMe,
      isMuted: isMuted ?? this.isMuted,
      isBlocked: isBlocked ?? this.isBlocked,
      complimentSent: complimentSent ?? this.complimentSent,
      messageAction: messageAction ?? this.messageAction,
      conversationId: conversationId,
      matchId: matchId,
    );
  }

  @override
  List<Object?> get props => [
    author,
    countryName,
    joinedAt,
    followers,
    following,
    postsCount,
    commentsCount,
    likesCount,
    isFollowing,
    followsMe,
    isMuted,
    isBlocked,
    complimentSent,
    messageAction,
    conversationId,
    matchId,
  ];
}
