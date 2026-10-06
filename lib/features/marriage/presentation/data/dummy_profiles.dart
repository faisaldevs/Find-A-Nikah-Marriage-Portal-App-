import '../state/marriage_profile.dart';

/// Placeholder photo from an online avatar service (needs internet). The
/// service's images are random stock portraits — swap for real profile
/// photos when the discovery API exists.
String _photo(int id) => 'https://i.pravatar.cc/800?img=$id';

/// Dummy feed for the UI-only Marriage tab. Not filtered — the filters
/// only restart the feed until the discovery API applies them server-side.
const _bd = '🇧🇩';

/// Detail sections shared by every dummy profile (only the hero differs) —
/// enough to fill the full-profile layout.
const _bio =
    "I'm someone who enjoys meeting new people and become quite outgoing "
    'once I feel a genuine connection. Family is one of the most important '
    'parts of my life, and I hope to build a loving, supportive home based '
    'on mutual respect and Islamic values.   I enjoy growing personally, '
    'professionally, and spiritually, and I appreciate a partner who '
    'believes that marriage is a partnership where we encourage each other '
    'to become better in every aspect of life. I value kindness, honesty, '
    'and open communication.\n'
    '\n'
    'A few facts about me:\n'
    '\n'
    '• Tea enthusiast\n'
    '• Sea beach lover\n'
    '• Love cats and puppies, as long as they belong to someone else\n'
    "• I like to mind my own business, and I don't like people who are nosy\n"
    "• I'm always busy working hard to become better in every important "
    'area of life: my religion, work, and my home\n'
    "• Working remotely gives me much more flexibility, so I'm currently "
    'learning to swim\n'
    '\n'
    "I'm looking for someone who wants a peaceful, happy marriage, values "
    "family, and is excited to grow together through life's successes and "
    'challenges.';

MarriageProfile _profile({
  required String id,
  required String name,
  required int age,
  required double distanceKm,
  required String area,
  required String profession,
  required String practice,
  required List<String> photoUrls,
  bool isVerified = false,
  bool isActiveToday = false,
  bool isPremium = false,
}) => MarriageProfile(
  id: id,
  name: name,
  age: age,
  distanceKm: distanceKm,
  area: area,
  country: 'Bangladesh',
  countryFlag: _bd,
  profession: profession,
  practice: practice,
  ethnicity: 'Bangladeshi',
  ethnicityFlag: _bd,
  photoUrls: photoUrls,
  isVerified: isVerified,
  isActiveToday: isActiveToday,
  isPremium: isPremium,
  similarities: const ['Grew up in Bangladesh'],
  heightCm: 158,
  maritalStatus: 'Never Married',
  children: 'Doesn’t have children',
  involveFamily: 'Immediately',
  chatFor: '1-2 months',
  marryWithin: '3-4 months',
  faith: const [
    'Charity Work',
    'Learning Arabic',
    'Hadith learning',
    'Prays 5 times a day',
    'Islamic lectures',
    'Tahajudd',
    'Prays on time',
    'Nafl Prayers',
    'Seerah Studies',
  ],
  futurePlans: const [
    'Wants children',
    'Open to relocate globally',
    'Not open to polygamy',
  ],
  interests: const [
    'Cooking',
    'Tea',
    'Family-oriented',
    'Open-minded',
    'Animal lover',
    'Eating out',
    'Meat lover',
    'Chocolate',
    'Gym',
    'Running',
  ],
  personality: const [
    'Ambitious',
    'Animal lover',
    'Family-oriented',
    'Funny',
    'Romantic',
  ],
  education: 'Undergraduate degree',
  languages: const ['English', 'Bengali', 'Hindi'],
  grewUpIn: 'Bangladesh',
  grewUpFlag: _bd,
  bio: _bio,
  isPhotoVerified: isVerified,
  isAgeVerified: isVerified,
  isIdVerified: isVerified,
);

final dummyMarriageProfiles = <MarriageProfile>[
  _profile(
    id: 'p1',
    name: 'Tabassum',
    age: 31,
    distanceKm: 3,
    area: 'Mohakhali',
    profession: 'Teacher',
    practice: 'Actively practising',
    photoUrls: [_photo(47), _photo(45), _photo(44), _photo(43), _photo(41)],
    isVerified: true,
    isActiveToday: true,
    isPremium: true,
  ),
  _profile(
    id: 'p2',
    name: 'Nusrat',
    age: 27,
    distanceKm: 5,
    area: 'Dhanmondi',
    profession: 'Doctor',
    practice: 'Practising',
    photoUrls: [_photo(49), _photo(48), _photo(39), _photo(38), _photo(36)],
    isVerified: true,
    isActiveToday: true,
  ),
  _profile(
    id: 'p3',
    name: 'Ayesha',
    age: 29,
    distanceKm: 8,
    area: 'Gulshan',
    profession: 'Software engineer',
    practice: 'Actively practising',
    photoUrls: [_photo(32), _photo(31), _photo(29), _photo(28), _photo(27)],
    isPremium: true,
  ),
  _profile(
    id: 'p4',
    name: 'Farzana',
    age: 25,
    distanceKm: 12,
    area: 'Uttara',
    profession: 'Architect',
    practice: 'Moderately practising',
    photoUrls: [_photo(26), _photo(25), _photo(24), _photo(23), _photo(21)],
    isVerified: true,
  ),
  _profile(
    id: 'p5',
    name: 'Sadia',
    age: 33,
    distanceKm: 20,
    area: 'Mirpur',
    profession: 'Accountant',
    practice: 'Practising',
    photoUrls: [_photo(20), _photo(16), _photo(10), _photo(9), _photo(5)],
    isActiveToday: true,
  ),
];
