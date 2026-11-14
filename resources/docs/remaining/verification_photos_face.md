# Phone code, photos, face check

Code: `lib/features/auth/` (phone), `lib/features/onboarding/` (photos), `lib/features/face_verification/`.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| VER-01 | 🔴 | App + Backend | **Face check could not be completed by automation.** The screen repeated "Step 1 (front): no face detected" while the server had already set `profile.faceVerification.isFaceVerified: true` for the account | Test by hand with a real face. Decide who is right: is the server auto-verifying in dev, or does the app's local detector reject real faces? After relaunch the app skipped to Location because the server said verified |
| VER-02 | 🟠 | App | The liveness screen loops (Try again → step 1 → fail) with no way to leave except system Back | Add a visible Back/close and a "need help" path |
| VER-03 | 🟠 | App | The camera opened without an in-app explanation of why it is needed (permission was already granted on this phone) | Check the pre-permission message on a clean install |
| PHO-01 | 🟠 | App | System photo picker: pressing **Back** with items selected submitted them and moved on to the next screen. The picker also expanded after the first tap, so later taps selected other photos | Show a confirm/preview screen after picking; allow removing a photo before upload |
| PHO-02 | 🟠 | Backend | The API let me delete **all** photos (`DELETE /onboarding/images`) although the app requires at least 3 | Enforce the minimum server-side |
| PHO-03 | ⚪ | App | Photo "Photo guidelines" tile — not opened | Check content |
| PHN-01 | ✅ | — | Phone step: Bangladesh +880 needs 10 digits ("10 characters remaining"); debug build auto-filled the dev code and moved on | verified (debug only) |
| PHN-02 | ⚪ | App | After the OTP screen was reached again from photos, a new code was requested and auto-filled with a new 60 s timer | Check that going back does not resend a code each time |

Not tested: wrong phone code, resend, a number that is already used, non-Bangladesh numbers, uploading a non-face photo, HEIC/very large photos, photo reorder.
