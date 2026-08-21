// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-git-standard",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Git Standard", targets: ["Git Standard"])
    ],
    targets: [
        .target(name: "Git Standard"),
        .testTarget(
            name: "Git Standard Tests",
            dependencies: ["Git Standard"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableExperimentalFeature("LifetimeDependence"),
            .enableExperimentalFeature("Lifetimes"),
                .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("LifetimeDependence"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        ]
}
