import 'package:find_a_nikah/features/feed/data/dtos/feed_marriage_mapper.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = FeedMarriageMapper('https://img.example.com');
  final now = DateTime.utc(2026, 11, 14);

  // A full-access response, trimmed from the dev server.
  Map<String, dynamic> full() => {
    'userId': 'u1',
    'fullName': 'Chat TesterF',
    'isVerified': true,
    'profile': {
      'marriageIntentions': {
        'getToknowDuration': '1-2_years',
        'marriageTimeline': 'agree_together',
      },
      'lifestyle': {'halalFood': true, 'smoking': false, 'alcohol': false},
      'aboutYou': {
        'bornMuslim': true,
        'haveChildren': false,
        'relocateAbroad': true,
      },
      'interests': {
        'cultural': ['poetry'],
        'foodDrinks': ['tea_lover'],
        'sports': <Object?>[],
      },
      'country': 'Bangladesh',
      'dateOfBirth': '1999-05-09T00:00:00.000Z',
      'age': 27,
      'maritalStatus': 'never_married',
      'religiousPractices': ['actively_practising'],
      'languages': ['English'],
      'ethnicity': <Object?>[],
      'educationLevel': 'undergraduate',
      'professionTitle': 'Consultant',
      'aboutMe': 'Test account for chat checks only.',
      'images': ['/public/upload/a.jpg', '/public/upload/b.jpg'],
      'heightCm': 165,
    },
    'photos': <Object?>[],
    'isMatch': true,
    'matchId': 'm1',
    'access': {
      'level': 'full',
      'reason': null,
      'unlockable': false,
      'lockedSections': <Object?>[],
    },
  };

  test('maps a full profile to display text', () {
    final p = mapper.map(full(), now: now);

    expect(p.fullName, 'Chat TesterF');
    expect(p.firstName, 'Chat');
    expect(p.age, 27);
    expect(p.location, 'Bangladesh');
    expect(p.maritalStatus, 'Never married');
    expect(p.practice, 'Actively practising');
    expect(p.children, 'No children');
    expect(p.diet, 'Halal only');
    expect(p.smoking, 'Doesn’t smoke');
    expect(p.relocation, 'Open to relocating');
    expect(p.education, 'Undergraduate');
    expect(p.profession, 'Consultant');
    expect(p.gettingToKnow, '1-2 years');
    expect(p.marriageTimeline, 'Agree together');
    expect(p.interests, ['Poetry', 'Tea lover']);
    expect(p.height, '5\'5" (165 cm)');
    expect(p.photos, [
      'https://img.example.com/public/upload/a.jpg',
      'https://img.example.com/public/upload/b.jpg',
    ]);
    expect(p.isMatch, isTrue);
    expect(p.access.isFull, isTrue);
  });

  test('age falls back to the date of birth', () {
    final data = full();
    (data['profile'] as Map<String, dynamic>).remove('age');

    expect(mapper.map(data, now: now).age, 27);
  });

  test('a partial profile: withheld sections are simply absent', () {
    // The server removes `marriageIntentions` and `partnerPreference`.
    final data = full();
    (data['profile'] as Map<String, dynamic>).remove('marriageIntentions');
    data['access'] = {
      'level': 'partial',
      'reason': 'NOT_ELIGIBLE',
      'unlockable': false,
      'lockedSections': ['marriageIntentions', 'partnerPreference'],
    };

    final p = mapper.map(data, now: now);

    expect(p.access.level, FeedMarriageAccessLevel.partial);
    expect(p.access.reason, 'NOT_ELIGIBLE');
    expect(p.access.lockedSections, [
      'marriageIntentions',
      'partnerPreference',
    ]);
    expect(p.gettingToKnow, isNull);
    expect(p.marriageTimeline, isNull);
    expect(p.fullName, 'Chat TesterF', reason: 'visible parts still map');
  });

  test('a fully locked profile maps with nothing but the access', () {
    final p = mapper.map({
      'userId': 'u2',
      'fullName': '',
      'profile': null,
      'photos': null,
      'access': {
        'level': 'locked',
        'reason': 'PREMIUM_REQUIRED',
        'unlockable': true,
        'lockedSections': ['photos', 'marriageIntentions'],
      },
    });

    expect(p.access.level, FeedMarriageAccessLevel.locked);
    expect(p.access.unlockable, isTrue);
    expect(p.photos, isEmpty);
    expect(p.age, isNull);
    expect(p.interests, isEmpty);
  });

  test('an unknown access level is treated as partial, not full', () {
    final data = full()..['access'] = {'level': 'something-new', 'reason': 'X'};

    final access = mapper.map(data, now: now).access;

    expect(access.level, FeedMarriageAccessLevel.partial);
    expect(access.reason, 'X');
  });

  test('a response without `access` (older server) is full', () {
    final data = full()..remove('access');

    expect(mapper.map(data, now: now).access.isFull, isTrue);
  });
}
