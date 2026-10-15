import Fluent
import Shared
import Vapor

struct EntryController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let entries = routes.grouped("entries")
        entries.get(use: index)
        entries.post(use: create)
        entries.delete(":id", use: delete)
    }

    struct PeriodQuery: Content {
        var from: String?
        var to: String?
    }

    /// GET /entries?from=&to=  (from is inclusive, to is exclusive)
    @Sendable
    func index(req: Request) async throws -> [EntryDTO] {
        let userID = try req.auth.require(User.self).requireID()
        let period = try req.query.decode(PeriodQuery.self)

        let query = Entry.query(on: req.db).filter(\.$user.$id == userID)
        if let from = try isoDate(period.from, name: "from") {
            query.filter(\.$consumedAt >= from)
        }
        if let to = try isoDate(period.to, name: "to") {
            query.filter(\.$consumedAt < to)
        }
        return
            try await query
            .sort(\.$consumedAt, .descending)
            .all()
            .map { try $0.toDTO() }
    }

    /// POST /entries
    /// Idempotent: sending the same entry again (for example after a network drop)
    /// does not create a duplicate, it returns the saved one.
    @Sendable
    func create(req: Request) async throws -> EntryDTO {
        let userID = try req.auth.require(User.self).requireID()
        try CreateEntryDTO.validate(content: req)
        let input = try req.content.decode(CreateEntryDTO.self)

        if let existing = try await Entry.query(on: req.db).withDeleted().filter(\.$id == input.id).first() {
            guard existing.$user.id == userID else { throw APIError(.conflict, .entryConflict) }
            return try existing.toDTO()
        }

        guard let drink = try await Drink.find(input.drinkId, on: req.db), drink.isVisible(to: userID) else {
            throw APIError(.badRequest, .unknownDrink)
        }

        let entry = try Entry(
            id: input.id,
            userID: userID,
            drink: drink,
            consumedAt: input.consumedAt,
            volumeMl: input.volumeMl ?? drink.volumeMl,
            priceMinor: input.price.map(Money.toMinor)
        )
        try await entry.create(on: req.db)
        return try entry.toDTO()
    }

    /// DELETE /entries/:id  (soft delete)
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let userID = try req.auth.require(User.self).requireID()
        guard
            let id = req.parameters.get("id", as: UUID.self),
            let entry = try await Entry.query(on: req.db)
                .filter(\.$id == id)
                .filter(\.$user.$id == userID)
                .first()
        else {
            throw Abort(.notFound)
        }
        try await entry.delete(on: req.db)
        return .noContent
    }
}
