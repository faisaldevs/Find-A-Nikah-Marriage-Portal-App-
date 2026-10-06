# Pending

Work that's been scoped but not started. Newest first. Move an item out
(or delete it) once it's done.

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
