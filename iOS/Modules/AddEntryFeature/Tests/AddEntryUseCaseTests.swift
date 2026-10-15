import Domain
import Foundation
import Testing

@testable import AddEntryFeature

// The Clean Architecture payoff: rules are tested without UI and without a database.

private let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now)!

@Test("Caffeine is calculated from volume")
func nutrition() {
    let result = NutritionCalculator().nutrition(of: SeedCatalog.redBull, volumeMl: 500)
    #expect(result.caffeineMg == 160)
}

@Test(
    "Going over the limit is reported",
    arguments: [
        (existingMg: 200.0, expectedOver: false),  // 200 + 160 = 360 <= 400
        (existingMg: 300.0, expectedOver: true),  // 300 + 160 = 460 > 400
    ]
)
func overLimit(existingMg: Double, expectedOver: Bool) async throws {
    let existing = Entry(
        drinkId: UUID(),
        brand: "X",
        drinkName: "Y",
        consumedAt: noon.addingTimeInterval(-3600),
        volumeMl: 250,
        caffeineMg: existingMg,
        sugarG: 0
    )
    let sut = DefaultAddEntryUseCase(
        entries: InMemoryEntryRepository(entries: [existing]),
        settings: InMemorySettingsRepository(limit: 400),
        now: { noon }
    )

    let result = try await sut.execute(drink: SeedCatalog.redBull, volumeMl: 500, consumedAt: noon, price: nil)

    #expect(result.isOverLimit == expectedOver)
}

@Test("A date in the future is rejected")
func futureDate() async {
    let sut = DefaultAddEntryUseCase(
        entries: InMemoryEntryRepository(),
        settings: InMemorySettingsRepository(),
        now: { noon }
    )
    await #expect(throws: AddEntryError.dateInFuture) {
        try await sut.execute(
            drink: SeedCatalog.redBull,
            volumeMl: 250,
            consumedAt: noon.addingTimeInterval(3600),
            price: nil
        )
    }
}

@Test("Weird volumes are rejected", arguments: [0, 10, 5000])
func badVolume(volume: Int) async {
    let sut = DefaultAddEntryUseCase(entries: InMemoryEntryRepository(), settings: InMemorySettingsRepository())
    await #expect(throws: AddEntryError.invalidVolume) {
        try await sut.execute(drink: SeedCatalog.redBull, volumeMl: volume, consumedAt: .now, price: nil)
    }
}
