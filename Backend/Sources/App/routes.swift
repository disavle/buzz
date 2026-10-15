import Vapor

func routes(_ app: Application) throws {
    app.get("health") { _ async -> String in
        "ok"
    }

    // Public routes
    try app.register(collection: AuthController())

    // Everything else needs a token: Authorization: Bearer <token>
    let protected = app.grouped(UserToken.authenticator(), User.guardMiddleware())
    try protected.register(collection: MeController())
    try protected.register(collection: DrinkController())
    try protected.register(collection: EntryController())
    try protected.register(collection: SyncController())
    try protected.register(collection: StatsController())
}
