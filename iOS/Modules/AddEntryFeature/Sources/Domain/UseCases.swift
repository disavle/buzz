import Domain
import Foundation

// A use case = one thing the user can do, as a protocol plus a default implementation.
// The view model knows only the protocols, so tests can replace any of them.

// MARK: - Add entry

public protocol AddEntryUseCase: Sendable {
    func execute(drink: Drink, volumeMl: Int, consumedAt: Date, price: Decimal?) async throws(AddEntryError)
        -> AddEntryResult
}

public struct DefaultAddEntryUseCase: AddEntryUseCase {
    let entries: any EntryRepository
    let settings: any SettingsRepository
    let calculator: NutritionCalculator
    /// Time is a dependency too: tests pass a fixed date and do not depend on the clock.
    let now: @Sendable () -> Date

    public init(
        entries: any EntryRepository,
        settings: any SettingsRepository,
        calculator: NutritionCalculator = .init(),
        now: @escaping @Sendable () -> Date = { .now }
    ) {
        self.entries = entries
        self.settings = settings
        self.calculator = calculator
        self.now = now
    }

    public func execute(drink: Drink, volumeMl: Int, consumedAt: Date, price: Decimal?) async throws(AddEntryError)
        -> AddEntryResult
    {
        // 1. Business rules.
        guard (50...2000).contains(volumeMl) else { throw .invalidVolume }
        if let price, price < 0 { throw .invalidPrice }
        guard consumedAt <= now().addingTimeInterval(60) else { throw .dateInFuture }

        // 2. Create the entry.
        let nutrition = calculator.nutrition(of: drink, volumeMl: volumeMl)
        let entry = Entry(
            drinkId: drink.id,
            brand: drink.brand,
            drinkName: drink.name,
            consumedAt: consumedAt,
            volumeMl: volumeMl,
            price: price,
            caffeineMg: nutrition.caffeineMg,
            sugarG: nutrition.sugarG
        )

        // 3. Save and count the day total. Storage errors become one simple case.
        do {
            try await entries.add(entry)
            let day = try await entries.entries(onDayOf: consumedAt)
            let total = day.reduce(0) { $0 + $1.caffeineMg }
            let limit = try await settings.dailyLimitMg()
            return AddEntryResult(entry: entry, dayTotalMg: total, limitMg: limit)
        } catch {
            throw .storage
        }
    }
}

// MARK: - Recent drinks

public protocol GetRecentDrinksUseCase: Sendable {
    func execute(limit: Int) async throws -> [Drink]
}

public struct DefaultGetRecentDrinksUseCase: GetRecentDrinksUseCase {
    let entries: any EntryRepository
    let drinks: any DrinkRepository

    public init(entries: any EntryRepository, drinks: any DrinkRepository) {
        self.entries = entries
        self.drinks = drinks
    }

    public func execute(limit: Int) async throws -> [Drink] {
        let ids = try await entries.recentDrinkIds(limit: limit)
        return try await drinks.drinks(ids: ids)
    }
}

// MARK: - Search

/// Honest note: this use case only forwards the call to the repository.
/// That is the usual price of Clean Architecture in small apps.
/// Ask yourself whether you need it, and feel free to delete it.
public protocol SearchDrinksUseCase: Sendable {
    func execute(_ query: String) async throws -> [Drink]
}

public struct DefaultSearchDrinksUseCase: SearchDrinksUseCase {
    let drinks: any DrinkRepository

    public init(drinks: any DrinkRepository) { self.drinks = drinks }

    public func execute(_ query: String) async throws -> [Drink] {
        try await drinks.search(query)
    }
}

// MARK: - Projected total (for the warning before saving)

public protocol TodayTotalUseCase: Sendable {
    func execute(on date: Date) async throws -> (totalMg: Double, limitMg: Int)
}

public struct DefaultTodayTotalUseCase: TodayTotalUseCase {
    let entries: any EntryRepository
    let settings: any SettingsRepository

    public init(entries: any EntryRepository, settings: any SettingsRepository) {
        self.entries = entries
        self.settings = settings
    }

    public func execute(on date: Date) async throws -> (totalMg: Double, limitMg: Int) {
        let day = try await entries.entries(onDayOf: date)
        return (day.reduce(0) { $0 + $1.caffeineMg }, try await settings.dailyLimitMg())
    }
}
