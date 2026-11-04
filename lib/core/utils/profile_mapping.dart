import 'package:find_a_nikah/core/constants/countries.dart';

/// DTO → entity helpers shared by every feature that maps a backend
/// profile (Marriage cards, Explore sections). Raw backend codes become
/// display text here so widgets never see `never_married`.

/// `never_married` → `Never married`, `3-4_months` → `3-4 months`.
String labelFromCode(String? raw) {
  final v = raw?.trim() ?? '';
  if (v.isEmpty) return '';
  final words = v.replaceAll('_', ' ');
  return words[0].toUpperCase() + words.substring(1);
}

/// Countries come as names ("Bangladesh"); '' when not in our list.
String flagForCountryName(String countryName) {
  if (countryName.isEmpty) return '';
  final key = countryName.toLowerCase();
  for (final c in allCountries) {
    if (c.name.toLowerCase() == key) return c.flag;
  }
  return '';
}

/// Server-relative upload path (`/public/upload/x.jpg`) → absolute URL on
/// [base]. Already-absolute URLs pass through.
String resolveImageUrl(String base, String path) {
  if (path.startsWith('http')) return path;
  final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
  return '$b${path.startsWith('/') ? '' : '/'}$path';
}

/// True when the ISO-8601 [iso] timestamp is less than 24h before [now].
bool isActiveWithinADay(String? iso, DateTime now) {
  final at = iso == null ? null : DateTime.tryParse(iso);
  return at != null && now.difference(at).inHours < 24;
}
