import SwiftUI

struct PINLoginView: View {
    @ObservedObject var viewModel: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 22) {
            Spacer()

            Image(systemName: "lock.fill")
                .font(.system(size: 54))
                .foregroundStyle(.orange)

            Text("Enter your PIN")
                .font(.title.bold())

            SecureField("4-digit PIN", text: $viewModel.enteredPIN)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .multilineTextAlignment(.center)
                .font(.title2)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onChange(of: viewModel.enteredPIN) { newValue in
                    viewModel.enteredPIN = String(newValue.filter(\.isNumber).prefix(4))
                }

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }

            Button("Unlock") {
                viewModel.verifyPIN()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.orange)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button("Back to Face ID") {
                viewModel.returnToBiometricLogin()
            }

            Text("Demo PIN: 1234")
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(24)
    }
}

