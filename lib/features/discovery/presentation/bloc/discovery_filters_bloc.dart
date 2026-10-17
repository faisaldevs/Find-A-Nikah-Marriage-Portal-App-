import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discovery_filters_bloc.freezed.dart';

sealed class DiscoveryFiltersEvent {
  const DiscoveryFiltersEvent();
}

final class DiscoveryFiltersSubscribed extends DiscoveryFiltersEvent {
  const DiscoveryFiltersSubscribed();
}

final class AgeRangeChanged extends DiscoveryFiltersEvent {
  const AgeRangeChanged(this.min, this.max);
  final int min;
  final int max;
}

/// Saved to the backend (step 11, coordinates) before it's applied.
final class DistanceFilterConfirmed extends DiscoveryFiltersEvent {
  const DistanceFilterConfirmed({
    required this.miles,
    required this.limitToHomeCountry,
    required this.center,
    this.countryName,
  });
  final double miles;
  final bool limitToHomeCountry;

  /// The member's position — sent as the point the radius is around.
  final GeoPoint center;

  /// The country the member is in ("Bangladesh"). With
  /// [limitToHomeCountry] on, step 11 sends this country instead of the
  /// coordinates.
  final String? countryName;
}

/// Saved to the backend (step 11, country) before it's applied.
final class CountryFilterConfirmed extends DiscoveryFiltersEvent {
  const CountryFilterConfirmed(this.countryCode, {required this.countryName});
  final String countryCode;

  /// As shown in the list ("Bangladesh") — what the backend stores.
  final String countryName;
}

final class LocationFilterCleared extends DiscoveryFiltersEvent {
  const LocationFilterCleared();
}

final class EthnicitiesChanged extends DiscoveryFiltersEvent {
  const EthnicitiesChanged(this.codes);
  final List<String> codes;
}

/// "Discover profiles": ends sign-up (first time) and enters the app.
final class DiscoverProfilesRequested extends DiscoveryFiltersEvent {
  const DiscoverProfilesRequested();
}

enum DiscoveryFiltersStatus {
  idle,
  submitting,
  failure,
  readyToDiscover,

  /// A location confirm is being saved to the backend.
  savingLocation,

  /// …and it succeeded — the Location page moves on.
  locationSaved,
}

@freezed
abstract class DiscoveryFiltersState with _$DiscoveryFiltersState {
  const factory DiscoveryFiltersState({
    @Default(DiscoveryFilters()) DiscoveryFilters filters,
    @Default(DiscoveryFiltersStatus.idle) DiscoveryFiltersStatus status,
    Failure? failure,
  }) = _DiscoveryFiltersState;
}

/// Page-scoped (Location, Add filters). Several instances stay in sync
/// because they all watch the same session repository.
class DiscoveryFiltersBloc
    extends Bloc<DiscoveryFiltersEvent, DiscoveryFiltersState> {
  DiscoveryFiltersBloc(this._filters, this._auth, this._locationPreference)
    : super(DiscoveryFiltersState(filters: _filters.current)) {
    on<DiscoveryFiltersSubscribed>(
      (_, emit) => emit.forEach<DiscoveryFilters>(
        _filters.watchFilters(),
        onData: (filters) => state.copyWith(filters: filters),
      ),
      transformer: restartable(),
    );
    // Edits are read-modify-write on the current filters: keep them ordered.
    on<AgeRangeChanged>(
      (e, emit) => _save(emit, state.filters.withAgeRange(e.min, e.max)),
      transformer: sequential(),
    );
    // Before step 11 existed, confirms only updated the local filters:
    // on<DistanceFilterConfirmed>(
    //   (e, emit) => _save(
    //     emit,
    //     state.filters.withDistance(
    //       miles: e.miles,
    //       limitToHomeCountry: e.limitToHomeCountry,
    //     ),
    //   ),
    //   transformer: sequential(),
    // );
    // on<CountryFilterConfirmed>(
    //   (e, emit) => _save(emit, state.filters.withCountry(e.countryCode)),
    //   transformer: sequential(),
    // );
    on<DistanceFilterConfirmed>(
      (e, emit) => _saveLocation(
        emit,
        remote: () => e.limitToHomeCountry && e.countryName != null
            ? _locationPreference.saveCountry(e.countryName!)
            : _locationPreference.saveArea(
                center: e.center,
                distanceMiles: e.miles.clamp(
                  kMinDistanceMiles,
                  kMaxDistanceMiles,
                ),
              ),
        local: () => state.filters.withDistance(
          miles: e.miles,
          limitToHomeCountry: e.limitToHomeCountry,
        ),
      ),
      transformer: droppable(),
    );
    on<CountryFilterConfirmed>(
      (e, emit) => _saveLocation(
        emit,
        remote: () => _locationPreference.saveCountry(e.countryName),
        local: () => state.filters.withCountry(e.countryCode),
      ),
      transformer: droppable(),
    );
    on<LocationFilterCleared>(
      (_, emit) => _save(emit, state.filters.withoutLocation()),
      transformer: sequential(),
    );
    on<EthnicitiesChanged>(
      (e, emit) => _save(emit, state.filters.withEthnicities(e.codes)),
      transformer: sequential(),
    );
    on<DiscoverProfilesRequested>(_onDiscover, transformer: droppable());
  }

  final DiscoveryFiltersRepository _filters;
  final AuthRepository _auth;
  final LocationPreferenceRepository _locationPreference;

  /// Backend first (step 11), then the local filters — so a failed save
  /// leaves the previous filter in place and the page doesn't move on.
  Future<void> _saveLocation(
    Emitter<DiscoveryFiltersState> emit, {
    required Future<Either<Failure, Unit>> Function() remote,
    required DiscoveryFilters Function() local,
  }) async {
    emit(
      state.copyWith(
        status: DiscoveryFiltersStatus.savingLocation,
        failure: null,
      ),
    );
    final saved = await remote();
    if (saved.isLeft()) {
      emit(
        state.copyWith(
          status: DiscoveryFiltersStatus.failure,
          failure: saved.getLeft().toNullable(),
        ),
      );
      return;
    }
    await _save(emit, local());
    if (state.status != DiscoveryFiltersStatus.failure) {
      emit(state.copyWith(status: DiscoveryFiltersStatus.locationSaved));
    }
  }

  Future<void> _save(
    Emitter<DiscoveryFiltersState> emit,
    DiscoveryFilters next,
  ) async {
    final result = await _filters.save(next);
    result.fold(
      (f) => emit(
        state.copyWith(status: DiscoveryFiltersStatus.failure, failure: f),
      ),
      // The watch stream delivers the saved value.
      (_) {},
    );
  }

  Future<void> _onDiscover(
    DiscoverProfilesRequested event,
    Emitter<DiscoveryFiltersState> emit,
  ) async {
    final status = _auth.currentStatus;
    final alreadyOnboarded =
        status is Authenticated && status.session.onboardingComplete;
    if (alreadyOnboarded) {
      emit(state.copyWith(status: DiscoveryFiltersStatus.readyToDiscover));
      return;
    }
    emit(state.copyWith(status: DiscoveryFiltersStatus.submitting));
    final result = await _auth.completeOnboarding();
    emit(
      result.fold(
        (f) => state.copyWith(
          status: DiscoveryFiltersStatus.failure,
          failure: f,
        ),
        (_) => state.copyWith(status: DiscoveryFiltersStatus.readyToDiscover),
      ),
    );
  }
}
