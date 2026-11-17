import 'package:equatable/equatable.dart';

/// One row of the in-app bell list (`GET /v1/notifications`). Chat messages
/// are never rows — they have their own unread counter.
class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.actorName,
    this.actorPhotoUrl,
    this.userId,
    this.postId,
    this.conversationId,
  });

  final String id;
  final String type;
  final String title;
  final String body;
  final DateTime? createdAt;
  final bool isRead;
  final String? actorName;
  final String? actorPhotoUrl;
  final String? userId;
  final String? postId;
  final String? conversationId;

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    type: type,
    title: title,
    body: body,
    createdAt: createdAt,
    isRead: isRead ?? this.isRead,
    actorName: actorName,
    actorPhotoUrl: actorPhotoUrl,
    userId: userId,
    postId: postId,
    conversationId: conversationId,
  );

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    body,
    createdAt,
    isRead,
    actorName,
    actorPhotoUrl,
    userId,
    postId,
    conversationId,
  ];
}
