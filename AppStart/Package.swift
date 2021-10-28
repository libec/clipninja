// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AppStart",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "AppStart",
            targets: ["AppStart"]
        ),
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
        .package(path: "../Generic"),
        .package(path: "../Feature"),
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMajor(from: "2.7.0")),
    ],
    targets: [
        .target(
            name: "AppStart",
            dependencies: [
                .product(name: "Logger", package: "Infrastructure"),
                .product(name: "InstanceProvider", package: "Infrastructure"),
                .product(name: "Clipboard", package: "Generic"),
                "Swinject",
                "SwinjectAutoregistration",
            ]
        ),
    ]
)
