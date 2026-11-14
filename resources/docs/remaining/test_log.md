# Test log — 2026-11-14

**Build:** debug, dev flavor (`lib/flavors/main_dev.dart` + `env/dev.json`), fresh install after uninstall. **Device:** Pixel 5-class, Android, 1080×2340. Driven over adb (taps, UI-tree dumps, screenshots); API facts checked with curl against the same dev server.

## Path walked
Install → intro → welcome (Google, Apple, Help, Language, Terms) → login (wrong password) → Forgot password → Sign up → email → code → password → account type → full profile wizard → bio (AI) → phone → code → photos → face check → (relaunch) location → Marriage deck (scroll, pass, undo, like, compliment box, favourite, share) → Filters → Sort, bell → Explore (For you, My history ×4) → Chat (Marriage, Friends) → Menu → Edit profile (Languages) → Settings → Manage account (Delete, Sign out) → sign-out → sign-in again.
Feed was covered separately: `../feed/09_DEVICE_TEST_REPORT.md`.

## Not covered
Real face check, second device (messages, matches, calls, push), iOS, denied permissions, offline in most screens, tablets and landscape, large text, dark mode (the app has none), every edit field, payments, notifications.

## Test data created on the dev backend
- Account `qa.flow1114@example.com` (male, "QA Tester", phone +8801700001114). **It cannot be deleted from the app** (SET-01). Delete it on the backend.
- One like and one pass on seeded profiles; one "Amina" compliment box opened but not sent.
- Earlier Feed testing: two compliments to a seeded member were removed by the backend; test posts and comments were deleted.

## Things that went wrong during testing (for honesty)
- Android system **Back** at an app root left the app and later taps landed in other apps (Gmail notification, Calendar, Phone dialer, Quick Settings). No call can be placed (no SIM) and nothing was sent or changed there; I did not read the content I was shown.
- In the system photo picker the layout changed after the first tap and **five photos were selected, some of them personal photos from the phone**. They were uploaded to the QA account's profile. I then deleted all five through `DELETE /onboarding/images` (the account now has 0 photos). If you want certainty, also delete the account on the backend.
- Pushed test images to `/sdcard/Pictures` were removed; Do Not Disturb and "stay awake" were restored.
