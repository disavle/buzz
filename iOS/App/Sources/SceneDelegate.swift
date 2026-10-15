import DesignSystem
import UIKit

/// Creates the window, the dependencies and the root coordinator.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private var dependencies: AppDependencies?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let dependencies: AppDependencies
        do {
            dependencies = try AppDependencies()
        } catch {
            // The database could not open. In a real app: show an error screen and send a report.
            fatalError("Cannot create the database: \(error)")
        }

        let window = UIWindow(windowScene: windowScene)
        // UIKit parts (tab bar, nav bar buttons) use the window tint, SwiftUI uses `.buzzTheme()`.
        window.tintColor = UIColor(AccentChoice.current.color)

        let coordinator = AppCoordinator(window: window, deps: dependencies)
        coordinator.start()
        window.makeKeyAndVisible()

        self.window = window
        self.appCoordinator = coordinator
        self.dependencies = dependencies

        // The app was opened by a link like buzz://add.
        if let url = connectionOptions.urlContexts.first?.url {
            coordinator.handle(url)
        }

        // Sync trigger 1: app start.
        dependencies.startBackgroundWork()
    }

    /// Deep links while the app is already running.
    func scene(_ scene: UIScene, openURLContexts urlContexts: Set<UIOpenURLContext>) {
        guard let url = urlContexts.first?.url else { return }
        appCoordinator?.handle(url)
    }

    /// Sync trigger 2: the app comes back from the background.
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let dependencies else { return }
        Task { await dependencies.sync.syncNow() }
    }
}
