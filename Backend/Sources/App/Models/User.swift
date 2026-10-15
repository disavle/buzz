import Fluent
import Shared
import Vapor

final class User: Model, Authenticatable, @unchecked Sendable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "password_hash")
    var passwordHash: String

    @Field(key: "daily_caffeine_limit_mg")
    var dailyCaffeineLimitMg: Int

    /// "ru" or "en". A string, not an enum: this way we can add a language without a migration.
    @Field(key: "locale")
    var locale: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, email: String, passwordHash: String, dailyCaffeineLimitMg: Int = 400, locale: AppLocale = .ru)
    {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.dailyCaffeineLimitMg = dailyCaffeineLimitMg
        self.locale = locale.rawValue
    }

    func toDTO() throws -> UserDTO {
        UserDTO(
            id: try requireID(),
            email: email,
            dailyCaffeineLimitMg: dailyCaffeineLimitMg,
            locale: AppLocale(rawValue: locale) ?? .ru
        )
    }

    func generateToken() throws -> UserToken {
        try UserToken(value: [UInt8].random(count: 32).base64, userID: requireID())
    }
}
