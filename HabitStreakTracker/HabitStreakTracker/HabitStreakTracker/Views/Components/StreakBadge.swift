
import SwiftUI

struct StreakBadge: View {
    let streak: Int

    var body: some View {
        Label("\(streak)", systemImage: "flame.fill")
            .font(.caption.bold())
            .foregroundStyle(streak > 0 ? Color.orange : Color.secondary)
            .accessibilityLabel("Current streak \(streak) days")
    }
}
