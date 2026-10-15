import Domain
import Foundation
import Shared
import Synchronization

/// A fake server in memory. Use it in previews, tests, and to run the app
/// without the backend (set `BUZZ_MOCK_API=1` in the scheme's environment).
///
/// It behaves like the real API for the parts the app uses:
/// entries are stored by id (so a repeated POST does not duplicate),
/// DELETE makes a "tombstone", and /sync returns everything changed after `since`.
/// The JSON examples of the same responses are in `Mocks/api/`.
public final class MockAPIClient: APIClient {
    private struct State {
        var drinks: [UUID: DrinkDTO]
        var entries: [UUID: EntryDTO] = [:]
        var limit = 400
        var calls: [String] = []
    }

    private let state: Mutex<State>
    /// If set, every call fails with this error. Handy to test offline behaviour.
    public let failure: APIError?

    public init(drinks: [Drink] = SeedCatalog.all, failure: APIError? = nil) {
        let dtos = drinks.map {
            DrinkDTO(
                id: $0.id, brand: $0.brand, name: $0.name, volumeMl: $0.volumeMl,
                caffeinePer100ml: $0.caffeinePer100ml, sugarPer100ml: $0.sugarPer100ml,
                isCustom: $0.isCustom
            )
        }
        state = Mutex(State(drinks: Dictionary(uniqueKeysWithValues: dtos.map { ($0.id, $0) })))
        self.failure = failure
    }

    /// "POST /entries", "GET /sync" ... in call order. Tests check it.
    public var calls: [String] { state.withLock { $0.calls } }

    /// Put an entry on the "server" as if another device created it.
    public func seedRemote(_ entry: EntryDTO) {
        state.withLock { $0.entries[entry.id] = entry }
    }

    public func send<Response>(_ endpoint: Endpoint<Response>) async throws(APIError) -> Response {
        state.withLock { $0.calls.append("\(endpoint.method.rawValue) \(endpoint.path)") }
        if let failure { throw failure }

        let now = Date.now
        let result: Any
        switch (endpoint.method, endpoint.path) {
        case (.post, "/auth/login"), (.post, "/auth/register"):
            let body = try decode(CredentialsDTO.self, endpoint.body)
            result = TokenDTO(
                token: "mock-token",
                user: UserDTO(id: UUID(), email: body.email, dailyCaffeineLimitMg: 400, locale: .en)
            )

        case (.get, "/me"):
            result = state.withLock { UserDTO(id: UUID(), email: "demo@buzz.app", dailyCaffeineLimitMg: $0.limit, locale: .en) }

        case (.get, "/drinks"):
            result = state.withLock { Array($0.drinks.values) }

        case (.post, "/entries"):
            let dto = try decode(CreateEntryDTO.self, endpoint.body)
            result = state.withLock { state -> EntryDTO in
                if let existing = state.entries[dto.id] { return existing }   // idempotent
                let drink = state.drinks[dto.drinkId]
                let volume = dto.volumeMl ?? drink?.volumeMl ?? 0
                let entry = EntryDTO(
                    id: dto.id, drinkId: dto.drinkId, consumedAt: dto.consumedAt, volumeMl: volume,
                    price: dto.price,
                    caffeineMg: (drink?.caffeinePer100ml ?? 0) * Double(volume) / 100,
                    sugarG: (drink?.sugarPer100ml ?? 0) * Double(volume) / 100,
                    updatedAt: now, deletedAt: nil
                )
                state.entries[dto.id] = entry
                return entry
            }

        case (.delete, let path) where path.hasPrefix("/entries/"):
            let id = UUID(uuidString: String(path.dropFirst("/entries/".count)))
            state.withLock { state in
                if let id, var entry = state.entries[id] {
                    entry.deletedAt = now
                    entry.updatedAt = now
                    state.entries[id] = entry
                }
            }
            result = EmptyResponse()

        case (.get, "/sync"):
            let since = endpoint.query.first { $0.name == "since" }?.value
                .flatMap { try? Date($0, strategy: .iso8601) }
            result = state.withLock { state in
                SyncDTO(
                    drinks: Array(state.drinks.values),
                    entries: state.entries.values.filter { since == nil || ($0.updatedAt ?? now) > since! },
                    serverTime: now
                )
            }

        default:
            throw .server(.notFound, status: 404)
        }

        guard let typed = result as? Response else { throw .decoding }
        return typed
    }

    private func decode<T: Decodable>(_ type: T.Type, _ data: Data?) throws(APIError) -> T {
        guard let data, let value = try? JSONDecoder.buzz.decode(T.self, from: data) else {
            throw .server(.invalidBody, status: 400)
        }
        return value
    }
}
