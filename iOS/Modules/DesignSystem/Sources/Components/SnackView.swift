import SwiftUI

/// What the snack shows. Plain data, so the screen's model can create it.
public struct Snack: Equatable, Identifiable, Sendable {
    public let id = UUID()
    public var title: String
    public var subtitle: String
    /// Orange subtitle and a warning haptic when the new can went over the limit.
    public var isWarning: Bool

    public init(title: String, subtitle: String, isWarning: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.isWarning = isWarning
    }
}

/// iOS has no built-in snackbar, so we make our own overlay.
/// Design: docs/design/README.md, section "Снек «банка добавлена»".
public struct SnackView: View {
    let snack: Snack
    let undo: () -> Void

    public init(snack: Snack, undo: @escaping () -> Void) {
        self.snack = snack
        self.undo = undo
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark")
                .font(.footnote.bold())
                .foregroundStyle(.black)
                .frame(width: 28, height: 28)
                .background(.tint, in: .circle)
            VStack(alignment: .leading, spacing: 1) {
                Text(snack.title).font(.subheadline.weight(.semibold))
                Text(snack.subtitle)
                    .font(.footnote)
                    .foregroundStyle(snack.isWarning ? Color.buzzOver : Color(white: 0.82))
            }
            Spacer(minLength: 0)
            Button(action: undo) {
                Text("snack.undo", bundle: .module)
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 14)
                    .frame(height: 40)
                    .background(.white.opacity(0.14), in: .capsule)
            }
            .buttonStyle(.plain)
        }
        .foregroundStyle(.white)
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .padding(.vertical, 8)
        .background(Color(white: 0.11), in: .capsule)
        .shadow(color: .black.opacity(0.25), radius: 15, y: 10)
        .padding(.horizontal, 16)
        .sensoryFeedback(snack.isWarning ? .warning : .success, trigger: snack.id)
        .onAppear {
            // Tell VoiceOver users what happened, because the snack is not focused.
            AccessibilityNotification.Announcement(snack.title).post()
        }
    }
}

public extension View {
    /// Shows a snack at the bottom and hides it after 3 seconds.
    ///
    /// `.task(id:)` restarts when `snack` changes and is cancelled when the view goes away,
    /// so a new snack resets the timer. This is a timer without `Timer` or Combine.
    func snack(_ snack: Binding<Snack?>, undo: @escaping () -> Void) -> some View {
        overlay(alignment: .bottom) {
            if let value = snack.wrappedValue {
                SnackView(snack: value) {
                    undo()
                    snack.wrappedValue = nil
                }
                .padding(.bottom, 16)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .task(id: value.id) {
                    try? await Task.sleep(for: .seconds(3))
                    guard !Task.isCancelled else { return }
                    withAnimation { snack.wrappedValue = nil }
                }
            }
        }
        .animation(.spring(duration: 0.35), value: snack.wrappedValue)
    }
}

#Preview {
    Color.buzzBackground
        .ignoresSafeArea()
        .snack(.constant(Snack(title: "Monster Ultra White", subtitle: "+150 mg · 320 / 400 mg", isWarning: false))) {}
        .buzzTheme()
}
