
import Foundation

enum LegacyDataCleanup {
    private static let doneKey = "didRemoveSampleHabits.v1"

    private static let sampleHabits: [String: String] = [
        "Drink 2L Water": "Hydration keeps my head clear.",
        "Read 20 Pages": "Small pages, big knowledge.",
        "Morning Meditation": "10 quiet minutes before the phone.",
        "Save ₹100": "Future me says thanks."
    ]

    
    static func removeSampleHabits(from habits: inout [Habit]) -> Bool {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: doneKey) else { return false }
        defaults.set(true, forKey: doneKey)

        let before = habits.count
        habits.removeAll { sampleHabits[$0.name] == $0.note }
        return habits.count != before
    }
}
