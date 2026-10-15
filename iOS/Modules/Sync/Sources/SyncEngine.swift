import Domain
import Foundation
import Networking
import Persistence

/// Offline-first sync. Screens always read local SwiftData; this actor moves data
/// to and from the server in the background. Full story: docs/client/sync.md.
///
/// Why an actor: `syncNow()` can be called from many places at once (app start,
/// pull to refresh, network came back). The actor runs its methods one at a time,
/// so `isRunning` and `needsAnotherPass` can never be changed by two tasks together.
public actor SyncEngine: SyncService {
    private let store: SyncStore
    private let api: any APIClient
    private let tokens: any TokenStore
    private nonisolated let status = Broadcaster<SyncStatus>()

    private var isRunning = false
    private var needsAnotherPass = false
    private var lastStatus: SyncStatus = .idle(lastSync: nil)
    private var triggerTasks: [Task<Void, Never>] = []

    public init(store: SyncStore, api: any APIClient, tokens: any TokenStore) {
        self.store = store
        self.api = api
        self.tokens = tokens
    }

    // MARK: - SyncService

    public func syncNow() async {
        // Merge calls: if a sync is already running, just ask for one more pass.
        // Note: an actor is re-entrant. While `pass()` awaits the network,
        // another `syncNow()` can start running here. That is exactly why we need this flag.
        guard !isRunning else {
            needsAnotherPass = true
            return
        }
        isRunning = true
        defer { isRunning = false }

        repeat {
            needsAnotherPass = false
            await pass()
        } while needsAnotherPass
    }

    public nonisolated func statusUpdates() -> AsyncStream<SyncStatus> {
        let stream = status.stream()
        // Send the current status to the new listener right away.
        Task { await self.publish(nil) }
        return stream
    }

    public func pendingCount() async -> Int {
        (try? await store.pendingCount()) ?? 0
    }

    // MARK: - Automatic triggers

    /// Start the automatic triggers: local changes (with a small delay to merge
    /// a series of actions) and the network coming back.
    public func start(changes: AsyncStream<Void>, network: NetworkMonitor) {
        guard triggerTasks.isEmpty else { return }

        triggerTasks.append(
            Task { [weak self] in
                for await _ in changes {
                    // Debounce: wait 2 seconds. If the user adds 3 cans quickly we send them in one pass.
                    try? await Task.sleep(for: .seconds(2))
                    await self?.syncNow()
                }
            }
        )

        triggerTasks.append(
            Task { [weak self] in
                for await isOnline in network.updates() where isOnline {
                    await self?.syncNow()
                }
            }
        )
    }

    // MARK: - One pass

    private func pass() async {
        guard await tokens.token() != nil else {
            publish(.offlineGuest)
            return
        }
        publish(.syncing)
        do {
            try await pushPending()
            try await pullChanges()
            publish(.idle(lastSync: await store.lastSyncedAt))
        } catch APIError.unauthorized {
            await tokens.clear()
            publish(.needsLogin)
        } catch {
            // Pending rows stay as they are, the next trigger will retry.
            publish(.failed)
        }
    }

    /// Step 1: send the outbox.
    private func pushPending() async throws {
        // Custom drinks first: an entry may point to one of them.
        for drink in try await store.pendingCustomDrinks() {
            _ = try await api.send(.createDrink(drink.createDTO))
            try await store.markDrinkSynced(drink.id)
        }
        for pending in try await store.pendingEntries() {
            // The same id again does not create a duplicate on the server.
            _ = try await api.send(.createEntry(pending.entry.createDTO))
            try await store.markSynced(pending.entry.id, ifUpdatedAt: pending.updatedAt)
        }
        for id in try await store.pendingDeletes() {
            do {
                _ = try await api.send(.deleteEntry(id))
            } catch APIError.server(.notFound, _) {
                // Already deleted on the server: that is a success for us.
            }
            try await store.markSyncedDelete(id)
        }
    }

    /// Steps 2 and 3: fetch changes and apply them without touching pending rows.
    private func pullChanges() async throws {
        let delta = try await api.send(.sync(since: await store.lastSyncedAt))
        try await store.apply(delta)
        await store.setLastSyncedAt(delta.serverTime)
    }

    /// Remembers and broadcasts the status. `nil` re-sends the last one.
    private func publish(_ new: SyncStatus?) {
        if let new { lastStatus = new }
        status.yield(lastStatus)
    }
}
