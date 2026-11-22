
import SwiftUI

struct HabitDetailsView: View {

    let habit: Habit

    // MARK: - Current Streak

    private var streak: Int {
        StreakService.currentStreak(for: habit)
    }

    // MARK: - Body

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                // Habit Header
                VStack(alignment: .leading, spacing: 10) {

                    Image(systemName: "star.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.orange)

                    Text(habit.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(habit.category)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Habit Statistics
                HStack(spacing: 12) {

                    statCard(
                        title: "Current Streak",
                        value: "\(streak)",
                        icon: "flame.fill"
                    )

                    statCard(
                        title: "Total Check-ins",
                        value: "\(habit.totalCheckIns)",
                        icon: "checkmark.circle.fill"
                    )
                }

                // Habit Information
                VStack(alignment: .leading, spacing: 15) {

                    Text("Habit Information")
                        .font(.headline)

                    infoRow(
                        title: "Target Frequency",
                        value: "\(habit.targetFrequency) days/week"
                    )

                    infoRow(
                        title: "Start Date",
                        value: habit.startDate.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )

                    infoRow(
                        title: "Today's Status",
                        value: habit.isCompletedToday
                            ? "Completed"
                            : "Not Completed"
                    )
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // Motivational Note
                VStack(alignment: .leading, spacing: 10) {

                    Text("Motivational Note")
                        .font(.headline)

                    Text(
                        habit.motivationalNote.isEmpty
                        ? "Keep going! Every small step counts."
                        : habit.motivationalNote
                    )
                    .font(.body)
                    .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .navigationTitle("Habit Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Statistics Card

    private func statCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            Image(systemName: icon)
                .foregroundStyle(.orange)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Information Row

    private func infoRow(
        title: String,
        value: String
    ) -> some View {

        HStack {

            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .fontWeight(.medium)
        }
    }
}

