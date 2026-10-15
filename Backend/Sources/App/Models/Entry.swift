import Fluent
import Foundation
import Shared

final class Entry: Model, @unchecked Sendable {
    static let schema = "entries"

    /// Set by the client, not by the database.
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "drink_id")
    var drink: Drink

    @Field(key: "consumed_at")
    var consumedAt: Date

    @Field(key: "volume_ml")
    var volumeMl: Int

    /// Price in cents (kopecks): we never store money as Double in the database.
    @OptionalField(key: "price_minor")
    var priceMinor: Int?

    @Field(key: "caffeine_mg")
    var caffeineMg: Double

    @Field(key: "sugar_g")
    var sugarG: Double

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    /// A timestamp with `on: .delete` turns on soft delete:
    /// `delete(on:)` only sets the date, and normal queries skip such rows.
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() {}

    init(id: UUID, userID: User.IDValue, drink: Drink, consumedAt: Date, volumeMl: Int, priceMinor: Int?) throws {
        self.id = id
        self.$user.id = userID
        self.$drink.id = try drink.requireID()
        self.consumedAt = consumedAt
        self.volumeMl = volumeMl
        self.priceMinor = priceMinor
        // We calculate once: editing the catalog must not change history.
        self.caffeineMg = drink.caffeinePer100ml * Double(volumeMl) / 100
        self.sugarG = drink.sugarPer100ml * Double(volumeMl) / 100
    }

    func toDTO() throws -> EntryDTO {
        EntryDTO(
            id: try requireID(),
            drinkId: $drink.id,
            consumedAt: consumedAt,
            volumeMl: volumeMl,
            price: priceMinor.map(Money.fromMinor),
            caffeineMg: caffeineMg,
            sugarG: sugarG,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }
}

enum Money {
    static func toMinor(_ amount: Decimal) -> Int {
        var value = amount * 100
        var rounded = Decimal()
        NSDecimalRound(&rounded, &value, 0, .plain)
        return NSDecimalNumber(decimal: rounded).intValue
    }

    static func fromMinor(_ minor: Int) -> Decimal {
        Decimal(minor) / 100
    }
}
