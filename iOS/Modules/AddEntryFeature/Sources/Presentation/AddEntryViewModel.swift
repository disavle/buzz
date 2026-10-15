import Domain
import Foundation
import Observation

/// Thin view model: form state + turning use case results into UI state.
/// All rules (validation, totals) live in the use cases.
@MainActor
@Observable
final class AddEntryViewModel {
    /// Volume presets from the design. `nil` = "Custom".
    enum VolumePreset: Hashable, CaseIterable {
        case ml250, ml330, ml500, custom
        var ml: Int? {
            switch self {
            case .ml250: 250
            case .ml330: 330
            case .ml500: 500
            case .custom: nil
            }
        }
    }

    var recent: [Drink] = []
    var results: [Drink] = []
    var query = ""
    var selected: Drink?
    var preset: VolumePreset = .ml500
    var customVolumeMl = 500
    var consumedAt = Date.now
    /// `TextField(value:format:.currency)` writes a number here, no manual parsing needed.
    var price: Decimal?
    var error: AddEntryError?
    private(set) var todayTotalMg: Double = 0
    private(set) var limitMg = defaultDailyLimitMg
    private(set) var isSaving = false

    @ObservationIgnored private let addEntry: any AddEntryUseCase
    @ObservationIgnored private let getRecent: any GetRecentDrinksUseCase
    @ObservationIgnored private let search: any SearchDrinksUseCase
    @ObservationIgnored private let todayTotal: any TodayTotalUseCase
    @ObservationIgnored private let calculator: NutritionCalculator
    @ObservationIgnored private let output: AddEntryOutput

    init(
        addEntry: any AddEntryUseCase,
        getRecent: any GetRecentDrinksUseCase,
        search: any SearchDrinksUseCase,
        todayTotal: any TodayTotalUseCase,
        calculator: NutritionCalculator,
        output: AddEntryOutput
    ) {
        self.addEntry = addEntry
        self.getRecent = getRecent
        self.search = search
        self.todayTotal = todayTotal
        self.calculator = calculator
        self.output = output
    }

    // MARK: - Derived state

    var volumeMl: Int { preset.ml ?? customVolumeMl }
    var previewMg: Double { selected.map { calculator.nutrition(of: $0, volumeMl: volumeMl).caffeineMg } ?? 0 }
    var projectedTotalMg: Double { todayTotalMg + previewMg }
    var willExceedLimit: Bool { selected != nil && projectedTotalMg > Double(limitMg) }
    var canSave: Bool { selected != nil && !isSaving }

    // MARK: - Actions

    func onAppear() async {
        recent = (try? await getRecent.execute(limit: 5)) ?? []
        if let total = try? await todayTotal.execute(on: consumedAt) {
            todayTotalMg = total.totalMg
            limitMg = total.limitMg
        }
        await queryChanged()
        // Preselect the last drink: most people drink the same thing.
        if selected == nil, let first = recent.first { select(first) }
    }

    func queryChanged() async {
        results = (try? await search.execute(query)) ?? []
    }

    func select(_ drink: Drink) {
        selected = drink
        // Pick the preset that matches the standard can, or "Custom".
        preset = VolumePreset.allCases.first { $0.ml == drink.volumeMl } ?? .custom
        customVolumeMl = drink.volumeMl
    }

    func clearSelection() {
        selected = nil
    }

    func cancelTapped() {
        output.cancelled()
    }

    func saveTapped() async {
        guard let selected else { return }
        isSaving = true
        defer { isSaving = false }
        do {
            let result = try await addEntry.execute(
                drink: selected,
                volumeMl: volumeMl,
                consumedAt: consumedAt,
                price: price
            )
            output.finished(result.entry)
        } catch {
            // Typed throws: `error` is already `AddEntryError`, no casting needed.
            self.error = error
        }
    }
}
