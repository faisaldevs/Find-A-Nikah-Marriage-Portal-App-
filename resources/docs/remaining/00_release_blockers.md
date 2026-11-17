# Release blockers (🔴)

| ID | Area | Problem | Owner |
|---|---|---|---|
| AUTH-03 | Login/Welcome | Google and Apple sign-in show "That isn't available on this device" | App + Backend |
| SET-02 | Membership | "Upgrade now" / "Get more" do nothing — no payments | App + Product |
| XC-02 | Links | Share links need the domain, signing fingerprints and iOS entitlement (see `feed.md` FEED-L1) | App + Backend |
| XC-03 | Push | No push notifications: backend is ready, the app needs a Firebase project (your files) | App + Product |
| BE-01 | Backend | Demo-mode codes (`devCode`) must be off in production | Backend |
| VER-01 | Face check | Must be tested by hand with a real face; screen said "no face detected" while the server already marked the account verified | App + Backend |
