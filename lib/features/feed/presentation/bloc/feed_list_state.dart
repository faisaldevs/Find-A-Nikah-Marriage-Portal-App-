import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';

enum FeedListStatus { idle, loading, ready, failure }

/// A cursor-paged list held in a bloc state (feed, comments, a profile tab).
class FeedListState<T> extends Equatable {
  const FeedListState({
    this.status = FeedListStatus.idle,
    this.items = const [],
    this.nextCursor,
    this.hasMore = false,
    this.loadingMore = false,
    this.failure,
  });

  final FeedListStatus status;
  final List<T> items;
  final String? nextCursor;
  final bool hasMore;
  final bool loadingMore;
  final Failure? failure;

  bool get isIdle => status == FeedListStatus.idle;
  bool get isLoading => status == FeedListStatus.loading;
  bool get isReady => status == FeedListStatus.ready;
  bool get hasFailed => status == FeedListStatus.failure;
  bool get canLoadMore => isReady && hasMore && !loadingMore;

  FeedListState<T> copyWith({
    FeedListStatus? status,
    List<T>? items,
    Object? nextCursor = unchanged,
    bool? hasMore,
    bool? loadingMore,
    Object? failure = unchanged,
  }) {
    return FeedListState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      nextCursor: identical(nextCursor, unchanged)
          ? this.nextCursor
          : nextCursor as String?,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
    );
  }

  /// First page arrived.
  FeedListState<T> loaded(FeedPaged<T> page) => FeedListState<T>(
    status: FeedListStatus.ready,
    items: page.items,
    nextCursor: page.nextCursor,
    hasMore: page.hasMore,
  );

  /// A further page arrived: append, skipping ids already present.
  FeedListState<T> appended(
    FeedPaged<T> page, {
    required Object Function(T) idOf,
  }) {
    final seen = {for (final i in items) idOf(i)};
    return copyWith(
      items: [
        ...items,
        for (final i in page.items)
          if (!seen.contains(idOf(i))) i,
      ],
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
      loadingMore: false,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    nextCursor,
    hasMore,
    loadingMore,
    failure,
  ];
}

/// A one-shot message for the UI (toast). The [id] makes every notice
/// distinct, so showing the same text twice still fires a listener.
class FeedNotice extends Equatable {
  const FeedNotice(this.id, this.text, {this.isError = false});

  final int id;
  final String text;
  final bool isError;

  @override
  List<Object?> get props => [id, text, isError];
}

/// Replace the item with [id] by [update], leaving the rest as is.
List<T> replaceWhere<T>(
  List<T> list,
  bool Function(T) test,
  T Function(T) update,
) => [for (final i in list) test(i) ? update(i) : i];
