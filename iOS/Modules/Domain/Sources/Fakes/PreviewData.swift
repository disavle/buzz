import Foundation

/// Ready-made data for `#Preview` blocks and tests.
/// The same entries as on the design canvas: 320 mg of 400 today.
public enum PreviewData {
    /// Today at a given hour and minute.
    public static func today(_ hour: Int, _ minute: Int = 0, calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: hour, minute: minute, second: 0, of: .now) ?? .now
    }

    public static let todayEntries: [Entry] = {
        var monster = Entry.make(drink: SeedCatalog.monsterUltra, volumeMl: 500, consumedAt: today(18, 40))
        monster.isSynced = false   // shows the "not synced" icon
        var burn = Entry.make(drink: SeedCatalog.burn, volumeMl: 250, consumedAt: today(13, 30))
        burn.isSynced = true
        var redBull = Entry.make(drink: SeedCatalog.redBull, volumeMl: 250, consumedAt: today(9, 10))
        redBull.isSynced = true
        return [monster, burn, redBull]
    }()

    /// About a month of random-looking but stable history for the Stats screen.
    public static func history(days: Int = 30, calendar: Calendar = .current) -> [Entry] {
        let drinks = SeedCatalog.all
        var result: [Entry] = []
        for day in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -day, to: .now) else { continue }
            // A simple formula instead of random(), so previews look the same every time.
            let cans = 1 + (day * 7) % 3
            for can in 0..<cans {
                let drink = drinks[(day + can) % drinks.count]
                let hour = 9 + (day * 3 + can * 5) % 13
                let time = calendar.date(bySettingHour: hour, minute: 15, second: 0, of: date) ?? date
                var entry = Entry.make(drink: drink, volumeMl: drink.volumeMl, consumedAt: time, price: 129)
                entry.isSynced = true
                result.append(entry)
            }
        }
        return result
    }
}
