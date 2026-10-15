import DesignSystem
import Domain
import SwiftUI

/// Grid of drinks with search and an "All / Mine" filter.
public struct CatalogView: View {
    @State private var model: CatalogViewModel

    public init(model: CatalogViewModel) {
        _model = State(initialValue: model)
    }

    /// `.adaptive(minimum: 150)` fits as many columns as the width allows.
    /// In UIKit this was a CompositionalLayout group where you counted columns from the width yourself.
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 12)]

    public var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Picker(selection: $model.filter) {
                    Text("catalog.filter.all", bundle: .module).tag(CatalogViewModel.Filter.all)
                    Text("catalog.filter.mine", bundle: .module).tag(CatalogViewModel.Filter.mine)
                } label: {
                    Text("catalog.filter", bundle: .module)
                }
                .pickerStyle(.segmented)

                // Lazy: cards are created only when they scroll into view, like cell reuse.
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(model.visible) { drink in
                        Button {
                            model.drinkTapped(drink)
                        } label: {
                            DrinkCard(drink: drink)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, BuzzMetrics.screenPadding)
        }
        .background(Color.buzzBackground)
        .overlay {
            if model.visible.isEmpty {
                ContentUnavailableView.search(text: model.query)
            }
        }
        // `.searchable` puts a search bar into the navigation bar (UISearchController in UIKit).
        .searchable(text: $model.query, prompt: Text("catalog.search", bundle: .module))
        // Debounce: wait 300 ms after the last key press. A new key press cancels this task.
        .task(id: model.query) {
            if !model.query.isEmpty { try? await Task.sleep(for: .milliseconds(300)) }
            guard !Task.isCancelled else { return }
            await model.load()
        }
        .navigationTitle(Text("catalog.title", bundle: .module))
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    model.addCustomTapped()
                } label: {
                    Label {
                        Text("catalog.addCustom", bundle: .module)
                    } icon: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

/// One card in the grid.
struct DrinkCard: View {
    let drink: Drink

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                BrandPalette.color(for: drink.brand)
                HStack(alignment: .bottom) {
                    Text(String(drink.brand.prefix(1)))
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                    Spacer()
                    Text(BuzzFormat.volume(drink.volumeMl))
                        .font(.caption.weight(.semibold))
                        .opacity(0.9)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .frame(height: 104)
            .clipShape(.rect(cornerRadius: 16, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(drink.displayName)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                HStack(spacing: 4) {
                    Text("catalog.per100 \(BuzzFormat.caffeine(drink.caffeinePer100ml))", bundle: .module)
                    if drink.isCustom {
                        Text("catalog.mine.badge", bundle: .module)
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 6)
            .padding(.bottom, 6)
        }
        .padding(8)
        .background(Color.buzzCard, in: .rect(cornerRadius: BuzzMetrics.gridCardRadius, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        CatalogView(
            model: CatalogViewModel(
                repository: InMemoryDrinkRepository(),
                output: .init(drinkTapped: { _ in }, addCustomTapped: {})
            )
        )
    }
    .buzzTheme()
}
