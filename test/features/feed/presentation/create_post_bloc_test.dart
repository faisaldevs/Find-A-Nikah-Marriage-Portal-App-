import 'package:bloc_test/bloc_test.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'feed_test_data.dart';

class _MockFeedRepository extends Mock implements FeedRepository {}

void main() {
  late _MockFeedRepository repo;

  setUpAll(() => registerFallbackValue(feedTopic));

  setUp(() {
    repo = _MockFeedRepository();
    when(repo.fetchMe).thenAnswer((_) async => right(feedMe));
    when(repo.fetchTopics).thenAnswer(
      (_) async => right(const [feedTopic, feedReadOnlyTopic]),
    );
  });

  group('writing', () {
    blocTest<CreatePostBloc, CreatePostState>(
      'offers only topics the member can post into',
      build: () => CreatePostBloc(repo),
      act: (b) => b.add(const CreatePostStarted()),
      verify: (b) {
        expect(b.state.topics, [feedTopic]);
        expect(b.state.me, feedMe);
      },
    );

    test('Post stays off until there is text and a topic', () {
      expect(const CreatePostState().canPost, isFalse);
      expect(
        const CreatePostState(text: 'hi').canPost,
        isFalse,
        reason: 'no topic',
      );
      expect(
        const CreatePostState(topic: feedTopic).canPost,
        isFalse,
        reason: 'no text',
      );
      expect(
        const CreatePostState(topic: feedTopic, text: '   ').canPost,
        isFalse,
        reason: 'blank',
      );
      expect(
        const CreatePostState(topic: feedTopic, text: 'hi').canPost,
        isTrue,
      );
      expect(
        const CreatePostState(
          topic: feedTopic,
          text: 'hi',
          status: CreatePostStatus.submitting,
        ).canPost,
        isFalse,
        reason: 'already sending',
      );
    });

    blocTest<CreatePostBloc, CreatePostState>(
      'publishes the trimmed text to the chosen topic',
      build: () {
        when(
          () => repo.createPost(
            topic: any(named: 'topic'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => right(feedPost(mine: true, body: 'hi')));
        return CreatePostBloc(repo);
      },
      act: (b) => b
        ..add(const CreatePostTopicSelected(feedTopic))
        ..add(const CreatePostTextChanged('  hi  '))
        ..add(const CreatePostSubmitted()),
      verify: (b) {
        expect(b.state.status, CreatePostStatus.published);
        expect(b.state.published!.body, 'hi');
        expect(
          b.state.published!.topic,
          'Random',
          reason: 'the chosen topic wins over a wrong one in the response',
        );
        verify(() => repo.createPost(topic: feedTopic, body: 'hi')).called(1);
      },
    );

    blocTest<CreatePostBloc, CreatePostState>(
      'a post over the server limit can not be sent',
      build: () => CreatePostBloc(repo),
      act: (b) => b
        ..add(const CreatePostTopicSelected(feedTopic))
        ..add(CreatePostTextChanged('x' * (feedPostMaxLength + 1)))
        ..add(const CreatePostSubmitted()),
      verify: (b) {
        expect(b.state.tooLong, isTrue);
        expect(b.state.canPost, isFalse);
        verifyNever(
          () => repo.createPost(
            topic: any(named: 'topic'),
            body: any(named: 'body'),
          ),
        );
      },
    );

    blocTest<CreatePostBloc, CreatePostState>(
      'a rate-limited post fails with the failure kept for the toast',
      build: () {
        when(
          () => repo.createPost(
            topic: any(named: 'topic'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => left(const RateLimitedFailure(null)));
        return CreatePostBloc(repo);
      },
      act: (b) => b
        ..add(const CreatePostTopicSelected(feedTopic))
        ..add(const CreatePostTextChanged('hi'))
        ..add(const CreatePostSubmitted()),
      verify: (b) {
        expect(b.state.status, CreatePostStatus.failure);
        expect(b.state.failure, isA<RateLimitedFailure>());
        expect(b.state.text, 'hi', reason: 'the text is not lost');
      },
    );
  });

  group('editing', () {
    final original = feedPost(mine: true, body: 'Old text');

    blocTest<CreatePostBloc, CreatePostState>(
      'starts with the old text and a fixed topic, nothing to save yet',
      build: () => CreatePostBloc(repo, editing: original),
      verify: (b) {
        expect(b.state.isEditing, isTrue);
        expect(b.state.text, 'Old text');
        expect(b.state.topic!.id, 't1');
        expect(b.state.canPost, isFalse, reason: 'unchanged');
      },
    );

    blocTest<CreatePostBloc, CreatePostState>(
      'saving sends only the new body to the edit endpoint',
      build: () {
        when(() => repo.editPost('p1', 'New text')).thenAnswer(
          (_) async => right(original.copyWith(body: 'New text')),
        );
        return CreatePostBloc(repo, editing: original);
      },
      act: (b) => b
        ..add(const CreatePostTextChanged('New text'))
        ..add(const CreatePostSubmitted()),
      verify: (b) {
        expect(b.state.status, CreatePostStatus.published);
        verify(() => repo.editPost('p1', 'New text')).called(1);
        verifyNever(
          () => repo.createPost(
            topic: any(named: 'topic'),
            body: any(named: 'body'),
          ),
        );
      },
    );

    blocTest<CreatePostBloc, CreatePostState>(
      'an expired edit window fails and keeps the draft',
      build: () {
        when(() => repo.editPost('p1', 'New')).thenAnswer(
          (_) async => left(const ForbiddenFailure()),
        );
        return CreatePostBloc(repo, editing: original);
      },
      act: (b) => b
        ..add(const CreatePostTextChanged('New'))
        ..add(const CreatePostSubmitted()),
      verify: (b) {
        expect(b.state.status, CreatePostStatus.failure);
        expect(b.state.text, 'New');
      },
    );
  });
}
