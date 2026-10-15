import Fluent

struct CreateDrink: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(Drink.schema)
            .id()
            .field("brand", .string, .required)
            .field("name", .string, .required)
            .field("volume_ml", .int, .required)
            .field("caffeine_per_100ml", .double, .required)
            .field("sugar_per_100ml", .double, .required)
            .field("image_url", .string)
            .field("owner_id", .uuid, .references(User.schema, "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(Drink.schema).delete()
    }
}
