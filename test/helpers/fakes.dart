import 'dart:async';

import 'package:find_a_nikah/core/network/network.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/domain/domain.dart';
import 'package:find_a_nikah/features/onboarding/domain/domain.dart';
import 'package:mocktail/mocktail.dart';

/// Hand-written fakes for the layer below the class under test. Prefer
/// these over mocks; use mocktail only where call counts matter.

class SilentLogger implements Logger {
  @override
  void debug(String message) {}
  @override
  void info(String message) {}
  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {}
  @override
  void error(String message, Object error, StackTrace stackTrace) {}
}

class RecordingErrorReporter implements ErrorReporter {
  final errors = <Object>[];
  String? userId;

  @override
  Future<void> record(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
    String? reason,
  }) async => errors.add(error);

  @override
  Future<void> setUserId(String? anonymousId) async => userId = anonymousId;
}

Guard testGuard([ErrorReporter? reporter]) => Guard(
  reporter ?? RecordingErrorReporter(),
  translators: const [translateDioException],
);

class MemoryTokenStore implements TokenStore {
  AuthTokens? tokens;

  @override
  Future<void> clear() async => tokens = null;
  @override
  Future<AuthTokens?> read() async => tokens;
  @override
  Future<void> save(AuthTokens tokens) async => this.tokens = tokens;
}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSessionLifecycle extends Mock implements SessionLifecycle {}

class MockMarriageRepository extends Mock implements MarriageRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockPhotoPickerRepository extends Mock implements PhotoPickerRepository {}

/// [DiscoveryFiltersRepository] backed by a list, with a working stream.
class FakeDiscoveryFiltersRepository implements DiscoveryFiltersRepository {
  FakeDiscoveryFiltersRepository([this._current = const DiscoveryFilters()]);

  final _controller = StreamController<DiscoveryFilters>.broadcast();
  DiscoveryFilters _current;
  Failure? failNextSave;

  @override
  DiscoveryFilters get current => _current;

  @override
  Stream<DiscoveryFilters> watchFilters() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<Either<Failure, Unit>> save(DiscoveryFilters filters) async {
    final failure = failNextSave;
    if (failure != null) {
      failNextSave = null;
      return left(failure);
    }
    _current = filters;
    _controller.add(filters);
    return right(unit);
  }
}

/// [OnboardingDraftRepository] with a working stream.
class FakeOnboardingDraftRepository implements OnboardingDraftRepository {
  final _controller = StreamController<OnboardingData>.broadcast();
  OnboardingData _current = const OnboardingData();

  @override
  OnboardingData get current => _current;

  @override
  Stream<OnboardingData> watchDraft() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<Either<Failure, Unit>> save(OnboardingData draft) async {
    _current = draft;
    _controller.add(draft);
    return right(unit);
  }
}

/// Minimal valid profile for feed tests.
MarriageProfile testProfile(String id, {String? name, int age = 30}) =>
    MarriageProfile(
      id: id,
      name: name ?? 'Name $id',
      age: age,
      distanceKm: 5,
      area: 'Dhanmondi',
      country: 'Bangladesh',
      countryFlag: '🇧🇩',
      profession: 'Doctor',
      practice: 'Practising',
      ethnicity: 'Bangladeshi',
      ethnicityFlag: '🇧🇩',
      photoUrls: const ['https://example.com/1.jpg'],
      heightCm: 160,
      maritalStatus: 'Never Married',
      children: 'None',
      involveFamily: 'Immediately',
      chatFor: '1-2 months',
      marryWithin: '3-4 months',
      education: 'Degree',
      grewUpIn: 'Bangladesh',
      grewUpFlag: '🇧🇩',
      bio: 'Bio',
    );
