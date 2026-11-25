
import SwiftUI
import UIKit

struct HabitFormView: View {
    @EnvironmentObject private var store: HabitStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: HabitFormViewModel

    init(mode: HabitFormViewModel.Mode) {
        _viewModel = StateObject(wrappedValue: HabitFormViewModel(mode: mode))
    }

    var body: some View {
        NavigationStack {
            Form {
                nameSection
                detailsSection
                reminderSection
                noteSection

                if let error = viewModel.errorMessage {
                    Section {
                        Label(error, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
            .task {
                await viewModel.requestNotificationPermission()
            }
            .onChange(of: viewModel.reminderEnabled) { _, _ in
                Task { await viewModel.requestNotificationPermission() }
            }
            .onChange(of: scenePhase) { _, phase in
                // Re-check after the user comes back from the Settings app.
                if phase == .active {
                    Task { await viewModel.requestNotificationPermission() }
                }
            }
            .onChange(of: viewModel.startDate) { _, newValue in
                // Keep the end date from falling before a newly chosen start date.
                if viewModel.endDate < newValue.startOfDay {
                    viewModel.endDate = newValue
                }
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Sections

    private var nameSection: some View {
        Section {
            TextField("e.g. Drink 2L water", text: $viewModel.name)
                .textInputAutocapitalization(.sentences)
        } header: {
            Text("Habit name")
        } footer: {
            Text("\(viewModel.name.count)/\(HabitFormViewModel.nameLimit)")
        }
    }

    private var detailsSection: some View {
        Section("Details") {
            Picker("Category", selection: $viewModel.category) {
                ForEach(HabitCategory.allCases) { category in
                    Label(category.rawValue, systemImage: category.icon)
                        .tag(category)
                }
            }
            Picker("Target frequency", selection: $viewModel.frequency) {
                ForEach(HabitFrequency.allCases) { frequency in
                    Text(frequency.rawValue).tag(frequency)
                }
            }
            if !viewModel.isEditing {
                DatePicker("Start date",
                           selection: $viewModel.startDate,
                           in: ...Date(),
                           displayedComponents: .date)
            }
            Toggle("Set end date", isOn: $viewModel.hasEndDate)
            if viewModel.hasEndDate {
                DatePicker("End date",
                           selection: $viewModel.endDate,
                           in: viewModel.earliestEndDate...,
                           displayedComponents: .date)
            }
        }
    }

    private var reminderSection: some View {
        Section {
            Toggle("Remind me every day", isOn: $viewModel.reminderEnabled)
            if viewModel.reminderEnabled {
                DatePicker("Reminder time",
                           selection: $viewModel.reminderTime,
                           displayedComponents: .hourAndMinute)
            }
        } header: {
            Text("Reminder")
        } footer: {
            if viewModel.reminderEnabled && viewModel.notificationsDenied {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Notifications are turned off for this app, so reminders cannot be delivered.")
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            openURL(url)
                        }
                    }
                }
            } else if viewModel.reminderEnabled {
                Text("You will get a notification at this time on every day the habit is active. Checking in early skips that day's reminder.")
            }
        }
    }

    private var noteSection: some View {
        Section {
            TextField("Why does this habit matter to you?", text: $viewModel.note, axis: .vertical)
                .lineLimit(3...6)
        } header: {
            Text("Motivational note")
        } footer: {
            Text("\(viewModel.note.count)/\(HabitFormViewModel.noteLimit)")
        }
    }

    
    private func save() {
        guard let habit = viewModel.makeHabit(existing: store.habits) else { return }
        if viewModel.isEditing {
            store.update(habit)
        } else {
            store.add(habit)
        }
        dismiss()
    }
}
