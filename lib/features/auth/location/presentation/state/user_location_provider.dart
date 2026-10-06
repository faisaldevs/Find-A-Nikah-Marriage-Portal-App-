import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Dhaka — where the map lands when location is unavailable/denied, since
/// the launch market is Bangladesh (see `suggestedCountries`).
const kFallbackCenter = LatLng(23.8103, 90.4125);

/// One-shot device position for centring the distance map. Never throws:
/// permission denied / services off / timeout all resolve to
/// [kFallbackCenter] so the map still renders.
///
/// Requires `NSLocationWhenInUseUsageDescription` (iOS) and
/// `ACCESS_COARSE_LOCATION`/`ACCESS_FINE_LOCATION` (Android) — both added
/// alongside this feature.
final userLocationProvider = FutureProvider<LatLng>((ref) async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) return kFallbackCenter;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return kFallbackCenter;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        // City-level is plenty for a "within N miles" radius.
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 8),
      ),
    );
    return LatLng(position.latitude, position.longitude);
  } catch (_) {
    return kFallbackCenter;
  }
});
