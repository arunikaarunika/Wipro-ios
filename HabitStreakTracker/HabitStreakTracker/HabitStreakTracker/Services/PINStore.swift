

import Foundation
import Security
import CryptoKit

protocol PINStoring {
    var hasPIN: Bool { get }
    func save(pin: String) -> Bool
    func verify(pin: String) -> Bool
}

final class KeychainPINStore: PINStoring {
    private let service = "com.habitstreaktracker.pin"
    private let account = "user-pin"
   
    private let installFlagKey = "pinConfiguredOnThisInstall"

    init() {
        if !UserDefaults.standard.bool(forKey: installFlagKey) {
            deleteItem()
        }
    }

    var hasPIN: Bool {
        readItem() != nil
    }

    func save(pin: String) -> Bool {
        deleteItem()
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: hash(pin),
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            UserDefaults.standard.set(true, forKey: installFlagKey)
            return true
        }
        return false
    }

    func verify(pin: String) -> Bool {
        guard let stored = readItem() else { return false }
        return stored == hash(pin)
    }

    

    private func hash(_ pin: String) -> Data {
        Data(SHA256.hash(data: Data((pin + service).utf8)))
    }

    private func readItem() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess else { return nil }
        return item as? Data
    }

    private func deleteItem() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}
