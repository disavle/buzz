import Foundation

/// Body of any error response: `{"error": "limit_invalid", "reason": "..."}`.
/// The server never sends text for the user: the client translates `error`
/// with its own String Catalog. `reason` is only for logs and debugging.
public struct APIErrorDTO: Codable, Sendable, Hashable, Error {
    public var error: APIErrorCode
    public var reason: String?

    public init(error: APIErrorCode, reason: String? = nil) {
        self.error = error
        self.reason = reason
    }
}

public enum APIErrorCode: String, Codable, Sendable, CaseIterable {
    // General
    case invalidBody = "invalid_body"
    case validationFailed = "validation_failed"
    case invalidDate = "invalid_date"
    case unauthorized
    case notFound = "not_found"
    case `internal`

    // Auth and profile
    case emailInvalid = "email_invalid"
    case passwordTooShort = "password_too_short"
    case emailTaken = "email_taken"
    case invalidCredentials = "invalid_credentials"
    case limitInvalid = "limit_invalid"
    case localeInvalid = "locale_invalid"

    // Drinks and entries
    case drinkInvalid = "drink_invalid"
    case volumeInvalid = "volume_invalid"
    case unknownDrink = "unknown_drink"
    case entryConflict = "entry_conflict"

    /// A code the client does not know yet (the server was updated before the app).
    case unknown

    public init(from decoder: any Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = APIErrorCode(rawValue: raw) ?? .unknown
    }
}
