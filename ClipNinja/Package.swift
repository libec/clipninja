// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "ClipNinjaPackage",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "ClipNinjaPackage",
            targets: ["ClipNinjaPackage"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.2")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMajor(from: "2.8.1"))
    ],
    targets: [
        .target(
            name: "ClipNinjaPackage",
            dependencies: [
                "Swinject",
                "SwinjectAutoregistration"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ClipNinjaPackageTests",
            dependencies: ["ClipNinjaPackage"],
            path: "Tests"
        )
    ]
)
