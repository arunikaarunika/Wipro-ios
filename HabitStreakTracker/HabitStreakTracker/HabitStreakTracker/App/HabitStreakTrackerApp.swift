//
//  HabitStreakTrackerApp.swift
//  HabitStreakTracker
//
//  App entry point. All real work happens in `RootView`.
//

import SwiftUI
import UserNotifications

@main
struct HabitStreakTrackerApp: App {
    init() {
        // Show habit reminders as banners even when the app is in the foreground.
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
