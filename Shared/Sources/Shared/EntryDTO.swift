import Foundation

/// One can that the user drank.
public struct EntryDTO: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var drinkId: UUID
    public var consumedAt: Date
    public var volumeMl: Int
    public var price: Decimal?
    /// Calculated by the server on creation and never changed after.
    public var caffeineMg: Double
    public var sugarG: Double
    public var updatedAt: Date?
    /// Not nil when the entry is deleted. Comes only from /sync.
    public var deletedAt: Date?

    public init(
        id: UUID, drinkId: UUID, consumedAt: Date, volumeMl: Int, price: Decimal?,
        caffeineMg: Double, sugarG: Double, updatedAt: Date?, deletedAt: Date?
    ) {
        self.id = id
        self.drinkId = drinkId
        self.consumedAt = consumedAt
        self.volumeMl = volumeMl
        self.price = price
        self.caffeineMg = caffeineMg
        self.sugarG = sugarG
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}

/// Body of POST /entries. The client generates `id`, so an entry can be
/// created offline and safely sent again.
public struct CreateEntryDTO: Codable, Sendable, Hashable {
    public var id: UUID
    public var drinkId: UUID
    public var consumedAt: Date
    /// nil means the standard can volume.
    public var volumeMl: Int?
    public var price: Decimal?

    public init(id: UUID = UUID(), drinkId: UUID, consumedAt: Date = .now, volumeMl: Int? = nil, price: Decimal? = nil) {
        self.id = id
        self.drinkId = drinkId
        self.consumedAt = consumedAt
        self.volumeMl = volumeMl
        self.price = price
    }
}

/// Response of GET /sync?since=. The next request uses since = serverTime.
public struct SyncDTO: Codable, Sendable, Hashable {
    public var drinks: [DrinkDTO]
    public var entries: [EntryDTO]
    public var serverTime: Date

    public init(drinks: [DrinkDTO], entries: [EntryDTO], serverTime: Date) {
        self.drinks = drinks
        self.entries = entries
        self.serverTime = serverTime
    }
}
