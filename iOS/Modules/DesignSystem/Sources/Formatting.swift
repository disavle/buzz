import Foundation

// Numbers with units are always formatted with `FormatStyle`, never glued by hand
// like "\(value) mg". The format style knows the language: "160 мг" in Russian, "160 mg" in English.
// More in docs/client/localization.md, section 4.

public enum BuzzFormat {
    /// "160 mg" / "160 мг"
    public static func caffeine(_ mg: Double, locale: Locale = .current) -> String {
        Measurement(value: mg.rounded(), unit: UnitMass.milligrams)
            .formatted(
                .measurement(
                    width: .abbreviated,
                    usage: .asProvided,
                    numberFormatStyle: .number.precision(.fractionLength(0))
                )
                .locale(locale)
            )
    }

    /// "27 g" / "27 г"
    public static func sugar(_ grams: Double, locale: Locale = .current) -> String {
        Measurement(value: grams.rounded(), unit: UnitMass.grams)
            .formatted(
                .measurement(
                    width: .abbreviated,
                    usage: .asProvided,
                    numberFormatStyle: .number.precision(.fractionLength(0))
                )
                .locale(locale)
            )
    }

    /// "500 ml" / "500 мл". `usage: .asProvided` stops iOS from turning ml into fl oz in the US.
    public static func volume(_ ml: Int, locale: Locale = .current) -> String {
        Measurement(value: Double(ml), unit: UnitVolume.milliliters)
            .formatted(.measurement(width: .abbreviated, usage: .asProvided).locale(locale))
    }

    /// Money in the device currency: "129 ₽" / "$1.99".
    public static func money(_ value: Decimal, locale: Locale = .current) -> String {
        value.formatted(.currency(code: locale.currency?.identifier ?? "USD").locale(locale))
    }

    /// The currency code of the device, for `TextField(value:format:)`.
    public static var currencyCode: String { Locale.current.currency?.identifier ?? "USD" }
}
