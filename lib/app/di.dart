import 'dart:io' show Platform;

import 'package:find_a_nikah/app/session_scope_manager.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/logging/app_logger.dart';
import 'package:find_a_nikah/core/logging/log_error_reporter.dart';
import 'package:find_a_nikah/core/network/network.dart';
import 'package:find_a_nikah/features/auth/data/data.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/bloc.dart';
import 'package:find_a_nikah/features/discovery/data/data.dart';
import 'package:find_a_nikah/features/discovery/domain/domain.dart';
import 'package:find_a_nikah/features/discovery/presentation/presentation.dart';
import 'package:find_a_nikah/features/explore/data/data.dart';
import 'package:find_a_nikah/features/explore/domain/domain.dart';
import 'package:find_a_nikah/features/explore/presentation/presentation.dart';
import 'package:find_a_nikah/features/face_verification/data/data.dart';
import 'package:find_a_nikah/features/face_verification/domain/domain.dart';
import 'package:find_a_nikah/features/face_verification/presentation/presentation.dart';
import 'package:find_a_nikah/features/feed/data/data.dart';
import 'package:find_a_nikah/features/feed/domain/domain.dart';
import 'package:find_a_nikah/features/feed/presentation/presentation.dart';
import 'package:find_a_nikah/features/marriage/data/data.dart';
import 'package:find_a_nikah/features/marriage/domain/domain.dart';
import 'package:find_a_nikah/features/marriage/presentation/presentation.dart';
import 'package:find_a_nikah/features/menu/data/data.dart';
import 'package:find_a_nikah/features/menu/domain/domain.dart';
import 'package:find_a_nikah/features/menu/presentation/presentation.dart';
import 'package:find_a_nikah/features/onboarding/data/data.dart';
import 'package:find_a_nikah/features/onboarding/domain/domain.dart';
import 'package:find_a_nikah/features/onboarding/presentation/presentation.dart';
import 'package:find_a_nikah/features/remote_config/data/data.dart';
import 'package:find_a_nikah/features/remote_config/domain/domain.dart';
import 'package:find_a_nikah/features/remote_config/presentation/presentation.dart';
import 'package:find_a_nikah/flavors/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// The app's service locator. Only this file, the router and pages (to
/// create their bloc) resolve from it; widgets below a page use
/// `context.read`. Unit tests build classes directly with fakes.
final GetIt getIt = GetIt.instance;

/// User-scoped registrations: pushed on sign-in, dropped on sign-out so no
/// singleton keeps the previous user's data.
const sessionScope = 'session';

/// Registers the app-wide services and feature dependencies.
Future<void> configureDependencies(AppConfig config) async {
  final info = await PackageInfo.fromPlatform();
  final isDev = config.flavors == Flavors.dev;

  // ── Core services ────────────────────────────────────────────────────
  const Logger logger = AppLogger();
  final reporter = LogErrorReporter(logger);
  final guard = Guard(reporter, translators: const [translateDioException]);
  final authLocal = AuthLocalDataSource(
    const FlutterSecureStorage(iOptions: AuthLocalDataSource.iosOptions),
  );
  final sessionExpiry = SessionExpirySignal();
  final api = ApiClient(
    config: ApiClientConfig(
      baseUrl: config.apiBaseUrl,
      appVersion: info.version,
      platform: Platform.operatingSystem,
      enableLogging: kDebugMode,
    ),
    tokenStore: authLocal,
    refreshTokens: authTokenRefresher(authLocal),
    onSessionExpired: sessionExpiry.notify,
    logger: logger,
  );
  final picker = ImagePicker();
  // Android: use the system Photo Picker (backported to older versions via
  // Play services). The legacy gallery intent ignores the multi-select
  // limit, so users could pick more than the 5-photo maximum.
  final pickerPlatform = ImagePickerPlatform.instance;
  if (pickerPlatform is ImagePickerAndroid) {
    pickerPlatform.useAndroidPhotoPicker = true;
  }

  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<Logger>(logger)
    ..registerSingleton<ErrorReporter>(reporter)
    ..registerSingleton<Guard>(guard)
    ..registerSingleton<ApiClient>(api)
    // ── Repositories (stateless → root scope) ──────────────────────────
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: AuthRemoteDataSource(
          api.dio,
          baseUrl: config.authApiBaseUrl,
        ),
        local: authLocal,
        social: const UnconfiguredSocialAuthDataSource(),
        guard: guard,
        logger: logger,
        sessionExpiry: sessionExpiry,
      ),
    )
    ..registerLazySingleton<RemoteConfigRepository>(
      () => RemoteConfigRepositoryImpl(
        isDev
            ? const FakeRemoteConfigRemoteDataSource()
            : RemoteConfigRemoteDataSource(api.dio),
        guard,
      ),
    )
    // Onboarding step 11 (country / coordinates + distance in miles).
    ..registerLazySingleton<LocationPreferenceRepository>(
      () => LocationPreferenceRepositoryImpl(
        DiscoveryRemoteDataSource(api.dio),
        guard,
      ),
    )
    ..registerLazySingleton<LocationRepository>(
      () => LocationRepositoryImpl(const DeviceLocationDataSource(), guard),
    )
    ..registerLazySingleton<ImageCompressor>(() => const ImageCompressor())
    ..registerLazySingleton<FaceVerificationRepository>(
      () => FaceVerificationRepositoryImpl(
        ImageCaptureDataSource(picker),
        SelfieFaceDetector(),
        // Dev hits the real backend too now; the fake stays for offline use.
        // isDev
        //     ? const FakeFaceVerificationRemoteDataSource()
        //     : FaceVerificationRemoteDataSource(api.dio),
        FaceVerificationRemoteDataSource(api.dio),
        guard,
        getIt<ImageCompressor>(),
      ),
    )
    ..registerLazySingleton<PhotoPickerRepository>(
      () => PhotoPickerRepositoryImpl(
        GalleryDataSource(picker),
        guard,
        getIt<ImageCompressor>(),
      ),
    )
    ..registerLazySingleton<AiBioRepository>(
      () => AiBioRepositoryImpl(AiBioRemoteDataSource(api.dio), guard),
    )
    ..registerLazySingleton<OnboardingSubmissionRepository>(
      () => OnboardingSubmissionRepositoryImpl(
        OnboardingRemoteDataSource(api.dio),
        guard,
      ),
    )
    ..registerLazySingleton<OnboardingProfileRepository>(
      () => OnboardingProfileRepositoryImpl(
        OnboardingRemoteDataSource(api.dio),
        guard,
        imageBaseUrl: config.imageBaseUrl,
      ),
    )
    ..registerLazySingleton<MarriageRepository>(
      () => MarriageRepositoryImpl(
        isDev
            ? const DummyMarriageDataSource()
            : MarriageRemoteDataSource(api.dio),
        guard,
      ),
    )
    // Dummy-only for now — no Explore API exists yet.
    ..registerLazySingleton<ExploreRepository>(
      () => ExploreRepositoryImpl(const DummyExploreDataSource(), guard),
    )
    // Profile from /v1/onboarding/status (TODO(api): profile API);
    // membership + settings dummy until their APIs exist.
    ..registerLazySingleton<MenuRepository>(
      () => MenuRepositoryImpl(
        MenuRemoteDataSource(api.dio),
        DummyMenuDataSource(),
        guard,
        imageBaseUrl: config.imageBaseUrl,
      ),
    )
    // Dummy-only for now — no Feed API exists yet.
    ..registerLazySingleton<FeedRepository>(
      () => FeedRepositoryImpl(DummyFeedDataSource(), guard),
    )
    // ── Session ────────────────────────────────────────────────────────
    ..registerLazySingleton<SessionScopeManager>(
      () => SessionScopeManager(getIt<AuthRepository>(), reporter),
    )
    // SessionScopeManager is the SessionLifecycle sign-out drives.
    ..registerFactory<SignOut>(
      () => SignOut(getIt<AuthRepository>(), getIt<SessionScopeManager>()),
    )
    // ── Blocs (a new one per page) ─────────────────────────────────────
    ..registerFactory<AuthBloc>(
      () => AuthBloc(getIt<AuthRepository>(), getIt<SignOut>()),
    )
    ..registerFactory<SignInBloc>(() => SignInBloc(getIt<AuthRepository>()))
    ..registerFactory<SignUpBloc>(() => SignUpBloc(getIt<AuthRepository>()))
    ..registerFactory<PhoneVerificationBloc>(
      () => PhoneVerificationBloc(getIt<AuthRepository>()),
    )
    ..registerFactory<RemoteConfigBloc>(
      () => RemoteConfigBloc(getIt<RemoteConfigRepository>(), info.version),
    )
    ..registerFactory<FaceVerificationBloc>(
      () => FaceVerificationBloc(getIt<FaceVerificationRepository>()),
    )
    ..registerFactory<LivenessCaptureBloc>(
      () => LivenessCaptureBloc(getIt<FaceVerificationRepository>()),
    )
    ..registerFactory<UserLocationBloc>(
      () => UserLocationBloc(getIt<LocationRepository>()),
    )
    // These read session-scoped repositories, resolved when the page opens.
    ..registerFactory<OnboardingBloc>(
      () => OnboardingBloc(
        getIt<OnboardingDraftRepository>(),
        getIt<PhotoPickerRepository>(),
        getIt<AiBioRepository>(),
        getIt<OnboardingSubmissionRepository>(),
        getIt<OnboardingProfileRepository>(),
      ),
    )
    ..registerFactory<DiscoveryFiltersBloc>(
      () => DiscoveryFiltersBloc(
        getIt<DiscoveryFiltersRepository>(),
        getIt<AuthRepository>(),
        getIt<LocationPreferenceRepository>(),
      ),
    )
    ..registerFactory<MarriageFeedBloc>(
      () => MarriageFeedBloc(
        getIt<MarriageRepository>(),
        getIt<DiscoveryFiltersRepository>(),
      ),
    )
    ..registerFactory<ExploreBloc>(
      () => ExploreBloc(getIt<ExploreRepository>()),
    )
    ..registerFactory<FeedBloc>(() => FeedBloc(getIt<FeedRepository>()))
    ..registerFactory<MenuBloc>(() => MenuBloc(getIt<MenuRepository>()))
    ..registerFactory<SettingsBloc>(
      () => SettingsBloc(getIt<MenuRepository>()),
    )
    ..registerFactory<EditProfileBloc>(
      () => EditProfileBloc(getIt<MenuRepository>()),
    )
    ..registerFactoryParam<PostDetailBloc, FeedPost, void>(
      (post, _) => PostDetailBloc(getIt<FeedRepository>(), post),
    )
    ..registerFactoryParam<ProfileBloc, FeedAuthor, void>(
      (author, _) => ProfileBloc(getIt<FeedRepository>(), author),
    )
    ..registerFactory<CreatePostBloc>(
      () => CreatePostBloc(getIt<FeedRepository>()),
    );
}

/// Pushes the [sessionScope] with the signed-in user's repositories.
void pushSessionScope() => getIt.pushNewScope(
  scopeName: sessionScope,
  init: (scope) => scope
    ..registerLazySingleton<DiscoveryFiltersRepository>(
      InMemoryDiscoveryFiltersRepository.new,
      dispose: (r) => (r as InMemoryDiscoveryFiltersRepository).dispose(),
    )
    ..registerLazySingleton<OnboardingDraftRepository>(
      InMemoryOnboardingDraftRepository.new,
      dispose: (r) => (r as InMemoryOnboardingDraftRepository).dispose(),
    ),
);

/// Drops the [sessionScope], running each dispose callback.
Future<void> dropSessionScope() async {
  if (getIt.hasScope(sessionScope)) await getIt.dropScope(sessionScope);
}
