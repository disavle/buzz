// swift-tools-version: 6.0
// External dependencies of the project. Tuist fetches them with `tuist install`
// and turns them into normal Xcode targets.
import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    productTypes: [
        "Shared": .staticFramework,
    ]
)
#endif

let package = Package(
    name: "BuzzDependencies",
    dependencies: [
        // DTOs shared with the Vapor backend. The path goes from iOS/Tuist/ to the repo root.
        .package(path: "../../Shared"),
    ]
)
