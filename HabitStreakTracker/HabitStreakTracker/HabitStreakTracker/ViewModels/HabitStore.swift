
import Foundation
import SwiftUI

@MainActor
final class HabitStore: ObservableObject {
    @Published private(set) var habits: [Habit]
    private let storage: HabitStoring
    private var reminderTask: Task<Void, Never>?

    /// The app starts empty – only habits the user adds are shown.
    init(storage: HabitStoring = FileHabitStorage()) {
        self.storage = storage
        var saved = storage.load() ?? []
        if LegacyDataCleanup.removeSampleHabits(from: &saved) {
            storage.save(saved)
        }
        self.habits = saved
        scheduleReminders()
    }

    

    func habit(with id: UUID) -> Habit? {
        habits.first { $0.id == id }
    }

    
    func add(_ habit: Habit) {
        habits.insert(habit, at: 0)
        persist()
    }

    func update(_ habit: Habit) {
        guard let index = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        habits[index] = habit
        persist()
    }

    
    func delete(id: UUID) {
        habits.removeAll { $0.id == id }
        persist()
    }

    
    func toggleCheckIn(for id: UUID, on date: Date = Date()) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        if let existing = habits[index].checkIns.firstIndex(where: { $0.isSameDay(as: date) }) {
            habits[index].checkIns.remove(at: existing)
        } else {
            habits[index].checkIns.append(date.startOfDay)
        }
        persist()
    }

    
    func refresh() {
        objectWillChange.send()
        scheduleReminders()
    }

  

    private func persist() {
        storage.save(habits)
        scheduleReminders()
    }

    
    private func scheduleReminders() {
        let snapshot = habits
        let previous = reminderTask
        reminderTask = Task {
            await previous?.value
            await ReminderService.refresh(habits: snapshot)
        }
    }
}
