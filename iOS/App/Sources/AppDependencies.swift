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
    /// "Data changed, reload the screens": local edits and data from the server.
    private let changes = Broadcaster<Void>()
    /// "The user changed something": only this starts an automatic sync.
    private let localEdits = Broadcaster<Void>()

    init(
        environment: [String: String] = ProcessInfo.processInfo.environment,
        infoPlist: [String: Any] = Bundle.main.infoDictionary ?? [:]
    ) throws {
        // UI tests and screenshots can start with a clean in-memory database.
        let inMemory = environment["BUZZ_IN_MEMORY"] == "1"
        container = try PersistenceContainer.make(inMemory: inMemory)
        try PersistenceContainer.seedIfNeeded(container)

        // Two signals: `changes` (repository and sync store, screens listen to it)
        // and `localEdits` (repository only, the sync engine listens to it).
        entries = SwiftDataEntryRepository(modelContainer: container, broadcaster: changes, localEdits: localEdits)
        drinks = SwiftDataDrinkRepository(modelContainer: container)
        settings = UserDefaultsSettingsRepository()
        entryStore = EntryStore(repository: entries)

        // Network: the real Vapor server, or a fake one with BUZZ_MOCK_API=1
        // (Xcode: Edit Scheme > Run > Arguments > Environment Variables).
        // Server address, first match wins:
        // 1. BUZZ_API_URL from the scheme: a quick override, only when run from Xcode;
        // 2. BuzzAPIURL from Info.plist: set at generate time from TUIST_API_URL (see Project.swift);
        // 3. localhost, for the simulator and `mise run backend:run`.
        tokens = KeychainTokenStore()
        if environment["BUZZ_MOCK_API"] == "1" {
            api = MockAPIClient()
        } else {
            let address =
                environment["BUZZ_API_URL"]
                ?? infoPlist["BuzzAPIURL"] as? String
                ?? "http://localhost:8080"
            let baseURL = URL(string: address)!
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
        // The engine listens to local edits only. If it listened to `changes`, its own pass
        // (which saves data and yields `changes`) would start the next pass every ~2 seconds.
        let edits = localEdits.stream()
        let network = network
        Task {
            await syncEngine.start(changes: edits, network: network)
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
