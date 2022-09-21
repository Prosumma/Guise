// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Guise",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "Guise",
            targets: ["Guise"]),
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-atomics", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Guise",
            dependencies: [.product(name: "Atomics", package: "swift-atomics")]),
        .testTarget(
            name: "GuiseTests",
            dependencies: ["Guise"]),
    ]
)
