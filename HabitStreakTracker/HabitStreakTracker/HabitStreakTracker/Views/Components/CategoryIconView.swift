
import SwiftUI

struct CategoryIconView: View {
    let category: HabitCategory
    var size: CGFloat = 44

    var body: some View {
        Image(systemName: category.icon)
            .font(.system(size: size * 0.45, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(category.color.gradient,
                        in: RoundedRectangle(cornerRadius: size * 0.28, style: .continuous))
            .accessibilityHidden(true)
    }
}
