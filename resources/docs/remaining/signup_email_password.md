# Sign-up: email, code, password

Code: `lib/features/onboarding/signup/`.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| SUP-01 | 🟠 | App | The email field **capitalises letters** ("QA.flow1114@example.com" after typing lower-case) | Set `keyboardType: emailAddress`, `textCapitalization: none`, `autocorrect: false`, `autofillHints` |
| SUP-02 | 🟡 | App | Email field is not focused when the screen opens; "Continue" for an invalid address ("abc") gave no visible message | Show an inline error; verify the validator |
| SUP-03 | 🟠 | App | Code screen: the **Continue button is hidden behind the keyboard**, and the code does not submit by itself at 6 digits | Pin the button above the keyboard or auto-submit |
| SUP-04 | ⚪ | App | Typing the 6 digits very fast (adb) dropped one digit and shifted the boxes; typing normally was fine | Re-check with paste and SMS/email autofill |
| SUP-05 | 🟡 | App | Password rules say "At least 1 number (1-9)" — `0` should count | Copy and regex |
| SUP-06 | ⚪ | App | Mismatched passwords: Continue was pressed and nothing visible happened | Verify there is a "passwords don't match" message |
| SUP-07 | ⚪ | App | The email code request has a 60 s resend timer and a "Resend code" link — worked | verified |
| BE-01 | 🔴 | Backend | `POST /onboarding/email/send-code` returns the code in the response (`devCode`) in dev | Must be disabled outside dev. The app only auto-fills the **phone** code, and only when `kDebugMode` |

Not tested: already-registered email, expired/incorrect code message, resend limit, very long email, offline.
