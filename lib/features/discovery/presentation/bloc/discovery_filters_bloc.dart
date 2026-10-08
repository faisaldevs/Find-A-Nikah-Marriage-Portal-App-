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

final class DistanceFilterConfirmed extends DiscoveryFiltersEvent {
  const DistanceFilterConfirmed({
    required this.miles,
    required this.limitToHomeCountry,
  });
  final double miles;
  final bool limitToHomeCountry;
}

final class CountryFilterConfirmed extends DiscoveryFiltersEvent {
  const CountryFilterConfirmed(this.countryCode);
  final String countryCode;
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

enum DiscoveryFiltersStatus { idle, submitting, failure, readyToDiscover }

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
  DiscoveryFiltersBloc(this._filters, this._auth)
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
    on<DistanceFilterConfirmed>(
      (e, emit) => _save(
        emit,
        state.filters.withDistance(
          miles: e.miles,
          limitToHomeCountry: e.limitToHomeCountry,
        ),
      ),
      transformer: sequential(),
    );
    on<CountryFilterConfirmed>(
      (e, emit) => _save(emit, state.filters.withCountry(e.countryCode)),
      transformer: sequential(),
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
