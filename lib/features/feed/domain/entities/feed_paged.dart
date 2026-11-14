import 'package:equatable/equatable.dart';

/// One page of a cursor-paged list. Stop on [hasMore] — the server may send
/// a [nextCursor] even on the last page.
class FeedPaged<T> extends Equatable {
  const FeedPaged({
    this.items = const [],
    this.nextCursor,
    this.hasMore = false,
  });

  final List<T> items;
  final String? nextCursor;
  final bool hasMore;

  /// The cursor to ask for the next page, or null when there is none.
  String? get next => hasMore ? nextCursor : null;

  @override
  List<Object?> get props => [items, nextCursor, hasMore];
}

/// Result of a like / follow / mute toggle: the state the server ended in
/// and the count it holds now.
class ToggleResult extends Equatable {
  const ToggleResult({required this.active, this.count});

  final bool active;
  final int? count;

  @override
  List<Object?> get props => [active, count];
}
