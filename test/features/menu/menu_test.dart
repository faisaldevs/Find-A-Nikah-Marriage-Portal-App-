import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/features/menu/data/data.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:find_a_nikah/features/menu/presentation/presentation.dart';
import 'package:find_a_nikah/features/menu/presentation/widgets/menu_format.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fakes.dart';

class _MockRemote extends Mock implements MenuRemoteDataSource {}

class _MockRepo extends Mock implements MenuRepository {}

void main() {
  group('MenuRepositoryImpl.fetchMyProfile', () {
    test('maps the onboarding status payload to MyProfile', () async {
      final remote = _MockRemote();
      when(remote.getMyProfile).thenAnswer(
        (_) async => MyProfileResponseDto.fromJson({
          'data': {
            'user': {'fullName': 'Dev Team v2'},
            'profile': {
              'gender': 'male',
              'dateOfBirth': '2005-04-02T00:00:00.000Z',
              'country': 'Bangladesh',
              'completeness': 76.4,
              'maritalStatus': 'annulled',
              'images': ['/public/upload/a.png'],
              'faceVerification': {'isFaceVerified': true},
              'aboutYou': {'bornMuslim': true, 'haveChildren': true},
              'lifestyle': {'halalFood': false, 'alcohol': true},
              'interests': {
                'cultural': ['Museums'],
                'foodDrinks': ['Cooking'],
              },
              'religiousPractices': ['strictly_practising'],
              'unknownField': 'ignored',
            },
          },
        }),
      );
      final repo = MenuRepositoryImpl(
        remote,
        DummyMenuDataSource(),
        testGuard(),
        imageBaseUrl: 'https://img.example.com/',
      );

      final profile = (await repo.fetchMyProfile()).getRight().toNullable()!;

      expect(profile.fullName, 'Dev Team v2');
      expect(profile.firstName, 'Dev');
      expect(profile.photos, ['https://img.example.com/public/upload/a.png']);
      expect(profile.isVerified, isTrue);
      expect(profile.completeness, 76);
      expect(profile.dateOfBirth, DateTime.utc(2005, 4, 2));
      expect(profile.currentLocation, 'Bangladesh');
      expect(profile.hasChildren, isTrue);
      expect(profile.halalFood, isFalse);
      expect(profile.interests, ['Museums', 'Cooking']);
      expect(profile.religiousPractice, 'strictly_practising');
    });
  });

  group('MenuFormat', () {
    test('tokens, dates, height, lists, booleans', () {
      expect(MenuFormat.token('never_married'), 'Never married');
      expect(MenuFormat.token('1-2_months'), '1-2 months');
      expect(MenuFormat.token(null), isNull);
      expect(MenuFormat.date(DateTime(2000, 6, 11)), '11 June, 2000');
      expect(MenuFormat.height(160), '160cm (5\' 3")');
      expect(
        MenuFormat.list(['Cycling', 'Dancing', 'Gymnastics', 'Chess']),
        'Cycling, Dancing, Gymnastics and 1 other',
      );
      expect(MenuFormat.list(const []), isNull);
      expect(MenuFormat.children(false), 'Doesn’t have children');
      expect(MenuFormat.smoking(false), 'Non-smoker');
      expect(MenuFormat.yesNo(null), isNull);
    });
  });

  group('SettingsBloc', () {
    late _MockRepo repo;

    setUpAll(() => registerFallbackValue(const AppSettings()));

    setUp(() {
      repo = _MockRepo();
      when(
        repo.fetchMyProfile,
      ).thenAnswer((_) async => right(const MyProfile(fullName: 'A')));
      when(
        repo.fetchSettings,
      ).thenAnswer((_) async => right(const AppSettings()));
    });

    test('a toggle applies right away and is saved', () async {
      when(
        () => repo.saveSettings(any()),
      ).thenAnswer(
        (i) async => right(i.positionalArguments.first as AppSettings),
      );
      final bloc = SettingsBloc(repo)..add(const SettingsStarted());
      await Future<void>.delayed(Duration.zero);

      bloc.add(SettingsChanged((s) => s.copyWith(chatMessagePreview: true)));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.settings.chatMessagePreview, isTrue);
      verify(
        () => repo.saveSettings(const AppSettings(chatMessagePreview: true)),
      ).called(1);
      await bloc.close();
    });

    test(
      'a failed save rolls the toggle back and surfaces the error',
      () async {
        when(
          () => repo.saveSettings(any()),
        ).thenAnswer((_) async => left(const NetworkFailure()));
        final bloc = SettingsBloc(repo)..add(const SettingsStarted());
        await Future<void>.delayed(Duration.zero);

        bloc.add(SettingsChanged((s) => s.copyWith(notifications: false)));
        await Future<void>.delayed(Duration.zero);

        expect(bloc.state.settings.notifications, isTrue);
        expect(bloc.state.failure, isA<NetworkFailure>());
        await bloc.close();
      },
    );
  });

  group('MenuBloc', () {
    test('loads profile + membership; tabs switch in place', () async {
      final repo = _MockRepo();
      when(
        repo.fetchMyProfile,
      ).thenAnswer((_) async => right(const MyProfile(fullName: 'A')));
      when(repo.fetchMembership).thenAnswer(
        (_) async => right(
          const Membership(
            planName: 'Basic plan',
            planDescription: '',
            likes: 20,
            compliments: 1,
            likesInFilters: 12,
            monthlyPrice: r'$10',
          ),
        ),
      );
      final bloc = MenuBloc(repo)..add(const MenuStarted());
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.status, MenuStatus.ready);
      expect(bloc.state.membership?.likes, 20);

      bloc.add(const MenuTabSelected(MenuTab.invite));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.tab, MenuTab.invite);
      await bloc.close();
    });

    test('a profile failure shows the error state', () async {
      final repo = _MockRepo();
      when(
        repo.fetchMyProfile,
      ).thenAnswer((_) async => left(const NetworkFailure()));
      when(repo.fetchMembership).thenAnswer(
        (_) async => right(
          const Membership(
            planName: '',
            planDescription: '',
            likes: 0,
            compliments: 0,
            likesInFilters: 0,
            monthlyPrice: '',
          ),
        ),
      );
      final bloc = MenuBloc(repo)..add(const MenuStarted());
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.status, MenuStatus.failure);
      await bloc.close();
    });
  });
}
