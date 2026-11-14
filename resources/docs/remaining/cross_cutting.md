# Cross-cutting: navigation, build, config, tests

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| XC-01 | 🔴 | App | **Android release is signed with the debug key** (`android/app/build.gradle.kts`: `signingConfig = signingConfigs.getByName("debug")`) | Create an upload keystore; keep it out of git. Play-signing and the link fingerprints depend on it |
| XC-02 | 🔴 | App + Backend | App/Universal Links: see `feed.md` FEED-L1 | |
| XC-03 | 🔴 | App + Backend | **No push notifications.** Bells do nothing; Firebase/FCM and Crashlytics are not added (deferred in `CLAUDE.md`) | Needed for new matches/messages. Also crash reporting before launch |
| XC-04 | 🟠 | App | **Strings are inline English**; the language selector is dead | Decide on l10n (flutter gen-l10n) before adding languages; RTL (Arabic/Urdu) is likely needed for this audience |
| XC-05 | 🟠 | App | **Accessibility** not audited (labels, tap size, contrast, text scaling, TalkBack). Many icons come up as unnamed buttons in the UI tree | Do a pass |
| XC-06 | 🟠 | App | **iOS** has not been run in this pass: associated domains, Sign in with Apple, photo/camera/location/contacts usage strings, push, ATS | Needs a Mac build and a device |
| XC-07 | 🟠 | App | Root-screen Back exits the app straight to the previous app | Consider "press back again to exit" |
| XC-08 | 🟡 | App | Three automated test failures on the last commit: `test/architecture/layer_boundaries_test.dart` (needs a `packages/` folder), `test/router/app_redirect_test.dart` "new user", and a flaky `messaging_realtime_test` | Fix or delete; keep CI green |
| XC-09 | 🟡 | App | Analyzer: unused `_comingSoon` in `chat_room_page.dart`; many info-level lints in Feed | Clean up |
| XC-10 | 🟡 | App | Offline: reads can take ~20–45 s before an error appears; the retry setting is global (Feed reads were lowered) | Review timeouts app-wide |
| XC-11 | 🟡 | App | No Terms / Privacy / Community guidelines screens; store listings need a privacy policy URL and data-safety answers | Product + legal |
| XC-12 | 🟡 | App | Runtime permission rationale and denied-state handling for camera, location, notifications, photos, contacts | Test denied/permanently denied |
| XC-13 | ⚪ | Product | Age/ID verification rows ("age verified", "ID documents verified") appear on profiles — confirm they are real checks | Misleading if not |
