# find_a_nikah — Architecture Rules

Source docs: `resources/docs/01_COMBINED_ARCHITECTURE_PLAN.md`, `02_LEARNING_PREREQUISITES.md`,
`03_QUICK_REFERENCE.md`. Those docs are the design intent; this file resolves the places
where they conflict with each other or with the code actually in `lib/`, and is the one
to follow when the two disagree.

## Philosophy
Pragmatic production-ready: start each feature simple, add structure only when the
feature's own complexity demands it. Don't pre-build layers "because the diagram has them."

## Model layer: use Freezed
All new data models (entities, API response models, provider state) use `freezed` +
`json_serializable`, per the docs.

`freezed` / `freezed_annotation` / `json_serializable` are installed (added with
`features/auth`; `freezed` is pinned to 3.x because 4.x needs Dart ≥3.13 and the SDK
constraint is 3.12). Run `dart run build_runner build` after adding/changing a Freezed
class. Freezed 3 syntax: `abstract class X with _$X` for data classes, `sealed` for
unions. Pure UI state (e.g. `FaceVerificationState`, `DiscoveryFilters`) skips
`fromJson`/`toJson` — only add `part 'x.g.dart'` when the model actually crosses the
network. Existing `OnboardingData`
(`lib/features/onboarding/state/onboarding_data.dart`) still uses a manual
`@immutable` + `copyWith` pattern — migrate it to Freezed the next time that file is
touched for a feature reason; don't do a drive-by rewrite otherwise.

## Feature layering: incremental, not upfront clean architecture
For each new feature (`auth`, `profile`, `discovery`, `chat`, `feed`, ...):
- Start with `presentation/` only (screens, widgets, providers/state) — this is what
  `features/onboarding/` already does and it's correct for a feature with no real
  backend calls yet.
- Add `data/` (datasources + repository) once the feature makes actual API/socket calls.
- Add `domain/` (entities + repository interface + usecases) only when one of these is
  true, per the docs' own migration-path rule:
  - the same business logic is needed by 2+ features, or
  - a single ViewModel/Notifier exceeds ~50 lines of logic, or
  - the logic is meaningfully independent of any UI state.
Do not create empty `domain/` or `data/` folders in advance "for consistency" — the
full 4-layer diagram in guide 01 is the ceiling, not the starting point.

## Riverpod: follow the installed v3 API, not the docs' code snippets
`pubspec.yaml` pins `flutter_riverpod: ^3.4.2`. The docs' code samples are written
against an older Riverpod API (`StateNotifierProvider` / `StateNotifier`). That API is
legacy under Riverpod 3. `OnboardingController` already does this correctly with
`Notifier` / `NotifierProvider` — follow that pattern:
- Simple/complex mutable state → `Notifier<T>` / `NotifierProvider<Notifier, T>`
- Async data (one-shot) → `AsyncNotifier<T>` / `FutureProvider` per the docs' guidance
  on *when* to use which provider type — just implement it with v3 classes.
- Everything the docs say about `.watch()` vs `.read()`, `.select()`, `.family`,
  provider naming (`xProvider`, `xRepositoryProvider`, `xStateProvider`, etc.), and
  provider overrides for testing still applies as written — only the base class names
  are outdated in the docs' snippets.

## Infra dependencies: add when the feature needs them, not upfront
The docs' Week-1 plan calls for Hive, `flutter_secure_storage`, Firebase (Crashlytics +
FCM), and `geolocator` as foundation work. None are in `pubspec.yaml` and there is no
backend integration yet (`ApiEndpoints.baseUrl` still defaults to `localhost:3000`).
Add each dependency at the point it's actually used:
- `flutter_secure_storage` + Hive → when building auth (token storage) / profile
  (cache) / chat (message cache).
- Firebase Crashlytics + FCM → when building auth (crash context) / notifications.
- `geolocator` → already added (centres the distance-filter map in
  `features/auth/location`); reuse it for discovery.
Don't scaffold `core/storage/`, `core/error/`, `core/logging/` before a feature needs
what they'd hold.

## Maps & face verification (decided with `features/auth`)
- Maps: `flutter_map` + `latlong2` on OpenStreetMap tiles (vendor-free, no API key).
  Keep `userAgentPackageName` set and the attribution widget visible — both are OSM
  tile-policy requirements. Don't add Google Maps alongside it.
- Face verification: on-device gate only, via `google_mlkit_face_detection`
  (exactly one frontal, eyes-open face before upload — see `SelfieFaceChecker`).
  Selfie ↔ profile-photo *matching* is a server-side concern (AWS Rekognition
  `CompareFaces` or equivalent) because a client-side match verdict can be spoofed;
  `FaceVerificationController.submit()` is the stub to replace with that call. Don't
  pull in on-device face-recognition/embedding packages to "verify" identity locally.
- Platform floors set for ML Kit: iOS 15.5 (`Podfile`, `project.pbxproj`,
  `AppFrameworkInfo.plist`), Android minSdk stays at Flutter's default 24.

## REST vs Socket.IO (unchanged from docs — follow as written)
- REST (Dio): historical data, pagination, mutations, anything needing a confirmed
  response (login, send message, like post, get profile).
- Socket.IO: push-only notifications (new message arrived, new post, typing
  indicator). Socket handlers must never write directly into provider/notifier state —
  they feed a stream that the notifier merges, per guide 01 "Gotchas #4".

## Caching (unchanged from docs — follow as written)
Cache to Hive only after a successful API response; fall back to cache on failure;
invalidate on logout; see guide 01's cache table for what's worth caching per feature.

## Naming & structure conventions (unchanged from docs — follow as written)
- File names: `[feature]_[layer].dart` (`profile_repository.dart`,
  `profile_remote_datasource.dart`), snake_case, no `_impl` redundancy beyond what the
  docs show, no `_screen.dart` (prefer `_page.dart` — note: existing onboarding screens
  already use `_screen.dart`; don't rename existing files for this alone, but use
  `_page.dart` for brand-new top-level route widgets going forward if introducing a
  parallel convention feels worse than just matching what's there — when in doubt,
  match the existing `_screen.dart` convention already used throughout `features/`).
- `core/` never imports from `features/` (the one sanctioned exception is
  `core/router/`, which has to see every feature's route table). Features never import
  each other directly — share through `core/`. Widgets used by 2+ features live in
  `core/ui/components/` (`WizardScaffold`, `AppPrimaryButton`, `WizardProgressBar`,
  `LegalFooterText`, `SearchableSelectList`) and shared static data in
  `core/constants/` (`countries.dart`). Data that must cross a feature boundary at
  runtime (e.g. the onboarding photo handed to face verification) travels as go_router
  `extra`, not via another feature's provider.
- `features/auth/` is split into sub-features (`face_verification/`, `location/`),
  each with its own `presentation/` (and `data/` only where there's a real datasource —
  `face_verification/data/selfie_face_checker.dart` wraps ML Kit). Routes for the whole
  feature sit in `features/auth/auth_routes.dart`, mirroring `OnboardingRoutes`.
- `features/onboarding/` uses the same sub-feature split, one per part of the flow:
  `entry/` (splash, intro, welcome, login), `signup/` (email, code, password, get
  started), `profile/` (Account type → Bio; `screens/` split into the 3 progress
  sections `basics/`, `background_faith/`, `lifestyle_personality/`), and
  `verification/` (phone, OTP, photos). State shared across parts
  (`OnboardingController`/`OnboardingData`) lives in `features/onboarding/state/`,
  widgets used by 2+ parts in `features/onboarding/widgets/`, and routes in
  `features/onboarding/onboarding_routes.dart`. A new screen goes in the part (and
  section) it belongs to.
- Wizard parts are go_router `ShellRoute`s with a persistent header + progress bar
  (`RoutedWizardShell` in `core/ui/components/wizard_shell.dart`); titles/sections
  come from a `WizardSections` list, not from the screens. Profile's list is
  `OnboardingRoutes.wizardSections`; the Verification part spans onboarding + auth
  routes, so its shell and list live in `core/router/verification_routes.dart`.
- Main app = go_router `StatefulShellRoute.indexedStack` with a bottom nav
  (`MainNavShell` in `core/ui/components/main_nav_shell.dart`): Marriage · Explore ·
  Feed · Chat · Menu, each tab keeping its own state. Marriage is
  `features/marriage/` (routes in `features/marriage/marriage_routes.dart`); the other
  tabs are `PlaceholderScreen`s until their features exist (paths in `RoutePaths`).
- Discovery filters (`DiscoveryFilters` + controller) live in `core/filters/` — edited
  by `features/auth/location`, consumed by `features/marriage` (the feed restarts when
  they change).
- Auth is still a stub: `core/providers/session_provider.dart` is an in-memory
  "signed in" flag the router's redirect reads. Set by the intro's Skip (temporary
  shortcut into the app) and by "Discover profiles". Replace with real auth state.
- Provider dependencies always go through Riverpod providers, never direct
  instantiation of a repository/datasource in a widget or another provider's body.

## Known deviations already in the codebase (not yet resolved — flagging, not fixing silently)
- None currently. (Resolved: the orphaned `lib/start/onboardng/` scratch file is
  gone, and the splash screen now lives in
  `features/onboarding/entry/presentation/screens/`. `lib/start/` is an empty
  leftover directory.)
