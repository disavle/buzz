import Domain
import Foundation
import SwiftData

/// SwiftData version of `Drink`.
///
/// `@Model` turns a class into a persistent model (like an NSManagedObject subclass
/// in Core Data, but without the .xcdatamodeld file). Every stored property becomes a column.
@Model
public final class DrinkModel {
    /// `.unique`: inserting a model with the same id updates the old one instead of adding a copy.
    @Attribute(.unique) public var id: UUID
    public var brand: String
    public var name: String
    public var volumeMl: Int
    public var caffeinePer100ml: Double
    public var sugarPer100ml: Double
    public var imageURL: URL?
    public var isCustom: Bool
    /// Only custom drinks are sent to the server. The shared catalog is only downloaded.
    public var syncStateRaw: String = SyncState.synced.rawValue
    public var updatedAt: Date = Date.now

    public init(_ drink: Drink, syncState: SyncState) {
        id = drink.id
        brand = drink.brand
        name = drink.name
        volumeMl = drink.volumeMl
        caffeinePer100ml = drink.caffeinePer100ml
        sugarPer100ml = drink.sugarPer100ml
        imageURL = drink.imageURL
        isCustom = drink.isCustom
        syncStateRaw = syncState.rawValue
    }

    public var syncState: SyncState {
        get { SyncState(rawValue: syncStateRaw) ?? .pending }
        set { syncStateRaw = newValue.rawValue }
    }

    /// Convert to the plain Domain struct. Features never see `DrinkModel`.
    public var asDomain: Drink {
        Drink(
            id: id, brand: brand, name: name, volumeMl: volumeMl,
            caffeinePer100ml: caffeinePer100ml, sugarPer100ml: sugarPer100ml,
            imageURL: imageURL, isCustom: isCustom
        )
    }

    public func update(from drink: Drink) {
        brand = drink.brand
        name = drink.name
        volumeMl = drink.volumeMl
        caffeinePer100ml = drink.caffeinePer100ml
        sugarPer100ml = drink.sugarPer100ml
        imageURL = drink.imageURL
        isCustom = drink.isCustom
    }
}
