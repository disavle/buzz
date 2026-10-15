import Foundation

/// The user's UI language. The server keeps it for later (push notifications, emails).
public enum AppLocale: String, Codable, Sendable, CaseIterable {
    case ru
    case en
}

/// Body of POST /auth/register.
public struct RegisterDTO: Codable, Sendable, Hashable {
    public var email: String
    public var password: String
    /// nil means "use the Accept-Language header".
    public var locale: AppLocale?

    public init(email: String, password: String, locale: AppLocale? = nil) {
        self.email = email
        self.password = password
        self.locale = locale
    }
}

/// Body of POST /auth/login.
public struct CredentialsDTO: Codable, Sendable, Hashable {
    public var email: String
    public var password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

/// Response of register and login. Send the token later in the header
/// `Authorization: Bearer <token>`.
public struct TokenDTO: Codable, Sendable, Hashable {
    public var token: String
    public var user: UserDTO

    public init(token: String, user: UserDTO) {
        self.token = token
        self.user = user
    }
}

/// GET /me
public struct UserDTO: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var email: String
    public var dailyCaffeineLimitMg: Int
    public var locale: AppLocale

    public init(id: UUID, email: String, dailyCaffeineLimitMg: Int, locale: AppLocale) {
        self.id = id
        self.email = email
        self.dailyCaffeineLimitMg = dailyCaffeineLimitMg
        self.locale = locale
    }
}

/// PATCH /me. nil means "do not change".
public struct UpdateMeDTO: Codable, Sendable, Hashable {
    public var dailyCaffeineLimitMg: Int?
    public var locale: AppLocale?

    public init(dailyCaffeineLimitMg: Int? = nil, locale: AppLocale? = nil) {
        self.dailyCaffeineLimitMg = dailyCaffeineLimitMg
        self.locale = locale
    }
}
