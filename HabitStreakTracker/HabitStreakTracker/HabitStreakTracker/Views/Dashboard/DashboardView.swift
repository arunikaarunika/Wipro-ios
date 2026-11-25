

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: HabitStore
    @State private var showAddHabit = false

    /// Lets the Dashboard switch the tab bar to the Habits tab.
    let onShowHabits: () -> Void

    private var viewModel: DashboardViewModel {
        DashboardViewModel(habits: store.habits)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    statsGrid
                    progressCard
                    pendingSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add habit")
                }
            }
            .navigationDestination(for: UUID.self) { id in
                HabitDetailView(habitID: id)
            }
            .sheet(isPresented: $showAddHabit) {
                HabitFormView(mode: .add)
            }
        }
    }

    

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.greeting)
                .font(.title2.bold())
            Text(Date().formatted(date: .complete, time: .omitted))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            StatCardView(title: "Total Habits",
                         value: "\(viewModel.totalHabits)",
                         icon: "list.bullet.rectangle.fill",
                         color: .blue)
            StatCardView(title: "Done Today",
                         value: "\(viewModel.completedToday)",
                         icon: "checkmark.circle.fill",
                         color: .green)
            StatCardView(title: "Longest Streak",
                         value: "\(viewModel.longestCurrentStreak)",
                         icon: "flame.fill",
                         color: .orange,
                         subtitle: viewModel.longestCurrentStreak > 0 ? viewModel.longestStreakHabit?.name : nil)
            StatCardView(title: "Pending Today",
                         value: "\(viewModel.pendingCount)",
                         icon: "hourglass",
                         color: .purple)
        }
    }

    private var progressCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.green.opacity(0.2), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: viewModel.progress)
                Text("\(Int(viewModel.progress * 100))%")
                    .font(.subheadline.bold())
            }
            .frame(width: 70, height: 70)

            VStack(alignment: .leading, spacing: 4) {
                Text("Today's Progress")
                    .font(.headline)
                Text("\(viewModel.completedToday) of \(viewModel.activeCount) habits completed")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    @ViewBuilder
    private var pendingSection: some View {
        if store.habits.isEmpty {
            EmptyStateView(icon: "flame",
                           title: "No habits yet",
                           message: "Create your first habit and start building a streak.",
                           actionTitle: "Add Habit",
                           action: { showAddHabit = true })
        } else {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Still pending today")
                        .font(.headline)
                    Spacer()
                    Button("All Habits", action: onShowHabits)
                        .font(.subheadline)
                }

                if viewModel.pendingHabits.isEmpty {
                    EmptyStateView(icon: "party.popper.fill",
                                   title: "All done!",
                                   message: "You completed every habit today. Keep the streak alive tomorrow.")
                } else {
                    ForEach(viewModel.pendingHabits) { habit in
                        HabitCardView(habit: habit) {
                            store.toggleCheckIn(for: habit.id)
                        }
                    }
                }
            }
        }
    }
}
