import Vapor
import Fluent
import Shared

struct AuthController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("register", use: register)
        auth.post("login", use: login)
    }

    /// POST /auth/register
    @Sendable
    func register(req: Request) async throws -> TokenDTO {
        try RegisterDTO.validate(content: req)
        let input = try req.content.decode(RegisterDTO.self)
        let email = input.email.lowercased()

        if try await User.query(on: req.db).filter(\.$email == email).first() != nil {
            throw APIError(.conflict, .emailTaken)
        }

        let user = User(
            email: email,
            passwordHash: try req.password.hash(input.password),
            locale: input.locale ?? preferredLocale(req)
        )
        try await user.save(on: req.db)
        return try await issueToken(for: user, on: req.db)
    }

    /// POST /auth/login
    @Sendable
    func login(req: Request) async throws -> TokenDTO {
        let input = try req.content.decode(CredentialsDTO.self)
        guard
            let user = try await User.query(on: req.db).filter(\.$email == input.email.lowercased()).first(),
            try req.password.verify(input.password, created: user.passwordHash)
        else {
            throw APIError(.unauthorized, .invalidCredentials)
        }
        return try await issueToken(for: user, on: req.db)
    }

    /// If the client did not send a locale, we look at Accept-Language
    /// (URLSession fills it from the system language).
    private func preferredLocale(_ req: Request) -> AppLocale {
        let header = req.headers.first(name: .acceptLanguage)?.lowercased() ?? ""
        return header.hasPrefix("en") ? .en : .ru
    }

    private func issueToken(for user: User, on db: any Database) async throws -> TokenDTO {
        let token = try user.generateToken()
        try await token.save(on: db)
        return TokenDTO(token: token.value, user: try user.toDTO())
    }
}
