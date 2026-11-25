
import Foundation

enum HabitFrequency: String, CaseIterable, Codable, Identifiable {
    case daily = "Every day"
    case fiveDays = "5 days a week"
    case threeDays = "3 days a week"
    case weekly = "Once a week"

    var id: String { rawValue }
}
