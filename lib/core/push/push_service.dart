import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:dio/dio.dart';
import 'package:find_a_nikah/core/logging/logger.dart';
import 'package:find_a_nikah/core/push/notification_presenter.dart';
import 'package:find_a_nikah/core/push/push_payload.dart';
import 'package:find_a_nikah/core/push/push_tap_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Registers this phone's FCM token with the backend so it can send pushes
/// (`POST /v1/devices`, `DELETE /v1/devices/:token`). Every step is best
/// effort: push failing must never block sign-in or sign-out.
abstract interface class PushRegistrar {
  /// Asks for notification permission, then registers the token (and keeps
  /// it fresh). Safe to call on every sign-in.
  Future<void> register();

  /// Removes the token from the server. Call while still signed in.
  Future<void> unregister();
}

class PushService implements PushRegistrar {
  PushService(
    this._dio,
    this._logger,
    this._taps, [
    FirebaseMessaging? messaging,
    NotificationPresenter? presenter,
  ]) : _messaging = messaging ?? FirebaseMessaging.instance,
       _presenter = presenter ?? NotificationPresenter();

  final Dio _dio;
  final Logger _logger;
  final PushTapHandler _taps;
  final FirebaseMessaging _messaging;
  final NotificationPresenter _presenter;

  /// Once at start-up: channels, foreground display and tap routing.
  Future<void> init() async {
    await _presenter.init(
      onTap: (r) {
        final raw = r.payload;
        if (raw != null) _taps.handle(PushPayload.fromJson(raw));
      },
    );
    // Foreground: FCM never draws these itself.
    FirebaseMessaging.onMessage.listen(
      (m) => _presenter.show(PushPayload.fromMessage(m)).ignore(),
    );
    // Tapped a notification FCM drew (app was in the background or closed).
    FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => _taps.handle(PushPayload.fromMessage(m)),
    );
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _taps.handle(PushPayload.fromMessage(initial));
    // Tapped one of our own notifications while the app was closed.
    final launch = await _presenter.launchPayload();
    if (launch != null) _taps.handle(launch);
  }

  String? _token;
  bool _listening = false;

  @override
  Future<void> register() async {
    try {
      // Android 13+ and iOS show the system permission prompt here.
      await _messaging.requestPermission();
      // ignore: deprecated_member_use, the replacement returns a Firebase installation id, not the FCM token the backend sends to
      final token = await _messaging.getToken();
      if (token == null) return;
      await _send(token);
      if (!_listening) {
        _listening = true;
        // ignore: deprecated_member_use, see getToken above
        _messaging.onTokenRefresh.listen((t) => _send(t).ignore());
      }
    } on Object catch (e, st) {
      _logger.warning('push register failed', e, st);
    }
  }

  Future<void> _send(String token) async {
    _token = token;
    await _dio.post<void>(
      '/v1/devices',
      data: {'token': token, 'platform': _platform},
    );
  }

  @override
  Future<void> unregister() async {
    final token = _token;
    if (token == null) return;
    try {
      await _dio.delete<void>('/v1/devices/$token');
      _token = null;
    } on Object catch (e, st) {
      _logger.warning('push unregister failed', e, st);
    }
  }

  // shortcut: only android/ios have FCM here, desktop/web builds are not shipped.
  static String get _platform =>
      defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
}

/// Background / terminated messages. Top-level and an entry point because the
/// engine starts it in its own isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // A message with a notification block is drawn by Android itself; drawing
  // it here too would show it twice.
  if (message.notification != null) return;
  await Firebase.initializeApp(); // reads google-services.json / plist
  final presenter = NotificationPresenter();
  await presenter.init();
  await presenter.show(PushPayload.fromMessage(message));
}
