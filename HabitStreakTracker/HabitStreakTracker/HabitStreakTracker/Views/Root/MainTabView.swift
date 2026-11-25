//
//  MainTabView.swift
//  HabitStreakTracker
//
//  Tab navigation between the Dashboard and the Habit List.
//

import SwiftUI

enum AppTab: Hashable {
    case dashboard
    case habits
}

struct MainTabView: View {
    @State private var selection: AppTab = .dashboard

    var body: some View {
        TabView(selection: $selection) {
            DashboardView(onShowHabits: { selection = .habits })
                .tabItem { Label("Dashboard", systemImage: "square.grid.2x2.fill") }
                .tag(AppTab.dashboard)

            HabitListView()
                .tabItem { Label("Habits", systemImage: "checklist") }
                .tag(AppTab.habits)
        }
    }
}
