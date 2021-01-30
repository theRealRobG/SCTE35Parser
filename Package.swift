// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SCTE35Parser",
    products: [
        .library(
            name: "SCTE35Parser",
            targets: ["SCTE35Parser"]
        )
    ],
    dependencies: [
        .package(
            name: "BitByteData",
            url: "git@github.com:tsolomko/BitByteData.git",
            .exact(Version(1, 4, 3))
        )
    ],
    targets: [
        .target(
            name: "SCTE35Parser",
            dependencies: ["BitByteData"]
        ),
        .testTarget(
            name: "SCTE35ParserTests",
            dependencies: ["SCTE35Parser"]
        )
    ]
)
