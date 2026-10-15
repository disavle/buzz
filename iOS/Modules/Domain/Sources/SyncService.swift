import Foundation

/// What the sync engine is doing right now. Settings shows it as text.
public enum SyncStatus: Sendable, Equatable {
    /// Nothing is running. `lastSync` is nil if we never synced.
    case idle(lastSync: Date?)
    case syncing
    /// The last try failed (no network, server error). Pending entries stay and we retry later.
    case failed
    /// The user is not logged in: data lives only on this device.
    case offlineGuest
    /// The token expired, the user must log in again.
    case needsLogin
}

/// Features see only this protocol. The real `SyncEngine` actor lives in the Sync module.
/// This is the Dependency Inversion idea: high-level code depends on an abstraction.
public protocol SyncService: Sendable {
    /// Send pending changes, then fetch new data from the server.
    /// Safe to call many times: calls that come during a sync are merged into one more pass.
    func syncNow() async
    /// New stream of status updates for each caller.
    func statusUpdates() -> AsyncStream<SyncStatus>
    /// How many local changes still wait to be sent.
    func pendingCount() async -> Int
}

/// A sync service that does nothing. Used in previews and before login.
public struct NoopSyncService: SyncService {
    public init() {}
    public func syncNow() async {}
    public func statusUpdates() -> AsyncStream<SyncStatus> {
        AsyncStream { $0.yield(.offlineGuest); $0.finish() }
    }
    public func pendingCount() async -> Int { 0 }
}
