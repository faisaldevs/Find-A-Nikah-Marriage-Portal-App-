import 'package:find_a_nikah/features/remote_config/domain/entities/remote_config.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_config_dto.g.dart';

@JsonSerializable()
class RemoteConfigDto {
  const RemoteConfigDto({this.minimumSupportedVersion, this.flags = const {}});

  factory RemoteConfigDto.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfigDtoFromJson(json);

  final String? minimumSupportedVersion;
  final Map<String, bool> flags;

  Map<String, dynamic> toJson() => _$RemoteConfigDtoToJson(this);
}

extension RemoteConfigDtoMapper on RemoteConfigDto {
  RemoteConfig toEntity() => RemoteConfig(
    minimumSupportedVersion: minimumSupportedVersion,
    flags: Map.unmodifiable(flags),
  );
}
