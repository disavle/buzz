import Foundation

/// Where a local record is in the sync process.
///
/// - `synced`: the server has the same version.
/// - `pending`: created or changed on this device, waiting to be sent (this is our "outbox").
/// - `pendingDelete`: deleted on this device, the server does not know yet.
///
/// SwiftData stores it as a String (`syncStateRaw`): `#Predicate` with enums
/// is not reliable in SwiftData, but with strings it works fine.
public enum SyncState: String, Codable, Sendable {
    case synced
    case pending
    case pendingDelete
}
