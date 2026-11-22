import Foundation
import LocalAuthentication

final class BiometricService {
    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                        error: &error) else {
            completion(false, error?.localizedDescription ?? "Biometric authentication is unavailable.")
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Unlock your HabitStreak account") { success, authError in
            DispatchQueue.main.async {
                completion(success, authError?.localizedDescription)
            }
        }
    }
}

