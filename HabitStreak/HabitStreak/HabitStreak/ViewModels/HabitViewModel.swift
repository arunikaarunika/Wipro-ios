
import Foundation
import Combine

@MainActor
final class HabitViewModel: ObservableObject {

    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
        }
    }

    private let storageKey = "SavedHabits"

    init() {
        loadHabits()
    }

    // MARK: - Load Habits

    func loadHabits() {
        guard let data = UserDefaults.standard.data(
            forKey: storageKey
        ) else {
            return
        }

        do {
            habits = try JSONDecoder().decode(
                [Habit].self,
                from: data
            )
        } catch {
            print("Error loading habits: \(error)")
        }
    }

    // MARK: - Save Habits

    func saveHabits() {
        do {
            let data = try JSONEncoder().encode(habits)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Error saving habits: \(error)")
        }
    }

    // MARK: - Add Habit

    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }

    // MARK: - Update Habit

    func updateHabit(_ habit: Habit) {
        guard let index = habits.firstIndex(
            where: { $0.id == habit.id }
        ) else {
            return
        }

        habits[index] = habit
    }

    // MARK: - Delete Habit

    func deleteHabit(_ habit: Habit) {
        habits.removeAll {
            $0.id == habit.id
        }
    }

    // MARK: - Toggle Completion

    func toggleCompletion(for habit: Habit) {

        guard let index = habits.firstIndex(
            where: { $0.id == habit.id }
        ) else {
            return
        }

        if habits[index].isCompletedToday {

            habits[index].checkInDates.removeAll {
                Calendar.current.isDateInToday($0)
            }

        } else {

            habits[index].checkInDates.append(Date())

        }
    }
}

