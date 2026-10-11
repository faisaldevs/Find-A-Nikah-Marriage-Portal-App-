/// Shared by the submission repository (forward: display → token) and the
/// profile repository (reverse: token → display) — single source of
/// truth. Duplicated
/// from (not imported by) `presentation/widgets/wizard_options.dart`
/// because `data/` can't import `presentation/`. Keep in sync if that
/// file's `interestCategories` changes.
const culturalTags = {
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
};
const foodDrinkTags = {
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
};
const sportTags = {
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
};

/// `faithTagOptions` (`onboarding/presentation/widgets/wizard_options.dart`)
/// display strings → the backend's snake_case enum, confirmed against its
/// own validation error message. Unmapped values pass through unchanged
/// (defensive — shouldn't happen since this covers every option in that
/// list).
const faithTagTokens = {
  'Charity Work': 'charity_work',
  'Completed Hajj': 'completed_hajj',
  'Completed Umrah': 'completed_umrah',
  'Dawah': 'dawah',
  'Dhikr': 'dhikr',
  'Fasting': 'fasting',
  'Fiqh': 'fiqh',
  'Frequent Dua': 'frequent_dua',
  'Friday Prayer': 'friday_prayer',
  'Good Akhlaq': 'good_akhlaq',
  'Hadith learning': 'hadith_learning',
  'Islamic lectures': 'islamic_lectures',
  'Learning Arabic': 'learning_arabic',
  'Masjid regularly': 'masjid_regularly',
  'Nafl Prayers': 'nafl_prayer',
  'Prays 5 times a day': 'prays_on_time',
  'Prays on time': 'prays_on_time',
  'Prays a few times a day': 'prays_a_few_times_a_day',
  'Sadaqah': 'sadaqah',
  'Reciting Quran': 'reciting_quran',
  'Seerah Studies': 'seerah_studies',
  'Studied Quran': 'quran_reading',
  'Sunnah Prayers': 'sunnah_prayers',
  'Tahajjud': 'tahajudd',
  'Taraweeh': 'taraweeh',
};

/// Reverse of [faithTagTokens]. `prays_on_time` has two display strings
/// mapping onto it ('Prays 5 times a day' / 'Prays on time') — the reverse
/// resolves to whichever was inserted last (defined order above), which is
/// fine for a best-effort prefill.
final Map<String, String> faithTagDisplayNames = {
  for (final entry in faithTagTokens.entries) entry.value: entry.key,
};
