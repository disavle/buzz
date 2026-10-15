import Vapor
import Fluent
import Shared

struct SyncController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get("sync", use: sync)
    }

    struct SinceQuery: Content {
        var since: String?
    }

    /// GET /sync?since=
    /// Everything changed after `since`, including deleted entries (with deletedAt).
    /// Without `since` it returns everything. The client saves serverTime and sends it next time.
    @Sendable
    func sync(req: Request) async throws -> SyncDTO {
        let userID = try req.auth.require(User.self).requireID()
        let since = try isoDate(try req.query.decode(SinceQuery.self).since, name: "since")
        let serverTime = Date()

        let drinks = Drink.query(on: req.db).visible(to: userID)
        let entries = Entry.query(on: req.db).withDeleted().filter(\.$user.$id == userID)
        if let since {
            drinks.filter(\.$updatedAt >= since)
            entries.group(.or) { or in
                or.filter(\.$updatedAt >= since)
                or.filter(\.$deletedAt >= since)
            }
        }

        return SyncDTO(
            drinks: try await drinks.all().map { try $0.toDTO() },
            entries: try await entries.all().map { try $0.toDTO() },
            serverTime: serverTime
        )
    }
}
