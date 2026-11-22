
import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject {

    // MARK: - Greeting

    var greeting: String {

        let hour = Calendar.current.component(
            .hour,
            from: Date()
        )

        switch hour {

        case 5..<12:
            return "Good morning"

        case 12..<17:
            return "Good afternoon"

        default:
            return "Good evening"
        }
    }

    // MARK: - Completed Count

    func completedCount(in habits: [Habit]) -> Int {

        habits.filter {
            $0.isCompletedToday
        }.count
    }

    // MARK: - Best Streak

    func bestStreak(in habits: [Habit]) -> Int {

        habits.map {
            StreakService.currentStreak(for: $0)
        }.max() ?? 0
    }
}

