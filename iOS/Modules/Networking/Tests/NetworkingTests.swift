import Domain
import Foundation
import Shared
import Testing

@testable import Networking

@Test("POST /entries with the same id twice does not create a duplicate")
func idempotentCreate() async throws {
    let api = MockAPIClient()
    let entry = Entry.make(drink: SeedCatalog.redBull, volumeMl: 250, consumedAt: .now)

    _ = try await api.send(.createEntry(entry.createDTO))
    _ = try await api.send(.createEntry(entry.createDTO))

    let sync = try await api.send(.sync(since: nil))
    #expect(sync.entries.count == 1)
    #expect(sync.entries.first?.caffeineMg == 80)
}

@Test("Login saves the token")
func loginSavesToken() async throws {
    let tokens = InMemoryTokenStore()
    let auth = RemoteAuthService(api: MockAPIClient(), tokens: tokens)
    try await auth.login(email: "me@buzz.app", password: "12345678")
    #expect(await tokens.token() == "mock-token")
    #expect(await auth.currentEmail() == "me@buzz.app")
}

@Test("Network failure becomes AuthError.network")
func loginOffline() async {
    let auth = RemoteAuthService(api: MockAPIClient(failure: .transport), tokens: InMemoryTokenStore())
    await #expect(throws: AuthError.network) {
        try await auth.login(email: "me@buzz.app", password: "12345678")
    }
}

@Test("Unknown error codes from a newer server decode as .unknown")
func unknownErrorCode() throws {
    let json = Data(#"{"error": "something_new"}"#.utf8)
    let dto = try JSONDecoder.buzz.decode(APIErrorDTO.self, from: json)
    #expect(dto.error == .unknown)
}
