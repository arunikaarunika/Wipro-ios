
import SwiftUI

struct HabitDetailView: View {
    let habitID: UUID

    @EnvironmentObject private var store: HabitStore
    @Environment(\.dismiss) private var dismiss
    @State private var showEdit = false
    @State private var showDeleteAlert = false

    var body: some View {
        Group {
            if let habit = store.habit(with: habitID) {
                content(for: habit)
            } else {
                // Habit was deleted – the screen is closing.
                Color.clear
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Habit Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showEdit = true }
            }
        }
        .sheet(isPresented: $showEdit) {
            if let habit = store.habit(with: habitID) {
                HabitFormView(mode: .edit(habit))
            }
        }
        .alert("Delete Habit?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                store.delete(id: habitID)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This habit and its entire streak history will be permanently deleted.")
        }
    }

  

    private func content(for habit: Habit) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard(for: habit)
                checkInButton(for: habit)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    StatCardView(title: "Current Streak",
                                 value: "\(habit.currentStreak)",
                                 icon: "flame.fill",
                                 color: .orange,
                                 subtitle: habit.currentStreak == 1 ? "day" : "days")
                    StatCardView(title: "Best Streak",
                                 value: "\(habit.bestStreak)",
                                 icon: "trophy.fill",
                                 color: .yellow,
                                 subtitle: habit.bestStreak == 1 ? "day" : "days")
                    StatCardView(title: "Total Check-ins",
                                 value: "\(habit.totalCheckIns)",
                                 icon: "checkmark.seal.fill",
                                 color: .green)
                    StatCardView(title: "Started On",
                                 value: habit.startDate.formatted(date: .abbreviated, time: .omitted),
                                 icon: "calendar",
                                 color: .blue)
                    StatCardView(title: "Ends On",
                                 value: habit.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "No end date",
                                 icon: "flag.checkered",
                                 color: .red)
                    StatCardView(title: "Daily Reminder",
                                 value: habit.reminderEnabled ? habit.reminderTimeText : "Off",
                                 icon: habit.reminderEnabled ? "bell.fill" : "bell.slash.fill",
                                 color: .purple)
                }

                lastSevenDays(for: habit)
                noteCard(for: habit)
                actionButtons
            }
            .padding()
        }
    }

   
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                showEdit = true
            } label: {
                Label("Edit", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)

            Button(role: .destructive) {
                showDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }

    private func headerCard(for habit: Habit) -> some View {
        HStack(spacing: 14) {
            CategoryIconView(category: habit.category, size: 56)
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.title3.bold())
                Text(habit.category.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("Target: \(habit.frequency.rawValue)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func checkInButton(for habit: Habit) -> some View {
        Button {
            withAnimation(.snappy) { store.toggleCheckIn(for: habit.id) }
        } label: {
            Label(habit.hasEnded ? "Habit ended" : (habit.isCheckedInToday ? "Checked in today – tap to undo" : "Check in for today"),
                  systemImage: habit.isCheckedInToday ? "checkmark.circle.fill" : "circle")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(habit.isCheckedInToday ? .green : .accentColor)
        .disabled(habit.hasEnded)
        .sensoryFeedback(.success, trigger: habit.isCheckedInToday)
    }

    private func lastSevenDays(for habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Last 7 Days")
                .font(.headline)
            HStack {
                ForEach((0..<7).reversed(), id: \.self) { offset in
                    let day = Date().addingDays(-offset)
                    let done = habit.isCheckedIn(on: day)
                    VStack(spacing: 6) {
                        Image(systemName: done ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(done ? Color.green : Color.secondary.opacity(0.5))
                        Text(day.formatted(.dateTime.weekday(.narrow)))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func noteCard(for habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Motivational Note", systemImage: "quote.opening")
                .font(.headline)
            Text(habit.note.isEmpty ? "No note added yet." : habit.note)
                .font(.body)
                .foregroundStyle(habit.note.isEmpty ? Color.secondary : Color.primary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
