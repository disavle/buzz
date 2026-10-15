import Foundation

// Simple in-memory repositories for SwiftUI previews and unit tests.
//
// They are actors: an actor protects its own state, so many tasks can call it
// at the same time without data races. Compare it with a class + a serial queue in UIKit days.
//
// In a big app these would live in a separate "DomainTesting" module,
// so production code cannot use them by mistake. Here we keep it simple.

public actor InMemoryEntryRepository: EntryRepository {
    private var storage: [UUID: Entry]
    private nonisolated let broadcaster = Broadcaster<Void>()

    public init(entries: [Entry] = []) {
        storage = Dictionary(uniqueKeysWithValues: entries.map { ($0.id, $0) })
    }

    public func entries(from: Date, to: Date) async throws -> [Entry] {
        storage.values
            .filter { $0.consumedAt >= from && $0.consumedAt < to }
            .sorted { $0.consumedAt > $1.consumedAt }
    }

    public func add(_ entry: Entry) async throws {
        storage[entry.id] = entry
        broadcaster.yield()
    }

    public func delete(id: UUID) async throws {
        storage[id] = nil
        broadcaster.yield()
    }

    public func recentDrinkIds(limit: Int) async throws -> [UUID] {
        var result: [UUID] = []
        for entry in storage.values.sorted(by: { $0.consumedAt > $1.consumedAt })
        where !result.contains(entry.drinkId) {
            result.append(entry.drinkId)
            if result.count == limit { break }
        }
        return result
    }

    public nonisolated func changes() -> AsyncStream<Void> { broadcaster.stream() }
}

public actor InMemoryDrinkRepository: DrinkRepository {
    private var drinks: [Drink]

    public init(drinks: [Drink] = SeedCatalog.all) {
        self.drinks = drinks
    }

    public func all() async throws -> [Drink] { drinks }

    public func search(_ query: String) async throws -> [Drink] {
        let query = query.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return drinks }
        // localizedStandardContains: ignores case and diacritics, like the Finder search.
        return drinks.filter { $0.displayName.localizedStandardContains(query) }
    }

    public func drinks(ids: [UUID]) async throws -> [Drink] {
        ids.compactMap { id in drinks.first { $0.id == id } }
    }

    public func add(_ drink: Drink) async throws { drinks.append(drink) }
}

public actor InMemorySettingsRepository: SettingsRepository {
    private var limit: Int

    public init(limit: Int = defaultDailyLimitMg) { self.limit = limit }

    public func dailyLimitMg() async throws -> Int { limit }
    public func setDailyLimitMg(_ value: Int) async throws { limit = value }
}
