import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/notifications/domain/app_notification.dart';
import 'package:find_a_nikah/features/notifications/domain/notifications_repository.dart';

/// REST client for the bell. The response envelope is `{data: ...}`; the
/// list may sit at `data` or `data.notifications` (not fixed by the backend
/// yet — see `resources/docs/NEED_BACKEND_CONFIRM_PUSH_BELL.md`), so the
/// parsing below accepts both.
class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._dio, this._guard, this._imageBase);

  final Dio _dio;
  final Guard _guard;
  final String _imageBase;

  static const pageSize = 20;

  @override
  Future<Either<Failure, NotificationsPage>> fetch({String? cursor}) => _guard(
    () async {
      final res = await _dio.get<Map<String, dynamic>>(
        '/v1/notifications',
        queryParameters: {'limit': pageSize, 'cursor': ?cursor},
      );
      final data = res.data?['data'];
      final map = data is Map<String, dynamic>
          ? data
          : const <String, dynamic>{};
      final rows = data is List ? data : (map['notifications'] ?? map['items']);
      final items = [
        for (final r in rows is List ? rows : const [])
          if (r is Map<String, dynamic>) _parse(r),
      ];
      final next = map['nextCursor'] ?? res.data?['nextCursor'];
      return NotificationsPage(
        items,
        nextCursor: next is String && next.isNotEmpty ? next : null,
      );
    },
  );

  @override
  Future<Either<Failure, int>> unreadCount() => _guard(() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/v1/notifications/unread-count',
    );
    final d = res.data?['data'];
    final n = d is num ? d : (d is Map ? d['unreadCount'] ?? d['count'] : null);
    return n is num ? n.toInt() : 0;
  });

  @override
  Future<Either<Failure, Unit>> markRead(String id) => _guard(() async {
    await _dio.post<void>('/v1/notifications/$id/read');
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> markAllRead() => _guard(() async {
    await _dio.post<void>('/v1/notifications/read-all');
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> remove(String id) => _guard(() async {
    await _dio.delete<void>('/v1/notifications/$id');
    return unit;
  });

  static const _typeAlias = {
    'match_created': 'match',
    'message_received': 'message',
  };

  AppNotification _parse(Map<String, dynamic> j) {
    String? s(Object? v) => v is String && v.isNotEmpty ? v : null;
    final actor = j['actor'] is Map<String, dynamic>
        ? j['actor'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final photo = s(actor['photoUrl']);
    final rawType = s(j['type']) ?? 'unknown';
    // Dev backend (2026-11-16) sends these names, not the documented
    // `match` / `message`, and puts the recipient's own id in `userId`, so
    // for them the id is useless as a deep link.
    final type = _typeAlias[rawType] ?? rawType;
    final selfRef = _typeAlias.containsKey(rawType);
    return AppNotification(
      id: s(j['id']) ?? s(j['_id']) ?? '',
      type: type,
      title: s(j['title']) ?? '',
      body: s(j['body']) ?? '',
      createdAt: DateTime.tryParse(s(j['createdAt']) ?? '')?.toLocal(),
      isRead: j['isRead'] == true,
      actorName: s(actor['name']),
      // Absolute URLs pass through; `/public/...` paths get the server root.
      actorPhotoUrl: photo == null ? null : resolveImageUrl(_imageBase, photo),
      userId: selfRef ? null : s(j['userId']),
      postId: s(j['postId']),
      conversationId: s(j['conversationId']),
    );
  }
}
