
import SwiftUI

struct HabitListView: View {
    @EnvironmentObject private var store: HabitStore
    @StateObject private var viewModel = HabitListViewModel()

    @State private var showAddHabit = false
    @State private var habitToEdit: Habit?
    @State private var habitToDelete: Habit?
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CategoryFilterBar(selected: $viewModel.selectedCategory)
                    .padding(.vertical, 8)

                ScrollView {
                    content
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("My Habits")
            .searchable(text: $viewModel.searchText, prompt: "Search habits by name")
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
            .sheet(item: $habitToEdit) { habit in
                HabitFormView(mode: .edit(habit))
            }
            .alert("Delete Habit?",
                   isPresented: $showDeleteAlert,
                   presenting: habitToDelete) { habit in
                Button("Delete", role: .destructive) {
                    withAnimation { store.delete(id: habit.id) }
                }
                Button("Cancel", role: .cancel) { }
            } message: { habit in
                Text("\"\(habit.name)\" and its entire streak history will be permanently deleted.")
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        let habits = viewModel.filteredHabits(from: store.habits)

        if store.habits.isEmpty {
            EmptyStateView(icon: "flame",
                           title: "No habits yet",
                           message: "Tap + to create your first habit.",
                           actionTitle: "Add Habit",
                           action: { showAddHabit = true })
        } else if habits.isEmpty {
            EmptyStateView(icon: "magnifyingglass",
                           title: "No matching habits",
                           message: "Try a different name or category.")
        } else {
            LazyVStack(spacing: 12) {
                ForEach(habits) { habit in
                    HabitCardView(
                        habit: habit,
                        onToggle: { store.toggleCheckIn(for: habit.id) },
                        onEdit: { habitToEdit = habit },
                        onDelete: {
                            habitToDelete = habit
                            showDeleteAlert = true
                        }
                    )
                }
            }
        }
    }
}
