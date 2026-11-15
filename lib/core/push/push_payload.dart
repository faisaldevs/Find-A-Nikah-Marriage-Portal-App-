import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

/// What a push carries (see `resources/docs/PUSH_NOTIFICATIONS_BACKEND.md`).
/// Every value arrives as a string: FCM `data` has no nested JSON.
class PushPayload {
  const PushPayload({
    required this.type,
    this.title,
    this.body,
    this.conversationId,
    this.senderId,
    this.senderName,
    this.senderPhoto,
    this.postId,
    this.userId,
  });

  factory PushPayload.fromMessage(RemoteMessage m) => PushPayload.fromData(
    m.data,
    title: m.notification?.title,
    body: m.notification?.body,
  );

  factory PushPayload.fromData(
    Map<String, dynamic> d, {
    String? title,
    String? body,
  }) {
    String? s(String k) {
      final v = d[k];
      return v is String && v.isNotEmpty ? v : null;
    }

    return PushPayload(
      type: s('type') ?? 'unknown',
      // A notification block (shown by the system) wins; data-only pushes
      // carry the text themselves.
      title: title ?? s('title'),
      body: body ?? s('body'),
      conversationId: s('conversationId'),
      senderId: s('senderId'),
      senderName: s('senderName'),
      senderPhoto: s('senderPhoto'),
      postId: s('postId'),
      userId: s('userId'),
    );
  }

  /// Round-trips through a local notification's `payload` string.
  factory PushPayload.fromJson(String source) => PushPayload.fromData(
    (jsonDecode(source) as Map<String, dynamic>),
  );

  final String type;
  final String? title;
  final String? body;
  final String? conversationId;
  final String? senderId;
  final String? senderName;
  final String? senderPhoto;
  final String? postId;
  final String? userId;

  bool get isChat => type == 'message' && conversationId != null;

  String toJson() => jsonEncode(
    {
      'type': type,
      'title': title,
      'body': body,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhoto': senderPhoto,
      'postId': postId,
      'userId': userId,
    }..removeWhere((_, v) => v == null),
  );
}
