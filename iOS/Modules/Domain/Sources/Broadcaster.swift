import Foundation
import Synchronization

/// Sends the same values to many `AsyncStream` listeners.
///
/// A plain `AsyncStream` has only one consumer: if two loops read it,
/// each value goes to only one of them. Here every `stream()` call
/// creates a new stream, and `yield` sends the value to all of them.
///
/// `Mutex` (from the Synchronization framework, iOS 18+) protects the dictionary,
/// so the class is `Sendable` and can be used from any thread or actor.
public final class Broadcaster<Element: Sendable>: Sendable {
    private let continuations = Mutex<[UUID: AsyncStream<Element>.Continuation]>([:])

    public init() {}

    public func stream() -> AsyncStream<Element> {
        let id = UUID()
        let (stream, continuation) = AsyncStream<Element>.makeStream(bufferingPolicy: .bufferingNewest(1))
        // When the listener stops (its Task is cancelled), forget the continuation.
        continuation.onTermination = { [weak self] _ in
            _ = self?.continuations.withLock { $0.removeValue(forKey: id) }
        }
        continuations.withLock { $0[id] = continuation }
        return stream
    }

    public func yield(_ value: Element) {
        let all = continuations.withLock { Array($0.values) }
        for continuation in all {
            continuation.yield(value)
        }
    }
}

public extension Broadcaster where Element == Void {
    func yield() { yield(()) }
}
