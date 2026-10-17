import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFeedRepository extends Mock implements FeedRepository {}

const _me = FeedAuthor(name: 'Me', handle: 'me', photoUrl: '');
const _topic = FeedTopic(id: 't', name: 'Topic');
const _post = FeedPost(
  id: 'p1',
  author: _me,
  topic: 'Topic',
  postedAgo: 'now',
  body: 'Hello',
);
const _comment = FeedComment(
  id: 'c1',
  author: _me,
  postedAgo: 'now',
  body: 'Hi',
);
const _profile = FeedProfile(
  author: _me,
  countryName: 'Bangladesh',
  joined: 'Oct 2026',
);

void main() {
  late _MockFeedRepository repo;

  setUpAll(() {
    registerFallbackValue(CommentSort.mostPopular);
    registerFallbackValue(_topic);
  });

  setUp(() {
    repo = _MockFeedRepository();
    when(repo.fetchMe).thenAnswer((_) async => right(_me));
    when(repo.fetchTopics).thenAnswer((_) async => right(const [_topic]));
    when(
      () => repo.fetchComments(any(), any()),
    ).thenAnswer((_) async => right(const [_comment]));
    when(
      () => repo.fetchProfile(any()),
    ).thenAnswer((_) async => right(_profile));
    when(
      () => repo.fetchProfilePosts(any()),
    ).thenAnswer((_) async => right(const [_post]));
    when(
      () => repo.createPost(
        topic: any(named: 'topic'),
        body: any(named: 'body'),
        anonymous: any(named: 'anonymous'),
      ),
    ).thenAnswer((_) async => right(_post));
  });

  group('PostDetailBloc', () {
    blocTest<PostDetailBloc, PostDetailState>(
      'loads the signed-in member and the comments',
      build: () => PostDetailBloc(repo, _post),
      act: (b) => b.add(const PostDetailStarted()),
      expect: () => [
        const PostDetailState(post: _post, me: _me),
        const PostDetailState(
          post: _post,
          me: _me,
          status: PostDetailStatus.ready,
          comments: [_comment],
        ),
      ],
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'changing the sort reloads comments in that order',
      build: () => PostDetailBloc(repo, _post),
      seed: () =>
          const PostDetailState(post: _post, status: PostDetailStatus.ready),
      act: (b) => b.add(const PostDetailSortChanged(CommentSort.mostRecent)),
      skip: 1,
      expect: () => [
        const PostDetailState(
          post: _post,
          status: PostDetailStatus.ready,
          sort: CommentSort.mostRecent,
          comments: [_comment],
        ),
      ],
      verify: (_) => verify(
        () => repo.fetchComments('p1', CommentSort.mostRecent),
      ).called(1),
    );
  });

  blocTest<ProfileBloc, ProfileState>(
    'ProfileBloc loads the profile and its posts',
    build: () => ProfileBloc(repo, _me),
    act: (b) => b.add(const ProfileStarted()),
    expect: () => [
      const ProfileState(author: _me),
      const ProfileState(
        author: _me,
        status: ProfileStatus.ready,
        profile: _profile,
        posts: [_post],
      ),
    ],
  );

  group('CreatePostBloc', () {
    test('Post stays off until there is text and a group', () {
      expect(const CreatePostState(text: 'hi').canPost, isFalse);
      expect(const CreatePostState(topic: _topic).canPost, isFalse);
      expect(const CreatePostState(text: 'hi', topic: _topic).canPost, isTrue);
      expect(const CreatePostState(text: '  ', topic: _topic).canPost, isFalse);
    });

    blocTest<CreatePostBloc, CreatePostState>(
      'publishes the trimmed text to the chosen group',
      build: () => CreatePostBloc(repo),
      seed: () => const CreatePostState(text: ' hi ', topic: _topic),
      act: (b) => b.add(const CreatePostSubmitted()),
      expect: () => [
        const CreatePostState(
          text: ' hi ',
          topic: _topic,
          status: CreatePostStatus.submitting,
        ),
        const CreatePostState(
          text: ' hi ',
          topic: _topic,
          status: CreatePostStatus.published,
          published: _post,
        ),
      ],
      verify: (_) => verify(
        () => repo.createPost(topic: _topic, body: 'hi', anonymous: false),
      ).called(1),
    );
  });
}
