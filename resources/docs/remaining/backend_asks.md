# Backend asks (all open items)

Feed items are tracked in `../feed/` (`NEED_FROM_BACKEND_FEED_V3.md` answered; `REPLY_TO_BACKEND_V3.md` pending). New from the full pass:

| ID | Sev | Ask |
|---|---|---|
| BE-01 | 🔴 | Turn off `devCode` in `POST /onboarding/email/send-code` and `/onboarding/phone/send-code` outside dev |
| BE-02 | 🔴 | Account deletion endpoint (and what it removes: profile, photos, messages, feed posts) |
| BE-03 | 🔴 | Password reset endpoints (request code, verify, set password) |
| BE-04 | 🔴 | Google and Apple sign-in token exchange |
| BE-05 | 🔴 | Push notifications: device token registration, event list (match, message, like, comment…) |
| BE-06 | 🔴 | Payments/membership: plans, receipt validation, entitlements (likes, compliments, filters) |
| BE-07 | 🟠 | Confirm swipe persistence: after `POST /profiles/swipe` with `like`/`pass`, where does it show? `GET /likes/like-list` returned `tag: "Who Liked You"` and no rows; `/profiles/feed/passed` empty. Which endpoints back My history → Liked / Passed / Favourited / Complimented? |
| BE-08 | 🟠 | Enforce min 3 photos server-side (`DELETE /onboarding/images` allowed 0) |
| BE-09 | 🟠 | Face verification: how is `isFaceVerified` set in dev? The account was verified while the app reported "no face detected". Describe the real rules and thresholds |
| BE-10 | 🟡 | Clean seed data (duplicate faces/names, "Zayd Blocked", "Fatima NoPhoto") before demos |
| BE-11 | 🟡 | Rate limits and error codes for: email code, phone code, login, swipe (daily likes), compliments |
| BE-12 | 🟡 | Support tickets (`Help → Report someone / Contact support`): confirm endpoints and statuses |
