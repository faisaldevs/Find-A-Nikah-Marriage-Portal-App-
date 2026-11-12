import 'package:find_a_nikah/core/utils/profile_mapping.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_message_dto.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/chat_peer_dto.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/conversation_dto.dart';
import 'package:find_a_nikah/features/messaging/data/dtos/my_matches_dto.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';

extension ChatPeerDtoMapper on ChatPeerDto {
  ChatPeer toEntity() => ChatPeer(
    id: id,
    name: name,
    photoUrl: photoUrl,
    isOnline: isOnline,
    lastSeenAt: isOnline ? null : lastSeenAt?.toLocal(),
    matchId: matchId,
  );
}

/// Sender ids become `isMine` against `myId` (the signed-in user’s id).
extension ChatMessageDtoMapper on ChatMessageDto {
  ChatMessage toEntity({required String myId}) => ChatMessage(
    id: id,
    conversationId: conversationId,
    text: text,
    sentAt: sentAt.toLocal(),
    isMine: senderId == myId,
    status: messageStatusFromWire(status),
    replyTo: switch (replyTo) {
      null => null,
      final r => MessageReply(
        messageId: r.messageId,
        isMine: r.senderId == myId,
        text: r.text,
      ),
    },
    callLog: switch (call) {
      null => null,
      final c => CallLog(
        outcome: callOutcomeFromWire(c.outcome),
        outgoing: c.callerId == myId,
        duration: Duration(seconds: c.durationSeconds),
      ),
    },
  );
}

extension ConversationDtoMapper on ConversationDto {
  Conversation toEntity({required String myId}) => Conversation(
    id: id,
    peer: peer.toEntity(),
    slot: slot,
    lastMessage: lastMessage?.toEntity(myId: myId),
    unreadCount: unreadCount,
  );
}

/// A `my-matches` row → the peer shape the conversation store holds.
/// Null when the row has no partner id. The API has no presence, so
/// nobody reads as online — the header shows "Last seen …" instead.
extension MatchDtoMapper on MatchDto {
  ChatPeerDto? toPeerDto({required String imageBaseUrl}) {
    final id = partner?.id ?? profile?.userId;
    if (id == null || id.isEmpty) return null;
    final photo = profile?.photoUrl ?? profile?.images.firstOrNull;
    final lastActive = partner?.lastActiveAt ?? profile?.lastActiveAt;
    return ChatPeerDto(
      id: id,
      name: partner?.fullName ?? profile?.fullName ?? '',
      photoUrl: photo == null || photo.isEmpty
          ? ''
          : resolveImageUrl(imageBaseUrl, photo),
      lastSeenAt: lastActive == null ? null : DateTime.tryParse(lastActive),
      matchId: matchId.isEmpty ? null : matchId,
    );
  }
}

extension MatchProfileMapper on MatchDto {
  /// The "View profile" data for this match, with photo paths made absolute.
  PeerProfile? toPeerProfile({required String imageBaseUrl}) {
    final p = profile;
    if (p == null) return null;
    final raw = [
      if (p.photoUrl case final photo? when photo.isNotEmpty) photo,
      for (final img in p.images)
        if (img.isNotEmpty && img != p.photoUrl) img,
    ];
    return PeerProfile(
      images: [for (final r in raw) resolveImageUrl(imageBaseUrl, r)],
      age: p.age,
      city: p.city,
      country: p.country,
      education: p.educationLevel,
      profession: p.professionTitle,
      faith: p.faith.isEmpty ? null : p.faith.join(', '),
      religion: p.religion,
      sect: p.sect.isEmpty ? null : p.sect.join(', '),
      maritalStatus: p.maritalStatus,
      isVerified: p.isVerified,
    );
  }
}

/// Unknown codes read as `sent` — the message exists, the tick is just
/// less specific.
MessageStatus messageStatusFromWire(String code) => switch (code) {
  'sending' => MessageStatus.sending,
  'delivered' => MessageStatus.delivered,
  'seen' => MessageStatus.seen,
  'failed' => MessageStatus.failed,
  _ => MessageStatus.sent,
};

/// Unknown codes read as `completed`.
CallOutcome callOutcomeFromWire(String code) => switch (code) {
  'missed' => CallOutcome.missed,
  'declined' => CallOutcome.declined,
  'cancelled' => CallOutcome.cancelled,
  _ => CallOutcome.completed,
};
