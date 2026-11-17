# Feed

Full detail lives in `../feed/` — start with `README.md` and `09_DEVICE_TEST_REPORT.md`. Status on 2026-11-14: about 90% done, core flows verified on a phone.

## Still open

| ID | Sev | Owner | Item | Source |
|---|---|---|---|---|
| FEED-L1 | 🔴 | App + Backend | **Share links**: `findanikah.app` does not resolve yet; the Android link file must list debug + release + Play-signing fingerprints; iOS needs the associated-domains entitlement and Team ID | `../feed/REPLY_TO_BACKEND_V3.md` |
| FEED-01 | 🟠 | App | Followers / following lists (tappable counts) | `../PENDING.md` |
| FEED-02 | 🟠 | App | People tab in Feed search | `../PENDING.md` |
| FEED-03 | 🟠 | App | Muted members list (`GET /feed/mutes`) | `../PENDING.md` |
| FEED-04 | 🟠 | App | Report: optional text box (max 1000) and load reasons from `GET /reports/reasons` | `../PENDING.md` |
| FEED-05 | 🟠 | App | Link opened while signed out should return to the link after login (built, only tested signed in) | `../feed/09_DEVICE_TEST_REPORT.md` A1 |
| FEED-06 | 🟡 | App | Polish still open: topic colour red vs green (A8, confirm with design), compose button over the card (A9, normal for a floating button), compliment page overlap (A11), default delete dialog style (A12), full name in chat vs initial in Feed (A13) | `../feed/09_DEVICE_TEST_REPORT.md` |
| FEED-07 | 🟡 | App | Offline: measure the new retry timing; failed like/refresh messages | same A6 |
| FEED-08 | 🟡 | App | Page-1 cache, offline banner, shimmer loading; Feed widget tests; shared `profile_view` replacing the Preview copy | `../PENDING.md` |
| FEED-09 | 🟡 | App | Remove the "force chosen topic" override in `CreatePostBloc` (backend fixed) | `../PENDING.md` |
| FEED-10 | 🟡 | App | Partial/locked profile: hidden fields still show "—"; section names ("About me" holds marital status, "My Faith" holds lifestyle) | `../feed/09_DEVICE_TEST_REPORT.md` A2 |
| FEED-11 | ⚪ | App | Not tested: Report/Block/Mute submit, comment edit/delete, replies, topic chips, "New" tab, 5000-char limit, 429 message | report "Not covered" |
