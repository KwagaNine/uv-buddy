// swift-tools-version: 5.10
import PackageDescription

var products: [Product] = [
    .library(name: "UVBuddyCore", targets: ["UVBuddyCore"])
]

var targets: [Target] = [
    .target(
        name: "UVBuddyCore",
        path: "Sources/UVBuddyCore"
    ),
    .testTarget(
        name: "UVBuddyCoreTests",
        dependencies: ["UVBuddyCore"],
        path: "Tests/UVBuddyCoreTests"
    )
]

var supportedPlatforms: [SupportedPlatform] = []

#if !os(Linux)
products.append(
    .executable(name: "UVBuddy", targets: ["UVBuddy"])
)

targets.append(
    .executableTarget(
        name: "UVBuddy",
        dependencies: ["UVBuddyCore"],
        path: "Sources/UVBuddy"
    )
)

supportedPlatforms = [.iOS(.v17)]
#endif

let package = Package(
    name: "UVBuddy",
    platforms: supportedPlatforms.isEmpty ? nil : supportedPlatforms,
    products: products,
    targets: targets
)
