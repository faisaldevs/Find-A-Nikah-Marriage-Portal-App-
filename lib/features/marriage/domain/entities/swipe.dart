import 'package:equatable/equatable.dart';

/// What the action buttons send (`POST /v1/profiles/swipe`): ✕ → [pass],
/// ✓ → [like], undo → [undo], middle (message) button → [complement].
enum SwipeAction {
  pass,
  like,

  /// A like with a first message (`text` is required). The API spells it
  /// "complement"; `compliment` is rejected with a 400. The server treats
  /// it like a like: the profile leaves the deck and can match.
  complement,

  /// Brings back the **last passed** profile. Likes can't be undone (the
  /// API answers 400 "No previous passed profile to rewind").
  undo,
}

/// Result of a swipe. Only a like (or compliment) can match.
class SwipeOutcome extends Equatable {
  const SwipeOutcome({
    this.isMatch = false,
    this.matchedName,
    this.matchedPhotoUrl,
    this.conversationId,
    this.rewoundUserId,
  });

  final bool isMatch;

  /// With [isMatch]: who it matched with, for the match dialog.
  final String? matchedName;
  final String? matchedPhotoUrl;

  /// With [isMatch]: the chat the match opened.
  final String? conversationId;

  /// Undo only: the profile that is back in the deck.
  final String? rewoundUserId;

  @override
  List<Object?> get props => [
    isMatch,
    matchedName,
    matchedPhotoUrl,
    conversationId,
    rewoundUserId,
  ];
}
