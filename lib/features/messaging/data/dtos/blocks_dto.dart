/// `GET /v1/blocks` → `{ data: { blocks: [...], pagination } }`.
///
/// The row shape wasn't confirmed (the list was empty when checked), so the
/// blocked user is read tolerantly from the usual keys; see [BlockRowDto].
class BlocksResponseDto {
  const BlocksResponseDto({this.blocks = const [], this.hasNext = false});

  factory BlocksResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final map = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};
    final rows = map['blocks'];
    final pagination = map['pagination'];
    return BlocksResponseDto(
      blocks: [
        if (rows is List)
          for (final r in rows)
            if (r is Map) BlockRowDto.fromJson(Map<String, dynamic>.from(r)),
      ],
      hasNext: pagination is Map && pagination['hasNext'] == true,
    );
  }

  final List<BlockRowDto> blocks;
  final bool hasNext;
}

/// One block. The blocked member is `blocked` / `blockedUser` / `user` /
/// `target` (an object), or just an id in `blockedId` / `targetUserId`.
class BlockRowDto {
  const BlockRowDto({required this.userId, this.name, this.photoUrl});

  factory BlockRowDto.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? user;
    for (final key in const ['blocked', 'blockedUser', 'user', 'target']) {
      final v = json[key];
      if (v is Map) {
        user = Map<String, dynamic>.from(v);
        break;
      }
    }
    String? text(Object? v) => v is String && v.isNotEmpty ? v : null;
    final profile = user?['profile'];
    return BlockRowDto(
      userId:
          text(user?['_id']) ??
          text(user?['id']) ??
          text(json['blockedId']) ??
          text(json['targetUserId']) ??
          (json['blocked'] is String ? json['blocked'] as String : ''),
      name:
          text(user?['fullName']) ??
          text(user?['name']) ??
          (profile is Map ? text(profile['fullName']) : null),
      photoUrl:
          text(user?['photoUrl']) ??
          (profile is Map ? text(profile['photoUrl']) : null),
    );
  }

  final String userId;
  final String? name;

  /// Server-relative (`/public/upload/...`) or absolute.
  final String? photoUrl;
}
