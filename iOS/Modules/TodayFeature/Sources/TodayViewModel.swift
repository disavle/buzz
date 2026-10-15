import DesignSystem
import Domain
import Foundation
import Observation

/// "Today" screen logic. Architecture: MVVM on `@Observable` (docs/client/architecture.md).
///
/// The view model owns screen state and actions. The view only draws.
/// Navigation leaves the screen through `Output` closures: the screen says
/// "the user wants to add a can", and the coordinator decides what to show.
@MainActor
@Observable
public final class TodayViewModel {
    /// Events that leave the screen. The coordinator fills them in.
    public struct Output {
        public var addTapped: () -> Void
        public init(addTapped: @escaping () -> Void) {
            self.addTapped = addTapped
        }
    }

    public private(set) var limitMg = defaultDailyLimitMg
    /// Bound to the snack overlay. Set after a new can is added.
    public var snack: Snack?

    @ObservationIgnored private let store: EntryStore
    @ObservationIgnored private let settings: any SettingsRepository
    @ObservationIgnored private let sync: any SyncService
    @ObservationIgnored private let output: Output
    @ObservationIgnored private var lastAddedId: UUID?

    public init(store: EntryStore, settings: any SettingsRepository, sync: any SyncService, output: Output) {
        self.store = store
        self.settings = settings
        self.sync = sync
        self.output = output
    }

    // MARK: - State for the view
    //
    // These are computed from the store. Observation tracks `store.today` through them,
    // so when another screen adds an entry, this screen redraws by itself.

    var entries: [Entry] { store.today }
    var caffeineMg: Double { store.caffeineMg }
    var sugarG: Double { store.sugarG }
    var leftMg: Double { max(Double(limitMg) - caffeineMg, 0) }
    var isOverLimit: Bool { caffeineMg > Double(limitMg) }

    // MARK: - Actions

    func onAppear() async {
        limitMg = (try? await settings.dailyLimitMg()) ?? defaultDailyLimitMg
        try? await store.loadToday()
    }

    /// Pull to refresh: send pending changes first, then fetch new data.
    /// Errors are not shown: the data is on screen anyway and the icons stay.
    func refresh() async {
        await sync.syncNow()
        try? await store.loadToday()
    }

    func addTapped() {
        output.addTapped()
    }

    func delete(_ entry: Entry) async {
        try? await store.delete(id: entry.id)
    }

    /// The coordinator calls this after the "Add" sheet saved a can.
    public func showAdded(_ entry: Entry) async {
        try? await store.loadToday()
        lastAddedId = entry.id
        let total = BuzzFormat.caffeine(caffeineMg)
        let limit = BuzzFormat.caffeine(Double(limitMg))
        let over = BuzzFormat.caffeine(caffeineMg - Double(limitMg))
        snack = Snack(
            title: String(localized: "today.snack.added \(entry.displayName)", bundle: .module),
            subtitle: isOverLimit
                ? String(localized: "today.snack.over \(over)", bundle: .module)
                : String(localized: "today.snack.progress \(BuzzFormat.caffeine(entry.caffeineMg)) \(total) \(limit)", bundle: .module),
            isWarning: isOverLimit
        )
    }

    /// "Undo" on the snack removes the can that was just added.
    func undoLastAdd() async {
        guard let id = lastAddedId else { return }
        lastAddedId = nil
        try? await store.delete(id: id)
    }
}
