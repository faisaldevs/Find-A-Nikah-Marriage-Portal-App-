# Remaining work before release

One file per feature. Each item has an ID, a severity, what was seen, and where to look.
Found by a full device pass on **2026-11-14** (fresh install → sign-up → onboarding → every tab → settings → sign-out → sign-in) plus the Feed passes in `../feed/`. See `test_log.md` for what was and wasn't covered.

**Severity:** 🔴 release blocker · 🟠 must fix soon · 🟡 polish · ⚪ info / verify
**Owner:** App · Backend · Product (a decision is needed)

| File | Area |
|---|---|
| [00_release_blockers.md](00_release_blockers.md) | the short list that stops a release |
| [auth_welcome_login.md](auth_welcome_login.md) | welcome, login, social sign-in, forgot password |
| [signup_email_password.md](signup_email_password.md) | email, code, password |
| [onboarding_profile.md](onboarding_profile.md) | the profile wizard (basics → bio) |
| [verification_photos_face.md](verification_photos_face.md) | phone code, photos, face check |
| [location_filters.md](location_filters.md) | location step, discovery filters |
| [marriage.md](marriage.md) | the swipe deck |
| [explore.md](explore.md) | Explore tab, My history |
| [chat.md](chat.md) | chat tab and rooms |
| [feed.md](feed.md) | Feed (links to `../feed/`) |
| [menu_settings.md](menu_settings.md) | Menu, edit profile, settings, membership |
| [cross_cutting.md](cross_cutting.md) | navigation, toasts, build/config, tests, notifications |
| [backend_asks.md](backend_asks.md) | everything that needs the backend team |
| [test_log.md](test_log.md) | what was tested, how, and test data left behind |

Update the status in the item itself when fixed (✅ + date); keep the file as history.
