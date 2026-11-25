
import Foundation

@MainActor
final class HabitListViewModel: ObservableObject {
    @Published var searchText = ""
    
    @Published var selectedCategory: HabitCategory?

    func filteredHabits(from habits: [Habit]) -> [Habit] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return habits.filter { habit in
            let matchesCategory = selectedCategory == nil || habit.category == selectedCategory
            let matchesSearch = query.isEmpty || habit.name.localizedCaseInsensitiveContains(query)
            return matchesCategory && matchesSearch
        }
    }

    var isFiltering: Bool {
        selectedCategory != nil || !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
