import DesignSystem
import Domain
import UIKit

/// Root coordinator: a tab bar with four tabs, each with its own coordinator
/// and its own `UINavigationController` (independent stacks, like in any UIKit app).
@MainActor
final class AppCoordinator {
    private let window: UIWindow
    private let deps: AppDependencies
    private let tabBar = UITabBarController()

    private lazy var today = TodayCoordinator(deps: deps)
    private lazy var catalog = CatalogCoordinator(
        deps: deps,
        drinkNow: { [weak self] drink in
            self?.showAddEntry(preselected: drink)
        }
    )
    private lazy var stats = StatsCoordinator(deps: deps)
    private lazy var settings = SettingsCoordinator(
        deps: deps,
        accentChanged: { [weak self] accent in
            self?.window.tintColor = UIColor(accent.color)
        }
    )

    init(window: UIWindow, deps: AppDependencies) {
        self.window = window
        self.deps = deps
    }

    func start() {
        let children: [Coordinator] = [today, catalog, stats, settings]
        children.forEach { $0.start() }
        tabBar.viewControllers = children.map(\.rootViewController)
        window.rootViewController = tabBar
    }

    func handle(_ url: URL) {
        switch DeepLink(url: url) {
        case .add:
            showAddEntry(preselected: nil)
        case .stats:
            tabBar.selectedIndex = 2
        case nil:
            break
        }
    }

    /// "Drink now" from the catalog: switch to Today and open the sheet there,
    /// so the snack appears on the Today screen after saving.
    private func showAddEntry(preselected: Drink?) {
        tabBar.selectedIndex = 0
        today.showAddEntry(preselected: preselected)
    }
}
