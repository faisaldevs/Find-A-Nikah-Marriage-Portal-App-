import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_time.dart';

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
  ];
}
