# Welcome, login, social sign-in

Code: `lib/features/auth/presentation/view/` (`intro_page.dart`, `login_page.dart`).

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| AUTH-01 | 🔴 | App | Login form is pre-filled with `user@example.com` / `12345678`. Comment in code: "Hard-coded dev credentials shipped in every build type (audit #6)" | `login_page.dart:50-51`. Gate behind `kDebugMode` / dev flavor, or remove. Also a privacy/security risk if shipped |
| AUTH-02 | 🔴 | App + Backend | "Forgot Password?" does nothing (no screen, no toast) | Needs a reset flow: request code → code → new password. Ask backend for endpoints |
| AUTH-03 | 🔴 | App + Backend | "Continue with Google" and "Continue with Apple" (welcome and login) show a red toast "That isn't available on this device" | Apple is iOS-only by policy if Google exists elsewhere (App Store rule 4.8). Needs SDKs, keys, backend token exchange |
| AUTH-04 | 🟠 | App | On the welcome screen the **language selector** ("English"), the **help "?"** and the **Terms / Privacy links** do nothing | Terms and Privacy links are legally required before store submission |
| AUTH-05 | 🟡 | App | Welcome / login background photo is darkened by a grey overlay over the whole screen, including the status bar area | Check against the design |
| AUTH-06 | 🟡 | App | Error toast slides in from the right and is clipped at the screen edge while animating (seen on "Invalid credentials") | Check `CustomToast` animation width |
| AUTH-07 | ⚪ | App | Back on the welcome screen leaves the app (it is the root) | Normal on Android; consider "press back again to exit" |
| AUTH-08 | ✅ | — | Wrong password → "Invalid credentials" toast; sign-out → login; sign-in again resumes the session | verified |

Not tested: login with an unverified email, rate limiting, token refresh after expiry, biometric/remember me (not built).
