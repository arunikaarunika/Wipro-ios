import Foundation

final class HabitStorageService {
    private let storageKey = "habit_streak_saved_habits"

    func loadHabits() -> [Habit] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }

        do {
            return try JSONDecoder().decode([Habit].self, from: data)
        } catch {
            print("Unable to load habits: \(error)")
            return []
        }
    }

    func saveHabits(_ habits: [Habit]) {
        do {
            let data = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Unable to save habits: \(error)")
        }
    }
}
