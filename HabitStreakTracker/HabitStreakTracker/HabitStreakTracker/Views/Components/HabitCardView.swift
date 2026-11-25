
import SwiftUI

struct HabitCardView: View {
    let habit: Habit
    let onToggle: () -> Void
    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil

    private var showsActions: Bool {
        onEdit != nil || onDelete != nil
    }

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                NavigationLink(value: habit.id) {
                    HStack(spacing: 12) {
                        CategoryIconView(category: habit.category)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(habit.name)
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            HStack(spacing: 8) {
                                Text(habit.category.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                StreakBadge(streak: habit.currentStreak)
                            }
                            HStack(spacing: 6) {
                                Text(statusText)
                                    .foregroundStyle(statusColor)
                                if habit.reminderEnabled && !habit.hasEnded {
                                    Label(habit.reminderTimeText, systemImage: "bell.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .font(.caption)
                        }
                        Spacer(minLength: 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                CheckInButton(isChecked: habit.isCheckedInToday) {
                    withAnimation(.snappy) { onToggle() }
                }
                .disabled(habit.hasEnded)
                .opacity(habit.hasEnded ? 0.4 : 1)
            }

            if showsActions {
                Divider()
                actionRow
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var statusText: String {
        if habit.hasEnded, let end = habit.endDate {
            return "Ended on \(end.formatted(date: .abbreviated, time: .omitted))"
        }
        return habit.isCheckedInToday ? "Checked in today" : "Not checked in yet"
    }

    private var statusColor: Color {
        if habit.hasEnded { return .orange }
        return habit.isCheckedInToday ? .green : .secondary
    }

    /// Always-visible View / Edit / Delete buttons.
    private var actionRow: some View {
        HStack {
            NavigationLink(value: habit.id) {
                Label("View", systemImage: "eye")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)

            if let onEdit {
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
            }

            if let onDelete {
                Button(role: .destructive, action: onDelete) {
                    Label("Delete", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderless)
            }
        }
        .font(.subheadline.weight(.medium))
    }
}
