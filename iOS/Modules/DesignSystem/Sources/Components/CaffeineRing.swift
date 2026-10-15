import SwiftUI

/// The progress ring on "Today": caffeine today vs the daily limit.
///
/// Built from two `Circle` shapes. The second one is cut with `.trim(from:to:)`,
/// so its length shows the progress. In UIKit this would be a `CAShapeLayer`
/// with `strokeEnd` and a `CABasicAnimation`; here animation is one modifier.
public struct CaffeineRing: View {
    let valueMg: Double
    let limitMg: Double

    public init(valueMg: Double, limitMg: Double) {
        self.valueMg = valueMg
        self.limitMg = limitMg
    }

    private var progress: Double { limitMg > 0 ? min(valueMg / limitMg, 1) : 0 }
    private var isOver: Bool { valueMg > limitMg }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(Color.buzzFill, lineWidth: BuzzMetrics.ringLine)
            Circle()
                .trim(from: 0, to: progress)
                // `.tint` is the user's accent color (see BuzzTheme).
                .stroke(isOver ? AnyShapeStyle(Color.buzzOver) : AnyShapeStyle(.tint),
                        style: StrokeStyle(lineWidth: BuzzMetrics.ringLine, lineCap: .round))
                .rotationEffect(.degrees(-90))   // start at 12 o'clock, not 3 o'clock
                .animation(.spring(duration: 0.6), value: progress)

            VStack(spacing: 2) {
                Text(valueMg, format: .number.precision(.fractionLength(0)))
                    .font(.buzzHero)
                    // The digits roll like a counter when the value changes.
                    .contentTransition(.numericText(value: valueMg))
                    .animation(.default, value: valueMg)
                Text("ring.of \(BuzzFormat.caffeine(limitMg))", bundle: .module)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: BuzzMetrics.ringSize, height: BuzzMetrics.ringSize)
        // Haptic "warning" exactly when the value goes over the limit.
        .sensoryFeedback(.warning, trigger: isOver) { _, new in new }
        // VoiceOver reads one sentence instead of separate numbers.
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("ring.a11y \(BuzzFormat.caffeine(valueMg)) \(BuzzFormat.caffeine(limitMg))", bundle: .module))
    }
}

#Preview("Under and over the limit") {
    HStack {
        CaffeineRing(valueMg: 320, limitMg: 400)
        CaffeineRing(valueMg: 480, limitMg: 400)
    }
    .scaleEffect(0.7)
    .buzzTheme()
}
