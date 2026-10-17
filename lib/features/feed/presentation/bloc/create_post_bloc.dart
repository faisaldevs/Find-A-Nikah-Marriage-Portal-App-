import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_bloc.freezed.dart';

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

@freezed
abstract class CreatePostState with _$CreatePostState {
  const factory CreatePostState({
    @Default(CreatePostStatus.editing) CreatePostStatus status,
    FeedAuthor? me,
    @Default(<FeedTopic>[]) List<FeedTopic> topics,
    FeedTopic? topic,
    @Default('') String text,
    @Default(false) bool anonymous,
    FeedPost? published,
    Failure? failure,
  }) = _CreatePostState;

  const CreatePostState._();

  /// "Post" lights up once there's something to say and a group for it.
  bool get canPost =>
      text.trim().isNotEmpty &&
      topic != null &&
      status != CreatePostStatus.submitting;
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
