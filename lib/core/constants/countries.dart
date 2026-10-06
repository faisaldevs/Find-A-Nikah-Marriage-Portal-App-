/// A country entry for the nationality/grew-up/ethnicity pickers.
class Country {
  const Country(this.code, this.name, this.flag);

  final String code;
  final String name;
  final String flag;
}

/// Shown above the alphabetical list on the country pickers, per design —
/// a small "likely relevant to you" shortlist ahead of the full list.
const suggestedCountries = [Country('BD', 'Bangladesh', '🇧🇩')];

/// Not exhaustive (~60 countries) — enough for real search/select UX without
/// hand-maintaining all 195 ISO countries; extend as needed.
const allCountries = [
  Country('AF', 'Afghanistan', '🇦🇫'),
  Country('AZ', 'Azerbaijan', '🇦🇿'),
  Country('MY', 'Malaysia', '🇲🇾'),
  Country('PK', 'Pakistan', '🇵🇰'),
  Country('TR', 'Turkey', '🇹🇷'),
  Country('LK', 'Sri Lanka', '🇱🇰'),
  Country('TJ', 'Tajikistan', '🇹🇯'),
  Country('BD', 'Bangladesh', '🇧🇩'),
  Country('IN', 'India', '🇮🇳'),
  Country('ID', 'Indonesia', '🇮🇩'),
  Country('EG', 'Egypt', '🇪🇬'),
  Country('SA', 'Saudi Arabia', '🇸🇦'),
  Country('AE', 'United Arab Emirates', '🇦🇪'),
  Country('QA', 'Qatar', '🇶🇦'),
  Country('KW', 'Kuwait', '🇰🇼'),
  Country('JO', 'Jordan', '🇯🇴'),
  Country('LB', 'Lebanon', '🇱🇧'),
  Country('IQ', 'Iraq', '🇮🇶'),
  Country('IR', 'Iran', '🇮🇷'),
  Country('SY', 'Syria', '🇸🇾'),
  Country('YE', 'Yemen', '🇾🇪'),
  Country('OM', 'Oman', '🇴🇲'),
  Country('MA', 'Morocco', '🇲🇦'),
  Country('DZ', 'Algeria', '🇩🇿'),
  Country('TN', 'Tunisia', '🇹🇳'),
  Country('LY', 'Libya', '🇱🇾'),
  Country('SD', 'Sudan', '🇸🇩'),
  Country('SO', 'Somalia', '🇸🇴'),
  Country('NG', 'Nigeria', '🇳🇬'),
  Country('KE', 'Kenya', '🇰🇪'),
  Country('GB', 'United Kingdom', '🇬🇧'),
  Country('US', 'United States', '🇺🇸'),
  Country('CA', 'Canada', '🇨🇦'),
  Country('AU', 'Australia', '🇦🇺'),
  Country('FR', 'France', '🇫🇷'),
  Country('DE', 'Germany', '🇩🇪'),
  Country('NL', 'Netherlands', '🇳🇱'),
  Country('SE', 'Sweden', '🇸🇪'),
  Country('IT', 'Italy', '🇮🇹'),
  Country('ES', 'Spain', '🇪🇸'),
  Country('KZ', 'Kazakhstan', '🇰🇿'),
  Country('UZ', 'Uzbekistan', '🇺🇿'),
  Country('KG', 'Kyrgyzstan', '🇰🇬'),
  Country('TM', 'Turkmenistan', '🇹🇲'),
  Country('AL', 'Albania', '🇦🇱'),
  Country('BA', 'Bosnia and Herzegovina', '🇧🇦'),
  Country('XK', 'Kosovo', '🇽🇰'),
  Country('MV', 'Maldives', '🇲🇻'),
  Country('BN', 'Brunei', '🇧🇳'),
  Country('SG', 'Singapore', '🇸🇬'),
  Country('ZA', 'South Africa', '🇿🇦'),
  Country('GY', 'Guyana', '🇬🇾'),
  Country('TT', 'Trinidad and Tobago', '🇹🇹'),
];
