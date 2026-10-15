// swift-tools-version:6.0
import PackageDescription

// A package with no dependencies: both the iOS client and the Vapor server use it.
let package = Package(
    name: "Shared",
    platforms: [.iOS(.v17), .macOS(.v13)],
    products: [
        .library(name: "Shared", targets: ["Shared"]),
    ],
    targets: [
        .target(name: "Shared"),
    ]
)
