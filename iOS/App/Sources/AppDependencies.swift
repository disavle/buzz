import DesignSystem
import Domain
import Foundation
import Networking
import Persistence
import SwiftData
import SwiftUI
import Sync

/// The "composition root": the one place where real implementations are created
/// and connected. No singletons anywhere else: everything gets its dependencies in `init`.
@MainActor
final class AppDependencies {
    let container: ModelContainer
    let entries: any EntryRepository
    let drinks: any DrinkRepository
    let settings: any SettingsRepository
    let entryStore: EntryStore
    let api: any APIClient
    let tokens: any TokenStore
    let auth: any AuthService
    let syncEngine: SyncEngine
    var sync: any SyncService { syncEngine }
    private let network = NetworkMonitor()
    private let changes = Broadcaster<Void>()

    init(environment: [String: String] = ProcessInfo.processInfo.environment) throws {
        // UI tests and screenshots can start with a clean in-memory database.
        let inMemory = environment["BUZZ_IN_MEMORY"] == "1"
        container = try PersistenceContainer.make(inMemory: inMemory)
        try PersistenceContainer.seedIfNeeded(container)

        // One broadcaster for "entries changed": the repository yields on local changes,
        // the sync store yields on server changes. Screens and the sync engine listen to it.
        entries = SwiftDataEntryRepository(modelContainer: container, broadcaster: changes)
        drinks = SwiftDataDrinkRepository(modelContainer: container)
        settings = UserDefaultsSettingsRepository()
        entryStore = EntryStore(repository: entries)

        // Network: the real Vapor server, or a fake one with BUZZ_MOCK_API=1
        // (Xcode: Edit Scheme > Run > Arguments > Environment Variables).
        tokens = KeychainTokenStore()
        if environment["BUZZ_MOCK_API"] == "1" {
            api = MockAPIClient()
        } else {
            let baseURL = URL(string: environment["BUZZ_API_URL"] ?? "http://localhost:8080")!
            api = URLSessionAPIClient(baseURL: baseURL, tokens: tokens)
        }
        auth = RemoteAuthService(api: api, tokens: tokens)

        syncEngine = SyncEngine(
            store: SyncStore(modelContainer: container, changes: changes),
            api: api,
            tokens: tokens
        )
    }

    func startBackgroundWork() {
        entryStore.startListening()
        let changes = changes.stream()
        let network = network
        Task {
            await syncEngine.start(changes: changes, network: network)
            await syncEngine.syncNow()
        }
    }

    /// Wraps a SwiftUI screen into a `UIHostingController`.
    ///
    /// Every hosting controller is a separate SwiftUI root, so environment values
    /// do NOT flow from one to another. Everything shared by all screens is added here, once.
    func host<Content: View>(_ view: Content, title: LocalizedStringResource? = nil) -> UIHostingController<some View> {
        let controller = UIHostingController(rootView: view.buzzTheme())
        if let title { controller.title = String(localized: title) }
        return controller
    }
}
