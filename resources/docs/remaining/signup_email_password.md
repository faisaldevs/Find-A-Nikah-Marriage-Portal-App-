# Sign-up: email, code, password

Code: `lib/features/onboarding/signup/`.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| SUP-02 | 🔧 | App | Invalid-email hint added under the field (built, unit-checked; device check pending). Email field is still not auto-focused when the screen opens | Delete after the device check |
| BE-01 | 🔴 | Backend | `POST /onboarding/email/send-code` returns the code in the response (`devCode`) in dev | Must be disabled outside dev. The app only auto-fills the **phone** code, and only when `kDebugMode` |

Not tested: already-registered email, expired/incorrect code message, resend limit, very long email, offline.
