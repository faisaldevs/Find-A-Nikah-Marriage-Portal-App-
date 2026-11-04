import 'package:find_a_nikah/features/menu/domain/domain.dart';

// Choices for the Edit profile editors. Copied from onboarding
// (`wizard_options.dart`, `onboarding_option_tokens.dart`) because features
// can't import each other's presentation/data and onboarding stays
// untouched. Values here are what `/v1/profiles/me` stores, so an editor
// can pre-select the current value without converting it. Keep in sync
// with onboarding if its lists change.

/// One choice: [value] is sent to the API, [title] is shown.
class EditOption {
  const EditOption(this.value, this.title, [this.subtitle]);

  final String value;
  final String title;
  final String? subtitle;
}

const genderOptions = [
  EditOption('male', 'Male'),
  EditOption('female', 'Female'),
];

/// Same list as onboarding's Basic information (only `islam` confirmed).
const religionOptions = [
  EditOption('islam', 'Islam'),
  EditOption('christianity', 'Christianity'),
  EditOption('hinduism', 'Hinduism'),
  EditOption('buddhism', 'Buddhism'),
  EditOption('other', 'Other'),
];

/// Labels are stored as-is (`["English", "Bengali"]`).
const languageOptions = [
  'English',
  'Bengali',
  'Hindi',
  'Tamil',
  'Malay',
  'French',
  'Bahasa',
  'Spanish',
];

const maritalStatusOptions = [
  EditOption('never_married', 'Never married'),
  EditOption('divorced', 'Divorced'),
  EditOption('separated', 'Separated'),
  EditOption('annulled', 'Annulled'),
  EditOption('widowed', 'Widowed'),
  EditOption('married', 'Married'),
];

const educationOptions = [
  EditOption('high_school', 'High school'),
  EditOption('non_degree', 'Non-degree qualification'),
  EditOption('undergraduate', 'Undergraduate degree'),
  EditOption('postgraduate', 'Postgraduate degree'),
  EditOption('doctorate', 'Doctorate'),
  EditOption('other', 'Other education level'),
];

const religiousPracticeOptions = [
  EditOption(
    'strictly_practising',
    'Strictly practising',
    'I pray all the time, fast and adhere strictly to islamic tenets.',
  ),
  EditOption(
    'actively_practising',
    'Actively practising',
    'I try and make religious practice part of my daily life where I can.',
  ),
  EditOption(
    'occasionally_practising',
    'Occasionally practising',
    'I only practise during Ramadan/Eid and other special occasions',
  ),
  EditOption(
    'not_practising',
    'Not practising at all',
    "I'm culturally a Muslim but do not actively practice",
  ),
];

/// "I'd like to know someone for" — server tokens use a hyphen
/// (`3-4_months`), unlike onboarding's local values (`3_4_months`).
const getToKnowOptions = [
  EditOption('1-2_months', '1-2 months'),
  EditOption('3-4_months', '3-4 months'),
  EditOption('4-12_months', '4-12 months'),
  EditOption('1-2_years', '1-2 years'),
];

/// "I'd like to be married within".
const marriageTimelineOptions = [
  EditOption('1-2_months', '1-2 months'),
  EditOption('3-4_months', '3-4 months'),
  EditOption('4-12_months', '4-12 months'),
  EditOption('1-2_years', '1-2 years'),
  EditOption('3-4_years', '3-4 years'),
  EditOption('4_plus_years', '4+ years'),
  EditOption('agree_together', 'Agree together'),
];

/// Onboarding's rule: married-within must be at least two steps after
/// get-to-know (both lists share their first four steps), or "Agree
/// together".
bool timelineFits(String getToKnow, String marriageTimeline) {
  if (marriageTimeline == 'agree_together') return true;
  final know = getToKnowOptions.indexWhere((o) => o.value == getToKnow);
  final married = marriageTimelineOptions.indexWhere(
    (o) => o.value == marriageTimeline,
  );
  if (know == -1 || married == -1) return true;
  return married >= know + 2;
}

const professionOptions = [
  'Accountant',
  'Actor',
  'Administration Employee',
  'Air Hostess',
  'Architect',
  'Business Owner',
  'Consultant',
  'Dentist',
  'Doctor',
  'Engineer',
  'Entrepreneur',
  'Farmer',
  'Finance Professional',
  'Government Employee',
  'IT Professional',
  'Lawyer',
  'Lecturer',
  'Marketing Professional',
  'Nurse',
  'Pharmacist',
  'Pilot',
  'Police Officer',
  'Sales Professional',
  'Scientist',
  'Self-employed',
  'Student',
  'Teacher',
  'Unemployed',
];

/// Faith tags: backend token → label. Onboarding's "Prays 5 times a day"
/// is left out: it saves as `prays_on_time`, the same token as "Prays on
/// time" (ISS-007), so offering both here would show the wrong one ticked.
const faithOptions = [
  EditOption('charity_work', 'Charity Work'),
  EditOption('completed_hajj', 'Completed Hajj'),
  EditOption('completed_umrah', 'Completed Umrah'),
  EditOption('dawah', 'Dawah'),
  EditOption('dhikr', 'Dhikr'),
  EditOption('fasting', 'Fasting'),
  EditOption('fiqh', 'Fiqh'),
  EditOption('frequent_dua', 'Frequent Dua'),
  EditOption('friday_prayer', 'Friday Prayer'),
  EditOption('good_akhlaq', 'Good Akhlaq'),
  EditOption('hadith_learning', 'Hadith learning'),
  EditOption('islamic_lectures', 'Islamic lectures'),
  EditOption('learning_arabic', 'Learning Arabic'),
  EditOption('masjid_regularly', 'Masjid regularly'),
  EditOption('nafl_prayer', 'Nafl Prayers'),
  EditOption('prays_on_time', 'Prays on time'),
  EditOption('prays_a_few_times_a_day', 'Prays a few times a day'),
  EditOption('sadaqah', 'Sadaqah'),
  EditOption('reciting_quran', 'Reciting Quran'),
  EditOption('seerah_studies', 'Seerah Studies'),
  EditOption('quran_reading', 'Studied Quran'),
  EditOption('sunnah_prayers', 'Sunnah Prayers'),
  EditOption('tahajudd', 'Tahajjud'),
  EditOption('taraweeh', 'Taraweeh'),
];

const personalityOptions = [
  'Adventurous',
  'Ambitious',
  'Animal lover',
  'Cheerful',
  'Confident',
  'Conservative',
  'Creative',
  'Cultural',
  'Extroverted',
  'Family-oriented',
  'Fashionable',
  'Funny',
  'Generous',
  'Good with kids',
  'Introverted',
  'Open-minded',
  'Patient',
  'Positive',
  'Romantic',
  'Respectful',
];

/// Interest chips per category, with the heading onboarding shows.
/// Onboarding has no options for fashion / activities; whatever the
/// member already has there is kept and shown.
const interestOptions = <InterestCategory, (String, List<String>)>{
  InterestCategory.cultural: (
    'Arts & Culture',
    [
      'Movies',
      'Music',
      'Reading',
      'Photography',
      'Painting',
      'Theatre',
      'Museums',
      'Poetry',
      'Dancing',
      'Fashion',
    ],
  ),
  InterestCategory.foodDrinks: (
    'Food & Drink',
    [
      'Baking',
      'Sushi',
      'Vegan',
      'Coffee',
      'Tea',
      'Cooking',
      'Chocolate',
      'Eating out',
      'Vegetarian',
      'Fish & chips',
      'Healthy eating',
      'Junk food',
      'Meat lover',
      'Pizza',
    ],
  ),
  InterestCategory.sports: (
    'Sport',
    [
      'Football',
      'Surfing',
      'Badminton',
      'Basketball',
      'Cricket',
      'Boxing',
      'Cycling',
      'Tennis',
      'Rugby',
      'Dancing',
      'Volleyball',
      'Gym',
      'Horse Riding',
      'Mixed Martial Arts',
      'Running',
      'Yoga',
      'Swimming',
    ],
  ),
  InterestCategory.fashion: ('Fashion', []),
  InterestCategory.activities: ('Activities', []),
};

/// One row per inch, 4'0" → 7'3", like onboarding's Height page.
List<({int cm, String label})> buildHeightOptions() => [
  for (var inches = 48; inches <= 87; inches++)
    if ((inches * 2.54).round() case final cm)
      (cm: cm, label: '${cm}cm  •  ${_feetInches(cm)}'),
];

String _feetInches(int cm) {
  final totalInches = (cm / 2.54).round();
  return "${totalInches ~/ 12}' ${totalInches % 12}\"";
}

/// Faith / religious-practice / etc. limits, same as onboarding.
const maxFaithTags = 8;
const maxPersonalityTraits = 5;
const maxInterests = 15;
const maxNationalities = 2;
const minAge = 18;

/// Fewest photos a profile may have (onboarding asks for 3).
const minPhotos = 3;
