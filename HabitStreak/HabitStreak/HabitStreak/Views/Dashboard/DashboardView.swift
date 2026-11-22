
import SwiftUI

struct DashboardView: View {

    @StateObject private var habitViewModel = HabitViewModel()
    @StateObject private var dashboardViewModel = DashboardViewModel()

    @State private var selectedCategory: String? = nil
    @State private var showingAddHabit = false
    @State private var editingHabit: Habit?

    private let categories = [
        "Health",
        "Fitness",
        "Learning",
        "Productivity",
        "Personal"
    ]

    // MARK: - Filter Habits

    private var filteredHabits: [Habit] {

        guard let selectedCategory else {
            return habitViewModel.habits
        }

        return habitViewModel.habits.filter {
            $0.category == selectedCategory
        }
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 22) {

                    // Greeting

                    VStack(alignment: .leading, spacing: 5) {

                        Text(dashboardViewModel.greeting)
                            .font(.title2.bold())

                        Text("Let's make today count.")
                            .foregroundStyle(.secondary)
                    }

                    // Statistics Cards

                    HStack(spacing: 12) {

                        StatisticsCardView(
                            title: "Today's progress",
                            value: "\(dashboardViewModel.completedCount(in: habitViewModel.habits))/\(habitViewModel.habits.count)",
                            symbol: "checkmark.circle.fill"
                        )

                        StatisticsCardView(
                            title: "Best current streak",
                            value: "\(dashboardViewModel.bestStreak(in: habitViewModel.habits))",
                            symbol: "flame.fill"
                        )
                    }

                    // Your Habits Heading

                    HStack {

                        Text("Your habits")
                            .font(.title3.bold())

                        Spacer()

                        Button {
                            showingAddHabit = true
                        } label: {

                            Label("Add", systemImage: "plus")
                                .font(.subheadline.weight(.semibold))
                        }
                    }

                    // Category Filter

                    ScrollView(.horizontal, showsIndicators: false) {

                        HStack(spacing: 10) {

                            categoryButton("All", category: nil)

                            ForEach(categories, id: \.self) { category in

                                categoryButton(
                                    category,
                                    category: category
                                )
                            }
                        }
                    }

                    // Habit List

                    if filteredHabits.isEmpty {

                        ContentUnavailableView(
                            "No habits yet",
                            systemImage: "leaf",
                            description: Text(
                                "Tap Add to create your first habit."
                            )
                        )
                        .padding(.top, 20)

                    } else {

                        LazyVStack(spacing: 12) {

                            ForEach(filteredHabits) { habit in

                                HabitCardView(habit: habit) {

                                    habitViewModel.toggleCompletion(
                                        for: habit
                                    )
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    editingHabit = habit
                                }
                                .contextMenu {

                                    Button(
                                        "Edit habit",
                                        systemImage: "pencil"
                                    ) {
                                        editingHabit = habit
                                    }

                                    Button(
                                        "Delete habit",
                                        systemImage: "trash",
                                        role: .destructive
                                    ) {
                                        habitViewModel.deleteHabit(habit)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("HabitStreak")

            // Add Habit Sheet

            .sheet(isPresented: $showingAddHabit) {

                AddHabitView(viewModel: habitViewModel)
            }

            // Edit Habit Sheet

            .sheet(item: $editingHabit) { habit in

                EditHabitView(
                    habit: habit,
                    viewModel: habitViewModel
                )
            }
        }
    }

    // MARK: - Category Button

    private func categoryButton(
        _ title: String,
        category: String?
    ) -> some View {

        let isSelected = selectedCategory == category

        return Button {

            selectedCategory = category

        } label: {

            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    isSelected ? Color.orange : Color(.systemGray6)
                )
                .foregroundStyle(
                    isSelected ? Color.white : Color.primary
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

