import SwiftUI

struct CategoryFilterView: View {
    @Binding var selectedCategory: HabitCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                filterButton(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }

                ForEach(HabitCategory.allCases) { category in
                    filterButton(title: category.rawValue,
                                 isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func filterButton(title: String,
                              isSelected: Bool,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(isSelected ? Color.orange : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
