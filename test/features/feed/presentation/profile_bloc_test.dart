import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/bloc/feed_list_state.dart';
import 'package:find_a_nikah/features/feed/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'feed_test_data.dart';

class _MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late _MockFeedRepository repo;
  final post = feedPost();
  const profile = FeedProfile(
    author: feedOther,
    countryName: 'Bangladesh',
    followers: 4,
    following: 2,
    postsCount: 1,
  );

  setUpAll(() {
    registerFallbackValue(
      const FeedReport(
        target: FeedReportTarget.feedUser,
        reason: FeedReportReason.spam,
      ),
    );
  });

  setUp(() {
    repo = _MockFeedRepository();
    when(() => repo.fetchProfile('u2')).thenAnswer((_) async => right(profile));
    when(
      () => repo.fetchProfilePosts('u2', cursor: any(named: 'cursor')),
    ).thenAnswer((_) async => right(FeedPaged(items: [post])));
  });

  ProfileBloc build({FeedAuthor? author = feedOther}) =>
      ProfileBloc(repo, 'u2', author: author);

  ProfileState ready() => ProfileState(
    userId: 'u2',
    author: feedOther,
    status: ProfileStatus.ready,
    profile: profile,
    posts: const FeedListState<FeedPost>().loaded(
      FeedPaged(items: [post]),
    ),
  );

  group('opening', () {
    blocTest<ProfileBloc, ProfileState>(
      'by id: loads the profile and the first page of posts',
      build: () => build(author: null),
      act: (b) => b.add(const ProfileStarted()),
      verify: (b) {
        expect(b.state.status, ProfileStatus.ready);
        expect(b.state.shownAuthor, feedOther);
        expect(b.state.posts.items, [post]);
        expect(b.state.following, isFalse);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'a member who left shows an error, not a blank page',
      build: () {
        when(() => repo.fetchProfile('u2')).thenAnswer(
          (_) async => left(const NotFoundFailure()),
        );
        return build(author: null);
      },
      act: (b) => b.add(const ProfileStarted()),
      verify: (b) {
        expect(b.state.status, ProfileStatus.failure);
        expect(b.state.failure, isA<NotFoundFailure>());
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'already following shows "Following" from the start',
      build: () {
        when(() => repo.fetchProfile('u2')).thenAnswer(
          (_) async => right(profile.copyWith(isFollowing: true)),
        );
        return build();
      },
      act: (b) => b.add(const ProfileStarted()),
      verify: (b) => expect(b.state.following, isTrue),
    );
  });

  group('tabs', () {
    blocTest<ProfileBloc, ProfileState>(
      'Comments loads on first open only',
      build: () {
        when(
          () => repo.fetchProfileComments('u2', cursor: any(named: 'cursor')),
        ).thenAnswer(
          (_) async => right(
            FeedPaged(
              items: [
                FeedUserComment(
                  comment: feedComment(),
                  postId: 'p1',
                  postAuthorName: 'X',
                  postPreview: 'p',
                ),
              ],
            ),
          ),
        );
        return build();
      },
      seed: ready,
      act: (b) => b
        ..add(const ProfileTabSelected(ProfileTab.comments))
        ..add(const ProfileTabSelected(ProfileTab.posts))
        ..add(const ProfileTabSelected(ProfileTab.comments)),
      verify: (b) {
        expect(b.state.comments.items, hasLength(1));
        verify(
          () => repo.fetchProfileComments('u2', cursor: any(named: 'cursor')),
        ).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'a failed tab can be retried by selecting it again',
      build: () {
        var calls = 0;
        when(
          () => repo.fetchProfileComments('u2', cursor: any(named: 'cursor')),
        ).thenAnswer((_) async {
          calls++;
          return calls == 1
              ? left(const NetworkFailure())
              : right(const FeedPaged());
        });
        return build();
      },
      seed: ready,
      act: (b) async {
        b.add(const ProfileTabSelected(ProfileTab.comments));
        await Future<void>.delayed(Duration.zero);
        b.add(const ProfileTabSelected(ProfileTab.comments));
      },
      verify: (b) => expect(b.state.comments.isReady, isTrue),
    );

    blocTest<ProfileBloc, ProfileState>(
      'loads the next page of posts',
      build: () {
        when(
          () => repo.fetchProfilePosts('u2', cursor: 'c1'),
        ).thenAnswer(
          (_) async => right(FeedPaged(items: [feedPost(id: 'p9')])),
        );
        return build();
      },
      seed: () => ready().copyWith(
        posts: const FeedListState<FeedPost>().loaded(
          FeedPaged(items: [post], nextCursor: 'c1', hasMore: true),
        ),
      ),
      act: (b) => b.add(const ProfileLoadMore()),
      verify: (b) => expect(b.state.posts.items.map((p) => p.id), ['p1', 'p9']),
    );
  });

  group('follow, mute, block', () {
    blocTest<ProfileBloc, ProfileState>(
      'follow flips at once and takes the server follower count',
      build: () {
        when(() => repo.setFollowing('u2', following: true)).thenAnswer(
          (_) async => right(const ToggleResult(active: true, count: 7)),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const ProfileFollowToggled()),
      verify: (b) {
        expect(b.state.following, isTrue);
        expect(b.state.profile!.followers, 7);
        expect(b.state.followBusy, isFalse);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'a failed follow rolls the button and counter back',
      build: () {
        when(() => repo.setFollowing('u2', following: true)).thenAnswer(
          (_) async => left(const ForbiddenFailure()),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const ProfileFollowToggled()),
      verify: (b) {
        expect(b.state.following, isFalse);
        expect(b.state.profile!.followers, 4);
        expect(b.state.notice?.isError, isTrue);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'you can not follow yourself',
      build: () => ProfileBloc(repo, 'me', author: feedMe),
      seed: () => ProfileState(
        userId: 'me',
        author: feedMe,
        status: ProfileStatus.ready,
        profile: const FeedProfile(author: feedMe),
      ),
      act: (b) => b.add(const ProfileFollowToggled()),
      verify: (_) => verifyNever(
        () => repo.setFollowing(any(), following: any(named: 'following')),
      ),
    );

    blocTest<ProfileBloc, ProfileState>(
      'blocking the member leaves the page',
      build: () {
        when(() => repo.blockMember('u2')).thenAnswer((_) async => right(unit));
        return build();
      },
      seed: ready,
      act: (b) => b.add(const ProfileBlocked()),
      verify: (b) => expect(b.state.exit, isTrue),
    );

    blocTest<ProfileBloc, ProfileState>(
      'muting a post author from a tab hides their posts, stays on the page',
      build: () {
        when(
          () => repo.setMuted('u2', muted: true),
        ).thenAnswer((_) async => right(unit));
        return build();
      },
      seed: ready,
      act: (b) => b.add(
        const ProfileAuthorHideRequested('u2', block: false),
      ),
      verify: (b) {
        expect(b.state.posts.items, isEmpty);
        expect(b.state.exit, isFalse);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'unmuting is a toggle on the same menu entry',
      build: () {
        when(
          () => repo.setMuted('u2', muted: true),
        ).thenAnswer((_) async => right(unit));
        return build();
      },
      seed: ready,
      act: (b) => b.add(const ProfileMuteToggled()),
      verify: (b) => expect(b.state.muted, isTrue),
    );
  });

  group('posts in the tabs', () {
    blocTest<ProfileBloc, ProfileState>(
      'deleting my post removes it and lowers the posts counter',
      build: () {
        when(() => repo.deletePost('p1')).thenAnswer((_) async => right(unit));
        return build();
      },
      seed: ready,
      act: (b) => b.add(const ProfilePostDeleteRequested('p1')),
      verify: (b) {
        expect(b.state.posts.items, isEmpty);
        expect(b.state.profile!.postsCount, 0);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'like rolls back on failure',
      build: () {
        when(() => repo.setPostLiked('p1', liked: true)).thenAnswer(
          (_) async => left(const NetworkFailure()),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const ProfilePostLikeToggled('p1')),
      verify: (b) {
        expect(b.state.posts.items.single, post);
        expect(b.state.notice?.isError, isTrue);
      },
    );
  });

  group('marriage side', () {
    const marriage = FeedMarriageProfile(
      userId: 'u2',
      fullName: 'Khalil K',
      access: FeedMarriageAccess(
        level: FeedMarriageAccessLevel.partial,
        reason: 'NOT_ELIGIBLE',
        lockedSections: ['marriageIntentions'],
      ),
    );

    blocTest<ProfileBloc, ProfileState>(
      'loads once when the side is first opened',
      build: () {
        when(() => repo.fetchMarriageProfile('u2')).thenAnswer(
          (_) async => right(marriage),
        );
        return build();
      },
      seed: ready,
      act: (b) => b
        ..add(const ProfileMarriageRequested())
        ..add(const ProfileMarriageRequested()),
      verify: (b) {
        expect(b.state.marriage.status, ProfileStatus.ready);
        expect(b.state.marriage.profile!.access.reason, 'NOT_ELIGIBLE');
        verify(() => repo.fetchMarriageProfile('u2')).called(1);
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'a failure can be retried',
      build: () {
        var calls = 0;
        when(() => repo.fetchMarriageProfile('u2')).thenAnswer((_) async {
          calls++;
          return calls == 1 ? left(const ForbiddenFailure()) : right(marriage);
        });
        return build();
      },
      seed: ready,
      act: (b) async {
        b.add(const ProfileMarriageRequested());
        await Future<void>.delayed(Duration.zero);
        b.add(const ProfileMarriageRequested());
      },
      verify: (b) => expect(b.state.marriage.profile, marriage),
    );
  });
}
