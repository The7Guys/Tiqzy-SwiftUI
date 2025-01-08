import Foundation
import Security

class TokenManager {
    static let shared = TokenManager()
    private let service = "com.yourapp.tiqzy"
    private let account = "authToken"

    private init() {}

    // Save the token to Keychain
    func saveToken(_ token: String) {
        let data = token.data(using: .utf8)!

        // Remove any existing token
        deleteToken()

        // Create Keychain query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        // Add token to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Error saving token: \(status)")
            return
        }
    }

    // Retrieve the token from Keychain
    func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let data = item as? Data else {
            print("Error retrieving token: \(status)")
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    // Delete the token from Keychain
    func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        SecItemDelete(query as CFDictionary)
    }
}
