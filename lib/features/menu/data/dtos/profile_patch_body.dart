import 'package:find_a_nikah/features/menu/domain/domain.dart';

/// `PATCH /v1/profiles/me` body for [patch]. The only place that knows the
/// API's key names: the server silently ignores unknown keys (ISS-011), so
/// a typo here would look saved but be lost.
///
/// [imagePath] turns a full photo URL back into the stored relative path
/// (`/public/upload/…`).
Map<String, dynamic> profilePatchBody(
  ProfilePatch patch, {
  required String Function(String url) imagePath,
}) {
  final p = patch;
  return {
    'fullName': ?p.fullName,
    if (p.dateOfBirth case final d?) 'dateOfBirth': _isoDate(d),
    'gender': ?p.gender,
    'religion': ?p.religion,
    'languages': ?p.languages,
    'grewUpIn': ?p.grewUpIn,
    'heightCm': ?p.heightCm,
    'maritalStatus': ?p.maritalStatus,
    'aboutMe': ?p.bio,
    if (p.aboutYou case final a?)
      'aboutYou': {
        'bornMuslim': ?a.bornMuslim,
        'haveChildren': ?a.haveChildren,
        'relocateAbroad': ?a.relocateAbroad,
      },
    if (p.marriageIntentions case final m?)
      'marriageIntentions': {
        'getToknowDuration': m.getToKnow,
        'marriageTimeline': m.marriageTimeline,
      },
    'religiousPractices': ?p.religiousPractices,
    'faith': ?p.faith,
    if (p.lifestyle case final l?)
      'lifestyle': {
        'halalFood': ?l.halalFood,
        'smoking': ?l.smoking,
        'alcohol': ?l.alcohol,
      },
    if (p.interests case final i?)
      'interests': {
        for (final c in InterestCategory.values)
          interestKey(c): i[c] ?? const <String>[],
      },
    'personalityTraits': ?p.personalityTraits,
    'educationLevel': ?p.educationLevel,
    'professionTitle': ?p.profession,
    'ethnicity': ?p.ethnicity,
    'nationality': ?p.nationality,
    if (p.photoOrder case final o?) 'images': [for (final u in o) imagePath(u)],
  };
}

/// `profile.interests` key for [c].
String interestKey(InterestCategory c) => switch (c) {
  InterestCategory.cultural => 'cultural',
  InterestCategory.foodDrinks => 'foodDrinks',
  InterestCategory.sports => 'sports',
  InterestCategory.fashion => 'fashion',
  InterestCategory.activities => 'activities',
};

/// `yyyy-MM-dd`, the format onboarding's step 4 sends.
String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
