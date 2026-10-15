import Fluent
import Shared
import Vapor

struct StatsController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get("stats", use: stats)
    }

    struct StatsQuery: Content {
        var period: StatsPeriod?
        /// The client's time zone, for example Europe/Moscow. It decides
        /// which day and hour a can drunk at 00:30 belongs to.
        var tz: String?
    }

    /// GET /stats?period=week|month&tz=Europe/Moscow
    ///
    /// We aggregate in Swift: there are few entries in the MVP and the code is easier to read.
    /// Next step for practice: move the grouping into SQL with SQLKit
    /// (GROUP BY date(consumed_at)).
    @Sendable
    func stats(req: Request) async throws -> StatsDTO {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        let query = try req.query.decode(StatsQuery.self)
        let period = query.period ?? .week

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = query.tz.flatMap(TimeZone.init(identifier:)) ?? .gmt
        calendar.firstWeekday = 2  // weeks start on Monday

        let today = calendar.startOfDay(for: Date())
        let days = (0..<period.days).reversed().compactMap {
            calendar.date(byAdding: .day, value: -$0, to: today)
        }
        guard let from = days.first else { throw Abort(.internalServerError) }

        let entries = try await Entry.query(on: req.db)
            .filter(\.$user.$id == userID)
            .filter(\.$consumedAt >= from)
            .with(\.$drink)
            .all()

        // By day
        var dayTotals: [Date: DayStat] = [:]
        for day in days {
            dayTotals[day] = DayStat(day: day, caffeineMg: 0, sugarG: 0, count: 0)
        }
        for entry in entries {
            let day = calendar.startOfDay(for: entry.consumedAt)
            dayTotals[day]?.caffeineMg += entry.caffeineMg
            dayTotals[day]?.sugarG += entry.sugarG
            dayTotals[day]?.count += 1
        }

        // By hour
        var hourCounts = Array(repeating: 0, count: 24)
        for entry in entries {
            hourCounts[calendar.component(.hour, from: entry.consumedAt)] += 1
        }

        // By brand
        let brandCounts = Dictionary(grouping: entries, by: { $0.drink.brand })
            .map { BrandStat(brand: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }

        // Spending by week
        var weekTotals: [Date: Int] = [:]
        for entry in entries {
            guard let price = entry.priceMinor,
                let week = calendar.dateInterval(of: .weekOfYear, for: entry.consumedAt)?.start
            else { continue }
            weekTotals[week, default: 0] += price
        }

        return StatsDTO(
            period: period,
            dailyCaffeineLimitMg: user.dailyCaffeineLimitMg,
            byDay: days.compactMap { dayTotals[$0] },
            byHour: hourCounts.enumerated().map { HourStat(hour: $0.offset, count: $0.element) },
            byBrand: brandCounts,
            spendByWeek:
                weekTotals
                .sorted { $0.key < $1.key }
                .map { WeekSpend(weekStart: $0.key, total: Money.fromMinor($0.value)) }
        )
    }
}
