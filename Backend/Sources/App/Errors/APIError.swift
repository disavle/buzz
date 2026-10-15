import Shared
import Vapor

/// The error that route handlers throw: an HTTP status plus a code for the client.
/// `reason` is in English and only for developers.
struct APIError: AbortError {
    let status: HTTPResponseStatus
    let code: APIErrorCode
    let reason: String

    init(_ status: HTTPResponseStatus, _ code: APIErrorCode, _ reason: String? = nil) {
        self.status = status
        self.code = code
        self.reason = reason ?? code.rawValue
    }
}
