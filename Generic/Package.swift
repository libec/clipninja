// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Generic",
    platforms: [.macOS(.v11)],
    products: [
        .library(
            name: "Generic",
            targets: ["Generic"]
        )
    ],
    dependencies: [
        .package(path: "../Infrastructure"),
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMajor(from: "2.7.0")),
    ],
    targets: [
        .target(
            name: "Generic",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration",
                "Infrastructure",
            ],
            path: "Sources"
        ),
    ]
)
