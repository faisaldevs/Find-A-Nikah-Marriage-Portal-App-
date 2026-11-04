import 'package:json_annotation/json_annotation.dart';

part 'ai_bio_response.g.dart';

@JsonSerializable()
class AiBioResponse {
  const AiBioResponse({
    required this.data,
    this.statusCode,
    this.message,
    this.success,
  });

  factory AiBioResponse.fromJson(Map<String, dynamic> json) =>
      _$AiBioResponseFromJson(json);

  final AiBioData data;
  final int? statusCode;
  final String? message;
  final bool? success;

  Map<String, dynamic> toJson() => _$AiBioResponseToJson(this);
}

@JsonSerializable()
class AiBioData {
  const AiBioData({
    required this.bio,
    this.options = const <AiBioOption>[],
    this.source,
  });

  factory AiBioData.fromJson(Map<String, dynamic> json) =>
      _$AiBioDataFromJson(json);

  final String bio;
  final List<AiBioOption> options;
  final String? source;

  Map<String, dynamic> toJson() => _$AiBioDataToJson(this);
}

@JsonSerializable()
class AiBioOption {
  const AiBioOption({
    required this.tone,
    required this.title,
    required this.bio,
  });

  factory AiBioOption.fromJson(Map<String, dynamic> json) =>
      _$AiBioOptionFromJson(json);

  final String tone;
  final String title;
  final String bio;

  Map<String, dynamic> toJson() => _$AiBioOptionToJson(this);
}
