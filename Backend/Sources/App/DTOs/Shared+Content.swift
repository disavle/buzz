import Vapor
import Shared

// Shared DTOs know nothing about Vapor. Here the server teaches them to be HTTP content
// and to validate incoming data.
extension APIErrorDTO: @retroactive Content {}
extension RegisterDTO: @retroactive Content {}
extension CredentialsDTO: @retroactive Content {}
extension TokenDTO: @retroactive Content {}
extension UserDTO: @retroactive Content {}
extension UpdateMeDTO: @retroactive Content {}
extension DrinkDTO: @retroactive Content {}
extension CreateDrinkDTO: @retroactive Content {}
extension EntryDTO: @retroactive Content {}
extension CreateEntryDTO: @retroactive Content {}
extension SyncDTO: @retroactive Content {}
extension StatsDTO: @retroactive Content {}

extension RegisterDTO: @retroactive Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("locale", as: String.self, is: .in(AppLocale.allCases.map(\.rawValue)), required: false)
    }
}

extension UpdateMeDTO: @retroactive Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("dailyCaffeineLimitMg", as: Int.self, is: .range(1...2000), required: false)
        validations.add("locale", as: String.self, is: .in(AppLocale.allCases.map(\.rawValue)), required: false)
    }
}

extension CreateDrinkDTO: @retroactive Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("brand", as: String.self, is: !.empty && .count(...100))
        validations.add("name", as: String.self, is: !.empty && .count(...100))
        validations.add("volumeMl", as: Int.self, is: .range(1...5000))
        validations.add("caffeinePer100ml", as: Double.self, is: .range(0...1000))
        validations.add("sugarPer100ml", as: Double.self, is: .range(0...100))
    }
}

extension CreateEntryDTO: @retroactive Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("volumeMl", as: Int.self, is: .range(1...5000), required: false)
    }
}
