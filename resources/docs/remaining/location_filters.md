# Location step and discovery filters

Code: `lib/features/auth/location/`, `lib/core/filters/`.

| ID | Sev | Owner | Finding | Notes |
|---|---|---|---|---|
| LOC-02 | ⚪ | App | Not tested: deny permission, "Only this time", approximate location, the Country tab, Clear | Needs a pass |
| FIL-01 | ⚪ | Product | The Filters page shows the 4 progress bars (code comment says Figma draws them) | Confirm with design; remove if not wanted |
| FIL-02 | ⚪ | App | Age slider, "Limit location by", "Ethnicity" shown; Apply not exercised | Check that the deck and Explore refresh after Apply |
