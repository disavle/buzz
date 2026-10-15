import Domain
import Foundation
import Networking
import Persistence
import Shared
import SwiftData

/// Database access that only the sync engine needs: the outbox, marking rows as synced,
/// and applying changes from the server.
///
/// Same `ModelActor` pattern as in Persistence: its own context, off the main thread.
public actor SyncStore: ModelActor {
    public nonisolated let modelContainer: ModelContainer
    public nonisolated let modelExecutor: any ModelExecutor
    private nonisolated let changes: Broadcaster<Void>
    private let defaults: UserDefaults
    private static let lastSyncKey = "lastSyncedAt"

    /// - Parameter changes: the same broadcaster the entry repository uses,
    ///   so screens reload when data comes from the server.
    public init(modelContainer: ModelContainer, changes: Broadcaster<Void>, defaults: UserDefaults = .standard) {
        self.modelContainer = modelContainer
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: ModelContext(modelContainer))
        self.changes = changes
        self.defaults = defaults
    }

    // MARK: - Last sync time

    /// We store the *server* time from the last /sync answer, not the phone clock.
    /// If the phone clock is behind, using it would skip some server changes forever.
    public var lastSyncedAt: Date? { defaults.object(forKey: Self.lastSyncKey) as? Date }

    public func setLastSyncedAt(_ date: Date?) {
        defaults.set(date, forKey: Self.lastSyncKey)
    }

    // MARK: - Outbox

    /// A snapshot of one pending entry. `updatedAt` lets us detect edits made while sending.
    public struct PendingEntry: Sendable {
        public let entry: Entry
        public let updatedAt: Date
    }

    public func pendingEntries() throws -> [PendingEntry] {
        let pending = SyncState.pending.rawValue
        let descriptor = FetchDescriptor<EntryModel>(predicate: #Predicate { $0.syncStateRaw == pending })
        return try modelContext.fetch(descriptor).map { PendingEntry(entry: $0.asDomain, updatedAt: $0.updatedAt) }
    }

    public func pendingDeletes() throws -> [UUID] {
        let pendingDelete = SyncState.pendingDelete.rawValue
        let descriptor = FetchDescriptor<EntryModel>(predicate: #Predicate { $0.syncStateRaw == pendingDelete })
        return try modelContext.fetch(descriptor).map(\.id)
    }

    public func pendingCustomDrinks() throws -> [Drink] {
        let pending = SyncState.pending.rawValue
        let descriptor = FetchDescriptor<DrinkModel>(predicate: #Predicate { $0.syncStateRaw == pending })
        return try modelContext.fetch(descriptor).map(\.asDomain)
    }

    public func pendingCount() throws -> Int {
        let synced = SyncState.synced.rawValue
        return try modelContext.fetchCount(FetchDescriptor<EntryModel>(predicate: #Predicate { $0.syncStateRaw != synced }))
    }

    /// Mark as synced only if nobody changed the entry while the request was in flight.
    /// Otherwise it stays `pending` and goes out in the next pass.
    public func markSynced(_ id: UUID, ifUpdatedAt updatedAt: Date) throws {
        guard let model = try entry(id), model.updatedAt == updatedAt else { return }
        model.syncState = .synced
        try modelContext.save()
        changes.yield()   // the "not synced" icon disappears
    }

    /// The server confirmed the delete, now we can remove the row for real.
    public func markSyncedDelete(_ id: UUID) throws {
        guard let model = try entry(id) else { return }
        modelContext.delete(model)
        try modelContext.save()
    }

    public func markDrinkSynced(_ id: UUID) throws {
        let descriptor = FetchDescriptor<DrinkModel>(predicate: #Predicate { $0.id == id })
        try modelContext.fetch(descriptor).first?.syncState = .synced
        try modelContext.save()
    }

    // MARK: - Apply server changes

    /// The main rule: never overwrite something that is still pending on this device.
    public func apply(_ delta: SyncDTO) throws {
        for remote in delta.drinks {
            let id = remote.id
            let descriptor = FetchDescriptor<DrinkModel>(predicate: #Predicate { $0.id == id })
            if let local = try modelContext.fetch(descriptor).first {
                if local.syncState == .synced { local.update(from: Drink(remote)) }
            } else {
                modelContext.insert(DrinkModel(Drink(remote), syncState: .synced))
            }
        }

        let drinks = try modelContext.fetch(FetchDescriptor<DrinkModel>()).map(\.asDomain)
        for remote in delta.entries {
            let remoteUpdatedAt = remote.updatedAt ?? delta.serverTime
            if let local = try entry(remote.id) {
                guard local.syncState == .synced else { continue }    // pending wins, see the rule above
                guard remoteUpdatedAt > local.updatedAt else { continue } // conflict: newer updatedAt wins
                if remote.deletedAt != nil {
                    modelContext.delete(local)                         // deleted on another device
                } else {
                    let drink = drinks.first { $0.id == remote.drinkId }
                    let updated = EntryModel(Entry(remote, drink: drink), syncState: .synced, updatedAt: remoteUpdatedAt)
                    modelContext.delete(local)
                    modelContext.insert(updated)
                }
            } else if remote.deletedAt == nil {
                let drink = drinks.first { $0.id == remote.drinkId }
                modelContext.insert(EntryModel(Entry(remote, drink: drink), syncState: .synced, updatedAt: remoteUpdatedAt))
            }
        }
        try modelContext.save()
        changes.yield()
    }

    private func entry(_ id: UUID) throws -> EntryModel? {
        var descriptor = FetchDescriptor<EntryModel>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
}
