# Pending

Work that's been scoped but not started. Newest first. Move an item out
(or delete it) once it's done.

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
- [ ] **Step 8 (photos) was never wired**: `OnboardingRemoteDataSource
      .submitImages` / `OnboardingImagesRequestDto` exist but nothing
      calls them — this is the root cause of the gap above.
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
