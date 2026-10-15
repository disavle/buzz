import DesignSystem
import Domain
import SwiftUI

/// Login and registration in one small form. Plain `@State`, no architecture needed:
/// the screen is tiny and lives only while it is shown.
public struct LoginView: View {
    let auth: any AuthService
    let finished: (_ loggedIn: Bool) -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var isRegister = false
    @State private var isLoading = false
    @State private var error: AuthError?

    public init(auth: any AuthService, finished: @escaping (_ loggedIn: Bool) -> Void) {
        self.auth = auth
        self.finished = finished
    }

    private var isValid: Bool { email.contains("@") && password.count >= 8 }

    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(text: $email) { Text("login.email", bundle: .module) }
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    SecureField(text: $password) { Text("login.password", bundle: .module) }
                        .textContentType(isRegister ? .newPassword : .password)
                } footer: {
                    if let error { Text(message(for: error)).foregroundStyle(Color.buzzOver) }
                }

                Section {
                    Picker(selection: $isRegister) {
                        Text("login.mode.login", bundle: .module).tag(false)
                        Text("login.mode.register", bundle: .module).tag(true)
                    } label: {
                        EmptyView()
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle(Text("login.title", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        finished(false)
                    } label: {
                        Text("login.cancel", bundle: .module)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Button {
                            Task { await submit() }
                        } label: {
                            Text("login.submit", bundle: .module)
                        }
                        .disabled(!isValid)
                    }
                }
            }
        }
    }

    private func submit() async {
        isLoading = true
        defer { isLoading = false }
        do {
            if isRegister {
                try await auth.register(email: email, password: password)
            } else {
                try await auth.login(email: email, password: password)
            }
            finished(true)
        } catch {
            self.error = error  // typed throws: already an AuthError
        }
    }

    private func message(for error: AuthError) -> String {
        switch error {
        case .invalidCredentials: String(localized: "login.error.credentials", bundle: .module)
        case .emailTaken: String(localized: "login.error.taken", bundle: .module)
        case .emailInvalid: String(localized: "login.error.email", bundle: .module)
        case .passwordTooShort: String(localized: "login.error.password", bundle: .module)
        case .network: String(localized: "login.error.network", bundle: .module)
        case .unknown: String(localized: "login.error.unknown", bundle: .module)
        }
    }
}
