import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/discovery/presentation/bloc/user_location_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fakes.dart';

void main() {
  late MockLocationRepository repo;

  setUpAll(() => registerFallbackValue(GeoPoint.fallback));

  setUp(() {
    repo = MockLocationRepository();
    when(
      () => repo.checkAccess(request: any(named: 'request')),
    ).thenAnswer((_) async => LocationAccess.granted);
    when(
      repo.currentPosition,
    ).thenAnswer((_) async => right(const GeoPoint(51.5, -0.12)));
  });

  Future<UserLocationBloc> checked() async {
    final bloc = UserLocationBloc(repo)
      ..add(const LocationAccessCheckRequested(request: true));
    await Future<void>.delayed(const Duration(milliseconds: 5));
    return bloc;
  }

  test('after a fix, the country there is looked up', () async {
    when(() => repo.countryCodeAt(any())).thenAnswer((_) async => right('GB'));
    final bloc = await checked();
    expect(bloc.state.hasFix, isTrue);
    expect(bloc.state.countryCode, 'GB');
    verify(() => repo.countryCodeAt(const GeoPoint(51.5, -0.12))).called(1);
    await bloc.close();
  });

  test('a failed lookup leaves the country unknown (toggle hidden)', () async {
    when(
      () => repo.countryCodeAt(any()),
    ).thenAnswer((_) async => left(const DeviceFailure()));
    final bloc = await checked();
    expect(bloc.state.hasFix, isTrue);
    expect(bloc.state.countryCode, isNull);
    await bloc.close();
  });
}
