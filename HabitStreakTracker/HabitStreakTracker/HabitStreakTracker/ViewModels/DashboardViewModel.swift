
import Foundation

struct DashboardViewModel {
    let habits: [Habit]

    var totalHabits: Int { habits.count }

    var completedToday: Int {
        habits.filter { $0.isCheckedInToday }.count
    }

   
    var pendingHabits: [Habit] {
        habits.filter { !$0.isCheckedInToday && !$0.hasEnded }
    }

    var pendingCount: Int { pendingHabits.count }

    
    var activeCount: Int { completedToday + pendingCount }

    
    var longestStreakHabit: Habit? {
        habits.max { $0.currentStreak < $1.currentStreak }
    }

    var longestCurrentStreak: Int {
        longestStreakHabit?.currentStreak ?? 0
    }

    
    var progress: Double {
        activeCount == 0 ? 0 : Double(completedToday) / Double(activeCount)
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Hello"
        }
    }
}
