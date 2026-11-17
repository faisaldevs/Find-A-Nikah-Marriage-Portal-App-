import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/notifications/domain/app_notification.dart';
import 'package:find_a_nikah/features/notifications/domain/notifications_repository.dart';

enum NotificationsStatus { loading, ready, failure }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.loading,
    this.items = const <AppNotification>[],
    this.nextCursor,
    this.loadingMore = false,
    this.failure,
  });

  final NotificationsStatus status;
  final List<AppNotification> items;
  final String? nextCursor;
  final bool loadingMore;

  /// A failed action (mark read, remove, next page); shown once.
  final Failure? failure;

  bool get hasUnread => items.any((n) => !n.isRead);

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? items,
    Object? nextCursor = unchanged,
    bool? loadingMore,
    Object? failure = unchanged,
  }) => NotificationsState(
    status: status ?? this.status,
    items: items ?? this.items,
    nextCursor: identical(nextCursor, unchanged)
        ? this.nextCursor
        : nextCursor as String?,
    loadingMore: loadingMore ?? this.loadingMore,
    failure: identical(failure, unchanged) ? this.failure : failure as Failure?,
  );

  @override
  List<Object?> get props => [status, items, nextCursor, loadingMore, failure];
}

/// The bell list: newest first, cursor paging, optimistic read/remove.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repo) : super(const NotificationsState());

  final NotificationsRepository _repo;

  Future<void> load() async {
    emit(state.copyWith(status: NotificationsStatus.loading, failure: null));
    final res = await _repo.fetch();
    res.match(
      (f) =>
          emit(state.copyWith(status: NotificationsStatus.failure, failure: f)),
      (page) => emit(
        state.copyWith(
          status: NotificationsStatus.ready,
          items: page.items,
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final cursor = state.nextCursor;
    if (cursor == null || state.loadingMore) return;
    emit(state.copyWith(loadingMore: true));
    final res = await _repo.fetch(cursor: cursor);
    res.match(
      (f) => emit(state.copyWith(loadingMore: false, failure: f)),
      (page) => emit(
        state.copyWith(
          loadingMore: false,
          items: [...state.items, ...page.items],
          nextCursor: page.nextCursor,
        ),
      ),
    );
  }

  Future<void> markRead(AppNotification n) async {
    if (n.isRead) return;
    _replace(n.id, (x) => x.copyWith(isRead: true));
    final res = await _repo.markRead(n.id);
    res.match((f) {
      _replace(n.id, (x) => x.copyWith(isRead: false));
      emit(state.copyWith(failure: f));
    }, (_) {});
  }

  Future<void> markAllRead() async {
    final before = state.items;
    emit(
      state.copyWith(
        items: [for (final n in before) n.copyWith(isRead: true)],
        failure: null,
      ),
    );
    final res = await _repo.markAllRead();
    res.match((f) => emit(state.copyWith(items: before, failure: f)), (_) {});
  }

  Future<void> remove(AppNotification n) async {
    final before = state.items;
    emit(
      state.copyWith(
        items: [
          for (final x in before)
            if (x.id != n.id) x,
        ],
        failure: null,
      ),
    );
    final res = await _repo.remove(n.id);
    res.match((f) => emit(state.copyWith(items: before, failure: f)), (_) {});
  }

  void _replace(String id, AppNotification Function(AppNotification) f) => emit(
    state.copyWith(
      items: [for (final n in state.items) n.id == id ? f(n) : n],
      failure: null,
    ),
  );
}
