import Fluent
import Shared
import Vapor

struct DrinkController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let drinks = routes.grouped("drinks")
        drinks.get(use: index)
        drinks.post(use: create)
    }

    struct SearchQuery: Content {
        var query: String?
    }

    /// GET /drinks?query=monster
    @Sendable
    func index(req: Request) async throws -> [DrinkDTO] {
        let userID = try req.auth.require(User.self).requireID()
        let search = try req.query.decode(SearchQuery.self).query?.trimmingCharacters(in: .whitespaces)

        let query = Drink.query(on: req.db).visible(to: userID)
        if let search, !search.isEmpty {
            // ~~ means LIKE '%...%'. In SQLite it ignores case (for Latin letters),
            // in Postgres it does not: there you need ILIKE via .custom.
            query.group(.or) { or in
                or.filter(\.$brand ~~ search)
                or.filter(\.$name ~~ search)
            }
        }
        return
            try await query
            .sort(\.$brand)
            .sort(\.$name)
            .all()
            .map { try $0.toDTO() }
    }

    /// POST /drinks
    @Sendable
    func create(req: Request) async throws -> DrinkDTO {
        let userID = try req.auth.require(User.self).requireID()
        try CreateDrinkDTO.validate(content: req)
        let input = try req.content.decode(CreateDrinkDTO.self)
        let drink = Drink(
            brand: input.brand,
            name: input.name,
            volumeMl: input.volumeMl,
            caffeinePer100ml: input.caffeinePer100ml,
            sugarPer100ml: input.sugarPer100ml,
            ownerID: userID
        )
        try await drink.save(on: req.db)
        return try drink.toDTO()
    }
}
