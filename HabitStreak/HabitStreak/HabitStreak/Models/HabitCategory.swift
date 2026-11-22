
import Foundation

enum HabitCategory: String, CaseIterable, Identifiable, Codable {

    case health = "Health"
    case fitness = "Fitness"
    case learning = "Learning"
    case productivity = "Productivity"
    case personal = "Personal"

    var id: String {
        rawValue
    }
}
