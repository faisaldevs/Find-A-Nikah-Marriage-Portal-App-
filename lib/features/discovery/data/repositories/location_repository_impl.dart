import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/data/datasources/device_location_data_source.dart';
import 'package:find_a_nikah/features/discovery/domain/entities/discovery_filters.dart';
import 'package:find_a_nikah/features/discovery/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl(this._device, this._guard);

  final DeviceLocationDataSource _device;
  final Guard _guard;

  @override
  Future<LocationAccess> checkAccess({required bool request}) =>
      _device.checkAccess(request: request);

  @override
  Future<Either<Failure, GeoPoint>> currentPosition() =>
      _guard(_device.currentPosition);

  @override
  Future<void> openAppSettings() => _device.openAppSettings();

  @override
  Future<void> openLocationSettings() => _device.openLocationSettings();
}
