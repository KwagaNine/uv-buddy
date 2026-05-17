// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "UVBuddy",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "UVBuddy", targets: ["UVBuddy"])
    ],
    targets: [
        .executableTarget(
            name: "UVBuddy",
            path: "Sources/UVBuddy"
        )
    ]
)
