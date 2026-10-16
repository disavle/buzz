import Domain
import Foundation
import SwiftData

/// `EntryRepository` on top of SwiftData.
///
/// It is an actor that conforms to `ModelActor`. This gives it its own `ModelContext`
/// that runs off the main thread, so heavy fetches never block the UI.
///
/// Usually you write `@ModelActor actor X {}` and the macro generates the code below.
/// We write it by hand once so you can see what the macro does:
/// a `modelContainer`, a `modelExecutor` with a fresh context, and an init.
public actor SwiftDataEntryRepository: EntryRepository, ModelActor {
    public nonisolated let modelContainer: ModelContainer
    public nonisolated let modelExecutor: any ModelExecutor
    private nonisolated let broadcaster: Broadcaster<Void>
    private nonisolated let localEdits: Broadcaster<Void>

    /// - Parameters:
    ///   - broadcaster: "data changed, reload the screens". Pass the same one to `SyncStore`,
    ///     so data that comes from the server also tells the screens to reload.
    ///   - localEdits: "the user changed something, it needs to be sent". Only the sync engine
    ///     listens to it. It must stay separate from `broadcaster`: otherwise every sync pass
    ///     (which also changes data) would start the next pass, in an endless loop.
    public init(
        modelContainer: ModelContainer,
        broadcaster: Broadcaster<Void> = .init(),
        localEdits: Broadcaster<Void> = .init()
    ) {
        self.modelContainer = modelContainer
        let context = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: context)
        self.broadcaster = broadcaster
        self.localEdits = localEdits
    }

    public func entries(from: Date, to: Date) async throws -> [Entry] {
        // #Predicate is a macro: it turns this Swift closure into a database query.
        // Only simple expressions work inside it, so we capture plain local values.
        let descriptor = FetchDescriptor<EntryModel>(
            predicate: #Predicate { $0.consumedAt >= from && $0.consumedAt < to && $0.deletedAt == nil },
            sortBy: [SortDescriptor(\.consumedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map(\.asDomain)
    }

    public func add(_ entry: Entry) async throws {
        // Any change made by the user is `pending`: the sync engine will send it.
        modelContext.insert(EntryModel(entry, syncState: .pending))
        try modelContext.save()
        broadcaster.yield()
        localEdits.yield()
    }

    public func delete(id: UUID) async throws {
        guard let model = try fetch(id: id) else { return }
        if model.syncState == .pending {
            // The server never saw this entry, so we can remove it for real.
            modelContext.delete(model)
        } else {
            model.deletedAt = .now
            model.updatedAt = .now
            model.syncState = .pendingDelete
        }
        try modelContext.save()
        broadcaster.yield()
        localEdits.yield()
    }

    public func recentDrinkIds(limit: Int) async throws -> [UUID] {
        var descriptor = FetchDescriptor<EntryModel>(
            predicate: #Predicate { $0.deletedAt == nil },
            sortBy: [SortDescriptor(\.consumedAt, order: .reverse)]
        )
        // Read a bit more than needed: the same drink can repeat many times.
        descriptor.fetchLimit = limit * 10
        var result: [UUID] = []
        for model in try modelContext.fetch(descriptor) where !result.contains(model.drinkId) {
            result.append(model.drinkId)
            if result.count == limit { break }
        }
        return result
    }

    public nonisolated func changes() -> AsyncStream<Void> {
        broadcaster.stream()
    }

    private func fetch(id: UUID) throws -> EntryModel? {
        var descriptor = FetchDescriptor<EntryModel>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
}
