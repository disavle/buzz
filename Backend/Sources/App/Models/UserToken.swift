import Vapor
import Fluent

/// A random string the server uses to find the user
/// from the `Authorization: Bearer <token>` header.
final class UserToken: Model, @unchecked Sendable {
    static let schema = "user_tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Parent(key: "user_id")
    var user: User

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

extension UserToken: ModelTokenAuthenticatable {
    static var valueKey: KeyPath<UserToken, Field<String>> { \UserToken.$value }
    static var userKey: KeyPath<UserToken, Parent<User>> { \UserToken.$user }

    // You can add a token expiry date here.
    var isValid: Bool { true }
}
