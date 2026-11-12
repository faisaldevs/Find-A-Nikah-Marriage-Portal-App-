import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';

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

  ChatPeer copyWith({
    String? id,
    String? name,
    String? photoUrl,
    bool? isOnline,
    Object? lastSeenAt = unchanged,
    Object? matchId = unchanged,
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
  ];
}
