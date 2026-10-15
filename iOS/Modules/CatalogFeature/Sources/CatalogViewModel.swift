import Domain
import Foundation
import Observation

/// "Catalog" screen logic (MVVM).
@MainActor
@Observable
public final class CatalogViewModel {
    public struct Output {
        public var drinkTapped: (Drink) -> Void
        public var addCustomTapped: () -> Void
        public init(drinkTapped: @escaping (Drink) -> Void, addCustomTapped: @escaping () -> Void) {
            self.drinkTapped = drinkTapped
            self.addCustomTapped = addCustomTapped
        }
    }

    public enum Filter: Hashable, CaseIterable { case all, mine }

    var query = ""
    var filter: Filter = .all
    private(set) var drinks: [Drink] = []

    @ObservationIgnored private let repository: any DrinkRepository
    @ObservationIgnored private let output: Output

    public init(repository: any DrinkRepository, output: Output) {
        self.repository = repository
        self.output = output
    }

    /// What the grid shows: search results, then the "All / Mine" filter.
    var visible: [Drink] {
        switch filter {
        case .all: drinks
        case .mine: drinks.filter(\.isCustom)
        }
    }

    /// Public, so the coordinator can reload after a custom drink was added.
    public func load() async {
        drinks = (try? await repository.search(query)) ?? []
    }

    func drinkTapped(_ drink: Drink) { output.drinkTapped(drink) }
    func addCustomTapped() { output.addCustomTapped() }
}
