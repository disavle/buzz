import Domain
import Foundation
import SwiftData

/// `DrinkRepository` on top of SwiftData. Same `ModelActor` pattern as the entry repository.
public actor SwiftDataDrinkRepository: DrinkRepository, ModelActor {
    public nonisolated let modelContainer: ModelContainer
    public nonisolated let modelExecutor: any ModelExecutor

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: ModelContext(modelContainer))
    }

    public func all() async throws -> [Drink] {
        let descriptor = FetchDescriptor<DrinkModel>(
            sortBy: [SortDescriptor(\.brand), SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor).map(\.asDomain)
    }

    public func search(_ query: String) async throws -> [Drink] {
        let query = query.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return try await all() }
        // `localizedStandardContains` is supported inside #Predicate
        // and ignores case, so "red" finds "Red Bull".
        let descriptor = FetchDescriptor<DrinkModel>(
            predicate: #Predicate {
                $0.brand.localizedStandardContains(query) || $0.name.localizedStandardContains(query)
            },
            sortBy: [SortDescriptor(\.brand), SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor).map(\.asDomain)
    }

    public func drinks(ids: [UUID]) async throws -> [Drink] {
        let descriptor = FetchDescriptor<DrinkModel>(predicate: #Predicate { ids.contains($0.id) })
        let found = try modelContext.fetch(descriptor).map(\.asDomain)
        // Keep the order of `ids` (the database does not keep it).
        return ids.compactMap { id in found.first { $0.id == id } }
    }

    public func add(_ drink: Drink) async throws {
        var custom = drink
        custom.isCustom = true
        modelContext.insert(DrinkModel(custom, syncState: .pending))
        try modelContext.save()
    }
}
