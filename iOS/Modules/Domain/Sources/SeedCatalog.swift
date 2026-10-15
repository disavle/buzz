import Foundation

/// The starting catalog. It is loaded into SwiftData on the first launch
/// and is also used by previews and tests.
///
/// The ids are fixed (not `UUID()`), and they are the same as in
/// `Backend/Sources/App/Migrations/SeedDrinks.swift` and `Mocks/catalog.json`.
/// So an entry created offline points to the same drink on the server.
///
/// Values are approximate. Check them against real labels.
public enum SeedCatalog {
    public static let redBull = Drink(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        brand: "Red Bull", name: "Energy Drink", volumeMl: 250, caffeinePer100ml: 32, sugarPer100ml: 11
    )
    public static let redBullSugarfree = Drink(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        brand: "Red Bull", name: "Sugarfree", volumeMl: 250, caffeinePer100ml: 32, sugarPer100ml: 0
    )
    public static let monster = Drink(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
        brand: "Monster", name: "Energy", volumeMl: 500, caffeinePer100ml: 32, sugarPer100ml: 11
    )
    public static let monsterUltra = Drink(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
        brand: "Monster", name: "Ultra White", volumeMl: 500, caffeinePer100ml: 30, sugarPer100ml: 0
    )
    public static let burn = Drink(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
        brand: "Burn", name: "Original", volumeMl: 449, caffeinePer100ml: 32, sugarPer100ml: 13
    )
    public static let adrenaline = Drink(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
        brand: "Adrenaline", name: "Rush", volumeMl: 449, caffeinePer100ml: 30, sugarPer100ml: 12
    )
    public static let flashUp = Drink(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
        brand: "Flash Up", name: "Energy", volumeMl: 450, caffeinePer100ml: 30, sugarPer100ml: 11
    )
    public static let tornado = Drink(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
        brand: "Tornado", name: "Energy", volumeMl: 450, caffeinePer100ml: 30, sugarPer100ml: 12
    )

    public static let all: [Drink] = [
        redBull, redBullSugarfree, monster, monsterUltra, burn, adrenaline, flashUp, tornado,
    ]
}
