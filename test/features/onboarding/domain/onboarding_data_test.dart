import 'package:find_a_nikah/features/onboarding/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const empty = OnboardingData();

  test('photo slots and minimum', () {
    expect(empty.remainingPhotoSlots, OnboardingData.maxPhotos);
    expect(empty.hasEnoughPhotos, isFalse);
    expect(empty.mainPhotoPath, isNull);

    final three = empty.withPhotosAdded(['a', 'b', 'c']);
    expect(three.hasEnoughPhotos, isTrue);
    expect(three.mainPhotoPath, 'a');
    expect(three.remainingPhotoSlots, 2);
  });

  test('withPhotosAdded never exceeds the slot count', () {
    final full = empty.withPhotosAdded(['1', '2', '3', '4', '5', '6', '7']);
    expect(full.photoPaths, ['1', '2', '3', '4', '5']);
    expect(full.withPhotosAdded(['x']).photoPaths, hasLength(5));
  });

  test('withPhotoRemoved keeps order', () {
    final d = empty.withPhotosAdded(['a', 'b', 'c']).withPhotoRemoved(1);
    expect(d.photoPaths, ['a', 'c']);
  });

  test('copyWith can clear a field (the old manual copyWith could not)', () {
    final d = empty.copyWith(bio: 'hello').copyWith(bio: null);
    expect(d.bio, isNull);
  });
}
