import Foundation

// Repositories are protocols. Features talk only to these protocols.
// The real implementations live in the Persistence module (SwiftData),
// and tests/previews use the in-memory fakes from `InMemoryRepositories.swift`.
//
// All methods are `async`: the real implementation is an actor,
// so every call may wait for it.

/// Entries the user drank.
public protocol EntryRepository: Sendable {
    /// Entries in `[from, to)`, newest first. Deleted entries are not returned.
    func entries(from: Date, to: Date) async throws -> [Entry]
    func add(_ entry: Entry) async throws
    /// Soft delete: the entry is hidden right away and removed from the server on the next sync.
    func delete(id: UUID) async throws
    /// Last `limit` different drink ids the user had, newest first. Used for "Recent" in Add.
    func recentDrinkIds(limit: Int) async throws -> [UUID]
    /// Emits a value every time entries change (add, delete, or sync from server).
    /// Every call returns a new stream, so many screens can listen at once.
    func changes() -> AsyncStream<Void>
}

/// The drink catalog: shared drinks plus the user's own.
public protocol DrinkRepository: Sendable {
    func all() async throws -> [Drink]
    /// Case-insensitive search by brand or name. Empty query returns everything.
    func search(_ query: String) async throws -> [Drink]
    func drinks(ids: [UUID]) async throws -> [Drink]
    func add(_ drink: Drink) async throws
}

/// Small user settings that live on the device.
public protocol SettingsRepository: Sendable {
    func dailyLimitMg() async throws -> Int
    func setDailyLimitMg(_ value: Int) async throws
}

public extension EntryRepository {
    /// All entries of one calendar day.
    func entries(onDayOf date: Date, calendar: Calendar = .current) async throws -> [Entry] {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start.addingTimeInterval(86_400)
        return try await entries(from: start, to: end)
    }
}

/// The default daily caffeine limit for healthy adults, in mg.
public let defaultDailyLimitMg = 400
