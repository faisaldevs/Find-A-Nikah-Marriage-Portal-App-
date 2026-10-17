import 'package:json_annotation/json_annotation.dart';

part 'location_step_request.g.dart';

/// `PATCH /v1/onboarding/step`, step 11 — exactly one of [country] /
/// [coordinates]:
/// `{"step": 11, "country": "Bangladesh"}` or
/// `{"step": 11, "coordinates": {"longitude", "latitude", "distance"}}`.
@JsonSerializable(
  createFactory: false,
  includeIfNull: false,
  explicitToJson: true,
)
class LocationStepRequestDto {
  const LocationStepRequestDto({
    this.country,
    this.coordinates,
    this.step = 11,
  });

  final int step;
  final String? country;
  final LocationCoordinatesDto? coordinates;

  Map<String, dynamic> toJson() => _$LocationStepRequestDtoToJson(this);
}

@JsonSerializable(createFactory: false)
class LocationCoordinatesDto {
  const LocationCoordinatesDto({
    required this.longitude,
    required this.latitude,
    required this.distance,
  });

  final double longitude;
  final double latitude;

  /// Miles (confirmed with the backend — same unit as the app's slider).
  final double distance;

  Map<String, dynamic> toJson() => _$LocationCoordinatesDtoToJson(this);
}
