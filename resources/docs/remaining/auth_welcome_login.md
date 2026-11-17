# Welcome, login, social sign-in

Code: `lib/features/auth/presentation/view/` (`intro_page.dart`, `login_page.dart`).

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| AUTH-03 | 🟠 | App + Backend | **Google sign-in built 2026-11-15** (`google_sign_in` + the Firebase project's OAuth client; account sheet and cancel verified on the phone; Apple hidden). **A full sign-in was not run** — it would create a real account from one of your Google accounts. Open: (a) backend must verify the Google ID token (see `backend_asks.md` B-16), (b) release/Play-signing SHA-1 must be added in Firebase, (c) iOS client id, (d) Sign in with Apple (hidden, in `../PENDING.md`) | Run one real sign-in on the dev backend, then delete this row |
| AUTH-05 | 🟡 | App | Welcome / login background photo is darkened by a grey overlay over the whole screen, including the status bar area | Check against the design |
| AUTH-06 | 🟡 | App | Error toast slides in from the right and is clipped at the screen edge while animating (seen on "Invalid credentials") | Check `CustomToast` animation width |

Not tested: login with an unverified email, rate limiting, token refresh after expiry, biometric/remember me (not built).
