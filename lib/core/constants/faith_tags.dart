/// Faith tags a member can pick, as the backend's `faith` values (token) and
/// the label shown for them. Shared by the Add filters screen.
typedef FaithTag = ({String token, String label});

const faithTags = <FaithTag>[
  (token: 'charity_work', label: 'Charity Work'),
  (token: 'completed_hajj', label: 'Completed Hajj'),
  (token: 'completed_umrah', label: 'Completed Umrah'),
  (token: 'dawah', label: 'Dawah'),
  (token: 'dhikr', label: 'Dhikr'),
  (token: 'fasting', label: 'Fasting'),
  (token: 'fiqh', label: 'Fiqh'),
  (token: 'frequent_dua', label: 'Frequent Dua'),
  (token: 'friday_prayer', label: 'Friday Prayer'),
  (token: 'good_akhlaq', label: 'Good Akhlaq'),
  (token: 'hadith_learning', label: 'Hadith learning'),
  (token: 'islamic_lectures', label: 'Islamic lectures'),
  (token: 'learning_arabic', label: 'Learning Arabic'),
  (token: 'masjid_regularly', label: 'Masjid regularly'),
  (token: 'nafl_prayer', label: 'Nafl Prayers'),
  (token: 'prays_on_time', label: 'Prays on time'),
  (token: 'prays_a_few_times_a_day', label: 'Prays a few times a day'),
  (token: 'sadaqah', label: 'Sadaqah'),
  (token: 'reciting_quran', label: 'Reciting Quran'),
  (token: 'seerah_studies', label: 'Seerah Studies'),
  (token: 'quran_reading', label: 'Studied Quran'),
  (token: 'sunnah_prayers', label: 'Sunnah Prayers'),
  (token: 'tahajudd', label: 'Tahajjud'),
  (token: 'taraweeh', label: 'Taraweeh'),
];
