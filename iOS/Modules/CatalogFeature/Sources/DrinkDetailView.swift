import DesignSystem
import Domain
import SwiftUI

/// Drink details. Small and static, so no view model: the data comes in `init`
/// and the only action goes out as a closure. Not every screen needs MVVM.
public struct DrinkDetailView: View {
    let drink: Drink
    let drinkNow: () -> Void

    public init(drink: Drink, drinkNow: @escaping () -> Void) {
        self.drink = drink
        self.drinkNow = drinkNow
    }

    private var perCan: Double { drink.caffeinePer100ml * Double(drink.volumeMl) / 100 }
    private var sugarPerCan: Double { drink.sugarPer100ml * Double(drink.volumeMl) / 100 }

    public var body: some View {
        List {
            Section {
                HStack(spacing: 16) {
                    BrandTile(brand: drink.brand, size: 64)
                    VStack(alignment: .leading) {
                        Text(drink.brand).font(.title3.bold())
                        Text(drink.name).foregroundStyle(.secondary)
                    }
                }
            }
            Section {
                LabeledContent {
                    Text(BuzzFormat.volume(drink.volumeMl))
                } label: {
                    Text("detail.volume", bundle: .module)
                }
                LabeledContent {
                    Text(BuzzFormat.caffeine(perCan))
                } label: {
                    Text("detail.caffeinePerCan", bundle: .module)
                }
                LabeledContent {
                    Text(BuzzFormat.caffeine(drink.caffeinePer100ml))
                } label: {
                    Text("detail.caffeinePer100", bundle: .module)
                }
                LabeledContent {
                    Text(BuzzFormat.sugar(sugarPerCan))
                } label: {
                    Text("detail.sugarPerCan", bundle: .module)
                }
            }
        }
        .navigationTitle(drink.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Button(action: drinkNow) {
                Text("detail.drinkNow", bundle: .module).frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
            .padding()
        }
    }
}

#Preview {
    NavigationStack { DrinkDetailView(drink: SeedCatalog.monster) {} }
        .buzzTheme()
}
