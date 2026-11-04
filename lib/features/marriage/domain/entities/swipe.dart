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

/// Result of a swipe. Only a like can match.
typedef SwipeOutcome = ({bool isMatch});
