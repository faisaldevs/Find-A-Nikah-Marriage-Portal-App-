# Edit profile & Preview — research and implementation plan

**Date:** 2026-10-31 · **Status:** decisions made and built the same day
(see "Decisions" and "Phases" below). Onboarding was not touched.

Goal: make Menu → Edit profile actually edit the profile, and make Preview
match what other members see. Constraint: the app can only change fields
that `GET /v1/profiles/me` returns, and only through
`PATCH /v1/profiles/me`.

## Summary

- **Muzz edits one field (or one small group) per full-screen page.** Each
  page has a back arrow, the field name as the title, the current value
  pre-selected, and a pinned **Update** button. Most of these pages are
  the onboarding pages with "Update" instead of "Continue".
- **Muzz keeps name, birth date and gender out of Edit profile.** They live
  in Settings → Personal Information, with limits: name once every 6
  months, birth date only once.
- **Muzz Preview is exactly the card others see.** It hides empty fields,
  and its Faith section also shows diet, smoking and alcohol.
- **Our `PATCH /v1/profiles/me` works.** It saves height, nationality,
  grew-up-in, ethnicity, languages and name (step 4 drops some of these),
  validates option values, and can reorder photos. It returns the full
  updated profile.
- **Two traps:** a partial `marriageIntentions` or `interests` object
  wipes the rest of that group (ISS-010), and unknown keys are silently
  ignored (ISS-011). Always send whole nested objects, built from one
  typed patch class.

---

## 1. How Muzz handles Edit and Preview

Checked on the test phone's Muzz account (read-only: nothing was saved).

### Edit tab layout

Header: ✕ close, name + verified icon, Preview / Edit tabs.

| Muzz section | Rows | Ours today |
|---|---|---|
| Complete profile `69%` | Photo grid (Main label, 6 slots incl. guidelines), then prompts for empty fields: Family involvement, Living arrangements, ID Verified badge, Tagline, Job title, Employer, Video, Voice intro | Removed on 2026-10-31 (only ID badge + a duplicate Profession were left). Photos are their own section |
| Profile features | Gold member badge toggle | Removed (membership, not profile) |
| Location | Current location ("Pinned location" tag), Grew up in | Same |
| About me | Height, Marital status, Children, Bio | Same |
| Marriage intentions | Chatting, Marriage | Same |
| Future plans | Relocation, Family plans, Polygamy plan | Relocation only (no API for the others) |
| Icebreakers (0/3) | Pick questions + write answers | None (no API) |
| Religiosity | Sect, Born Muslim, Religious practice, Faith, Diet, Alcohol, Smoking | Same minus Sect (no API) |
| Interests and Personality | Interests, Personality | Same |
| Education and career | Education, Profession | Same |
| Languages and ethnicity | Ethnicity, Nationality, Languages | "Ethnicity and nationality"; Languages moved to our User info |
| — | (name, birth date, gender are in Settings) | Our **User info** section: Name, Birth date, Gender, Religion, Languages |

An empty value shows a pink "Complete your profile" prompt in its row,
same as ours.

### Editing a field

Every row opens a full-screen page. There's no inline editing and no
bottom sheets (except photos).

| Row | Muzz editor | Matches our onboarding page |
|---|---|---|
| Height | Same cm · ft list, Update pinned | `height_page.dart` |
| Marital status | Single-choice list, current value ticked | `marital_status_page.dart` |
| Diet (also Alcohol, Smoking) | Single-choice, **one page per field** | Part of `lifestyle_preferences_page.dart` (3 questions on one page) |
| Faith | Chips "Choose up to 8" (with emoji) | `faith_page.dart` |
| Languages | Searchable checkbox list (long list) | Commented-out chips on `basic_information_page.dart` (8 languages) |
| Bio | Text box, keyboard opens at once, Update above the keyboard | `bio_page.dart` (ours also has AI generate) |
| Chatting / Marriage | **Group page "Marriage intentions"**: know-for + involve family + married-within, one Update | `marriage_timeline_page.dart` (no family question) |
| Current location | Map: search country, "Pin your location to …" or "Use your live location" | Location page (`flutter_map`) |
| Photo (tap one) | Sheet: Use as main photo / Replace photo / Delete / Cancel | Photos page has remove only |

Back arrow = leave without saving; no "discard changes?" prompt seen.
Update looked enabled even with nothing changed.

### Name, birth date, gender (Muzz Settings → Personal Information)

| Field | Editor | Rule shown |
|---|---|---|
| First name | Text + Update | "You can only update your name once every 6 months, no exceptions are made" |
| Date of birth | Month / day / year wheels | "You can only change your date of birth once, no exceptions are made" |
| Gender | Male / Female + Update | none shown |
| Email, phone | Rows (not opened) | — |

### Preview

- The same card other members see. Header gets a **Share** icon.
- Hero badges: "Active today", "Photo verified". Name + age, location,
  then chips: profession, practice, ethnicity flags, sect.
- **Pinned "Boost my profile"** button at the bottom (we have no boost).
- Sections: About me (height, marital status, children) → marriage
  intentions card (only stops that have a value; no empty "Family") →
  **Faith (practice + diet + smoking + alcohol + faith tags)** → Future
  plans → Interests → Personality → Education and career → Languages and
  ethnicity (+ "Grew up in …") → Bio → Verified profile → Share profile.
- Empty fields and sections are simply left out.

---

## 2. What our API allows

Probed `PATCH /v1/profiles/me` on the test account
(`qa.profile.1031@example.com`) on 2026-10-31.

| Check | Result |
|---|---|
| Route | `PATCH /v1/profiles/me` exists. `/v1/profile`, `/v1/me`, `/v1/me/profile` → 404 |
| Response | 200 "Profile updated successfully" with the **same body as GET** (user + profile + counts), so no refetch is needed |
| `heightCm`, `nationality`, `grewUpIn`, `ethnicity` | **Saved.** Step 4 drops them, PATCH doesn't (ISS-001/002) |
| `languages` | Saved |
| `fullName` | Saved (changed and reverted). No rate limit seen |
| `gender`, `dateOfBirth`, `religion` | Same value accepted. Whether a *change* is allowed was **not tested** (it could lock the account) |
| `images` reordered | Saved, so "Use as main photo" = PATCH the reordered list |
| Invalid option (`maritalStatus: "not_a_real_status"`) | 400 "not_a_real_status is not valid", nothing saved |
| Unknown key (`notAField`) | 200, silently ignored (ISS-011) |
| Partial `lifestyle` | Merged |
| Partial `marriageIntentions` / `interests` | **Replaced:** other keys wiped (ISS-010) |
| `completeness` | Recalculated on PATCH (35 → 45 after height) |

Not checked: adding/replacing photo files, location (`country` /
coordinates), partial `aboutYou`.

---

## 3. Field-by-field plan

"Reuse" means the option list or picker body moves to `core/` and both the
onboarding page and the editor use it.

| Edit row | API key (`profile.`) | Editor | PATCH body | Reuse |
|---|---|---|---|---|
| **User info** | | | | |
| Name | `user.fullName` | Text | `{fullName}` | Basic info name field |
| Birth date | `dateOfBirth` | Read-only for now | — | — |
| Gender | `gender` | Read-only for now | — | — |
| Religion | `religion` | Read-only (only "Islam" exists) | — | — |
| Languages | `languages` | Searchable multi-select | `{languages: [...]}` | `languageOptions` (8 now; Muzz has a full list) |
| **Photos** | | | | |
| Tap photo → Use as main | `images` | Sheet action | `{images: reordered}` | — |
| Tap photo → Delete | `images` | Sheet action, block below 3 | `DELETE /v1/onboarding/images?filename=` (exists) | photos page logic |
| Tap photo → Replace / empty slot → Add | `images` | Gallery picker | **Upload endpoint after onboarding unconfirmed** | photo picker repo |
| **Location** | | | | |
| Current location | `country` | Map / country (like onboarding Location) | Unconfirmed: PATCH `{country}` or step 11 | Location page |
| Grew up in | `grewUpIn` | Country single-select | `{grewUpIn: [x]}` | `SearchableSelectList` + `countries.dart` |
| **About me** | | | | |
| Height | `heightCm` | Height list | `{heightCm}` | `buildHeightOptions()` |
| Marital status | `maritalStatus` | Single choice | `{maritalStatus}` | `maritalStatusOptions` |
| Children | `aboutYou.haveChildren` | Yes / No | `{aboutYou: {whole object}}` | About you page question |
| Bio | `aboutMe` | Text (+ AI generate, optional) | `{aboutMe}` | bio page, `/v1/onboarding/ai-bio` |
| **Marriage intentions** (group) | | | | |
| Chatting + Marriage | `marriageIntentions` | One page, both questions, married-within ≥ know-for rule | `{marriageIntentions: {getToknowDuration, marriageTimeline}}`, **always both** | `durationOptions`, `marriedWithinOptions` |
| **Future plans** | | | | |
| Relocation plans | `aboutYou.relocateAbroad` | Yes / No | `{aboutYou: {whole object}}` | About you page question |
| **Religiosity** | | | | |
| Born Muslim | `aboutYou.bornMuslim` | Yes / No | `{aboutYou: {whole object}}` | About you page question |
| Religious practice | `religiousPractices` | Single choice | `{religiousPractices: [x]}` | `religionPracticeOptions` |
| Faith | `faith` | Chips, max 8 | `{faith: [tokens]}` | `faithTagOptions` + `faithTagTokens` |
| Diet / Alcohol / Smoking | `lifestyle.*` | One page each (Muzz) | `{lifestyle: {whole object}}` | lifestyle page questions |
| **Interests and Personality** | | | | |
| Interests | `interests.{cultural, foodDrinks, sports, fashion, activities}` | Category chips, max 15 | `{interests: {all 5 lists}}`, **always all** | `interestCategories` + tag maps |
| Personality | `personalityTraits` | Chips, max 5 | `{personalityTraits: [...]}` | `personalityTraitOptions` |
| **Education and career** | | | | |
| Education | `educationLevel` | Single choice | `{educationLevel}` | `educationOptions` |
| Profession | `professionTitle` | Searchable single choice | `{professionTitle}` | `professionOptions` |
| **Ethnicity and nationality** | | | | |
| Ethnicity | `ethnicity` | Country multi-select | `{ethnicity: [...]}` | ethnicity page list |
| Nationality | `nationality` | Country multi-select, max 2 | `{nationality: [...]}` | nationality page list |

Not editable (no API field): family involvement, living arrangements,
tagline, employer, family plans, polygamy, sect, icebreakers, video,
voice intro, ID verification.

### Entity changes needed so edits don't lose data

`MyProfile` currently flattens or truncates some lists. An edit built from
it would wipe data:

- `interests`: flattened into one list. Keep the 5 categories, or the
  interests PATCH can't be rebuilt.
- `religiousPractices`, `grewUpIn`: only the first item kept. Keep the
  lists.
- `aboutYou`, `lifestyle`, `marriageIntentions`: needed whole to build
  "whole object" bodies. The values are there; build bodies from them.

---

## 4. Preview changes (match Muzz)

1. Faith section: add practice, diet, smoking, alcohol chips before the
   faith tags. Born Muslim stays Edit-only, as in Muzz.
2. Intentions card: show only the stops that have values. Drop the
   always-empty "Family" stop.
3. Hero badges: "Active today" from `user.lastActiveAt`, "Photo verified"
   from face verification. ISS-003 must be fixed first, or every account
   looks verified.
4. Photo "missing" boxes: only below the minimum (3), not for slots 4–5.
5. Later / no API yet: Share icon (needs share-link API), Boost button
   (no boost feature).
6. Longer term: render Preview with the same widget as other members'
   profiles (the `profile_view` plan in PENDING.md), so it can't drift
   from the real card.

---

## 5. Architecture

Follows `resources/Architecture/ARCHITECTURE.md`: BLoC, get_it/injectable,
fpdart `Either`; features never import another feature's `data/` or
`presentation/`.

**Data (menu)**
- `MenuRemoteDataSource.updateMyProfile(@Body() Map<String, dynamic>)` →
  `@PATCH('/v1/profiles/me')`, returns `MyProfileResponseDto` (same shape
  as GET).
- `MenuRepository.updateMyProfile(ProfilePatch)` →
  `Either<Failure, MyProfile>`. Map 400 messages to a readable failure.

**Domain**
- `ProfilePatch`: one sealed class, one case per editable group:
  `name`, `languages`, `height`, `maritalStatus`, `aboutYou(...)`,
  `lifestyle(...)`, `marriageIntentions(...)`, `interests(...)`, `faith`,
  `personality`, `education`, `profession`, `ethnicity`, `nationality`,
  `grewUpIn`, `religiousPractice`, `bio`, `photoOrder`. It owns the JSON
  keys (fixes the ISS-011 typo risk) and always writes whole nested
  objects (ISS-010).

**Presentation**
- One editor page per row (Muzz model), on routes under
  `/profile/edit/<field>`.
- `EditFieldScaffold`: back arrow, title, body, pinned **Update** button
  with a loading state. `WizardScaffold` already has `continueLabel`, so
  it may be enough.
- `EditFieldCubit<T>`: initial value, current value, `isDirty`,
  `isValid`, `submit()` → repository → success (pop with the updated
  profile) or failure (toast, stay on the page).
- `EditProfileBloc` takes the returned profile (`ProfileUpdated`). Menu
  refetches when it comes back into view, or the repository exposes a
  `watchMyProfile()` stream so both stay in sync.

**Sharing UI with onboarding**
- Move the option catalogs (`wizard_options.dart`) and label↔token maps
  (`onboarding_option_tokens.dart`) to `core/constants/` (CLAUDE.md:
  shared static data lives there).
- Extract the bodies of the onboarding pages (radio list, chip group,
  height list, yes/no question, country list) into `core/ui/components/`.
  Onboarding pages keep their `OnboardingBloc` wiring; editors use the
  same bodies with `EditFieldCubit`. This is an onboarding refactor, so it
  needs a no-behaviour-change check.
- Optional: move own-profile code (Edit, Preview, editors) from
  `features/menu` into a new `features/my_profile` once the editors land.
  Menu would then only link to it by route.

---

## 6. Phases

- [ ] **0. Backend answers** (section 7). Phases 1–5 didn't need them.
- [x] **1. Data layer:** `MenuRemoteDataSource.updateMyProfile` /
      `deletePhoto`, `ProfilePatch` (domain), `profilePatchBody` (data,
      owns the keys), `MenuRepository.updateMyProfile` / `deletePhoto`,
      `MyProfile.interestGroups` (interests kept per category).
- [x] **2. Shared UI:** *changed by decision 4:* onboarding isn't
      touched, so the option lists are copied into
      `features/menu/presentation/editing/profile_options.dart` (stored as
      server values) and the radio / chip looks into
      `widgets/editor_widgets.dart`. Keep both in sync with onboarding.
- [x] **3. Editor framework:** `FieldEditorBloc<T>` (Bloc, per the
      architecture's "Bloc for async"), `EditorScaffold` (back + title +
      pinned Update), one route `/profile/edit/field` with
      `ProfileFieldEditorArgs` as `extra` (the redirect allows exact paths
      only). Saving pops with the server's profile; Edit shows it and a
      "… updated" toast; Menu reloads when Edit closes.
- [x] **4. Simple editors:** Name, Birth date (wheels, 18+), Gender,
      Religion, Height, Marital status, Children, Bio, Relocation, Born
      Muslim, Religious practice, Diet, Alcohol, Smoking, Education,
      Profession.
- [x] **5. List / group editors:** Languages, Grew up in, Marriage
      intentions (one page, onboarding's rule), Faith (max 8), Interests
      (per category, max 15), Personality (max 5), Ethnicity, Nationality
      (max 2).
- [~] **6. Photos:** tap a photo → sheet. "Use as main photo" (PATCH
      order) and "Delete" (min 3) work; the first photo has a "Main"
      label. Replace / add photo are "coming soon" until the upload
      endpoint is confirmed.
- [~] **7. Preview:** items 1, 2 and 4 done. Item 3 (badges) waits on
      ISS-003.
- [ ] **8. Location:** "Current location" stays "coming soon" until the
      backend says how to set it after onboarding.
- [ ] Device pass on the test account after each phase. Record bugs in
      ISSUES.md.

---

## 6b. Caching and instant edits (2026-11-01)

- **Cache-first:** `MenuRepository` (now in the session scope) keeps the
  profile in memory and the last `/v1/profiles/me` response in
  `JsonCache` (key `menu.profile.me`, same Drift store as Explore).
  Menu, Edit profile and Settings show the cached copy at once and
  refresh quietly. The loading state only appears when there's no copy
  at all (first launch after sign-in). A failed refresh keeps the copy
  on screen.
- **One source of truth:** the repository announces every change on
  `myProfileChanges`. Menu, Edit profile and Settings follow it, so an
  edit shows everywhere without refetching.
- **Instant edits:** "Update" closes the field page straight away. The
  change shows at once, is saved in the background, then replaced by the
  server's answer. A failed save is rolled back and shows an error toast.
  Photo "Use as main" and "Delete" work the same way.
- **Photos:** `ProfilePhoto` (disk cache via `cached_network_image`)
  replaces `AppPhoto` in Menu / Edit / Preview. Menu warms the cache for
  every photo, so Edit and Preview open with photos ready.
- **Sign-out:** the session scope drops the repository (memory) and
  `JsonCache.clear()` wipes the device copy, so the next user never
  sees the previous profile.
- Settings still waits for its own (dummy) settings before showing.

## 7. Open questions for the backend

1. Nested objects: should a partial `marriageIntentions` / `interests`
   merge like `lifestyle` does? Does `aboutYou` merge? (ISS-010)
2. Reject unknown keys with a 400? (ISS-011)
3. Can `gender` and `dateOfBirth` change after onboarding, and with what
   limits? (Muzz: birth date once, name once per 6 months.) Should the
   server enforce a name-change limit?
4. Photos after onboarding: how to upload a new file (multipart on
   `PATCH /profiles/me`? step 8?). Is `DELETE /v1/onboarding/images`
   still the way to remove one? Is the 3-photo minimum enforced
   server-side?
5. Location: can `PATCH /profiles/me` set `country` and coordinates, or
   does step 11 stay the only way?
6. Completeness: which fields count? Height raised it 35 → 45; nationality
   didn't.
7. Fix step 4 so it saves `heightCm`, `nationality`, `grewUpIn` and
   `ethnicity` like PATCH does (ISS-001/002).

## 8. Decisions (owner, 2026-10-31)

1. **Editor model:** one page per field, like Muzz. Marriage intentions
   is the one group page.
2. **What's editable:** everything profile-related in Edit, including
   Name, Birth date, Gender, Religion and Languages. Verification and
   non-profile items (ID badge, Gold badge) are out.
3. **Update button:** enabled only when something changed (and is
   valid).
4. **Onboarding:** not touched. No step-4 stopgap; profile work only.
5. **Where the code lives:** not decided; built in `features/menu` for
   now.

---

## Appendix: test account changes during research

On `qa.profile.1031@example.com`: `heightCm` 160, `nationality`,
`grewUpIn` and `ethnicity` `["Bangladesh"]` (the values picked in
onboarding), `languages` `["English", "Bengali"]`. Completeness is now 45.
Name, marriage intentions, interests, marital status and photo order were
changed only to test and are back to their original values.
