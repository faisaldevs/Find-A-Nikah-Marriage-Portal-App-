# Profile wizard (Account type → Bio)

Code: `lib/features/onboarding/profile/`.

Walked through end to end as a new male account: account type → basics → intent → source → nationality → grew up → ethnicity → height → education → profession → marital status → marriage intentions → faith chips → practice → lifestyle → about you → personality → interests → bio. Every step saved and the next step opened; the account reached the app.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| ONB-01 | 🟠 | App | Basics page: after the keyboard opens and closes, the title "Tell us about yourself" is **cut off at the top** (page stays scrolled) | Reset scroll or use `resizeToAvoidBottomInset` correctly |
| ONB-02 | 🟡 | App | Birth date dropdowns open as a menu pinned to the left/right edge, not under the field | Use anchored menus or pickers |
| ONB-03 | 🟡 | App | Height: long radio list from 122 cm with no default or search | Consider a picker with a sensible default |
| ONB-04 | 🟠 | App | Progress bar: Bio shows 4 of 4 complete, then phone/photos/face/location start new bars; the Filters page reuses the same bars (all full) | Re-think the progress model across the whole flow |
| ONB-05 | ⚪ | App | Generated bio used generic traits ("kind, grounded, sincere"), said "background in undergraduate" and used the **full name** | I tapped Skip on Personality, so verify with traits selected. Check grammar of the template and whether the full name should appear |
| ONB-06 | ⚪ | Product | "All" nationality/country lists show only a few countries (Afghanistan, Azerbaijan, Malaysia, Pakistan, Turkey, Sri Lanka…) | Confirm it is intentional |
| ONB-07 | 🟡 | App | Bottom buttons change label and position between steps ("Continue", "Select (5)", "Add bio", "Add photos") and optional steps have a separate "Skip" under the button | Consistency |
| ONB-08 | ⚪ | App | Back inside the wizard goes one step back and keeps the answers — works; closing the app mid-wizard resumes at the right step (account type, then photos/location) | verified |

Not tested: Family account type (selected once, not completed), every validation error, under-18 date, very long name, emoji in name, offline mid-wizard.
