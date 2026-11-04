import 'dart:async';

import 'package:drift/native.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/database/database.dart';
import 'package:find_a_nikah/core/network/network.dart';
import 'package:find_a_nikah/features/menu/data/data.dart';
import 'package:find_a_nikah/features/menu/data/dtos/profile_patch_body.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:find_a_nikah/features/menu/presentation/editing/profile_options.dart';
import 'package:find_a_nikah/features/menu/presentation/presentation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fakes.dart';

class _MockRemote extends Mock implements MenuRemoteDataSource {}

/// Lets a chain of awaits finish.
Future<void> _settle() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

const _base = 'https://img.example.com';

String _path(String url) =>
    url.startsWith(_base) ? url.substring(_base.length) : url;

/// The smallest `/v1/profiles/me` body the mapper accepts.
MyProfileResponseDto _response({
  String name = 'Amina',
  List<String> images = const [],
}) => MyProfileResponseDto.fromJson({
  'data': {
    'user': {'fullName': name},
    'profile': {'images': images},
  },
});

void main() {
  setUpAll(() => registerFallbackValue(const ProfilePatch()));

  group('profilePatchBody', () {
    test('sends only the fields that are set', () {
      expect(
        profilePatchBody(const ProfilePatch(heightCm: 160), imagePath: _path),
        {'heightCm': 160},
      );
    });

    test('uses the API key names and formats', () {
      final body = profilePatchBody(
        ProfilePatch(
          fullName: 'Amina',
          dateOfBirth: DateTime(1998, 4, 5),
          bio: 'Hi',
          profession: 'Dentist',
          religiousPractices: const ['actively_practising'],
        ),
        imagePath: _path,
      );
      expect(body, {
        'fullName': 'Amina',
        'dateOfBirth': '1998-04-05',
        'aboutMe': 'Hi',
        'professionTitle': 'Dentist',
        'religiousPractices': ['actively_practising'],
      });
    });

    test('sends nested groups whole (ISS-010)', () {
      final body = profilePatchBody(
        const ProfilePatch(
          marriageIntentions: MarriageIntentionAnswers(
            getToKnow: '3-4_months',
            marriageTimeline: '1-2_years',
          ),
          interests: {
            InterestCategory.sports: ['Badminton'],
          },
        ),
        imagePath: _path,
      );
      expect(body['marriageIntentions'], {
        'getToknowDuration': '3-4_months',
        'marriageTimeline': '1-2_years',
      });
      // Every category, so the untouched ones aren't wiped.
      expect(body['interests'], {
        'cultural': <String>[],
        'foodDrinks': <String>[],
        'sports': ['Badminton'],
        'fashion': <String>[],
        'activities': <String>[],
      });
    });

    test('photo order goes back as stored relative paths', () {
      final body = profilePatchBody(
        const ProfilePatch(
          photoOrder: [
            '$_base/public/upload/b.jpg',
            '$_base/public/upload/a.jpg',
          ],
        ),
        imagePath: _path,
      );
      expect(body['images'], ['/public/upload/b.jpg', '/public/upload/a.jpg']);
    });
  });

  group('AboutYouAnswers / LifestyleAnswers', () {
    test('changing one answer keeps the others', () {
      const p = MyProfile(
        bornMuslim: true,
        hasChildren: false,
        relocateAbroad: true,
        halalFood: true,
        smoking: false,
        alcohol: false,
      );
      expect(
        AboutYouAnswers.of(p).copyWith(haveChildren: true),
        const AboutYouAnswers(
          bornMuslim: true,
          haveChildren: true,
          relocateAbroad: true,
        ),
      );
      expect(
        LifestyleAnswers.of(p).copyWith(smoking: true),
        const LifestyleAnswers(halalFood: true, smoking: true, alcohol: false),
      );
    });
  });

  group('MenuRepositoryImpl editing', () {
    late _MockRemote remote;
    late MenuRepositoryImpl repo;

    setUp(() {
      remote = _MockRemote();
      repo = MenuRepositoryImpl(
        remote,
        DummyMenuDataSource(),
        testGuard(),
        imageBaseUrl: '$_base/',
      );
    });

    test('updateMyProfile PATCHes the body and maps the reply', () async {
      when(
        () => remote.updateMyProfile(any()),
      ).thenAnswer((_) async => _response(name: 'New Name'));

      final result = await repo.updateMyProfile(
        const ProfilePatch(fullName: 'New Name'),
      );

      expect(result.getRight().toNullable()?.fullName, 'New Name');
      verify(() => remote.updateMyProfile({'fullName': 'New Name'})).called(1);
    });

    test('deletePhoto deletes by file name, then reloads', () async {
      when(() => remote.deletePhoto(any())).thenAnswer((_) async {});
      when(
        remote.getMyProfile,
      ).thenAnswer((_) async => _response(images: ['/public/upload/a.jpg']));

      final result = await repo.deletePhoto('$_base/public/upload/b.jpg');

      verify(() => remote.deletePhoto('b.jpg')).called(1);
      expect(result.getRight().toNullable()?.photos, [
        '$_base/public/upload/a.jpg',
      ]);
    });

    test('keeps interests per category', () async {
      when(remote.getMyProfile).thenAnswer(
        (_) async => MyProfileResponseDto.fromJson({
          'data': {
            'profile': {
              'interests': {
                'cultural': ['Dancing'],
                'sports': ['Dancing', 'Gym'],
              },
            },
          },
        }),
      );

      final p = (await repo.fetchMyProfile()).getRight().toNullable()!;

      expect(p.interestGroups[InterestCategory.sports], ['Dancing', 'Gym']);
      expect(p.interests, ['Dancing', 'Gym']);
    });
  });

  group('FieldEditorBloc', () {
    FieldEditorBloc<Set<String>> bloc() => FieldEditorBloc<Set<String>>(
      initial: const {'English'},
      isValid: (v) => v.isNotEmpty,
      toPatch: (v) => ProfilePatch(languages: v.toList()),
    );

    test('Update is off until the value really changes', () async {
      final b = bloc();
      expect(b.state.canSave, isFalse);

      b.add(const FieldEditorChanged({'English', 'Bengali'}));
      await Future<void>.delayed(Duration.zero);
      expect(b.state.canSave, isTrue);

      // Back to the same set (any order) → nothing to save.
      b.add(const FieldEditorChanged({'English'}));
      await Future<void>.delayed(Duration.zero);
      expect(b.state.canSave, isFalse);

      // A change that isn't valid can't be saved either.
      b.add(const FieldEditorChanged(<String>{}));
      await Future<void>.delayed(Duration.zero);
      expect(b.state.canSave, isFalse);
      await b.close();
    });

    test('Update hands the edit back at once (no waiting)', () async {
      final b = bloc()
        ..add(const FieldEditorChanged({'Bengali'}))
        ..add(const FieldEditorSubmitted());
      await _settle();

      expect(b.state.status, FieldEditorStatus.submitted);
      expect(b.state.patch, const ProfilePatch(languages: ['Bengali']));
      expect(b.state.canSave, isFalse);
      await b.close();
    });
  });

  group('MenuRepositoryImpl cache + instant edits', () {
    late _MockRemote remote;
    late AppDatabase db;
    late MenuRepositoryImpl repo;

    MenuRepositoryImpl build() => MenuRepositoryImpl(
      remote,
      DummyMenuDataSource(),
      testGuard(),
      imageBaseUrl: _base,
      cache: JsonCache(db),
    );

    setUp(() {
      remote = _MockRemote();
      db = AppDatabase(NativeDatabase.memory());
      repo = build();
    });

    tearDown(() async {
      await repo.dispose();
      await db.close();
    });

    test('a loaded profile is kept on the device for the next visit', () async {
      when(remote.getMyProfile).thenAnswer((_) async => _response());
      expect(await repo.cachedMyProfile(), isNull);
      await repo.fetchMyProfile();

      // A new session (fresh repository) still has it, without the API.
      final next = build();
      expect((await next.cachedMyProfile())?.fullName, 'Amina');
      await next.dispose();
    });

    test('an edit shows before the server answers', () async {
      when(remote.getMyProfile).thenAnswer((_) async => _response());
      await repo.fetchMyProfile();
      final reply = Completer<MyProfileResponseDto>();
      when(() => remote.updateMyProfile(any())).thenAnswer((_) => reply.future);
      final seen = <String>[];
      final sub = repo.myProfileChanges.listen((p) => seen.add(p.fullName));

      final saving = repo.updateMyProfile(const ProfilePatch(fullName: 'New'));
      await Future<void>.delayed(Duration.zero);
      expect(seen, ['New']); // shown at once
      expect((await repo.cachedMyProfile())?.fullName, 'New');

      reply.complete(_response(name: 'New'));
      expect((await saving).isRight(), isTrue);
      await sub.cancel();
    });

    test('a failed edit is rolled back', () async {
      when(remote.getMyProfile).thenAnswer((_) async => _response());
      await repo.fetchMyProfile();
      when(
        () => remote.updateMyProfile(any()),
      ).thenThrow(const NetworkException('offline'));
      final seen = <String>[];
      final sub = repo.myProfileChanges.listen((p) => seen.add(p.fullName));

      final result = await repo.updateMyProfile(
        const ProfilePatch(fullName: 'New'),
      );

      await Future<void>.delayed(Duration.zero);
      expect(result.isLeft(), isTrue);
      expect(seen, ['New', 'Amina']);
      expect((await repo.cachedMyProfile())?.fullName, 'Amina');
      await sub.cancel();
    });
  });

  group('EditProfileBloc instant edits', () {
    late _MockRemote remote;
    late MenuRepositoryImpl repo;
    const photos = [
      '$_base/public/upload/a.jpg',
      '$_base/public/upload/b.jpg',
      '$_base/public/upload/c.jpg',
    ];

    setUp(() {
      remote = _MockRemote();
      repo = MenuRepositoryImpl(
        remote,
        DummyMenuDataSource(),
        testGuard(),
        imageBaseUrl: _base,
      );
      when(remote.getMyProfile).thenAnswer(
        (_) async => _response(
          images: [for (final u in photos) u.substring(_base.length)],
        ),
      );
    });

    tearDown(() => repo.dispose());

    test('"Use as main photo" reorders before the server answers', () async {
      final reply = Completer<MyProfileResponseDto>();
      when(() => remote.updateMyProfile(any())).thenAnswer((_) => reply.future);
      final b = EditProfileBloc(repo)..add(const EditProfileStarted());
      await _settle();

      b.add(const EditProfilePhotoMadeMain('$_base/public/upload/c.jpg'));
      await _settle();

      expect(b.state.profile?.mainPhoto, '$_base/public/upload/c.jpg');
      verify(
        () => remote.updateMyProfile({
          'images': [
            '/public/upload/c.jpg',
            '/public/upload/a.jpg',
            '/public/upload/b.jpg',
          ],
        }),
      ).called(1);
      reply.complete(
        _response(
          images: [
            '/public/upload/c.jpg',
            '/public/upload/a.jpg',
            '/public/upload/b.jpg',
          ],
        ),
      );
      await _settle();
      expect(b.state.photoBusy, isFalse);
      await b.close();
    });

    test('a failed field save is rolled back with an error', () async {
      when(
        () => remote.updateMyProfile(any()),
      ).thenThrow(const NetworkException('offline'));
      final b = EditProfileBloc(repo)..add(const EditProfileStarted());
      await _settle();

      b.add(const EditProfileSaveRequested(ProfilePatch(fullName: 'New')));
      await _settle();

      expect(b.state.profile?.fullName, 'Amina');
      expect(b.state.failure, isA<NetworkFailure>());
      await b.close();
    });
  });

  group('timelineFits', () {
    test('married-within is two steps after get-to-know, or agreed', () {
      expect(timelineFits('3-4_months', '1-2_years'), isTrue);
      expect(timelineFits('3-4_months', '4-12_months'), isFalse);
      expect(timelineFits('1-2_years', 'agree_together'), isTrue);
    });
  });
}
