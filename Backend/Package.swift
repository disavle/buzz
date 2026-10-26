// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "BuzzBackend",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.122.3"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.13.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.9.0"),
        // Postgres for the deployed server (Neon); SQLite stays for local runs and tests
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.14.0"),
        // DTOs shared with the iOS client
        .package(path: "../Shared"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Shared", package: "Shared"),
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "VaporTesting", package: "vapor"),
                .product(name: "Shared", package: "Shared"),
            ]
        ),
    ]
)
