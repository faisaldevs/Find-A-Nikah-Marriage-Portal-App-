const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// "just now", "5m ago", "9h ago", "1 day ago", "3 days ago", then "Oct 3"
/// (with the year once it is not this year). Server times are UTC; this
/// compares absolute instants, so the device zone does not matter.
String feedTimeAgo(DateTime at, {DateTime? now}) {
  final diff = (now ?? DateTime.now()).toUtc().difference(at.toUtc());
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) {
    return diff.inDays == 1 ? '1 day ago' : '${diff.inDays} days ago';
  }
  final local = at.toLocal();
  final sameYear = local.year == (now ?? DateTime.now()).year;
  final day = '${_months[local.month - 1]} ${local.day}';
  return sameYear ? day : '$day, ${local.year}';
}

/// "Oct 2026".
String feedMonthYear(DateTime at) {
  final local = at.toLocal();
  return '${_months[local.month - 1]} ${local.year}';
}
