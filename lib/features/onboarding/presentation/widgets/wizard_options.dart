/// A single choice in a single-select radio list, with an optional
/// description line shown under the title (account type, intentions, etc).
class WizardOption {
  const WizardOption(this.value, this.title, [this.subtitle]);

  final String value;
  final String title;
  final String? subtitle;
}

const accountTypeOptions = [
  WizardOption(
    'individual',
    'Individual account for yourself',
    'Create and manage your own matrimonial profile.',
  ),
  WizardOption(
    'family',
    'Family account for a family member',
    'Create and manage a profile on behalf of your son, daughter or '
        'another family member.',
  ),
];

const lookingForIntentOptions = [
  WizardOption('know_first', 'I want to get to know someone first'),
  WizardOption('ready_soon', "I'm ready to get married soon"),
  WizardOption('curious', "I'm just curious about Find A Nikah"),
];

/// Religion dropdown on Basic Information. Values are a best guess pending
/// confirmation of the backend's accepted set — only `islam` is confirmed
/// (from the API example).
const religionOptions = [
  WizardOption('islam', 'Islam'),
  WizardOption('christianity', 'Christianity'),
  WizardOption('hinduism', 'Hinduism'),
  WizardOption('buddhism', 'Buddhism'),
  WizardOption('other', 'Other'),
];

/// Language multi-select on Basic Information. Not currently sent to the
/// backend — no field name confirmed yet — captured locally only.
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

/// Values confirmed against the backend's `referralSource` validation error
/// (`social_media, friend_or_family, influencer, ai_recommendation,
/// success_couple, google_play_store, apple_app_store, advertisement,
/// other`) — the app offers a subset of the accepted values.
const howHeardOptions = [
  WizardOption('social_media', 'Social Media'),
  WizardOption('friend_or_family', 'Friends or Family'),
  WizardOption('influencer', 'Influencer'),
  WizardOption('ai_recommendation', 'AI recommendation'),
  WizardOption('success_couple', 'I know a success couple'),
  WizardOption('google_play_store', 'Google play store'),
];

const educationOptions = [
  WizardOption('high_school', 'High school'),
  WizardOption('non_degree', 'Non-degree qualification'),
  WizardOption('undergraduate', 'Undergraduate degree'),
  WizardOption('postgraduate', 'Postgraduate degree'),
  WizardOption('doctorate', 'Doctorate'),
  WizardOption('other', 'Other education level'),
];

const maritalStatusOptions = [
  WizardOption('never_married', 'Never married'),
  WizardOption('divorced', 'Divorced'),
  WizardOption('separated', 'Separated'),
  WizardOption('annulled', 'Annulled'),
  WizardOption('widowed', 'Widowed'),
  WizardOption('married', 'Married'),
];

const religionPracticeOptions = [
  WizardOption(
    'strictly_practising',
    'Strictly practising',
    'I pray all the time, fast and adhere strictly to islamic tenets.',
  ),
  WizardOption(
    'actively_practising',
    'Actively practising',
    'I try and make religious practice part of my daily life where I can.',
  ),
  WizardOption(
    'occasionally_practising',
    'Occasionally practising',
    'I only practise during Ramadan/Eid and other special occasions',
  ),
  WizardOption(
    'not_practising',
    'Not practising at all',
    "I'm culturally a Muslim but do not actively practice",
  ),
];

const durationOptions = [
  WizardOption('1_2_months', '1-2 months'),
  WizardOption('3_4_months', '3-4 months'),
  WizardOption('4_12_months', '4-12 months'),
  WizardOption('1_2_years', '1-2 years'),
];

const marriedWithinOptions = [
  WizardOption('1_2_months', '1-2 months'),
  WizardOption('3_4_months', '3-4 months'),
  WizardOption('4_12_months', '4-12 months'),
  WizardOption('1_2_years', '1-2 years'),
  WizardOption('3_4_years', '3-4 years'),
  WizardOption('4_plus_years', '4+ years'),
  WizardOption('agree_together', 'Agree together'),
];

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

const faithTagOptions = [
  'Charity Work',
  'Completed Hajj',
  'Completed Umrah',
  'Dawah',
  'Dhikr',
  'Fasting',
  'Fiqh',
  'Frequent Dua',
  'Friday Prayer',
  'Good Akhlaq',
  'Hadith learning',
  'Islamic lectures',
  'Learning Arabic',
  'Masjid regularly',
  'Nafl Prayers',
  'Prays 5 times a day',
  'Prays on time',
  'Prays a few times a day',
  'Sadaqah',
  'Reciting Quran',
  'Seerah Studies',
  'Studied Quran',
  'Sunnah Prayers',
  'Tahajjud',
  'Taraweeh',
];

const personalityTraitOptions = [
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

/// Interest tags grouped by category, per the design. Note: the "Arts &
/// Culture" tags in the source mockup were a copy/paste of the Personality
/// screen's traits (Ambitious, Conservative, etc.) — clearly placeholder
/// content left over in the design file, not real interests. Replaced here
/// with actual arts/culture interests; "Food & Drink" and "Sport" are taken
/// verbatim from the mockup.
const interestCategories = {
  'Arts & Culture': [
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
  'Food & Drink': [
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
  'Sport': [
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
};

/// Height list: 122cm-220cm, per the design's discrete-list (not slider)
/// pattern. Label matches "XXXcm • X'X\"" exactly as shown.
List<({int cm, String label})> buildHeightOptions() {
  return [
    for (var cm = 122; cm <= 220; cm++)
      (cm: cm, label: '${cm}cm • ${_feetInches(cm)}'),
  ];
}

String _feetInches(int cm) {
  final totalInches = (cm / 2.54).round();
  final feet = totalInches ~/ 12;
  final inches = totalInches % 12;
  return "$feet' $inches\"";
}
