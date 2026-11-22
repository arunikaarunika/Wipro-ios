
import SwiftUI

struct HabitCardView: View {

    let habit: Habit
    let onToggle: () -> Void

    // MARK: - Current Streak

    private var streak: Int {
        StreakService.currentStreak(for: habit)
    }

    // MARK: - Category Symbol

    private var categorySymbol: String {
        switch habit.category {
        case "Health":
            return "heart.fill"
        case "Fitness":
            return "figure.run"
        case "Learning":
            return "book.fill"
        case "Productivity":
            return "briefcase.fill"
        case "Personal":
            return "person.fill"
        default:
            return "star.fill"
        }
    }

    // MARK: - Body

    var body: some View {

        HStack(spacing: 14) {

            // Category Icon
            Image(systemName: categorySymbol)
                .font(.title2)
                .foregroundStyle(.orange)
                .frame(width: 42, height: 42)
                .background(Color.orange.opacity(0.12))
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )

            // Habit Information
            VStack(alignment: .leading, spacing: 5) {

                Text(habit.name)
                    .font(.headline)

                Text(habit.category)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Label(
                    "\(streak) day streak",
                    systemImage: "flame.fill"
                )
                .font(.caption)
                .foregroundStyle(.orange)
            }

            Spacer()

            // Completion Button
            Button(action: onToggle) {

                Image(
                    systemName: habit.isCompletedToday
                    ? "checkmark.circle.fill"
                    : "circle"
                )
                .font(.system(size: 28))
                .foregroundStyle(
                    habit.isCompletedToday ? .green : .secondary
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(
                habit.isCompletedToday
                ? "Mark incomplete"
                : "Mark complete"
            )
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

