import 'package:find_a_nikah/app/di.dart';
import 'package:find_a_nikah/app/view/main_nav_shell.dart';
import 'package:find_a_nikah/core/ui/ui.dart';
import 'package:find_a_nikah/features/auth/presentation/presentation.dart';
import 'package:find_a_nikah/features/chat/presentation/presentation.dart';
import 'package:find_a_nikah/features/discovery/presentation/presentation.dart';
import 'package:find_a_nikah/features/explore/presentation/presentation.dart';
import 'package:find_a_nikah/features/face_verification/presentation/presentation.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/presentation.dart';
import 'package:find_a_nikah/features/marriage/presentation/presentation.dart';
// import 'package:find_a_nikah/app/view/menu_page.dart'; // replaced by features/menu
import 'package:find_a_nikah/features/menu/presentation/presentation.dart';
import 'package:find_a_nikah/features/onboarding/presentation/presentation.dart';
// Only needed for the livenessEnabled flag lookup (now disabled).
// import 'package:find_a_nikah/features/remote_config/domain/domain.dart';
import 'package:find_a_nikah/features/remote_config/presentation/presentation.dart';
import 'package:find_a_nikah/router/route_paths.dart';
import 'package:find_a_nikah/router/wizard_sections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Navigate with `context.push(RoutePaths.x)` / `context.go(RoutePaths.x)`.

GoRoute _page(String path, Widget page) =>
    GoRoute(path: path, builder: (_, _) => page);

/// Every route in the app.
final List<RouteBase> appRoutes = [
  // ── Public ─────────────────────────────────────────────────────────────
  _page(RoutePaths.splash, const SplashPage()),
  _page(RoutePaths.intro, const IntroPage()),
  _page(RoutePaths.welcome, const WelcomePage()),
  _page(RoutePaths.login, const LoginPage()),

  // Email → code → password share one SignUpBloc (it carries the email).
  ShellRoute(
    builder: (_, _, child) =>
        BlocProvider(create: (_) => getIt<SignUpBloc>(), child: child),
    routes: [
      _page(RoutePaths.signUpEmail, const SignUpEmailPage()),
      _page(RoutePaths.signUpCode, const SignUpCodePage()),
      _page(RoutePaths.createPassword, const CreatePasswordPage()),
    ],
  ),

  // ── Onboarding ─────────────────────────────────────────────────────────
  GoRoute(
    path: RoutePaths.getStarted,
    builder: (_, state) =>
        GetStartedPage(showRegistrationSuccess: state.extra == true),
  ),

  // Profile wizard: one persistent header + progress bar; only the page
  // body transitions between these routes.
  ShellRoute(
    builder: (_, _, child) => BlocProvider(
      create: (_) =>
          getIt<OnboardingBloc>()..add(const OnboardingDraftSubscribed()),
      child: RoutedWizardShell(
        sections: profileWizardSections,
        exitPath: RoutePaths.getStarted,
        child: child,
      ),
    ),
    routes: [
      _page(RoutePaths.accountType, const AccountTypePage()),
      _page(RoutePaths.relationship, const RelationshipPage()),
      _page(RoutePaths.basicInformation, const BasicInformationPage()),
      _page(RoutePaths.intentions, const IntentionsPage()),
      _page(RoutePaths.howHeard, const HowHeardPage()),
      _page(RoutePaths.nationality, const NationalityPage()),
      _page(RoutePaths.country, const CountryPage()),
      _page(RoutePaths.ethnicity, const EthnicityPage()),
      _page(RoutePaths.height, const HeightPage()),
      _page(RoutePaths.education, const EducationPage()),
      _page(RoutePaths.profession, const ProfessionPage()),
      _page(RoutePaths.maritalStatus, const MaritalStatusPage()),
      _page(RoutePaths.marriageTimeline, const MarriageTimelinePage()),
      _page(RoutePaths.faith, const FaithPage()),
      _page(RoutePaths.religiousPractice, const ReligiousPracticePage()),
      _page(RoutePaths.lifestylePreferences, const LifestylePreferencesPage()),
      _page(RoutePaths.aboutYou, const AboutYouPage()),
      _page(RoutePaths.personality, const PersonalityPage()),
      _page(RoutePaths.interests, const InterestsPage()),
      _page(RoutePaths.bio, const BioPage()),
    ],
  ),

  // Phone verification: its own shell, own progress bar, own bloc — fully
  // separate from photo/face verification below, not just a different
  // wizard section. Once verified it's locked (see `hideBackFor` on the
  // next shell); a user must finish this before starting the next layer.
  ShellRoute(
    builder: (_, _, child) => BlocProvider(
      create: (_) => getIt<PhoneVerificationBloc>(),
      child: RoutedWizardShell(
        sections: phoneVerificationSections,
        exitPath: RoutePaths.bio,
        bareHeaderFor: const {RoutePaths.phoneCode},
        child: child,
      ),
    ),
    routes: [
      _page(RoutePaths.phoneNumber, const PhoneNumberPage()),
      _page(RoutePaths.phoneCode, const PhoneCodePage()),
    ],
  ),

  // Photo + face verification: a separate layer from phone above — its
  // own shell, own progress bar, own blocs. Adding a photo immediately
  // drives the face check against it, so these are one flow, not two.
  ShellRoute(
    builder: (_, _, child) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<OnboardingBloc>()..add(const OnboardingDraftSubscribed()),
        ),
        BlocProvider(create: (_) => getIt<FaceVerificationBloc>()),
      ],
      child: RoutedWizardShell(
        sections: photoFaceVerificationSections,
        // No way back into the phone layer from here — it's a separate,
        // already-completed shell, not a section of this one.
        hideBackFor: const {RoutePaths.addPhotos},
        child: child,
      ),
    ),
    routes: [
      _page(RoutePaths.addPhotos, const AddPhotosPage()),
      // `extra` carries the main onboarding photo.
      GoRoute(
        path: RoutePaths.scanYourFace,
        builder: (_, state) => ScanYourFacePage(
          profilePhotoPath: state.extra is String
              ? state.extra! as String
              : null,
        ),
      ),
      // Liveness is the only verification path now — no flag lookup.
      // GoRoute(
      //   path: RoutePaths.startVerification,
      //   builder: (context, _) => StartVerificationPage(
      //     livenessEnabled: context.read<RemoteConfigBloc>().state.isEnabled(
      //       FeatureFlag.livenessEnabled,
      //     ),
      //   ),
      // ),
      _page(RoutePaths.startVerification, const StartVerificationPage()),
      // Own bloc per visit (camera capture state shouldn't outlive the page).
      // _page(RoutePaths.livenessCapture, const LivenessCapturePage()),
      _page(
        RoutePaths.livenessCapture,
        BlocProvider(
          create: (_) => getIt<LivenessCaptureBloc>(),
          child: const LivenessCapturePage(),
        ),
      ),
      // _page(RoutePaths.photoVerification, const PhotoVerificationPage()),
      // The greeting names the user (Figma); the name lives in the
      // onboarding draft, which this shell already provides.
      GoRoute(
        path: RoutePaths.photoVerification,
        builder: (context, _) => PhotoVerificationPage(
          userName: context.read<OnboardingBloc>().state.draft.fullName,
        ),
      ),
    ],
  ),

  _page(RoutePaths.location, const LocationFilterPage(isOnboardingStep: true)),

  // ── Discovery filters ──────────────────────────────────────────────────
  _page(RoutePaths.addFilters, const AddFiltersPage()),
  _page(RoutePaths.locationFilter, const LocationFilterPage()),

  // ── App ────────────────────────────────────────────────────────────────
  _page(RoutePaths.updateRequired, const UpdateRequiredPage()),

  // Feed flow pages, over the bottom nav.
  GoRoute(
    path: RoutePaths.feedPost,
    builder: (_, state) => PostDetailPage(post: state.extra! as FeedPost),
  ),
  GoRoute(
    path: RoutePaths.feedProfile,
    builder: (_, state) => ProfilePage(author: state.extra! as FeedAuthor),
  ),
  GoRoute(
    path: RoutePaths.feedProfileSearch,
    builder: (_, state) =>
        ProfileSearchPage(author: state.extra! as FeedAuthor),
  ),
  _page(RoutePaths.feedCompose, const CreatePostPage()),

  // Menu flow pages over the bottom nav (Figma: no nav bar on these).
  GoRoute(
    path: RoutePaths.settings,
    builder: (context, _) => SettingsPage(
      onSignOut: () =>
          context.read<AuthBloc>().add(const AuthSignOutRequested()),
    ),
  ),
  _page(RoutePaths.editProfile, const EditProfilePage()),
  _page(RoutePaths.chatArchived, const ChatArchivedPage()),

  // Bottom nav: Marriage · Explore · Feed · Chat · Menu. Each tab keeps its
  // own stack and state.
  StatefulShellRoute.indexedStack(
    builder: (_, _, shell) => MainNavShell(navigationShell: shell),
    branches: [
      StatefulShellBranch(
        routes: [_page(RoutePaths.marriage, const MarriagePage())],
      ),
      StatefulShellBranch(
        routes: [_page(RoutePaths.explore, const ExplorePage())],
      ),
      StatefulShellBranch(
        routes: [_page(RoutePaths.feed, const FeedPage())],
      ),
      StatefulShellBranch(
        routes: [
          _page(RoutePaths.chat, const ChatPage()),
          _page(RoutePaths.chatUnmatched, const ChatUnmatchedPage()),
        ],
      ),
      StatefulShellBranch(
        routes: [
          _page(RoutePaths.menu, const MenuPage()),
          // Help keeps the bottom nav (Figma "menu_help").
          _page(RoutePaths.menuHelp, const HelpPage()),
        ],
      ),
    ],
  ),
];
