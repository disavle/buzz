import Foundation
import Testing

@testable import DesignSystem

@Test("Brand color is stable: the same brand gets the same tile color every launch")
func brandColorIsStable() {
    #expect(BrandPalette.index(for: "Red Bull") == BrandPalette.index(for: "Red Bull"))
    #expect((0..<6).contains(BrandPalette.index(for: "Monster")))
}

// Parameterized test: one function, many inputs.
// We check `contains`, not `==`: the formatter puts a non-breaking space between
// the number and the unit, which is hard to see in source code.
@Test(
    "Caffeine is formatted for each language",
    arguments: [
        ("en_US", "mg"),
        ("ru_RU", "мг"),
    ]
)
func caffeineFormat(localeId: String, unit: String) {
    let text = BuzzFormat.caffeine(160, locale: Locale(identifier: localeId))
    #expect(text.hasPrefix("160"))
    #expect(text.hasSuffix(unit))
}
