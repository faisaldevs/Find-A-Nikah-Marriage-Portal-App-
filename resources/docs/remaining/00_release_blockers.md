# Release blockers (🔴)

| ID | Area | Problem | Owner |
|---|---|---|---|
| AUTH-01 | Login | Dev email **and password** are hard-coded into the login form in every build type | App |
| AUTH-02 | Login | "Forgot password?" does nothing | App + Backend |
| AUTH-03 | Login/Welcome | Google and Apple sign-in show "That isn't available on this device" | App + Backend |
| SET-01 | Settings | "Delete marriage profile" does nothing — no way to delete an account (App Store and Play both require it) | App + Backend |
| SET-02 | Membership | "Upgrade now" / "Get more" do nothing — no payments | App + Product |
| XC-01 | Build | Android release build is signed with the **debug** key | App |
| XC-02 | Links | Share links need the domain, signing fingerprints and iOS entitlement (see `feed.md` FEED-L1) | App + Backend |
| XC-03 | Push | No push notifications (bell does nothing; no FCM) | App + Backend |
| MAR-01 | Marriage | Likes/passes may not be saved (quota stayed 20, History empty) — **verify first** | App or Backend |
| BE-01 | Backend | Demo-mode codes (`devCode`) must be off in production | Backend |
| VER-01 | Face check | Must be tested by hand with a real face; screen said "no face detected" while the server already marked the account verified | App + Backend |
