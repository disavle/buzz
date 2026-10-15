import Foundation

/// Errors a user can see on the login screen.
/// The text is not here: the UI translates each case with the String Catalog.
public enum AuthError: Error, Equatable, Sendable {
    case invalidCredentials
    case emailTaken
    case emailInvalid
    case passwordTooShort
    case network
    case unknown
}

/// Login, register and logout. The real implementation is in Networking.
public protocol AuthService: Sendable {
    /// The email of the logged-in user, or nil for a guest.
    func currentEmail() async -> String?
    func login(email: String, password: String) async throws(AuthError)
    func register(email: String, password: String) async throws(AuthError)
    func logout() async
}
