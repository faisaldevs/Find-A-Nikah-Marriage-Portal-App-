import 'package:find_a_nikah/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('data-only chat push carries its own text', () {
    final p = PushPayload.fromData({
      'type': 'message',
      'title': 'Amina',
      'body': 'Salaam',
      'conversationId': 'c1',
      'senderId': 'u1',
      'senderName': 'Amina',
    });
    expect(p.isChat, isTrue);
    expect(p.body, 'Salaam');
    expect(p.senderId, 'u1');
  });

  test('a notification block wins over data text; missing type is unknown', () {
    final p = PushPayload.fromData(
      {'title': 'data title'},
      title: 'shown title',
      body: 'shown body',
    );
    expect(p.title, 'shown title');
    expect(p.type, 'unknown');
    expect(p.isChat, isFalse);
  });

  test('survives the notification payload round trip', () {
    const p = PushPayload(type: 'feed_comment', postId: 'p9', body: 'hi');
    final back = PushPayload.fromJson(p.toJson());
    expect(back.type, 'feed_comment');
    expect(back.postId, 'p9');
    expect(back.body, 'hi');
  });

  test('tap waits until the app is ready, then opens once', () {
    final opened = <String>[];
    var ready = false;
    final taps = PushTapHandler()
      ..attach(open: (p) => opened.add(p.type), isReady: () => ready)
      ..handle(const PushPayload(type: 'match'));
    expect(opened, isEmpty);
    ready = true;
    taps
      ..drain()
      ..drain();
    expect(opened, ['match']);
  });
}
