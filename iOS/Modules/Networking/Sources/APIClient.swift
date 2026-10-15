import Foundation
import Shared

/// Errors of the network layer.
public enum APIError: Error, Equatable, Sendable {
    /// No token, or the server said 401. The user must log in again.
    case unauthorized
    /// The server answered with an error code from `Shared.APIErrorCode`.
    case server(APIErrorCode, status: Int)
    /// No connection, timeout, and so on.
    case transport
    /// The response did not match the expected type.
    case decoding
}

/// The only thing the rest of the app needs from the network.
/// A protocol, so tests and previews can use `MockAPIClient`.
public protocol APIClient: Sendable {
    func send<Response>(_ endpoint: Endpoint<Response>) async throws(APIError) -> Response
}

/// The real client on top of `URLSession` and async/await.
///
/// Compare with the old way: no completion handlers, no `DispatchQueue.main.async`.
/// `try await session.data(for:)` suspends the task until the answer comes.
public struct URLSessionAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let tokens: any TokenStore

    public init(baseURL: URL, tokens: any TokenStore, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.tokens = tokens
        self.session = session
    }

    public func send<Response>(_ endpoint: Endpoint<Response>) async throws(APIError) -> Response {
        var request = URLRequest(url: url(for: endpoint))
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if endpoint.requiresAuth {
            guard let token = await tokens.token() else { throw .unauthorized }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let result: (Data, URLResponse)
        do {
            result = try await session.data(for: request)
        } catch {
            throw .transport
        }
        let (data, response) = result

        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard (200..<300).contains(status) else {
            if status == 401 { throw .unauthorized }
            // The server sends {"error": "code"}; the UI translates the code.
            let code = (try? JSONDecoder.buzz.decode(APIErrorDTO.self, from: data))?.error ?? .unknown
            throw .server(code, status: status)
        }

        if Response.self == EmptyResponse.self, let empty = EmptyResponse() as? Response {
            return empty
        }
        do {
            return try JSONDecoder.buzz.decode(Response.self, from: data)
        } catch {
            throw .decoding
        }
    }

    private func url<R>(for endpoint: Endpoint<R>) -> URL {
        var components = URLComponents(
            url: baseURL.appending(path: endpoint.path),
            resolvingAgainstBaseURL: false
        )!
        if !endpoint.query.isEmpty { components.queryItems = endpoint.query }
        return components.url!
    }
}
