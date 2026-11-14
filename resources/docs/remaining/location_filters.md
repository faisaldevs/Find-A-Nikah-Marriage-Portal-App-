# Location step and discovery filters

Code: `lib/features/auth/location/`, `lib/core/filters/`.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| LOC-01 | ✅ | — | Permission dialog → map centred near the member → Distance slider ("Everywhere"), "Limit to only Bangladesh", Confirm → opened the app | verified |
| LOC-02 | ⚪ | App | Not tested: deny permission, "Only this time", approximate location, the Country tab, Clear | Needs a pass |
| FIL-01 | 🟡 | App | The Filters page (from Marriage / Explore) reuses the onboarding header and shows **4 full progress bars** and a help icon | Use a plain settings header |
| FIL-02 | ⚪ | App | Age slider, "Limit location by", "Ethnicity" shown; Apply not exercised | Check that the deck and Explore refresh after Apply |
