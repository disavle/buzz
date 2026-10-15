import Fluent
import Foundation
import Shared

final class Drink: Model, @unchecked Sendable {
    static let schema = "drinks"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "brand")
    var brand: String

    @Field(key: "name")
    var name: String

    @Field(key: "volume_ml")
    var volumeMl: Int

    @Field(key: "caffeine_per_100ml")
    var caffeinePer100ml: Double

    @Field(key: "sugar_per_100ml")
    var sugarPer100ml: Double

    @OptionalField(key: "image_url")
    var imageURL: String?

    /// nil for the shared catalog, the user id for custom drinks.
    @OptionalParent(key: "owner_id")
    var owner: User?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {}

    init(
        id: UUID? = nil,
        brand: String,
        name: String,
        volumeMl: Int,
        caffeinePer100ml: Double,
        sugarPer100ml: Double,
        imageURL: String? = nil,
        ownerID: User.IDValue? = nil
    ) {
        self.id = id
        self.brand = brand
        self.name = name
        self.volumeMl = volumeMl
        self.caffeinePer100ml = caffeinePer100ml
        self.sugarPer100ml = sugarPer100ml
        self.imageURL = imageURL
        self.$owner.id = ownerID
    }

    func isVisible(to userID: User.IDValue) -> Bool {
        $owner.id == nil || $owner.id == userID
    }

    func toDTO() throws -> DrinkDTO {
        DrinkDTO(
            id: try requireID(),
            brand: brand,
            name: name,
            volumeMl: volumeMl,
            caffeinePer100ml: caffeinePer100ml,
            sugarPer100ml: sugarPer100ml,
            imageURL: imageURL.flatMap(URL.init(string:)),
            isCustom: $owner.id != nil
        )
    }
}

extension QueryBuilder where Model == Drink {
    /// The shared catalog plus the user's own drinks.
    func visible(to userID: User.IDValue) -> Self {
        group(.or) { or in
            or.filter(\.$owner.$id == nil)
            or.filter(\.$owner.$id == userID)
        }
    }
}
