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
  final post = feedPost(comments: 2);
  final c1 = feedComment(
    replies: [feedComment(id: 'r1', parentId: 'c1', author: feedMe)],
  );
  final c2 = feedComment(id: 'c2', author: feedMe, likes: 1);

  setUpAll(() {
    registerFallbackValue(CommentSort.mostPopular);
    registerFallbackValue(
      const FeedReport(
        target: FeedReportTarget.post,
        reason: FeedReportReason.spam,
      ),
    );
  });

  setUp(() {
    repo = _MockFeedRepository();
    when(repo.fetchMe).thenAnswer((_) async => right(feedMe));
    when(() => repo.fetchPost('p1')).thenAnswer((_) async => right(post));
    when(
      () => repo.fetchComments('p1', any(), cursor: any(named: 'cursor')),
    ).thenAnswer((_) async => right(FeedPaged(items: [c1, c2])));
    when(() => repo.fetchProfile(any())).thenAnswer(
      (_) async => right(
        const FeedProfile(author: feedOther, isFollowing: true),
      ),
    );
    when(() => repo.recordViews(any())).thenAnswer((_) async => right(unit));
  });

  PostDetailBloc build({FeedPost? initial}) =>
      PostDetailBloc(repo, 'p1', initial: initial);

  PostDetailState ready({
    FeedPost? p,
    List<FeedComment>? comments,
    ComposerMode composer = const ComposerNew(),
  }) => PostDetailState(
    postId: 'p1',
    post: p ?? post,
    status: PostDetailStatus.ready,
    me: feedMe,
    composer: composer,
    comments: const FeedListState<FeedComment>().loaded(
      FeedPaged(items: comments ?? [c1, c2]),
    ),
  );

  group('opening', () {
    blocTest<PostDetailBloc, PostDetailState>(
      'by id: loads the post, comments, who I follow, and counts a view',
      build: build,
      act: (b) => b.add(const PostDetailStarted()),
      verify: (b) {
        expect(b.state.status, PostDetailStatus.ready);
        expect(b.state.post, post);
        expect(b.state.me, feedMe);
        expect(b.state.following, isTrue);
        expect(b.state.comments.items, [c1, c2]);
        verify(() => repo.recordViews(['p1'])).called(1);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'a deleted post (410) shows why instead of a blank page',
      build: () {
        when(() => repo.fetchPost('p1')).thenAnswer(
          (_) async => left(const NotFoundFailure()),
        );
        return build();
      },
      act: (b) => b.add(const PostDetailStarted()),
      verify: (b) {
        expect(b.state.status, PostDetailStatus.failure);
        expect(b.state.post, isNull);
        expect(b.state.failure, isA<NotFoundFailure>());
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'a post that vanished while its card was shown closes the page',
      build: () {
        when(() => repo.fetchPost('p1')).thenAnswer(
          (_) async => left(const NotFoundFailure()),
        );
        return build(initial: post);
      },
      act: (b) => b.add(const PostDetailStarted()),
      verify: (b) => expect(b.state.exit, PostDetailExit.deleted),
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'offline with a card already shown keeps it',
      build: () {
        when(() => repo.fetchPost('p1')).thenAnswer(
          (_) async => left(const NetworkFailure()),
        );
        return build(initial: post);
      },
      act: (b) => b.add(const PostDetailStarted()),
      verify: (b) {
        expect(b.state.post, post);
        expect(b.state.exit, PostDetailExit.none);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'no "Follow" pill for my own post (author is me)',
      build: () {
        when(() => repo.fetchPost('p1')).thenAnswer(
          (_) async => right(feedPost(author: feedMe, mine: true)),
        );
        return build();
      },
      act: (b) => b.add(const PostDetailStarted()),
      verify: (b) {
        expect(b.state.following, isNull);
        verifyNever(() => repo.fetchProfile(any()));
      },
    );
  });

  group('post actions', () {
    blocTest<PostDetailBloc, PostDetailState>(
      'like is optimistic and keeps the server count',
      build: () {
        when(() => repo.setPostLiked('p1', liked: true)).thenAnswer(
          (_) async => right(const ToggleResult(active: true, count: 11)),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const PostDetailPostLiked()),
      verify: (b) {
        expect(b.state.post!.likedByMe, isTrue);
        expect(b.state.post!.likeCount, 11);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'a failed like restores the post',
      build: () {
        when(() => repo.setPostLiked('p1', liked: true)).thenAnswer(
          (_) async => left(const ServerFailure()),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const PostDetailPostLiked()),
      verify: (b) {
        expect(b.state.post, post);
        expect(b.state.notice?.isError, isTrue);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'deleting my post closes the page as deleted',
      build: () {
        when(() => repo.deletePost('p1')).thenAnswer(
          (_) async => right(unit),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const PostDetailPostDeleted()),
      verify: (b) => expect(b.state.exit, PostDetailExit.deleted),
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'blocking the author closes the page as author hidden',
      build: () {
        when(() => repo.blockMember('u2')).thenAnswer(
          (_) async => right(unit),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const PostDetailAuthorBlocked()),
      verify: (b) => expect(b.state.exit, PostDetailExit.authorHidden),
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'reporting twice is a calm notice, not an error',
      build: () {
        when(() => repo.report(any())).thenAnswer(
          (_) async => left(const ConflictFailure()),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(
        const PostDetailReported(
          FeedReport(
            target: FeedReportTarget.post,
            reason: FeedReportReason.spam,
            postId: 'p1',
          ),
        ),
      ),
      verify: (b) {
        expect(b.state.notice?.text, 'You already reported this');
        expect(b.state.notice?.isError, isFalse);
        expect(b.state.exit, PostDetailExit.none);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'follow toggles optimistically',
      build: () {
        when(() => repo.setFollowing('u2', following: false)).thenAnswer(
          (_) async => right(const ToggleResult(active: false, count: 0)),
        );
        return build();
      },
      seed: () => ready().copyWith(following: true),
      act: (b) => b.add(const PostDetailFollowToggled()),
      verify: (b) => expect(b.state.following, isFalse),
    );
  });

  group('comments', () {
    blocTest<PostDetailBloc, PostDetailState>(
      'a new comment goes on top and raises the post count',
      build: () {
        when(() => repo.createComment('p1', 'Nice')).thenAnswer(
          (_) async => right(feedComment(id: 'new', author: feedMe)),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const PostDetailCommentSubmitted('  Nice  ')),
      verify: (b) {
        expect(b.state.comments.items.first.id, 'new');
        expect(b.state.post!.commentCount, 3);
        expect(b.state.sending, isFalse);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'a blank comment is not sent',
      build: build,
      seed: ready,
      act: (b) => b.add(const PostDetailCommentSubmitted('   ')),
      verify: (_) => verifyNever(() => repo.createComment(any(), any())),
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'replying to a reply goes under the parent, with a mention',
      build: () {
        when(
          () => repo.createComment(
            'p1',
            'Thanks',
            parentId: 'c1',
            mentionUserId: 'me',
          ),
        ).thenAnswer(
          (_) async => right(
            feedComment(id: 'new', parentId: 'c1', author: feedMe),
          ),
        );
        return build();
      },
      seed: () => ready(
        composer: ComposerReply(c1.replies.single), // a reply by me
      ),
      act: (b) => b.add(const PostDetailCommentSubmitted('Thanks')),
      verify: (b) {
        final parent = b.state.comments.items.first;
        expect(parent.replies.map((r) => r.id), ['r1', 'new']);
        expect(parent.replyCount, 2);
        expect(b.state.composer, isA<ComposerNew>());
        expect(b.state.post!.commentCount, 3);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'editing a comment updates its text and marks it edited',
      build: () {
        when(() => repo.editComment('c2', 'Fixed')).thenAnswer(
          (_) async => right(
            c2.copyWith(
              body: 'Fixed',
              editedAt: DateTime.utc(2026, 11, 14, 0, 5),
            ),
          ),
        );
        return build();
      },
      seed: () => ready(composer: ComposerEdit(c2)),
      act: (b) => b.add(const PostDetailCommentSubmitted('Fixed')),
      verify: (b) {
        final c = b.state.comments.items.last;
        expect(c.body, 'Fixed');
        expect(c.edited, isTrue);
        expect(b.state.composer, isA<ComposerNew>());
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'a failed send keeps the composer and shows an error',
      build: () {
        when(() => repo.createComment('p1', 'Hi')).thenAnswer(
          (_) async => left(const RateLimitedFailure(null)),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const PostDetailCommentSubmitted('Hi')),
      verify: (b) {
        expect(b.state.sending, isFalse);
        expect(b.state.notice?.isError, isTrue);
        expect(b.state.comments.items, [c1, c2]);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'deleting a top-level comment removes its replies from the count too',
      build: () {
        when(() => repo.deleteComment('c1')).thenAnswer(
          (_) async => right(unit),
        );
        return build();
      },
      seed: () => ready(p: feedPost(comments: 3)),
      act: (b) => b.add(const PostDetailCommentDeleted('c1')),
      verify: (b) {
        expect(b.state.comments.items.map((c) => c.id), ['c2']);
        expect(b.state.post!.commentCount, 1);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'deleting a reply lowers the parent reply count',
      build: () {
        when(() => repo.deleteComment('r1')).thenAnswer(
          (_) async => right(unit),
        );
        return build();
      },
      seed: () => ready(p: feedPost(comments: 3)),
      act: (b) => b.add(const PostDetailCommentDeleted('r1')),
      verify: (b) {
        final parent = b.state.comments.items.first;
        expect(parent.replies, isEmpty);
        expect(parent.replyCount, 0);
        expect(b.state.post!.commentCount, 2);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'liking a reply updates just that reply, and rolls back on failure',
      build: () {
        when(() => repo.setCommentLiked('r1', liked: true)).thenAnswer(
          (_) async => left(const NetworkFailure()),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const PostDetailCommentLiked('r1')),
      verify: (b) {
        final r = b.state.comments.items.first.replies.single;
        expect(r.likedByMe, isFalse);
        expect(r.likeCount, 0);
        expect(b.state.notice?.isError, isTrue);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      '"view more replies" appends only the ones not shown yet',
      build: () {
        when(() => repo.fetchReplies('c1')).thenAnswer(
          (_) async => right(
            FeedPaged(
              items: [
                feedComment(id: 'r1', parentId: 'c1', author: feedMe),
                feedComment(id: 'r2', parentId: 'c1'),
              ],
            ),
          ),
        );
        return build();
      },
      seed: ready,
      act: (b) => b.add(const PostDetailRepliesRequested('c1')),
      verify: (b) => expect(
        b.state.comments.items.first.replies.map((r) => r.id),
        ['r1', 'r2'],
      ),
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'changing the sort reloads comments in that order',
      build: () {
        when(
          () => repo.fetchComments(
            'p1',
            CommentSort.mostRecent,
            cursor: any(named: 'cursor'),
          ),
        ).thenAnswer((_) async => right(FeedPaged(items: [c2, c1])));
        return build();
      },
      seed: ready,
      act: (b) => b.add(const PostDetailSortChanged(CommentSort.mostRecent)),
      verify: (b) {
        expect(b.state.sort, CommentSort.mostRecent);
        expect(b.state.comments.items.map((c) => c.id), ['c2', 'c1']);
      },
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'cancelling reply mode goes back to a new comment',
      build: build,
      seed: () => ready(composer: ComposerReply(c1)),
      act: (b) => b.add(const PostDetailComposerCancelled()),
      verify: (b) => expect(b.state.composer, isA<ComposerNew>()),
    );
  });
}
