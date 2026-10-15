import UIKit

/// The classic UIKit entry point. We keep the UIKit life cycle on purpose:
/// navigation is done by UIKit coordinators, screens are SwiftUI.
/// (A pure SwiftUI app would use `@main struct BuzzApp: App` instead.)
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // The scene delegate class is set in Info.plist (see iOS/Project.swift).
        UISceneConfiguration(name: "Default", sessionRole: connectingSceneSession.role)
    }
}
