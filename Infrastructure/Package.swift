// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Infrastructure",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "Logger", targets: ["Logger"]),
        .library(name: "InstanceProvider", targets: ["InstanceProvider"])
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMajor(from: "2.7.0")),
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
    ]
)
