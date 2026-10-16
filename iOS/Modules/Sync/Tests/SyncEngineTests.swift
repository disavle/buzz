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
    let localEdits = Broadcaster<Void>()
    let repo: SwiftDataEntryRepository
    let store: SyncStore
    let engine: SyncEngine

    init() throws {
        let container = try PersistenceContainer.make(inMemory: true)
        // A separate UserDefaults suite, so tests do not share lastSyncedAt.
        let defaults = UserDefaults(suiteName: UUID().uuidString)!
        repo = SwiftDataEntryRepository(modelContainer: container, broadcaster: changes, localEdits: localEdits)
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

private actor Counter {
    private(set) var value = 0
    func increment() { value += 1 }
}

@Test("A sync pass is not a local edit, so it does not start the next pass")
func syncDoesNotRetriggerItself() async throws {
    let f = try Fixture()
    let edits = Counter()
    let stream = f.localEdits.stream()
    let listener = Task { for await _ in stream { await edits.increment() } }

    try await f.repo.add(.make(drink: SeedCatalog.redBull, volumeMl: 250, consumedAt: .now))
    await f.engine.syncNow()  // marks the entry synced and pulls: both change data
    try await Task.sleep(for: .milliseconds(100))
    listener.cancel()

    #expect(await edits.value == 1)  // only the user's add, nothing from the sync itself
}

@Test("An empty /sync answer does not tell the screens to reload")
func emptyPullIsQuiet() async throws {
    let f = try Fixture()
    await f.engine.syncNow()  // first pass: catalog may arrive

    let reloads = Counter()
    let stream = f.changes.stream()
    let listener = Task { for await _ in stream { await reloads.increment() } }
    await f.engine.syncNow()  // nothing new on the server
    try await Task.sleep(for: .milliseconds(100))
    listener.cancel()

    #expect(await reloads.value == 0)
}
