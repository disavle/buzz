import DesignSystem
import Domain
import SwiftUI

/// The "Today" screen: caffeine ring, three small tiles and the list of today's cans.
///
/// It is shown inside a `UIHostingController` by `TodayCoordinator` (UIKit owns navigation).
/// `.navigationTitle` and `.toolbar` still work: the hosting controller passes them
/// to its `navigationItem` when it is inside a `UINavigationController`.
public struct TodayView: View {
    /// `@State` keeps the model alive for the whole life of the view.
    /// With `@Observable` classes you use `@State`, not `@StateObject`.
    @State private var model: TodayViewModel

    public init(model: TodayViewModel) {
        _model = State(initialValue: model)
    }

    public var body: some View {
        List {
            Section {
                summary
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)

            Section {
                ForEach(model.entries) { entry in
                    EntryRow(entry: entry)
                }
                // Swipe to delete, like `tableView(_:commit:forRowAt:)` in UIKit.
                .onDelete { offsets in
                    let toDelete = offsets.map { model.entries[$0] }
                    Task { for entry in toDelete { await model.delete(entry) } }
                }
            } header: {
                Text("today.list.title", bundle: .module)
            }
        }
        .listStyle(.insetGrouped)
        .overlay {
            if model.entries.isEmpty {
                ContentUnavailableView {
                    Label {
                        Text("today.empty.title", bundle: .module)
                    } icon: {
                        Image(systemName: "bolt.slash")
                    }
                } description: {
                    Text("today.empty.subtitle", bundle: .module)
                }
                .padding(.top, 320)
            }
        }
        .navigationTitle(Text("today.title", bundle: .module))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    model.addTapped()
                } label: {
                    Label {
                        Text("today.add", bundle: .module)
                    } icon: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        // `.task` runs when the view appears and is cancelled when it disappears.
        .task { await model.onAppear() }
        .refreshable { await model.refresh() }
        .snack($model.snack) {
            Task { await model.undoLastAdd() }
        }
    }

    /// The card with the ring and the three tiles.
    private var summary: some View {
        VStack(spacing: 18) {
            Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                .font(.footnote.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            CaffeineRing(valueMg: model.caffeineMg, limitMg: Double(model.limitMg))

            // Grid with 3 equal columns. In UIKit this would be a UIStackView with .fillEqually.
            Grid(horizontalSpacing: 8) {
                GridRow {
                    MetricTile(
                        "today.metric.left",
                        value: BuzzFormat.caffeine(model.leftMg),
                        color: model.isOverLimit ? .buzzOver : .accentColor,
                        bundle: .module
                    )
                    MetricTile(
                        "today.metric.sugar",
                        value: BuzzFormat.sugar(model.sugarG),
                        color: .buzzSugar,
                        bundle: .module
                    )
                    MetricTile("today.metric.cans", value: model.entries.count.formatted(), bundle: .module)
                }
            }
        }
        .card()
    }
}

/// One row: brand tile, name, time + volume + sugar, caffeine on the right.
struct EntryRow: View {
    let entry: Entry

    var body: some View {
        HStack(spacing: 12) {
            BrandTile(brand: entry.brand)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.displayName).font(.headline)
                HStack(spacing: 5) {
                    if !entry.isSynced {
                        // Not an error, just "not sent yet", so it is gray, not orange.
                        Image(systemName: "icloud.slash")
                            .imageScale(.small)
                            .accessibilityLabel(Text("today.entry.notSynced", bundle: .module))
                    }
                    // `.formatted(date:time:)` gives "18:40" in Russian and "6:40 PM" in English.
                    Text(entry.consumedAt.formatted(date: .omitted, time: .shortened))
                    Text("·")
                    Text(BuzzFormat.volume(entry.volumeMl))
                    Text("·")
                    Text(BuzzFormat.sugar(entry.sugarG))
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            Spacer()
            Text("+" + BuzzFormat.caffeine(entry.caffeineMg))
                .font(.system(.body, design: .rounded).bold().monospacedDigit())
                .foregroundStyle(.tint)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Previews
//
// Previews use in-memory fakes from Domain, so they open instantly without a database.

#Preview("Today, ru") {
    NavigationStack {
        TodayView(model: .preview(entries: PreviewData.todayEntries))
    }
    .buzzTheme()
    .environment(\.locale, Locale(identifier: "ru"))
}

#Preview("Today, empty") {
    NavigationStack {
        TodayView(model: .preview(entries: []))
    }
    .buzzTheme()
}

extension TodayViewModel {
    static func preview(entries: [Entry]) -> TodayViewModel {
        TodayViewModel(
            store: EntryStore(repository: InMemoryEntryRepository(entries: entries)),
            settings: InMemorySettingsRepository(),
            sync: NoopSyncService(),
            output: .init(addTapped: {})
        )
    }
}
