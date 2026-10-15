import Foundation
import Testing
@testable import Domain

// Swift Testing: `@Test` functions and `#expect` instead of XCTestCase and XCTAssert.
// Tests can be plain functions, `async`, and parameterized with `arguments:`.

@Test("Caffeine and sugar are calculated from the volume")
func entryNutrition() {
    let entry = Entry.make(drink: SeedCatalog.redBull, volumeMl: 500, consumedAt: .now)
    #expect(entry.caffeineMg == 160)   // 32 mg per 100 ml * 5
    #expect(entry.sugarG == 55)
    #expect(entry.isSynced == false)   // new entries are pending until sync
}

@Test("Recent drinks are unique and newest first")
func recentDrinks() async throws {
    let now = Date.now
    let repo = InMemoryEntryRepository(entries: [
        .make(drink: SeedCatalog.burn, volumeMl: 250, consumedAt: now.addingTimeInterval(-300)),
        .make(drink: SeedCatalog.redBull, volumeMl: 250, consumedAt: now.addingTimeInterval(-200)),
        .make(drink: SeedCatalog.burn, volumeMl: 250, consumedAt: now.addingTimeInterval(-100)),
    ])
    let ids = try await repo.recentDrinkIds(limit: 5)
    #expect(ids == [SeedCatalog.burn.id, SeedCatalog.redBull.id])
}

@Test("Broadcaster sends one value to every listener")
func broadcasterFanOut() async {
    let broadcaster = Broadcaster<Int>()
    let first = broadcaster.stream()
    let second = broadcaster.stream()
    broadcaster.yield(42)

    var firstIterator = first.makeAsyncIterator()
    var secondIterator = second.makeAsyncIterator()
    #expect(await firstIterator.next() == 42)
    #expect(await secondIterator.next() == 42)
}

@MainActor
@Test("EntryStore reloads today after add")
func storeAdd() async throws {
    let store = EntryStore(repository: InMemoryEntryRepository())
    try await store.add(.make(drink: SeedCatalog.monster, volumeMl: 500, consumedAt: .now))
    #expect(store.today.count == 1)
    #expect(store.caffeineMg == 160)
}
