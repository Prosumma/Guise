// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "Guise",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .watchOS(.v6),
    .tvOS(.v13),
  ],
  products: [
    .library(
      name: "Guise",
      targets: ["Guise"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/groue/Semaphore", from: "0.1.0"),
    .package(url: "https://github.com/apple/swift-collections", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "Guise",
      dependencies: [
        .product(name: "OrderedCollections", package: "swift-collections"),
        "Semaphore",
      ]
    ),
    .testTarget(
      name: "GuiseTests",
      dependencies: ["Guise"]
    ),
  ]
)
