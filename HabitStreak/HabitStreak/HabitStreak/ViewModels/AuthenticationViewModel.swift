import Foundation
import Combine

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showPINEntry = false
    @Published var enteredPIN = ""
    @Published var errorMessage = ""

    private let biometricService = BiometricService()
    private let pinService = PINStorageService()

    func authenticateWithBiometrics() {
        errorMessage = ""
        biometricService.authenticate { [weak self] success, message in
            Task { @MainActor in
                guard let self else { return }
                if success {
                    self.isAuthenticated = true
                    self.showPINEntry = false
                } else {
                    self.errorMessage = message ?? "Face ID was not successful. Please use your PIN."
                    self.showPINEntry = true
                }
            }
        }
    }

    func usePIN() {
        enteredPIN = ""
        errorMessage = ""
        showPINEntry = true
    }

    func verifyPIN() {
        guard enteredPIN.count == 4,
              enteredPIN.allSatisfy({ $0.isNumber }) else {
            errorMessage = "Please enter your 4-digit PIN."
            return
        }

        if pinService.verify(pin: enteredPIN) {
            isAuthenticated = true
            errorMessage = ""
        } else {
            errorMessage = "Incorrect PIN. Please try again."
            enteredPIN = ""
        }
    }

    func returnToBiometricLogin() {
        showPINEntry = false
        enteredPIN = ""
        errorMessage = ""
    }
}
