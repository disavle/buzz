import Fluent
import FluentSQLiteDriver
import Shared
import Vapor

public func configure(_ app: Application) async throws {
    // Database: in memory for tests, otherwise a db.sqlite file next to the project.
    // To move to Postgres: change the driver and this line, models stay the same.
    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
        // Bcrypt is slow on purpose; tests do not need that.
        app.passwords.use(.plaintext)
    } else {
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    }

    // Errors are sent as codes (`{"error": "limit_invalid"}`), the client translates the text.
    app.middleware = Middlewares()
    app.middleware.use(RouteLoggingMiddleware(logLevel: .info))
    app.middleware.use(APIErrorMiddleware())

    // Dates in JSON are ISO 8601, same as the client (see Shared/Coding.swift).
    ContentConfiguration.global.use(encoder: JSONEncoder.buzz, for: .json)
    ContentConfiguration.global.use(decoder: JSONDecoder.buzz, for: .json)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
    app.migrations.add(CreateDrink())
    // The seed goes before CreateEntry: migrations are reverted in reverse order, so the entries
    // table is dropped first and deleting the seeded drinks does not hit the foreign key.
    app.migrations.add(SeedDrinks())
    app.migrations.add(CreateEntry())

    // For convenience during development, migrations run on startup.
    if app.environment == .development {
        try await app.autoMigrate()
    }

    try routes(app)
}
