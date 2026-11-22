
import Foundation

struct Habit: Identifiable, Codable {

    var id: UUID
    var name: String
    var category: String
    var targetFrequency: Int
    var startDate: Date
    var motivationalNote: String
    var checkInDates: [Date]

    init(
        id: UUID = UUID(),
        name: String,
        category: String,
        targetFrequency: Int = 7,
        startDate: Date = Date(),
        motivationalNote: String = "",
        checkInDates: [Date] = []
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.targetFrequency = targetFrequency
        self.startDate = startDate
        self.motivationalNote = motivationalNote
        self.checkInDates = checkInDates
    }

    // Total completed check-ins
    var totalCheckIns: Int {
        checkInDates.count
    }

    // Check whether habit is completed today
    var isCompletedToday: Bool {
        checkInDates.contains {
            Calendar.current.isDateInToday($0)
        }
    }

    // Category icon
    var categorySymbol: String {
        switch category {
        case "Health":
            return "heart.fill"
        case "Fitness":
            return "figure.run"
        case "Learning":
            return "book.fill"
        case "Productivity":
            return "briefcase.fill"
        case "Personal":
            return "person.fill"
        default:
            return "star.fill"
        }
    }
}

