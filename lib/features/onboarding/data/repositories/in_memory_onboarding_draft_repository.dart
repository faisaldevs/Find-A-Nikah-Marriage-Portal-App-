import 'dart:async';

import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/onboarding/domain/entities/onboarding_data.dart';
import 'package:find_a_nikah/features/onboarding/domain/repositories/onboarding_draft_repository.dart';

/// Keeps the draft for the current session. Registered in the `session`
/// DI scope.
class InMemoryOnboardingDraftRepository implements OnboardingDraftRepository {
  final _controller = StreamController<OnboardingData>.broadcast();
  OnboardingData _current = const OnboardingData();

  @override
  OnboardingData get current => _current;

  @override
  Stream<OnboardingData> watchDraft() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<Either<Failure, Unit>> save(OnboardingData draft) async {
    if (draft != _current) {
      _current = draft;
      _controller.add(draft);
    }
    return right(unit);
  }

  Future<void> dispose() => _controller.close();
}
