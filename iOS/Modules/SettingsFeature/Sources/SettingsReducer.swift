import Domain
import Foundation

/// The whole "scenario" of the screen in one `switch`.
/// New behavior = a new case in `SettingsAction` + a branch here. The compiler shows what is missing.
public func settingsReducer(env: SettingsEnvironment) -> Reducer<SettingsState, SettingsAction> {
    { state, action in
        switch action {
        case .onAppear:
            // Two effects in one: load once, then keep listening to the sync status.
            return .run { send in
                let loaded = await env.load()
                await send(.loaded(limit: loaded.limit, email: loaded.email, pending: loaded.pending))
                for await status in env.syncStatus() {
                    await send(.syncStatusChanged(status))
                }
            }

        case .loaded(let limit, let email, let pending):
            state.dailyLimitMg = limit
            state.account = email.map { .loggedIn(email: $0) } ?? .guest
            state.pendingCount = pending
            return .none

        case .limitChanged(let value):
            // Clamp in the reducer: the rule lives in one place, not in every control.
            state.dailyLimitMg = min(
                max(value, SettingsState.limitRange.lowerBound),
                SettingsState.limitRange.upperBound
            )
            let limit = state.dailyLimitMg
            return .run { _ in await env.saveLimit(limit) }

        case .accentPicked(let accent):
            state.accent = accent
            return .run { _ in await env.saveAccent(accent) }

        case .syncTapped:
            guard state.sync != .syncing, case .loggedIn = state.account else { return .none }
            state.sync = .syncing
            return .run { send in
                await env.syncNow()
                let loaded = await env.load()
                await send(.loaded(limit: loaded.limit, email: loaded.email, pending: loaded.pending))
            }

        case .syncStatusChanged(let status):
            // Show an alert only when the user is waiting for the result.
            if status == .failed, state.sync == .syncing { state.alert = .syncFailed }
            state.sync = status
            return .none

        case .loginTapped:
            return .run { _ in await env.openLogin() }

        case .logoutTapped:
            return .run { send in
                await env.logout()
                await send(.loggedOut)
            }

        case .loggedOut:
            state.account = .guest
            state.sync = .offlineGuest
            state.alert = .loggedOut
            return .none

        case .languageTapped:
            // iOS shows the language picker on the app's page in system Settings.
            return .run { _ in await env.openSystemSettings() }

        case .alertDismissed:
            state.alert = nil
            return .none
        }
    }
}
