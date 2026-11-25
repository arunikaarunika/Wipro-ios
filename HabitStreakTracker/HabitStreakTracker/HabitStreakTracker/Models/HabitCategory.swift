

import Foundation

enum HabitCategory: String, CaseIterable, Codable, Identifiable {
    case health = "Health"
    case study = "Study"
    case mindfulness = "Mindfulness"
    case finance = "Finance"
    case hobby = "Hobby"
    case fitness = "Fitness"
    case other = "Other"

    var id: String { rawValue }
}
