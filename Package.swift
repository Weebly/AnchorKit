// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "AnchorKit",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_12),
        .tvOS(.v9)
    ],
    products: [
        .library(name: "AnchorKit", targets: ["AnchorKit"]),
    ],
    targets: [
        .target(name: "AnchorKit", path: "AnchorKit/Source"),
        .testTarget(name: "AnchorKitTests", dependencies: ["AnchorKit"], path: "AnchorKitTests"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)