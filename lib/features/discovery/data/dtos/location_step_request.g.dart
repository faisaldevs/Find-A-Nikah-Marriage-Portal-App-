// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_step_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$LocationStepRequestDtoToJson(
  LocationStepRequestDto instance,
) => <String, dynamic>{
  'step': instance.step,
  'country': ?instance.country,
  'coordinates': ?instance.coordinates?.toJson(),
};

Map<String, dynamic> _$LocationCoordinatesDtoToJson(
  LocationCoordinatesDto instance,
) => <String, dynamic>{
  'longitude': instance.longitude,
  'latitude': instance.latitude,
  'distance': instance.distance,
};
