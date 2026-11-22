
import SwiftUI

struct EditHabitView: View {

    @ObservedObject var viewModel: HabitViewModel

    @Environment(\.dismiss) private var dismiss

    let habit: Habit

    @State private var name: String
    @State private var motivationalNote: String
    @State private var category: String
    @State private var targetFrequency: Int
    @State private var startDate: Date

    @State private var showDeleteAlert = false

    // MARK: - Initialization

    init(habit: Habit, viewModel: HabitViewModel) {

        self.habit = habit
        self.viewModel = viewModel

        _name = State(initialValue: habit.name)
        _motivationalNote = State(
            initialValue: habit.motivationalNote
        )
        _category = State(initialValue: habit.category)
        _targetFrequency = State(
            initialValue: habit.targetFrequency
        )
        _startDate = State(initialValue: habit.startDate)
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {

            Form {

                // Habit Information
                Section("Habit Information") {

                    TextField("Habit name", text: $name)

                    TextField(
                        "Motivational note",
                        text: $motivationalNote,
                        axis: .vertical
                    )
                    .lineLimit(2...4)

                    Picker("Category", selection: $category) {

                        Text("Health").tag("Health")
                        Text("Fitness").tag("Fitness")
                        Text("Learning").tag("Learning")
                        Text("Productivity").tag("Productivity")
                        Text("Personal").tag("Personal")
                    }

                    Stepper(
                        "Target Frequency: \(targetFrequency) days/week",
                        value: $targetFrequency,
                        in: 1...7
                    )

                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: .date
                    )
                }

                // Delete Habit
                Section {

                    Button(role: .destructive) {

                        showDeleteAlert = true

                    } label: {

                        HStack {
                            Spacer()
                            Text("Delete Habit")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)

            // MARK: - Navigation Buttons

            .toolbar {

                ToolbarItem(placement: .topBarLeading) {

                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {

                    Button("Save") {
                        saveHabit()
                    }
                    .disabled(name.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty)
                }
            }

            // MARK: - Delete Confirmation

            .alert(
                "Delete Habit?",
                isPresented: $showDeleteAlert
            ) {

                Button("Cancel", role: .cancel) { }

                Button("Delete", role: .destructive) {

                    viewModel.deleteHabit(habit)
                    dismiss()
                }

            } message: {

                Text("Are you sure you want to delete this habit?")
            }
        }
    }

    // MARK: - Save Habit

    private func saveHabit() {

        let updatedHabit = Habit(
            id: habit.id,
            name: name.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            category: category,
            targetFrequency: targetFrequency,
            startDate: startDate,
            motivationalNote: motivationalNote,
            checkInDates: habit.checkInDates
        )

        viewModel.updateHabit(updatedHabit)

        dismiss()
    }
}

