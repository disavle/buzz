@testable import App
import VaporTesting
import Testing
import Fluent
import Shared

@Suite("Buzz API", .serialized)
struct AppTests {
    /// Starts the app in memory with a clean database for every test.
    private func withApp(_ test: (Application) async throws -> Void) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }

    /// Registers a user and returns their token.
    private func register(_ app: Application, email: String = "me@buzz.app") async throws -> String {
        var token: String?
        try await app.testing().test(.POST, "auth/register", beforeRequest: { req in
            try req.content.encode(RegisterDTO(email: email, password: "password123", locale: .ru))
        }, afterResponse: { res async throws in
            #expect(res.status == .ok)
            token = try res.content.decode(TokenDTO.self).token
        })
        return try #require(token)
    }

    /// The first drink of the shared catalog.
    private func anyDrink(_ app: Application) async throws -> Drink {
        try #require(try await Drink.query(on: app.db).filter(\.$brand == "Red Bull").first())
    }

    /// Checks the HTTP status and the error code in the response body.
    private func expectError(_ res: TestingHTTPResponse, _ status: HTTPStatus, _ code: APIErrorCode) throws {
        #expect(res.status == status)
        #expect(try res.content.decode(APIErrorDTO.self).error == code)
    }

    // MARK: - Auth

    @Test("Protected routes answer 401 with code unauthorized when there is no token")
    func unauthorized() async throws {
        try await withApp { app in
            try await app.testing().test(.GET, "drinks") { res async throws in
                try expectError(res, .unauthorized, .unauthorized)
            }
        }
    }

    @Test("Register, read profile and change the limit")
    func registerAndMe() async throws {
        try await withApp { app in
            let token = try await register(app)

            try await app.testing().test(.GET, "me", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: token)
            }, afterResponse: { res async throws in
                let me = try res.content.decode(UserDTO.self)
                #expect(me.email == "me@buzz.app")
                #expect(me.dailyCaffeineLimitMg == 400)
                #expect(me.locale == .ru)
            })

            try await app.testing().test(.PATCH, "me", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: token)
                try req.content.encode(UpdateMeDTO(dailyCaffeineLimitMg: 300, locale: .en))
            }, afterResponse: { res async throws in
                let me = try res.content.decode(UserDTO.self)
                #expect(me.dailyCaffeineLimitMg == 300)
                #expect(me.locale == .en)
            })

            try await app.testing().test(.PATCH, "me", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: token)
                try req.content.encode(UpdateMeDTO(dailyCaffeineLimitMg: 0))
            }, afterResponse: { res async throws in
                try expectError(res, .badRequest, .limitInvalid)
            })
        }
    }

    @Test("Register and login errors come as codes")
    func authErrors() async throws {
        try await withApp { app in
            _ = try await register(app)

            try await app.testing().test(.POST, "auth/register", beforeRequest: { req in
                try req.content.encode(RegisterDTO(email: "ME@buzz.app", password: "password123"))
            }, afterResponse: { res async throws in
                try expectError(res, .conflict, .emailTaken)
            })

            try await app.testing().test(.POST, "auth/register", beforeRequest: { req in
                try req.content.encode(RegisterDTO(email: "new@buzz.app", password: "short"))
            }, afterResponse: { res async throws in
                try expectError(res, .badRequest, .passwordTooShort)
            })

            try await app.testing().test(.POST, "auth/login", beforeRequest: { req in
                try req.content.encode(CredentialsDTO(email: "me@buzz.app", password: "wrong-password"))
            }, afterResponse: { res async throws in
                try expectError(res, .unauthorized, .invalidCredentials)
            })
        }
    }

    @Test("Locale comes from Accept-Language when the client does not send it")
    func localeFromHeader() async throws {
        try await withApp { app in
            try await app.testing().test(.POST, "auth/register", beforeRequest: { req in
                req.headers.replaceOrAdd(name: .acceptLanguage, value: "en-US,en;q=0.9")
                try req.content.encode(RegisterDTO(email: "en@buzz.app", password: "password123"))
            }, afterResponse: { res async throws in
                #expect(try res.content.decode(TokenDTO.self).user.locale == .en)
            })
        }
    }

    // MARK: - Catalog

    @Test("Catalog search, and custom drinks are visible only to their owner")
    func drinks() async throws {
        try await withApp { app in
            let alice = try await register(app, email: "alice@buzz.app")
            let bob = try await register(app, email: "bob@buzz.app")

            try await app.testing().test(.GET, "drinks?query=Monster", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: alice)
            }, afterResponse: { res async throws in
                let drinks = try res.content.decode([DrinkDTO].self)
                #expect(drinks.count == 2)
                #expect(drinks.allSatisfy { $0.brand == "Monster" })
            })

            try await app.testing().test(.POST, "drinks", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: alice)
                try req.content.encode(CreateDrinkDTO(brand: "Homemade", name: "Cold Brew", volumeMl: 330, caffeinePer100ml: 20, sugarPer100ml: 5))
            }, afterResponse: { res async throws in
                #expect(try res.content.decode(DrinkDTO.self).isCustom)
            })

            try await app.testing().test(.GET, "drinks?query=Homemade", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: bob)
            }, afterResponse: { res async throws in
                #expect(try res.content.decode([DrinkDTO].self).isEmpty)
            })
        }
    }

    // MARK: - Entries and sync

    @Test("Entry calculates caffeine, a retry does not create a duplicate, delete is soft")
    func entriesLifecycle() async throws {
        try await withApp { app in
            let token = try await register(app)
            let drink = try await anyDrink(app) // Red Bull 250 ml, 32 mg/100 ml
            let input = CreateEntryDTO(drinkId: try drink.requireID(), price: 1.99)

            for _ in 0..<2 {
                try await app.testing().test(.POST, "entries", beforeRequest: { req in
                    req.headers.bearerAuthorization = .init(token: token)
                    try req.content.encode(input)
                }, afterResponse: { res async throws in
                    let entry = try res.content.decode(EntryDTO.self)
                    #expect(entry.id == input.id)
                    #expect(entry.caffeineMg == 80)
                    #expect(entry.price == Decimal(string: "1.99"))
                })
            }
            #expect(try await Entry.query(on: app.db).count() == 1)

            try await app.testing().test(.DELETE, "entries/\(input.id)", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: token)
            }, afterResponse: { res async throws in
                #expect(res.status == .noContent)
            })

            try await app.testing().test(.GET, "entries", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: token)
            }, afterResponse: { res async throws in
                #expect(try res.content.decode([EntryDTO].self).isEmpty)
            })

            try await app.testing().test(.GET, "sync", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: token)
            }, afterResponse: { res async throws in
                let sync = try res.content.decode(SyncDTO.self)
                #expect(sync.entries.count == 1)
                #expect(sync.entries.first?.deletedAt != nil)
                #expect(sync.drinks.count == 8)
            })
        }
    }

    @Test("You cannot delete another user's entry")
    func foreignEntry() async throws {
        try await withApp { app in
            let alice = try await register(app, email: "alice@buzz.app")
            let bob = try await register(app, email: "bob@buzz.app")
            let input = CreateEntryDTO(drinkId: try await anyDrink(app).requireID())

            try await app.testing().test(.POST, "entries", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: alice)
                try req.content.encode(input)
            })
            try await app.testing().test(.DELETE, "entries/\(input.id)", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: bob)
            }, afterResponse: { res async throws in
                try expectError(res, .notFound, .notFound)
            })
        }
    }

    // MARK: - Stats

    @Test("Stats for a week")
    func stats() async throws {
        try await withApp { app in
            let token = try await register(app)
            let drinkID = try await anyDrink(app).requireID()

            for _ in 0..<2 {
                try await app.testing().test(.POST, "entries", beforeRequest: { req in
                    req.headers.bearerAuthorization = .init(token: token)
                    try req.content.encode(CreateEntryDTO(drinkId: drinkID, price: 2))
                })
            }

            try await app.testing().test(.GET, "stats?period=week&tz=UTC", beforeRequest: { req in
                req.headers.bearerAuthorization = .init(token: token)
            }, afterResponse: { res async throws in
                let stats = try res.content.decode(StatsDTO.self)
                #expect(stats.byDay.count == 7)
                #expect(stats.byDay.last?.caffeineMg == 160)
                #expect(stats.byHour.count == 24)
                #expect(stats.byHour.map(\.count).reduce(0, +) == 2)
                #expect(stats.byBrand == [BrandStat(brand: "Red Bull", count: 2)])
                #expect(stats.spendByWeek.first?.total == 4)
            })
        }
    }
}
