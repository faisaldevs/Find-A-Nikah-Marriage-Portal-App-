import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_bio_response.freezed.dart';
part 'ai_bio_response.g.dart';

@freezed
abstract class AiBioResponse with _$AiBioResponse {
  const factory AiBioResponse({
    required AiBioData data,
    int? statusCode,
    String? message,
    bool? success,
  }) = _AiBioResponse;

  factory AiBioResponse.fromJson(Map<String, dynamic> json) =>
      _$AiBioResponseFromJson(json);
}

@freezed
abstract class AiBioData with _$AiBioData {
  const factory AiBioData({
    required String bio,
    @Default(<AiBioOption>[]) List<AiBioOption> options,
    String? source,
  }) = _AiBioData;

  factory AiBioData.fromJson(Map<String, dynamic> json) =>
      _$AiBioDataFromJson(json);
}

@freezed
abstract class AiBioOption with _$AiBioOption {
  const factory AiBioOption({
    required String tone,
    required String title,
    required String bio,
  }) = _AiBioOption;

  factory AiBioOption.fromJson(Map<String, dynamic> json) =>
      _$AiBioOptionFromJson(json);
}
