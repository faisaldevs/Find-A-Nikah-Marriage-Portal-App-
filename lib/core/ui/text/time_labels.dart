/// Display text for timestamps in lists and threads. English only until
/// the l10n approach is decided (same as `FailureText`).
abstract final class TimeLabels {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// `14:05`.
  static String clock(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

  /// `Today` · `Yesterday` · `24 Oct 2026` — a thread's day divider.
  static String day(DateTime t, {DateTime? now}) {
    final days = _daysBetween(t, now ?? DateTime.now());
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return '${t.day} ${_months[t.month - 1]} ${t.year}';
  }

  /// `14:05` today · `Yesterday` · `24/10/26` — a list row's time.
  static String short(DateTime t, {DateTime? now}) {
    final days = _daysBetween(t, now ?? DateTime.now());
    if (days == 0) return clock(t);
    if (days == 1) return 'Yesterday';
    return '${_two(t.day)}/${_two(t.month)}/${_two(t.year % 100)}';
  }

  /// `just now` · `5m ago` · `3h ago` · `Yesterday` · `24 Oct 2026`.
  static String ago(DateTime t, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final diff = n.difference(t);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (_daysBetween(t, n) == 0) return '${diff.inHours}h ago';
    return day(t, now: n);
  }

  /// `00:40` · `02:14` · `1:02:14` — a call timer or call length.
  static String duration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return h > 0 ? '$h:${_two(m)}:${_two(s)}' : '${_two(m)}:${_two(s)}';
  }

  static int _daysBetween(DateTime a, DateTime b) => DateTime(
    b.year,
    b.month,
    b.day,
  ).difference(DateTime(a.year, a.month, a.day)).inDays;

  static String _two(int v) => v.toString().padLeft(2, '0');
}
