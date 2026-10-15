import DesignSystem
import Domain
import SwiftUI

/// The view only reads `store.state` and sends actions. No logic here.
struct SettingsView: View {
    @State var store: Store<SettingsState, SettingsAction>

    var body: some View {
        Form {
            profile
            accent
            limit
            sync
            app
        }
        .navigationTitle(Text("settings.title", bundle: .module))
        .task { store.send(.onAppear) }
        .onDisappear { store.cancelEffects() }
        .alert(
            Text(store.state.alert.map(title(for:)) ?? ""),
            isPresented: Binding(
                get: { store.state.alert != nil },
                set: { if !$0 { store.send(.alertDismissed) } }
            )
        ) {}
    }

    // MARK: - Sections

    private var profile: some View {
        Section {
            switch store.state.account {
            case .guest:
                Button { store.send(.loginTapped) } label: {
                    Label { Text("settings.login", bundle: .module) } icon: { Image(systemName: "person.crop.circle") }
                }
            case .loggedIn(let email):
                HStack(spacing: 12) {
                    Text(String(email.prefix(1)).uppercased())
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .frame(width: 52, height: 52)
                        .background(.tint, in: .circle)
                    VStack(alignment: .leading) {
                        Text(email).font(.headline)
                        Text(statusText).font(.footnote).foregroundStyle(.secondary)
                    }
                }
                Button(role: .destructive) { store.send(.logoutTapped) } label: {
                    Text("settings.logout", bundle: .module)
                }
            }
        }
    }

    private var accent: some View {
        Section {
            HStack {
                ForEach(AccentChoice.allCases) { choice in
                    Button { store.send(.accentPicked(choice)) } label: {
                        Circle()
                            .fill(choice.color)
                            .frame(width: 32, height: 32)
                            .overlay {
                                if store.state.accent == choice {
                                    Image(systemName: "checkmark").font(.caption.bold()).foregroundStyle(.white)
                                }
                            }
                            .padding(4)
                            .overlay(Circle().strokeBorder(store.state.accent == choice ? choice.color : .clear, lineWidth: 3))
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel(Text(choice.title))
                    .accessibilityAddTraits(store.state.accent == choice ? .isSelected : [])
                }
            }
        } header: {
            Text("settings.accent", bundle: .module)
        } footer: {
            Text("settings.accent.footer", bundle: .module)
        }
    }

    private var limit: some View {
        Section {
            Stepper(
                value: store.binding(\.dailyLimitMg, send: SettingsAction.limitChanged),
                in: SettingsState.limitRange,
                step: SettingsState.limitStep
            ) {
                Text(BuzzFormat.caffeine(Double(store.state.dailyLimitMg))).monospacedDigit()
            }
        } header: {
            Text("settings.limit", bundle: .module)
        } footer: {
            Text("settings.limit.footer", bundle: .module)
        }
    }

    private var sync: some View {
        Section {
            LabeledContent { Text(statusText) } label: { Text("settings.sync.last", bundle: .module) }
            LabeledContent {
                Text(store.state.pendingCount.formatted()).monospacedDigit()
            } label: {
                Text("settings.sync.pending", bundle: .module)
            }
            Button { store.send(.syncTapped) } label: {
                HStack {
                    Text("settings.sync.now", bundle: .module)
                    Spacer()
                    if store.state.sync == .syncing { ProgressView() }
                }
            }
            .disabled(store.state.account == .guest)
        } header: {
            Text("settings.sync", bundle: .module)
        }
    }

    private var app: some View {
        Section {
            Button { store.send(.languageTapped) } label: {
                LabeledContent {
                    Text(currentLanguage)
                } label: {
                    Text("settings.language", bundle: .module).foregroundStyle(.primary)
                }
            }
            LabeledContent {
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "–")
            } label: {
                Text("settings.version", bundle: .module)
            }
        } header: {
            Text("settings.app", bundle: .module)
        }
    }

    // MARK: - Text helpers (translation happens in the view, not in the reducer)

    private var statusText: String {
        switch store.state.sync {
        case .idle(let date?): String(localized: "settings.sync.at \(date.formatted(.relative(presentation: .named)))", bundle: .module)
        case .idle(nil): String(localized: "settings.sync.never", bundle: .module)
        case .syncing: String(localized: "settings.sync.running", bundle: .module)
        case .failed: String(localized: "settings.sync.failed", bundle: .module)
        case .offlineGuest: String(localized: "settings.sync.guest", bundle: .module)
        case .needsLogin: String(localized: "settings.sync.needsLogin", bundle: .module)
        }
    }

    private func title(for alert: SettingsAlert) -> String {
        switch alert {
        case .syncFailed: String(localized: "settings.alert.syncFailed", bundle: .module)
        case .loggedOut: String(localized: "settings.alert.loggedOut", bundle: .module)
        }
    }

    /// "English" / "Русский", from the language the app actually runs in.
    private var currentLanguage: String {
        let code = Bundle.main.preferredLocalizations.first ?? "en"
        return Locale.current.localizedString(forLanguageCode: code)?.capitalized ?? code
    }
}

#Preview("Logged in") {
    NavigationStack {
        SettingsView(store: Store(
            initial: SettingsState(account: .loggedIn(email: "dima@buzz.app"), sync: .idle(lastSync: .now.addingTimeInterval(-300)), pendingCount: 1),
            reducer: { _, _ in .none }   // a reducer that does nothing: perfect for a static preview
        ))
    }
    .buzzTheme()
}
