import Domain
import Foundation
import Observation

/// "Stats" screen logic (MVVM). Loads entries for the period and asks the calculator for chart data.
@MainActor
@Observable
public final class StatsViewModel {
    var period: StatsPeriod = .week
    private(set) var snapshot = StatsSnapshot()
    private(set) var limitMg = defaultDailyLimitMg

    @ObservationIgnored private let entries: any EntryRepository
    @ObservationIgnored private let settings: any SettingsRepository
    @ObservationIgnored private let sync: any SyncService
    @ObservationIgnored private let calculator: StatsCalculator

    public init(
        entries: any EntryRepository,
        settings: any SettingsRepository,
        sync: any SyncService,
        calculator: StatsCalculator = .init()
    ) {
        self.entries = entries
        self.settings = settings
        self.sync = sync
        self.calculator = calculator
    }

    func load(now: Date = .now) async {
        limitMg = (try? await settings.dailyLimitMg()) ?? defaultDailyLimitMg
        let calendar = Calendar.current
        let end = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) ?? now
        let start = calendar.date(byAdding: .day, value: -period.days, to: end) ?? now
        let list = (try? await entries.entries(from: start, to: end)) ?? []
        snapshot = calculator.snapshot(entries: list, period: period, now: now)
    }

    func refresh() async {
        await sync.syncNow()
        await load()
    }

    /// Reload every time entries change somewhere in the app.
    func observeChanges() async {
        for await _ in entries.changes() {
            await load()
        }
    }
}
