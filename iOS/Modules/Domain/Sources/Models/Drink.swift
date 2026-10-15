import Foundation

/// A drink from the catalog (for example "Red Bull Energy Drink, 250 ml").
///
/// Domain models are plain structs, not SwiftData `@Model` classes.
/// Why: structs are `Sendable` (safe to pass between threads and actors),
/// easy to create in tests and previews, and features do not depend on the database.
public struct Drink: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var brand: String
    public var name: String
    /// Standard volume of one can.
    public var volumeMl: Int
    public var caffeinePer100ml: Double
    public var sugarPer100ml: Double
    public var imageURL: URL?
    /// `true` when the user created this drink themselves.
    public var isCustom: Bool

    public init(
        id: UUID = UUID(),
        brand: String,
        name: String,
        volumeMl: Int,
        caffeinePer100ml: Double,
        sugarPer100ml: Double,
        imageURL: URL? = nil,
        isCustom: Bool = false
    ) {
        self.id = id
        self.brand = brand
        self.name = name
        self.volumeMl = volumeMl
        self.caffeinePer100ml = caffeinePer100ml
        self.sugarPer100ml = sugarPer100ml
        self.imageURL = imageURL
        self.isCustom = isCustom
    }

    /// "Red Bull Energy Drink". Brand names are never translated.
    public var displayName: String { "\(brand) \(name)" }
}
