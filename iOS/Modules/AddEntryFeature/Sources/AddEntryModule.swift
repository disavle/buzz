import Domain
import SwiftUI

// The public "entry point" of the feature. All features look the same from outside:
// a factory that takes dependencies + Output and returns `some View`.
// The coordinator does not care which architecture is inside.

/// What the module needs from the app.
public struct AddEntryDependencies {
    public let entries: any EntryRepository
    public let drinks: any DrinkRepository
    public let settings: any SettingsRepository

    public init(entries: any EntryRepository, drinks: any DrinkRepository, settings: any SettingsRepository) {
        self.entries = entries
        self.drinks = drinks
        self.settings = settings
    }
}

/// Events that leave the module.
public struct AddEntryOutput {
    /// A can was saved. The coordinator closes the sheet and shows the snack on "Today".
    public var finished: (Entry) -> Void
    public var cancelled: () -> Void

    public init(finished: @escaping (Entry) -> Void, cancelled: @escaping () -> Void) {
        self.finished = finished
        self.cancelled = cancelled
    }
}

public enum AddEntryModule {
    /// The "composition root" of the module: creates use cases and wires them into the view model.
    @MainActor
    public static func make(deps: AddEntryDependencies, output: AddEntryOutput, preselected: Drink? = nil) -> some View {
        let calculator = NutritionCalculator()
        let model = AddEntryViewModel(
            addEntry: DefaultAddEntryUseCase(entries: deps.entries, settings: deps.settings, calculator: calculator),
            getRecent: DefaultGetRecentDrinksUseCase(entries: deps.entries, drinks: deps.drinks),
            search: DefaultSearchDrinksUseCase(drinks: deps.drinks),
            todayTotal: DefaultTodayTotalUseCase(entries: deps.entries, settings: deps.settings),
            calculator: calculator,
            output: output
        )
        if let preselected { model.select(preselected) }
        return AddEntryView(model: model)
    }
}
