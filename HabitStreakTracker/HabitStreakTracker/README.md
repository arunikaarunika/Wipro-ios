# Habit Streak Tracker (Project 24)

SwiftUI + MVVM iPhone app (portrait only, iOS 17+). Open
`HabitStreakTracker.xcodeproj` in **Xcode 16 or later** and press Run.

## Folder structure
| Folder | Purpose |
|---|---|
| `App/` | App entry point |
| `Models/` | `Habit`, `HabitCategory`, `HabitFrequency` (data + streak logic) |
| `Services/` | Biometrics (Face ID), Keychain PIN store, JSON storage, reminders (notifications) |
| `ViewModels/` | `AuthViewModel`, `HabitStore`, `DashboardViewModel`, `HabitListViewModel`, `HabitFormViewModel` |
| `Views/Auth` | Face ID + 4-digit PIN lock screen |
| `Views/Dashboard` | Home / overview |
| `Views/Habits` | List, Add/Edit form, Details |
| `Views/Components` | Reusable cards, chips, keypad |
| `Utilities/` | Date + category UI helpers |
| `Assets.xcassets` | App icon (1024px) + accent colour |

## Feature map
1. Front page: "Login with Face ID" button + 4-digit PIN field + Login button (PIN validation: empty / short / incorrect / mismatch)
2. Dashboard – total, done today, longest streak, pending
3. Habit List – cards with name, category, today state, streak
4. Add Habit – name, category, target frequency, start date, end date (optional toggle), daily reminder time, motivational note
10. Reminders – per-habit daily notification; skipped once you check in, stopped after the end date
5. Habit Details – category, start date, current/best streak, total check-ins, note
6. Edit Habit – visible Edit buttons on every card and on the Details screen
7. Delete Habit – visible Delete buttons with a confirmation alert (streak history is deleted too)
8. Search by name + category chips
9. Streak counter – check-in adds 1, a missed day resets current streak to 0, best streak is remembered

## Running notes
* Simulator Face ID: **Features ▸ Face ID ▸ Enrolled**, then **Matching Face**.
  Without enrolment the app falls back to the PIN screen automatically.
* First launch asks you to create a 4-digit PIN (stored hashed in Keychain).
* To run on a real iPhone: select the target ▸ *Signing & Capabilities* ▸ choose your Team,
  and change the bundle identifier if needed.
* The app starts empty – only habits you add are shown. Data is saved to `Documents/habits.json`.
* Reminders are local notifications. Allow notifications when asked; test by setting a habit's reminder 1–2 minutes ahead.
