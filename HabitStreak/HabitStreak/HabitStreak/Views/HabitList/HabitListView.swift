
import SwiftUI

struct HabitListView: View {
    let habits: [Habit]
    let onToggle: (Habit) -> Void
    let onSelect: (Habit) -> Void
    let onDelete: (Habit) -> Void

    var body: some View {
        List {
            ForEach(habits) { habit in
                HabitCardView(habit: habit) {
                    onToggle(habit)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelect(habit)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        onDelete(habit)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}




