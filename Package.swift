// swift-tools-version: 5.10
import PackageDescription

#if os(Linux)
let package = Package(
    name: "UVBuddy",
    products: [
        .library(name: "UVBuddyCore", targets: ["UVBuddyCore"])
    ],
    targets: [
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
)
#else
let package = Package(
    name: "UVBuddy",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "UVBuddyCore", targets: ["UVBuddyCore"]),
        .executable(name: "UVBuddy", targets: ["UVBuddy"])
    ],
    targets: [
        .target(
            name: "UVBuddyCore",
            path: "Sources/UVBuddyCore"
        ),
        .executableTarget(
            name: "UVBuddy",
            dependencies: ["UVBuddyCore"],
            path: "Sources/UVBuddy"
        ),
        .testTarget(
            name: "UVBuddyCoreTests",
            dependencies: ["UVBuddyCore"],
            path: "Tests/UVBuddyCoreTests"
        )
    ]
)
#endif
