import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';

sealed class FieldEditorEvent<T> {
  const FieldEditorEvent();
}

/// The member picked or typed a new value.
final class FieldEditorChanged<T> extends FieldEditorEvent<T> {
  const FieldEditorChanged(this.value);
  final T value;
}

/// "Update" tapped.
final class FieldEditorSubmitted<T> extends FieldEditorEvent<T> {
  const FieldEditorSubmitted();
}

/// `saving` / `saved` / `failure` were used while the page waited for the
/// server; edits are now handed back at once ([submitted]) and saved by
/// Edit profile in the background.
enum FieldEditorStatus { editing, saving, saved, failure, submitted }

class FieldEditorState<T> extends Equatable {
  const FieldEditorState({
    required this.initial,
    required this.value,
    required this.isValid,
    this.status = FieldEditorStatus.editing,
    this.saved,
    this.failure,
    this.patch,
  });

  /// The value when the page opened.
  final T initial;
  final T value;

  /// Whether [value] may be saved (e.g. a name isn't blank).
  final bool isValid;
  final FieldEditorStatus status;

  /// The profile the server returned after saving.
  final MyProfile? saved;
  final Failure? failure;

  /// What "Update" handed back (set with [FieldEditorStatus.submitted]).
  final ProfilePatch? patch;

  /// Deep comparison: lists by order, sets and maps by content.
  bool get isDirty => _Box(initial) != _Box(value);

  /// "Update" is enabled only for a valid change that isn't saving yet.
  bool get canSave =>
      isDirty &&
      isValid &&
      status != FieldEditorStatus.saving &&
      status != FieldEditorStatus.saved &&
      status != FieldEditorStatus.submitted;

  FieldEditorState<T> copyWith({
    Object? value = unchanged,
    bool? isValid,
    FieldEditorStatus? status,
    MyProfile? saved,
    Object? failure = unchanged,
    ProfilePatch? patch,
  }) => FieldEditorState<T>(
    initial: initial,
    value: identical(value, unchanged) ? this.value : value as T,
    isValid: isValid ?? this.isValid,
    status: status ?? this.status,
    saved: saved ?? this.saved,
    failure: identical(failure, unchanged) ? this.failure : failure as Failure?,
    patch: patch ?? this.patch,
  );

  @override
  List<Object?> get props => [
    initial,
    value,
    isValid,
    status,
    saved,
    failure,
    patch,
  ];
}

/// Equatable's deep equality for any value, including `null`.
class _Box extends Equatable {
  const _Box(this.value);
  final Object? value;

  @override
  List<Object?> get props => [value];
}

/// One Edit profile field page: holds the value being edited and, on
/// "Update", hands back the [ProfilePatch] that [toPatch] builds. Saving
/// happens in Edit profile (shown at once, saved in the background).
class FieldEditorBloc<T>
    extends Bloc<FieldEditorEvent<T>, FieldEditorState<T>> {
  FieldEditorBloc({
    // this._repo, {
    required T initial,
    required this.toPatch,
    bool Function(T value)? isValid,
  }) : _isValid = isValid ?? ((_) => true),
       super(
         FieldEditorState<T>(
           initial: initial,
           value: initial,
           isValid: (isValid ?? (_) => true)(initial),
         ),
       ) {
    on<FieldEditorChanged<T>>(_onChanged);
    on<FieldEditorSubmitted<T>>(_onSubmitted, transformer: droppable());
  }

  // Saving moved to Edit profile (optimistic, through the repository).
  // final MenuRepository _repo;

  /// Turns the edited value into what's sent to the API.
  final ProfilePatch Function(T value) toPatch;
  final bool Function(T value) _isValid;

  void _onChanged(
    FieldEditorChanged<T> event,
    Emitter<FieldEditorState<T>> emit,
  ) => emit(
    state.copyWith(
      value: event.value,
      isValid: _isValid(event.value),
      status: FieldEditorStatus.editing,
      failure: null,
    ),
  );

  // Before: waited on the server with "Saving..." on the button.
  // Future<void> _onSubmitted(
  //   FieldEditorSubmitted<T> event,
  //   Emitter<FieldEditorState<T>> emit,
  // ) async {
  //   if (!state.canSave) return;
  //   emit(state.copyWith(status: FieldEditorStatus.saving, failure: null));
  //   final result = await _repo.updateMyProfile(toPatch(state.value));
  //   emit(
  //     result.fold(
  //       (f) => state.copyWith(status: FieldEditorStatus.failure, failure: f),
  //       (p) => state.copyWith(status: FieldEditorStatus.saved, saved: p),
  //     ),
  //   );
  // }
  void _onSubmitted(
    FieldEditorSubmitted<T> event,
    Emitter<FieldEditorState<T>> emit,
  ) {
    if (!state.canSave) return;
    emit(
      state.copyWith(
        status: FieldEditorStatus.submitted,
        patch: toPatch(state.value),
      ),
    );
  }
}
