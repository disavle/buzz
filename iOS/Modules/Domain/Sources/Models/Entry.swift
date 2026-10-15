import Foundation

/// One can that the user drank.
public struct Entry: Identifiable, Hashable, Sendable {
    /// Created on the device. Because the client makes the id,
    /// sending the same entry twice to the server does not create a duplicate.
    public let id: UUID
    public var drinkId: UUID
    /// We copy brand and name into the entry, so the list can show them
    /// without loading the drink (and they stay the same if the drink changes).
    public var brand: String
    public var drinkName: String
    public var consumedAt: Date
    public var volumeMl: Int
    /// Optional price in the device currency.
    public var price: Decimal?
    /// Calculated once when the entry is created and then stored.
    /// So the history does not change when someone edits the catalog.
    public var caffeineMg: Double
    public var sugarG: Double
    /// `false` while the entry is only on this device (shows a small cloud icon in the UI).
    public var isSynced: Bool

    public init(
        id: UUID = UUID(),
        drinkId: UUID,
        brand: String,
        drinkName: String,
        consumedAt: Date,
        volumeMl: Int,
        price: Decimal? = nil,
        caffeineMg: Double,
        sugarG: Double,
        isSynced: Bool = false
    ) {
        self.id = id
        self.drinkId = drinkId
        self.brand = brand
        self.drinkName = drinkName
        self.consumedAt = consumedAt
        self.volumeMl = volumeMl
        self.price = price
        self.caffeineMg = caffeineMg
        self.sugarG = sugarG
        self.isSynced = isSynced
    }

    public var displayName: String { "\(brand) \(drinkName)" }
}

public extension Entry {
    /// Creates a new entry for a drink. Caffeine and sugar are calculated here.
    static func make(
        drink: Drink,
        volumeMl: Int,
        consumedAt: Date,
        price: Decimal? = nil,
        id: UUID = UUID()
    ) -> Entry {
        let factor = Double(volumeMl) / 100
        return Entry(
            id: id,
            drinkId: drink.id,
            brand: drink.brand,
            drinkName: drink.name,
            consumedAt: consumedAt,
            volumeMl: volumeMl,
            price: price,
            caffeineMg: drink.caffeinePer100ml * factor,
            sugarG: drink.sugarPer100ml * factor
        )
    }
}
