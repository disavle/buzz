import DesignSystem
import SwiftUI

/// Public entry point, the same shape as the other features:
/// dependencies in, `some View` out. Nobody outside knows it is Redux inside.
public enum SettingsModule {
    @MainActor
    public static func make(env: SettingsEnvironment) -> some View {
        let store = Store(
            initial: SettingsState(accent: AccentChoice.current),
            reducer: settingsReducer(env: env)
        )
        return SettingsView(store: store)
    }
}
