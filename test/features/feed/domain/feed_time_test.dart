import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 11, 14, 12);

  group('feedTimeAgo', () {
    String ago(Duration d) => feedTimeAgo(now.subtract(d), now: now);

    test('just now under a minute', () {
      expect(ago(const Duration(seconds: 20)), 'just now');
    });

    test('minutes and hours', () {
      expect(ago(const Duration(minutes: 23)), '23m ago');
      expect(ago(const Duration(hours: 9)), '9h ago');
    });

    test('days are singular for one (no "1 days ago")', () {
      expect(ago(const Duration(days: 1)), '1 day ago');
      expect(ago(const Duration(days: 3)), '3 days ago');
    });

    test('older than a week shows the date', () {
      final at = DateTime.utc(2026, 10, 3, 12);
      expect(feedTimeAgo(at, now: now), matches(RegExp(r'^Oct [23]$')));
    });

    test('a different year adds the year', () {
      final at = DateTime.utc(2025, 3, 10, 12);
      expect(feedTimeAgo(at, now: now), endsWith('2025'));
    });
  });

  test('feedMonthYear', () {
    expect(feedMonthYear(DateTime.utc(2026, 11, 12, 12)), 'Nov 2026');
  });

  group('FeedPost.canEditAt', () {
    FeedPost post({required bool mine, required Duration age}) => FeedPost(
      id: 'p',
      author: const FeedAuthor(
        userId: 'u',
        name: 'A',
        handle: 'a',
        photoUrl: '',
      ),
      topic: 'T',
      createdAt: now.subtract(age),
      body: 'b',
      isMine: mine,
    );

    test('own post inside the 15 minute window', () {
      expect(
        post(mine: true, age: const Duration(minutes: 14)).canEditAt(now),
        isTrue,
      );
    });

    test('own post past the window', () {
      expect(
        post(mine: true, age: const Duration(minutes: 16)).canEditAt(now),
        isFalse,
      );
    });

    test('someone else\'s post is never editable', () {
      expect(
        post(mine: false, age: const Duration(minutes: 1)).canEditAt(now),
        isFalse,
      );
    });
  });

  test('FeedPaged.next ignores the cursor on the last page', () {
    expect(
      const FeedPaged<int>(nextCursor: 'abc').next,
      isNull,
      reason: 'the server sends a cursor even when hasMore is false',
    );
    expect(
      const FeedPaged<int>(nextCursor: 'abc', hasMore: true).next,
      'abc',
    );
  });
}
