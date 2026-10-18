import Domain
import Foundation
import Testing

@testable import CatalogFeature

@MainActor
private func makeModel(drinks: [Drink] = SeedCatalog.all) -> CatalogViewModel {
    CatalogViewModel(
        repository: InMemoryDrinkRepository(drinks: drinks),
        output: .init(drinkTapped: { _ in }, addCustomTapped: {})
    )
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
    let custom = Drink(
        brand: "Home",
        name: "Cold brew",
        volumeMl: 330,
        caffeinePer100ml: 45,
        sugarPer100ml: 0,
        isCustom: true
    )
    let model = makeModel(drinks: SeedCatalog.all + [custom])
    await model.load()
    model.filter = .mine
    #expect(model.visible == [custom])
}

/// Wraps the in-memory repository and remembers every search query it was asked for.
/// An `actor`, so the test can read `queries` safely while the view model searches.
private actor SpyDrinkRepository: DrinkRepository {
    private let inner = InMemoryDrinkRepository()
    private(set) var queries: [String] = []

    func all() async throws -> [Drink] { try await inner.all() }
    func drinks(ids: [UUID]) async throws -> [Drink] { try await inner.drinks(ids: ids) }
    func add(_ drink: Drink) async throws { try await inner.add(drink) }
    func search(_ query: String) async throws -> [Drink] {
        queries.append(query)
        return try await inner.search(query)
    }
}

@MainActor
@Test("Fast typing gives one search (Combine debounce)")
func debounceTyping() async throws {
    let repository = SpyDrinkRepository()
    let model = CatalogViewModel(
        repository: repository,
        output: .init(drinkTapped: { _ in }, addCustomTapped: {}),
        debounce: .milliseconds(50)
    )

    // Three key presses with no pause between them, like fast typing.
    model.query = "m"
    model.query = "mo"
    model.query = "monster "

    // Wait longer than the debounce, so the pipeline sends its one value.
    try await Task.sleep(for: .milliseconds(500))

    // Only the last text was searched, and the spaces at the end were trimmed.
    #expect(await repository.queries == ["monster"])
    #expect(!model.visible.isEmpty)
    #expect(model.visible.allSatisfy { $0.brand == "Monster" })
}
