import AddEntryFeature
import Domain
import TodayFeature
import UIKit

@MainActor
final class TodayCoordinator: Coordinator {
    private let navigation = UINavigationController()
    private let deps: AppDependencies
    private var todayModel: TodayViewModel?

    var rootViewController: UIViewController { navigation }

    init(deps: AppDependencies) {
        self.deps = deps
        navigation.tabBarItem = UITabBarItem(
            title: String(localized: "tab.today"),
            image: UIImage(systemName: "bolt"),
            selectedImage: UIImage(systemName: "bolt.fill")
        )
        navigation.navigationBar.prefersLargeTitles = true
    }

    func start() {
        let model = TodayViewModel(
            store: deps.entryStore,
            settings: deps.settings,
            sync: deps.sync,
            output: .init(addTapped: { [weak self] in self?.showAddEntry(preselected: nil) })
        )
        todayModel = model
        navigation.setViewControllers([deps.host(TodayView(model: model))], animated: false)
    }

    func showAddEntry(preselected: Drink?) {
        // If a sheet is already open (for example from a deep link), close it first.
        navigation.dismiss(animated: false)

        let view = AddEntryModule.make(
            deps: AddEntryDependencies(entries: deps.entries, drinks: deps.drinks, settings: deps.settings),
            output: AddEntryOutput(
                finished: { [weak self] entry in
                    self?.navigation.dismiss(animated: true)
                    // Show "Monster added · +160 mg" on Today.
                    Task { await self?.todayModel?.showAdded(entry) }
                },
                cancelled: { [weak self] in self?.navigation.dismiss(animated: true) }
            ),
            preselected: preselected
        )
        let controller = deps.host(view)
        // A UIKit sheet. Try `[.medium(), .large()]` to allow a half-height sheet.
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        navigation.present(controller, animated: true)
    }
}
