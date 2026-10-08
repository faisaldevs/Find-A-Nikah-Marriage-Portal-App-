// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_bio_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiBioResponse _$AiBioResponseFromJson(Map<String, dynamic> json) =>
    _AiBioResponse(
      data: AiBioData.fromJson(json['data'] as Map<String, dynamic>),
      statusCode: (json['statusCode'] as num?)?.toInt(),
      message: json['message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$AiBioResponseToJson(_AiBioResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'success': instance.success,
    };

_AiBioData _$AiBioDataFromJson(Map<String, dynamic> json) => _AiBioData(
  bio: json['bio'] as String,
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => AiBioOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AiBioOption>[],
  source: json['source'] as String?,
);

Map<String, dynamic> _$AiBioDataToJson(_AiBioData instance) =>
    <String, dynamic>{
      'bio': instance.bio,
      'options': instance.options,
      'source': instance.source,
    };

_AiBioOption _$AiBioOptionFromJson(Map<String, dynamic> json) => _AiBioOption(
  tone: json['tone'] as String,
  title: json['title'] as String,
  bio: json['bio'] as String,
);

Map<String, dynamic> _$AiBioOptionToJson(_AiBioOption instance) =>
    <String, dynamic>{
      'tone': instance.tone,
      'title': instance.title,
      'bio': instance.bio,
    };
