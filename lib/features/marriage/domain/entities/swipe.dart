/// What the action buttons send (`POST /v1/profiles/swipe`): ✕ → [pass],
/// ✓ → [like], undo → [undo]. The middle (message) button is a separate
/// API, not a swipe.
enum SwipeAction {
  pass,
  like,

  /// Brings back the **last passed** profile. Likes can't be undone (the
  /// API answers 400 "No previous passed profile to rewind").
  undo,
}

/// Result of a swipe. Only a like can match.
typedef SwipeOutcome = ({bool isMatch});
