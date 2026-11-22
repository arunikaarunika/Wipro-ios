
import Foundation

struct StreakService {

    // MARK: - Current Streak

    static func currentStreak(for habit: Habit) -> Int {

        let calendar = Calendar.current

        let completedDays = Set(
            habit.checkInDates.map {
                calendar.startOfDay(for: $0)
            }
        )

        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())

        // Allow a streak to continue if today
        // has not been completed yet.
        if !completedDays.contains(currentDate) {
            guard let yesterday = calendar.date(
                byAdding: .day,
                value: -1,
                to: currentDate
            ), completedDays.contains(yesterday) else {
                return 0
            }

            currentDate = yesterday
        }

        while completedDays.contains(currentDate) {

            streak += 1

            guard let previousDate = calendar.date(
                byAdding: .day,
                value: -1,
                to: currentDate
            ) else {
                break
            }

            currentDate = previousDate
        }

        return streak
    }

    // MARK: - Best Streak

    static func bestStreak(for habit: Habit) -> Int {

        let calendar = Calendar.current

        let completedDays = Set(
            habit.checkInDates.map {
                calendar.startOfDay(for: $0)
            }
        )

        let sortedDates = completedDays.sorted()

        var bestStreak = 0
        var currentStreak = 0
        var previousDate: Date?

        for date in sortedDates {

            if let previousDate = previousDate,
               let nextDay = calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: previousDate
               ),
               calendar.isDate(date, inSameDayAs: nextDay) {

                currentStreak += 1

            } else {
                currentStreak = 1
            }

            bestStreak = max(bestStreak, currentStreak)
            previousDate = date
        }

        return bestStreak
    }
}

