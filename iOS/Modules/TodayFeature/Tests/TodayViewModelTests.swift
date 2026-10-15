import Domain
import Foundation
import Testing

@testable import TodayFeature

// View model tests: no UI, no database, just the fakes from Domain.

@MainActor
@Test("Totals and 'left' are calculated from today's entries")
func totals() async {
    let model = TodayViewModel.preview(entries: PreviewData.todayEntries)
    await model.onAppear()

    // Monster Ultra 500 ml (150 mg) + Burn 250 ml (80 mg) + Red Bull 250 ml (80 mg)
    #expect(model.caffeineMg == 310)
    #expect(model.leftMg == 90)
    #expect(model.isOverLimit == false)
}

@MainActor
@Test("Undo removes the can that was just added")
func undo() async throws {
    let repo = InMemoryEntryRepository()
    let model = TodayViewModel(
        store: EntryStore(repository: repo),
        settings: InMemorySettingsRepository(),
        sync: NoopSyncService(),
        output: .init(addTapped: {})
    )
    let entry = Entry.make(drink: SeedCatalog.monster, volumeMl: 500, consumedAt: .now)
    try await repo.add(entry)

    await model.showAdded(entry)
    #expect(model.snack != nil)
    #expect(model.entries.count == 1)

    await model.undoLastAdd()
    #expect(model.entries.isEmpty)
}

@MainActor
@Test("Add button goes to the coordinator through Output")
func addGoesOut() {
    var tapped = false
    let model = TodayViewModel(
        store: EntryStore(repository: InMemoryEntryRepository()),
        settings: InMemorySettingsRepository(),
        sync: NoopSyncService(),
        output: .init(addTapped: { tapped = true })
    )
    model.addTapped()
    #expect(tapped)
}
