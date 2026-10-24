# Pending

Work that's been scoped but not started. Newest first. Move an item out
(or delete it) once it's done.

---

## Marriage tab — small copy/icon fixes (undecided)

**Added:** 2026-10-18 · **Status:** owner undecided — don't change yet

Found comparing against the reference app screenshots
(`resources/reference/marriage/`). Decision on 2026-10-18: action buttons
now pinned like the reference; button colours/icons, top bar, chip style
and everything else stay as the Figma.

- [ ] Stray space in "Don't wait , chat with {name} now." (compliment box)
- [ ] Favourite in the footer uses the share/upload icon — reference uses
      a star (☆)
- [ ] Compliment placeholder "…about their profile or about her" —
      reference is gender-neutral "…about their profile"

---

## Marriage tab → real `/profiles/cards` API

**Added:** 2026-10-18 · **Status:** reviewed, not started — waiting on
backend answers

The Marriage tab still runs on `DummyMarriageDataSource` in dev
(`di.dart`) and calls `GET /discovery/profiles` expecting
`{items, nextCursor}`. The real API is `/v1/profiles/cards` →
`{data: {cards, totalReturned, limit, hasMore, viewerGender,
targetGender, targetReligion}}`.

**Blocking before mapping**
- Dev flavor: wire `MarriageRemoteDataSource` instead of the dummy.
- Endpoint + wrapper DTO (`data.cards`).
- Pagination: no cursor, just `hasMore` + `limit: 3` (swipe deck, server
  excludes seen cards?) — adapt `MarriageFeedBloc`'s `nextCursor` logic.
- `images` / `primaryPhoto` are relative (`/public/upload/...`) → prefix
  `imageBaseUrl` (same as `menu_repository_impl.dart`).
- `heightCm` comes back `null`; entity has it as required `int` → make
  nullable, hide the chip.

**Field mapping**
| UI field | API | Note |
|---|---|---|
| id | `userId` / `profileId` | which one do like/pass use? |
| name | `fullName` | rename |
| age, distanceKm, isVerified | same | ok |
| country | `country` | ok (own profile had `"dhaka"` — backend data inconsistent) |
| countryFlag, ethnicityFlag | — | derive from name via `countries.dart` |
| ethnicity | `ethnicity[]` | first / join |
| profession | `professionTitle` | rename |
| education | `educationLevel` (`bachelors`) | code→label map |
| maritalStatus | `never_married` | code→label map |
| faith | `faith[]` (`sunni`) | label map |
| bio | `aboutMe` | rename |
| photoUrls | `images` (+ `primaryPhoto`) | prefix base URL |
| similarities | `sharedInterests` | good fit |
| interests | `allInterests` | ok |
| isActiveToday | `lastActiveAt` | derive (e.g. < 24h) |
| practice | missing | `religiousPractices` exists on profile |
| area | missing | only coordinates |
| involveFamily / chatFor / marryWithin | missing | `marriageIntentions` on profile → intentions card empty |
| children | missing | `aboutYou.haveChildren` on profile |
| grewUpIn / grewUpFlag | missing | |
| futurePlans, personality, languages | missing | `personalityTraits`, `languages` on profile |
| isPhoto/Age/IdVerified | missing | |
| isPremium | missing | default false |
| (unused) | `matchScore`, `completeness`, `sharedCount` | no UI yet |

**UI**
- `profile_details.dart` renders every section unconditionally → empty
  headings / blank intentions boxes / "Grew up in " with no value. Add
  `isNotEmpty` guards.

**Ask backend**
- Privacy: card leaks the other user's exact `location.coordinates` —
  drop it, `distanceKm` is enough.
- GET or POST? (Postman curl had `--data ''` → POST.)
- Which filter query params are accepted (age, distance, country,
  ethnicity)? Without them the Filters page does nothing.
- Add missing fields: `religiousPractices`, `marriageIntentions`,
  `aboutYou.haveChildren`, `personalityTraits`, `languages`, `grewUpIn`,
  verification flags, city/area.

**Open questions (owner)**
1. Hide sections with no data now, or wait for backend fields?
2. `userId` vs `profileId` for actions?

---

## Revert client-side "step 12 = onboarding complete" once the API is fixed

**Added:** 2026-10-18 · **Status:** waiting on backend

The complete-onboarding endpoint is broken, so for now saving Location
(step 11 → server `currentStep` 12) counts as complete on the client and
the user goes straight to Marriage. Filters are no longer an onboarding
step; they're opened from Marriage only ("Apply" goes back). When the
backend is fixed, revert these (old code is kept commented out next to each):
- `OnboardingStatusResume.isEffectivelyCompleted` (`auth_dtos.dart`) → back
  to `data.isCompleted` in `AuthRepositoryImpl._startSession` /
  `restoreSession`.
- `DiscoveryFiltersBloc._onDiscover` → `_auth.completeOnboarding()` instead
  of `markOnboardingCompleteLocally()` (then drop that repo method).
- `authTokenRefresher` → `onboardingComplete: dto.onboardingComplete`.
- Decide whether filters stay Marriage-only. The rest of the flow
  (`resumeRouteFor`, `RoutePaths.onboarding`, Location page, Add filters
  "Apply") depends on that decision.

---

## profile_view — shared member profile as its own feature

**Added:** 2026-10-16 · **Status:** design agreed in principle, one decision open

**Goal:** one member-profile UI used from many places, both embedded in a
screen (Marriage tab) and as its own routed screen (Explore, chat, …).
Today the profile lives inside `features/marriage/` (`MarriageProfile`,
`ProfileHero`, `ProfileDetails`, sections, action buttons) and nothing else
can use it; Explore cards just show "Coming soon".

**User requirements**
- New feature `lib/features/profile_view/` that depends on **no** other
  feature; other features depend on it.
- Provides both: an embeddable **widget** (`ProfileView`) and a **screen
  with a route** (`ProfileViewPage`, `/profile/:id`).
- Action buttons (pass · undo · message · like) are **part of
  profile_view**, **pinned at the bottom** — the page scrolls, the buttons
  don't. **Undo is hidden** on the first profile / when there's no previous
  profile.
- For now connect it **only to Marriage**; the Marriage tab must look the
  same as before the split (check on device vs current screenshots).
- No backend profile endpoints yet (`/discovery/profiles`, `/profiles/:id`
  → 404 on 2026-10-16): build the full structure (domain / data /
  presentation, repository, remote data source placeholder) running on
  **dummy data**; the user will provide the API later.

**Proposed approach (no architecture exception needed)**
- `profile_view` owns: `domain/` (`MemberProfile`, `ProfileViewRepository
  .getProfile(id)`), `data/` (dummy + remote placeholder, cache),
  `presentation/` (`ProfileViewBloc`, `ProfileView` widget,
  `ProfileViewPage`).
- Embedding goes through the **router** (already the one place allowed to
  see every feature): `MarriagePage` takes a `profileBuilder` slot typed
  with plain Flutter types (`Widget Function(BuildContext, String memberId,
  {VoidCallback? onPass, onUndo, onMessage, onLike})`); `routes.dart` fills
  it with `ProfileView(...)`. Marriage never imports profile_view's
  presentation, so ARCHITECTURE.md's "features don't import each other's
  data/ or presentation/" rule holds.
- Screens that only open a profile use `context.push('/profile/<id>')`.
- Marriage keeps only feed concerns: order of members, current index,
  what pass / like / undo do.

**Open decision (ask the user before starting)**
- [ ] Marriage passes **member id only** (profile_view loads + caches it;
      recommended) **or** the full `MemberProfile` (no second load; Marriage
      then depends on profile_view's `domain/`, which the rule allows).

**Tasks once decided**
- [ ] Create `features/profile_view/` (domain, data with dummy source,
      presentation), DI registrations, route `/profile/:id`.
- [ ] Move profile widgets out of `features/marriage/presentation/widgets/`
      (hero, details, sections, intentions card, verified card, compliment
      box, footer actions, action buttons, style) into profile_view.
- [ ] Pinned bottom action bar; hide undo when there's no previous profile.
- [ ] `MarriagePage` slot + router wiring; Marriage feed holds ids/order.
- [ ] Device check: Marriage tab identical to before; `/profile/:id` opens.
- [ ] Record the slot pattern in CLAUDE.md for future embeds.

Reference: Muzz teardown — `resources/research/muzz-marriage-teardown.html`
(Muzz opens the same full profile from several places; its action row
docks above the nav while reading).

---

## Onboarding APIs still missing (login → Discover profiles)

**Added:** 2026-10-15

Verified live on 2026-10-15: profile steps 4–7, photos (step 8) +
delete, face verification (`/start` + submit, `step1..3`), and step 11
location is wired (country name / coordinates + distance in miles).

- [ ] **"Discover profiles" / finish onboarding** — the app calls
      `POST /me/onboarding/complete` (old placeholder path, auth base) and
      then expects `/onboarding/status` → `isCompleted: true`. Needs the
      real endpoint (or the step that completes onboarding).
- [ ] **Add filters (age range, ethnicities)** — kept in memory only
      (`InMemoryDiscoveryFiltersRepository`); no API to save them.
- [ ] **Steps 9 and 10** — unknown. After photos the status reports step
      9; location is 11. Confirm whether the backend sets them itself
      (e.g. on face verification) or the app must send something.
- [ ] **Location "Clear"** is app-side only — no step-11 body for "no
      location filter". (The Distance tab's "Limit to only {country}" is
      wired: the country comes from the device's reverse geocoder and, when
      on, step 11 sends `{country}` instead of coordinates.)
- [ ] **Remote config** — dev uses `FakeRemoteConfigRemoteDataSource`;
      the real `GET /config` endpoint is unconfirmed.

---

## Menu / Settings / Edit profile — UI done, editing + APIs pending

**Files:** `lib/features/menu/**`, routes `RoutePaths.menuHelp` / `settings` /
`editProfile`, old `lib/app/view/menu_page.dart` (commented out)
**Added:** 2026-10-15

Built pixel-matched from Figma (`menu`, `menu_invite`, `menu_help`,
`settings`, `menu_edit`). Real data where `/v1/onboarding/status` has it
(name, photos, verified, completeness, profile fields); dummy otherwise.

- [ ] **Profile API** — swap `MenuRemoteDataSource.getMyProfile` +
      `MyProfileResponseDto` (marked `TODO(api)`) when it exists.
- [ ] **Edit mode** — agreed approach: open the onboarding pages from
      Edit profile without the stepper, "Save" PATCHes that section and
      pops back. Needs backend confirmation that step PATCHes (or a profile
      update API) work after onboarding is complete. Until then every Edit
      row shows "Coming soon".
- [ ] **Rows onboarding never collects** (family involvement, living
      arrangements, tagline, employer, sect, family plans, polygamy) —
      need designs + API fields.
- [ ] **Membership / settings / gold badge** — dummy, in-memory
      (`DummyMenuDataSource`); need APIs. Email + phone show "—" unless the
      status payload's `user` carries them.
- [ ] **No design yet:** Safety & Advice, Preview tab, Help sub-pages
      (tickets, report, contact, search), notifications, upgrade/pricing,
      Manage account actions (Sign out works).
- [ ] **Fonts** — design uses Outfit + Plus Jakarta Sans in places; only
      Satoshi is bundled, so those render in Satoshi.
- [ ] **Bottom-nav Menu avatar** still uses the placeholder image, not the
      member's photo.

---

## Step 8 photos: keep/remove contract for already-uploaded photos

**Files:** `lib/features/onboarding/data/repositories/onboarding_submission_repository_impl.dart`
(`submitPhotos`, marked `TODO(api)`), `onboarding_profile_repository_impl.dart`
(prefill), `lib/core/ui/components/app_photo.dart`
**Added:** 2026-10-15

Already-uploaded photos (`profile.images` from `/v1/onboarding/status`)
now prefill the Photos page as full URLs (`IMAGE_BASE_URL` +
`/public/upload/...`) and can be removed / topped up with new ones in the
UI. What the backend does with that isn't wired yet:

- [ ] **Confirm step 8 semantics with backend** — does `PATCH
      /v1/onboarding/step` (`step=8` + `images` files) *replace* the whole
      photo set or *append*?
- [ ] **Kept photos** — if it replaces: how to send the kept server
      photos alongside new files (a kept-paths field, e.g.
      `existingImages`?), or re-download + re-upload them.
- [x] **Removed photos (2026-10-15)** — `DELETE
      /v1/onboarding/images?filename=<name>` is wired: removing an
      uploaded photo deletes it on the server first (spinner on the slot;
      a failure keeps the photo and shows a toast). A delete endpoint
      suggests step 8 *appends* — confirm, then close the items above.
- [ ] **Order / main photo** — how the backend learns the new order
      (first = main photo) when kept and new photos are mixed.
- [ ] **Until then (current behaviour):** Continue uploads only newly
      picked local files (correct if step 8 appends); with none it sends
      nothing and moves on. Removals are saved immediately via the delete
      API.

---

## Guided liveness capture — API unconfirmed, no device pass yet

**Files:** `lib/features/face_verification/**` (new: `LivenessPoseEvaluator`,
`LivenessCameraController`, `LivenessCapturePage`, `FaceVerificationBloc`'s
`Liveness*` events/states), `lib/features/remote_config/domain/entities/remote_config.dart`
(`FeatureFlag.livenessEnabled`)
**Added:** 2026-10-11

Replaces the single-selfie capture with a guided 3-pose (front/left/right)
live capture behind `livenessEnabled` (`defaultValue: false` — the old
single-selfie flow stays default/untouched until this is ready). The old
`/me/verification/face` path is still there, unremoved.

- [ ] **Backend contract unconfirmed** — every guess is marked
      `TODO(api)` in `face_verification_remote_data_source.dart` and
      `face_verification_response_mapper.dart`: `startFaceSession`'s
      response shape (`sessionId`, possibly its own pose plan),
      `verifyFace`'s verdict shape (status codes, rejection body,
      immediate-verified vs 202-under-review). Confirm against the real
      backend and tighten the mapper's lenient key-guessing.
- [ ] **No manual device pass** — `LivenessConfig.yawSign` (front-camera
      mirroring can flip which physical turn direction `headEulerAngleY`
      means) and every threshold in `LivenessConfig` are starting values
      from the spec, unverified on real hardware. Needs a real Android
      *and* a real iPhone: yaw sign, low-end frame rate/jank, low
      light/backlight/glasses/hijab, two-faces-blocked, printed-photo
      spoof resistance, backgrounding mid-capture, permission-denied /
      permanently-denied paths, EXIF/size-cap on the uploaded files.
- [ ] **No liveness verdict feedback loop beyond "under review"** — same
      gap as the old flow: nothing tells the app later whether the
      server approved or rejected an `underReview` submission.
- [ ] **TTS / spoken instructions and Bengali text** — spec asked for
      both; skipped for now, since the app has no l10n infrastructure
      yet (`failure_text.dart`'s "English only until the l10n approach
      is decided" still holds). Add once l10n exists app-wide, not just
      for this screen.
- [ ] Once the above are done, flip `FeatureFlag.livenessEnabled`'s
      `defaultValue` to `true` (or set it server-side).

---

## Phone verification — bypassed, no backend API yet

**Screens:** `lib/features/auth/presentation/view/phone_number_page.dart`,
`lib/features/auth/presentation/view/phone_code_page.dart`
**Added:** 2026-10-11

Backend has no phone-verification endpoints yet (`/me/phone/code`,
`/me/phone/verify`). Both screens' "Continue" buttons skip straight to
the next screen instead of calling `PhoneVerificationBloc`/
`AuthRepository`; the original dispatch is commented out in place
(search `TODO(phone-api)`), not deleted.

- [ ] `phone_number_page.dart` `_next()`: uncomment the
      `PhoneNumberSubmitted` dispatch, remove the direct `context.push`
- [ ] `phone_code_page.dart` `_submit()`: uncomment `PhoneCodeSubmitted`,
      remove the direct `context.push`; un-suppress the `_code` getter
      (`// ignore: unused_element`)
- [ ] "Resend code" (`PhoneCodeResendRequested`) was **not** bypassed —
      still calls the same unavailable API if tapped
- [ ] Once verified, `isPhoneVerified` is read from the onboarding-status
      API (`user.isPhoneVerified`) for resume routing — confirm the
      backend actually flips this once `/me/phone/verify` succeeds

---

## Onboarding resume — gaps past Bio (backend step-tracking stops at 7)

**Files:** `lib/router/app_router.dart` (`resumeRouteFor`),
`lib/features/onboarding/data/repositories/onboarding_profile_repository_impl.dart`
**Added:** 2026-10-11

The onboarding-status API's `currentStep` only tracks steps 4-7 (Basics →
Bio); nothing backend-side tracks progress through phone/photos/face
verification the same way.

- [ ] **Resume re-does photos/face verification**: once phone is
      verified, `resumeRouteFor` always sends a returning user to
      `addPhotos` — there's no signal for "already added photos" or
      "already passed face verification but hasn't hit Discover
      profiles yet." Needs either backend step-tracking extended past 7,
      or reading the status payload's `photos`/`verifications` arrays
      client-side as a completion signal.
- [x] **Step 8 (photos) wired (2026-10-15)**: "Continue" on Add photos
      sends `PATCH /v1/onboarding/step` multipart (`step=8` + repeated
      `images` files) via `PhotosSubmitted` →
      `OnboardingSubmissionRepository.submitPhotos`, then opens face
      verification. Still open: the response's `profile.images`
      (`/public/upload/...` paths) isn't read, and resume/prefill doesn't
      restore server-side photos into the draft.
- [ ] **Prefill field names unconfirmed past Basics**: `educationLevel` /
      `professionTitle` / `getToknowDuration` / `marriageTimeline`
      (step 5) and `aboutMe`'s location (step 7) in
      `OnboardingProfileDto` are same-name-as-the-submit-request
      guesses — only `maritalStatus` / `faith` / `religiousPractices` /
      the `aboutYou` / `lifestyle` / `interests` nesting were confirmed
      against a real payload. Verify against a real post-step-5 and
      post-step-7 payload and fix any mismatches.

---

## Marriage tab — profile details below the first photo

**Screen:** `lib/features/marriage/presentation/screens/marriage_screen.dart`
**Added:** 2026-09-30

**Status (2026-10-03): full-profile layout built; pixel-match pass ~90% done.**
Detailed progress log + resume steps: `resources/docs/MARRIAGE_SCREEN_PROGRESS.md`.

> ⚠️ `lib/main.dart` still has a **TEMP-VERIFY** design size
> (`Size(392.7, 802.9)`, the Pixel 5's size) — revert to `_designSize`
> before shipping or testing on another device.

- [x] Get the full-resolution "full profile" design (1560×24700, 4x)
- [x] Build the detail sections between the photos
- [ ] Finish pixel-match pass (see progress file: bio wrap, card internals)
- [ ] Button actions beyond UI: Save (shortlist), Message, Previous history
- [ ] Sort (⇅) and Notifications (bell) — currently "coming soon" snackbars
- [ ] Replace dummy profiles / placeholder photos with the discovery API
      (apply `DiscoveryFilters` server-side)

---

## Photo validation on "Add your photos"

**Screen:** `lib/features/onboarding/verification/presentation/screens/add_photos_screen.dart`
**Added:** 2026-09-30

Check each photo right after it's picked (multi-select already fills
several slots at once). Client-side checks are UX only — a modified app can
skip them — so the server must re-check on upload.

### 1. File checks (on-device, no new packages)
- [ ] Format: JPG / PNG / HEIC / WebP only
- [ ] Size: roughly 50 KB – 10 MB
- [ ] Decodes, and resolution ≥ ~400×400 (`ui.instantiateImageCodec`)
- [ ] Reject duplicates (same photo picked twice)

### 2. Content checks (on-device, ML Kit face detection — already installed)
- [ ] Main (first) photo: exactly one face, large enough — enforces the
      "face clearly in first photo" and "no group photos as main picture"
      guidelines
- [ ] Other photos: optional, e.g. warn when no person is detected
- [ ] (Optional) Blur detection — needs the `image` package; heuristic,
      expect false positives

### 3. Explicit / offensive content (server-side)
- [ ] Run moderation on upload — AWS Rekognition `DetectModerationLabels`
      or Google Cloud Vision SafeSearch. No reliable on-device option.
- [ ] Leave a client stub until the backend exists
- "Recent photos only" can't be enforced reliably (EXIF dates are often
  stripped) — handle via reporting/moderation instead.

### Decisions needed before building
1. Face check on the first photo only, or on every photo?
2. On failure: remove the photo with a message, or keep it with a red
   warning badge so the user can replace it?
3. OK to move the face detector (`SelfieFaceChecker`, currently in
   `features/auth/face_verification/data/`) into `core/`? Features can't
   import each other, so onboarding can't reuse it where it is.
