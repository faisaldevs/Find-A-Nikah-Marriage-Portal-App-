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

final class CreatePostAnonymousToggled extends CreatePostEvent {
  const CreatePostAnonymousToggled({required this.anonymous});

  final bool anonymous;
}

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
    this.anonymous = false,
    this.published,
    this.failure,
  });

  final CreatePostStatus status;
  final FeedAuthor? me;
  final List<FeedTopic> topics;
  final FeedTopic? topic;
  final String text;
  final bool anonymous;
  final FeedPost? published;
  final Failure? failure;

  /// "Post" lights up once there's something to say and a group for it.
  bool get canPost =>
      text.trim().isNotEmpty &&
      topic != null &&
      status != CreatePostStatus.submitting;

  CreatePostState copyWith({
    CreatePostStatus? status,
    Object? me = unchanged,
    List<FeedTopic>? topics,
    Object? topic = unchanged,
    String? text,
    bool? anonymous,
    Object? published = unchanged,
    Object? failure = unchanged,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      me: identical(me, unchanged) ? this.me : me as FeedAuthor?,
      topics: topics ?? this.topics,
      topic: identical(topic, unchanged) ? this.topic : topic as FeedTopic?,
      text: text ?? this.text,
      anonymous: anonymous ?? this.anonymous,
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
    anonymous,
    published,
    failure,
  ];
}

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc(this._repo) : super(const CreatePostState()) {
    on<CreatePostStarted>(_onStarted);
    on<CreatePostTextChanged>(
      (e, emit) => emit(state.copyWith(text: e.text)),
    );
    on<CreatePostTopicSelected>(
      (e, emit) => emit(state.copyWith(topic: e.topic)),
    );
    on<CreatePostAnonymousToggled>(
      (e, emit) => emit(state.copyWith(anonymous: e.anonymous)),
    );
    on<CreatePostSubmitted>(_onSubmitted, transformer: droppable());
  }

  final FeedRepository _repo;

  Future<void> _onStarted(
    CreatePostStarted event,
    Emitter<CreatePostState> emit,
  ) async {
    final me = await _repo.fetchMe();
    final topics = await _repo.fetchTopics();
    emit(
      state.copyWith(
        me: me.toNullable(),
        topics: topics.getOrElse((_) => const []),
      ),
    );
  }

  Future<void> _onSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    final topic = state.topic;
    if (!state.canPost || topic == null) return;
    emit(state.copyWith(status: CreatePostStatus.submitting));
    final result = await _repo.createPost(
      topic: topic,
      body: state.text.trim(),
      anonymous: state.anonymous,
    );
    emit(
      result.fold(
        (f) => state.copyWith(status: CreatePostStatus.failure, failure: f),
        (post) => state.copyWith(
          status: CreatePostStatus.published,
          published: post,
        ),
      ),
    );
  }
}
