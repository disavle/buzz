import DesignSystem
import Domain
import SettingsFeature
import UIKit

@MainActor
final class SettingsCoordinator: Coordinator {
    private let navigation = UINavigationController()
    private let deps: AppDependencies
    private let accentChanged: (AccentChoice) -> Void

    var rootViewController: UIViewController { navigation }

    init(deps: AppDependencies, accentChanged: @escaping (AccentChoice) -> Void) {
        self.deps = deps
        self.accentChanged = accentChanged
        navigation.tabBarItem = UITabBarItem(
            title: String(localized: "tab.settings"),
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        navigation.navigationBar.prefersLargeTitles = true
    }

    func start() {
        navigation.setViewControllers([deps.host(SettingsModule.make(env: makeEnvironment()))], animated: false)
    }

    /// Builds the Redux environment from real services.
    /// Each closure captures only `Sendable` things (repositories, services), not the coordinator,
    /// except the navigation closures, which run on the main actor.
    private func makeEnvironment() -> SettingsEnvironment {
        let settings = deps.settings
        let auth = deps.auth
        let sync = deps.sync
        return SettingsEnvironment(
            load: {
                let limit = (try? await settings.dailyLimitMg()) ?? defaultDailyLimitMg
                return (limit, await auth.currentEmail(), await sync.pendingCount())
            },
            saveLimit: { try? await settings.setDailyLimitMg($0) },
            saveAccent: { [weak self] accent in
                // @AppStorage in BuzzTheme reads the same key, so every SwiftUI screen updates.
                UserDefaults.standard.set(accent.rawValue, forKey: AccentChoice.storageKey)
                self?.accentChanged(accent)
            },
            syncNow: { await sync.syncNow() },
            syncStatus: { sync.statusUpdates() },
            logout: { await auth.logout() },
            openLogin: { [weak self] in self?.showLogin() },
            openSystemSettings: {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        )
    }

    private func showLogin() {
        let view = LoginView(auth: deps.auth) { [weak self] loggedIn in
            guard let self else { return }
            navigation.dismiss(animated: true)
            if loggedIn {
                // Everything the guest saved offline is still `pending`: send it now.
                Task { await self.deps.sync.syncNow() }
                start()  // rebuild the screen to show the new account
            }
        }
        navigation.present(deps.host(view), animated: true)
    }
}
