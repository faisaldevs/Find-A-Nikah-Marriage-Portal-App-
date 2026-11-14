import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';

/// `GET /v1/profiles/:userId` → [FeedMarriageProfile]. Lenient on purpose:
/// the server withholds locked sections (the keys vanish or are null), and
/// the response is shared with Marriage, so only what the Feed card draws
/// is read, each field defensively.
class FeedMarriageMapper {
  const FeedMarriageMapper(this.imageBaseUrl);

  final String imageBaseUrl;

  FeedMarriageProfile map(Map<String, dynamic> data, {DateTime? now}) {
    final profile = _map(data['profile']);
    final lifestyle = _map(profile['lifestyle']);
    final about = _map(profile['aboutYou']);
    final intentions = _map(profile['marriageIntentions']);
    final interests = _map(profile['interests']);

    final images = [
      ..._strings(profile['images']),
      if (_strings(profile['images']).isEmpty) ..._photoUrls(data['photos']),
    ];

    return FeedMarriageProfile(
      userId: data['userId'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      access: _access(_map(data['access'])),
      photos: [for (final i in images) resolveImageUrl(imageBaseUrl, i)],
      age: _age(profile, now ?? DateTime.now()),
      location: _text(profile['country']),
      isVerified: data['isVerified'] as bool? ?? false,
      height: _height(profile['heightCm']),
      maritalStatus: _token(profile['maritalStatus']),
      children: switch (about['haveChildren']) {
        true => 'Has children',
        false => 'No children',
        _ => null,
      },
      practice: _tokens(profile['religiousPractices']).firstOrNull,
      diet: switch (lifestyle['halalFood']) {
        true => 'Halal only',
        false => 'Not strictly halal',
        _ => null,
      },
      smoking: switch (lifestyle['smoking']) {
        true => 'Smokes',
        false => 'Doesn’t smoke',
        _ => null,
      },
      alcohol: switch (lifestyle['alcohol']) {
        true => 'Drinks alcohol',
        false => 'Doesn’t drink',
        _ => null,
      },
      faith: _tokens(profile['faith']),
      relocation: switch (about['relocateAbroad']) {
        true => 'Open to relocating',
        false => 'Not planning to relocate',
        _ => null,
      },
      interests: [
        for (final list in interests.values) ..._tokens(list),
      ],
      personality: _tokens(profile['personalityTraits']),
      education: _token(profile['educationLevel']),
      profession: _text(profile['professionTitle']),
      grewUpIn: _tokens(profile['grewUpIn']).firstOrNull,
      ethnicity: _tokens(profile['ethnicity']),
      languages: _tokens(profile['languages']),
      nationality: _tokens(profile['nationality']),
      bio: _text(profile['aboutMe']),
      gettingToKnow: _token(intentions['getToknowDuration']),
      marriageTimeline: _token(intentions['marriageTimeline']),
      isMatch: data['isMatch'] as bool? ?? false,
      matchId: data['matchId'] as String?,
    );
  }

  FeedMarriageAccess _access(Map<String, dynamic> a) => FeedMarriageAccess(
    // Missing = an older server without `access`: full. A level we don't
    // know is treated as partial, so the lock notice still shows.
    level: switch (a['level']) {
      null || 'full' => FeedMarriageAccessLevel.full,
      'locked' => FeedMarriageAccessLevel.locked,
      _ => FeedMarriageAccessLevel.partial,
    },
    reason: a['reason'] as String?,
    unlockable: a['unlockable'] as bool? ?? false,
    lockedSections: _strings(a['lockedSections']),
  );

  Map<String, dynamic> _map(Object? v) =>
      v is Map<String, dynamic> ? v : const {};

  List<String> _strings(Object? v) => v is List
      ? [
          for (final i in v)
            if (i is String && i.isNotEmpty) i,
        ]
      : const [];

  /// `photos` may hold URLs or `{url}` objects.
  List<String> _photoUrls(Object? v) => v is List
      ? [
          for (final i in v)
            if (i is String && i.isNotEmpty)
              i
            else if (i is Map && i['url'] is String)
              i['url'] as String,
        ]
      : const [];

  String? _text(Object? v) {
    final t = v is String ? v.trim() : null;
    return t == null || t.isEmpty ? null : t;
  }

  /// `never_married` → "Never married".
  String? _token(Object? v) {
    final t = _text(v);
    if (t == null) return null;
    final spaced = t.replaceAll('_', ' ');
    return spaced[0].toUpperCase() + spaced.substring(1);
  }

  List<String> _tokens(Object? v) => [
    for (final i in v is List ? v : const []) ?_token(i),
  ];

  int? _age(Map<String, dynamic> profile, DateTime now) {
    final age = profile['age'];
    if (age is int) return age;
    final dob = DateTime.tryParse(profile['dateOfBirth'] as String? ?? '');
    if (dob == null) return null;
    var years = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      years--;
    }
    return years;
  }

  String? _height(Object? cm) {
    if (cm is! num || cm <= 0) return null;
    final inches = cm / 2.54;
    final feet = inches ~/ 12;
    return "$feet'${(inches - feet * 12).round()}\" (${cm.round()} cm)";
  }
}
