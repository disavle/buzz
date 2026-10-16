import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Modules
// Module rules (see docs/client/architecture.md): a feature sees only Domain and DesignSystem,
// SwiftData lives only in Persistence, network and DTOs only in Networking.

let domain       = Module("Domain", tests: true)
let persistence  = Module("Persistence", dependencies: [domain.dependency], tests: true)
let networking   = Module("Networking", dependencies: [domain.dependency, .external(name: "Shared")], tests: true)
let designSystem = Module("DesignSystem", resources: true, tests: true)
// Offline sync (actor SyncEngine), see docs/client/sync.md. Features only see the SyncService protocol from Domain.
let sync = Module(
    "Sync",
    dependencies: [domain.dependency, persistence.dependency, networking.dependency, .external(name: "Shared")],
    tests: true
)

// Every feature has its own String Catalog (Resources/Localizable.xcstrings), so resources: true.
let featureDeps: [TargetDependency] = [domain.dependency, designSystem.dependency]
let today    = Module("TodayFeature", dependencies: featureDeps, resources: true, tests: true)
let addEntry = Module("AddEntryFeature", dependencies: featureDeps, resources: true, tests: true)
let catalog  = Module("CatalogFeature", dependencies: featureDeps, resources: true, tests: true)
let stats    = Module("StatsFeature", dependencies: featureDeps, resources: true, tests: true)
let settings = Module("SettingsFeature", dependencies: featureDeps, resources: true, tests: true)

let modules = [domain, persistence, networking, designSystem, sync, today, addEntry, catalog, stats, settings]

// MARK: - App

let app: Target = .target(
    name: "Buzz",
    destinations: Buzz.destinations,
    product: .app,
    bundleId: Buzz.bundleIdPrefix,
    deploymentTargets: Buzz.deploymentTargets,
    infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "$(MARKETING_VERSION)",
        "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
        // Server address baked into the build, so the app finds the server even when launched
        // from the home screen (scheme environment variables work only when run from Xcode).
        // Set TUIST_API_URL in mise.local.toml, e.g. "https://buzz.onrender.com", then `mise run generate`.
        "BuzzAPIURL": .string(Environment.apiUrl.getString(default: "http://localhost:8080")),
        "UILaunchScreen": [:],
        // Without this iOS will not show the "Language" row in the app's system settings.
        "CFBundleLocalizations": ["en", "ru"],
        // UIKit life cycle: SceneDelegate starts AppCoordinator.
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [[
                    "UISceneConfigurationName": "Default",
                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
                ]],
            ],
        ],
        // Allow plain http to localhost, so the app can talk to `mise run backend:run`.
        "NSAppTransportSecurity": ["NSAllowsLocalNetworking": true],
        // Deep link buzz://add
        "CFBundleURLTypes": [[
            "CFBundleURLName": "\(Buzz.bundleIdPrefix)",
            "CFBundleURLSchemes": ["buzz"],
        ]],
    ]),
    sources: ["App/Sources/**"],
    resources: ["App/Resources/**"],
    dependencies: modules.map(\.dependency),
    settings: .settings(base: [
        "MARKETING_VERSION": "0.1.0",
        "CURRENT_PROJECT_VERSION": "1",
        // Team ID comes from the TUIST_TEAM_ID variable (locally from mise.local.toml, in CI from a secret).
        "DEVELOPMENT_TEAM": .string(Environment.teamId.getString(default: "")),
        "CODE_SIGN_STYLE": "Automatic",
    ])
)

let appTests: Target = .target(
    name: "BuzzTests",
    destinations: Buzz.destinations,
    product: .unitTests,
    bundleId: "\(Buzz.bundleIdPrefix).Tests",
    deploymentTargets: Buzz.deploymentTargets,
    sources: ["App/Tests/**"],
    dependencies: [.target(name: "Buzz")]
)

// MARK: - Project

let testTargets = ["BuzzTests"] + modules.filter(\.hasTests).map { "\($0.name)Tests" }

let project = Project(
    name: "Buzz",
    options: .options(
        // English is the development language (keys and source strings), Russian is a translation.
        // See docs/client/localization.md.
        defaultKnownRegions: ["en", "ru"],
        developmentRegion: "en"
    ),
    settings: .settings(base: [
        "SWIFT_VERSION": "6.0",
        "SWIFT_STRICT_CONCURRENCY": "complete",
    ]),
    targets: [app, appTests] + modules.flatMap(\.targets),
    schemes: [
        // One scheme that runs all tests: fastlane uses it.
        .scheme(
            name: "Buzz",
            buildAction: .buildAction(targets: ["Buzz"]),
            testAction: .targets(testTargets.map { .testableTarget(target: .target($0)) }),
            runAction: .runAction(executable: "Buzz")
        ),
    ]
)
