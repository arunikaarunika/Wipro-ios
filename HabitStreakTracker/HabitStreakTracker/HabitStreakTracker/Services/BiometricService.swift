

import Foundation
import LocalAuthentication


enum BiometryKind {
    case none, faceID, touchID

    var displayName: String {
        switch self {
        case .faceID: return "Face ID"
        case .touchID: return "Touch ID"
        case .none: return "Biometrics"
        }
    }

    var symbolName: String {
        switch self {
        case .faceID: return "faceid"
        case .touchID: return "touchid"
        case .none: return "lock.fill"
        }
    }
}

enum BiometricResult {
    case success
    case cancelled
    case unavailable
    case failed(String)
}

protocol BiometricAuthenticating {
    func availableBiometry() -> BiometryKind
    func authenticate(reason: String) async -> BiometricResult
}

final class BiometricService: BiometricAuthenticating {

    func availableBiometry() -> BiometryKind {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        switch context.biometryType {
        case .faceID: return .faceID
        case .touchID: return .touchID
        default: return .none
        }
    }

    func authenticate(reason: String) async -> BiometricResult {
        let context = LAContext()
        context.localizedFallbackTitle = "Use PIN"

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .unavailable
        }

        do {
            let success = try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                           localizedReason: reason)
            return success ? .success : .failed("Authentication failed.")
        } catch let laError as LAError {
            switch laError.code {
            case .userCancel, .appCancel, .systemCancel, .userFallback:
                return .cancelled
            case .biometryNotAvailable, .biometryNotEnrolled, .biometryLockout:
                return .unavailable
            default:
                return .failed("Authentication failed. Please use your PIN.")
            }
        } catch {
            return .failed("Authentication failed. Please use your PIN.")
        }
    }
}
