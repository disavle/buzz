import SwiftUI

/// A small tile under the ring: a caption and a big number ("Left 80 mg").
public struct MetricTile: View {
    let title: LocalizedStringKey
    let value: String
    let color: Color?
    let bundle: Bundle?

    /// - Parameter bundle: the bundle of the String Catalog with `title`.
    ///   Each feature module passes `.module`, because the key lives in *its* catalog.
    public init(_ title: LocalizedStringKey, value: String, color: Color? = nil, bundle: Bundle? = nil) {
        self.title = title
        self.value = value
        self.color = color
        self.bundle = bundle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title, bundle: bundle)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.buzzNumber)
                .foregroundStyle(color.map(AnyShapeStyle.init) ?? AnyShapeStyle(.primary))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.buzzBackground, in: .rect(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}
