// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "ClipNinja",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "ClipNinja",
            targets: ["ClipNinja"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMajor(from: "2.7.0")),
        .package(url: "https://github.com/sindresorhus/KeyboardShortcuts", .upToNextMajor(from: "1.3.0")),
    ],
    targets: [
        .target(
            name: "ClipNinja",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration",
                "KeyboardShortcuts",
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ClipNinjaTests",
            dependencies: ["ClipNinja"],
            path: "Tests"
        ),
    ]
)
