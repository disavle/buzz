import Vapor
import Shared

struct MeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get("me", use: show)
        routes.patch("me", use: update)
    }

    /// GET /me
    @Sendable
    func show(req: Request) async throws -> UserDTO {
        try req.auth.require(User.self).toDTO()
    }

    /// PATCH /me
    @Sendable
    func update(req: Request) async throws -> UserDTO {
        let user = try req.auth.require(User.self)
        try UpdateMeDTO.validate(content: req)
        let input = try req.content.decode(UpdateMeDTO.self)
        if let limit = input.dailyCaffeineLimitMg {
            user.dailyCaffeineLimitMg = limit
        }
        if let locale = input.locale {
            user.locale = locale.rawValue
        }
        try await user.save(on: req.db)
        return try user.toDTO()
    }
}
