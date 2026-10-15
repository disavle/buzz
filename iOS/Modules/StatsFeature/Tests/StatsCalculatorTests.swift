import Domain
import Foundation
import Testing

@testable import StatsFeature

private let calendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Europe/Moscow")!
    calendar.firstWeekday = 2  // Monday
    return calendar
}()

private let now = calendar.date(from: DateComponents(year: 2026, month: 10, day: 15, hour: 20))!

private func entry(_ drink: Drink, daysAgo: Int, hour: Int, price: Decimal? = nil) -> Entry {
    let day = calendar.date(byAdding: .day, value: -daysAgo, to: now)!
    let date = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day)!
    return .make(drink: drink, volumeMl: drink.volumeMl, consumedAt: date, price: price)
}

@Test("Every day of the week has a bar, empty days are zero")
func byDayFillsGaps() {
    let entries = [entry(SeedCatalog.redBull, daysAgo: 0, hour: 9), entry(SeedCatalog.redBull, daysAgo: 3, hour: 9)]
    let days = StatsCalculator(calendar: calendar).snapshot(entries: entries, period: .week, now: now).byDay

    #expect(days.count == 7)
    #expect(days.last?.caffeineMg == 80)  // today
    #expect(days.filter { $0.caffeineMg == 0 }.count == 5)
}

@Test("Hours always have 24 buckets and the peak is found")
func byHour() {
    let entries = [
        entry(SeedCatalog.redBull, daysAgo: 0, hour: 14),
        entry(SeedCatalog.redBull, daysAgo: 1, hour: 14),
        entry(SeedCatalog.redBull, daysAgo: 2, hour: 9),
    ]
    let snapshot = StatsCalculator(calendar: calendar).snapshot(entries: entries, period: .week, now: now)
    #expect(snapshot.byHour.count == 24)
    #expect(snapshot.peakHour == 14)
}

@Test("Brands after the top 4 go to 'Other'")
func otherBrands() {
    let drinks = [
        SeedCatalog.redBull, SeedCatalog.monster, SeedCatalog.burn, SeedCatalog.adrenaline,
        SeedCatalog.flashUp, SeedCatalog.tornado,
    ]
    let entries = drinks.enumerated().map { entry($1, daysAgo: $0, hour: 10) }
    let brands = StatsCalculator(calendar: calendar).snapshot(entries: entries, period: .week, now: now).byBrand

    #expect(brands.count == 5)
    #expect(brands.last?.brand == nil)
    #expect(brands.last?.count == 2)
}

@Test("Spending is grouped by week")
func spending() {
    let entries = [
        entry(SeedCatalog.redBull, daysAgo: 0, hour: 10, price: 100),
        entry(SeedCatalog.redBull, daysAgo: 1, hour: 10, price: 50),
        entry(SeedCatalog.redBull, daysAgo: 8, hour: 10, price: 70),
    ]
    let weeks = StatsCalculator(calendar: calendar).snapshot(entries: entries, period: .month, now: now).spendByWeek
    #expect(weeks.map(\.amount) == [70, 150])
}
