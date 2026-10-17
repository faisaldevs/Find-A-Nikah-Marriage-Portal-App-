// Single-value formatters (`MenuFormat.yesNo(profile.bornMuslim)`), not
// boolean flags — a named parameter would only add noise.
// ignore_for_file: avoid_positional_boolean_parameters

import 'package:find_a_nikah/features/menu/domain/domain.dart';

/// Display text for [MyProfile]'s raw backend values. Null = not filled in
/// (the row then shows "Complete your profile").
abstract final class MenuFormat {
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// `never_married` → `Never married`, `1-2_months` → `1-2 months`.
  static String? token(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final words = raw.trim().replaceAll('_', ' ');
    return words[0].toUpperCase() + words.substring(1);
  }

  /// `11 June, 2000`.
  static String? date(DateTime? d) =>
      d == null ? null : '${d.day} ${_months[d.month - 1]}, ${d.year}';

  /// `160cm (5' 3")`.
  static String? height(int? cm) {
    if (cm == null || cm <= 0) return null;
    final totalInches = (cm / 2.54).round();
    return '${cm}cm (${totalInches ~/ 12}\' ${totalInches % 12}")';
  }

  /// `Cycling, Dancing, Gymnastics and 1 other`.
  static String? list(List<String> items, {int show = 3}) {
    final clean = [
      for (final i in items)
        if (i.trim().isNotEmpty) token(i)!,
    ];
    if (clean.isEmpty) return null;
    if (clean.length <= show) return clean.join(', ');
    final rest = clean.length - show;
    return '${clean.take(show).join(', ')} and $rest '
        '${rest == 1 ? 'other' : 'others'}';
  }

  static String? yesNo(bool? v) => v == null ? null : (v ? 'Yes' : 'No');

  static String? children(bool? v) =>
      v == null ? null : (v ? 'Has children' : 'Doesn’t have children');

  static String? relocation(bool? v) =>
      v == null ? null : (v ? 'Will move abroad' : 'Won’t move abroad');

  static String? diet(bool? halalOnly) => halalOnly == null
      ? null
      : (halalOnly ? 'Only eats Halal food' : 'Doesn’t only eat Halal food');

  static String? alcohol(bool? drinks) =>
      drinks == null ? null : (drinks ? 'Drinks' : 'Doesn’t drink');

  static String? smoking(bool? smokes) =>
      smokes == null ? null : (smokes ? 'Smoker' : 'Non-smoker');

  static String? text(String? v) =>
      v == null || v.trim().isEmpty ? null : v.trim();
}
