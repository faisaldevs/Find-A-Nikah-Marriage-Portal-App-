import 'package:find_a_nikah/features/messaging/data/data.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_message_dto.dart';
import 'package:find_a_nikah/features/messaging/data/mappers/messaging_mappers.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('messaging mappers', () {
    final dto = ChatMessageDto(
      id: 'm1',
      conversationId: 'c1',
      senderId: 'me',
      text: 'Hi',
      sentAt: DateTime.utc(2026, 10, 24, 12),
      status: 'delivered',
      replyTo: const MessageReplyDto(
        messageId: 'm0',
        senderId: 'peer',
        text: 'Salaam',
      ),
    );

    test('sender ids become isMine against myId', () {
      final m = dto.toEntity(myId: 'me');
      expect(m.isMine, isTrue);
      expect(m.replyTo!.isMine, isFalse);
      expect(dto.toEntity(myId: 'other').isMine, isFalse);
    });

    test('status codes map, unknown reads as sent', () {
      expect(messageStatusFromWire('sending'), MessageStatus.sending);
      expect(messageStatusFromWire('delivered'), MessageStatus.delivered);
      expect(messageStatusFromWire('seen'), MessageStatus.seen);
      expect(messageStatusFromWire('failed'), MessageStatus.failed);
      expect(messageStatusFromWire('read_by_all'), MessageStatus.sent);
    });

    test('sentAt comes out local', () {
      expect(dto.toEntity(myId: 'me').sentAt.isUtc, isFalse);
    });
  });

  group('DummyMessagingDataSource', () {
    late DummyMessagingDataSource source;

    setUp(() => source = DummyMessagingDataSource(latency: Duration.zero));
    tearDown(() => source.dispose());

    test('loads the fixture: 3 conversations in slots 0–2', () async {
      final list = await source.watchConversations().first;
      expect([for (final c in list) c.slot], [0, 1, 2]);
      expect(list.first.id, 'c-yusuf');
      expect(list.first.unreadCount, 2);
    });

    test('fixture times are shifted to now', () async {
      final list = await source.watchConversations().first;
      final newest = list.first.lastMessage!.sentAt;
      expect(
        DateTime.now().difference(newest),
        lessThan(const Duration(hours: 1)),
      );
    });

    test('a match takes the slot it was picked from', () async {
      expect(await source.watchMatches().first, hasLength(2));
      final c = await source.openConversation('u-hamza', slot: 4);
      expect(c.slot, 4);
      expect(c.lastMessage, isNull);
      expect(await source.watchMatches().first, hasLength(1));
      var list = await source.watchConversations().first;
      expect([for (final c in list) c.slot], [0, 1, 2, 4]);
      expect(list.last.id, c.id);

      // Messaging doesn't move it.
      await source.sendMessage(conversationId: c.id, text: 'Salaam');
      list = await source.watchConversations().first;
      expect(list.last.id, c.id);
      expect(list.last.lastMessage!.status, 'sent');
    });

    test('a taken or missing slot falls back to the first free one', () async {
      expect((await source.openConversation('u-hamza', slot: 1)).slot, 3);
      expect((await source.openConversation('u-zayd')).slot, 4);
    });

    test('openConversation returns the existing chat for a peer', () async {
      final c = await source.openConversation('u-yusuf');
      expect(c.id, 'c-yusuf');
    });

    test('a reply embeds the quoted message', () async {
      await source.sendMessage(
        conversationId: 'c-yusuf',
        text: 'Yes, in sha Allah',
        replyToMessageId: 'm-y6',
      );
      final messages = await source.watchMessages('c-yusuf').first;
      expect(messages.last.replyTo!.messageId, 'm-y6');
      expect(messages.last.replyTo!.senderId, 'u-yusuf');
    });

    test('logCall appends a call record; incoming counts unread', () async {
      await source.markRead('c-abdullah');
      await source.logCall(
        conversationId: 'c-abdullah',
        outcome: 'missed',
        outgoing: false,
        durationSeconds: 0,
      );
      final messages = await source.watchMessages('c-abdullah').first;
      final call = messages.last.toEntity(myId: source.meId);
      expect(call.isCall, isTrue);
      expect(call.callLog!.outcome, CallOutcome.missed);
      expect(call.callLog!.outgoing, isFalse);
      final list = await source.watchConversations().first;
      expect(list.firstWhere((c) => c.id == 'c-abdullah').unreadCount, 1);
    });

    test('markRead clears the unread count', () async {
      await source.markRead('c-yusuf');
      final list = await source.watchConversations().first;
      expect(list.firstWhere((c) => c.id == 'c-yusuf').unreadCount, 0);
    });
  });
}
