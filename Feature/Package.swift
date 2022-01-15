// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "Clipboard",
            targets: ["Clipboard"]
        ),
        .library(
            name: "Settings",
            targets: ["Settings"]
        ),
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
        .package(path: "../Generic"),
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMajor(from: "2.7.0")),
    ],
    targets: [
        .target(
            name: "Clipboard",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration",
                .product(name: "Navigation", package: "Infrastructure")
            ]
        ),
        .testTarget(
            name: "ClipboardTests",
            dependencies: ["Clipboard"]
        ),
        .target(
            name: "Settings",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration"
            ]
        )
    ]
)
