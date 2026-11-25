

import SwiftUI

extension HabitCategory {
    var icon: String {
        switch self {
        case .health: return "heart.fill"
        case .study: return "book.fill"
        case .mindfulness: return "leaf.fill"
        case .finance: return "banknote.fill"
        case .hobby: return "paintpalette.fill"
        case .fitness: return "figure.run"
        case .other: return "star.fill"
        }
    }

    var color: Color {
        switch self {
        case .health: return .green
        case .study: return .blue
        case .mindfulness: return .purple
        case .finance: return .orange
        case .hobby: return .pink
        case .fitness: return .red
        case .other: return .gray
        }
    }
}
