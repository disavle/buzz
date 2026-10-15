import Domain
import Foundation
import SwiftData
import Testing

@testable import Persistence

// Each test makes a fresh in-memory database, so tests never affect each other.

@Test("Added entry is pending and shows up in today's list")
func addEntry() async throws {
    let repo = SwiftDataEntryRepository(modelContainer: try PersistenceContainer.make(inMemory: true))
    try await repo.add(.make(drink: SeedCatalog.redBull, volumeMl: 250, consumedAt: .now))

    let today = try await repo.entries(onDayOf: .now)
    #expect(today.count == 1)
    #expect(today.first?.isSynced == false)
}

@Test("Deleting a synced entry hides it but keeps a pendingDelete row for sync")
func softDelete() async throws {
    let container = try PersistenceContainer.make(inMemory: true)
    let entry = Entry.make(drink: SeedCatalog.redBull, volumeMl: 250, consumedAt: .now)

    // Pretend the entry came from the server.
    let context = ModelContext(container)
    context.insert(EntryModel(entry, syncState: .synced))
    try context.save()

    let repo = SwiftDataEntryRepository(modelContainer: container)
    try await repo.delete(id: entry.id)

    #expect(try await repo.entries(onDayOf: .now).isEmpty)
    let rows = try ModelContext(container).fetch(FetchDescriptor<EntryModel>())
    #expect(rows.first?.syncState == .pendingDelete)
}

@Test("Seed fills the catalog once")
func seed() async throws {
    let container = try PersistenceContainer.make(inMemory: true)
    try PersistenceContainer.seedIfNeeded(container)
    try PersistenceContainer.seedIfNeeded(container)

    let drinks = try await SwiftDataDrinkRepository(modelContainer: container).all()
    #expect(drinks.count == SeedCatalog.all.count)
}

@Test("Search ignores case")
func search() async throws {
    let container = try PersistenceContainer.make(inMemory: true)
    try PersistenceContainer.seedIfNeeded(container)
    let found = try await SwiftDataDrinkRepository(modelContainer: container).search("red")
    #expect(found.allSatisfy { $0.brand == "Red Bull" })
    #expect(!found.isEmpty)
}
