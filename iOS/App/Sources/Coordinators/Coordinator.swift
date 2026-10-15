import UIKit

/// A coordinator owns navigation for one part of the app.
/// Screens never push or present anything themselves: they send events (Output),
/// and the coordinator decides what to show. This is the same pattern as in UIKit apps.
@MainActor
protocol Coordinator: AnyObject {
    var rootViewController: UIViewController { get }
    func start()
}

/// Parsed deep links. Kept separate from the coordinator so it is easy to unit test.
enum DeepLink: Equatable {
    /// buzz://add — open the "Add a can" sheet.
    case add
    /// buzz://stats — open the Stats tab.
    case stats

    init?(url: URL) {
        guard url.scheme == "buzz" else { return nil }
        switch url.host() {
        case "add": self = .add
        case "stats": self = .stats
        default: return nil
        }
    }
}
