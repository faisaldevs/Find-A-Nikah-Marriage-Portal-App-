import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/entities/discovery_filters.dart';
import 'package:geolocator/geolocator.dart';

/// `geolocator` wrapper. Requires `NSLocationWhenInUseUsageDescription`
/// (iOS) and `ACCESS_COARSE_LOCATION` / `ACCESS_FINE_LOCATION` (Android).
///
/// Throws [DeviceException] when the platform call fails.
class DeviceLocationDataSource {
  const DeviceLocationDataSource();

  Future<LocationAccess> checkAccess({required bool request}) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return LocationAccess.serviceOff;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied && request) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always
          ? LocationAccess.granted
          : LocationAccess.denied;
    } on Object {
      // Plugin unavailable (e.g. tests) — treat as not granted.
      return LocationAccess.denied;
    }
  }

  Future<GeoPoint> currentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );
      return GeoPoint(position.latitude, position.longitude);
    } on Object catch (e) {
      throw DeviceException('location: ${e.runtimeType}');
    }
  }

  Future<void> openAppSettings() => Geolocator.openAppSettings();

  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
}
