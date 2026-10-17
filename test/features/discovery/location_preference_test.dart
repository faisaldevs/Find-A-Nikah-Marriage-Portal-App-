import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/data/data.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/discovery/presentation/bloc/discovery_filters_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fakes.dart';

class _MockRemote extends Mock implements DiscoveryRemoteDataSource {}

class _MockPreference extends Mock implements LocationPreferenceRepository {}

void main() {
  group('step 11 request body', () {
    test('country', () {
      expect(const LocationStepRequestDto(country: 'Bangladesh').toJson(), {
        'step': 11,
        'country': 'Bangladesh',
      });
    });

    test('coordinates + distance (miles)', () {
      expect(
        const LocationStepRequestDto(
          coordinates: LocationCoordinatesDto(
            longitude: 90.4125,
            latitude: 23.8103,
            distance: 50,
          ),
        ).toJson(),
        {
          'step': 11,
          'coordinates': {
            'longitude': 90.4125,
            'latitude': 23.8103,
            'distance': 50.0,
          },
        },
      );
    });
  });

  group('LocationPreferenceRepositoryImpl', () {
    late _MockRemote remote;
    late LocationPreferenceRepositoryImpl repo;

    setUpAll(() => registerFallbackValue(const LocationStepRequestDto()));

    setUp(() {
      remote = _MockRemote();
      repo = LocationPreferenceRepositoryImpl(remote, testGuard());
      when(() => remote.submitLocation(any())).thenAnswer((_) async {});
    });

    test('saveArea sends the point and the distance', () async {
      final result = await repo.saveArea(
        center: GeoPoint.fallback,
        distanceMiles: 120,
      );
      expect(result.isRight(), isTrue);
      final body =
          verify(() => remote.submitLocation(captureAny())).captured.single
              as LocationStepRequestDto;
      expect(body.toJson()['coordinates'], {
        'longitude': 90.4125,
        'latitude': 23.8103,
        'distance': 120.0,
      });
    });
  });

  group('DiscoveryFiltersBloc location save', () {
    late FakeDiscoveryFiltersRepository filters;
    late _MockPreference preference;
    late DiscoveryFiltersBloc bloc;

    setUpAll(() => registerFallbackValue(const GeoPoint(0, 0)));

    setUp(() {
      filters = FakeDiscoveryFiltersRepository();
      preference = _MockPreference();
      bloc = DiscoveryFiltersBloc(filters, MockAuthRepository(), preference)
        ..add(const DiscoveryFiltersSubscribed());
    });

    tearDown(() => bloc.close());

    Future<void> settle() =>
        Future<void>.delayed(const Duration(milliseconds: 5));

    test(
      'country: backend first, then applied locally → locationSaved',
      () async {
        when(
          () => preference.saveCountry(any()),
        ).thenAnswer((_) async => right(unit));

        bloc.add(const CountryFilterConfirmed('BD', countryName: 'Bangladesh'));
        await settle();

        verify(() => preference.saveCountry('Bangladesh')).called(1);
        expect(filters.current.countryCode, 'BD');
        expect(filters.current.locationMode, LocationFilterMode.country);
        expect(bloc.state.status, DiscoveryFiltersStatus.locationSaved);
      },
    );

    test('distance at max ("Everywhere") sends the max miles', () async {
      when(
        () => preference.saveArea(
          center: any(named: 'center'),
          distanceMiles: any(named: 'distanceMiles'),
        ),
      ).thenAnswer((_) async => right(unit));

      bloc.add(
        const DistanceFilterConfirmed(
          miles: kMaxDistanceMiles,
          limitToHomeCountry: false,
          center: GeoPoint(23.8, 90.4),
        ),
      );
      await settle();

      verify(
        () => preference.saveArea(
          center: const GeoPoint(23.8, 90.4),
          distanceMiles: kMaxDistanceMiles,
        ),
      ).called(1);
      expect(filters.current.locationMode, LocationFilterMode.distance);
      expect(bloc.state.status, DiscoveryFiltersStatus.locationSaved);
    });

    test('"Limit to only {country}" on → step 11 sends the country', () async {
      when(
        () => preference.saveCountry(any()),
      ).thenAnswer((_) async => right(unit));

      bloc.add(
        const DistanceFilterConfirmed(
          miles: 50,
          limitToHomeCountry: true,
          center: GeoPoint(23.8, 90.4),
          countryName: 'Bangladesh',
        ),
      );
      await settle();

      verify(() => preference.saveCountry('Bangladesh')).called(1);
      verifyNever(
        () => preference.saveArea(
          center: any(named: 'center'),
          distanceMiles: any(named: 'distanceMiles'),
        ),
      );
      expect(filters.current.limitToHomeCountry, isTrue);
      expect(bloc.state.status, DiscoveryFiltersStatus.locationSaved);
    });

    test('a failed save keeps the old filter and surfaces the error', () async {
      when(
        () => preference.saveCountry(any()),
      ).thenAnswer((_) async => left(const NetworkFailure()));

      bloc.add(const CountryFilterConfirmed('BD', countryName: 'Bangladesh'));
      await settle();

      expect(filters.current.locationMode, isNull);
      expect(bloc.state.status, DiscoveryFiltersStatus.failure);
      expect(bloc.state.failure, isA<NetworkFailure>());
    });
  });
}
