

import SwiftUI

struct CategoryFilterBar: View {
    @Binding var selected: HabitCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chip(title: "All", icon: "square.grid.2x2.fill", color: .accentColor, isSelected: selected == nil) {
                    selected = nil
                }
                ForEach(HabitCategory.allCases) { category in
                    chip(title: category.rawValue,
                         icon: category.icon,
                         color: category.color,
                         isSelected: selected == category) {
                        selected = (selected == category) ? nil : category
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func chip(title: String, icon: String, color: Color, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .background(isSelected ? color : Color(.secondarySystemGroupedBackground), in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
