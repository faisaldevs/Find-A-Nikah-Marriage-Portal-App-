# Find A Nikah — App Status (A–Z)

**Snapshot:** 2026-10-27 · branch `refactor/architecture`
**Sources:** code in `lib/`, `di.dart` wiring, `resources/docs/PENDING.md`, `audit/HANDOFF.md`.
Update this file when a feature or API changes state. Detailed notes for many items
live in `PENDING.md` — this file is the overview.

## Legend

| Mark | Meaning |
|---|---|
| ✅ | Done — UI built and running on the live API (or needs no API) |
| 🟢 | Done, small follow-ups left (backend data issues, polish) |
| 🟡 | UI built, runs on **dummy / in-memory data** or partly wired |
| 🟠 | Placeholder only — button shows "coming soon" |
| 🔴 | Not built (no screen / no design yet) |

**Base URLs** (`lib/flavors/env/*.json`):
- `API_BASE_URL` = `…/api` → most data sources put `/v1` in the path (`/v1/onboarding/status` = `…/api/v1/onboarding/status`).
- `AUTH_API_BASE_URL` = `…/api/v1` → auth data source paths have no `/v1` (`/auth/login` = `…/api/v1/auth/login`).
- `IMAGE_BASE_URL` → prefix for relative image paths (`/public/upload/...`).
- Dev backend is an ngrok URL that changes on restart — update `dev.json`.

---

# Part 1 — Features, pages & functions

## Overall progress

| # | Feature | Folder | Data source today | Progress |
|---|---|---|---|---|
| 1 | Auth (splash, intro, login, sign-up) | `features/auth` | Live API | 🟢 ~85% |
| 2 | Onboarding profile wizard | `features/onboarding` | Live API | 🟢 ~90% |
| 3 | Phone verification | `features/auth` | Live API | 🟢 ~90% |
| 4 | Photos | `features/onboarding` | Live API | 🟢 ~75% |
| 5 | Face verification | `features/face_verification` | Live API (contract unconfirmed) | 🟢 ~75% |
| 6 | Location & discovery filters | `features/discovery` | Location live, filters in-memory | 🟡 ~65% |
| 7 | Marriage tab (swipe deck) | `features/marriage` | Live API | 🟡 ~65% |
| 8 | Explore tab + My history | `features/explore` | Mixed live + dummy | 🟡 ~70% |
| 9 | Feed tab (community posts) | `features/feed` | Dummy only | 🟡 ~35% (UI only) |
| 10 | Chat tab (conversation list) | `features/chat` | Dummy only | 🟡 ~40% (UI only) |
| 11 | Chat room (messaging) | `features/messaging` | Dummy only | 🟡 ~40% (UI only) |
| 12 | Voice calls | `features/calling` | Dummy only | 🟡 ~30% (UI only) |
| 13 | Menu, Settings, Edit profile, Help | `features/menu` | Status API + dummy | 🟡 ~40% |
| 14 | Remote config / force update | `features/remote_config` | Fake in dev | 🟡 ~60% |
| 15 | Member profile view (shared) | `features/profile_view` (planned) | — | 🔴 0% |
| 16 | Notifications (push + in-app list) | — | — | 🔴 0% |
| 17 | Subscriptions / Gold / payments | — | — | 🔴 0% |
| 18 | Safety: block / report / moderation | — | — | 🔴 0% |
| 19 | Localisation (l10n, Bengali) | — | — | 🔴 0% |
| 20 | Realtime (Socket.IO) | — | — | 🔴 0% |

---

## 1. Auth — `features/auth` 🟢

| Page / function | Route | Status | What's left |
|---|---|---|---|
| Splash | `/splash` | ✅ | — |
| Intro carousel | `/onboarding/intro` | ✅ | "Skip" is a dev shortcut into the app — remove before release |
| Welcome | `/welcome` | ✅ | — |
| Login (email + password) | `/login` | ✅ | — |
| Forgot password | (on login page) | 🔴 | Button does nothing (`TODO(auth)`); needs screens + API |
| Google / Apple sign-in | (welcome/login) | 🟠 | `UnconfiguredSocialAuthDataSource` throws; add `google_sign_in` / `sign_in_with_apple` + OAuth client ids from backend |
| Sign-up email | `/signup/email` | ✅ | — |
| Sign-up code | `/signup/verification-code` | ✅ | — |
| Create password | `/signup/create-password` | ✅ | — |
| Get started | `/get-started` | ✅ | — |
| Session restore / token refresh | `AuthBloc`, `AuthInterceptor` | ✅ | — |
| Sign out | Menu → Manage account | ✅ | — |
| Resume onboarding where user left | `resumeRouteFor` (`app_router.dart`) | 🟢 | Backend step tracking past step 8 unclear → returning users may redo photos / face check |
| "Onboarding complete" flag | `OnboardingStatusResume.isEffectivelyCompleted` | 🟢 | Client treats step 12 as complete; revert to `isCompleted` once backend completes onboarding properly (old code commented in place) |

## 2. Onboarding profile wizard — `features/onboarding` 🟢

Three progress sections, each a `ShellRoute` with header + progress bar.

| Page | Route | API step | Status | What's left |
|---|---|---|---|---|
| Account type | `/onboarding/account-type` | 4 | ✅ | Family-flow copy wording (owner decision, audit #15) |
| Relationship | `/onboarding/relationship` | 4 | ✅ | — |
| Basic information | `/onboarding/basic-information` | 4 | ✅ | — |
| Intentions | `/onboarding/intentions` | 4 | ✅ | — |
| How heard | `/onboarding/how-heard` | 4 | ✅ | Skip sends `other` (backend requires a value) |
| Nationality | `/onboarding/nationality` | 4 | ⚠️ | Backend drops nationality on step 4 (audit #33) |
| Country | `/onboarding/country` | 4 | ⚠️ | Backend drops grewUpIn on step 4 |
| Ethnicity | `/onboarding/ethnicity` | 4 | ⚠️ | Backend drops ethnicity on step 4 |
| Height | `/onboarding/height` | 4 | ✅ | — |
| Education | `/onboarding/education` | 5 | ✅ | Confirm prefill field names against a real payload |
| Profession | `/onboarding/profession` | 5 | ✅ | Same |
| Marital status | `/onboarding/marital-status` | 5 | ✅ | — |
| Marriage timeline | `/onboarding/marriage` | 5 | ✅ | Confirm prefill field names |
| Faith | `/onboarding/faith` | 5 | ✅ | — |
| Religious practice | `/onboarding/religious-practice` | 5 | ✅ | — |
| Lifestyle preferences | `/onboarding/lifestyle-preferences` | 6 | ✅ | — |
| About you | `/onboarding/about-you` | 6 | ✅ | — |
| Personality | `/onboarding/personality` | 6 | ✅ | — |
| Interests | `/onboarding/interests` | 6 | ✅ | — |
| Bio (+ AI bio) | `/onboarding/bio` | 7 | ✅ | — |
| Wizard prefill on resume | `OnboardingProfileRepositoryImpl` | — | 🟢 | Verify step 5 / 7 field names |

## 3. Phone verification — `features/auth` 🟢

| Page | Route | Status | What's left |
|---|---|---|---|
| Phone number | `/onboarding/phone-number` | ✅ | Code sent via WhatsApp |
| Phone code | `/onboarding/phone-verification-code` | ✅ | Debug builds autofill `devCode` |
| Resend code | (on code page) | ✅ | — |
| `isPhoneVerified` for resume | onboarding status | 🟢 | Confirm backend flips it after verify |

## 4. Photos — `features/onboarding` 🟢

| Function | Status | What's left |
|---|---|---|
| Add photos page (`/onboarding/photos`), multi-pick | ✅ | — |
| Upload (step 8 multipart) | ✅ | — |
| Delete uploaded photo | ✅ | — |
| Prefill already-uploaded photos | ✅ | — |
| Replace vs append semantics, kept photos, photo order / main photo | 🟡 | Backend contract unconfirmed |
| On-device checks (format, size, resolution, duplicates, face in main photo) | 🔴 | Decisions needed (see `PENDING.md`) |
| Server-side explicit-content moderation | 🔴 | Backend work |

## 5. Face verification — `features/face_verification` 🟢

| Page / function | Route | Status | What's left |
|---|---|---|---|
| Scan your face (intro) | `/verification/scan-your-face` | ✅ | — |
| Start verification | `/verification/start` | ✅ | — |
| Single-selfie capture + ML Kit gate | `/verification/photo` | ✅ | Default flow today |
| Guided 3-pose liveness | `/verification/liveness` | 🟡 | Behind `livenessEnabled` flag (off). Needs real-device pass (yaw sign, thresholds, low light, hijab/glasses), API shape confirmed |
| Verdict after "under review" | — | 🔴 | Nothing tells the app later if approved/rejected — needs status API or push |
| Spoken instructions / Bengali | — | 🔴 | Waits on l10n |

## 6. Location & discovery filters — `features/discovery` 🟡

| Page / function | Route | Status | What's left |
|---|---|---|---|
| Location permission gate | (widget) | ✅ | — |
| Location filter: Distance tab (map + radius) | `/location`, `/filters/location` | ✅ | Saves as step 11 coordinates + distance |
| Location filter: Country tab | same | ✅ | Saves as step 11 country |
| Location "Clear" | same | 🟡 | App-side only; no API body for "no location filter" |
| Add filters (age range, ethnicities) | `/filters` | 🟡 | In memory only (`InMemoryDiscoveryFiltersRepository`); needs save API. Age + country already passed to `/v1/profiles/cards` |
| Remove filter sheet | (sheet) | ✅ | — |

## 7. Marriage tab — `features/marriage` 🟡

| Function | Status | What's left |
|---|---|---|
| Swipe deck from live API | ✅ | — |
| Full profile on card (hero, details, sections, photos) | 🟢 | Pixel-match ~90%; hide empty sections where API lacks fields |
| Pass / Like / Undo | ✅ | Live swipe API |
| Filters button → Add filters | ✅ | — |
| Compliment box | 🟠 | Shows "Compliment sent" toast only — no API |
| Message from Marriage | 🟠 | Coming soon |
| Favourite / Save (shortlist) | 🟠 | Coming soon |
| Block / Report | 🟠 | Coming soon |
| Share profile | 🟠 | Coming soon |
| "Curious about X's filters?" (filter match) | 🟠 | Coming soon, premium |
| Sort (⇅) | 🟠 | Coming soon |
| Notifications bell | 🟠 | Coming soon |
| Missing card fields from backend | ⚠️ | `religiousPractices`, `marriageIntentions`, `haveChildren`, `personalityTraits`, `languages`, `grewUpIn`, verification flags, city/area; `heightCm` null |
| Privacy: card returns exact coordinates | ⚠️ | Ask backend to drop them |
| Small copy/icon fixes | 🟡 | Owner undecided (see `PENDING.md`) |

## 8. Explore tab + My history — `features/explore` 🟡

| Section | Status | Data |
|---|---|---|
| Active near you | 🟢 | Live, cached, paged. Latest payload fills `city` and `distanceKm`; "active" looks like a ~7-day window, so the list can be empty |
| Just joined | 🟢 | Live, cached, paged, unlocked. Test accounts with completeness 35 are not returned (eligibility rule unknown) |
| Likes in your filters | 🟢 | Live, cached, paged. Flat `profiles` plus wrapped `likes` with `likedAt` (shown on the card). Locked response not seen since the shape change |
| Second look | 🟢 | Wired, but only empty responses so far: the test accounts that passed and liked back are hidden by a backend filter |
| Visited you | 🟢 | Live, cached, paged, unlocked; card shows `viewedAt` |
| Passed | 🟢 | Live, cached, paged; `totalCount` can exceed the profiles returned (3 vs 2) |
| Currently available | 🟡 | Dummy — no API |
| My history: Liked / Favourited / Complimented | 🟡 | Dummy — no API |
| Tap a card → open profile | 🟠 | Coming soon — needs shared profile view (#15) |
| Explore filters | 🟠 | Coming soon |
| Upgrade / lock overlay | 🟢 | Lock shows on cards the API marks `locked` and they don't open; everything is unlocked while the app is free. Upgrade screen not built (see Subscriptions) |
| Offline-first cache + shimmer | ✅ | Drift cache of page 1 per section; cached copy shows at once, fresh data replaces it quietly; shimmer only on a first launch with no cache; cleared on sign-out |
| Paging | ✅ | Next page near the end of a strip (top 1, bottom 2, next column 3 and 4); page size 12 |
| Card photo disk cache | ✅ | `cached_network_image` on the Explore cards |

## 9. Feed tab — `features/feed` 🟡 (all dummy)

| Page / function | Route | Status | What's left |
|---|---|---|---|
| Feed list + topic filter chips | `/feed` | 🟡 | Needs posts + topics API |
| Post detail + comments + sort | `/feed/post` | 🟡 | Needs comments API |
| Create post (topic, anonymous) | `/feed/compose` | 🟡 | Needs create API; extra compose options coming soon |
| Author profile + their posts | `/feed/profile` | 🟡 | Needs user profile + posts API |
| Profile search | `/feed/profile/search` | 🟡 | Needs search API |
| Like post / comment | — | 🟠 | Coming soon |
| Comment / reply | — | 🟠 | Coming soon |
| Share | — | 🟠 | Coming soon |
| Follow | — | 🟠 | Coming soon |
| Post actions (report / hide / etc.) | — | 🟠 | Coming soon |
| Message an author | — | 🟠 | Coming soon |
| Notifications bell | — | 🟠 | Coming soon |

## 10. Chat tab — `features/chat` 🟡 (all dummy)

| Page / function | Route | Status | What's left |
|---|---|---|---|
| Conversation list with 5 slots | `/chat` | 🟡 | Needs conversations API; 5-slot limit must be enforced server-side |
| Matches sheet (start chat from a match) | (sheet) | 🟡 | Live list from `GET /v1/matches/my-matches` (2026-11-02); the chat it opens is still dummy |
| Gold upsell sheet | (sheet) | 🟠 | Coming soon |
| Unmatched profiles | `/chat/unmatched` | 🟡 | Empty state only; needs API |
| Archived chats | `/chat/archived` | 🟡 | Empty state only; needs API |
| Friends tab chats, conversation search, list "•••" menu | — | 🔴 | Not built |

## 11. Chat room — `features/messaging` 🟡 (all dummy)

| Function | Status | What's left |
|---|---|---|
| Message list, send text, statuses (sending → seen) | 🟡 | Faked by `DummyMessagingDataSource` |
| Typing indicator | 🟡 | Faked; needs socket |
| Older messages on scroll-up (paging) | 🔴 | Needs cursor API |
| Mark read | 🟡 | Faked |
| `myId` from auth session | 🟡 | Uses fixture `meId` |
| Offline message cache | 🔴 | Currently in-memory |
| Attachments (+) / voice messages (mic) | 🟠 | Coming soon |
| ⋮ menu: View profile, Mute, Clear chat, Unmatch, Block, Report | 🟠 | Coming soon |
| Long-press: copy / delete / report / block | 🔴 | Not built |

## 12. Voice calls — `features/calling` 🟡 (all dummy)

| Function | Route | Status | What's left |
|---|---|---|---|
| Outgoing call screen (dialing → ringing → connected) | `/call` | 🟡 | Fake peer; no audio |
| Incoming call screen | `/call/incoming` | 🟡 | Dev menu only |
| Mute / speaker / hang up | — | 🟡 | Fake |
| Real audio (LiveKit / Agora / …) + mic permission | — | 🔴 | SDK not chosen |
| Real incoming calls (CallKit / ConnectionService + push) | — | 🔴 | — |
| Call log lines from server | — | 🔴 | Client-side `logCall` today |
| Minimised in-call bar, proximity sensor | — | 🔴 | — |
| In-call profile button | — | 🟠 | Coming soon |

## 13. Menu / Settings / Edit profile / Help — `features/menu` 🟡

| Page / function | Route | Status | What's left |
|---|---|---|---|
| Menu (profile header, completeness, verified) | `/menu` | 🟢 | Reads `/v1/onboarding/status`; swap to a real profile API when it exists |
| Membership / Gold badge | (menu) | 🟡 | Dummy |
| Upgrade | (menu) | 🟠 | Coming soon |
| Notifications | (menu) | 🟠 | Coming soon |
| Safety & Advice | (menu) | 🟠 | No design |
| Invite friends | (menu) | 🟢 | UI per Figma |
| Bottom-nav Menu avatar | (nav) | 🟡 | Still placeholder image, not member photo |
| **Edit profile** | `/profile/edit` | 🟠 | Every row "coming soon". Plan: reuse onboarding pages without stepper, Save PATCHes section |
| Edit photos / photo guidelines / ID verification / preview | (edit) | 🟠 | Coming soon |
| Fields onboarding never collects (family involvement, living arrangements, tagline, employer, sect, family plans, polygamy) | (edit) | 🔴 | Need design + API fields |
| **Settings** | `/settings` | 🟡 | Dummy, in-memory |
| — Personal info: change gender / email / phone | | 🟠 | Coming soon |
| — Notifications toggles, chat preview | | 🟡 | Saved in memory only |
| — Language, Restore purchases, Passcode, Chaperone | | 🟠 | Coming soon |
| — Privacy: profile visibility, sharing link, blocked profiles, block contacts | | 🟠 | Coming soon |
| — Manage account: Start again, Take a break, Delete profile | | 🟠 | Coming soon (Sign out works) |
| **Help** | `/menu/help` | 🟠 | Support tickets, Reporting, Contact support, Help search — all coming soon |
| Fonts Outfit + Plus Jakarta Sans | — | 🟡 | Only Satoshi bundled |

## 14. Remote config / force update — `features/remote_config` 🟡

| Function | Route | Status | What's left |
|---|---|---|---|
| Fetch config + feature flags | — | 🟡 | Dev uses `FakeRemoteConfigRemoteDataSource`; real `GET /config` unconfirmed |
| Update-required screen | `/update-required` | ✅ | — |

## 15–20. Not started

| Feature | What it needs |
|---|---|
| **Shared member profile view** (`features/profile_view`) | Embeddable `ProfileView` + `/profile/:id` page; used by Marriage, Explore, Chat, Feed. Design agreed, one decision open (pass id vs full profile) — see `PENDING.md` |
| **Notifications** | FCM / APNs setup (Firebase not in `pubspec.yaml`), device-token API, in-app notifications list, bell buttons on Marriage / Feed / Menu |
| **Subscriptions / Gold** | Pricing screens (no design), in-app purchase (store SDK), membership API, restore purchases, premium gates (Visited you, filters teaser, chat slots) |
| **Safety** | Block, unblock, blocked list, report (profile / message / post), server-side photo moderation |
| **Localisation** | l10n setup, Bengali strings, `failure_text.dart` still English-only |
| **Realtime (Socket.IO)** | Socket client, events feed repository streams (never bloc state), close in `SessionScopeManager.closeConnections` |

## Cross-cutting tech debt

- [ ] Tests: 2 failing: `layer_boundaries_test` (looks for a `packages/` folder that doesn't exist) and `app_redirect_test` "new user" (gets null, expects `/get-started`).
- [ ] Remove dev "Skip" shortcut on intro before release.
- [ ] Local cache: Drift is live for Explore only (cache-then-network, cleared on sign-out). Profile, chat and the other features are still uncached. `CLAUDE.md` still says Hive.
- [ ] Crash reporting (Crashlytics) — not added.
- [ ] Old placeholder endpoints still in code (`/discovery/profiles`, `/me/verification/face`) — remove once unused.

---

# Part 2 — APIs

Status: ✅ **Done** (wired + verified live) · 🟢 **Wired, contract unconfirmed / backend issue** · 🔴 **Required, doesn't exist yet**

## 2.1 Done / wired

| # | Status | Method | Endpoint | What it does | Belongs to (file) |
|---|---|---|---|---|---|
| 1 | ✅ | POST | `/v1/auth/login` | Email + password sign-in → access + refresh tokens | Auth — `auth_remote_data_source.dart` |
| 2 | ✅ | POST | `/v1/auth/refresh` | Swap refresh token for new tokens | Auth (interceptor) |
| 3 | ✅ | POST | `/v1/auth/logout` | Revoke refresh token on sign out | Auth / Menu |
| 4 | 🟢 | POST | `/v1/auth/social` | Exchange Google/Apple id token for a session — client SDK not added | Auth |
| 5 | ✅ | POST | `/v1/onboarding/email/send-code` | Send sign-up email code (dev echoes `devCode`) | Auth sign-up |
| 6 | ✅ | POST | `/v1/onboarding/email/verify-code` | Verify sign-up email code | Auth sign-up |
| 7 | ✅ | POST | `/v1/onboarding/account` | Create account (email + password) → session | Auth create password |
| 8 | ✅ | GET | `/v1/onboarding/status` | Onboarding step, completion flags, user + full profile (also used as "my profile" for Menu and wizard prefill) | Auth resume, Onboarding, Menu |
| 9 | ✅ | PATCH | `/v1/onboarding/step` (step 4) | Save Basics section | Onboarding |
| 10 | ✅ | PATCH | `/v1/onboarding/step` (step 5) | Save Background & Faith | Onboarding |
| 11 | ✅ | PATCH | `/v1/onboarding/step` (step 6) | Save Lifestyle & Personality | Onboarding |
| 12 | ✅ | PATCH | `/v1/onboarding/step` (step 7) | Save Bio (`aboutMe`) | Onboarding |
| 13 | 🟢 | PATCH | `/v1/onboarding/step` (step 8, multipart) | Upload profile photos — replace vs append unconfirmed | Onboarding photos |
| 14 | ✅ | DELETE | `/v1/onboarding/images?filename=` | Delete one uploaded photo | Onboarding photos |
| 15 | ✅ | PATCH | `/v1/onboarding/step` (step 11) | Save location: `{country}` or `{coordinates, distance}` | Discovery — `discovery_remote_data_source.dart` |
| 16 | ✅ | GET | `/v1/onboarding/ai-bio` | Generate a bio suggestion | Onboarding bio — `ai_bio_remote_data_source.dart` |
| 17 | ✅ | POST | `/v1/onboarding/phone/send-code` | Send WhatsApp phone code (dev echoes `devCode`) | Auth phone verification |
| 18 | ✅ | POST | `/v1/onboarding/phone/verify-code` | Verify phone code | Auth phone verification |
| 19 | ✅ | POST | `/v1/onboarding/complete` | Mark onboarding finished ("Discover profiles") — client still uses step-12 workaround | Auth / Discovery filters |
| 20 | 🟢 | POST | `/v1/profile/face-verification/start` | Start liveness session → `sessionId`, challenges | Face verification |
| 21 | 🟢 | POST | `/v1/profile/face-verification` | Upload stills for server face match — response shape unconfirmed, result ignored | Face verification |
| 22 | ✅ | GET | `/v1/profiles/cards?limit&minAge&maxAge&country` | Swipe deck (opposite gender, same religion) | Marriage — `marriage_cards_remote_data_source.dart` |
| 23 | ✅ | GET | `/v1/profiles/{userId}` | Full profile by userId (profileId → 404) | Marriage card details |
| 24 | ✅ | POST | `/v1/profiles/swipe` | `{action: pass\|like\|undo, targetUserId}` — undo rewinds last pass only | Marriage |
| 25 | ✅ | GET | `/v1/profiles/feed/near-you?page&limit` | "Active near you" — paged; `city` and `distanceKm` now filled | Explore |
| 26 | ✅ | GET | `/v1/profiles/feed/just-joined?page&limit` | "Just joined" — paged | Explore |
| 27 | 🟢 | GET | `/v1/profiles/feed/second-look?page&limit` | "Second look" — only empty responses seen so far | Explore |
| 28 | ✅ | GET | `/v1/profiles/feed/visited-you?page&limit` | "Visited you" — paged, unlocked; items carry `viewedAt`, `viewCount` | Explore |
| 29 | ✅ | GET | `/v1/profiles/feed/passed?page&limit` | Profiles you passed — `passedAt` per item; `totalCount` can exceed the profiles returned | Explore |
| 30 | ✅ | GET | `/v1/likes/like-list` | Who liked you — paged; flat `profiles` plus wrapped `likes` with `likedAt` | Explore |
| 31 | 🟢 | GET | `/config` | App config + feature flags + min version — unconfirmed, dev uses fake | Remote config |

**Dead / placeholder paths still in code** (never existed, remove when cleaning up):
`GET /discovery/profiles` (old Marriage), `POST /me/verification/face` (old selfie flow),
`POST /me/phone/code`, `POST /me/phone/verify`, `POST /me/onboarding/complete` (commented out).

## 2.2 Required — not built yet

Endpoint paths below are **suggested** names — agree final paths with backend.

### Auth & account
| Method | Suggested endpoint | What it does | Belongs to |
|---|---|---|---|
| POST | `/v1/auth/password/forgot` | Send password-reset code | Auth login |
| POST | `/v1/auth/password/reset` | Set new password with code | Auth login |
| PATCH | `/v1/me/email` (+ verify) | Change email | Menu → Settings |
| PATCH | `/v1/me/phone` (+ verify) | Change phone | Menu → Settings |
| POST | `/v1/me/pause` | Take a break (hide profile) | Settings → Manage account |
| POST | `/v1/me/reset` | Start again (wipe profile, keep account) | Settings → Manage account |
| DELETE | `/v1/me` | Delete account | Settings → Manage account |

### Profile (own)
| Method | Suggested endpoint | What it does | Belongs to |
|---|---|---|---|
| GET | `/v1/me/profile` | Dedicated "my profile" (replace reading onboarding status) | Menu, Edit profile |
| PATCH | `/v1/me/profile` (or step PATCH after completion) | Edit any profile section | Edit profile |
| PATCH | `/v1/me/photos/order` | Reorder photos / set main photo | Photos, Edit profile |
| GET | `/v1/profile/face-verification/status` | Face-check verdict after "under review" | Face verification |
| — | add fields to step 4 | Backend must persist nationality, grewUpIn, ethnicity | Onboarding |

### Discovery & Marriage
| Method | Suggested endpoint | What it does | Belongs to |
|---|---|---|---|
| GET / PUT | `/v1/me/filters` | Save + load discovery filters (age, ethnicities, location, "clear") | Discovery filters |
| POST | `/v1/profiles/{userId}/compliment` | Send a compliment | Marriage |
| POST / DELETE | `/v1/favourites/{userId}` | Favourite / unfavourite (shortlist) | Marriage, Explore |
| GET | `/v1/profiles/{userId}/share-link` | Shareable profile link | Marriage, Settings |
| GET | `/v1/profiles/{userId}/filter-match` | "Do I match their filters?" (premium) | Marriage |
| — | sort param on `/v1/profiles/cards` | Sort the deck | Marriage |
| — | extra fields on cards | `religiousPractices`, `marriageIntentions`, `haveChildren`, `personalityTraits`, `languages`, `grewUpIn`, verification flags, city; drop raw coordinates | Marriage |

### Explore
| Method | Suggested endpoint | What it does | Belongs to |
|---|---|---|---|
| GET | `/v1/profiles/feed/currently-available` | "Currently available" section | Explore |
| GET | `/v1/history/liked` | Profiles I liked | Explore → My history |
| GET | `/v1/history/favourited` | Profiles I favourited | Explore → My history |
| GET | `/v1/history/complimented` | Profiles I complimented | Explore → My history |
| — | fix feed data | ~7-day "active" window, `faith` vs `sect`, which profiles passed / second-look / just-joined return (completeness, verified). `distanceKm` and `city` are now filled | Explore |

### Chat & messaging
| Method | Suggested endpoint | What it does | Belongs to |
|---|---|---|---|
| GET | `/v1/matches` | Mutual matches (for Matches sheet) | Chat |
| GET | `/v1/conversations` | Conversation list (enforce 5 slots) | Chat |
| POST | `/v1/conversations` | Open conversation with a match | Chat |
| GET | `/v1/conversations/{id}/messages?cursor` | Message history, paged | Messaging |
| POST | `/v1/conversations/{id}/messages` | Send message (text, later media/voice) | Messaging |
| POST | `/v1/conversations/{id}/read` | Mark as read | Messaging |
| POST | `/v1/conversations/{id}/mute` | Mute | Messaging |
| DELETE | `/v1/conversations/{id}/messages` | Clear chat | Messaging |
| DELETE | `/v1/messages/{id}` | Delete message | Messaging |
| POST | `/v1/matches/{userId}/unmatch` | Unmatch | Messaging, Chat |
| GET | `/v1/matches/unmatched` | Unmatched list | Chat → Unmatched |
| GET / POST | `/v1/conversations/archived`, `/{id}/archive` | Archive + list archived | Chat → Archived |
| POST | `/v1/uploads` | Upload attachment / voice note | Messaging |
| Socket | `message:new`, `message:status`, `typing`, `presence` | Realtime push into repository streams | Messaging |

### Calls
| Method | Suggested endpoint | What it does | Belongs to |
|---|---|---|---|
| POST | `/v1/calls` | Start a call → SDK room + token | Calling |
| POST | `/v1/calls/{id}/accept` / `decline` / `end` | Call signalling | Calling |
| GET | `/v1/conversations/{id}/calls` | Call history lines | Messaging |
| Push | VoIP push (CallKit / ConnectionService) | Ring incoming calls | Calling |

### Feed
| Method | Suggested endpoint | What it does | Belongs to |
|---|---|---|---|
| GET | `/v1/feed/topics` | Topic list for chips + compose | Feed |
| GET | `/v1/feed/posts?topic&cursor` | Post list | Feed |
| POST | `/v1/feed/posts` | Create post (topic, body, anonymous) | Feed compose |
| GET | `/v1/feed/posts/{id}/comments?sort` | Comments | Post detail |
| POST | `/v1/feed/posts/{id}/comments` | Comment / reply | Post detail |
| POST / DELETE | `/v1/feed/posts/{id}/like` | Like post | Feed |
| POST / DELETE | `/v1/feed/comments/{id}/like` | Like comment | Post detail |
| GET | `/v1/feed/users/{handle}` | Author profile | Feed profile |
| GET | `/v1/feed/users/{handle}/posts` | Author's posts | Feed profile |
| POST / DELETE | `/v1/feed/users/{handle}/follow` | Follow | Feed profile |
| GET | `/v1/feed/search?q` | Search profiles / posts | Feed search |
| GET | `/v1/me/feed-author` | My feed identity (`fetchMe`) | Feed |

### Safety
| Method | Suggested endpoint | What it does | Belongs to |
|---|---|---|---|
| POST / DELETE | `/v1/blocks/{userId}` | Block / unblock | Marriage, Messaging, Settings |
| GET | `/v1/blocks` | Blocked profiles list | Settings → Privacy |
| POST | `/v1/reports` | Report profile / message / post | Marriage, Messaging, Feed, Help |
| — | server photo moderation | Explicit-content check on upload | Photos |

### Settings, notifications, membership, help
| Method | Suggested endpoint | What it does | Belongs to |
|---|---|---|---|
| GET / PATCH | `/v1/me/settings` | Notification toggles, chat preview, privacy (visibility, social-chat block, contacts block), language | Settings |
| POST | `/v1/me/devices` | Register FCM / APNs token | Notifications |
| GET | `/v1/notifications` | In-app notifications list | Notifications bell |
| GET | `/v1/membership` | Current plan, Gold status | Menu, Chat, Explore |
| GET | `/v1/plans` | Pricing plans | Upgrade |
| POST | `/v1/purchases/verify` | Verify store receipt / restore purchases | Upgrade, Settings |
| GET / POST | `/v1/support/tickets` | Support tickets | Help |
| POST | `/v1/support/contact` | Contact support | Help |
| GET | `/v1/help/articles?q` | Help search | Help |

---

## Open questions for backend (blocking items above)

1. Step 8 photos: replace or append? How to send order / main photo?
2. What do steps 9 and 10 mean? Does backend track photos / face check for resume?
3. Face verification: final response shape and how the app learns the verdict.
4. Filters: a save endpoint, and a "no location filter" body for step 11.
5. Missing card / feed fields (see Marriage + Explore sections) and drop raw coordinates.
6. Real `GET /config` path and shape.
7. OAuth client ids for Google / Apple sign-in.
8. Calling SDK choice (LiveKit / Agora / …) and socket server for chat.
9. Which profiles do the passed, second-look and just-joined feeds return (verified? completeness?). Test accounts at completeness 35 are hidden, and `passed` reports `totalCount` 3 but returns 2, so pass-then-like-back can't be tested.
