import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/notifications/domain/app_notification.dart';

abstract interface class NotificationsRepository {
  /// Newest first. [cursor] is the `nextCursor` of the previous page.
  Future<Either<Failure, NotificationsPage>> fetch({String? cursor});

  Future<Either<Failure, int>> unreadCount();
  Future<Either<Failure, Unit>> markRead(String id);
  Future<Either<Failure, Unit>> markAllRead();
  Future<Either<Failure, Unit>> remove(String id);
}

class NotificationsPage {
  const NotificationsPage(this.items, {this.nextCursor});
  final List<AppNotification> items;

  /// Null on the last page.
  final String? nextCursor;
}
