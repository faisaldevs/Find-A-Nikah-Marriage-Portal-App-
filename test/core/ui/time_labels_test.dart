import 'package:find_a_nikah/core/ui/text/time_labels.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 24, 15, 30);

  test('clock pads to HH:mm', () {
    expect(TimeLabels.clock(DateTime(2026, 1, 1, 9, 5)), '09:05');
  });

  test('day: Today · Yesterday · date', () {
    expect(TimeLabels.day(DateTime(2026, 10, 24, 0, 1), now: now), 'Today');
    expect(
      TimeLabels.day(DateTime(2026, 10, 23, 23, 59), now: now),
      'Yesterday',
    );
    expect(TimeLabels.day(DateTime(2026, 9, 3), now: now), '3 Sep 2026');
  });

  test('short: clock today, Yesterday, dd/MM/yy', () {
    expect(TimeLabels.short(DateTime(2026, 10, 24, 2, 11), now: now), '02:11');
    expect(TimeLabels.short(DateTime(2026, 10, 23), now: now), 'Yesterday');
    expect(TimeLabels.short(DateTime(2026, 3, 7), now: now), '07/03/26');
  });

  test('ago', () {
    expect(TimeLabels.ago(now, now: now), 'just now');
    expect(
      TimeLabels.ago(now.subtract(const Duration(minutes: 5)), now: now),
      '5m ago',
    );
    expect(
      TimeLabels.ago(now.subtract(const Duration(hours: 3)), now: now),
      '3h ago',
    );
    expect(TimeLabels.ago(DateTime(2026, 10, 23), now: now), 'Yesterday');
  });

  test('duration: mm:ss, h:mm:ss past an hour', () {
    expect(TimeLabels.duration(const Duration(seconds: 40)), '00:40');
    expect(
      TimeLabels.duration(const Duration(minutes: 2, seconds: 14)),
      '02:14',
    );
    expect(
      TimeLabels.duration(const Duration(hours: 1, minutes: 2, seconds: 3)),
      '1:02:03',
    );
  });
}
