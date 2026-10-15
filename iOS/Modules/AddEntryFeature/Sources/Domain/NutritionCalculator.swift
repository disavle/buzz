import Domain
import Foundation

// This module uses Clean Architecture (docs/client/architecture-experiments.md, section 1).
//
//   Presentation (SwiftUI, @Observable)  ->  Domain (use cases, pure Swift)  ->  repositories (protocols)
//
// Dependencies point inward only. Files in this `Domain/` folder import only Foundation
// and the shared Domain module: no SwiftUI, no SwiftData. That is why they are easy to test.

/// A pure function: same input, same output, no side effects. The easiest thing to test.
public struct NutritionCalculator: Sendable {
    public init() {}

    public func nutrition(of drink: Drink, volumeMl: Int) -> (caffeineMg: Double, sugarG: Double) {
        let factor = Double(volumeMl) / 100
        return (drink.caffeinePer100ml * factor, drink.sugarPer100ml * factor)
    }
}

/// Validation errors. No user-facing text here: Presentation translates them.
public enum AddEntryError: Error, Equatable, Sendable {
    case invalidVolume
    case invalidPrice
    case dateInFuture
    case storage
}

public struct AddEntryResult: Sendable, Equatable {
    public let entry: Entry
    public let dayTotalMg: Double
    public let limitMg: Int
    /// The view model decides whether to warn the user.
    public var isOverLimit: Bool { dayTotalMg > Double(limitMg) }
}
