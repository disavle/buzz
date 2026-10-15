import Foundation
import Shared

/// One API call: path, method, body and the type of the response.
///
/// The generic `Response` ties the request to its answer at compile time:
/// `api.send(.me)` returns `UserDTO`, and you cannot decode it as something else by mistake.
/// The list of endpoints is in docs/backend/API.md.
public struct Endpoint<Response: Decodable & Sendable>: Sendable {
    public enum Method: String, Sendable { case get = "GET", post = "POST", patch = "PATCH", delete = "DELETE" }

    public var method: Method
    public var path: String
    public var query: [URLQueryItem] = []
    /// Already encoded JSON body.
    public var body: Data?
    /// `false` only for /auth/* routes.
    public var requiresAuth = true
}

/// Used by endpoints that return no body (for example DELETE answers 204).
public struct EmptyResponse: Decodable, Sendable {}

// MARK: - All Buzz endpoints

public extension Endpoint where Response == TokenDTO {
    static func register(_ dto: RegisterDTO) -> Self {
        Self(method: .post, path: "/auth/register", body: try? JSONEncoder.buzz.encode(dto), requiresAuth: false)
    }

    static func login(_ dto: CredentialsDTO) -> Self {
        Self(method: .post, path: "/auth/login", body: try? JSONEncoder.buzz.encode(dto), requiresAuth: false)
    }
}

public extension Endpoint where Response == UserDTO {
    static var me: Self { Self(method: .get, path: "/me") }

    static func updateMe(_ dto: UpdateMeDTO) -> Self {
        Self(method: .patch, path: "/me", body: try? JSONEncoder.buzz.encode(dto))
    }
}

public extension Endpoint where Response == [DrinkDTO] {
    static func drinks(query: String = "") -> Self {
        Self(method: .get, path: "/drinks", query: query.isEmpty ? [] : [URLQueryItem(name: "query", value: query)])
    }
}

public extension Endpoint where Response == DrinkDTO {
    static func createDrink(_ dto: CreateDrinkDTO) -> Self {
        Self(method: .post, path: "/drinks", body: try? JSONEncoder.buzz.encode(dto))
    }
}

public extension Endpoint where Response == EntryDTO {
    static func createEntry(_ dto: CreateEntryDTO) -> Self {
        Self(method: .post, path: "/entries", body: try? JSONEncoder.buzz.encode(dto))
    }
}

public extension Endpoint where Response == EmptyResponse {
    static func deleteEntry(_ id: UUID) -> Self {
        Self(method: .delete, path: "/entries/\(id.uuidString)")
    }
}

public extension Endpoint where Response == SyncDTO {
    static func sync(since: Date?) -> Self {
        let query = since.map { [URLQueryItem(name: "since", value: $0.formatted(.iso8601))] } ?? []
        return Self(method: .get, path: "/sync", query: query)
    }
}

public extension Endpoint where Response == StatsDTO {
    static func stats(period: StatsPeriod, timeZone: TimeZone = .current) -> Self {
        Self(method: .get, path: "/stats", query: [
            URLQueryItem(name: "period", value: period.rawValue),
            URLQueryItem(name: "tz", value: timeZone.identifier),
        ])
    }
}
