// swift-tools-version:5.0
//
//  Package.swift
//  Guise
//
//  Created by Gregory Higley on 6/8/19.
//  Copyright © 2019 Gregory Higley. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "Guise",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "Guise",
            targets: ["Guise"])
    ],
    targets: [
        .target(
            name: "Guise",
            path: "Guise"),
        .testTarget(
            name: "GuiseTests",
            dependencies: ["Guise"],
            path: "GuiseTests")
    ],
    swiftLanguageVersions: [.v5]
)
