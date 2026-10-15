import SwiftUI

// Design tokens from docs/design/README.md.
//
// Rule: take everything the system already has (backgrounds, text colors, separators,
// tab bar, segmented control, search, sheets). Then dark mode, Dynamic Type and
// Liquid Glass on iOS 26 just work. We have only a few own colors, all in Assets.xcassets
// as Color Sets with "Any" and "Dark" variants.

public extension Color {
    /// Over the daily limit. Orange, not red: people with color blindness tell
    /// violet and orange apart much better than green and red.
    static let buzzOver = Color("BuzzOver", bundle: .module)
    /// Sugar is always teal.
    static let buzzSugar = Color("BuzzSugar", bundle: .module)
    /// Screen background and card background (system colors, they adapt to dark mode).
    static let buzzBackground = Color(.systemGroupedBackground)
    static let buzzCard = Color(.secondarySystemGroupedBackground)
    static let buzzFill = Color(.tertiarySystemFill)
}

public extension Font {
    /// The big number inside the ring. `.monospacedDigit()` keeps digits the same width,
    /// so the number does not "jump" during `.contentTransition(.numericText())`.
    static let buzzHero = Font.system(size: 52, weight: .bold, design: .rounded).monospacedDigit()
    /// The main number at the top of a chart card.
    static let buzzMetric = Font.system(.title, design: .rounded).bold().monospacedDigit()
    /// Numbers in small tiles and list rows.
    static let buzzNumber = Font.system(.title3, design: .rounded).bold().monospacedDigit()
}

public enum BuzzMetrics {
    public static let cardRadius: CGFloat = 26
    public static let gridCardRadius: CGFloat = 22
    public static let screenPadding: CGFloat = 16
    public static let ringSize: CGFloat = 210
    public static let ringLine: CGFloat = 20
}

/// White rounded card on the grouped background.
/// A `ViewModifier` is the SwiftUI way to reuse a group of modifiers.
public struct CardBackground: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.buzzCard, in: .rect(cornerRadius: BuzzMetrics.cardRadius, style: .continuous))
    }
}

public extension View {
    /// `Text("Hi").card()` instead of `.modifier(CardBackground())`.
    func card() -> some View { modifier(CardBackground()) }
}
