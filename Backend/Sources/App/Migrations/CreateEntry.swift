import Fluent

struct CreateEntry: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(Entry.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, "id", onDelete: .cascade))
            .field("drink_id", .uuid, .required, .references(Drink.schema, "id"))
            .field("consumed_at", .datetime, .required)
            .field("volume_ml", .int, .required)
            .field("price_minor", .int)
            .field("caffeine_mg", .double, .required)
            .field("sugar_g", .double, .required)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Entry.schema).delete()
    }
}
