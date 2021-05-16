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
    targets: [
        .target(
            name: "SCTE35Parser",
            exclude: [
                "BitParser/BitByteData/LICENCE",
                "BitParser/BitByteData/README.md"
            ]
        ),
        .testTarget(
            name: "SCTE35ParserTests",
            dependencies: ["SCTE35Parser"]
        )
    ]
)
