import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Shared
import Vapor

public func configure(_ app: Application) async throws {
    // Database:
    // - tests: SQLite in memory;
    // - DATABASE_URL is set (the deployed server, see docs/backend/DEPLOY.md): Postgres, e.g. on Neon;
    // - otherwise: a db.sqlite file next to the project.
    // Models and migrations are the same for both databases, only the driver changes.
    if app.environment == .testing {
        app.databases.use(.sqlite(.memory), as: .sqlite)
        // Bcrypt is slow on purpose; tests do not need that.
        app.passwords.use(.plaintext)
    } else if let databaseURL = Environment.get("DATABASE_URL") {
        // The URL looks like postgres://user:password@host/dbname?sslmode=require
        // `sslmode=require` turns on TLS, which cloud databases ask for.
        let postgres = try SQLPostgresConfiguration(url: databaseURL)
        app.databases.use(.postgres(configuration: postgres), as: .psql)
    } else {
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    }

    // Hosting platforms like Render tell the app which port to listen on via PORT.
    if let port = Environment.get("PORT").flatMap(Int.init) {
        app.http.server.configuration.port = port
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

    // Migrations run on startup during development, and on the deployed server
    // where the Dockerfile sets AUTO_MIGRATE=true (a free host has no shell to run `migrate` by hand).
    if app.environment == .development || Environment.get("AUTO_MIGRATE") == "true" {
        try await app.autoMigrate()
    }

    try routes(app)
}
