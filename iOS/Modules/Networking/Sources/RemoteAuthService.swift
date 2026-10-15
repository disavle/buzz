import Domain
import Foundation
import Shared

/// `AuthService` that talks to the Vapor backend and keeps the token in a `TokenStore`.
public struct RemoteAuthService: AuthService {
    private let api: any APIClient
    private let tokens: any TokenStore

    public init(api: any APIClient, tokens: any TokenStore) {
        self.api = api
        self.tokens = tokens
    }

    public func currentEmail() async -> String? {
        await tokens.email()
    }

    public func login(email: String, password: String) async throws(AuthError) {
        let result = try await call(.login(CredentialsDTO(email: email, password: password)))
        await tokens.save(token: result.token, email: result.user.email)
    }

    public func register(email: String, password: String) async throws(AuthError) {
        // The server reads Accept-Language when `locale` is nil, but we can be explicit.
        let locale: AppLocale = Locale.current.language.languageCode?.identifier == "ru" ? .ru : .en
        let result = try await call(.register(RegisterDTO(email: email, password: password, locale: locale)))
        await tokens.save(token: result.token, email: result.user.email)
    }

    public func logout() async {
        await tokens.clear()
    }

    /// Converts network errors to errors the login screen understands.
    /// `throws(AuthError)` is "typed throws" (Swift 6): the caller knows the exact error type.
    private func call(_ endpoint: Endpoint<TokenDTO>) async throws(AuthError) -> TokenDTO {
        do {
            return try await api.send(endpoint)
        } catch {
            switch error {
            case .server(.invalidCredentials, _), .unauthorized: throw .invalidCredentials
            case .server(.emailTaken, _): throw .emailTaken
            case .server(.emailInvalid, _): throw .emailInvalid
            case .server(.passwordTooShort, _): throw .passwordTooShort
            case .transport: throw .network
            default: throw .unknown
            }
        }
    }
}
