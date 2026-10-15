import Domain
import Foundation

// Data for the four charts. Small `Identifiable` structs are what Swift Charts likes best.

public struct DayTotal: Identifiable, Equatable, Sendable {
    public let day: Date
    public let caffeineMg: Double
    public var id: Date { day }
}

public struct HourBucket: Identifiable, Equatable, Sendable {
    public let hour: Int
    public let count: Int
    public var id: Int { hour }
}

public struct BrandShare: Identifiable, Equatable, Sendable {
    /// `nil` brand = "Other" (all brands after the top 4). Kept as nil, not as a string,
    /// because "Other" must be translated and brand names must not.
    public let brand: String?
    public let count: Int
    public var id: String { brand ?? "_other" }
}

public struct WeekSpend: Identifiable, Equatable, Sendable {
    public let weekStart: Date
    public let amount: Decimal
    public var id: Date { weekStart }
}

public enum StatsPeriod: String, CaseIterable, Sendable {
    case week, month
    public var days: Int { self == .week ? 7 : 30 }
}

public struct StatsSnapshot: Equatable, Sendable {
    public var byDay: [DayTotal] = []
    public var byHour: [HourBucket] = []
    public var byBrand: [BrandShare] = []
    public var spendByWeek: [WeekSpend] = []

    public var averageMg: Double {
        byDay.isEmpty ? 0 : byDay.reduce(0) { $0 + $1.caffeineMg } / Double(byDay.count)
    }
    /// The busiest hour, for the "usually at 14:00–15:00" number.
    public var peakHour: Int? { byHour.max { $0.count < $1.count }.flatMap { !$0.isEmpty ? $0.hour : nil } }
    public var totalCans: Int { byBrand.reduce(0) { $0 + $1.count } }
    public var lastWeekSpend: Decimal { spendByWeek.last?.amount ?? 0 }
}

/// Pure grouping logic, separate from the view model so it is easy to test.
/// Later the `/stats` endpoint can return the same structures from the server.
public struct StatsCalculator: Sendable {
    let calendar: Calendar

    /// Use `Calendar.current`: then weeks start on Monday in Russia and on Sunday in the US,
    /// exactly like the chart axis labels.
    public init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    public func snapshot(entries: [Entry], period: StatsPeriod, now: Date = .now) -> StatsSnapshot {
        StatsSnapshot(
            byDay: byDay(entries, period: period, now: now),
            byHour: byHour(entries),
            byBrand: byBrand(entries),
            spendByWeek: spendByWeek(entries)
        )
    }

    /// One bar per day. Days without cans get 0, otherwise the chart would have holes.
    func byDay(_ entries: [Entry], period: StatsPeriod, now: Date) -> [DayTotal] {
        let totals = Dictionary(grouping: entries) { calendar.startOfDay(for: $0.consumedAt) }
            .mapValues { $0.reduce(0) { $0 + $1.caffeineMg } }
        let today = calendar.startOfDay(for: now)
        return (0..<period.days).reversed().compactMap { offset in
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            return DayTotal(day: day, caffeineMg: totals[day] ?? 0)
        }
    }

    /// Always 24 buckets, 0...23.
    func byHour(_ entries: [Entry]) -> [HourBucket] {
        let counts = Dictionary(grouping: entries) { calendar.component(.hour, from: $0.consumedAt) }.mapValues(\.count)
        return (0..<24).map { HourBucket(hour: $0, count: counts[$0] ?? 0) }
    }

    /// Top 4 brands + "Other".
    func byBrand(_ entries: [Entry]) -> [BrandShare] {
        let sorted = Dictionary(grouping: entries, by: \.brand)
            .map { BrandShare(brand: $0.key, count: $0.value.count) }
            .sorted { $0.count != $1.count ? $0.count > $1.count : ($0.brand ?? "") < ($1.brand ?? "") }
        let top = Array(sorted.prefix(4))
        let rest = sorted.dropFirst(4).reduce(0) { $0 + $1.count }
        return rest > 0 ? top + [BrandShare(brand: nil, count: rest)] : top
    }

    func spendByWeek(_ entries: [Entry]) -> [WeekSpend] {
        Dictionary(grouping: entries.filter { $0.price != nil }) {
            calendar.dateInterval(of: .weekOfYear, for: $0.consumedAt)?.start ?? $0.consumedAt
        }
        .map { WeekSpend(weekStart: $0.key, amount: $0.value.reduce(0) { $0 + ($1.price ?? 0) }) }
        .sorted { $0.weekStart < $1.weekStart }
    }
}
