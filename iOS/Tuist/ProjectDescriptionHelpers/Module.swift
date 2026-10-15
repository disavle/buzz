import ProjectDescription

// Shared project constants.
public enum Buzz {
    public static let bundleIdPrefix = "com.disavle.buzz"
    public static let destinations: Destinations = [.iPhone]
    public static let deploymentTargets: DeploymentTargets = .iOS("18.0")
}

/// Describes one module: it produces a framework target and (optionally) a test target.
/// New module = one line in Project.swift + a folder Modules/<Name>/Sources.
public struct Module {
    public let name: String
    public let dependencies: [TargetDependency]
    public let hasResources: Bool
    public let hasTests: Bool

    public init(
        _ name: String,
        dependencies: [TargetDependency] = [],
        resources: Bool = false,
        tests: Bool = false
    ) {
        self.name = name
        self.dependencies = dependencies
        self.hasResources = resources
        self.hasTests = tests
    }

    public var dependency: TargetDependency { .target(name: name) }

    public var targets: [Target] {
        var result: [Target] = [
            .target(
                name: name,
                destinations: Buzz.destinations,
                product: .staticFramework,
                bundleId: "\(Buzz.bundleIdPrefix).\(name)",
                deploymentTargets: Buzz.deploymentTargets,
                sources: ["Modules/\(name)/Sources/**"],
                resources: hasResources ? ["Modules/\(name)/Resources/**"] : nil,
                dependencies: dependencies
            ),
        ]
        if hasTests {
            result.append(
                .target(
                    name: "\(name)Tests",
                    destinations: Buzz.destinations,
                    product: .unitTests,
                    bundleId: "\(Buzz.bundleIdPrefix).\(name)Tests",
                    deploymentTargets: Buzz.deploymentTargets,
                    sources: ["Modules/\(name)/Tests/**"],
                    dependencies: [.target(name: name)]
                )
            )
        }
        return result
    }
}
