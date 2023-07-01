// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Data",
            dependencies: []),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"]),
    ]
)
