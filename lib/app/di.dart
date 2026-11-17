import 'dart:async';
import 'dart:io' show Platform;

import 'package:find_a_nikah/app/session_scope_manager.dart';
import 'package:find_a_nikah/core/core.dart';
import 'package:find_a_nikah/core/database/database.dart';
import 'package:find_a_nikah/core/logging/app_logger.dart';
import 'package:find_a_nikah/core/logging/log_error_reporter.dart';
import 'package:find_a_nikah/core/network/network.dart';
import 'package:find_a_nikah/features/auth/data/data.dart';
import 'package:find_a_nikah/features/auth/domain/domain.dart';
import 'package:find_a_nikah/features/auth/presentation/bloc/bloc.dart';
import 'package:find_a_nikah/features/calling/data/data.dart';
import 'package:find_a_nikah/features/calling/domain/domain.dart';
import 'package:find_a_nikah/features/calling/presentation/presentation.dart';
import 'package:find_a_nikah/features/chat/presentation/presentation.dart';
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
import 'package:find_a_nikah/features/messaging/data/data.dart';
import 'package:find_a_nikah/features/messaging/domain/domain.dart';
import 'package:find_a_nikah/features/messaging/presentation/presentation.dart';
import 'package:find_a_nikah/features/notifications/data/notifications_repository_impl.dart';
import 'package:find_a_nikah/features/notifications/domain/notifications_repository.dart';
import 'package:find_a_nikah/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:find_a_nikah/features/onboarding/data/data.dart';
import 'package:find_a_nikah/features/onboarding/domain/domain.dart';
import 'package:find_a_nikah/features/onboarding/presentation/presentation.dart';
import 'package:find_a_nikah/features/remote_config/data/data.dart';
import 'package:find_a_nikah/features/remote_config/domain/domain.dart';
import 'package:find_a_nikah/features/remote_config/presentation/presentation.dart';
import 'package:find_a_nikah/flavors/app_config.dart';
import 'package:find_a_nikah/core/logging/firebase_error_reporter.dart';
import 'package:firebase_core/firebase_core.dart';
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
  // Crashlytics once Firebase is initialised (bootstrap); plain logging in
  // tests and anywhere Firebase isn't set up.
  final ErrorReporter reporter = Firebase.apps.isEmpty
      ? LogErrorReporter(logger)
      : FirebaseErrorReporter(LogErrorReporter(logger));
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
  // One local database for the app; user content in it is cache only and
  // is wiped on sign-out (SessionScopeManager.end).
  final cache = JsonCache(AppDatabase());
  // Open it in the background now: the first cached screen (Explore) then
  // paints from the cache at once instead of after the database opens.
  unawaited(cache.warmUp().catchError((Object _) {}));
  final picker = ImagePicker();
  // Android: use the system Photo Picker (backported to older versions via
  // Play services). The legacy gallery intent ignores the multi-select
  // limit, so users could pick more than the 5-photo maximum.
  final pickerPlatform = ImagePickerPlatform.instance;
  if (pickerPlatform is ImagePickerAndroid) {
    pickerPlatform.useAndroidPhotoPicker = true;
  }

  final pushTaps = PushTapHandler();
  final push = PushService(api.dio, logger, pushTaps);

  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<Logger>(logger)
    ..registerSingleton<ErrorReporter>(reporter)
    ..registerSingleton<Guard>(guard)
    ..registerSingleton<ApiClient>(api)
    ..registerSingleton<PushTapHandler>(pushTaps)
    ..registerSingleton<PushService>(push)
    ..registerSingleton<PushRegistrar>(push)
    ..registerSingleton<TokenStore>(authLocal)
    ..registerSingleton<ImagePicker>(picker)
    ..registerSingleton<JsonCache>(cache)
    // ── Repositories (stateless → root scope) ──────────────────────────
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: AuthRemoteDataSource(
          api.dio,
          baseUrl: config.authApiBaseUrl,
        ),
        local: authLocal,
        social: GoogleSocialAuthDataSource(),
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
    // ..registerLazySingleton<MarriageRepository>(
    //   () => MarriageRepositoryImpl(
    //     isDev
    //         ? const DummyMarriageDataSource()
    //         : MarriageRemoteDataSource(api.dio),
    //     guard,
    //   ),
    // )
    // Real `/v1/profiles/cards` everywhere (dev too). For offline work,
    // swap back to `MarriageRepositoryImpl(const DummyMarriageDataSource(),
    // guard)`.
    ..registerLazySingleton<MarriageRepository>(
      () => MarriageCardsRepositoryImpl(
        MarriageCardsRemoteDataSource(api.dio),
        guard,
        config.imageBaseUrl,
      ),
    )
    // Dummy-only for now — no Explore API exists yet.
    // ..registerLazySingleton<ExploreRepository>(
    //   () => ExploreRepositoryImpl(const DummyExploreDataSource(), guard),
    // )
    // "Active near you" on the real API (cached); other sections dummy.
    ..registerLazySingleton<ExploreRepository>(
      () => ExploreRepositoryImpl(
        const DummyExploreDataSource(),
        ExploreRemoteDataSource(api.dio),
        cache,
        guard,
        config.imageBaseUrl,
        // Device position for "Currently available"; never prompts.
        viewerPosition: () async {
          final location = getIt<LocationRepository>();
          if (await location.checkAccess(request: false) !=
              LocationAccess.granted) {
            return null;
          }
          final here = await location.currentPosition();
          return here.fold(
            (_) => null,
            (p) => (latitude: p.latitude, longitude: p.longitude),
          );
        },
      ),
    )
    // Moved to the session scope (pushSessionScope): it now holds the
    // member's profile in memory.
    // ..registerLazySingleton<MenuRepository>(
    //   () => MenuRepositoryImpl(
    //     MenuRemoteDataSource(api.dio),
    //     DummyMenuDataSource(),
    //     guard,
    //     imageBaseUrl: config.imageBaseUrl,
    //   ),
    // )
    // Real Feed API. (The old in-memory dummy source is kept in
    // resources/outdated_code/dummy_feed_data_source.dart.txt.)
    ..registerLazySingleton<FeedRepository>(
      () => FeedRepositoryImpl(
        FeedRemoteDataSource(api.dio),
        guard,
        config.imageBaseUrl,
      ),
    )
    ..registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(api.dio, guard, config.imageBaseUrl),
    )
    // ── Session ────────────────────────────────────────────────────────
    ..registerLazySingleton<SessionScopeManager>(
      () => SessionScopeManager(getIt<AuthRepository>(), reporter, cache),
    )
    // SessionScopeManager is the SessionLifecycle sign-out drives.
    ..registerFactory<SignOut>(
      () => SignOut(
        getIt<AuthRepository>(),
        getIt<SessionScopeManager>(),
        getIt<PushRegistrar>(),
      ),
    )
    // ── Blocs (a new one per page) ─────────────────────────────────────
    ..registerFactory<AuthBloc>(
      () => AuthBloc(getIt<AuthRepository>(), getIt<SignOut>()),
    )
    ..registerFactory<SignInBloc>(() => SignInBloc(getIt<AuthRepository>()))
    ..registerFactory<SignUpBloc>(() => SignUpBloc(getIt<AuthRepository>()))
    ..registerFactory<ForgotPasswordCubit>(
      () => ForgotPasswordCubit(getIt<AuthRepository>()),
    )
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
    ..registerFactoryParam<PostDetailBloc, String, FeedPost?>(
      (postId, initial) =>
          PostDetailBloc(getIt<FeedRepository>(), postId, initial: initial),
    )
    ..registerFactoryParam<ProfileBloc, String, FeedAuthor?>(
      (userId, author) =>
          ProfileBloc(getIt<FeedRepository>(), userId, author: author),
    )
    ..registerFactoryParam<MemberSearchBloc, String, void>(
      (userId, _) => MemberSearchBloc(getIt<FeedRepository>(), userId),
    )
    ..registerFactoryParam<CreatePostBloc, FeedPost?, void>(
      (editing, _) => CreatePostBloc(getIt<FeedRepository>(), editing: editing),
    )
    // Messaging reads the session-scoped repository, resolved on open.
    ..registerFactory<NotificationsCubit>(
      () => NotificationsCubit(getIt<NotificationsRepository>()),
    )
    ..registerFactory<UnreadCountCubit>(
      () => UnreadCountCubit(getIt<MessagingRepository>()),
    )
    ..registerFactory<UnmatchedCubit>(
      () => UnmatchedCubit(getIt<MessagingRepository>()),
    )
    ..registerFactory<BlockedUsersCubit>(
      () => BlockedUsersCubit(getIt<MessagingRepository>()),
    )
    ..registerFactory<ArchivedChatsCubit>(
      () => ArchivedChatsCubit(getIt<MessagingRepository>()),
    )
    ..registerFactory<ConversationsBloc>(
      () => ConversationsBloc(getIt<MessagingRepository>()),
    )
    ..registerFactoryParam<ChatRoomBloc, ChatPeer, void>(
      (peer, _) => ChatRoomBloc(getIt<MessagingRepository>(), peer),
    )
    // param2: opened as an incoming call.
    ..registerFactoryParam<CallBloc, ChatPeer, bool>(
      (peer, incoming) => CallBloc(
        getIt<CallRepository>(),
        getIt<MessagingRepository>(),
        peer,
        incoming: incoming,
      ),
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
    )
    // The user's chats. Dummy-only for now — no chat API or socket yet.
    // ..registerLazySingleton<MessagingRepository>(
    //   () => MessagingRepositoryImpl(
    //     DummyMessagingDataSource(),
    //     getIt<Guard>(),
    //   ),
    // Matches panel is live (`my-matches`); conversations + messages are
    // still dummy until the chat API / socket are wired.
    // Live now: conversations, messages (REST, polled — no socket yet) and
    // matches. The dummy-backed version is `DummyMessagingRepositoryImpl`.
    // ..registerLazySingleton<MessagingRepository>(
    //   () => DummyMessagingRepositoryImpl(
    //     DummyMessagingDataSource(),
    //     MatchesRemoteDataSource(getIt<ApiClient>().dio),
    //     getIt<Guard>(),
    //     getIt<AppConfig>().imageBaseUrl,
    //   ),
    //   dispose: (r) => (r as DummyMessagingRepositoryImpl).dispose(),
    // )
    // The chat socket: websocket, JWT in the handshake. When the server
    // refuses the handshake (expired token) a cheap authenticated REST call
    // makes the auth interceptor refresh it before the retry.
    ..registerLazySingleton<ChatSocket>(
      () => SocketIoChatSocket(
        url: getIt<AppConfig>().socketUrl ?? getIt<AppConfig>().imageBaseUrl,
        readToken: () async => (await getIt<TokenStore>().read())?.accessToken,
        refreshToken: () async {
          await ChatRemoteDataSource(getIt<ApiClient>().dio).unreadCount();
        },
      ),
    )
    ..registerLazySingleton<MessagingRepository>(
      () => MessagingRepositoryImpl(
        ChatRemoteDataSource(getIt<ApiClient>().dio),
        MatchesRemoteDataSource(getIt<ApiClient>().dio),
        getIt<ChatSocket>(),
        getIt<Guard>(),
        getIt<AppConfig>().imageBaseUrl,
      ),
      dispose: (r) => (r as MessagingRepositoryImpl).dispose(),
    )
    // Live calls end with the session. Dummy-only — no calling SDK yet.
    ..registerLazySingleton<CallRepository>(
      () => CallRepositoryImpl(DummyCallDataSource(), getIt<Guard>()),
      dispose: (r) => (r as CallRepositoryImpl).dispose(),
    )
    // The member's own profile (`/v1/profiles/me`), kept for the session
    // and on the device so Menu / Edit profile / Settings open instantly.
    // Membership + settings dummy until their APIs exist.
    ..registerLazySingleton<MenuRepository>(
      () => MenuRepositoryImpl(
        MenuRemoteDataSource(getIt<ApiClient>().dio),
        DummyMenuDataSource(),
        getIt<Guard>(),
        imageBaseUrl: getIt<AppConfig>().imageBaseUrl,
        cache: getIt<JsonCache>(),
        onDeckReset: () => getIt<DiscoveryFiltersRepository>().reload(),
      ),
      dispose: (r) => (r as MenuRepositoryImpl).dispose(),
    ),
);

/// Drops the [sessionScope], running each dispose callback.
Future<void> dropSessionScope() async {
  if (getIt.hasScope(sessionScope)) await getIt.dropScope(sessionScope);
}
