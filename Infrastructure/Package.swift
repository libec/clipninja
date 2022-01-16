// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "Logger", targets: ["Logger"]),
        .library(name: "InstanceProvider", targets: ["InstanceProvider"]),
        .library(name: "Shortcuts", targets: ["Shortcuts"])
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMajor(from: "2.7.0")),
        .package(url: "https://github.com/sindresorhus/KeyboardShortcuts", .upToNextMajor(from: "1.3.0")),
    ],
    targets: [
        .target(
            name: "Logger",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration"
            ]
        ),
        .target(
            name: "InstanceProvider",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration"
            ]
        ),
        .target(
            name: "Shortcuts",
            dependencies: [
                "KeyboardShortcuts",
                "Logger",
                "Swinject",
                "SwinjectAutoregistration"
            ]
        ),
    ]
)
