import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/domain/entities/marriage_profile.dart';
import 'package:find_a_nikah/features/marriage/domain/entities/swipe.dart';

/// One page of the feed. `nextCursor` is null on the last page.
typedef MarriageFeedPage = ({List<MarriageProfile> items, String? nextCursor});

/// Profiles for the Marriage tab, filtered server-side by the user's
/// `DiscoveryFilters`. Read policy: network only — a stale feed shows
/// people who may have left (decisions register #8).
abstract interface class MarriageRepository {
  /// First page when [cursor] is null.
  Future<Either<Failure, MarriageFeedPage>> fetchPage({
    required DiscoveryFilters filters,
    String? cursor,
  });

  /// Records a pass / like on [targetUserId], or undoes the last pass
  /// ([SwipeAction.undo] takes no target). [SwipeAction.complement] also
  /// sends [text]. Swiped profiles leave the server's deck, so the next
  /// [fetchPage] no longer includes them.
  Future<Either<Failure, SwipeOutcome>> swipe(
    SwipeAction action, {
    String? targetUserId,
    String? text,
  });

  /// Adds [userId] to favourites (`POST /v1/favorites/:userId`).
  Future<Either<Failure, Unit>> favourite(String userId);

  /// Blocks [userId] (`POST /v1/blocks/:userId`).
  Future<Either<Failure, Unit>> block(String userId);

  /// Reports [userId] (`POST /v1/reports`). [reason] is one of
  /// [kReportReasons]' codes.
  Future<Either<Failure, Unit>> report(
    String userId, {
    required String reason,
    String? description,
  });
}

/// `(code, label)` the API accepts for `reason`, in display order.
const kReportReasons = <(String, String)>[
  ('harassment', 'Harassment or abuse'),
  ('inappropriate_content', 'Inappropriate content'),
  ('fake_profile', 'Fake profile'),
  ('spam', 'Spam or scam'),
  ('other', 'Something else'),
];
