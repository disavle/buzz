import Domain
import Foundation
import Network

/// Tells when the device goes online or offline.
///
/// `NWPathMonitor` calls a closure on a dispatch queue (the old callback style).
/// We turn it into an `AsyncStream`, so callers can simply write
/// `for await isOnline in monitor.updates() { ... }`.
///
/// `@unchecked Sendable`: we promise the compiler this class is thread-safe.
/// It is true here: `NWPathMonitor` is configured once in `init` and calls us on its own queue,
/// and `Broadcaster` is protected by a Mutex. Use `@unchecked` rarely and always explain why.
public final class NetworkMonitor: @unchecked Sendable {
    private let monitor = NWPathMonitor()
    private let broadcaster = Broadcaster<Bool>()

    public init() {
        monitor.pathUpdateHandler = { [broadcaster] path in
            broadcaster.yield(path.status == .satisfied)
        }
        monitor.start(queue: DispatchQueue(label: "buzz.network-monitor"))
    }

    deinit { monitor.cancel() }

    /// `true` = online. Repeated values are removed, so we react only to real changes.
    public func updates() -> AsyncStream<Bool> {
        let source = broadcaster.stream()
        return AsyncStream { continuation in
            let task = Task {
                var last: Bool?
                for await value in source where value != last {
                    last = value
                    continuation.yield(value)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}
