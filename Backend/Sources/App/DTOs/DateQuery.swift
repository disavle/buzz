import Vapor
import Shared

/// Dates in query parameters come as ISO 8601 strings (`?since=2026-10-15T21:00:00Z`).
/// We parse them by hand so the format matches the JSON body.
func isoDate(_ string: String?, name: String) throws -> Date? {
    guard let string else { return nil }
    guard let date = try? Date(string, strategy: .iso8601) else {
        throw APIError(.badRequest, .invalidDate, "\(name) must be an ISO 8601 date")
    }
    return date
}
