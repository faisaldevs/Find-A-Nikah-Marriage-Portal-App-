import 'package:find_a_nikah/core/push/push_payload.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Draws notifications ourselves: for data-only pushes (chat) and for any
/// push that arrives while the app is open (FCM doesn't show those).
///
/// Also runs in the background-message isolate, so it must not use `getIt`.
class NotificationPresenter {
  NotificationPresenter([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  // Ids must match the backend's `android.notification.channel_id`.
  static const chatChannel = AndroidNotificationChannel(
    'channel_chat',
    'Messages',
    description: 'New chat messages',
    importance: Importance.high,
  );
  static const matchesChannel = AndroidNotificationChannel(
    'channel_matches',
    'Matches and compliments',
    description: 'New matches and compliments',
    importance: Importance.high,
  );
  static const activityChannel = AndroidNotificationChannel(
    'channel_activity',
    'Activity',
    description: 'Likes, comments and other activity',
  );

  /// Drawable in `android/app/src/main/res/drawable`.
  static const _icon = 'ic_stat_notification';

  // shortcut: recent messages live in memory per conversation, so a message
  // that arrives after the process was killed starts a fresh stack; persist
  // them if users report lost context.
  static final _history = <String, List<Message>>{};

  Future<void> init({
    DidReceiveNotificationResponseCallback? onTap,
  }) async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_icon),
      ),
      onDidReceiveNotificationResponse: onTap,
    );
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    for (final c in [chatChannel, matchesChannel, activityChannel]) {
      await android?.createNotificationChannel(c);
    }
  }

  /// The notification that opened the app from a closed state, if any.
  Future<PushPayload?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    final raw = details?.notificationResponse?.payload;
    if (details?.didNotificationLaunchApp != true || raw == null) return null;
    return PushPayload.fromJson(raw);
  }

  Future<void> show(PushPayload p) async {
    // Silent sync pushes: the chat was read elsewhere / a message was
    // deleted for everyone, so its notification is stale.
    // shortcut: drops the whole conversation stack, not just the one
    // deleted message; the payload has no per-message notification id.
    if (p.isSilentSync) {
      if (p.conversationId != null) await clearConversation(p.conversationId!);
      return;
    }
    if (p.title == null && p.body == null) return;
    if (p.isChat) return _showChat(p);

    final channel = switch (p.type) {
      'match' || 'compliment' || 'like' => matchesChannel,
      _ => activityChannel,
    };
    await _plugin.show(
      id: _id(p.postId ?? p.userId ?? p.type),
      title: p.title,
      body: p.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          priority: Priority.high,
          icon: _icon,
        ),
      ),
      payload: p.toJson(),
    );
  }

  /// One notification per conversation; new messages stack in it.
  Future<void> _showChat(PushPayload p) async {
    final id = p.conversationId!;
    final sender = Person(
      name: p.senderName ?? p.title ?? 'New message',
      key: p.senderId,
      important: true,
    );
    final messages = (_history[id] ??= <Message>[])
      ..add(Message(p.body ?? '', DateTime.now(), sender));
    if (messages.length > 6) messages.removeAt(0);

    await _plugin.show(
      id: _id(id),
      title: sender.name,
      body: p.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          chatChannel.id,
          chatChannel.name,
          channelDescription: chatChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: _icon,
          category: AndroidNotificationCategory.message,
          styleInformation: MessagingStyleInformation(
            const Person(name: 'Me'),
            messages: List.of(messages),
          ),
        ),
      ),
      payload: p.toJson(),
    );
  }

  /// Opening the chat clears its stack and notification.
  Future<void> clearConversation(String conversationId) async {
    _history.remove(conversationId);
    await _plugin.cancel(id: _id(conversationId));
  }

  static int _id(String key) => key.hashCode & 0x7fffffff;
}
