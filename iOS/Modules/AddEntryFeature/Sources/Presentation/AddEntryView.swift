import DesignSystem
import Domain
import SwiftUI

/// The "Add a can" sheet: recent drinks, search, the selected drink with volume/time/price,
/// a warning if the limit will be exceeded, and the main button.
struct AddEntryView: View {
    @State var model: AddEntryViewModel

    var body: some View {
        // This sheet has its own small NavigationStack only for the title bar and the
        // Cancel button. It never pushes screens, so it does not fight the coordinators.
        NavigationStack {
            Form {
                if !model.recent.isEmpty {
                    Section {
                        recentStrip
                    } header: {
                        Text("add.recent", bundle: .module)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }

                if let drink = model.selected {
                    selectedSection(drink)
                    if model.willExceedLimit { warning }
                } else {
                    searchResults
                }
            }
            .searchable(text: $model.query, prompt: Text("add.search", bundle: .module))
            // Debounce without Combine: `.task(id:)` restarts on every change of `query`
            // and cancels the previous run. If the user keeps typing, the sleep is cancelled.
            .task(id: model.query) {
                try? await Task.sleep(for: .milliseconds(250))
                guard !Task.isCancelled else { return }
                await model.queryChanged()
            }
            .navigationTitle(Text("add.title", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { model.cancelTapped() } label: { Text("add.cancel", bundle: .module) }
                }
            }
            .safeAreaInset(edge: .bottom) { saveButton }
            .task { await model.onAppear() }
            .alert(isPresented: Binding(get: { model.error != nil }, set: { if !$0 { model.error = nil } }),
                   error: model.error.map(LocalizedAddEntryError.init)) {}
        }
    }

    // MARK: - Parts

    private var recentStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(model.recent) { drink in
                    Button { model.select(drink) } label: {
                        VStack(spacing: 6) {
                            BrandTile(brand: drink.brand, size: 40)
                            Text(drink.brand).font(.caption.weight(.medium)).lineLimit(2)
                        }
                        .frame(width: 78)
                        .padding(.vertical, 10)
                        .background(Color.buzzCard, in: .rect(cornerRadius: 18, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(model.selected?.id == drink.id ? Color.accentColor : .clear, lineWidth: 2)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private var searchResults: some View {
        Section {
            ForEach(model.results) { drink in
                Button { model.select(drink) } label: {
                    HStack(spacing: 12) {
                        BrandTile(brand: drink.brand, size: 40)
                        VStack(alignment: .leading) {
                            Text(drink.displayName).font(.headline)
                            Text("add.per100 \(BuzzFormat.caffeine(drink.caffeinePer100ml))", bundle: .module)
                                .font(.footnote).foregroundStyle(.secondary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func selectedSection(_ drink: Drink) -> some View {
        Section {
            HStack(spacing: 12) {
                BrandTile(brand: drink.brand, size: 52)
                VStack(alignment: .leading, spacing: 2) {
                    Text(drink.displayName).font(.headline)
                    Text("add.per100 \(BuzzFormat.caffeine(drink.caffeinePer100ml))", bundle: .module)
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Spacer()
                Button { model.clearSelection() } label: { Text("add.change", bundle: .module) }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.small)
            }

            // Segmented control = Picker with .segmented style (UISegmentedControl in UIKit).
            Picker(selection: $model.preset) {
                Text(verbatim: "250").tag(AddEntryViewModel.VolumePreset.ml250)
                Text(verbatim: "330").tag(AddEntryViewModel.VolumePreset.ml330)
                Text(verbatim: "500").tag(AddEntryViewModel.VolumePreset.ml500)
                Text("add.volume.custom", bundle: .module).tag(AddEntryViewModel.VolumePreset.custom)
            } label: {
                Text("add.volume", bundle: .module)
            }
            .pickerStyle(.segmented)

            if model.preset == .custom {
                Stepper(value: $model.customVolumeMl, in: 50...2000, step: 10) {
                    Text(BuzzFormat.volume(model.customVolumeMl))
                }
            }

            DatePicker(selection: $model.consumedAt, in: ...Date.now) {
                Text("add.time", bundle: .module)
            }

            LabeledContent {
                // The format parses "129,90" or "129.90" depending on the locale. No string hacks.
                TextField(value: $model.price, format: .currency(code: BuzzFormat.currencyCode)) {
                    Text("add.price.placeholder", bundle: .module)
                }
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
            } label: {
                Text("add.price", bundle: .module)
            }
        }
    }

    private var warning: some View {
        Section {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text("add.warning.title \(BuzzFormat.caffeine(model.previewMg))", bundle: .module)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.buzzOver)
                    Text("add.warning.subtitle \(BuzzFormat.caffeine(model.projectedTotalMg)) \(BuzzFormat.caffeine(Double(model.limitMg)))", bundle: .module)
                        .font(.footnote)
                }
            } icon: {
                Image(systemName: "exclamationmark.triangle").foregroundStyle(Color.buzzOver)
            }
        }
    }

    private var saveButton: some View {
        Button {
            Task { await model.saveTapped() }
        } label: {
            Text("add.save \(BuzzFormat.caffeine(model.previewMg))", bundle: .module)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .disabled(!model.canSave)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

/// Wraps the domain error so `.alert(error:)` can show a translated message.
/// The Domain layer has no text; translation happens here, in Presentation.
struct LocalizedAddEntryError: LocalizedError {
    let error: AddEntryError

    var errorDescription: String? {
        switch error {
        case .invalidVolume: String(localized: "add.error.volume", bundle: .module)
        case .invalidPrice: String(localized: "add.error.price", bundle: .module)
        case .dateInFuture: String(localized: "add.error.future", bundle: .module)
        case .storage: String(localized: "add.error.storage", bundle: .module)
        }
    }
}

#Preview {
    Color.gray.sheet(isPresented: .constant(true)) {
        AddEntryModule.make(
            deps: AddEntryDependencies(
                entries: InMemoryEntryRepository(entries: PreviewData.todayEntries),
                drinks: InMemoryDrinkRepository(),
                settings: InMemorySettingsRepository()
            ),
            output: AddEntryOutput(finished: { _ in }, cancelled: {})
        )
        .presentationDetents([.large])
    }
    .buzzTheme()
}
