import Domain
import Foundation
import Shared

// DTOs (from the Shared package) describe JSON on the wire.
// Domain models describe the app. We convert between them here, in one place,
// so a change in the API does not leak into every screen.

public extension Drink {
    init(_ dto: DrinkDTO) {
        self.init(
            id: dto.id, brand: dto.brand, name: dto.name, volumeMl: dto.volumeMl,
            caffeinePer100ml: dto.caffeinePer100ml, sugarPer100ml: dto.sugarPer100ml,
            imageURL: dto.imageURL, isCustom: dto.isCustom
        )
    }

    var createDTO: CreateDrinkDTO {
        CreateDrinkDTO(
            brand: brand, name: name, volumeMl: volumeMl,
            caffeinePer100ml: caffeinePer100ml, sugarPer100ml: sugarPer100ml
        )
    }
}

public extension Entry {
    /// `brand` and `drinkName` are not in the DTO, so we take them from the drink.
    init(_ dto: EntryDTO, drink: Drink?) {
        self.init(
            id: dto.id, drinkId: dto.drinkId,
            brand: drink?.brand ?? "", drinkName: drink?.name ?? "",
            consumedAt: dto.consumedAt, volumeMl: dto.volumeMl, price: dto.price,
            caffeineMg: dto.caffeineMg, sugarG: dto.sugarG, isSynced: true
        )
    }

    var createDTO: CreateEntryDTO {
        CreateEntryDTO(id: id, drinkId: drinkId, consumedAt: consumedAt, volumeMl: volumeMl, price: price)
    }
}
