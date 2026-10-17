import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location_bloc.freezed.dart';

sealed class UserLocationEvent {
  const UserLocationEvent();
}

/// Page opened ([request] = true: may show the system prompt) or the app
/// came back from Settings ([request] = false).
final class LocationAccessCheckRequested extends UserLocationEvent {
  const LocationAccessCheckRequested({required this.request});
  final bool request;
}

final class LocationSettingsRequested extends UserLocationEvent {
  const LocationSettingsRequested();
}

@freezed
abstract class UserLocationState with _$UserLocationState {
  const factory UserLocationState({
    @Default(LocationAccess.checking) LocationAccess access,

    /// Where the map centres. [GeoPoint.fallback] until a fix arrives.
    @Default(GeoPoint.fallback) GeoPoint position,

    /// True once [position] is a real fix.
    @Default(false) bool hasFix,

    /// ISO code of the country at [position] (reverse geocoded) — drives
    /// the Distance tab's "Limit to only {country}". Null until known, or
    /// when the lookup fails (the toggle is hidden then).
    String? countryCode,
  }) = _UserLocationState;
}

/// Location is mandatory on the Location page: this drives the permission
/// gate and the distance map's centre.
class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  UserLocationBloc(this._repository) : super(const UserLocationState()) {
    // A check already in flight covers the next one (the system prompt
    // itself pauses/resumes the app on Android).
    on<LocationAccessCheckRequested>(_onCheck, transformer: droppable());
    on<LocationSettingsRequested>(
      (_, _) => state.access == LocationAccess.serviceOff
          ? _repository.openLocationSettings()
          : _repository.openAppSettings(),
      transformer: droppable(),
    );
  }

  final LocationRepository _repository;

  Future<void> _onCheck(
    LocationAccessCheckRequested event,
    Emitter<UserLocationState> emit,
  ) async {
    final access = await _repository.checkAccess(request: event.request);
    final wasGranted = state.access == LocationAccess.granted;
    emit(state.copyWith(access: access));
    if (access != LocationAccess.granted || (wasGranted && state.hasFix)) {
      return;
    }
    final position = await _repository.currentPosition();
    final fix = position.fold<GeoPoint?>(
      (_) => null, // keep the fallback centre
      (p) => p,
    );
    if (fix == null) return;
    emit(state.copyWith(position: fix, hasFix: true));
    final country = await _repository.countryCodeAt(fix);
    country.fold(
      (_) {}, // no toggle
      (code) => emit(state.copyWith(countryCode: code)),
    );
  }
}
