import CatalogFeature
import Domain
import UIKit

@MainActor
final class CatalogCoordinator: Coordinator {
    private let navigation = UINavigationController()
    private let deps: AppDependencies
    private let drinkNow: (Drink) -> Void
    private var catalogModel: CatalogViewModel?

    var rootViewController: UIViewController { navigation }

    /// - Parameter drinkNow: "Drink now" belongs to another tab, so the app coordinator handles it.
    init(deps: AppDependencies, drinkNow: @escaping (Drink) -> Void) {
        self.deps = deps
        self.drinkNow = drinkNow
        navigation.tabBarItem = UITabBarItem(
            title: String(localized: "tab.catalog"),
            image: UIImage(systemName: "square.grid.2x2"),
            selectedImage: UIImage(systemName: "square.grid.2x2.fill")
        )
        navigation.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let model = CatalogViewModel(
            repository: deps.drinks,
            output: .init(
                drinkTapped: { [weak self] in self?.showDetail($0) },
                addCustomTapped: { [weak self] in self?.showCustomForm() }
            )
        )
        catalogModel = model
        navigation.setViewControllers([deps.host(CatalogView(model: model))], animated: false)
    }

    private func showDetail(_ drink: Drink) {
        let view = DrinkDetailView(drink: drink) { [weak self] in self?.drinkNow(drink) }
        navigation.pushViewController(deps.host(view), animated: true)
    }

    private func showCustomForm() {
        let view = CustomDrinkForm(repository: deps.drinks) { [weak self] in
            self?.navigation.dismiss(animated: true)
            Task { await self?.catalogModel?.load() }  // show the new drink in the grid
        }
        navigation.present(deps.host(view), animated: true)
    }
}
