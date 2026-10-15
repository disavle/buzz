import Foundation

/// A drink from the catalog: shared or created by the user.
public struct DrinkDTO: Codable, Sendable, Hashable, Identifiable {
    public var id: UUID
    public var brand: String
    public var name: String
    public var volumeMl: Int
    public var caffeinePer100ml: Double
    public var sugarPer100ml: Double
    public var imageURL: URL?
    public var isCustom: Bool

    public init(
        id: UUID,
        brand: String,
        name: String,
        volumeMl: Int,
        caffeinePer100ml: Double,
        sugarPer100ml: Double,
        imageURL: URL? = nil,
        isCustom: Bool
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
}

/// Body of POST /drinks.
public struct CreateDrinkDTO: Codable, Sendable, Hashable {
    public var brand: String
    public var name: String
    public var volumeMl: Int
    public var caffeinePer100ml: Double
    public var sugarPer100ml: Double

    public init(brand: String, name: String, volumeMl: Int, caffeinePer100ml: Double, sugarPer100ml: Double) {
        self.brand = brand
        self.name = name
        self.volumeMl = volumeMl
        self.caffeinePer100ml = caffeinePer100ml
        self.sugarPer100ml = sugarPer100ml
    }
}
