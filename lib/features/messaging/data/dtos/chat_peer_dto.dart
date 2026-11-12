import 'package:find_a_nikah/features/messaging/domain/entities/chat_peer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_peer_dto.g.dart';

/// Wire format of a chat peer / match. Kept separate from [ChatPeer]
/// (decisions register #4).
@JsonSerializable()
class ChatPeerDto {
  const ChatPeerDto({
    required this.id,
    required this.name,
    required this.photoUrl,
    this.isOnline = false,
    this.lastSeenAt,
    this.matchId,
  });

  factory ChatPeerDto.fromJson(Map<String, dynamic> json) =>
      _$ChatPeerDtoFromJson(json);

  final String id;
  final String name;
  final String photoUrl;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final String? matchId;

  Map<String, dynamic> toJson() => _$ChatPeerDtoToJson(this);
}
