import Fluent
import Foundation

/// The starting shared catalog. Values are approximate, check them against real labels.
struct SeedDrinks: AsyncMigration {
    func prepare(on database: any Database) async throws {
        // Fixed ids, the same as in the iOS app (iOS/Modules/Domain/Sources/SeedCatalog.swift)
        // and in Mocks/catalog.json. An entry created offline points to the same drink here.
        func id(_ n: Int) -> UUID { UUID(uuidString: String(format: "00000000-0000-0000-0000-%012ld", n))! }
        let drinks = [
            Drink(
                id: id(1),
                brand: "Red Bull",
                name: "Energy Drink",
                volumeMl: 250,
                caffeinePer100ml: 32,
                sugarPer100ml: 11
            ),
            Drink(
                id: id(2),
                brand: "Red Bull",
                name: "Sugarfree",
                volumeMl: 250,
                caffeinePer100ml: 32,
                sugarPer100ml: 0
            ),
            Drink(id: id(3), brand: "Monster", name: "Energy", volumeMl: 500, caffeinePer100ml: 32, sugarPer100ml: 11),
            Drink(
                id: id(4),
                brand: "Monster",
                name: "Ultra White",
                volumeMl: 500,
                caffeinePer100ml: 30,
                sugarPer100ml: 0
            ),
            Drink(id: id(5), brand: "Burn", name: "Original", volumeMl: 449, caffeinePer100ml: 32, sugarPer100ml: 13),
            Drink(id: id(6), brand: "Adrenaline", name: "Rush", volumeMl: 449, caffeinePer100ml: 30, sugarPer100ml: 12),
            Drink(id: id(7), brand: "Flash Up", name: "Energy", volumeMl: 450, caffeinePer100ml: 30, sugarPer100ml: 11),
            Drink(id: id(8), brand: "Tornado", name: "Energy", volumeMl: 450, caffeinePer100ml: 30, sugarPer100ml: 12),
        ]
        try await drinks.create(on: database)
    }

    func revert(on database: any Database) async throws {
        try await Drink.query(on: database).filter(\.$owner.$id == nil).delete()
    }
}
