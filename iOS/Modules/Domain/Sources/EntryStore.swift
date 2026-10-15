import Foundation
import Observation

/// Shared state for screens that show today's entries ("Today", and the snack after "Add").
///
/// `@Observable` (the Observation framework, iOS 17+) replaces `ObservableObject` + `@Published`.
/// SwiftUI tracks which properties a view *reads* in `body` and redraws only when
/// those properties change. No `@Published`, no Combine.
///
/// `@MainActor`: the store is UI state, so it always lives on the main thread.
@MainActor
@Observable
public final class EntryStore {
    public private(set) var today: [Entry] = []

    // `@ObservationIgnored`: this property never changes, so do not track it.
    @ObservationIgnored private let repository: any EntryRepository
    @ObservationIgnored private var listenTask: Task<Void, Never>?

    public init(repository: any EntryRepository) {
        self.repository = repository
    }

    /// Start listening for changes from the repository (new entry, delete, sync).
    /// Call once at app start.
    public func startListening() {
        guard listenTask == nil else { return }
        let changes = repository.changes()
        listenTask = Task { [weak self] in
            for await _ in changes {
                try? await self?.loadToday()
            }
        }
    }

    public func loadToday(now: Date = .now) async throws {
        today = try await repository.entries(onDayOf: now)
    }

    public func add(_ entry: Entry) async throws {
        try await repository.add(entry)
        try await loadToday()
    }

    public func delete(id: UUID) async throws {
        try await repository.delete(id: id)
        try await loadToday()
    }

    // MARK: - Simple totals for today

    public var caffeineMg: Double { today.reduce(0) { $0 + $1.caffeineMg } }
    public var sugarG: Double { today.reduce(0) { $0 + $1.sugarG } }
}
