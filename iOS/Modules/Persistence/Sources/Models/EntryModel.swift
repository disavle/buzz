import Domain
import Foundation
import SwiftData

/// SwiftData version of `Entry`, plus the fields that only sync needs.
@Model
public final class EntryModel {
    /// Generated on the device, so a POST with the same id is idempotent.
    @Attribute(.unique) public var id: UUID
    /// We keep the id, not a relationship to `DrinkModel`: the API also works with ids,
    /// and an entry must survive even if its custom drink was not downloaded yet.
    public var drinkId: UUID
    public var brand: String
    public var drinkName: String
    public var consumedAt: Date
    public var volumeMl: Int
    public var price: Decimal?
    public var caffeineMg: Double
    public var sugarG: Double

    // MARK: Sync fields (see docs/client/sync.md)

    /// Last change time. On conflict the newer `updatedAt` wins.
    public var updatedAt: Date
    /// Soft delete: we hide the entry at once but keep the row until the server confirms.
    public var deletedAt: Date?
    public var syncStateRaw: String = SyncState.pending.rawValue

    public init(_ entry: Entry, syncState: SyncState, updatedAt: Date = .now) {
        id = entry.id
        drinkId = entry.drinkId
        brand = entry.brand
        drinkName = entry.drinkName
        consumedAt = entry.consumedAt
        volumeMl = entry.volumeMl
        price = entry.price
        caffeineMg = entry.caffeineMg
        sugarG = entry.sugarG
        self.updatedAt = updatedAt
        syncStateRaw = syncState.rawValue
    }

    public var syncState: SyncState {
        get { SyncState(rawValue: syncStateRaw) ?? .pending }
        set { syncStateRaw = newValue.rawValue }
    }

    public var asDomain: Entry {
        Entry(
            id: id,
            drinkId: drinkId,
            brand: brand,
            drinkName: drinkName,
            consumedAt: consumedAt,
            volumeMl: volumeMl,
            price: price,
            caffeineMg: caffeineMg,
            sugarG: sugarG,
            isSynced: syncState == .synced
        )
    }
}
