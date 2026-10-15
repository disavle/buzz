import Domain
import Foundation
import Testing

@testable import SettingsFeature

// The reducer is a pure function, so most tests do not need async at all:
// make a state, apply an action, check the new state.

@Test("Limit is clamped to the allowed range", arguments: [(5000, 1000), (0, 50), (450, 450)])
func limitIsClamped(input: Int, expected: Int) {
    var state = SettingsState()
    _ = settingsReducer(env: .noop)(&state, .limitChanged(input))
    #expect(state.dailyLimitMg == expected)
}

@Test("Sync is ignored for a guest")
func syncIgnoredForGuest() {
    var state = SettingsState(account: .guest)
    _ = settingsReducer(env: .noop)(&state, .syncTapped)
    #expect(state.sync == .offlineGuest)
}

@Test("A failed sync the user asked for shows an alert")
func syncFailureShowsAlert() {
    var state = SettingsState(account: .loggedIn(email: "a@b.c"), sync: .syncing)
    _ = settingsReducer(env: .noop)(&state, .syncStatusChanged(.failed))
    #expect(state.sync == .failed)
    #expect(state.alert == .syncFailed)
}

@Test("Loaded data fills the state")
func loaded() {
    var state = SettingsState()
    _ = settingsReducer(env: .noop)(&state, .loaded(limit: 300, email: "me@buzz.app", pending: 2))
    #expect(state == SettingsState(dailyLimitMg: 300, account: .loggedIn(email: "me@buzz.app"), pendingCount: 2))
}

@MainActor
@Test("Logout runs the effect and returns to guest")
func logout() async throws {
    var env = SettingsEnvironment.noop
    env.logout = {}
    let store = Store(initial: SettingsState(account: .loggedIn(email: "a@b.c")), reducer: settingsReducer(env: env))

    store.send(.logoutTapped)
    // The effect runs in a Task. Give it a moment to finish.
    try await Task.sleep(for: .milliseconds(100))

    #expect(store.state.account == .guest)
}
