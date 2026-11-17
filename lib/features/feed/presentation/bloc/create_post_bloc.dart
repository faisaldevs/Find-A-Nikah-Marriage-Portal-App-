import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';

sealed class CreatePostEvent {
  const CreatePostEvent();
}

final class CreatePostStarted extends CreatePostEvent {
  const CreatePostStarted();
}

final class CreatePostTextChanged extends CreatePostEvent {
  const CreatePostTextChanged(this.text);

  final String text;
}

final class CreatePostTopicSelected extends CreatePostEvent {
  const CreatePostTopicSelected(this.topic);

  final FeedTopic topic;
}

// Anonymous posting dropped (every post is under the member).
// final class CreatePostAnonymousToggled extends CreatePostEvent {
//   const CreatePostAnonymousToggled({required this.anonymous});
//
//   final bool anonymous;
// }

final class CreatePostSubmitted extends CreatePostEvent {
  const CreatePostSubmitted();
}

enum CreatePostStatus { editing, submitting, published, failure }

class CreatePostState extends Equatable {
  const CreatePostState({
    this.status = CreatePostStatus.editing,
    this.me,
    this.topics = const <FeedTopic>[],
    this.topic,
    this.text = '',
    this.original,
    this.published,
    this.failure,
  });

  final CreatePostStatus status;
  final FeedAuthor? me;

  /// Topics the member can post into (read-only ones are left out).
  final List<FeedTopic> topics;
  final FeedTopic? topic;
  final String text;

  /// The post being edited, or null when writing a new one.
  final FeedPost? original;
  final FeedPost? published;
  final Failure? failure;

  bool get isEditing => original != null;

  bool get tooLong => text.length > feedPostMaxLength;

  /// "Post" lights up once there's something to say (an edit also needs a
  /// change). A topic is optional — the composer no longer asks for one.
  bool get canPost =>
      text.trim().isNotEmpty &&
      !tooLong &&
      status != CreatePostStatus.submitting &&
      (original == null || text.trim() != original!.body.trim());

  CreatePostState copyWith({
    CreatePostStatus? status,
    Object? me = unchanged,
    List<FeedTopic>? topics,
    Object? topic = unchanged,
    String? text,
    Object? published = unchanged,
    Object? failure = unchanged,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      me: identical(me, unchanged) ? this.me : me as FeedAuthor?,
      topics: topics ?? this.topics,
      topic: identical(topic, unchanged) ? this.topic : topic as FeedTopic?,
      text: text ?? this.text,
      original: original,
      published: identical(published, unchanged)
          ? this.published
          : published as FeedPost?,
      failure: identical(failure, unchanged)
          ? this.failure
          : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    me,
    topics,
    topic,
    text,
    original,
    published,
    failure,
  ];
}

/// Writes a new post, or edits [editing] (body only — the topic is fixed).
class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc(this._repo, {FeedPost? editing})
    : super(
        CreatePostState(
          original: editing,
          text: editing?.body ?? '',
          topic: editing == null
              ? null
              : FeedTopic(id: editing.topicId, name: editing.topic),
        ),
      ) {
    on<CreatePostStarted>(_onStarted);
    on<CreatePostTextChanged>(
      (e, emit) => emit(state.copyWith(text: e.text)),
    );
    on<CreatePostTopicSelected>(
      (e, emit) => emit(state.copyWith(topic: e.topic)),
    );
    on<CreatePostSubmitted>(_onSubmitted, transformer: droppable());
  }

  final FeedRepository _repo;

  Future<void> _onStarted(
    CreatePostStarted event,
    Emitter<CreatePostState> emit,
  ) async {
    final me = await _repo.fetchMe();
    // The composer has no topic picker now, so the topics aren't loaded:
    // final topics = await _repo.fetchTopics();
    // emit(state.copyWith(me: me.toNullable(), topics: [
    //   for (final t in topics.getOrElse((_) => const <FeedTopic>[]))
    //     if (t.canPost) t,
    // ]));
    emit(state.copyWith(me: me.toNullable()));
  }

  Future<void> _onSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    final topic = state.topic;
    if (!state.canPost) return;
    emit(state.copyWith(status: CreatePostStatus.submitting));
    final original = state.original;
    final result = original == null
        ? await _repo.createPost(topic: topic, body: state.text.trim())
        : await _repo.editPost(original.id, state.text.trim());
    emit(
      result.fold(
        (f) => state.copyWith(status: CreatePostStatus.failure, failure: f),
        // The create / edit responses of the dev server name the wrong topic
        // ("General"); the member's own choice is the truth here.
        (post) => state.copyWith(
          status: CreatePostStatus.published,
          published: topic == null
              ? post
              : post.copyWith(topic: topic.name, topicId: topic.id),
        ),
      ),
    );
  }
}
