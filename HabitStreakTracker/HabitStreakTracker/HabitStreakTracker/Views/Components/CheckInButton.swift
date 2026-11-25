
import SwiftUI

struct CheckInButton: View {
    let isChecked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 30))
                .foregroundStyle(isChecked ? Color.green : Color.secondary)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.success, trigger: isChecked)
        .accessibilityLabel(isChecked ? "Checked in today. Tap to undo" : "Check in for today")
    }
}
