import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/features/explore/domain/entities/explore_profile.dart';

/// The 4 lists behind the Explore "My history" tab's filter chips. No
/// per-list `count` badge, unlike `ExploreSection` — the mockup doesn't
/// show one here.
class ExploreHistoryFeed extends Equatable {
  const ExploreHistoryFeed({
    this.liked = const <ExploreProfile>[],
    this.favourited = const <ExploreProfile>[],
    this.passed = const <ExploreProfile>[],
    this.complimented = const <ExploreProfile>[],
  });

  final List<ExploreProfile> liked;
  final List<ExploreProfile> favourited;
  final List<ExploreProfile> passed;
  final List<ExploreProfile> complimented;

  ExploreHistoryFeed copyWith({
    List<ExploreProfile>? liked,
    List<ExploreProfile>? favourited,
    List<ExploreProfile>? passed,
    List<ExploreProfile>? complimented,
  }) {
    return ExploreHistoryFeed(
      liked: liked ?? this.liked,
      favourited: favourited ?? this.favourited,
      passed: passed ?? this.passed,
      complimented: complimented ?? this.complimented,
    );
  }

  @override
  List<Object?> get props => [
    liked,
    favourited,
    passed,
    complimented,
  ];
}
