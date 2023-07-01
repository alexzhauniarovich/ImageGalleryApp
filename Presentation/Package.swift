// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presentation",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: ["Kingfisher"]),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]),
    ]
)
