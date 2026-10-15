import DesignSystem
import Domain
import SwiftUI

/// Form for the user's own drink. The state is local (`@State`), because nobody else needs it.
/// This is the simplest SwiftUI pattern: state + form + one callback.
public struct CustomDrinkForm: View {
    let repository: any DrinkRepository
    let finished: () -> Void

    @State private var brand = ""
    @State private var name = ""
    @State private var volumeMl = 330
    @State private var caffeinePer100ml: Double = 32
    @State private var sugarPer100ml: Double = 0
    @State private var isSaving = false

    public init(repository: any DrinkRepository, finished: @escaping () -> Void) {
        self.repository = repository
        self.finished = finished
    }

    private var isValid: Bool {
        !brand.trimmingCharacters(in: .whitespaces).isEmpty
            && (50...2000).contains(volumeMl)
            && (0...100).contains(caffeinePer100ml)
            && (0...100).contains(sugarPer100ml)
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField(text: $brand) { Text("custom.brand", bundle: .module) }
                    TextField(text: $name) { Text("custom.name", bundle: .module) }
                }
                Section {
                    Stepper(value: $volumeMl, in: 50...2000, step: 10) {
                        LabeledContent {
                            Text(BuzzFormat.volume(volumeMl))
                        } label: {
                            Text("custom.volume", bundle: .module)
                        }
                    }
                    // `TextField(value:format:)` edits a number directly. No String -> Double parsing by hand.
                    LabeledContent {
                        TextField(value: $caffeinePer100ml, format: .number) { Text(verbatim: "32") }
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text("custom.caffeine", bundle: .module)
                    }
                    LabeledContent {
                        TextField(value: $sugarPer100ml, format: .number) { Text(verbatim: "0") }
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text("custom.sugar", bundle: .module)
                    }
                }
            }
            .navigationTitle(Text("custom.title", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: finished) { Text("custom.cancel", bundle: .module) }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task { await save() }
                    } label: {
                        Text("custom.save", bundle: .module)
                    }
                    .disabled(!isValid || isSaving)
                }
            }
        }
    }

    private func save() async {
        isSaving = true
        let drink = Drink(
            brand: brand.trimmingCharacters(in: .whitespaces),
            name: name.trimmingCharacters(in: .whitespaces),
            volumeMl: volumeMl,
            caffeinePer100ml: caffeinePer100ml,
            sugarPer100ml: sugarPer100ml,
            isCustom: true
        )
        try? await repository.add(drink)
        isSaving = false
        finished()
    }
}

#Preview {
    CustomDrinkForm(repository: InMemoryDrinkRepository()) {}
}
