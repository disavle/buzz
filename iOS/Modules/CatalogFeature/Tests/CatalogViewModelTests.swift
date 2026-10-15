import Domain
import Foundation
import Testing
@testable import CatalogFeature

@MainActor
private func makeModel(drinks: [Drink] = SeedCatalog.all) -> CatalogViewModel {
    CatalogViewModel(repository: InMemoryDrinkRepository(drinks: drinks), output: .init(drinkTapped: { _ in }, addCustomTapped: {}))
}

@MainActor
@Test("Search filters by brand")
func searchByBrand() async {
    let model = makeModel()
    model.query = "monster"
    await model.load()
    #expect(!model.visible.isEmpty)
    #expect(model.visible.allSatisfy { $0.brand == "Monster" })
}

@MainActor
@Test("'Mine' shows only custom drinks")
func mineFilter() async {
    let custom = Drink(brand: "Home", name: "Cold brew", volumeMl: 330, caffeinePer100ml: 45, sugarPer100ml: 0, isCustom: true)
    let model = makeModel(drinks: SeedCatalog.all + [custom])
    await model.load()
    model.filter = .mine
    #expect(model.visible == [custom])
}
