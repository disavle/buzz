import Foundation
import Security

/// Where the auth token lives.
public protocol TokenStore: Sendable {
    func token() async -> String?
    func email() async -> String?
    func save(token: String, email: String) async
    func clear() async
}

/// Keeps the token in the Keychain: unlike UserDefaults, it is encrypted
/// and survives app reinstall only if you want it to.
///
/// The Keychain API is old C-style code (dictionaries with `kSec...` keys).
/// We hide it behind a small actor so the rest of the app never sees it.
public actor KeychainTokenStore: TokenStore {
    private let service = "com.disavle.buzz.auth"

    public init() {}

    public func token() -> String? { read(account: "token") }
    public func email() -> String? { read(account: "email") }

    public func save(token: String, email: String) {
        write(token, account: "token")
        write(email, account: "email")
    }

    public func clear() {
        delete(account: "token")
        delete(account: "email")
    }

    // MARK: - Keychain helpers

    private func baseQuery(account: String) -> [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: service,
         kSecAttrAccount as String: account]
    }

    private func read(account: String) -> String? {
        var query = baseQuery(account: account)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return String(decoding: data, as: UTF8.self)
    }

    private func write(_ value: String, account: String) {
        delete(account: account)
        var query = baseQuery(account: account)
        query[kSecValueData as String] = Data(value.utf8)
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        SecItemAdd(query as CFDictionary, nil)
    }

    private func delete(account: String) {
        SecItemDelete(baseQuery(account: account) as CFDictionary)
    }
}

/// Token store in memory, for tests and previews.
public actor InMemoryTokenStore: TokenStore {
    private var stored: (token: String, email: String)?

    public init(token: String? = nil, email: String = "demo@buzz.app") {
        if let token { stored = (token, email) }
    }

    public func token() -> String? { stored?.token }
    public func email() -> String? { stored?.email }
    public func save(token: String, email: String) { stored = (token, email) }
    public func clear() { stored = nil }
}
