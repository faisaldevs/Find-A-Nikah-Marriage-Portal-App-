import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const filters = DiscoveryFilters();

  test('defaults: any age, no location filter, everywhere', () {
    expect(filters.isAnyAge, isTrue);
    expect(filters.hasLocationFilter, isFalse);
    expect(filters.isEverywhere, isTrue);
  });

  group('withAgeRange', () {
    test('sets bounds inside the allowed range', () {
      final f = filters.withAgeRange(25, 35);
      expect((f.minAge, f.maxAge), (25, 35));
      expect(f.isAnyAge, isFalse);
    });

    test('rejects bounds outside the range or inverted', () {
      expect(() => filters.withAgeRange(kMinAge - 1, 30), throwsArgumentError);
      expect(() => filters.withAgeRange(20, kMaxAge + 1), throwsArgumentError);
      expect(() => filters.withAgeRange(40, 30), throwsArgumentError);
    });
  });

  test('distance replaces a country filter and clamps the radius', () {
    final f = filters
        .withCountry('PK')
        .withDistance(
          miles: 9999,
          limitToHomeCountry: true,
          homeCountryCode: 'BD',
        );
    expect(f.locationMode, LocationFilterMode.distance);
    expect(f.homeCountryCode, 'BD');
    expect(f.countryCode, isNull);
    expect(f.distanceMiles, kMaxDistanceMiles);
    expect(f.limitToHomeCountry, isTrue);
  });

  test('limit to home country needs a known country', () {
    final f = filters.withDistance(miles: 50, limitToHomeCountry: true);
    expect(f.limitToHomeCountry, isFalse);
    expect(f.homeCountryCode, isNull);
  });

  test('faiths and city are set, cleared and kept by withoutLocation', () {
    final f = filters.withFaiths(['dhikr']).withCity('  Dhaka ');
    expect(f.faiths, ['dhikr']);
    expect(f.city, 'Dhaka');
    final cleared = f.withoutLocation();
    expect(cleared.faiths, ['dhikr']);
    expect(cleared.city, 'Dhaka');
    expect(f.withCity('  ').city, isNull);
  });

  test('country replaces distance but keeps the slider position', () {
    final f = filters
        .withDistance(miles: 50, limitToHomeCountry: false)
        .withCountry('BD');
    expect(f.locationMode, LocationFilterMode.country);
    expect(f.countryCode, 'BD');
    expect(f.distanceMiles, 50);
  });

  test('withoutLocation resets the distance draft to Everywhere', () {
    final f = filters
        .withDistance(miles: 30, limitToHomeCountry: true)
        .withoutLocation();
    expect(f.hasLocationFilter, isFalse);
    expect(f.isEverywhere, isTrue);
    expect(f.limitToHomeCountry, isFalse);
  });

  test('ethnicities are stored unmodifiable', () {
    final f = filters.withEthnicities(['BD', 'PK']);
    expect(f.ethnicities, ['BD', 'PK']);
    expect(() => f.ethnicities.add('IN'), throwsUnsupportedError);
  });
}
