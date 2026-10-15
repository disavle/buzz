import Domain
import Foundation
import Networking
import Persistence
import Shared
import Testing

@testable import Sync

// Sync tests run without network: MockAPIClient is the "server",
// and the database is in memory.

private struct Fixture {
    let api = MockAPIClient()
    let tokens = InMemoryTokenStore(token: "mock-token")
    let changes = Broadcaster<Void>()
    let repo: SwiftDataEntryRepository
    let store: SyncStore
    let engine: SyncEngine

    init() throws {
        let container = try PersistenceContainer.make(inMemory: true)
        // A separate UserDefaults suite, so tests do not share lastSyncedAt.
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        repo = SwiftDataEntryRepository(modelContainer: container, broadcaster: changes)
        store = SyncStore(modelContainer: container, changes: changes, defaults: defaults)
        engine = SyncEngine(store: store, api: api, tokens: tokens)
    }
}

@Test("Pending entry is sent and becomes synced")
func pushPending() async throws {
    let f = try Fixture()
    try await f.repo.add(.make(drink: SeedCatalog.redBull, volumeMl: 250, consumedAt: .now))

    await f.engine.syncNow()

    #expect(f.api.calls.contains("POST /entries"))
    #expect(try await f.repo.entries(onDayOf: .now).first?.isSynced == true)
    #expect(await f.engine.pendingCount() == 0)
}

@Test("An entry from another device is downloaded")
func pullRemote() async throws {
    let f = try Fixture()
    let id = UUID()
    f.api.seedRemote(
        EntryDTO(
            id: id,
            drinkId: SeedCatalog.monster.id,
            consumedAt: .now,
            volumeMl: 500,
            price: nil,
            caffeineMg: 160,
            sugarG: 55,
            updatedAt: .now,
            deletedAt: nil
        )
    )

    await f.engine.syncNow()

    let today = try await f.repo.entries(onDayOf: .now)
    #expect(today.map(\.id) == [id])
}

@Test("Without a token nothing is sent and the status is offlineGuest")
func guestMode() async throws {
    let f = try Fixture()
    await f.tokens.clear()
    try await f.repo.add(.make(drink: SeedCatalog.redBull, volumeMl: 250, consumedAt: .now))

    await f.engine.syncNow()

    #expect(f.api.calls.isEmpty)
    #expect(await f.engine.pendingCount() == 1)
}

@Test("A failed sync keeps entries pending")
func offlineKeepsPending() async throws {
    let container = try PersistenceContainer.make(inMemory: true)
    let changes = Broadcaster<Void>()
    let repo = SwiftDataEntryRepository(modelContainer: container, broadcaster: changes)
    let engine = SyncEngine(
        store: SyncStore(
            modelContainer: container,
            changes: changes,
            defaults: UserDefaults(suiteName: UUID().uuidString)!
        ),
        api: MockAPIClient(failure: .transport),
        tokens: InMemoryTokenStore(token: "t")
    )
    try await repo.add(.make(drink: SeedCatalog.redBull, volumeMl: 250, consumedAt: .now))

    await engine.syncNow()

    #expect(await engine.pendingCount() == 1)
}
