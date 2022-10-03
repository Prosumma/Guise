// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Guise",
    platforms: [.macOS(.v10_15), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)],
    products: [
        .library(
            name: "Guise",
            targets: ["Guise"])
    ],
    dependencies: [
      .package(url: "https://github.com/apple/swift-atomics", from: "1.0.0"),
      .package(url: "https://github.com/apple/swift-collections", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Guise",
            dependencies: [
              .product(name: "Atomics", package: "swift-atomics"),
              .product(name: "OrderedCollections", package: "swift-collections")
            ],
            exclude: [
              "Lazy/LazyResolver+Async.swift.gyb",
              "Lazy/LazyResolver+Sync.swift.gyb",
              "Lazy/LazyTagsResolver+Async.swift.gyb",
              "Lazy/LazyTagsResolver+Sync.swift.gyb",
              "Registrar/Registrar+Async.swift.gyb",
              "Registrar/Registrar+Sync.swift.gyb",
              "Resolver/Resolver+Async.swift.gyb",
              "Resolver/Resolver+Sync.swift.gyb"
            ]),
        .testTarget(
            name: "GuiseTests",
            dependencies: ["Guise"],
            exclude: [
              "ArgumentTests.swift.gyb",
              "LazyResolverTests.swift.gyb",
              "LazyTagsResolverTests.swift.gyb"
            ]
        )
    ]
)
