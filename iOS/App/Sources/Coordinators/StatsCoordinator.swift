import StatsFeature
import UIKit

/// Experiment idea (docs/client/architecture.md, section 7): make this tab a pure SwiftUI
/// `NavigationStack(path:)` inside one hosting controller and compare it with UIKit navigation.
@MainActor
final class StatsCoordinator: Coordinator {
    private let navigation = UINavigationController()
    private let deps: AppDependencies

    var rootViewController: UIViewController { navigation }

    init(deps: AppDependencies) {
        self.deps = deps
        navigation.tabBarItem = UITabBarItem(
            title: String(localized: "tab.stats"),
            image: UIImage(systemName: "chart.bar.xaxis"),
            tag: 2
        )
        navigation.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let model = StatsViewModel(entries: deps.entries, settings: deps.settings, sync: deps.sync)
        navigation.setViewControllers([deps.host(StatsView(model: model))], animated: false)
    }
}
