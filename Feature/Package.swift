// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.macOS(.v11)],
    products: [

    ],
    dependencies: [
        .package(path: "../Infrastructure"),
        .package(path: "../Generic"),
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0")),
        .package(url: "https://github.com/Swinject/SwinjectAutoregistration.git", .upToNextMajor(from: "2.7.0")),
    ],
    targets: [
        
    ]
)
