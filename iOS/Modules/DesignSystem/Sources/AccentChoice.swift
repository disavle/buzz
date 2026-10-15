import SwiftUI

/// The main color the user picks in Settings. Only the accent changes:
/// ring, buttons, active tab, chart bars. "Over limit" stays orange, sugar stays teal.
///
/// Each case has a Color Set in Assets.xcassets ("Accent/violet" ...) with light and dark values.
public enum AccentChoice: String, CaseIterable, Identifiable, Sendable {
    case violet, blue, pink, green, teal, graphite

    public static let storageKey = "accent"
    public static let `default` = AccentChoice.violet

    public var id: Self { self }

    public var color: Color { Color("Accent/\(rawValue)", bundle: .module) }

    /// Localized name for VoiceOver ("Violet" / "Фиолетовый").
    public var title: LocalizedStringResource {
        switch self {
        case .violet: LocalizedStringResource("accent.violet", bundle: .atURL(Bundle.module.bundleURL))
        case .blue: LocalizedStringResource("accent.blue", bundle: .atURL(Bundle.module.bundleURL))
        case .pink: LocalizedStringResource("accent.pink", bundle: .atURL(Bundle.module.bundleURL))
        case .green: LocalizedStringResource("accent.green", bundle: .atURL(Bundle.module.bundleURL))
        case .teal: LocalizedStringResource("accent.teal", bundle: .atURL(Bundle.module.bundleURL))
        case .graphite: LocalizedStringResource("accent.graphite", bundle: .atURL(Bundle.module.bundleURL))
        }
    }

    /// Reads the saved choice. Used by UIKit code (coordinators) that has no `@AppStorage`.
    public static var current: AccentChoice {
        UserDefaults.standard.string(forKey: storageKey).flatMap(AccentChoice.init(rawValue:)) ?? .default
    }
}

/// Applies the user's accent color as the SwiftUI tint.
/// `@AppStorage` re-renders the view when the value in UserDefaults changes,
/// so every screen updates right after the user picks a new color.
public struct BuzzTheme: ViewModifier {
    @AppStorage(AccentChoice.storageKey) private var accent: AccentChoice = .default

    public init() {}

    public func body(content: Content) -> some View {
        content.tint(accent.color)
    }
}

public extension View {
    func buzzTheme() -> some View { modifier(BuzzTheme()) }
}
