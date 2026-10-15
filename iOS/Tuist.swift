import ProjectDescription

// Global Tuist configuration.
let tuist = Tuist(
    project: .tuist(
        // When you pick your Xcode version, pin it: .upToNextMajor("26.0")
        compatibleXcodeVersions: .all,
        swiftVersion: "6.0"
    )
)
