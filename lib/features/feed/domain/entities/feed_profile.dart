import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/features/feed/domain/entities/feed_author.dart';

/// A member's community profile.
class FeedProfile extends Equatable {
  const FeedProfile({
    required this.author,
    required this.countryName,
    required this.joined,
    this.followers = 0,
    this.following = 0,
  });

  final FeedAuthor author;
  final String countryName;

  /// Display-ready ("Oct 2026").
  final String joined;

  final int followers;
  final int following;

  FeedProfile copyWith({
    FeedAuthor? author,
    String? countryName,
    String? joined,
    int? followers,
    int? following,
  }) {
    return FeedProfile(
      author: author ?? this.author,
      countryName: countryName ?? this.countryName,
      joined: joined ?? this.joined,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }

  @override
  List<Object?> get props => [
    author,
    countryName,
    joined,
    followers,
    following,
  ];
}
