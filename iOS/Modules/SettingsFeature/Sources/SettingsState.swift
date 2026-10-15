import DesignSystem
import Domain
import Foundation

/// Everything the Settings screen shows, in one value.
/// `Equatable` lets tests compare whole states, and lets SwiftUI skip work.
public struct SettingsState: Equatable {
    public var dailyLimitMg = defaultDailyLimitMg
    public var accent: AccentChoice = .default
    public var account: Account = .guest
    public var sync: SyncStatus = .offlineGuest
    public var pendingCount = 0
    /// Not a String: the state keeps a *value*, the view translates it.
    /// So reducer tests do not depend on the language.
    public var alert: SettingsAlert?

    public enum Account: Equatable {
        case guest
        case loggedIn(email: String)
    }

    public init(
        dailyLimitMg: Int = defaultDailyLimitMg,
        accent: AccentChoice = .default,
        account: Account = .guest,
        sync: SyncStatus = .offlineGuest,
        pendingCount: Int = 0,
        alert: SettingsAlert? = nil
    ) {
        self.dailyLimitMg = dailyLimitMg
        self.accent = accent
        self.account = account
        self.sync = sync
        self.pendingCount = pendingCount
        self.alert = alert
    }

    public static let limitRange = 50...1000
    public static let limitStep = 50
}

public enum SettingsAlert: Equatable, Sendable {
    case syncFailed
    case loggedOut
}

/// Everything that can happen on the screen. Two groups: from the user and from effects.
public enum SettingsAction: Sendable {
    // From the user
    case onAppear
    case limitChanged(Int)
    case accentPicked(AccentChoice)
    case syncTapped
    case loginTapped
    case logoutTapped
    case languageTapped
    case alertDismissed

    // Results of effects
    case loaded(limit: Int, email: String?, pending: Int)
    case syncStatusChanged(SyncStatus)
    case loggedOut
}

/// Dependencies as a struct of closures, not protocols. This is the TCA style:
/// a test replaces exactly the one function it cares about.
public struct SettingsEnvironment: Sendable {
    public var load: @Sendable () async -> (limit: Int, email: String?, pending: Int)
    public var saveLimit: @Sendable (Int) async -> Void
    public var saveAccent: @MainActor @Sendable (AccentChoice) -> Void
    public var syncNow: @Sendable () async -> Void
    public var syncStatus: @Sendable () -> AsyncStream<SyncStatus>
    public var logout: @Sendable () async -> Void
    /// Navigation goes out to the coordinator.
    public var openLogin: @MainActor @Sendable () -> Void
    public var openSystemSettings: @MainActor @Sendable () -> Void

    public init(
        load: @escaping @Sendable () async -> (limit: Int, email: String?, pending: Int),
        saveLimit: @escaping @Sendable (Int) async -> Void,
        saveAccent: @escaping @MainActor @Sendable (AccentChoice) -> Void,
        syncNow: @escaping @Sendable () async -> Void,
        syncStatus: @escaping @Sendable () -> AsyncStream<SyncStatus>,
        logout: @escaping @Sendable () async -> Void,
        openLogin: @escaping @MainActor @Sendable () -> Void,
        openSystemSettings: @escaping @MainActor @Sendable () -> Void
    ) {
        self.load = load
        self.saveLimit = saveLimit
        self.saveAccent = saveAccent
        self.syncNow = syncNow
        self.syncStatus = syncStatus
        self.logout = logout
        self.openLogin = openLogin
        self.openSystemSettings = openSystemSettings
    }

    /// Does nothing. For tests and previews.
    public static let noop = SettingsEnvironment(
        load: { (defaultDailyLimitMg, nil, 0) },
        saveLimit: { _ in },
        saveAccent: { _ in },
        syncNow: {},
        syncStatus: { AsyncStream { $0.finish() } },
        logout: {},
        openLogin: {},
        openSystemSettings: {}
    )
}
