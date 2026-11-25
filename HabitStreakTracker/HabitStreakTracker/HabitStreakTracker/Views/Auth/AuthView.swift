
import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var isPINFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                faceIDSection
                orDivider
                pinSection
                loginButton
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            .padding(.bottom, 24)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemBackground).ignoresSafeArea())
    }


    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "flame.fill")
                .font(.system(size: 66))
                .foregroundStyle(.orange.gradient)
                .accessibilityHidden(true)
            Text("Habit Streak Tracker")
                .font(.system(size: 30, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text("Build good habits everyday")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }

    private var faceIDSection: some View {
        VStack(spacing: 14) {
            Image(systemName: viewModel.biometricSymbol)
                .font(.system(size: 58))
                .foregroundStyle(.indigo)
                .padding(.top, 8)
                .accessibilityHidden(true)

            Text("Login with \(viewModel.biometricName)")
                .font(.title2.bold())

            Button {
                isPINFocused = false
                Task { await viewModel.authenticateWithBiometrics(userInitiated: true) }
            } label: {
                Label("Login with \(viewModel.biometricName)", systemImage: viewModel.biometricSymbol)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
            }
            .background(Color.blue, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }

    private var orDivider: some View {
        HStack(spacing: 12) {
            Rectangle().frame(height: 1)
            Text("OR").font(.subheadline.bold())
            Rectangle().frame(height: 1)
        }
        .foregroundStyle(.secondary.opacity(0.6))
        .padding(.vertical, 4)
    }

    private var pinSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.white)
                SecureField("",
                            text: $viewModel.pin,
                            prompt: Text(viewModel.pinPlaceholder).foregroundStyle(Color.white.opacity(0.9)))
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .focused($isPINFocused)
            }
            .font(.headline)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(.systemGray), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            // Error (red) takes priority over the helper caption.
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            } else if let caption = viewModel.caption {
                Text(caption)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var loginButton: some View {
        Button {
            isPINFocused = false
            viewModel.submit()
        } label: {
            Text(viewModel.submitTitle)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
        }
        .background(Color.green, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
