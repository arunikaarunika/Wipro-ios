

import Foundation
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {

    enum Mode {
        case enterPIN, createPIN, confirmPIN
    }

    @Published private(set) var isUnlocked = false
    @Published private(set) var mode: Mode
    @Published private(set) var biometry: BiometryKind
    @Published private(set) var errorMessage: String?

    
    @Published var pin = "" {
        didSet {
            let filtered = String(pin.filter { "0123456789".contains($0) }.prefix(4))
            if filtered != pin {
                pin = filtered
            } else if oldValue != pin {
                errorMessage = nil
            }
        }
    }

    private var firstPIN = ""
    private var isAuthenticating = false
    private var needsBiometricPrompt = false

    private let biometric: BiometricAuthenticating
    private let pinStore: PINStoring

    init(biometric: BiometricAuthenticating = BiometricService(),
         pinStore: PINStoring = KeychainPINStore()) {
        self.biometric = biometric
        self.pinStore = pinStore
        self.biometry = biometric.availableBiometry()
        self.mode = pinStore.hasPIN ? .enterPIN : .createPIN
    }

    
    var biometricName: String {
        biometry == .none ? "Face ID" : biometry.displayName
    }

    var biometricSymbol: String {
        biometry == .touchID ? "touchid" : "faceid"
    }

    var pinPlaceholder: String {
        switch mode {
        case .enterPIN: return "Enter 4 digit pin"
        case .createPIN: return "Create 4 digit pin"
        case .confirmPIN: return "Confirm 4 digit pin"
        }
    }

    var submitTitle: String {
        switch mode {
        case .enterPIN: return "Login"
        case .createPIN: return "Continue"
        case .confirmPIN: return "Save PIN"
        }
    }

   
    var caption: String? {
        switch mode {
        case .enterPIN: return nil
        case .createPIN: return "First time? Create a 4-digit PIN as your backup login."
        case .confirmPIN: return "Enter the same PIN once more."
        }
    }

    
    func submit() {
        guard !pin.isEmpty else {
            errorMessage = "Please enter your 4-digit PIN."
            return
        }
        guard pin.count == 4 else {
            errorMessage = "PIN must be exactly 4 digits."
            return
        }

        switch mode {
        case .enterPIN:
            if pinStore.verify(pin: pin) {
                unlock()
            } else {
                pin = ""
                errorMessage = "Incorrect PIN. Please try again."
            }
        case .createPIN:
            firstPIN = pin
            pin = ""
            mode = .confirmPIN
        case .confirmPIN:
            if pin == firstPIN {
                if pinStore.save(pin: pin) {
                    unlock()
                } else {
                    resetCreation()
                    errorMessage = "Could not save the PIN. Please try again."
                }
            } else {
                resetCreation()
                errorMessage = "PINs do not match. Please start again."
            }
        }
    }

    
    func authenticateWithBiometrics(userInitiated: Bool = false) async {
        guard !isUnlocked, !isAuthenticating else { return }
        biometry = biometric.availableBiometry()
        guard biometry != .none else {
            if userInitiated {
                errorMessage = "\(biometricName) is not available on this device. Please use your PIN."
            }
            return
        }

        isAuthenticating = true
        let result = await biometric.authenticate(reason: "Unlock your Habit Streak Tracker")
        isAuthenticating = false

        switch result {
        case .success:
            unlock()
        case .failed(let message):
            errorMessage = message
        case .unavailable:
            if userInitiated {
                errorMessage = "\(biometricName) is not available. Please use your PIN."
            }
        case .cancelled:
            break
        }
    }

    
    func lock() {
        guard isUnlocked else { return }
        isUnlocked = false
        pin = ""
        errorMessage = nil
        mode = pinStore.hasPIN ? .enterPIN : .createPIN
        biometry = biometric.availableBiometry()
        needsBiometricPrompt = true
    }

    
    func handleBecameActive() async {
        guard needsBiometricPrompt else { return }
        needsBiometricPrompt = false
        await authenticateWithBiometrics()
    }

    

    private func unlock() {
        firstPIN = ""
        mode = pinStore.hasPIN ? .enterPIN : .createPIN
        pin = ""
        errorMessage = nil
        isUnlocked = true
    }

    private func resetCreation() {
        pin = ""
        firstPIN = ""
        mode = .createPIN
    }
}
