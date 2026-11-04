# Pending

Work that's been scoped but not started. Newest first. Move an item out
(or delete it) once it's done.

---

## Support tickets — backend contract received, nothing built

**Added:** 2026-10-29 · **Status:** UI is two "coming soon" stubs in
`help_page.dart`; REST + socket exist on the backend

REST + socket contract and backend issues live in
`resources/docs/SUPPORT_TICKETS.md`.

- [ ] Backend: attachment shape/upload, status/category/priority
      constants, closed-ticket guard (see doc)
- [ ] Build `features/support/` (tickets list, ticket thread, new ticket)
      with a Retrofit data source + socket push; needs `socket_io_client`

---

## Explore — 6 sections + Passed live; waiting on backend fixes

**Added:** 2026-10-25 · **Updated:** 2026-10-27 · **Status:** wired to
`feed/near-you`, `just-joined`, `second-look`, `visited-you`, `passed`,
`likes/who-liked-me` ("People who liked you" on For you) and
`likes/like-list` (My history → Liked) (Drift cache-then-network, paged
12/page, nothing locked while everything is free). "Currently available"
and My history's Favourited / Complimented are still
`DummyExploreDataSource` (no API).

Checked on a phone against the real response payloads (fixtures in
`test/fixtures/explore/`, served by a local mock; the dev ngrok URL was
down on 2026-10-27). Backend items:

- [ ] `passed`: `totalCount` says 3 but only 2 profiles come back. The
      missing one is the pending test account Amira (completeness 35, not
      verified). Same filter seems to hide those accounts from
      `second-look` and `just-joined`, so a "pass, then they like me back"
      scenario can't be produced with them. Need to know what makes a
      profile eligible (verified? completeness?).
- [ ] **`like-list` returns who liked ME, not who I liked** (same data,
      `tag: "Who Liked You"`, as `who-liked-me`). Checked 2026-10-27 on the
      new dev URL: seed account f1 liked the QA account via
      `POST /v1/profiles/swipe`; QA's `like-list` and `who-liked-me` both
      list f1, while f1's own `like-list` is empty. My history → Liked
      therefore shows the wrong people until the backend returns sent
      likes (or gives another endpoint).
- [ ] Open question (decide later): should someone who liked me still
      show in "People who liked you" once it becomes a match
      (`likeStatus` other than `pending`)? Today every returned row shows.
- [ ] Open question (decide later): do `who-liked-me` / `like-list` hide
      low-completeness (35) unverified accounts like the other feeds?
      The seed accounts showed up in `who-liked-me`, so apparently not.
- [ ] `like-list` returns the same people twice (`likes` wrapper with
      `likedAt`, and flat `profiles`); the flat list's order differs from
      `likes`. The app shows the flat order and takes the time from `likes`.
- [ ] near-you now returns `city` and `distanceKm` (earlier all null), but
      the sample profiles use `faith: ["sunni"]` (a sect) and photos
      `/public/upload/sample_*.jpg`. Re-check on real data.
- [ ] "active" window looks like about 7 days: near-you was empty once
      everyone's `lastActiveAt` was older.
- [ ] `faith` and `sect` carry identical values on the seeded profiles.
- [ ] Unlocked `like-list` item shape confirmed (wrapper + flat), but a
      locked response (`locked: true`) hasn't been seen since the change.

---

## Voice calls — UI on a fake call, SDK + signalling pending

**Added:** 2026-10-24 · **Status:** screens done on `DummyCallDataSource`
(no audio); waiting on calling SDK choice (decisions register #13) and
backend signalling

Chat room 📞 → `/call` (dialing → ringing → connected, the dummy peer
always answers after ~5s). Dev flavor: ⋮ → "Simulate incoming call" →
`/call/incoming` (Accept / Decline / quick message; missed after 30s).
Ended → "Call ended" for 2s → back to chat, which gets a call line.

- [ ] Real calls: managed SDK (LiveKit / Agora / …) behind
      `CallRepository`; mic permission; audio session / speaker routing
- [ ] Real incoming calls: push (CallKit on iOS, ConnectionService /
      full-screen intent on Android) + an app-scoped listener that opens
      the call screen from anywhere — today only the dev menu rings
- [ ] Call records should come from the server, not `logCall` on the
      client
- [ ] Back currently ends the call; needs a minimised in-call bar to keep
      it running behind other screens
- [ ] In-call profile button is a "coming soon" toast
- [ ] Proximity sensor / screen-off while at the ear

---

## Chat (messaging) — UI on dummy data, API + realtime pending

**Added:** 2026-10-24 · **Status:** UI done on `DummyMessagingDataSource`
(`assets/dummy/messaging.json`); waiting on backend

Contract: `resources/docs/MESSAGING_API.md`.

Chat tab → Marriage lists active conversations over the free slots; empty
slot → Matches panel → pick a match → it takes a slot on the list
(empty row, "Say salaam…") → tap the row → chat room (`/chat/room`, peer
as `extra`). Text only. Statuses sending → sent → delivered → seen, typing
indicator and auto-replies are all faked by the dummy source.

**Matches panel is live (2026-11-02):** `GET /v1/matches/my-matches`
(`MatchesRemoteDataSource`) feeds the panel; conversations + messages are
still dummy, so picking a real match opens a *fake* conversation with
that person's name and photo (auto-replies included).

**Conversations + messages wired over REST (2026-11-04, untested against
the live server):** `MessagingRepositoryImpl` uses `ChatRemoteDataSource`
(list, open, history with `before` cursor, send, mark-read), text only.
No socket yet, so it polls (list 10s, open thread 3s). Replies, typing and
call records have no backend: replies are dropped on send, call lines are
local-only. The dummy version is `DummyMessagingRepositoryImpl` (swap in
`di.dart`).

**Slots (decided 2026-11-02):** keep the 5 slots on the frontend. When the
conversations API is wired, fill them from the list as it comes (in order,
no saved position). Switch to a server `slot` field once the backend has
one.

- [ ] Real data source: conversation list, message history (cursor
      paging, older messages on scroll-up), send, mark-read
- [ ] Backend: add a `slot` (0–4) to conversations + enforce the 5-chat
      limit on `POST /conversations/:userId`; then read it instead of
      filling slots in list order
- [ ] Matches are fetched once per Chat tab visit (the tab keeps its
      state), so a match made mid-session needs a restart — add refresh
      (on panel open or pull-to-refresh)
- [ ] Matches: `canMessage` and `status` are read but not used yet (a
      `canMessage: false` match still shows); confirm `status` values
- [ ] Every match already has a server conversation (`conversationId` in
      `my-matches`). When conversations go live, decide which rows show
      in the panel vs the slots (e.g. panel = `lastMessagePreview` null)
- [ ] No presence in the API: peers never show "Online", only "Last seen"
      from `lastActiveAt`
- [ ] Realtime (decisions register #12): new message / status / typing
      / presence events feed the repository streams, never bloc state;
      close the socket in `SessionScopeManager.closeConnections`
- [ ] `myId` from the auth session instead of the fixture's `meId`
- [ ] Offline cache for messages (register #9) — currently in-memory
- [ ] 5-slot limit is display-only; server must enforce it
- [ ] "Coming soon" stubs: attachments (+), voice messages (mic), voice
      call (header; video call removed 2026-10-24), and the header's "⋮"
      menu — View profile, Mute, Clear chat, Unmatch, Block, Report
- [ ] Not built yet: long-press actions (copy / delete / report / block),
      Friends tab chats, conversation search, the list's "•••" menu

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
- [x] Compliment placeholder is now the gender-neutral "…about their
      profile" (2026-10-27)

**Compliment / message button (2026-10-27):** the middle action button
opens a full-screen Compliment page (per the reference video) and sends it
through `POST /v1/profiles/swipe` `{action: "complement", text,
targetUserId}` — spelled "complement"; "compliment" is a 400, empty text a
500. The sent text shows above the profile photo with a spinner, then a
double tick. The server treats it as a like (profile leaves the deck, can
match, shows in their "People who liked you"), so undo can't bring it back.
It also returns `conversationId` / `messageId`, unused until Chat is real.

- [ ] If the send fails the strip is removed and the error toast shows; the
      typed text is lost (could keep it on the Compliment page and retry).
- [ ] Backend: does a complement to someone who already liked me match?
      Not tried yet.

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

- [x] **Profile API** — Menu / Edit profile read `GET /v1/profiles/me`.
- [x] **Edit mode (2026-10-31)** — Muzz-style: each row opens its own
      field page, Update enabled once something changes, saved with
      `PATCH /v1/profiles/me`. Plan, decisions and what's left:
      `resources/docs/EDIT_PROFILE_PLAN.md`.
- [ ] **Still "coming soon" in Edit:** Current location (how to set it
      after onboarding is unconfirmed), adding / replacing photos (no
      upload endpoint confirmed). Use-as-main and delete work.
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
