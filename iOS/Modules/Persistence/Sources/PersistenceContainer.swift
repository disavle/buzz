import Domain
import Foundation
import SwiftData

/// Creates the SwiftData `ModelContainer` (the database) for the whole app.
///
/// One container is shared by all repositories. Each repository actor
/// makes its own `ModelContext` from it (contexts are not thread-safe, containers are).
public enum PersistenceContainer {
    public static let schema = Schema([DrinkModel.self, EntryModel.self])

    /// - Parameter inMemory: `true` for previews and tests: nothing is written to disk.
    public static func make(inMemory: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: schema, configurations: configuration)
    }

    /// Fills the catalog with `SeedCatalog` if it is empty (first launch).
    public static func seedIfNeeded(_ container: ModelContainer) throws {
        let context = ModelContext(container)
        let count = try context.fetchCount(FetchDescriptor<DrinkModel>())
        guard count == 0 else { return }
        for drink in SeedCatalog.all {
            // The seed is the same as on the server, so it is already "synced".
            context.insert(DrinkModel(drink, syncState: .synced))
        }
        try context.save()
    }
}
