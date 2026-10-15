import Domain
import Foundation

/// Settings in `UserDefaults`. Good enough for a few small values.
///
/// We store only the suite name (a String) and open `UserDefaults` when needed,
/// so this struct is `Sendable` without any tricks. Tests can pass their own suite.
public struct UserDefaultsSettingsRepository: SettingsRepository {
    /// The same key that SwiftUI code could read with `@AppStorage("dailyCaffeineLimitMg")`.
    public static let limitKey = "dailyCaffeineLimitMg"
    private let suiteName: String?

    public init(suiteName: String? = nil) {
        self.suiteName = suiteName
    }

    private var defaults: UserDefaults { suiteName.flatMap(UserDefaults.init(suiteName:)) ?? .standard }

    public func dailyLimitMg() async throws -> Int {
        let value = defaults.integer(forKey: Self.limitKey)
        return value == 0 ? defaultDailyLimitMg : value
    }

    public func setDailyLimitMg(_ value: Int) async throws {
        defaults.set(value, forKey: Self.limitKey)
    }
}
