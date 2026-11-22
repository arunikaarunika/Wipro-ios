import SwiftUI

struct AuthenticationViews: View {
    @StateObject private var viewModel = AuthenticationViewModel()

    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                DashboardView()
            } else if viewModel.showPINEntry {
                PINLoginView(viewModel: viewModel)
            } else {
                VStack(spacing: 24) {
                    Spacer()

                    Image(systemName: "flame.fill")
                        .font(.system(size: 76))
                        .foregroundStyle(.orange)

                    Text("Habit Streak Tracker")
                        .font(.largeTitle.bold())

                    Text("Build better habits, one day at a time.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Spacer()

                    Button {
                        viewModel.authenticateWithBiometrics()
                    } label: {
                        Label("Continue with Face ID", systemImage: "faceid")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button("Use PIN instead") {
                        viewModel.usePIN()
                    }
                    .padding(.bottom, 24)

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
                .padding(24)
            }
        }
    }
}

