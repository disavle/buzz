import Foundation

public enum StatsPeriod: String, Codable, Sendable, CaseIterable {
    case week
    case month

    public var days: Int {
        switch self {
        case .week: 7
        case .month: 30
        }
    }
}

/// Response of GET /stats?period=week|month&tz=Europe/Moscow.
/// Each field maps to its own Swift Charts chart.
public struct StatsDTO: Codable, Sendable, Hashable {
    public var period: StatsPeriod
    public var dailyCaffeineLimitMg: Int
    /// BarMark + RuleMark for the limit. Days without entries are included with zeros.
    public var byDay: [DayStat]
    /// When you drink: 24 items, hour 0...23.
    public var byHour: [HourStat]
    /// SectorMark by brand, most frequent first.
    public var byBrand: [BrandStat]
    /// LineMark of spending by week.
    public var spendByWeek: [WeekSpend]

    public init(period: StatsPeriod, dailyCaffeineLimitMg: Int, byDay: [DayStat], byHour: [HourStat], byBrand: [BrandStat], spendByWeek: [WeekSpend]) {
        self.period = period
        self.dailyCaffeineLimitMg = dailyCaffeineLimitMg
        self.byDay = byDay
        self.byHour = byHour
        self.byBrand = byBrand
        self.spendByWeek = spendByWeek
    }
}

public struct DayStat: Codable, Sendable, Hashable {
    public var day: Date
    public var caffeineMg: Double
    public var sugarG: Double
    public var count: Int

    public init(day: Date, caffeineMg: Double, sugarG: Double, count: Int) {
        self.day = day
        self.caffeineMg = caffeineMg
        self.sugarG = sugarG
        self.count = count
    }
}

public struct HourStat: Codable, Sendable, Hashable {
    public var hour: Int
    public var count: Int

    public init(hour: Int, count: Int) {
        self.hour = hour
        self.count = count
    }
}

public struct BrandStat: Codable, Sendable, Hashable {
    public var brand: String
    public var count: Int

    public init(brand: String, count: Int) {
        self.brand = brand
        self.count = count
    }
}

public struct WeekSpend: Codable, Sendable, Hashable {
    public var weekStart: Date
    public var total: Decimal

    public init(weekStart: Date, total: Decimal) {
        self.weekStart = weekStart
        self.total = total
    }
}
