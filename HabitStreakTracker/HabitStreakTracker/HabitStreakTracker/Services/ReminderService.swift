
import Foundation
import UserNotifications

enum ReminderService {
    private static let idPrefix = "habit-reminder-"
    private static let maxPending = 60

    // MARK: - Permission

    private static func isAuthorized(_ status: UNAuthorizationStatus) -> Bool {
        status == .authorized || status == .provisional || status == .ephemeral
    }

   
    static func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .notDetermined:
            return (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        default:
            return isAuthorized(settings.authorizationStatus)
        }
    }

    
    static func refresh(habits: [Habit]) async {
        let center = UNUserNotificationCenter.current()

        
        let pending = await center.pendingNotificationRequests()
        let ours = pending.map { $0.identifier }.filter { $0.hasPrefix(idPrefix) }
        center.removePendingNotificationRequests(withIdentifiers: ours)

        
        let settings = await center.notificationSettings()
        guard isAuthorized(settings.authorizationStatus) else { return }

        let active = habits.filter { $0.reminderEnabled && !$0.hasEnded }
        guard !active.isEmpty else { return }

        let daysAhead = max(2, min(14, maxPending / active.count))
        let now = Date()
        let calendar = Calendar.current

        for habit in active {
            for offset in 0..<daysAhead {
                let day = now.startOfDay.addingDays(offset)

                
                if day < habit.startDate.startOfDay { continue }
                if let end = habit.endDate, day > end.startOfDay { continue }
                
                if offset == 0 && habit.isCheckedInToday { continue }

                guard let fireDate = calendar.date(bySettingHour: habit.reminderHour,
                                                   minute: habit.reminderMinute,
                                                   second: 0,
                                                   of: day),
                      fireDate > now else { continue }

                let content = UNMutableNotificationContent()
                content.title = "Time for \(habit.name)"
                content.body = habit.note.isEmpty
                    ? "Complete it now and keep your streak going! 🔥"
                    : habit.note
                content.sound = .default

                let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
                let request = UNNotificationRequest(identifier: "\(idPrefix)\(habit.id.uuidString)-\(offset)",
                                                    content: content,
                                                    trigger: trigger)
                try? await center.add(request)
            }
        }
    }
}


final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
}
