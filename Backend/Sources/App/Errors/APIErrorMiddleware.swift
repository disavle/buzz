import Shared
import Vapor

/// Replaces Vapor's default ErrorMiddleware: any error becomes
/// an `APIErrorDTO` with a machine code that the client translates itself.
struct APIErrorMiddleware: AsyncMiddleware {
    /// Which field failed validation -> which code to return.
    private static let validationCodes: [String: APIErrorCode] = [
        "email": .emailInvalid,
        "password": .passwordTooShort,
        "dailyCaffeineLimitMg": .limitInvalid,
        "locale": .localeInvalid,
        "volumeMl": .volumeInvalid,
        "brand": .drinkInvalid,
        "name": .drinkInvalid,
        "caffeinePer100ml": .drinkInvalid,
        "sugarPer100ml": .drinkInvalid,
    ]

    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: request)
        } catch {
            let (status, body) = Self.map(error)
            if status == .internalServerError {
                request.logger.report(error: error)
            }
            let response = Response(status: status)
            try response.content.encode(body)
            return response
        }
    }

    static func map(_ error: any Error) -> (HTTPResponseStatus, APIErrorDTO) {
        switch error {
        case let error as APIError:
            return (error.status, APIErrorDTO(error: error.code, reason: error.reason))

        case let error as ValidationsError:
            let key = error.failures.first.map { "\($0.key)" } ?? ""
            let code = validationCodes[key] ?? .validationFailed
            return (.badRequest, APIErrorDTO(error: code, reason: error.description))

        case is DecodingError:
            return (.badRequest, APIErrorDTO(error: .invalidBody, reason: "\(error)"))

        case let error as any AbortError:
            let code: APIErrorCode =
                switch error.status {
                case .unauthorized: .unauthorized
                case .notFound: .notFound
                case .badRequest, .unprocessableEntity: .invalidBody
                default: .internal
                }
            return (error.status, APIErrorDTO(error: code, reason: error.reason))

        default:
            return (.internalServerError, APIErrorDTO(error: .internal))
        }
    }
}
