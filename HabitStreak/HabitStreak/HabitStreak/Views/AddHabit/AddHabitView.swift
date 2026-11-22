
import SwiftUI

struct AddHabitView: View {

    @ObservedObject var viewModel: HabitViewModel

    @Environment(\.dismiss) private var dismiss

    // MARK: - Form Properties

    @State private var name = ""
    @State private var motivationalNote = ""
    @State private var category = "Health"
    @State private var targetFrequency = 7
    @State private var startDate = Date()

    // MARK: - Categories

    private let categories = [
        "Health",
        "Fitness",
        "Learning",
        "Productivity",
        "Personal"
    ]

    // MARK: - Body

    var body: some View {

        NavigationStack {

            Form {

                Section("Habit Information") {

                    TextField(
                        "Habit name",
                        text: $name
                    )

                    TextField(
                        "Description (optional)",
                        text: $motivationalNote,
                        axis: .vertical
                    )
                    .lineLimit(2...4)

                    Picker(
                        "Category",
                        selection: $category
                    ) {

                        ForEach(categories, id: \.self) { item in
                            Text(item).tag(item)
                        }
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

                Section {

                    Text("Build consistency one day at a time.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)

            // MARK: - Toolbar

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
                    .disabled(
                        name.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
            }
        }
    }

    // MARK: - Save Habit

    private func saveHabit() {

        let newHabit = Habit(
            name: name.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            category: category,
            targetFrequency: targetFrequency,
            startDate: startDate,
            motivationalNote: motivationalNote
        )

        viewModel.addHabit(newHabit)

        dismiss()
    }
}

// MARK: - Preview

#Preview {
    AddHabitView(
        viewModel: HabitViewModel()
    )
}

