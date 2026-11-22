import Foundation

final class PINStorageService {
    // Demo PIN for the first version. Change this before publishing the app.
    private let demoPIN = "1234"

    func verify(pin: String) -> Bool {
        pin == demoPIN
    }
}

